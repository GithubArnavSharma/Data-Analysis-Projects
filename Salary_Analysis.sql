/* The Database 'Salaries' will consist of one table: dbo.Salary */

USE Salaries;

/* Since the goal of the data analysis project is to observe American salaries,
remove all non-American rows */

DELETE FROM Salary
WHERE Currency != 'USD';

/* Convert the Annual_salary column from nvarchar(MAX) (due to commas) to INT */

UPDATE Salary 
SET Annual_salary = REPLACE(Annual_salary, ',', '')
WHERE Annual_salary LIKE '%,%';

ALTER TABLE Salary
ALTER COLUMN Annual_salary INT;

/* Clean the Education column */

UPDATE Salary
SET Highest_level_of_education_completed = 

CASE
	WHEN Highest_level_of_education_completed = 'Some college' THEN 'College degree'
	WHEN Highest_level_of_education_completed LIKE 'Professional%' THEN 'Professional degree'
	WHEN Highest_level_of_education_completed LIKE 'Master%' THEN 'Professional degree'
	WHEN Highest_level_of_education_completed = 'PhD' THEN 'Professional degree'
	WHEN Highest_level_of_education_completed = 'High School' THEN 'High School'
	ELSE 'Unknown'
END;

/* Clean the Race column */

UPDATE Salary
SET Race = 

CASE
	WHEN Race LIKE '%,%' THEN 'Multi Racial'
	WHEN Race LIKE 'Another option%' THEN 'Unknown'
	WHEN Race IS NULL THEN 'Unknown'
	ELSE Race
END;

/* Clean the Gender column */

UPDATE Salary
SET Gender = 

CASE
	WHEN Gender LIKE 'Other%' THEN 'Unknown'
	WHEN Gender LIKE 'Prefer%' THEN 'Unknown'
	WHEN Gender IS NULL THEN 'Unknown'
	ELSE Gender
END;

/* Clean the state column */

UPDATE Salary
SET [State] = 

CASE
	WHEN [State] LIKE '%,%' THEN 'Multiple'
	WHEN [State] IS NULL THEN 'Unknown'
	ELSE [State]
END;

/* Clean the Annual_salary column by removing outliers */ 

UPDATE Salary
SET Annual_salary = 

CASE
	WHEN Annual_salary > 1000000 THEN 1000000
	ELSE Annual_salary
END; 

/* ------------------Get info about the cities the responses are located in------------------ */

SELECT TOP 100 City, COUNT(City)
FROM Salary
GROUP BY City
ORDER BY COUNT(City) DESC;

/* Results show that the majority of responses are in medium or large sized cities */


/* ------------------Get gender pay differences------------------ */

SELECT AVG(Annual_salary), Gender
FROM Salary
GROUP BY Gender
ORDER BY AVG(Annual_salary) ASC;

/* Results show that men make an average of $117146 while women make an average of $86770.
   The lowest gender salary are non-binaries, making only $73398*/


/* ------------------Get the Industry pay differences------------------ */

SELECT Industry, AVG(Annual_salary) AS Avg_Salary
FROM Salary
GROUP BY Industry
HAVING COUNT([Timestamp]) > 100
ORDER BY AVG(Annual_salary) ASC;

/* Results show that the highest paying jobs involve Technology, law, buisness, and entertainment 
   The lowest paying jobs involve social work, retail, education, and nonprofits */


/* ------------------Get the Age pay differences------------------ */

SELECT How_old_are_you, AVG(Annual_salary) AS Avg_Salary
FROM Salary
GROUP BY How_old_are_you
HAVING Count([Timestamp]) > 100
ORDER BY AVG(Annual_salary) ASC;

/* Results show that older people have higher pay, but the pay starts to decline after reaching 45-54
   years old */ 


/* ------------------Get the Race pay differences------------------ */

SELECT Race, AVG(Annual_salary) AS Avg_Salary
FROM Salary
GROUP BY Race
HAVING Count([Timestamp]) > 100
ORDER BY AVG(Annual_salary) ASC;

/* Results show that Asian Americans have higher average pay, and all other races tend to be equal */


/* ------------------Get the Experience Years pay differences------------------ */

SELECT Years_of_experience_in_field, AVG(Annual_salary) AS Avg_Salary
FROM Salary
GROUP BY Years_of_experience_in_field
HAVING Count([Timestamp]) > 100
ORDER BY AVG(Annual_salary) ASC;

/* Results show a generally positive linear relationship between the years of experience in 
   a field and the average salary */


/* ------------------Get the Education pay differences------------------ */

SELECT Highest_level_of_education_completed, AVG(Annual_salary) AS Avg_Salary
FROM Salary
GROUP BY Highest_level_of_education_completed
HAVING Count([Timestamp]) > 100
ORDER BY AVG(Annual_salary) ASC;

/* Results show that as the amount of education increases, so does the average salary */
