-- DATA CLEANING

SELECT *
FROM layoffs;

-- When we are data cleaning we usually follow a few steps:
-- 1. Remove Duplicated
-- 2. Standardize values
-- 3. Null Values or Blank Values
-- 4. Remove any columns

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;


# First let's check for duplicates using Windows Function ROW_NUMBER
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

# Create CTE & check for duplicates (row_num >1)
WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num >1;

# Check to see if random selected result is actual duplicate
-- let's just look at oda to confirm
SELECT *
FROM layoffs_staging
WHERE company = 'Casper'
;
-- it looks like these are all legitimate entries and shouldn't be deleted. We need to really look at every single row to be accurate
WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num >1;

-- let's just Double-check & confirm new CTE is duplicates, lets look at Casper to confirm
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- Now we can attempt to remove dupes

WITH duplicate_cte AS 		#
(							#
SELECT *,					#
ROW_NUMBER() OVER(			#
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions) AS row_num
FROM layoffs_staging		#
)							#
DELETE 						#
FROM duplicate_cte			# TARGET TABLE NOT UPDATEABLE *** (CANNOT UPDATE A CTE)
WHERE row_num >1;			#

-- Instead we can transfer the CTE data into a 2ns staging db, and then alter columns & delete duplicate rows
# CREATE NEW TABLE
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

#	POPULATE NEW TABLE WITH CTE
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions) AS row_num
FROM layoffs_staging;

-- FILTER TABLE FOR DUPES
SELECT *
FROM layoffs_staging2
WHERE row_num >1;

-- DELETE DUPES
DELETE
FROM layoffs_staging2
WHERE row_num >1;

-- Double CHeck output
SELECT *
FROM layoffs_staging2;
#####################################################
-- STANDARDIZING DATA
###################################################
# remove extra spaces from compant column & UPDATE 
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

# check Industry columns for NULLs, spaces, etc
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
from layoffs_staging2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging2
set industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry		# Double check results
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

# ReFormat Date
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y/')
FROM layoffs_staging2;

UPDATE layoffs_staging2
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y/');

#Convert to Date column
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
from layoffs_staging2;

####################################
# WORKING WITH NULLS & BLANK VALUES
####################################
SELECT *
from layoffs_staging2					# multiple companys have NULL reports
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
from layoffs_staging2
WHERE industry IS NULL					# multiple companies with black industry
OR industry = '' ;

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';				# determine if company has industry populated in another instance

SELECT *
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2						# combines listing of companies w/ NULL or blank & same companies populated instances
	ON t1.company = t2.company						# ** we can then use this join to UPDATE the layoffs_staging2 table
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2						# 
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';					# comapant only had 1 round of layoffs, so no other instance to determine industry from

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;				# CAN WE DELETE THESE VALUES??????       (361 rows)

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;							# DOuble check data for other items to adjust

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;