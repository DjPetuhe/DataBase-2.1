USE [TrailerRepair]
GO

CREATE TABLE [dbo].[Trailer](
	[Brand] [nvarchar](50) NOT NULL,
	[ManifactureDate] [date] NOT NULL,
	[InventoryNumber] [int] NOT NULL
)
GO

ALTER TABLE TrailerRepair.dbo.Trailer
ADD CONSTRAINT PK_Trailer_InventoryNumber PRIMARY KEY CLUSTERED (InventoryNumber)
GO

TRUNCATE TABLE TrailerRepair.dbo.Trailer
GO

DROP TABLE TrailerRepair.dbo.Trailer
GO