USE [pdr_fix]
GO

--Тригер що при видаленні поліцейського департаменту зробить NULL поля поліцейських з номером цього департаменту
CREATE TRIGGER nullDepartmentId
ON PoliceDepartment
INSTEAD OF DELETE
AS
BEGIN
  DECLARE @deletedDepartmentId int = (SELECT PoliceDepartmentId FROM deleted)
  UPDATE PoliceOfficer 
  SET FK_PoliceDepartmentID = NULL 
  WHERE FK_PoliceDepartmentID = @deletedDepartmentId
  DELETE FROM PoliceDepartment WHERE PoliceDepartmentID = @deletedDepartmentId
END
GO

--Тригер, що перевіряє, чи дата видачі менше за дату закінчення документу
CREATE TRIGGER OnInsertDriverLicense
ON DriverLicense
INSTEAD OF INSERT
AS 
BEGIN
  DECLARE @IssuedBy nvarchar(50)
  DECLARE @DateOfIssue date
  DECLARE @EndDate date
  DECLARE @LicenseID varchar(9)
  DECLARE @FK_PassportNumber varchar(14)

  DECLARE curs CURSOR LOCAL FOR
    SELECT IssuedBy, DateOfIssue, EndDate, LicenseID, FK_PassportNumber FROM inserted
  OPEN curs
  FETCH NEXT FROM curs INTO @IssuedBy, @DateOfIssue, @EndDate, @LicenseID, @FK_PassportNumber
  WHILE @@FETCH_STATUS = 0
  BEGIN 
    IF @DateOfIssue < @EndDate
      INSERT DriverLicense(IssuedBy, DateOfIssue, EndDate, LicenseID, FK_PassportNumber) values (@IssuedBy, @DateOfIssue, @EndDate, @LicenseID, @FK_PassportNumber)
  ELSE THROW 50005, N'Error! Date of issue is less than EndDate', 1;
    FETCH NEXT FROM curs INTO @IssuedBy, @DateOfIssue, @EndDate, @LicenseID, @FK_PassportNumber
  END
  CLOSE curs
  DEALLOCATE curs
END
GO
