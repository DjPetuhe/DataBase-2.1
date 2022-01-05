USE [pdr_fix]
GO

--Функція, що виводить інформацію про конкретного поліцейського
CREATE FUNCTION getInfoAboutPoliceman(@PassportNumberPoliceOfficer varchar(14))
RETURNS TABLE
AS
RETURN (
SELECT [Name] as [Police officer name], Surname AS [Police officer surname], PhoneNumber AS [Police officer phone number], FK_PK_PassportNumber AS [Police officer passport number], Rang
FROM PoliceOfficer
JOIN Person ON PoliceOfficer.FK_PK_PassportNumber = Person.PassportNumber
WHERE PoliceOfficer.FK_PK_PassportNumber=@PassportNumberPoliceOfficer
)
GO

SELECT * FROM getInfoAboutPoliceman('06041773-50754')

--Функція, що виводить повну інформацію про правопорушення за його ID
CREATE FUNCTION getInfoAboutIncident(@IncidentID int)
RETURNS TABLE
AS
RETURN (
SELECT Brand AS [Car brand], Model AS [Car model], CarNumber, Color AS [Car color], [Name] AS [Violator Name], 
Surname AS [Violator Surname], PhoneNumber AS [Violator phone number], PassportNumber AS [Violator passport number],
ViolationsName AS [Violation], Cost AS [Penalty], IncidentDescription
FROM ViolantDuringIncident
JOIN Person ON ViolantDuringIncident.FK_ViolatorPassportNumber = Person.PassportNumber
JOIN Car ON ViolantDuringIncident.FK_CarID = Car.CarID
JOIN ResolutionOnFine ON ViolantDuringIncident.ViolantDuringIncidentID = ResolutionOnFine.FK_PK_ViolantDuringIncidentID
JOIN Violation ON ResolutionOnFine.FK_ViolationID = Violation.ViolationsID
JOIN Penalty ON Violation.ViolationsID = Penalty.FK_ViolationsID AND ViolantDuringIncident.DateOfViolation = Penalty.CostDate
JOIN IncidentReport ON ViolantDuringIncident.FK_IncidentID = IncidentReport.IncidentID
WHERE IncidentID = @IncidentID)
GO

SELECT * FROM getInfoAboutIncident(1)

--Функція, що виводить поліцейский участок та звіти, що до нього відносятся
CREATE FUNCTION getInfoAboutPoliceDepartment(@DepartmentID int)
RETURNS TABLE
AS
RETURN (
SELECT NumberOfDepartment, City, Street, HouseNumber, PoliceDepartmentID, IncidentDescription, IncidentID
FROM PoliceDepartment
JOIN PoliceOfficer ON PoliceOfficer.FK_PoliceDepartmentID = PoliceDepartment.PoliceDepartmentID
JOIN IncidentReport ON IncidentReport.FK_PoliceOfficerPassportNumber = PoliceOfficer.FK_PK_PassportNumber
WHERE @DepartmentID=PoliceDepartmentID)
GO

SELECT * FROM getInfoAboutPoliceDepartment(5)

--Виведення цін за порушення протягом заданого періоду
CREATE FUNCTION getPenaltiesInDataRange(@FromDate date, @ToDate date)
RETURNS TABLE
AS
RETURN (SELECT ViolationsName, Cost, CostDate FROM Penalty
JOIN Violation ON ViolationsID=Fk_ViolationsID
WHERE CostDate >= @FromDate AND CostDate <= @ToDate)
GO

SELECT * FROM getPenaltiesInDataRange('2021-12-22', '2021-12-25')

--Топ виборка найдорожчих порушень
CREATE FUNCTION getTopOfTheMostExpensiveViolations(@numberViolations int)
RETURNS TABLE
AS
RETURN (
SELECT TOP (@numberViolations) ViolationsID, MAX(Cost) MaxCost
FROM Violation
JOIN Penalty ON Violation.ViolationsID = Penalty.FK_ViolationsID
GROUP BY ViolationsID
ORDER BY MaxCost DESC)
GO

SELECT * FROM getTopOfTheMostExpensiveViolations(5)

--Процедури

--Процедура, що дозволяє додавати інформацію про авто та вивести список всіх авто
CREATE PROC addCarInfo
  @brand nvarchar(30),
  @model nvarchar(30),
  @carNumber nvarchar(20),
  @color nvarchar(20)
AS
BEGIN
  INSERT INTO Car(Brand,Model,CarNumber,Color)
  VALUES(@brand,@model,@carNumber,@color)
  SELECT * FROM Car
END
GO

EXEC addCarInfo 'Mitsu','Lancer','AI0990KP', 'white'

--Процедура, що показує всіх поліцейських певного департаменту, які створювали репорти
CREATE PROC reportsOfOfficers
  @departmentId int
AS
BEGIN
  SELECT Rang, Surname, Name, @departmentId as Department FROM PoliceOfficer
  JOIN IncidentReport ON IncidentReport.FK_PoliceOfficerPassportNumber = PoliceOfficer.FK_PK_PassportNumber
  JOIN Person on Person.PassportNumber = PoliceOfficer.FK_PK_PassportNumber
  where PoliceOfficer.FK_PoliceDepartmentID = @departmentId 
END
GO

EXEC reportsOfOfficers 5