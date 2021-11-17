USE [Barbershop]
GO

--Создание таблицы клиентов
CREATE TABLE [dbo].[Client](
	[Name] [nvarchar](50) NOT NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[Patronymic] [nvarchar](50) NULL,
	[AmountOfHaircuts] [int] DEFAULT 0,
	[Discount] [int] NULL,
	[ClientID] int IDENTITY(1,1)
)
GO

--Ограничение внутреннего ключа стрижек
ALTER TABLE Client
ADD CONSTRAINT PK_Client_ClientID PRIMARY KEY CLUSTERED (ClientID)
GO

--Вставка 100 клиентов
INSERT INTO Client (Name, Surname) VALUES
('Harcourt', 'Vispo'),
('Tomasine', 'Crookall'),
('Moshe', 'Farguhar'),
('Inglebert', 'Bonnavant'),
('Gustave', 'Prestney'),
('Terry', 'Beedell'),
('Honoria', 'Cianelli'),
('Shanna', 'Keetley'),
('Toiboid', 'Bambury'),
('Shannen', 'Agnolo'),
('Jaquenette', 'Hawarden'),
('Derwin', 'Spillett'),
('Leelah', 'Durie'),
('Wynn', 'Biskupek'),
('Werner', 'Risborough'),
('Lezlie', 'Twiddell'),
('Dody', 'Minister'),
('Miran', 'Vedikhov'),
('Wandie', 'Pendreigh'),
('Regina', 'Jzak'),
('Deni', 'Carnie'),
('Kendal', 'Terne'),
('Rikki', 'Furnell'),
('Christi', 'Haseldine'),
('Delcine', 'Zambon'),
('Kirk', 'Balnave'),
('Nicolais', 'Semrad'),
('Homerus', 'Conley'),
('Barry', 'Gobert'),
('Shawnee', 'Elbourn'),
('Sacha', 'Weatherburn'),
('Berk', 'Hoggan'),
('Dot', 'Hutchison'),
('Everett', 'Benford'),
('Slade', 'Blouet'),
('Mayne', 'Leeburn'),
('Hanny', 'McVie'),
('Sallie', 'Kovnot'),
('Gino', 'Muslim'),
('Shara', 'Batrip'),
('Rogerio', 'Wiley'),
('Kylynn', 'Neames'),
('Alf', 'Gligoraci'),
('Mommy', 'Dillamore'),
('Lazarus', 'Shipston'),
('Tito', 'Imms'),
('Rosaleen', 'Langan'),
('Garrik', 'Mulgrew'),
('Paul', 'Geraldo'),
('Erik', 'Brewood'),
('Reidar', 'Marl'),
('Jimmie', 'Puckett'),
('Franchot', 'Millier'),
('Deny', 'Allison'),
('Jose', 'Durman'),
('Tabitha', 'Busk'),
('Georgie', 'Giovannetti'),
('Ketty', 'Cartmill'),
('Georgeanna', 'Georgel'),
('Cecilio', 'Martynka'),
('Antone', 'Forbes'),
('Aleda', 'Spiers'),
('Stoddard', 'Renzini'),
('Burg', 'Motton'),
('Mitchell', 'Edling'),
('Melodie', 'Rosgen'),
('Stacia', 'Pingstone'),
('Stacey', 'Wakerley'),
('Micaela', 'Bichener'),
('Hertha', 'Draycott'),
('Chrysa', 'Baynham'),
('Mohandis', 'Finlan'),
('Rinaldo', 'Cartwright'),
('Levey', 'Klyn'),
('Darcy', 'Drillingcourt'),
('Cammi', 'Finding'),
('Junie', 'Blemings'),
('Vincents', 'McTurlough'),
('Barth', 'Badsworth'),
('Jana', 'Colam'),
('Vernice', 'Stockhill'),
('Tobit', 'Burk'),
('Jon', 'Yoseloff'),
('Wilt', 'Eudall'),
('Karoly', 'MacClancey'),
('Amery', 'Morden'),
('Braden', 'Pudding'),
('Odetta', 'Francey'),
('Ben', 'Balsdon'),
('Candice', 'Gameson'),
('Daphne', 'Dilliway'),
('Reeba', 'Cutforth'),
('Correna', 'Wrankling'),
('Luz', 'Ferrai'),
('Stace', 'Merfin'),
('Carlo', 'Sainsbury-Brown'),
('Constantine', 'Gauche'),
('Darcee', 'Solway'),
('Demetria', 'Sheppard'),
('Janette', 'Kynson');
GO

--Установление скидки в 3%, при наличии 5 и более стрижек
UPDATE Client 
SET Discount = 3 
WHERE AmountOfHaircuts >= 5
GO

--Обнуление всех скидок
UPDATE Client 
SET Discount = 0
GO

--Установление количества стрижек по документам
UPDATE Client 
SET AmountOfHaircuts = COUNT(*) 
FROM PaymentDoc 
WHERE PaymentDoc.ClientID = Client.ClientID
GO

--Обнуление количества стрижек
Update Client 
SET AmountOfHaircuts = 0
GO

--Просмотр таблички клиентов
SELECT TOP (100)
[Name],
Surname,
Patronymic,
AmountOfHaircuts,
Discount,
ClientID
  FROM Client
GO

--Удаление всех клиентов, у которых было совершено 0 стрижек
DELETE FROM Client
WHERE AmountOfHaircuts = 0
GO

--Обнуление таблицы клиентов
TRUNCATE TABLE Client
GO