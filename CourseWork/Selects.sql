USE [pdr_fix]
GO

--�����, �� �������� ������� ����� �� ���������
SELECT SUM(Cost) / Cast(Count(Cost) AS float) AS [average penalty], ViolationsID
FROM Violation, Penalty
WHERE Violation.ViolationsID = Penalty.FK_ViolationsID
GROUP BY ViolationsID
GO

--�����, �� �������� ������� �����, �� ����� ������� ����������
SELECT ((SELECT count(*) FROM Person_With_License) / cast(count(*) AS float)) * 100  AS [Percentage of persons have driver license]
FROM Person
GO

--�����, �� �������� ������� �����, �� ����� ������� ����������
SELECT ((SELECT count(*) FROM Police_Persons) / cast(count(*) AS float)) * 100  AS [Percentage of police persons]
FROM Person
GO

--�����, �� ��������� ���������� ��� �������� ����� �� �����������, �� �� ��� ���������
SELECT NumberOfDepartment, City, Street, HouseNumber, PoliceDepartmentID, Rang, FK_PK_PassportNumber
FROM PoliceDepartment
JOIN PoliceOfficer ON PoliceDepartment.PoliceDepartmentID = PoliceOfficer.FK_PoliceDepartmentID
ORDER BY PoliceDepartmentID
GO

--�����, �� �������� ����� ���������� ��� �����������
SELECT [Name] as [Police officer name], Surname AS [Police officer surname], PhoneNumber AS [Police officer phone number], FK_PK_PassportNumber AS [Police officer passport number], Rang
FROM PoliceOfficer
JOIN Person ON PoliceOfficer.FK_PK_PassportNumber = Person.PassportNumber
GO

--�����, �� �������� �������� �� ���� �����
SELECT IncidentDescription, FK_PoliceOfficerPassportNumber, IncidentID, [Name] AS [Witness Name], Surname AS [Witness Surname], PhoneNumber AS [Witness phone number], PassportNumber AS [Witness passport number]
FROM IncidentReport
JOIN IncidentWitness ON IncidentReport.IncidentID = IncidentWitness.FK_IncidentID
JOIN Person ON IncidentWitness.FK_PassportNumber = Person.PassportNumber
GO

--�����, �� �������� �������� �� ������������ �� �����
SELECT IncidentDescription, FK_PoliceOfficerPassportNumber, IncidentID, [Name] AS [Victim Name], Surname AS [Victim Surname], PhoneNumber AS [Victim phone number], PassportNumber AS [Victim passport number]
FROM IncidentReport
JOIN IncidentVictim ON IncidentReport.IncidentID = IncidentVictim.FK_IncidentID
JOIN Person ON IncidentVictim.FK_PassportNumber = Person.PassportNumber
GO

--�����, �� �������� �������� ������� �� ����, �� �� ��� ���������
SELECT NumberOfDepartment, City, Street, HouseNumber, PoliceDepartmentID, IncidentDescription, IncidentID
FROM PoliceDepartment
JOIN PoliceOfficer ON PoliceOfficer.FK_PoliceDepartmentID = PoliceDepartment.PoliceDepartmentID
JOIN IncidentReport ON IncidentReport.FK_PoliceOfficerPassportNumber = PoliceOfficer.FK_PK_PassportNumber
GO

 --�����, �� �������� ������ ����������� � ������� �������
SELECT PoliceDepartmentID, count(FK_PK_PassportNumber)
FROM Department_And_PoliceOfficers
GROUP BY PoliceDepartmentID
GO

--�����, �� �������� ������� ������������ � ������� ���������
SELECT IncidentID, count(FK_PassportNumber)
FROM Incedent_And_Victims
GROUP BY IncidentID
GO

--�����, �� �������� ������� ����� � ������� ���������
SELECT IncidentID, count(FK_PassportNumber)
FROM Incedent_And_Witnesses
GROUP BY IncidentID
GO

--�����, �� �������� �������� ������, �� ����-������ ���� �� �������� ���������
SELECT ViolationsID, MAX(Cost)
FROM Violation
JOIN Penalty ON Violation.ViolationsID = Penalty.FK_ViolationsID
GROUP BY ViolationsID
GO

--�����, �� �������� ��������� ������, �� ����-������ ���� �� �������� ���������
SELECT ViolationsID, MIN(Cost)
FROM Violation
JOIN Penalty ON Violation.ViolationsID = Penalty.FK_ViolationsID
GROUP BY ViolationsID
GO

--�����, �� �������� ������ � ���� ���� ��������� �����
SELECT [Name] AS [Violator name], Surname AS [Violator surname], PassportNumber, Penalty.Cost
FROM ViolantDuringIncident
JOIN Person ON ViolantDuringIncident.FK_ViolatorPassportNumber = Person.PassportNumber
JOIN ResolutionOnFine ON ViolantDuringIncident.FK_IncidentID = ResolutionOnFine.FK_PK_ViolantDuringIncidentID
JOIN Violation ON ResolutionOnFine.FK_ViolationID = Violation.ViolationsID
JOIN Penalty ON ViolantDuringIncident.DateOfViolation = Penalty.CostDate AND ResolutionOnFine.FK_ViolationID = Penalty.FK_ViolationsID
ORDER BY Penalty.Cost DESC
GO

--�����, �� �������� ������������ �� ���, ���� �� ������ �����
SELECT FK_PoliceOfficerPassportNumber, [Name] AS [Violators Name], Surname AS [Violators surname], FK_ViolatorPassportNumber
FROM ResolutionOnFine
JOIN ViolantDuringIncident ON ResolutionOnFine.FK_PK_ViolantDuringIncidentID = ViolantDuringIncident.ViolantDuringIncidentID
JOIN Person ON ViolantDuringIncident.FK_ViolatorPassportNumber = Person.PassportNumber
GO

--�����, �� �������� ������������ �� ���, ��� ���� �� ����� ���
SELECT FK_PoliceOfficerPassportNumber, [Name] AS [Violators Name], Surname AS [Violators surname], FK_ViolatorPassportNumber
FROM IncidentReport
JOIN ViolantDuringIncident ON IncidentReport.IncidentID = ViolantDuringIncident.FK_IncidentID
JOIN Person ON ViolantDuringIncident.FK_ViolatorPassportNumber = Person.PassportNumber
GO

--�����, �� �������� ��� ����������, �� ����� ������ �����
SELECT [Name] AS [Police officer name], Surname AS [Police officer surname], FK_PassportNumber [Police officer passport number], LicenseID
FROM Person_With_License
JOIN PoliceOfficer ON PoliceOfficer.FK_PK_PassportNumber = Person_With_License.FK_PassportNumber
GO

--�����, �� �������� ����� ���������� ��� ��������������
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
GO