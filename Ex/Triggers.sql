USE [uni_Dchoose]
GO

CREATE TRIGGER OnInsertÑhoose
ON ChooseHistory
INSTEAD OF INSERT
AS BEGIN
  DECLARE @dID int
  DECLARE @sID int
  DECLARE @y date
  DECLARE curs CURSOR LOCAL FOR
    SELECT FK_StudentID, FK_DisciplineID, Year FROM inserted
  OPEN curs
  FETCH NEXT FROM curs INTO @dID, @sID, @y
  WHILE @@FETCH_STATUS = 0
  BEGIN 
    IF (((SELECT count(*) FROM inserted WHERE @dID = FK_DisciplineID) >= 25) AND ((SELECT count(*) FROM [Catalog] WHERE @dID = [Catalog].FK_DisciplineID AND @sID = [Catalog].FK_StudentID AND @y = [Catalog].[Year]) > 0) AND (SELECT count(*) FROM [CanceledDiscipline] WHERE @dID = CanceledDiscipline.FK_DisciplineID AND @y = CanceledDiscipline.[Year]) = 0)
	BEGIN
		INSERT ChooseHistory(FK_DisciplineID, FK_StudentID, [Year]) values (@dID, @sID, @y)
	END
  ELSE
  BEGIN
	IF ((SELECT count(*) FROM [CanceledDiscipline] WHERE @dID = CanceledDiscipline.FK_DisciplineID AND @y = CanceledDiscipline.[Year]) = 0)
	BEGIN
		INSERT CanceledDiscipline(FK_DisciplineID, [Year]) values (@dID, @y)
	END
  END
    FETCH NEXT FROM curs INTO @dID, @sID, @y
  END
  CLOSE curs
  DEALLOCATE curs
END
GO