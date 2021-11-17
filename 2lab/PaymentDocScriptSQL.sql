USE [Barbershop]
GO

--Создание таблицы документа
CREATE TABLE [dbo].[PaymentDoc](
	[FinalPrice] [money] DEFAULT 0,
	[DateOfHaircut] [date] NOT NULL,
	[MainOffice] [bit] NOT NULL,
	[HaircutID] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
	[BarberID] [int] NOT NULL
)
GO

--Ограничение на внешний ключ стрижки
ALTER TABLE PaymentDoc
WITH CHECK ADD CONSTRAINT FK_PaymentDoc_Haircut FOREIGN KEY(HaircutID)
REFERENCES Haircut (HaircutID)
ON UPDATE CASCADE
GO

--Ограничение на внешний ключ клиента
ALTER TABLE PaymentDoc
WITH CHECK ADD CONSTRAINT FK_PaymentDoc_Client FOREIGN KEY(ClientID)
REFERENCES Client (ClientID)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

--Ограничение на внешний ключ парикмахера
ALTER TABLE PaymentDoc
WITH CHECK ADD CONSTRAINT FK_PaymentDoc_Barber FOREIGN KEY(BarberID)
REFERENCES Barber (BarberID)
ON UPDATE CASCADE
GO

--Выставление сегодняшней даты по умолчанию
ALTER TABLE PaymentDoc
ADD CONSTRAINT DF_PaymentDoc_DateOfHaircut DEFAULT (getdate()) FOR DateOfHaircut
GO

--Вставка 20 разных чеков на 3 разные даты
INSERT INTO PaymentDoc (DateOfHaircut, MainOffice, HaircutID, ClientID, BarberID) VALUES
('11/14/2021', 0, 6, 95, 6),
('11/14/2021', 0, 30, 75, 4),
('11/14/2021', 1, 17, 19, 5),
('11/14/2021', 1, 10, 33, 14),
('11/14/2021', 0, 6, 71, 2),
('11/14/2021', 1, 30, 17, 9),
('11/14/2021', 1, 8, 44, 6),
('11/14/2021', 1, 22, 50, 7),
('11/14/2021', 1, 24, 77, 7),
('11/14/2021', 1, 14, 53, 7),
('11/14/2021', 1, 25, 22, 3),
('11/14/2021', 1, 28, 24, 15),
('11/14/2021', 0, 7, 37, 1),
('11/14/2021', 1, 7, 63, 9),
('11/14/2021', 0, 6, 56, 4),
('11/14/2021', 0, 9, 4, 12),
('11/14/2021', 0, 21, 72, 10),
('11/14/2021', 1, 16, 94, 10),
('11/14/2021', 0, 24, 33, 6),
('11/14/2021', 0, 14, 9, 15),
('11/15/2021', 0, 23, 66, 8),
('11/15/2021', 0, 15, 75, 6),
('11/15/2021', 0, 7, 67, 14),
('11/15/2021', 0, 15, 76, 9),
('11/15/2021', 1, 15, 37, 14),
('11/15/2021', 0, 28, 57, 15),
('11/15/2021', 1, 19, 32, 5),
('11/15/2021', 1, 19, 94, 14),
('11/15/2021', 1, 5, 82, 14),
('11/15/2021', 0, 3, 21, 7),
('11/15/2021', 1, 8, 14, 1),
('11/15/2021', 1, 20, 80, 7),
('11/15/2021', 1, 27, 29, 4),
('11/15/2021', 1, 7, 54, 8),
('11/15/2021', 0, 26, 5, 14),
('11/15/2021', 0, 1, 29, 7),
('11/15/2021', 1, 5, 69, 12),
('11/15/2021', 1, 11, 90, 11),
('11/15/2021', 1, 3, 48, 4),
('11/15/2021', 0, 13, 31, 6),
('11/16/2021', 1, 26, 35, 11),
('11/16/2021', 1, 27, 33, 9),
('11/16/2021', 0, 12, 67, 5),
('11/16/2021', 0, 3, 20, 10),
('11/16/2021', 0, 22, 16, 7),
('11/16/2021', 1, 4, 53, 9),
('11/16/2021', 1, 10, 85, 1),
('11/16/2021', 0, 1, 98, 8),
('11/16/2021', 1, 16, 87, 5),
('11/16/2021', 0, 14, 4, 15),
('11/16/2021', 1, 24, 26, 12),
('11/16/2021', 1, 16, 94, 4),
('11/16/2021', 1, 6, 74, 13),
('11/16/2021', 1, 13, 32, 15),
('11/16/2021', 0, 13, 99, 2),
('11/16/2021', 0, 6, 17, 8),
('11/16/2021', 1, 14, 18, 8),
('11/16/2021', 0, 30, 60, 7),
('11/16/2021', 0, 10, 87, 9),
('11/16/2021', 1, 25, 1, 15);
GO

--Обновление финальной цены в зависимости от других полей
UPDATE PaymentDoc
SET FinalPrice = Price + 10 * Class + 50 * MainOffice FROM HaircutPrice, Barber 
WHERE HaircutPrice.HaircutID = PaymentDoc.HaircutID AND PaymentDoc.DateOfHaircut = HaircutPrice.[Date] AND PaymentDoc.BarberID = Barber.BarberID
GO

--Обновление финальной цены, если у клиента есть скидка
UPDATE PaymentDoc
SET FinalPrice -= FinalPrice * Discount / 100 FROM Client
GO

--Просмотр таблички документов
SELECT TOP (60)
FinalPrice,
DateOfHaircut,
MainOffice,
HaircutID,
ClientID,
BarberID
  FROM PaymentDoc
GO

--Обнуление таблицы парикмахера
TRUNCATE TABLE Barber
GO