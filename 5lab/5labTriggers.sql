USE [Barbershop]
GO

--4)
--c
DROP TRIGGER HaircutPriceCheckInsert
GO
--Проверяет, чтоб входящая дата не была больше нынешней
CREATE TRIGGER HaircutPriceCheckInsert
ON HaircutPrice
INSTEAD OF INSERT
AS BEGIN
  DECLARE @HaircutID int
  DECLARE @Price money
  DECLARE @Date date
  DECLARE curs CURSOR LOCAL FOR
  SELECT HaircutID, Price, [Date] FROM inserted
  OPEN CURS
  FETCH NEXT FROM CURS INTO @HaircutID, @Price, @Date
  WHILE @@FETCH_STATUS = 0
  BEGIN 
    IF @Date <= (getdate()) 
      INSERT INTO HaircutPrice (HaircutID, Price, [Date]) VALUES (@HaircutID, @Price, @Date)
  ELSE THROW 50005, N'Error! Date of haircut price is Higher than current date!', 1;
    FETCH NEXT FROM curs INTO @HaircutID, @Price, @Date
  END
  CLOSE CURS
  DEALLOCATE CURS
END
GO

INSERT INTO HaircutPrice (HaircutID, Price, [Date]) VALUES (1, '$20.00', '1/1/2022')
GO

INSERT INTO HaircutPrice (HaircutID, Price, [Date]) VALUES (1, '$20.00', '1/1/2019')
GO

SELECT *
FROM HaircutPrice
GO

--a
DROP TRIGGER HaircutPriceDeleteCheck
GO
--Выводить все удаленные данные о стрижках и их ценах
CREATE TRIGGER HaircutPriceDeleteCheck
ON HaircutPrice
FOR DELETE
AS BEGIN
	DECLARE @Price money
	DECLARE @HaircutID int
	DECLARE @HaircutDate date
	DECLARE CURS CURSOR LOCAL FOR
	SELECT HaircutID, Price, [Date] FROM HaircutPrice
	OPEN CURS
	FETCH NEXT FROM CURS INTO @HaircutID, @Price, @HaircutDate
	DECLARE @i int = (SELECT count(*) FROM deleted)
	WHILE @i > 0
	BEGIN
		PRINT 'Deleted row #' + convert(nvarchar(4), @i) + ', HaircutID: ' + convert(nvarchar(4), @HaircutID) + ', Price: ' + convert(nvarchar(50), @Price) + ', Date: ' + convert(nvarchar(50), @HaircutDate)
		FETCH NEXT FROM CURS INTO @HaircutID, @Price, @HaircutDate
		SET @i = @i - 1
	END
END
GO

DELETE FROM HaircutPrice WHERE HaircutPrice.HaircutID = 1 AND HaircutPrice.[Date] = '1/1/2019'
GO

--b 
DROP TRIGGER UpdatePaymentDocs
GO
--Выводит айди всех обновленных чеков
CREATE TRIGGER UpdatePaymentDocs
ON PaymentDoc
FOR UPDATE
AS BEGIN
	DECLARE @ID int
	DECLARE CURS CURSOR LOCAL FOR
	SELECT PaymentDocID FROM inserted
	OPEN CURS
	FETCH NEXT FROM CURS INTO @ID
	DECLARE @i int = (SELECT count(*) FROM inserted)
	WHILE @i > 0
	BEGIN
		PRINT 'Updated row with ID:' + convert(nvarchar(4), @ID)
		FETCH NEXT FROM CURS INTO @ID
		SET @i = @i - 1
	END
END
GO

UPDATE PaymentDoc
SET FinalPrice += 1
WHERE PaymentDoc.MainOffice = 1
GO