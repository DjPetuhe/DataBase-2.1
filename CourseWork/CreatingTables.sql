USE [pdr_fix]
GO

--Створення таблиці "ЛЮДИНА"

CREATE TABLE [dbo].[Person](
	[Name] [nvarchar](50) NOT NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[Patronymic] [nvarchar](50) NULL,
	[PhoneNumber] [varchar](50) NULL UNIQUE,
	[PassportNumber] [varchar](14) NOT NULL PRIMARY KEY CLUSTERED
)
GO

ALTER TABLE [dbo].[Person]
ADD CONSTRAINT CHK_PersonName
CHECK ([Name] LIKE '%[A-Za-z]%' AND [Name] NOT LIKE '%[^A-Za-z-]%')
GO

ALTER TABLE [dbo].[Person]
ADD CONSTRAINT CHK_PersonSurname
CHECK ([Surname] LIKE '%[A-Za-z]%' AND [Surname] NOT LIKE '%[^A-Za-z'' -]%')
GO

ALTER TABLE [dbo].[Person]
ADD CONSTRAINT CHK_PersonPatronymic
CHECK ([Patronymic] LIKE '%[A-Za-z]%' AND [Patronymic] NOT LIKE '%[^A-Za-z'' -]%')
GO

ALTER TABLE [dbo].[Person]
ADD CONSTRAINT CHK_PersonPhoneNumber
CHECK ([PhoneNumber] LIKE '+380%' AND PhoneNumber NOT LIKE '%[a-Z]%')
GO

ALTER TABLE [dbo].[Person]
ADD CONSTRAINT CHK_PersonPassportNumber
CHECK ([PassportNumber] LIKE '%-%' AND [PassportNumber] NOT LIKE '%[a-Z]%')
GO

--Створення таблиці "Водійське посвідчення"
CREATE TABLE [dbo].[DriverLicense](
	[IssuedBy] [nvarchar](50) NOT NULL,
	[DateOfIssue] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[LicenseID] [varchar](9) NOT NULL PRIMARY KEY CLUSTERED,
	[FK_PassportNumber] [varchar](14) NOT NULL
)
GO

ALTER TABLE [dbo].[DriverLicense]
WITH CHECK ADD CONSTRAINT FK_DriverLicense_PassportNumber FOREIGN KEY ([FK_PassportNumber])
REFERENCES [dbo].[Person]([PassportNumber])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[DriverLicense]
ADD CONSTRAINT CHK_FK_PassportNumber
CHECK ([FK_PassportNumber] LIKE '%-%' AND [FK_PassportNumber] NOT LIKE '%[a-Z]%')
GO

--Створення таблиці "Поліцейське відділення"
CREATE TABLE [dbo].[PoliceDepartment](
	[NumberOfDepartment] [int] NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[Street] [nvarchar](50) NOT NULL,
	[HouseNumber] [varchar](50) NOT NULL,
	[PoliceDepartmentID] [int] IDENTITY(1,1) PRIMARY KEY CLUSTERED
)
GO

ALTER TABLE [dbo].[PoliceDepartment]
ADD CONSTRAINT CHK_NumberOfDepartment
CHECK ([NumberOfDepartment] LIKE '%[0-9]%' AND [NumberOfDepartment] NOT LIKE '%[a-Z]%')
GO

ALTER TABLE [dbo].[PoliceDepartment]
ADD CONSTRAINT CHK_City
CHECK ([City] LIKE '%[^0-9]%')
GO

ALTER TABLE [dbo].[PoliceDepartment]
ADD CONSTRAINT CHK_Street
CHECK ([Street] LIKE '%[^0-9]%')
GO

ALTER TABLE [dbo].[PoliceDepartment]
ADD CONSTRAINT CHK_HouseNumber
CHECK ([HouseNumber] LIKE '%[0-9]%')
GO

--Створення таблиці "Автомобіль"
CREATE TABLE [dbo].[Car](
	[Brand] [nvarchar](50) NOT NULL,
	[Model] [nvarchar](50) NOT NULL,
	[CarNumber] [nvarchar](20) NOT NULL,
	[Color] [nvarchar](50) NOT NULL,
	[CarID] [int] IDENTITY(1,1) PRIMARY KEY CLUSTERED
)
GO

ALTER TABLE [dbo].[Car]
ADD CONSTRAINT CHK_Color
CHECK ([Color] LIKE '%[A-Za-z]%' AND [Color] NOT LIKE '%[^A-Za-z-]%')
GO

--Створення таблиці "Порушення"
CREATE TABLE [dbo].[Violation](
	[ViolationsName] [nvarchar](50) NOT NULL,
	[ViolationsID] [int] IDENTITY(1,1) PRIMARY KEY CLUSTERED
)
GO

--Створення таблиці "Штраф"
CREATE TABLE [dbo].[Penalty](
	[FK_ViolationsID] [int] NOT NULL,
	[Cost] [money] NOT NULL,
	[CostDate] [date] NOT NULL
)
GO

ALTER TABLE [dbo].[Penalty]
WITH CHECK ADD CONSTRAINT FK_Penalty_ViolationsID FOREIGN KEY ([FK_ViolationsID])
REFERENCES [dbo].[Violation]([ViolationsID])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Penalty]
WITH CHECK ADD CONSTRAINT PK_Penalty PRIMARY KEY CLUSTERED ([FK_ViolationsID], [CostDate])
GO

ALTER TABLE [dbo].[Penalty]
ADD CONSTRAINT DF_Penalty_CostDate DEFAULT (getdate()) FOR [CostDate]
GO

ALTER TABLE [dbo].[Penalty]
ADD CONSTRAINT CHK_Cost
CHECK ([Cost] > 0)
GO

--Створення таблиці "Поліцейський"
CREATE TABLE [dbo].[PoliceOfficer](
	[FK_PK_PassportNumber] [varchar](14) NOT NULL,
	[Rang] [nvarchar](50) NOT NULL,
	[FK_PoliceDepartmentID] [int] NULL
)
GO

ALTER TABLE [dbo].[PoliceOfficer]
WITH CHECK ADD CONSTRAINT FK_PoliceOfficer_PassportNumber FOREIGN KEY ([FK_PK_PassportNumber])
REFERENCES [dbo].[Person]([PassportNumber])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[PoliceOfficer]
WITH CHECK ADD CONSTRAINT FK_PoliceOfficer_PoliceDepartmentID FOREIGN KEY ([FK_PoliceDepartmentID])
REFERENCES [dbo].[PoliceDepartment]([PoliceDepartmentID])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[PoliceOfficer]
WITH CHECK ADD CONSTRAINT PK_PoliceOfficer_PassportNumber PRIMARY KEY CLUSTERED ([FK_PK_PassportNumber])
GO

ALTER TABLE [dbo].[PoliceOfficer]
ADD CONSTRAINT CHK_FK_PK_PassportNumber
CHECK ([FK_PK_PassportNumber] LIKE '%-%' AND [FK_PK_PassportNumber] NOT LIKE '%[a-Z]%')
GO

--Створення таблиці "Звіт про інцидент на дорозі"
CREATE TABLE [dbo].[IncidentReport](
	[IncidentDescription] [nvarchar](max) NOT NULL,
	[FK_PoliceOfficerPassportNumber] [varchar](14) NOT NULL,
	[IncidentID] [int] IDENTITY(1,1) PRIMARY KEY CLUSTERED
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[IncidentReport]
WITH CHECK ADD CONSTRAINT FK_IncidentReport_PoliceOfficerPassportNumber FOREIGN KEY ([FK_PoliceOfficerPassportNumber])
REFERENCES [dbo].[PoliceOfficer]([FK_PK_PassportNumber])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[IncidentReport]
ADD CONSTRAINT CHK_FK_PoliceOfficerPassportNumber
CHECK ([FK_PoliceOfficerPassportNumber] LIKE '%-%' AND [FK_PoliceOfficerPassportNumber] NOT LIKE '%[a-Z]%')
GO

ALTER TABLE [dbo].[PoliceOfficer] 
ALTER COLUMN [FK_PoliceDepartmentID] INT NULL

--Створення таблиці "Свідок інцицденту"

CREATE TABLE [dbo].[IncidentWitness](
	[FK_IncidentID] [int] NOT NULL,
	[FK_PassportNumber] [varchar](14) NOT NULL
)
GO

ALTER TABLE [dbo].[IncidentWitness]
WITH CHECK ADD CONSTRAINT FK_IncidentWitness_PassportNumber FOREIGN KEY ([FK_PassportNumber])
REFERENCES [dbo].[Person]([PassportNumber])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[IncidentWitness]
WITH CHECK ADD CONSTRAINT FK_IncidentWitness_IncidentID FOREIGN KEY ([FK_IncidentID])
REFERENCES [dbo].[IncidentReport]([IncidentID])
GO

ALTER TABLE [dbo].[IncidentWitness]
WITH CHECK ADD CONSTRAINT PK_IncidentWitness PRIMARY KEY CLUSTERED ([FK_IncidentID], [FK_PassportNumber])
GO

ALTER TABLE [dbo].[IncidentWitness]
ADD CONSTRAINT CHK_IncidentWitness_FK_PassportNumber
CHECK ([FK_PassportNumber] LIKE '%-%' AND [FK_PassportNumber] NOT LIKE '%[a-Z]%')
GO

--Створення таблиці "Постраждалий від іницдента"
CREATE TABLE [dbo].[IncidentVictim](
	[FK_IncidentID] [int] NOT NULL,
	[FK_PassportNumber] [varchar](14) NOT NULL,
	[DamageDegree] [nvarchar](50) NOT NULL
)
GO

ALTER TABLE [dbo].[IncidentVictim]
WITH CHECK ADD CONSTRAINT FK_IncidentVictim_PassportNumber FOREIGN KEY ([FK_PassportNumber])
REFERENCES [dbo].[Person]([PassportNumber])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[IncidentVictim]
WITH CHECK ADD CONSTRAINT FK_IncidentVictim_IncidentID FOREIGN KEY ([FK_IncidentID])
REFERENCES [dbo].[IncidentReport]([IncidentID])
GO

ALTER TABLE [dbo].[IncidentVictim]
WITH CHECK ADD CONSTRAINT PK_IncidentVictim PRIMARY KEY CLUSTERED ([FK_IncidentID], [FK_PassportNumber])
GO

ALTER TABLE [dbo].[IncidentVictim]
ADD CONSTRAINT CHK_IncidentVictim_FK_PassportNumber
CHECK ([FK_PassportNumber] LIKE '%-%' AND [FK_PassportNumber] NOT LIKE '%[a-Z]%')
GO

--Створення таблиці "Постраждалий від іницдента"
CREATE TABLE [dbo].[ViolantDuringIncident](
	[FK_CarID] [int] NOT NULL,
	[FK_ViolatorPassportNumber] [varchar](14) NOT NULL,
	[FK_IncidentID] [int] NOT NULL,
	[DateOfViolation] [date] NOT NULL,
	[ViolantDuringIncidentID] [int] IDENTITY(1,1) PRIMARY KEY CLUSTERED
)
GO

ALTER TABLE [dbo].[ViolantDuringIncident]
ADD CONSTRAINT CHK_ViolantDuringIncident_FK_ViolatorPassportNumber
CHECK ([FK_ViolatorPassportNumber] LIKE '%-%' AND [FK_ViolatorPassportNumber] NOT LIKE '%[a-Z]%')
GO

ALTER TABLE [dbo].[ViolantDuringIncident]
WITH CHECK ADD CONSTRAINT FK_ViolantDuringIncident_CarID FOREIGN KEY ([FK_CarID])
REFERENCES [dbo].[Car]([CarID])
GO

ALTER TABLE [dbo].[ViolantDuringIncident]
WITH CHECK ADD CONSTRAINT FK_ViolantDuringIncident_ViolatorPassportNumber FOREIGN KEY ([FK_ViolatorPassportNumber])
REFERENCES [dbo].[Person]([PassportNumber])
GO

ALTER TABLE [dbo].[ViolantDuringIncident]
WITH CHECK ADD CONSTRAINT FK_ViolantDuringIncident_IncidentID FOREIGN KEY ([FK_IncidentID])
REFERENCES [dbo].[IncidentReport]([IncidentID])
GO

--Створення таблиці "Постанова про штраф"
CREATE TABLE [dbo].[ResolutionOnFine](
	[FK_ViolationID] int NOT NULL,
	[FK_PoliceOfficerPassportNumber] varchar(14) NOT NULL,
	[FK_PK_ViolantDuringIncidentID] int NOT NULL
)
GO

ALTER TABLE [dbo].[ResolutionOnFine]
WITH CHECK ADD CONSTRAINT FK_ResolutionOnFine_ViolationID FOREIGN KEY ([FK_ViolationID])
REFERENCES [dbo].[Violation]([ViolationsID])
GO

ALTER TABLE [dbo].[ResolutionOnFine]
WITH CHECK ADD CONSTRAINT FK_ResolutionOnFine_PoliceOfficerPassportNumber FOREIGN KEY ([FK_PoliceOfficerPassportNumber])
REFERENCES [dbo].[PoliceOfficer]([FK_PK_PassportNumber])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[ResolutionOnFine]
WITH CHECK ADD CONSTRAINT FK_ResolutionOnFine_ViolantDuringIncidentID FOREIGN KEY ([FK_PK_ViolantDuringIncidentID])
REFERENCES [dbo].[ViolantDuringIncident]([ViolantDuringIncidentID])
GO

ALTER TABLE [dbo].[ResolutionOnFine]
ADD CONSTRAINT CHK_ResolutionOnFine_FK_PoliceOfficerPassportNumber
CHECK ([FK_PoliceOfficerPassportNumber] LIKE '%-%' AND [FK_PoliceOfficerPassportNumber] NOT LIKE '%[a-Z]%')
GO

ALTER TABLE [dbo].[ResolutionOnFine]
WITH CHECK ADD CONSTRAINT PK_ResolutionOnFine_VialantDuringIncidentID PRIMARY KEY CLUSTERED ([FK_PK_ViolantDuringIncidentID] )
GO
