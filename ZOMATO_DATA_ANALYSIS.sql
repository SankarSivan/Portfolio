--ANALYSIS QUESTIONS
USE Zomato;


SELECT * FROM [dbo].[Zomato_Dataset]



--ROLLING/MOVING COUNT OF RESTAURANTS IN INDIAN CITIES
SELECT 
	[COUNTRY_NAME],
	[City],[Locality],
	COUNT([Locality]) TOTAL_REST,
	SUM(COUNT([Locality])) OVER(PARTITION BY [City] ORDER BY [Locality] DESC) as City_Roll_Count,
	SUM(COUNT([Locality])) OVER(PARTITION BY [Country_name] ORDER BY [Locality] DESC) as Country_Roll_Count
FROM [dbo].[Zomato_Dataset]
--WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY  [COUNTRY_NAME], [City], [Locality]
order by country_name;

--WHICH COUNTRIES AND HOW MANY RESTAURANTS WITH PERCENTAGE PROVIDES ONLINE DELIVERY OPTION
CREATE OR ALTER VIEW COUNTRY_REST
AS
(
    SELECT 
        COUNTRY_NAME, 
        COUNT(CAST([RestaurantID] AS NUMERIC)) AS REST_COUNT
    FROM [dbo].[Zomato_Dataset]
    GROUP BY [COUNTRY_NAME]
);

SELECT 
    A.[COUNTRY_NAME],
    COUNT(A.[RestaurantID]) AS TOTAL_REST, 
    ROUND(COUNT(CAST(A.[RestaurantID] AS DECIMAL)) / CAST(B.[REST_COUNT] AS DECIMAL) * 100, 2) AS PERCENTAGE_WITH_ONLINE_DELIVERY
FROM 
    [dbo].[Zomato_Dataset] A 
JOIN 
    COUNTRY_REST B ON A.[COUNTRY_NAME] = B.[COUNTRY_NAME]
WHERE 
    A.[Has_Online_delivery] = 'YES'
GROUP BY 
    A.[COUNTRY_NAME], B.REST_COUNT
ORDER BY 
    TOTAL_REST DESC;

--FINDING FROM WHICH CITY AND LOCALITY IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
WITH CT1
AS
(
SELECT [City],[Locality],COUNT([RestaurantID]) REST_COUNT
FROM [dbo].[Zomato_Dataset]
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY CITY,LOCALITY
--ORDER BY 3 DESC
)
SELECT [Locality],REST_COUNT FROM CT1 WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1)



--TYPES OF FOODS ARE AVAILABLE IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
WITH CT1
AS
(
SELECT [City],[Locality],COUNT([RestaurantID]) REST_COUNT
FROM [dbo].[Zomato_Dataset]
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY CITY,LOCALITY
--ORDER BY 3 DESC
),
CT2 AS (
SELECT [Locality],REST_COUNT FROM CT1 WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1)
),
CT3 AS (
SELECT [Locality],[Cuisines] FROM [dbo].[Zomato_Dataset]
)
SELECT  A.[Locality], B.[Cuisines]
FROM  CT2 A JOIN CT3 B
ON A.Locality = B.[Locality]

--WHICH LOCALITIES IN INDIA HAS THE LOWEST RESTAURANTS LISTED IN ZOMATO
WITH CT1 AS
(
SELECT [City],[Locality], COUNT([RestaurantID]) REST_COUNT
FROM [dbo].[Zomato_Dataset]
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY [City],[Locality]
-- ORDER BY 3 DESC
)
SELECT * FROM CT1 WHERE REST_COUNT = (SELECT MIN(REST_COUNT) FROM CT1) ORDER BY CITY

--HOW MANY RESTAURANTS OFFER TABLE BOOKING OPTION IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO

WITH CT1 AS (
    SELECT [City], [Locality], COUNT([RestaurantID]) AS REST_COUNT
    FROM [dbo].[Zomato_Dataset]
    WHERE [COUNTRY_NAME] = 'INDIA'
    GROUP BY [City], [Locality]
),
CT2 AS (
    SELECT [Locality], REST_COUNT 
    FROM CT1 
    WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1)
),
CT3 AS (
    SELECT [Locality], [Has_Table_booking] AS TABLE_BOOKING
    FROM [dbo].[Zomato_Dataset]
)
SELECT A.[Locality], COUNT(CASE WHEN A.TABLE_BOOKING = 1 THEN 1 ELSE NULL END) AS TABLE_BOOKING_OPTION
FROM CT3 A 
JOIN CT2 B ON A.[Locality] = B.[Locality]
WHERE A.TABLE_BOOKING = 1 -- Filter for 'YES' converted to bit value
GROUP BY A.[Locality];


--AVG RATING OF RESTS LOCATION WISE
SELECT 
	[COUNTRY_NAME],
	[City],
	[Locality], 
	COUNT([RestaurantID]) TOTAL_REST ,
	ROUND(AVG(CAST([Rating] AS DECIMAL)),2) as AVG_RATING
FROM [dbo].[Zomato_Dataset]
GROUP BY [COUNTRY_NAME],[City],[Locality]
ORDER BY 4 DESC



--FINDING THE BEST RESTAURANTS WITH MODRATE COST FOR TWO IN INDIA HAVING INDIAN CUISINES
SELECT *
FROM [dbo].[Zomato_Dataset]
WHERE [COUNTRY_NAME] = 'INDIA'
AND [Has_Table_booking] = 'True' -- Assuming it's a string representing boolean
AND [Has_Online_delivery] = 'True' -- Assuming it's a string representing boolean
AND [Price_range] <= 3
AND [Votes] > 1000
AND [Average_Cost_for_two] < 1000
AND [Rating] > 4
AND [Cuisines] LIKE '%INDIA%';


--FIND ALL THE RESTAURANTS THOSE WHO ARE OFFERING TABLE BOOKING OPTIONS WITH PRICE RANGE AND HAS HIGH RATING
SELECT 
	[Price_range], 
	COUNT([Has_Table_booking]) AS NO_OF_REST
FROM [dbo].[Zomato_Dataset]
WHERE [Rating] >= 4.5
AND [Has_Table_booking] = 1
GROUP BY [Price_range];
