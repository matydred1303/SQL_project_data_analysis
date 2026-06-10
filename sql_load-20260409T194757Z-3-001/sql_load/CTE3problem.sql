WITH unique_skills AS (
  SELECT 
cd.company_id,
 COUNT (DISTINCT sj.skill_id) AS skill_count
 
 FROM company_dim AS cd
 
 LEFT JOIN job_postings_fact AS jp
 ON cd.company_id = jp.company_id
 LEFT JOIN skills_job_dim AS sj
  ON sj.job_id =jp.job_id

GROUP BY
cd.company_id
),
max_salary AS (SELECT 
jp.company_id,
MAX(jp.salary_year_avg) AS highest_average_salary 
FROM job_postings_fact AS jp
WHERE
jp.job_id IN (SELECT job_id FROM skills_job_dim)
GROUP BY
jp.company_id
)
SELECT
cd.name,
unique_skills.skill_count AS unique_skills_required, 
max_salary.highest_average_salary 
FROM company_dim AS cd
LEFT JOIN unique_skills ON cd.company_id = unique_skills.company_id
LEFT JOIN max_salary ON max_salary.company_id = cd.company_id
ORDER BY
cd.name;