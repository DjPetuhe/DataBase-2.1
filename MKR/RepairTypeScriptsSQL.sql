USE [TrailerRepair]
GO

CREATE TABLE [dbo].[RepairType](
	[RepairName] [nvarchar](50) NOT NULL,
	[RepairTypeID] [int] IDENTITY(1,1)
)
GO

ALTER TABLE TrailerRepair.dbo.RepairType
ADD CONSTRAINT PK_RepairType_RepairTypeID PRIMARY KEY CLUSTERED (RepairTypeID)
GO

TRUNCATE TABLE TrailerRepair.dbo.RepairType
GO

DROP TABLE TrailerRepair.dbo.RepairType
GO
