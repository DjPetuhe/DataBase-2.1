USE [Barbershop]
GO

--�������� ������� ������������
CREATE TABLE [dbo].[Barber](
	[Name] [nvarchar](50) NOT NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[Patronymic] [nvarchar](50) NULL,
	[Class] [int] NOT NULL,
	[BarberID] int IDENTITY(1,1)
)
GO

--����������� ����������� ����� ������������
ALTER TABLE Barber
ADD CONSTRAINT PK_Barber_BarberID PRIMARY KEY CLUSTERED (BarberID)
GO

--������� 15 ������������
INSERT INTO Barber (Name, Surname, Class) VALUES
('Reed', 'Lerven', 5),
('Min', 'Whitters', 4),
('Davin', 'Peasby', 1),
('Bell', 'Crunkhorn', 1),
('Ethe', 'Caldera', 1),
('Quintilla', 'Beernaert', 4),
('Cassandre', 'Gabbitis', 3),
('Mordy', 'Shadrach', 4),
('Lacy', 'Ikin', 3),
('Arri', 'Francesco', 2),
('Carolus', 'Simonsson', 5),
('Job', 'Devanney', 3),
('Cristina', 'Penkethman', 1),
('Griffin', 'Arnhold', 5),
('Quint', 'Jedras', 3);
GO

--�������� �������� ������������
SELECT TOP (15)
[Name],
Surname,
Patronymic,
Class,
BarberID
  FROM Barbershop.dbo.Barber
GO

--��������� �������� ������������
TRUNCATE TABLE Barbershop.dbo.Barber
GO

--���� ������� ������������
DROP TABLE Barbershop.dbo.Barber
GO