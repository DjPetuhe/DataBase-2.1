USE [uni_Dchoose]
GO

DROP TABLE [uni_Dchoose].[dbo].[Catalog]
GO

DROP TABLE [uni_Dchoose].[dbo].[ChooseHistory]
GO

DROP TABLE [uni_Dchoose].[dbo].[CanceledDiscipline]
GO

DROP TABLE [uni_Dchoose].[dbo].[Discipline]
GO

DROP TABLE [uni_Dchoose].[dbo].[Student]
GO

DROP TABLE [uni_Dchoose].[dbo].[Teacher]
GO

DROP FUNCTION isWord
GO

CREATE FUNCTION isWord(@Word nvarchar(50))
RETURNS int
AS BEGIN
	DECLARE @is int
	SELECT @is = CASE WHEN (@Word LIKE '%[A-Za-z]%' AND @Word NOT LIKE '%[^A-Za-z-]%') THEN 1 ELSE 0 END
	RETURN @is
END
GO

CREATE TABLE [dbo].[Student](
	[Name] [nvarchar](50) NOT NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[Faculty] [nvarchar](50) NOT NULL,
	[Department] [nvarchar](50) NOT NULL,
	[Speciality] [nvarchar](50) NOT NULL,
	[Semester] [int] NOT NULL,
	[StudentID] [int] IDENTITY(1,1) PRIMARY KEY CLUSTERED
)
GO

ALTER TABLE [dbo].[Student]
ADD CONSTRAINT CHK_Student_Name
CHECK (dbo.isWord([Name]) = 1)
GO

ALTER TABLE [dbo].[Student]
ADD CONSTRAINT CHK_Student_Surame
CHECK (dbo.isWord([Surname]) = 1)
GO

ALTER TABLE [dbo].[Student]
ADD CONSTRAINT CHK_Student_Faculty
CHECK (dbo.isWord([Faculty]) = 1)
GO

ALTER TABLE [dbo].[Student]
ADD CONSTRAINT CHK_Student_Department
CHECK (dbo.isWord([Department]) = 1)
GO

ALTER TABLE [dbo].[Student]
ADD CONSTRAINT CHK_Student_Speciality
CHECK (dbo.isWord([Speciality]) = 1)
GO

ALTER TABLE [dbo].[Student]
ADD CONSTRAINT CHK_Student_Semester
CHECK ([Semester] > 0 AND [Semester] <= 12)
GO

CREATE TABLE [dbo].[Teacher](
	[TeachersName] [nvarchar](50) NOT NULL,
	[TeachersSurname] [nvarchar](50) NOT NULL,
	[TeachersID] [int] IDENTITY(1,1) PRIMARY KEY CLUSTERED
)
GO

ALTER TABLE [dbo].[Teacher]
ADD CONSTRAINT CHK_Teacher_TeachersName
CHECK (dbo.isWord([TeachersName]) = 1)
GO

ALTER TABLE [dbo].[Teacher]
ADD CONSTRAINT CHK_Teacher_TeachersSurname
CHECK (dbo.isWord([TeachersSurname]) = 1)
GO

CREATE TABLE [dbo].[Discipline](
	[FK_TeachersID] [int] NOT NULL,
	[Faculty] [nvarchar](50) NOT NULL,
	[Department] [nvarchar](50) NOT NULL,
	[Semester] [int] NOT NULL,
	[Discription] [nvarchar](200) NOT NULL,
	[DisciplineID] [int] IDENTITY(1,1) PRIMARY KEY CLUSTERED
)
GO

ALTER TABLE [dbo].[Discipline]
ADD CONSTRAINT CHK_Discipline_Faculty
CHECK (dbo.isWord([Faculty]) = 1)
GO

ALTER TABLE [dbo].[Discipline]
ADD CONSTRAINT CHK_Discipline_Department
CHECK (dbo.isWord([Department]) = 1)
GO

ALTER TABLE [dbo].[Discipline]
ADD CONSTRAINT CHK_Discipline_Semester
CHECK ([Semester] > 0 AND [Semester] <= 12)
GO

ALTER TABLE [dbo].[Discipline]
WITH CHECK ADD CONSTRAINT FK_Discipline_TeachersID FOREIGN KEY ([FK_TeachersID])
REFERENCES [dbo].[Teacher]([TeachersID])
ON UPDATE CASCADE
GO

CREATE TABLE [dbo].[CanceledDiscipline](
	[FK_DisciplineID] [int] NOT NULL,
	[Year] [date] NOT NULL
)
GO

ALTER TABLE [dbo].[CanceledDiscipline]
WITH CHECK ADD CONSTRAINT PK_CanceledDiscipline PRIMARY KEY CLUSTERED ([FK_DisciplineID], [Year])
GO

ALTER TABLE [dbo].[CanceledDiscipline]
WITH CHECK ADD CONSTRAINT FK_CanceledDiscipline_DisciplineID FOREIGN KEY ([FK_DisciplineID])
REFERENCES [dbo].[Discipline]([DisciplineID])
ON UPDATE CASCADE
GO

CREATE TABLE [dbo].[ChooseHistory](
	[FK_StudentID] [int] NOT NULL,
	[FK_DisciplineID] [int] NOT NULL,
	[Year] [date] NOT NULL
)
GO

ALTER TABLE [dbo].[ChooseHistory]
WITH CHECK ADD CONSTRAINT PK_ChooseHistory PRIMARY KEY CLUSTERED ([FK_StudentID], [FK_DisciplineID], [Year])
GO

ALTER TABLE [dbo].[ChooseHistory]
WITH CHECK ADD CONSTRAINT FK_ChooseHistory_StudentID FOREIGN KEY ([FK_StudentID])
REFERENCES [dbo].[Student]([StudentID])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[ChooseHistory]
WITH CHECK ADD CONSTRAINT FK_ChooseHistory_DisciplineID FOREIGN KEY ([FK_DisciplineID])
REFERENCES [dbo].[Discipline]([DisciplineID])
ON UPDATE CASCADE
GO

CREATE TABLE [dbo].[Catalog](
	[FK_StudentID] [int] NOT NULL,
	[FK_DisciplineID] [int] NOT NULL,
	[Year] [date] NOT NULL
)
GO

ALTER TABLE [dbo].[Catalog]
WITH CHECK ADD CONSTRAINT PK_Catalog PRIMARY KEY CLUSTERED ([FK_StudentID], [FK_DisciplineID], [Year])
GO

ALTER TABLE [dbo].[Catalog]
WITH CHECK ADD CONSTRAINT FK_Catalog_StudentID FOREIGN KEY ([FK_StudentID])
REFERENCES [dbo].[Student]([StudentID])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Catalog]
WITH CHECK ADD CONSTRAINT FK_Catalog_DisciplineID FOREIGN KEY ([FK_DisciplineID])
REFERENCES [dbo].[Discipline]([DisciplineID])
ON UPDATE CASCADE
GO