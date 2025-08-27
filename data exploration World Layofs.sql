-- data exploration

select *
from layoffs_staging2;


-- check the maximum number of peopele laid off in one day and percentage

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2; 
-- 1 represent 100% which means hundered percentage of the employees was laid off

-- check how many company lay off 100 percent employee

select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- check total laid off by comapany

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- check date laid off start till end 

select min(`date`), max(`date`)
from layoffs_staging2;

-- check the total laid off by industry

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- check by year

select year (`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 2 desc;

-- check by stage

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

-- check total laid off by month

select substring(`date`, 6,2) as `month`, sum(total_laid_off)
from layoffs_staging2
group by `month`
;

-- check total laid off by month and year

select substring(`date`, 1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `month`
order by 1 asc
;

-- check rolling sum per month

with rolling_total as
(
select substring(`date`, 1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `month`
order by 1 asc
)
select `month` , total_off, sum(total_off) over(order by `month`) as rolling_total
from rolling_total;

-- check how many people company laid off per year
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;

-- check which company laid off more people per year
-- partition it so that all of 2020 will be in a partition, all of 2021 too etc

with company_year (company, years, total_laid_off) as 
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank as (
select *, dense_rank()
over(partition by years order by total_laid_off desc) as ranking 
from company_year
where years is not null
)
select *
from company_year_rank
where ranking <=5
;

