USE [TrailerRepair]
GO
CREATE TABLE [dbo].[Garage](
	[GarageID] [int] IDENTITY(1,1)
)
GO

ALTER TABLE TrailerRepair.dbo.Garage
ADD CONSTRAINT PK_Garage_GarageID PRIMARY KEY CLUSTERED (GarageID)
GO

TRUNCATE TABLE TrailerRepair.dbo.Garage
GO

DROP TABLE TrailerRepair.dbo.Garage
GO