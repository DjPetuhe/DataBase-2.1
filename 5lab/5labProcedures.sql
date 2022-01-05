USE [Barbershop]
GO

--1)
--a
-- Создаю таблицу и вношу туда данные, запросом переношу из временной таблицы в основную
CREATE TYPE TableHaircutLine AS TABLE ([HaircutName] nvarchar(50), [Gender] nvarchar(50))
GO

DROP PROCEDURE FromTempToHaircut
GO

CREATE PROCEDURE FromTempToHaircut 
	@temp TableHaircutLine READONLY
AS BEGIN
	INSERT INTO Haircut ([HaircutName], [Gender])
	SELECT HaircutName, Gender
	FROM @temp
END
GO

DECLARE @tempHaircutTable AS TableHaircutLine;
INSERT INTO @tempHaircutTable([HaircutName], [Gender]) values('Каре', 'female');
INSERT INTO @tempHaircutTable([HaircutName], [Gender]) values('Налысо', 'male');
EXEC FromTempToHaircut  @tempHaircutTable;
GO

SELECT * FROM Haircut
GO

DELETE FROM Haircut WHERE HaircutID > 30
GO
--b
DROP PROCEDURE FindClient
GO
--Находит клиента по его айди, и если не находит, то выводит сообщение
CREATE PROCEDURE FindClient
@IDclient int
AS BEGIN
	IF (SELECT count(*) FROM Client WHERE ClientID = @IDclient) > 0
		SELECT [Name], Surname, AmountOfHaircuts, Discount, ClientID FROM Client WHERE ClientID = @IDclient
	ELSE
		THROW 51000, 'There is no such client in database!', 1;
END
GO

EXEC FindClient 10
GO

EXEC FindClient 105
GO

--c
DROP PROCEDURE IncreasePrice
GO
--Создает временную таблицу (в моем случае чтоб не портить настоящую) и увличивает цену на определенную амплитуду, пока цена не станет больше задаваймой
CREATE PROCEDURE IncreasePrice
@amplitude int,
@ToCost int
AS BEGIN
	DECLARE @i int = 0
	DECLARE @Size int  = (SELECT count(*) FROM PaymentDoc)
	DECLARE @tempID int = 0
	CREATE TABLE #TempCost
		(
		[FinalPrice] [money] NOT NULL,
		[DateOfHaircut] [date] NOT NULL,
		[MainOffice] [bit] NOT NULL,
		[HaircutID] [int] NOT NULL,
		[ClientID] [int] NOT NULL,
		[BarberID] [int] NOT NULL,
		[PaymentDocID] [int] NOT NULL
		)
	INSERT INTO #TempCost
	SELECT *
	FROM PaymentDoc
	WHILE @i < @Size
	BEGIN
		IF (SELECT count(*) FROM #TempCost WHERE #TempCost.PaymentDocID = @tempID) > 0
		BEGIN
			WHILE @ToCost > (SELECT FinalPrice FROM #TempCost WHERE #TempCost.PaymentDocID = @tempID)
				BEGIN
				UPDATE #TempCost SET #TempCost.FinalPrice = #TempCost.FinalPrice + @amplitude WHERE #TempCost.PaymentDocID = @tempID 
				END
			SET @i = @i + 1
		END
		SET @tempID = @tempID + 1
	END
	SELECT *
	FROM #TempCost
END
GO

EXEC IncreasePrice 10, 200
GO

--d
DROP PROCEDURE  CreateClientsPaid
GO
--Создает временную таблицу, которая содержит клиентов с хотя бы 1 стрижкой и выводит её
CREATE PROCEDURE CreateClientsPaid
AS BEGIN
	CREATE TABLE #ClientsPaid
	(
		[Name] [nvarchar](50) NOT NULL,
		[Surname] [nvarchar](50) NOT NULL,
		[Patronymic] [nvarchar](50) NULL,
		[AmountOfHaircuts] [int] NOT NULL,
		[Discount] [int] NOT NULL,
		[ClientID] [int] NOT NULL
	)
	INSERT INTO #ClientsPaid
	SELECT *
	FROM Client
	WHERE AmountOfHaircuts > 0
	SELECT * 
	FROM #ClientsPaid
END
GO

EXEC CreateClientsPaid
GO

--e
DROP PROCEDURE  FindBarber
GO
--Находит парикмахера по его айди, и если не находит, то выводит сообщение
CREATE PROCEDURE FindBarber
@IDBarber int
AS BEGIN
	IF (SELECT count(*) FROM Barber WHERE BarberID = @IDBarber) > 0
		SELECT [Name], Surname, Class, BarberID FROM Barber WHERE BarberID = @IDBarber
	ELSE
		THROW 51000, 'There is no such Barber in database!', 1;
END
GO

EXEC FindBarber 10
GO

--f
DROP PROCEDURE MoneyByDay
GO
--Выводит сумму полученных денег со всех чеков за определенный день
CREATE PROCEDURE MoneyByDay
@Date date
AS BEGIN
	DECLARE @SumByDay int = (SELECT SUM(FinalPrice) FROM PaymentDoc WHERE PaymentDoc.DateOfHaircut = @Date)
	RETURN @SumByDay
END
GO

DECLARE @tempSum int
EXEC @tempSum = MoneyByDay '11/14/2021'
SELECT @tempSum
GO

--g
DROP PROCEDURE SetBarberClass
GO
--Находит парикмахера и обновляет его класс на введенный
CREATE PROCEDURE SetBarberClass
@IDBarber int,
@NewBarberClass int
AS BEGIN
	IF (SELECT count(*) FROM Barber WHERE BarberID = @IDBarber) > 0
	BEGIN
		UPDATE Barber
		SET Class = @NewBarberClass
		WHERE Barber.BarberID = @IDBarber
		SELECT [Name], Surname, Class, BarberID FROM Barber WHERE BarberID = @IDBarber
	END
	ELSE
		THROW 51000, 'There is no such Barber in database!', 1;
END
GO

SELECT * FROM Barber WHERE Barber.BarberID = 10
GO

EXEC SetBarberClass 10, 5
GO

--h
DROP PROCEDURE BarberClassHigher
GO
--Выводит всех парикмахеров у которых класс выше вводимого
CREATE PROCEDURE BarberClassHigher
@Class int
AS BEGIN
SELECT *
FROM Barber
WHERE Barber.Class > @Class
END
GO

EXEC BarberClassHigher 2
GO
