USE [TrailerRepair]
GO
CREATE TABLE [dbo].[Repair](
	[RepairDate] [date] NOT NULL,
	[MechID] [int] NOT NULL,
	[TrailerInventoryNumber] [int] NOT NULL,
	[RepairTypeID] [int] NOT NULL,
	[RepairID] [int] IDENTITY(1,1)
)
GO

ALTER TABLE TrailerRepair.dbo.Repair
ADD CONSTRAINT PK_Repair_RepairID PRIMARY KEY CLUSTERED (RepairID)
GO

ALTER TABLE TrailerRepair.dbo.Repair
WITH CHECK ADD CONSTRAINT FK_Repair_MechID FOREIGN KEY(MechID)
REFERENCES TrailerRepair.dbo.Mechanic (MechID)
ON UPDATE CASCADE
GO

ALTER TABLE TrailerRepair.dbo.Repair
WITH CHECK ADD CONSTRAINT FK_Repair_TrailerInventoryNumber FOREIGN KEY(TrailerInventoryNumber)
REFERENCES TrailerRepair.dbo.Trailer (InventoryNumber)
ON UPDATE CASCADE
GO

ALTER TABLE TrailerRepair.dbo.Repair
WITH CHECK ADD CONSTRAINT FK_Repair_RepairTypeID FOREIGN KEY(RepairTypeID)
REFERENCES TrailerRepair.dbo.RepairType (RepairTypeID)
ON UPDATE CASCADE
GO

TRUNCATE TABLE TrailerRepair.dbo.Repair
GO

DROP TABLE TrailerRepair.dbo.Repair
GO