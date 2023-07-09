CREATE DATABASE GG_TS
GO
USE GG_TS
GO
CREATE TABLE customers
(
CustomerNumber	int		NOT NULL,
LastName	char(30)	NOT NULL,
FirstName	char(30)	NOT NULL,
StreetAddress	char(30)	NOT NULL,
City		char(20)	NOT NULL,
State		char(2)		NOT NULL,
Zip		char(10)	NOT NULL
)

CREATE TABLE orders
(
OrderNumber	int		NOT NULL,
OrderDate	datetime	NOT NULL,
CustomerNumber	int		NOT NULL,
ItemNumber	int		NOT NULL,
Amount		numeric(9,2)	NOT NULL
)
CREATE TABLE items
(
ItemNumber	int		NOT NULL,
Description	char(30)	NOT NULL,
Price		numeric(9,2)	NOT NULL
) 

INSERT INTO customers
VALUES(1,'Doe','John','123 Joshua Tree','Plano','TX','75025')

INSERT INTO customers
VALUES(2,'Doe','Jane','123 Joshua Tree','Plano','TX','75025')

INSERT INTO customers
VALUES(3,'Citizen','John','57 Riverside','Reo','CA','90120')

INSERT INTO orders
VALUES(101,'19001018',1,1001,123.45)

INSERT INTO orders
VALUES(102,'19920227',2,1002,678.90)

INSERT INTO orders
VALUES(103,'19950520',3,1003,86753.09)

INSERT INTO orders
VALUES(104,'19971121',1,1002,678.90)

INSERT INTO orders
VALUES(105,'19991111',3,1001,123.45)

INSERT INTO orders
VALUES(106,'19991127',3,1002,678.90)

INSERT INTO orders
VALUES(107,'19990101',1,1003,86753.09)

INSERT INTO items
VALUES(1001,'WIDGET A',123.45)

INSERT INTO items
VALUES(1002,'WIDGET B',678.90)

INSERT INTO items
VALUES(1003,'WIDGET C',86753.09)
