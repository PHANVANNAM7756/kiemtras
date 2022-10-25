USE master
GO
IF EXISTS (SELECT * FROM sys.databases WHERE Name='AZbank')
DROP DATABASE AZbank
GO
CREATE DATABASE AZbank
GO
USE AZbank
GO
CREATE TABLE Customer(
CustomerID int  PRIMARY KEY,
Name nvarchar(50),
[City] nvarchar(50),
	[Country] nvarchar(50),
	[Phone] nvarchar(50),
	[Email] nvarchar(50),
)

CREATE TABLE CustomerAccount(
	AccountNumber char(9) PRIMARY KEY,
	CustomerId int,
	Balance money NOT NULL,
	MinAccount money,
	CONSTRAINT FK_CA_C
    FOREIGN KEY (CustomerId)
    REFERENCES Customer(CustomerId)
)

CREATE TABLE CustomerTransaction(
	TransactionId int PRIMARY KEY,
	AccountNumber char(9),
	TransactionDATE smalldatetime,
	Amount money,
	DepositorWithdraw bit,
	CONSTRAINT FK_CT_CA
    FOREIGN KEY (AccountNumber)
    REFERENCES CustomerAccount(AccountNumber)
)

INSERT INTO Customer VALUES(01, 'Van Nam', 'HA Noi', 'Viet Nam','4321','VN@gmail.com')
INSERT INTO Customer VALUES(02, ' Minh', 'bac Giang', 'Viet Nam', 'Minh@gmail.com')
INSERT INTO Customer VALUES(03, ' Duc', 'vinh phuc', 'Viet Nam', 'Duc@gmail.com')
SELECT * FROM Customer

INSERT INTO CustomerAccount VALUES('ca1',1,3000,100)
INSERT INTO CustomerAccount VALUES('ca2',1,200000,100)
INSERT INTO CustomerAccount VALUES('ca3',2,5000,100)
SELECT * FROM CustomerAccount

INSERT INTO CustomerTransaction VALUES(1,'CA1','2017-07-17',2000,3)
INSERT INTO CustomerTransaction VALUES(2,'CA1','2021-07-7',100000,5)
INSERT INTO CustomerTransaction VALUES(3,'CA2','2018-08-12',6000,3)
SELECT * FROM CustomerTransaction

--4. Write a query to get all customers from Customer table who live in ‘Hanoi’.
SELECT * FROM Customer WHERE City = 'HN'
--5. Write a query to get account information of the customers (Name, Phone, Email,
--AccountNumber, Balance).
SELECT [Name],Phone,Email,AccountNumber,Balance FROM Customer
join CustomerAccount ON
Customer.CustomerId = CustomerAccount.CustomerId
--6. A-Z bank has a business rule that each transaction (withdrawal or deposit) won’t be
--over $1000000 (One million USDs). Create a CHECK constraint on Amount column
--of CustomerTransaction table to check that each transaction amount is greater than
--0 and less than or equal $1000000.
ALTER TABLE CustomerTransaction
ADD CONSTRAINT CK_Checkwithdrawal CHECK (DepositorWithdraw > 0 and DepositorWithdraw <= 1000000)
--7. Create a view named vCustomerTransactions that display Name,
--AccountNumber, TransactionDate, Amount, and DepositorWithdraw from Customer,
--CustomerAccount and CustomerTransaction tables.

CREATE VIEW vCustomerTransactions
AS
SELECT [Name],CustomerAccount.AccountNumber,TransactionDate,Amount,DepositorWithdraw FROM Customer
join CustomerAccount ON
Customer.CustomerId = CustomerAccount.CustomerId
Join CustomerTransaction ON
CustomerTransaction.AccountNumber = CustomerAccount.AccountNumber

SELECT * FROM vCustomerTransactions