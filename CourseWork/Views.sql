USE [pdr_fix]
GO

--View для представлення людей, що мають водійське посвідчення.

CREATE VIEW Person_With_License AS
SELECT * 
FROM Person, DriverLicense
WHERE Person.PassportNumber = DriverLicense.FK_PassportNumber
GO

SELECT *
FROM Person_With_License
GO

DROP VIEW Person_With_License
GO

--View для представлення людей, які є поліцейскіми 

CREATE VIEW Police_Persons AS
SELECT * 
FROM Person, PoliceOfficer
WHERE Person.PassportNumber = PoliceOfficer.FK_PK_PassportNumber
GO

SELECT *
FROM Police_Persons
GO

DROP VIEW Police_Persons
GO

--View для представлення порушень, та динаміку штрафів на ніх

CREATE VIEW Violation_And_Penalties AS
SELECT ViolationsName, Cost, CostDate, ViolationsID
FROM Violation, Penalty
WHERE Violation.ViolationsID = Penalty.FK_ViolationsID
GO

SELECT *
FROM Violation_And_Penalties
GO

DROP VIEW Violation_And_Penalties
GO

--View для представлленя інформації про поліцейскі відділи та поліцейських, що до них відносятся
CREATE VIEW Department_And_PoliceOfficers AS
SELECT NumberOfDepartment, City, Street, HouseNumber, PoliceDepartmentID, Rang, FK_PK_PassportNumber
FROM PoliceDepartment
JOIN PoliceOfficer ON PoliceDepartment.PoliceDepartmentID = PoliceOfficer.FK_PoliceDepartmentID
GO

SELECT *
FROM Department_And_PoliceOfficers
GO

DROP VIEW Department_And_PoliceOfficers
GO

--View для представлленя інформації про всіх постраждалих та інцидентів з ними
CREATE VIEW Incedent_And_Victims AS
SELECT IncidentDescription, FK_PassportNumber, FK_PoliceOfficerPassportNumber, DamageDegree, IncidentID
FROM IncidentReport
JOIN IncidentVictim ON IncidentReport.IncidentID = IncidentVictim.FK_IncidentID
GO

SELECT *
FROM Incedent_And_Victims
GO

DROP VIEW Incedent_And_Victims
GO

--View для представлленя інформації про всіх свідків та інцідентів, які вони бачили
CREATE VIEW Incedent_And_Witnesses AS
SELECT IncidentDescription, FK_PassportNumber, FK_PoliceOfficerPassportNumber, IncidentID
FROM IncidentReport
JOIN IncidentWitness ON IncidentReport.IncidentID = IncidentWitness.FK_IncidentID
GO

SELECT *
FROM Incedent_And_Witnesses
GO

DROP VIEW Incedent_And_Witnesses
GO
