USE [TrailerRepair]
GO

CREATE TABLE [dbo].[Mechanic](
	[Name] [nvarchar](50) NOT NULL,
	[SurName] [nvarchar](50) NOT NULL,
	[Experience] [int] NOT NULL,
	[GarageID] [int] NOT NULL,
	[MechID] [int] IDENTITY(1,1)
)
GO

ALTER TABLE TrailerRepair.dbo.Mechanic
ADD CONSTRAINT PK_Mechanic_MechID PRIMARY KEY CLUSTERED (MechID)
GO

ALTER TABLE TrailerRepair.dbo.Mechanic
WITH CHECK ADD CONSTRAINT FK_Mechanic_GarageID FOREIGN KEY (GarageID)
REFERENCES Garage (GarageID)
ON UPDATE CASCADE
GO

TRUNCATE TABLE TrailerRepair.dbo.Mechanic
GO

DROP TABLE TrailerRepair.dbo.Mechanic
GO