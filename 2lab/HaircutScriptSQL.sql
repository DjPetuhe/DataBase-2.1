USE [Barbershop]
GO

--�������� ������� ������� 
CREATE TABLE [dbo].[Haircut](
	[HaircutName] [nvarchar](50) NOT NULL,
	[Gender] [nvarchar](50) NOT NULL,
	[HaircutID] int IDENTITY(1,1)
)
GO

--��������� ����������� ����� �������
ALTER TABLE Haircut
ADD CONSTRAINT PK_Haircut_HaircutID PRIMARY KEY CLUSTERED (HaircutID)
GO

--������� 30 ������ �������
INSERT INTO Haircut (HaircutName, Gender) VALUES
('Cetrizine', 'Male'),
('Sodium', 'Male'),
('Lamotrigine', 'Agender'),
('ATORVASTATIN', 'Polygender'),
('Perfecting', 'Non-binary'),
('Control', 'Female'),
('Pleo Ut', 'Genderfluid'),
('Saccharate', 'Genderqueer'),
('Colgate', 'Agender'),
('VITA', 'Non-binary'),
('Metronidazole', 'Agender'),
('Amitiza', 'Male'),
('phosphate', 'Agender'),
('BSS', 'Male'),
('Mononitrate', 'Genderfluid'),
('Island', 'Non-binary'),
('Bitartrate', 'Bigender'),
('Nitrofurantion', 'Genderqueer'),
('Hand', 'Female'),
('Luoride Rinse', 'Genderqueer'),
('metoprolol', 'Bigender'),
('Hand', 'Agender'),
('LOreal', 'Bigender'),
('IMIPRAMINE', 'Genderfluid'),
('Hives - Rashes', 'Female'),
('Dr. Cocoa', 'Polygender'),
('Privet Pollen', 'Bigender'),
('Glyburide', 'Polygender'),
('PredniSONE', 'Bigender'),
('meloxicam', 'Male');
GO

--�������� �������� �������
SELECT TOP (30)
HaircutName,
Gender,
HaircutID
  FROM Haircut
GO

--��������� ������� �������
TRUNCATE TABLE Haircut
GO