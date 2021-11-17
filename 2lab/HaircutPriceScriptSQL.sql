USE [Barbershop]
GO

--�������� ������� ��� �� �������
CREATE TABLE [dbo].[HaircutPrice](
	[HaircutID] [int] NOT NULL,
	[Price] [money] NOT NULL,
	[Date] [date] NOT NULL
)
GO

--����������� �� ������� ���� �������
ALTER TABLE HaircutPrice
WITH CHECK ADD CONSTRAINT FK_HaircutPrice_Haircut FOREIGN KEY(HaircutID)
REFERENCES Haircut (HaircutID)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

--����������� ����������� ���� �� ���������
ALTER TABLE HaircutPrice
ADD CONSTRAINT DF_HaircutPrice_Date DEFAULT (getdate()) FOR [Date]
GO

--������� 30 ��� �� 3 ������ ����
INSERT INTO HaircutPrice (HaircutID, Price, [Date]) VALUES
(1, '$69.50', '11/14/2021'),
(2, '$77.58', '11/14/2021'),
(3, '$76.74', '11/14/2021'),
(4, '$75.65', '11/14/2021'),
(5, '$50.18', '11/14/2021'),
(6, '$73.05', '11/14/2021'),
(7, '$62.67', '11/14/2021'),
(8, '$77.45', '11/14/2021'),
(9, '$63.30', '11/14/2021'),
(10, '$78.61', '11/14/2021'),
(11, '$56.88', '11/14/2021'),
(12, '$97.42', '11/14/2021'),
(13, '$78.98', '11/14/2021'),
(14, '$55.00', '11/14/2021'),
(15, '$75.44', '11/14/2021'),
(16, '$52.60', '11/14/2021'),
(17, '$75.84', '11/14/2021'),
(18, '$75.93', '11/14/2021'),
(19, '$73.26', '11/14/2021'),
(20, '$51.49', '11/14/2021'),
(21, '$78.39', '11/14/2021'),
(22, '$72.75', '11/14/2021'),
(23, '$73.16', '11/14/2021'),
(24, '$62.20', '11/14/2021'),
(25, '$92.78', '11/14/2021'),
(26, '$69.86', '11/14/2021'),
(27, '$54.78', '11/14/2021'),
(28, '$66.74', '11/14/2021'),
(29, '$97.18', '11/14/2021'),
(30, '$57.63', '11/14/2021'),
(1, '$66.61', '11/15/2021'),
(2, '$51.72', '11/15/2021'),
(3, '$87.64', '11/15/2021'),
(4, '$52.67', '11/15/2021'),
(5, '$96.29', '11/15/2021'),
(6, '$56.13', '11/15/2021'),
(7, '$64.78', '11/15/2021'),
(8, '$78.20', '11/15/2021'),
(9, '$88.55', '11/15/2021'),
(10, '$59.53', '11/15/2021'),
(11, '$95.39', '11/15/2021'),
(12, '$55.61', '11/15/2021'),
(13, '$91.63', '11/15/2021'),
(14, '$87.28', '11/15/2021'),
(15, '$61.60', '11/15/2021'),
(16, '$87.88', '11/15/2021'),
(17, '$83.65', '11/15/2021'),
(18, '$80.73', '11/15/2021'),
(19, '$86.05', '11/15/2021'),
(20, '$87.81', '11/15/2021'),
(21, '$52.94', '11/15/2021'),
(22, '$92.93', '11/15/2021'),
(23, '$81.06', '11/15/2021'),
(24, '$76.12', '11/15/2021'),
(25, '$71.93', '11/15/2021'),
(26, '$86.40', '11/15/2021'),
(27, '$71.97', '11/15/2021'),
(28, '$81.36', '11/15/2021'),
(29, '$51.14', '11/15/2021'),
(30, '$93.17', '11/15/2021'),
(1, '$88.70', '11/16/2021'),
(2, '$92.82', '11/16/2021'),
(3, '$94.67', '11/16/2021'),
(4, '$96.81', '11/16/2021'),
(5, '$66.49', '11/16/2021'),
(6, '$57.00', '11/16/2021'),
(7, '$62.82', '11/16/2021'),
(8, '$85.25', '11/16/2021'),
(9, '$77.75', '11/16/2021'),
(10, '$80.26', '11/16/2021'),
(11, '$86.18', '11/16/2021'),
(12, '$63.80', '11/16/2021'),
(13, '$73.29', '11/16/2021'),
(14, '$63.26', '11/16/2021'),
(15, '$92.91', '11/16/2021'),
(16, '$54.02', '11/16/2021'),
(17, '$51.55', '11/16/2021'),
(18, '$57.06', '11/16/2021'),
(19, '$60.01', '11/16/2021'),
(20, '$60.76', '11/16/2021'),
(21, '$51.97', '11/16/2021'),
(22, '$55.51', '11/16/2021'),
(23, '$89.50', '11/16/2021'),
(24, '$81.07', '11/16/2021'),
(25, '$87.70', '11/16/2021'),
(26, '$56.37', '11/16/2021'),
(27, '$65.76', '11/16/2021'),
(28, '$66.75', '11/16/2021'),
(29, '$92.65', '11/16/2021'),
(30, '$99.74', '11/16/2021');
GO

--�������� �������� ��� �� �������
SELECT TOP (90)
HaircutID,
Price,
[Date]
  FROM HaircutPrice
GO

--��������� �������� ��� �� �������
TRUNCATE TABLE Haircut
GO