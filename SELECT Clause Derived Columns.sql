-- Database Basics: Derived Columns with SELECT

-- In this video, we will be exploring the Houses table that we have been using in previous tutorials, but with more data
-- We will be using the SELECT clause to get a derived field not originally in the table
CREATE TABLE Houses (
Owner_ID VARCHAR(100),
Street VARCHAR(200),
[State] VARCHAR(200),
Price INT,
Price_Date DATE,
Years_since_construction INT,
Downpayment INT,
Years_since_renovation INT
);

INSERT INTO Houses (Owner_ID, Street, [State], Price, Price_Date, Years_since_construction, Downpayment, Years_since_renovation)
VALUES ('1', '240 Main Street', 'CA', 1900000, '2019-01-01', 18, 4000, 5), 
('1', '140 Maple Street', 'GA', 1300000, '2021-01-01', 5, 5000, NULL),
('2', '555 New Way', 'TX', 1100000, '2017-01-01', 12, 5400, 6),
('2', '14 Paradise Street', 'MO', 700000, '2020-01-01', 30, 21000, 6),
('4', '123 School Street', 'MI', 400000, '2019-01-01', 18, 67000, 8),
('1', '70 Smith Way', 'VA', 1500000, '2012-07-10', 12, 10000, 8),
('2', '230 Valley Way', 'TX', 1200000, '2007-02-08', 2, 56000, NULL),
('1', '23 King Drive', 'CA', 3300000, '2022-04-08', 5, 54000, NULL),
('3', '12 Felicity Way', 'RI', 2200000, '2017-04-12', 1, 56000, NULL),
('2', '34 Hollow Drive', 'FL', 1950000, '2019-05-29', 2, 34000, NULL),
('2', '345 Forest Drive', 'FL', 1900000, '2020-05-29', 2, 43000, NULL),
(NULL, '123 Rock Drive', 'MO', 1000000, '2016-03-29', 12, 65000, 6);

-- Now we have the following columns
-- Street is the address of the house
-- State is the U.S State in which the house is located
-- Price is the current listed price of the house
-- Price_Date is when the price was retrieved
-- Years_since_construction is how many years have passed since the house was built
-- Downpayment is the amount of money put when the house was bought
-- Years_since_renovation is how many years it has been since the house was renovated, if it was, if not, it is null

-- We will first look at the original table with a simple SELECT *
SELECT *
FROM Houses

-- Now, let's assume that we want to get a new column that takes the Downpayment and divides it by the Price
-- This will give us the percentage of downpayment compared to the price of the house
-- It can be performed by calling the column and doing the desired operation
SELECT *, 
Downpayment/Price
FROM Houses

-- You will notice that we only got 0, this is due to data types and because both values are integers
-- This can be solved in multiple ways, but for simplicity, we will just cast both values into floats, that allows decimals
SELECT *, 
CAST(Downpayment AS FLOAT)/CAST(Price AS FLOAT)
FROM Houses

-- The values are correct if we use a calculator. However, we want percentages, and preferentially, a column name as well
-- AS and ROUND can help us getting the desired result, as well as multiplying by 100 to get percentages
SELECT *, 
ROUND(CAST(Downpayment AS FLOAT)/CAST(Price AS FLOAT), 4) * 100 AS Downpayment_pct
FROM Houses

-- Now we have a column that gives us the downpayment percentage. However, because it was created in the query, we cannot filter by it directly
SELECT *, 
ROUND(CAST(Downpayment AS FLOAT)/CAST(Price AS FLOAT), 4) * 100 AS Downpayment_pct
FROM Houses
WHERE Downpayment_pct >= 1

-- This is because our new derived column is created in the query, but it is not part of the table
-- To get the houses that have more than 1% downpayment, we could call the whole formula instead in the WHERE clause
SELECT *, 
ROUND(CAST(Downpayment AS FLOAT)/CAST(Price AS FLOAT), 4) * 100 AS Downpayment_pct
FROM Houses
WHERE ROUND(CAST(Downpayment AS FLOAT)/CAST(Price AS FLOAT), 4) * 100 >= 1

-- A more powerful alternative, more so with long queries, is using either a subquery or a Common Table Expression (CTE)
SELECT *
FROM 
	(
	SELECT *, 
	ROUND(CAST(Downpayment AS FLOAT)/CAST(Price AS FLOAT), 4) * 100 AS Downpayment_pct
	FROM Houses
	) Houses_pct
WHERE Downpayment_pct >= 1

-- Or, written as  a CTE
WITH Houses_pct AS 
	(
	SELECT *, 
	ROUND(CAST(Downpayment AS FLOAT)/CAST(Price AS FLOAT), 4) * 100 AS Downpayment_pct
	FROM Houses
	)
SELECT *
FROM Houses_pct 
WHERE Downpayment_pct >= 1

-- These queries give the same result, it is mostly a personal preference which approach to use
--We can also create multiple derived columns from a table
-- Let's say we want to get the difference between Years_since_construction and Years_since_renovation
SELECT *, 
ROUND(CAST(Downpayment AS FLOAT)/CAST(Price AS FLOAT), 4) * 100 AS Downpayment_pct,
Years_since_construction - Years_since_renovation AS Years_between_construction_and_renovation
FROM Houses

-- Now, we can use the WHERE clause to filter where this new column is not null, as well as where the Downpayment_pct is more or equal than 1
SELECT *, 
ROUND(CAST(Downpayment AS FLOAT)/CAST(Price AS FLOAT), 4) * 100 AS Downpayment_pct,
Years_since_construction - Years_since_renovation AS Years_between_construction_and_renovation
FROM Houses
WHERE ROUND(CAST(Downpayment AS FLOAT)/CAST(Price AS FLOAT), 4) * 100 >= 1
AND Years_since_construction - Years_since_renovation IS NOT NULL

-- The last operation that we want to perform if we will not use the tables anymore is drop them
DROP TABLE Houses;