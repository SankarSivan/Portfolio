
USE [Zomato];

SELECT 
COLUMN_NAME, 
DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'Zomato_Dataset'																				-- Check Datatype of table


SELECT DISTINCT(TABLE_CATALOG),TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS										-- CHECK TABLES IN ALL THE DATABSE
SELECT * FROM INFORMATION_SCHEMA.COLUMNS

SELECT * FROM [dbo].[Zomato_Dataset]



--CHECKING FOR DUPLICATE
SELECT [RestaurantID],COUNT([RestaurantID]) FROM 
[dbo].[Zomato_Dataset]
GROUP BY [RestaurantID]
ORDER BY 2 DESC

SELECT * FROM country_code;

select distinct CountryCode FROM [dbo].[Zomato_Dataset] 


SELECT * FROM [dbo].[Zomato_Dataset]



-- COUNTRY CODE COLUMN
SELECT 
	distinct A.[CountryCode],
	B.COUNTRY
FROM [dbo].[Zomato_Dataset] A JOIN [dbo].[country_code] B
ON A.[CountryCode] = B.COUNTRY_CODE
order by a.CountryCode


ALTER TABLE [dbo].[Zomato_Dataset] ADD COUNTRY_NAME VARCHAR(50)

UPDATE [dbo].[Zomato_Dataset] SET COUNTRY_NAME = B.COUNTRY								 -- MERGING AND ADDING COUNTRY DETAILS FROM DIFFERENT TABLE THROUGH UPDATE WITH JOIN STATEMENT
FROM [dbo].[Zomato_Dataset] A JOIN [dbo].[country_code] B
ON A.[CountryCode] = B.[COUNTRY_CODE]

SELECT * FROM [dbo].[Zomato_Dataset]



--CITY COLUMN
SELECT DISTINCT [City] FROM [dbo].[Zomato_Dataset] 
WHERE CITY LIKE '%?%'																  --IDENTIFYING IF THERE ARE ANY MISS-SPELLED WORD

SELECT REPLACE(CITY,'?','i') 
FROM [Zomato_Dataset] WHERE CITY LIKE '%?%'											  --REPLACING MISS-SPELLED WORD

UPDATE [dbo].[Zomato_Dataset] SET [City]  = REPLACE(CITY,'?','i') 
					 FROM [Zomato_Dataset] WHERE CITY LIKE '%?%'	 			 -- UPDATING WITH REPLACE STRING FUNCTION

SELECT [COUNTRY_NAME], CITY, COUNT([City]) TOTAL_REST							      -- COUNTING TOTAL REST. IN EACH CITY OF PARTICULAR COUNTRY
FROM [dbo].[Zomato_Dataset]
GROUP BY [COUNTRY_NAME],CITY 
ORDER BY 1,2,3 DESC



--LOCALITY COLUMN
SELECT CITY,[Locality], COUNT([Locality]) COUNT_LOCALITY,														-- ROLLING COUNT
SUM(COUNT([Locality])) OVER(PARTITION BY [City] ORDER BY CITY,[Locality]) ROLL_COUNT
FROM [dbo].[Zomato_Dataset]
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY [Locality],CITY
ORDER BY 1,2,3 DESC



--DROP COLUMN,[Locality],[LocalityVerbose][Address]
ALTER TABLE [dbo].[Zomato_Dataset] DROP COLUMN [Address]
ALTER TABLE [dbo].[Zomato_Dataset] DROP COLUMN [LocalityVerbose] 



-- CUISINES COLUMN 
SELECT [Cuisines], COUNT([Cuisines]) FROM [dbo].[Zomato_Dataset]
WHERE [Cuisines] IS NULL OR [Cuisines] = ' '
GROUP BY [Cuisines]
ORDER BY 2 DESC

SELECT [Cuisines],COUNT([Cuisines]) as CuisinesCount
FROM [dbo].[Zomato_Dataset]
GROUP BY [Cuisines]
ORDER BY CuisinesCount ASC


-- CURRENCY COULMN
SELECT 
	[Currency], 
	COUNT([Currency]) TransactionCount 
FROM [dbo].[Zomato_Dataset]
GROUP BY [Currency]
ORDER BY 2 DESC


-- YES/NO COLUMNS
SELECT DISTINCT([Has_Table_booking]) FROM [dbo].[Zomato_Dataset]
SELECT DISTINCT([Has_Online_delivery]) FROM [dbo].[Zomato_Dataset]
SELECT DISTINCT([Is_delivering_now]) FROM [dbo].[Zomato_Dataset]
SELECT DISTINCT([Switch_to_order_menu]) FROM [dbo].[Zomato_Dataset]

-- DROP COULLMN [Switch_to_order_menu]
ALTER TABLE [dbo].[Zomato_Dataset] DROP COLUMN [Switch_to_order_menu]



-- PRICE RANGE COLUMN
SELECT DISTINCT([Price_range]) FROM [dbo].[Zomato_Dataset]



-- VOTES COLUMN (CHECKING MIN,MAX,AVG OF VOTE COLUMN)
ALTER TABLE [dbo].[Zomato_Dataset] ALTER COLUMN [Votes] INT

SELECT MIN(CAST([Votes] AS INT)) MIN_VT,AVG(CAST([Votes] AS INT)) AVG_VT,MAX(CAST([Votes] AS INT)) MAX_VT
FROM [dbo].[Zomato_Dataset]



-- COST COLUMN
ALTER TABLE [dbo].[Zomato_Dataset] ALTER COLUMN [Average_Cost_for_two] FLOAT

SELECT 
	[Currency],
	MIN(CAST([Average_Cost_for_two] AS INT)) MIN_CST,
	AVG(CAST([Average_Cost_for_two] AS INT)) AVG_CST,
	MAX(CAST([Average_Cost_for_two] AS INT)) MAX_CST
FROM [dbo].[Zomato_Dataset]
--WHERE [Currency] LIKE '%U%'
GROUP BY [Currency]



--RATING COLUMN
SELECT 
	MIN([Rating]),
	ROUND(AVG(CAST([Rating] AS DECIMAL)),1), 
	MAX([Rating])  
FROM [dbo].[Zomato_Dataset]

SELECT 
	CAST([Rating] AS decimal) NUM 
	FROM [dbo].[Zomato_Dataset] 
	WHERE CAST([Rating] AS decimal) >= 4

ALTER TABLE [dbo].[Zomato_Dataset] ALTER COLUMN [Rating] DECIMAL

SELECT 
	RATING 
FROM [dbo].[Zomato_Dataset] 
WHERE [Rating] >= 4

SELECT 
	RATING,
		CASE
			WHEN [Rating] >= 1 AND [Rating] < 2.5 THEN 'POOR'
			WHEN [Rating] >= 2.5 AND [Rating] < 3.5 THEN 'GOOD'
			WHEN [Rating] >= 3.5 AND [Rating] < 4.5 THEN 'GREAT'
			WHEN [Rating] >= 4.5 THEN 'EXCELLENT'
		END RATE_CATEGORY
FROM [dbo].[Zomato_Dataset]

ALTER TABLE [dbo].[Zomato_Dataset] ADD RATE_CATEGORY VARCHAR(20)

SELECT * FROM [dbo].[Zomato_Dataset]



--UPDATING NEW ADDED COLUMN WITH REFFERENCE OF AN EXISTING COLUMN
UPDATE [dbo].[Zomato_Dataset] 
	SET [RATE_CATEGORY] = 
		(CASE								     	-- UPDATE WITH CASE-WHEN STATEMENT
			WHEN [Rating] >= 1 AND [Rating] < 2.5 THEN 'POOR'
			WHEN [Rating] >= 2.5 AND [Rating] < 3.5 THEN 'GOOD'
			WHEN [Rating] >= 3.5 AND [Rating] < 4.5 THEN 'GREAT'
			WHEN [Rating] >= 4.5 THEN 'EXCELLENT'
		END)
