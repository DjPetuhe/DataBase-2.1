USE [uni_Dchoose]
GO

--a
SELECT *
FROM CanceledDiscipline
WHERE (DATEDIFF(YEAR, [Year], GETDATE()) = 1 AND [Year] < GETDATE())
GO

--b
DROP VIEW DisciplineChoosenYearBefore
GO

CREATE VIEW DisciplineChoosenYearBefore AS
SELECT DisciplineID, count(*) AS [Students choose]
FROM Discipline
JOIN ChooseHistory ON Discipline.DisciplineID = ChooseHistory.FK_DisciplineID
WHERE (DATEDIFF(YEAR, [Year], GETDATE()) = 1 AND [Year] < GETDATE()) AND Discipline.Semester = 6
GROUP BY DisciplineID
GO

SELECT TOP 1 *
FROM DisciplineChoosenYearBefore
ORDER BY [Students choose] DESC
GO

--c
DROP VIEW TeacherWithStudentsYoungCourses
GO

CREATE VIEW TeacherWithStudentsYoungCourses AS
SELECT TeachersID, count(*) AS [Students have]
FROM Teacher
JOIN Discipline ON Discipline.FK_TeachersID = TeachersID
JOIN ChooseHistory ON (ChooseHistory.FK_DisciplineID = Discipline.DisciplineID)
WHERE (DATEDIFF(YEAR, ChooseHistory.[Year], GETDATE()) = 0 AND ChooseHistory.[Year] < GETDATE() AND Discipline.Semester <= 4)
GROUP BY TeachersID
GO

SELECT TOP 1 *
FROM TeacherWithStudentsYoungCourses
ORDER BY [Students have] DESC
GO

--d
DROP VIEW StudentsWithAmountChoosenCanceled
GO

CREATE VIEW StudentsWithAmountChoosenCanceled AS
SELECT StudentID, count(*) [Choosen canceled]
FROM Student
JOIN ChooseHistory ON Student.StudentID = ChooseHistory.FK_StudentID
JOIN Discipline ON Discipline.DisciplineID = ChooseHistory.FK_DisciplineID
RIGHT JOIN CanceledDiscipline ON CanceledDiscipline.FK_DisciplineID = Discipline.DisciplineID
WHERE (DATEDIFF(YEAR, ChooseHistory.[Year], GETDATE()) = 1 AND ChooseHistory.[Year] < GETDATE())
GROUP BY StudentID
GO

SELECT TOP 1 *
FROM StudentsWithAmountChoosenCanceled
ORDER BY [Choosen canceled] DESC
GO
