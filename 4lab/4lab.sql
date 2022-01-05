USE [Barbershop]
GO

--FIRSTPART

--a COUNT;
--1) ��������� ���������� ���������� ������� �� ���-�� ����� 
UPDATE Client 
SET AmountOfHaircuts = (
	SELECT COUNT(*) 
	FROM PaymentDoc 
	WHERE PaymentDoc.ClientID = Client.ClientID
	)
GO

--b SUM;
--2) ������ ����� ���-�� ����������� ����� �� ��������
SELECT [Name], [Surname], SUM(FinalPrice) as [Total spend money] 
FROM Client, PaymentDoc
WHERE Client.ClientID = PaymentDoc.ClientID
GROUP BY [Name], Surname
ORDER BY [Total spend money] DESC
GO

--� UPPER, LOWER;
--3) ������ ������ ��� ������� ���������� ������� � �������� �������, ������� ��� ������� ���������� + ����
SELECT UPPER(TRIM([Name]) + ' ' + TRIM(SURNAME)) AS [Client full name], LOWER(HaircutName) as [Haircut name], FinalPrice, PaymentDocID
FROM PaymentDoc, Client, Haircut
WHERE PaymentDoc.ClientID = Client.ClientID AND PaymentDoc.HaircutID = Haircut.HaircutID
GO

--d ������ � ������
--4) ������ ���� � ����� � ��������� �������� � �����
SELECT DATENAME(day, DateOfHaircut) AS [Day of Haircut], DATENAME(month, DateOfHaircut) AS [Month of haircut], DATENAME(year, DateOfHaircut) AS [Year of haircut], FinalPrice, PaymentDocID
FROM PaymentDoc
GO

--e ����������� �� ������ �������
--5) ������ ����� �������� � �� ���-��� �������
SELECT Client.[Name], COUNT(PaymentDoc.PaymentDocID) AS [Amount of haircuts]
FROM Client
LEFT JOIN PaymentDoc ON Client.ClientID = PaymentDoc.ClientID
GROUP BY Client.[Name]
ORDER BY [Amount of haircuts] DESC
GO

--f ����������� �� ���������� ��������
--6) ������ ����� � ������� �������� � �� ���-��� ������
SELECT Client.[Name], Client.Surname, COUNT(PaymentDoc.PaymentDocID) AS [Amount of haircuts]
FROM Client
LEFT JOIN PaymentDoc ON Client.ClientID = PaymentDoc.ClientID
GROUP BY Client.[Name], Client.Surname
ORDER BY [Amount of haircuts] DESC
GO

--g HAVING
--7) ������ ����� � ������� �������� � �� ���-��� ������� (������ 1)
SELECT Client.[Name], Client.Surname, COUNT(PaymentDoc.PaymentDocID) AS [Amount of haircuts]
FROM Client
LEFT JOIN PaymentDoc ON Client.ClientID = PaymentDoc.ClientID
GROUP BY Client.[Name], Client.Surname
HAVING COUNT(PaymentDoc.PaymentDocID) >= 2
ORDER BY [Amount of haircuts] DESC

--h HAVING �� ��� GROUP BY
--8) ������ ����� ���������� ����� � ����� ����� ������������ �����
SELECT Count(PaymentDocID) AS [Total amount of payments], SUM(PaymentDoc.FinalPrice) AS [Total Earned Money]
FROM PaymentDoc
HAVING SUM(PaymentDoc.FinalPrice) > 5000
GO

--i ORDER BY
--9) ������ ���� � �������� �� �� ��������� ���� (�� �������, � �������)
SELECT *
FROM PaymentDoc
ORDER BY PaymentDoc.FinalPrice DESC
GO

--SECONDPART
--a CREATE VIEW
--10) ������ ������������� (view) �����, �� ������ ���� ��������, ������������ � ������� ��������� �� ���/��������
CREATE VIEW PAYMENTDOC_VIEW AS
SELECT Client.[Name] + ' ' + Client.Surname as [Client full name], Barber.[Name] + ' ' + Barber.Surname as [Barber full name], Haircut.[HaircutName], DateOfHaircut, FinalPrice, PaymentDocID
FROM PaymentDoc, Client, Barber, Haircut
WHERE PaymentDoc.ClientID = Client.ClientID AND PaymentDoc.BarberID = Barber.BarberID AND PaymentDoc.HaircutID = Haircut.HaircutID
GO

SELECT *
FROM PAYMENTDOC_VIEW
GO

--b CREATE VIEW � ������� �� ������ VIEW
--11) ��������� ���������� ������������� (view) � �������� ���� ���������� ��� ��, ���� �� ������� ������� � ������� �����
CREATE VIEW FULL_PAYMENTDOC_VIEW AS
SELECT [Client full name], [Barber full name], [HaircutName], PAYMENTDOC_VIEW.DateOfHaircut, MainOffice, PAYMENTDOC_VIEW.FinalPrice, PAYMENTDOC_VIEW.PaymentDocID
FROM PAYMENTDOC_VIEW, PaymentDoc
WHERE PaymentDoc.PaymentDocID = PAYMENTDOC_VIEW.PaymentDocID
GO

SELECT *
FROM FULL_PAYMENTDOC_VIEW
GO

--c ALTER VIEW
--12) �������� � ������ ������������� (view) ����� ���� ������� ��� ����� �������� ����� � ������ �����������
ALTER VIEW PAYMENTDOC_VIEW AS
SELECT Client.[Name] + ' ' + Client.Surname as [Client full name], Barber.[Name] + ' ' + Barber.Surname as [Barber full name], Haircut.[HaircutName], DateOfHaircut, HaircutPrice.Price AS [Haircut price], FinalPrice, PaymentDocID
FROM PaymentDoc, Client, Barber, Haircut, HaircutPrice
WHERE PaymentDoc.ClientID = Client.ClientID AND PaymentDoc.BarberID = Barber.BarberID AND PaymentDoc.HaircutID = Haircut.HaircutID AND DateOfHaircut = HaircutPrice.[Date] AND PaymentDoc.HaircutID = HaircutPrice.HaircutID 
GO

SELECT *
FROM PAYMENTDOC_VIEW
GO

--13) �������� �� ������ ������������� (view) ����������� �� ��������� ���� (������ ��� ����� 100), ��������� ������ ������������� (view)

ALTER VIEW FULL_PAYMENTDOC_VIEW AS
SELECT [Client full name], [Barber full name], [HaircutName], PAYMENTDOC_VIEW.DateOfHaircut, [Haircut price], MainOffice, PAYMENTDOC_VIEW.FinalPrice, PAYMENTDOC_VIEW.PaymentDocID
FROM PAYMENTDOC_VIEW, PaymentDoc
WHERE PaymentDoc.PaymentDocID = PAYMENTDOC_VIEW.PaymentDocID AND PAYMENTDOC_VIEW.FinalPrice >= 100
GO

SELECT *
FROM FULL_PAYMENTDOC_VIEW
GO

-------
DROP VIEW PAYMENTDOC_VIEW
GO

DROP VIEW FULL_PAYMENTDOC_VIEW
GO
-------

--d ���������� ����������
--14-19) ������� ���. ����������� ��� ������������� ��� ������ ���������� ��������

sp_help PAYMENTDOC_VIEW
GO

sp_help FULL_PAYMENTDOC_VIEW
GO

sp_helptext PAYMENTDOC_VIEW
GO

sp_helptext FULL_PAYMENTDOC_VIEW
GO

sp_depends PAYMENTDOC_VIEW
GO

sp_depends FULL_PAYMENTDOC_VIEW
GO