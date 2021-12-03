USE [TrailerRepair]
GO

--a task
SELECT TOP 1 TrailerRepair.dbo.Garage.GarageID, COUNT(*)
FROM TrailerRepair.dbo.Garage JOIN TrailerRepair.dbo.Mechanic ON TrailerRepair.dbo.Garage.GarageID = TrailerRepair.dbo.Mechanic.GarageID
JOIN TrailerRepair.dbo.Repair ON TrailerRepair.dbo.Mechanic.MechID = TrailerRepair.dbo.Repair.MechID
GROUP BY TrailerRepair.dbo.Garage.GarageID
ORDER BY COUNT(*) DESC
GO

--b task
SELECT TrailerRepair.dbo.Garage.GarageID
FROM TrailerRepair.dbo.Garage LEFT JOIN TrailerRepair.dbo.Mechanic ON TrailerRepair.dbo.Garage.GarageID = TrailerRepair.dbo.Mechanic.GarageID
WHERE MechID = NULL
GO

--c taks
SELECT TOP 1 TrailerRepair.dbo.Mechanic.MechID
FROM TrailerRepair.dbo.Mechanic JOIN TrailerRepair.dbo.Repair ON TrailerRepair.dbo.Mechanic.MechID = TrailerRepair.dbo.Repair.MechID
WHERE RepairDate < '2021-01-01' AND RepairDate > '2019-12-31'
GROUP BY TrailerRepair.dbo.Mechanic.MechID
ORDER BY COUNT(*) ASC
GO
