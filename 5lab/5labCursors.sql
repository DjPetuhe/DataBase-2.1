USE [Barbershop]
GO

--3)
--a
DECLARE CURS CURSOR FOR
SELECT [Name], Surname, Patronymic, Class, BarberID
FROM Barber
GO

--b
OPEN CURS
GO

--c
--Выводит данные всех парикмахеров (кроме 10)
DECLARE @Name nvarchar(50) 
DECLARE @Surname nvarchar(50) 
DECLARE @Patronymic nvarchar(50)
DECLARE @Class int
DECLARE @ID int
FETCH NEXT FROM CURS INTO @Name, @Surname, @Patronymic, @Class, @ID 
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @ID != 10
	BEGIN
		PRINT 'Name: ' + @Name  + ', Surname: ' + @Surname  + ', Class: '+ convert(nvarchar(4),@Class) + ', ID: ' + convert(nvarchar(4),@ID)
	END
	FETCH NEXT FROM CURS INTO @Name, @Surname, @Patronymic, @Class, @ID 
END
GO

CLOSE CURS
GO

DEALLOCATE CURS
GO
