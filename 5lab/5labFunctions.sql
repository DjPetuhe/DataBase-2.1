USE [Barbershop]
GO

--2)
--a
DROP FUNCTION AvgAmountOfHaircutsMadeByBarberMaxClass
GO
--Возвращает среднее колиечество стрижек выполненное парикмахерами 5-го класса
CREATE FUNCTION AvgAmountOfHaircutsMadeByBarberMaxClass()
RETURNS float
AS BEGIN
	DECLARE @SumOfHaircuts int = 0
	DECLARE @AmountOFBarbers int = 0
	DECLARE @Avg float
	SET @AmountOfBarbers = (SELECT count(*) FROM Barber WHERE Class = 5)
	SET @SumOfHaircuts = (SELECT count(*) FROM Barber, PaymentDoc WHERE PaymentDoc.BarberID = Barber.BarberID AND Barber.Class = 5)
	SET @Avg = @AmountOFBarbers / cast(@SumOfHaircuts AS float)
	RETURN @Avg
END
GO

SELECT 'Avarage amount of haircuts made by Barbers 5 class' = dbo.AvgAmountOfHaircutsMadeByBarberMaxClass()
GO

--b
DROP FUNCTION HaircutsAndTheirDynamicPrice
GO
--Возвращает топ (вводит пользователь) стрижек по их ценам за все даты
CREATE FUNCTION HaircutsAndTheirDynamicPrice(@top int)
RETURNS TABLE
AS RETURN
(
	SELECT TOP (@top) Haircut.HaircutName, Haircut.Gender, HaircutPrice.Price, HaircutPrice.Date, Haircut.HaircutID
	FROM Haircut, HaircutPrice
	WHERE Haircut.HaircutID = HaircutPrice.HaircutID
	ORDER BY HaircutPrice.Price DESC
)
GO

SELECT * FROM dbo.HaircutsAndTheirDynamicPrice(10)
GO

--c
DROP FUNCTION ClientAndDocs
GO
--Возвращает таблицу со айди всех чеков и клиентов, которые выполнили эту стрижку
CREATE FUNCTION ClientAndDocs()
RETURNS @ClandDOC TABLE ([Clientd ID] int, [Payment doc ID] int)
AS BEGIN 
	INSERT INTO @ClandDOC SELECT Client.ClientID, PaymentDoc.PaymentDocID
	FROM Client, PaymentDoc
	WHERE Client.ClientID = PaymentDoc.ClientID
	RETURN
END
GO

SELECT * FROM ClientAndDocs()
GO
