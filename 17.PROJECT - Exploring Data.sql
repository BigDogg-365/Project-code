-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
# AND total_laid_off IS NULL		# 73 of 116 are NULL   // more than 325 of 1995 rows are NULL
ORDER BY total_laid_off DESC;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;			# 2 stands for 2nd column

SELECT MIN(`date`), MAX(`date`) 
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, SUM(percentage_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;			# Not really relevant, but shows importance of exlporation

#############################################################
-- Rolling Sum/ Progression of lay_offs by month/year
SELECT SUBSTRING(`date`, 6,2) AS 'Month', SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `Month`;			# Issue is that results dissregard YEAR of lay_off (so results show seasonal lay-offs?)

SELECT SUBSTRING(`date`, 1,7) AS 'Month', SUM(total_laid_off)	# Now we are selecting each by within each year (36 months total)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;

-- Now we use it in a CTE so we can query off of it
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1,7) AS `Month`, SUM(total_laid_off) AS Total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `Month`, Total_off, SUM(total_off) OVER(ORDER BY `Month`) AS Rolling_total
FROM Rolling_Total;

-- Rolling totals of layoffs by COMPANY per year

SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;

SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year AS
(
SELECT company, YEAR(`date`) AS `Year`, SUM(total_laid_off) AS 'Total Layoff' 
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT * 
FROM Company_Year;

-- Determine which company had the highest layoffs in each year
WITH Company_Year AS
(
SELECT company, YEAR(`date`) AS `Year`, SUM(total_laid_off) AS 'Total_Layoff' 
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER(PARTITION BY `Year` ORDER BY Total_Layoff DESC) AS Ranking
FROM Company_Year
WHERE `Year` IS NOT NULL;

-- Determine which companies had the OVERALL highest layoffs within 1 year
WITH Company_Year AS
(
SELECT company, YEAR(`date`) AS `Year`, SUM(total_laid_off) AS 'Total_Layoff' 
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER(PARTITION BY `Year` ORDER BY Total_Layoff DESC) AS Ranking
FROM Company_Year
WHERE `Year` IS NOT NULL
ORDER BY Ranking ASC;

-- FILTER Top 5 companies by OVERALL highest layoffs within 1 year
WITH Company_Year AS
(
SELECT company, YEAR(`date`) AS `Year`, SUM(total_laid_off) AS 'Total_Layoff' 
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY `Year` ORDER BY Total_Layoff DESC) AS Ranking
FROM Company_Year
WHERE `Year` IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;
