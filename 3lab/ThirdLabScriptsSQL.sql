USE [Barbershop]
GO

--FIRSTPART

--a Найпростіших умов
--1) Вывожу всех парикмахером с лучшим классом
SELECT *
FROM Barber
WHERE Class = 5
GO

--2) Вывожу всех клиентов без стрижек
SELECT *
FROM Client
WHERE AmountOfHaircuts = 0
GO

--b Операторів порівняння
--3) Вывожу все стрижки с ценой выше 80
SELECT *
FROM HaircutPrice
WHERE Price >= 80
GO

--4) Вывожу все чеки с финальной ценой ниже 100
SELECT *
FROM PaymentDoc
WHERE FinalPrice < 100
GO

--c Умов з використанням логічних операторів AND, OR та NOT.
--5) Вывожу всех парикмахеров с классом больше или равным 2 и меньше или равным 5
SELECT *
FROM Barber
WHERE Class >= 2 AND Class <= 5
ORDER BY Class DESC
GO

--6) Вывожу все чеки, которые были сделанны в главном офисе и цена меньше 120
SELECT *
FROM PaymentDoc
WHERE MainOffice = 1 AND FinalPrice < 120
GO

--d Умов з використанням комбінацій логічних операторів
--7) Вывожу все чеки, которые были сделаны в главном офисе или цена больше 120 и меньше 150
SELECT *
FROM PaymentDoc
WHERE MainOffice = 1 OR (FinalPrice > 120 AND FinalPrice < 150)
GO

--8) Вывожу всех клиентов, у которых была хоть одна стрижка и их иайди меньше 20 или равен 50
SELECT *
FROM Client
WHERE AmountOfHaircuts >= 1 AND (ClientID = 50 OR ClientID < 20)
GO

--e З використанням виразів над стовпцями, як в якості новостворених стовпців, так і умовах
--9) Вывожу клиентов, у которых была хоть одна стрижка, объеденив ФИО в один столбец
SELECT TRIM(Name) + ' ' + TRIM(Surname) AS FullName, Discount
FROM Client 
WHERE AmountOfHaircuts >= 1
GO

--10) Вывожу цены на стрижку, сделанные в главном офисе без надбавки в 50
SELECT FinalPrice - 50 AS PriceWithoutOficce, DateOfHaircut, PaymentDocID
FROM PaymentDoc
WHERE MainOffice = 1
GO

--i Приналежності множині
--11) Вывожу всех клиентов, у кого имя не Моше и не Терри
SELECT *
FROM Client
WHERE [Name] NOT IN('Moshe','Terry')
GO

--12) Вывожу всех парикмахеров у которых соответствующие фамилии
SELECT *
FROM Barber
WHERE Surname IN('Ikin','Jedras','Caldera')
GO

--ii Приналежності діапазону
--13) Вывожу всех парикмахеров с классом между 2 и 4
SELECT *
FROM Barber
WHERE Class BETWEEN 2 AND 4
GO

--iii Відповідності шаблону
--14) Вывожу всех клиентов с соответсвующим именем
SELECT *
FROM Client
WHERE [Name] LIKE 'A%'
GO

--iv Відповідності регулярному виразу
--15) Вывожу всех клиентов с соответсвтующим именем
SELECT *
FROM Client
WHERE [Name] LIKE 'D%[p|l]%e'
GO

--v  Перевірка на невизначене значення
--16) Вывожу всех парикмахеров у которых нет отчества и класс равен 1
SELECT *
FROM Barber
WHERE Patronymic IS NULL AND Class = 1
GO

--SECONDPART

--a Використання підзапитів в рядку вибірки полів та вибірки з таблиць
--1) Вывожу парикмахеров у которых высший класс и клиентов с таким же айди как и у парикмахеров
SELECT bBarb.[Name] AS [BestBarbers], BarberID, Client.[Name], ClientID
FROM (SELECT * FROM Barber WHERE Class = 5) AS bBarb, Client
WHERE bBarb.BarberID = ClientID
GO

--2) Вывожу самую лучшую цену и лучшее кол-во стрижек у одного клиента
SELECT (SELECT TOP 1 FinalPrice FROM PaymentDoc ORDER BY FinalPrice DESC) as [BestPrice], (SELECT TOP 1 AmountOfHaircuts FROM Client ORDER BY AmountOfHaircuts DESC) as [BestAmountOfHaircuts]
GO

--b Використання підзапитів в умовах з конструкціями EXISTS, IN
--3) Вывожу всех парикмахеров, которые выполняли стрижки
SELECT [Name], Surname
FROM Barber
WHERE EXISTS(SELECT * FROM PaymentDoc WHERE PaymentDoc.BarberID = Barber.BarberID)
GO

--4) Вывожу всех клиентов, которые получиали стрижку с финальной ценой больше 100
SELECT *
FROM Client
WHERE ClientID IN (SELECT ClientID FROM  PaymentDoc WHERE FinalPrice > 100)
GO

--с Декартовий добуток
--5) Вивід всіх можливіх стрижок всім можливи клієнтам усіма можливими парикмахерами
SELECT Barber.[Name] as BarberName, Client.[Name] as ClientName, Haircut.HaircutName
FROM Barber, Client, Haircut
GO

--6) Те ж саме, що зверху, але іншим методом
SELECT Barber.[Name] as BarberName, Client.[Name] as ClientName, Haircut.HaircutName
FROM Barber
CROSS JOIN Client
CROSS JOIN Haircut
GO

--d З’єднання декількох таблиць (більше 2) за рівністю
--7) Вывод чека, но вместо айди имя и фамилия клиентов и парикмахеров
SELECT FinalPrice, DateOfHaircut, MainOffice, HaircutID, Client.[Name] AS ClientName, Client.Surname AS ClientSurname, Barber.[Name] AS BarberName, Barber.Surname AS BarberSurname, PaymentDocID
FROM PaymentDoc JOIN Barber ON PaymentDoc.BarberID = Barber.BarberID
JOIN Client ON PaymentDoc.ClientID = Client.ClientID
GO

--8) Вывод финальной цены чека с именем стрижки и всеми его ценами
SELECT FinalPrice, Haircut.HaircutName, HaircutPrice.Price
FROM PaymentDoc JOIN Haircut ON PaymentDoc.HaircutID = Haircut.HaircutID
JOIN HaircutPrice ON Haircut.HaircutID = HaircutPrice.HaircutID
GO

--***То же самое, но без джоина****
SELECT FinalPrice, Haircut.HaircutName, HaircutPrice.Price
FROM PaymentDoc, Haircut, HaircutPrice
WHERE PaymentDoc.HaircutID = Haircut.HaircutID AND Haircut.HaircutID = HaircutPrice.HaircutID
GO

--e З’єднання декількох таблиць (більше 2) за рівністю та умовою відбору
--9) Вывод финальной цены чека, вместе с именем, гендером и ценой стрижки
SELECT FinalPrice, Haircut.HaircutName, Haircut.Gender, HaircutPrice.Price
FROM PaymentDoc JOIN Haircut ON PaymentDoc.HaircutID = Haircut.HaircutID
JOIN HaircutPrice ON Haircut.HaircutID = HaircutPrice.HaircutID
WHERE [date] = [DateOfHaircut]
GO

--10) Вывод чека, но вместо айди имя и фамилия клиентов и парикмахеров (у которых класс 5)
SELECT FinalPrice, DateOfHaircut, MainOffice, HaircutID, Client.[Name] AS ClientName, Client.Surname AS ClientSurname, Barber.[Name] AS BarberName, Barber.Surname AS BarberSurname, PaymentDocID
FROM PaymentDoc JOIN Barber ON PaymentDoc.BarberID = Barber.BarberID
JOIN Client ON PaymentDoc.ClientID = Client.ClientID
WHERE Class = 5
GO

--f  Внутрішнього з’єднання
--11) Вывод Всех причесок и их цен через декартовое умножение
SELECT HaircutName, Gender, Price, [Date]
FROM Haircut INNER JOIN HaircutPrice ON Haircut.HaircutID = HaircutPrice.HaircutID
GO

--g Лівого зовнішнього з’єднання
--12) Вывод клиентов и их чеков через левое слияние
SELECT Client.[Name] AS ClientName, Client.Surname AS ClientSurname, FinalPrice, DateOfHaircut, MainOffice, HaircutID, BarberID, PaymentDocID
FROM Client LEFT JOIN PaymentDoc ON Client.ClientID = PaymentDoc.ClientID
GO

--13) Вывод парикмахеров и чеков с ними через левое слияние
SELECT Barber.[Name] AS BarberName, Barber.Surname AS BarberSurname, FinalPrice, DateOfHaircut, MainOffice, ClientID, HaircutID, PaymentDocID
FROM Barber LEFT JOIN PaymentDoc ON Barber.BarberID = PaymentDoc.BarberID
GO

--h  Правого зовнішнього з’єднання
--14) Вывод  чеков и клиентов через правое слияние
SELECT FinalPrice, HaircutID, BarberID, PaymentDocID, Client.[Name] AS ClientName, Client.Surname AS ClientSurname
FROM PaymentDoc RIGHT JOIN Client ON PaymentDoc.ClientID = Client.ClientID
GO

--i  Об’єднання таблиць
--15) Объеденение таблиц (Все имена)
SELECT Client.[Name] AS AllNames
FROM Client
UNION
SELECT Haircut.HaircutName
FROM Haircut
UNION
SELECT Barber.[Name]
FROM Barber
GO