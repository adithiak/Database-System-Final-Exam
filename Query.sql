GO
USE [LugiOh]
GO

--1
SELECT
CustomerName, CustomerGender, CustomerGender,
CustomerAddress, CustomerDOB
FROM Customer
WHERE CustomerName like '%l%'

--2
SELECT 
CustomerName, CustomerGender, CustomerPhone,
CustomerAddress,
DATENAME(MONTH, TransactionDate) AS [Transaction Month]
FROM Customer JOIN HeaderTransaction ON HeaderTransaction.CustomerID =
Customer.CustomerID
WHERE Customer.CustomerID = 'CU002'


--3
SELECT
CAST(LOWER(CardName) AS VARCHAR (100)) as CardName, CardElement,
CardLevel, CardAttack, CardDefense,
CONCAT(Count(TransactionID) , ' time(s)') AS [Total Transaction]
FROM Cards JOIN DetailTransaction ON 
DetailTransaction.CardsID = Cards.CardsID
WHERE CardElement like 'Dark'
Group by Cards.CardsID, CardName, CardElement,
CardLevel, CardAttack, CardDefense

--4
SELECT
CardName, CardElement,
SUM(CardPrice) AS [Total Price],
CAST(CONCAT(COUNT(TransactionID), ' Time(s)') AS VARCHAR ) AS [Total Transaction]
FROM Cards JOIN DetailTransaction ON DetailTransaction.CardsID =
Cards.CardsID
WHERE DATEDIFF(MONTH, '2017-01-01' , '2017-12-31') > 1 AND
CardPrice > 500000
GROUP BY Cards.CardsID, CardName, CardElement, DetailTransaction.TransactionID

--5
SELECT
CustomerName, CustomerGender, CONVERT(VARCHAR, CustomerDOB, 107) CustomerDOB
FROM Customer
WHERE Day(CustomerDOB) = 5

--6
	SELECT
	CardName, UPPER(CardTypeName) AS [Type], CardElement,
	CONCAT(Quantity, ' Cards') AS [Total Card],
	SUM(CardPrice * Quantity) as [Total Price]
	FROM CardType JOIN Cards ON Cards.CardTypeID = CardType.CardTypeID 
	JOIN DetailTransaction ON DetailTransaction.CardsID = Cards.CardsID,
	(
		SELECT
		AVG(CardPrice) AS AVGPrice
		FROM Cards
	) a
	WHERE CardElement = 'Dark' AND CardPrice < a.AVGPrice
GROUP BY Cards.CardsID, CardName, CardElement, CardTypeName, Quantity
ORDER BY Quantity

--7
CREATE VIEW [DragonDeck]
AS
SELECT
SUBSTRING(CardName, 1, Charindex(' ', CardName, -1)) AS [Monster Card],
CardTypeName, CardElement, CardLevel, CardAttack, CardDefense
FROM CardType JOIN Cards ON Cards.CardTypeID = CardType.CardTypeID
WHERE CardTypeName = 'Dragon'

Select * FROM DragonDeck

--8
CREATE VIEW [MayTransaction]
AS
SELECT
CustomerName, REPLACE(CustomerPhone, '8', 'x') AS CustomerPhone,
StaffName, StaffPhone, TransactionDate, SUM(Quantity) as Quantity
FROM Customer JOIN HeaderTransaction ON HeaderTransaction.CustomerID = Customer.CustomerID
JOIN Staff ON Staff.StaffID = HeaderTransaction.StaffID JOIN 
DetailTransaction ON DetailTransaction.TransactionID = HeaderTransaction.TransactionID
WHERE MONTH(TransactionDate) = 5 AND CustomerGender = 'Female'
Group By CustomerName, CustomerPhone, StaffName, StaffPhone, TransactionDate

--9
ALTER TABLE Staff ADD StaffSalary INT

Select * FROM Staff

--10
UPDATE Cards
SET CardPrice = (CardPrice + 200000)
Where (SELECT CardTypeName FROM CardType) = 'Divine-Beast' AND ( SELECT Quantity FROM DetailTransaction) > 10