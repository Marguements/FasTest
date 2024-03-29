USE [master]
GO
/****** Object:  Database [CS414_FasTest]    Script Date: 4/19/2018 9:50:47 PM ******/
CREATE DATABASE [CS414_FasTest]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CS414_FasTest', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\CS414_FasTest.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CS414_FasTest_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\CS414_FasTest_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [CS414_FasTest] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CS414_FasTest].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CS414_FasTest] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CS414_FasTest] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CS414_FasTest] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CS414_FasTest] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CS414_FasTest] SET ARITHABORT OFF 
GO
ALTER DATABASE [CS414_FasTest] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CS414_FasTest] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CS414_FasTest] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CS414_FasTest] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CS414_FasTest] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CS414_FasTest] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CS414_FasTest] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CS414_FasTest] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CS414_FasTest] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CS414_FasTest] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CS414_FasTest] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CS414_FasTest] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CS414_FasTest] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CS414_FasTest] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CS414_FasTest] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CS414_FasTest] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CS414_FasTest] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CS414_FasTest] SET RECOVERY FULL 
GO
ALTER DATABASE [CS414_FasTest] SET  MULTI_USER 
GO
ALTER DATABASE [CS414_FasTest] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CS414_FasTest] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CS414_FasTest] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CS414_FasTest] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CS414_FasTest] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CS414_FasTest] SET QUERY_STORE = OFF
GO
USE [CS414_FasTest]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [CS414_FasTest]
GO
/****** Object:  User [FasTestUser]    Script Date: 4/19/2018 9:50:47 PM ******/
CREATE USER [FasTestUser] FOR LOGIN [FasTestUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [FasTestUser]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [FasTestUser]
GO
ALTER ROLE [db_datareader] ADD MEMBER [FasTestUser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [FasTestUser]
GO
/****** Object:  UserDefinedFunction [dbo].[TestUserPass]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[TestUserPass] (@Username int, @password varchar(25))
returns int
as begin
	declare @match as int
	select @match = count(IDNumber) from FasTestUser where IDNumber = @Username and Password = @Password;
	return @match
end
GO
/****** Object:  Table [dbo].[FasTestUser]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FasTestUser](
	[IDNumber] [int] IDENTITY(111111,1) NOT NULL,
	[Password] [nvarchar](50) NULL,
	[CredentialLevel] [int] NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[UserImage] [varbinary](max) NULL,
	[Salt] [nvarchar](15) NULL,
 CONSTRAINT [PK_FasTestUser] PRIMARY KEY CLUSTERED 
(
	[IDNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Search_Users]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Search_Users] (@IDNumber int)
returns table as return select IDNumber, FirstName, LastName from FasTestUser where IDNumber = @IDNumber;
GO
/****** Object:  UserDefinedFunction [dbo].[select_students]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[select_students](@IDNumber varchar(6), @StudentFirst varchar(25), @StudentLast varchar(25))
returns table as return select * from FasTestUser where CAST(IDNumber as varchar) like '%'+@IDNumber+'%' and FirstNAme like '%'+@StudentFirst+'%' and LastName like '%'+@StudentLast+'%' and CredentialLevel = 3
GO
/****** Object:  Table [dbo].[Assignment]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Assignment](
	[AssignmentID] [int] IDENTITY(1,1) NOT NULL,
	[AssignmentName] [varchar](50) NULL,
	[ClassID] [int] NULL,
	[StartDate] [datetime] NULL,
	[Deadline] [datetime] NULL,
	[TestDuration] [int] NULL,
	[PointsPossible] [int] NOT NULL,
	[allGraded] [bit] NOT NULL,
 CONSTRAINT [PK_Assignment] PRIMARY KEY CLUSTERED 
(
	[AssignmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AssignmentQuestions]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssignmentQuestions](
	[AssignmentQuestion] [int] IDENTITY(1,1) NOT NULL,
	[AssignmentID] [int] NOT NULL,
	[QuestionID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Choice]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Choice](
	[ChoiceID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionID] [int] NOT NULL,
	[Choice] [varchar](100) NOT NULL,
	[StudentAssignmentID] [int] NOT NULL,
	[isCorrect] [bit] NULL,
	[PointValue] [int] NULL,
 CONSTRAINT [PK_Choice] PRIMARY KEY CLUSTERED 
(
	[ChoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Class]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Class](
	[ClassID] [int] IDENTITY(1,1) NOT NULL,
	[InstructorID] [int] NULL,
	[ClassTitle] [varchar](50) NULL,
	[GroupName] [varchar](20) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
 CONSTRAINT [PK_Class] PRIMARY KEY CLUSTERED 
(
	[ClassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClassQuestions]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClassQuestions](
	[ClassQuestionsID] [int] IDENTITY(1,1) NOT NULL,
	[ClassID] [int] NOT NULL,
	[QuestionID] [int] NOT NULL,
 CONSTRAINT [PK_ClassQuestions] PRIMARY KEY CLUSTERED 
(
	[ClassQuestionsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClassStudent]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClassStudent](
	[ClassStudent] [int] IDENTITY(1000,1) NOT NULL,
	[ClassID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[IsEnrolled] [bit] NULL,
 CONSTRAINT [PK_ClassStudent] PRIMARY KEY CLUSTERED 
(
	[ClassStudent] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InstructorQuestions]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InstructorQuestions](
	[InstructorQuestionID] [int] IDENTITY(1,1) NOT NULL,
	[InstructorID] [int] NOT NULL,
	[QuestionID] [int] NOT NULL,
 CONSTRAINT [PK_InstructorQuestions] PRIMARY KEY CLUSTERED 
(
	[InstructorQuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Question]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Question](
	[QuestionID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionType] [int] NULL,
	[QuestionDescription] [varchar](200) NULL,
	[PointValue] [int] NULL,
 CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionMultipleChoice]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionMultipleChoice](
	[QuestionID] [int] NOT NULL,
	[PossibleAnswer1] [varchar](100) NOT NULL,
	[PossibleAnswer2] [varchar](100) NOT NULL,
	[PossibleAnswer3] [varchar](100) NULL,
	[PossibleAnswer4] [varchar](100) NULL,
	[Answer] [int] NOT NULL,
 CONSTRAINT [PK_QuestionMultipleChoice] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionShortAnswer]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionShortAnswer](
	[QuestionID] [int] NOT NULL,
	[Answer] [varchar](100) NOT NULL,
 CONSTRAINT [PK_QuestionShortAnswer] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionTrueFalse]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionTrueFalse](
	[QuestionID] [int] NOT NULL,
	[Answer] [bit] NOT NULL,
 CONSTRAINT [PK_QuestionTrueFalse] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentAssignment]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentAssignment](
	[StudentAssignmentID] [int] IDENTITY(1,1) NOT NULL,
	[ClassId] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[AssignmentID] [int] NOT NULL,
	[Grade] [decimal](5, 2) NULL,
	[PointsEarned] [int] NULL,
	[isCompleted] [bit] NOT NULL,
	[isGraded] [bit] NOT NULL,
	[isVisible] [bit] NOT NULL,
	[TimeStarted] [datetime] NULL,
	[PledgeSigned] [bit] NULL,
 CONSTRAINT [PK_StudentAssignment] PRIMARY KEY CLUSTERED 
(
	[StudentAssignmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Assignment] ON 

INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (189, N'Testing end date', 5, CAST(N'2018-04-03T00:00:00.000' AS DateTime), CAST(N'2018-04-28T00:00:00.000' AS DateTime), 50, 31, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (202, N'afdaf', 19, NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (203, N'red', 5, NULL, NULL, NULL, 1, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (205, N'420 young money', 5, CAST(N'2018-04-10T00:00:00.000' AS DateTime), CAST(N'2018-04-13T00:00:00.000' AS DateTime), 50, 9, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (206, N'Don''t take this test', 5, CAST(N'2018-04-10T00:00:00.000' AS DateTime), CAST(N'2018-04-11T00:00:00.000' AS DateTime), 5, 1, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (207, N'Stephen''s Test', 5, CAST(N'2018-04-10T20:00:00.000' AS DateTime), CAST(N'2018-04-16T00:00:00.000' AS DateTime), 50, 20, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (208, N'This is a test', 5, CAST(N'2018-04-10T12:06:00.000' AS DateTime), CAST(N'2018-04-20T00:00:00.000' AS DateTime), 50, 15, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (209, N'point test editor', 5, CAST(N'2018-04-10T00:00:00.000' AS DateTime), CAST(N'2018-04-11T00:00:00.000' AS DateTime), 999999999, 22, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (210, N'Points test', 5, CAST(N'2018-04-11T00:00:00.000' AS DateTime), CAST(N'2018-04-12T00:00:00.000' AS DateTime), 50, 13, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (211, N'Boogie', 10, CAST(N'2018-04-14T00:00:00.000' AS DateTime), CAST(N'2018-04-14T00:00:00.000' AS DateTime), 50, 1, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (212, N'4/12/18 @ 1:20PM Test SG', 5, CAST(N'2018-04-12T00:00:00.000' AS DateTime), CAST(N'2018-04-14T00:00:00.000' AS DateTime), 200, 4, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (214, N'Bones 101', 13, CAST(N'2018-04-14T00:00:00.000' AS DateTime), CAST(N'2018-04-18T00:00:00.000' AS DateTime), 50, 12, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (215, N'Bones 102', 10, CAST(N'2018-04-17T13:29:00.000' AS DateTime), CAST(N'2018-04-17T00:00:00.000' AS DateTime), 0, 54, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (216, N'Bones 102', 11, CAST(N'2018-04-14T00:00:00.000' AS DateTime), CAST(N'2018-04-16T00:00:00.000' AS DateTime), 50, 12, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (228, N'rfgdf', 11, NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (231, N'Health test 1', 11, NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (245, N'American Govt test #1', 5, CAST(N'2018-04-14T00:00:00.000' AS DateTime), CAST(N'2018-04-14T00:00:00.000' AS DateTime), 0, 9, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (246, N'tfh', 12, NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (249, N'gfghf', 5, NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (252, N'Tito', 10, NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (253, N'Test 4', 10, NULL, NULL, NULL, 5, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (254, N'maya', 12, CAST(N'2018-04-17T00:00:00.000' AS DateTime), CAST(N'2018-04-17T00:00:00.000' AS DateTime), 0, 0, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (255, N'My face', 62, CAST(N'2018-04-17T00:00:00.000' AS DateTime), CAST(N'2018-04-18T00:00:00.000' AS DateTime), 50, 31, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (256, N'My face 2', 61, NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (257, N'my face 2', 62, CAST(N'2018-04-17T00:00:00.000' AS DateTime), CAST(N'2018-04-22T00:00:00.000' AS DateTime), 50, 31, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (258, N'For Stephen', 66, CAST(N'2018-04-17T00:00:00.000' AS DateTime), CAST(N'2018-04-18T00:00:00.000' AS DateTime), 50, 5, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (259, N'Daniels new test', 66, CAST(N'2018-04-17T00:00:00.000' AS DateTime), CAST(N'2018-04-18T00:00:00.000' AS DateTime), 50, 9, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (260, N'Daniels test', 65, CAST(N'2018-04-17T00:00:00.000' AS DateTime), CAST(N'2018-04-18T00:00:00.000' AS DateTime), 50, 6, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (261, N'New Test', 65, CAST(N'2018-04-17T00:00:00.000' AS DateTime), CAST(N'2018-04-18T00:00:00.000' AS DateTime), 50, 7, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (262, N'qefraeg', 5, CAST(N'2018-04-19T21:18:00.000' AS DateTime), CAST(N'2018-04-19T00:00:00.000' AS DateTime), 50, 0, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (263, N'Easy math', 19, NULL, NULL, NULL, 1, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (264, N'ryAN TEST', 10, CAST(N'2018-04-19T08:35:00.000' AS DateTime), CAST(N'2018-04-19T00:00:00.000' AS DateTime), 0, 1, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (265, N'Test for 4/19/20 @ 7:59', 5, CAST(N'2018-04-19T00:00:00.000' AS DateTime), CAST(N'2018-04-20T00:00:00.000' AS DateTime), 120, 3, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (266, N'Banana', 10, NULL, NULL, NULL, 3, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (267, N'New test', 11, NULL, NULL, NULL, 21, 0)
INSERT [dbo].[Assignment] ([AssignmentID], [AssignmentName], [ClassID], [StartDate], [Deadline], [TestDuration], [PointsPossible], [allGraded]) VALUES (268, N'Stephens Special Ed test', 66, CAST(N'2018-04-19T20:52:00.000' AS DateTime), CAST(N'2018-04-23T00:00:00.000' AS DateTime), 50, 33, 0)
SET IDENTITY_INSERT [dbo].[Assignment] OFF
SET IDENTITY_INSERT [dbo].[AssignmentQuestions] ON 

INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (278, 189, 391)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (279, 189, 392)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (281, 189, 394)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (410, 267, 523)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (408, 207, 521)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (299, 207, 412)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (303, 209, 416)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (304, 209, 417)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (305, 209, 418)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (306, 209, 419)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (307, 209, 420)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (312, 211, 425)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (350, 207, 463)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (330, 207, 443)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (331, 207, 444)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (364, 258, 477)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (365, 258, 478)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (366, 258, 479)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (367, 259, 480)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (368, 259, 481)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (369, 259, 482)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (370, 260, 483)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (371, 260, 484)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (372, 260, 485)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (373, 260, 486)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (374, 261, 487)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (375, 261, 488)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (376, 261, 489)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (377, 261, 490)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (378, 261, 491)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (380, 207, 493)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (411, 267, 524)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (382, 207, 495)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (383, 207, 496)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (384, 207, 497)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (385, 264, 498)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (386, 215, 499)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (387, 215, 500)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (388, 215, 501)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (389, 215, 502)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (390, 215, 503)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (391, 215, 504)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (392, 215, 505)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (403, 265, 516)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (404, 265, 517)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (405, 265, 518)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (406, 266, 519)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (412, 267, 525)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (413, 267, 526)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (414, 267, 527)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (415, 267, 528)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (282, 189, 395)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (283, 189, 396)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (284, 189, 397)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (313, 212, 426)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (314, 212, 427)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (315, 212, 428)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (316, 212, 429)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (359, 257, 472)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (360, 257, 473)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (361, 257, 474)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (362, 257, 475)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (363, 257, 476)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (401, 207, 514)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (285, 203, 398)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (351, 253, 464)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (346, 245, 459)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (347, 245, 460)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (348, 245, 461)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (354, 255, 467)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (355, 255, 468)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (356, 255, 469)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (357, 255, 470)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (358, 255, 471)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (308, 210, 421)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (309, 210, 422)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (310, 210, 423)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (311, 210, 424)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (290, 205, 403)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (291, 205, 404)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (292, 205, 405)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (293, 206, 406)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (294, 206, 407)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (295, 206, 408)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (296, 206, 409)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (300, 208, 413)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (301, 208, 414)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (302, 208, 415)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (321, 214, 434)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (322, 214, 435)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (323, 214, 436)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (324, 215, 437)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (325, 215, 438)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (326, 215, 439)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (327, 216, 440)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (328, 216, 441)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (329, 216, 442)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (379, 263, 492)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (393, 208, 506)
GO
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (394, 208, 507)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (395, 208, 508)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (396, 208, 509)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (397, 208, 510)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (398, 208, 511)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (416, 268, 529)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (417, 268, 530)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (418, 268, 531)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (419, 268, 532)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (420, 268, 533)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (421, 268, 534)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (422, 268, 535)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (423, 268, 536)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (424, 268, 537)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (425, 268, 538)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (426, 268, 539)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (427, 268, 540)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (428, 268, 541)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (429, 268, 542)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (430, 268, 543)
INSERT [dbo].[AssignmentQuestions] ([AssignmentQuestion], [AssignmentID], [QuestionID]) VALUES (431, 268, 544)
SET IDENTITY_INSERT [dbo].[AssignmentQuestions] OFF
SET IDENTITY_INSERT [dbo].[Choice] ON 

INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (48, 396, N'0', 514, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (49, 397, N'0', 514, 1, 8)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (50, 391, N'BS', 514, 1, 7)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (51, 392, N'Wonderful Bass', 514, 1, 7)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (52, 394, N'0', 514, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (53, 395, N'1', 514, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (54, 402, N'3', 0, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (55, 400, N'af', 0, 0, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (56, 405, N'2', 572, 0, 2)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (57, 403, N'not here', 572, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (58, 404, N'1', 572, 0, 4)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (59, 410, N'1', 588, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (60, 411, N'Grace', 588, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (61, 412, N'1', 588, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (62, 407, N'1', 580, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (63, 406, N';lksadjfa;slkdjfjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj', 580, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (64, 408, N'da', 580, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (65, 409, N'1', 580, 1, 4)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (66, 415, N'1', 596, 0, 4)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (67, 413, N'sinnnnnnnnnnnnnnn', 596, 0, 2)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (68, 414, N'1', 596, 0, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (69, 416, N'2', 604, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (70, 418, N'da', 604, 0, 7)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (71, 419, N'sinnnnnnnnnnnnnnn', 604, 0, 7)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (72, 417, N'1', 604, 0, 2)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (73, 420, N'2', 604, 0, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (74, 422, N'1', 612, 1, 4)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (75, 424, N'1', 612, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (76, 423, N'5', 612, 1, 5)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (77, 421, N'1', 612, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (78, 426, N'1', 622, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (79, 427, N'0', 622, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (80, 428, N'0', 622, 0, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (81, 429, N'0', 622, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (82, 442, N'1', 645, 1, 5)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (83, 440, N'295', 645, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (84, 441, N'0', 645, 0, 4)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (85, 471, N'2', 847, 1, 5)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (86, 470, N'Stephen', 847, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (87, 467, N'0', 847, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (88, 468, N'1', 847, 1, 10)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (89, 469, N'0', 847, 1, 10)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (90, 477, N'3', 868, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (91, 479, N'True', 868, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (92, 478, N'0', 868, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (93, 482, N'3', 876, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (94, 481, N'nui', 876, 0, 4)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (95, 480, N'0', 876, 1, 4)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (96, 482, N'1', 870, 0, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (97, 481, N'gsdgf', 870, 0, 4)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (98, 480, N'1', 870, 0, 4)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (99, 486, N'2', 877, 0, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (100, 484, N'ii', 877, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (101, 483, N'0', 877, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (102, 485, N'0', 877, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (103, 489, N'2', 878, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (104, 491, N'tutjy', 878, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (105, 487, N'0', 878, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (106, 488, N'1', 878, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (107, 490, N'0', 878, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (108, 396, N'4', 513, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (109, 397, N'1', 513, 1, 8)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (110, 391, N'Stupid', 513, 0, 7)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (111, 392, N'bass', 513, 1, 7)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (112, 394, N'1', 513, 0, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (113, 395, N'1', 513, 0, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (114, 477, N'1', 862, 0, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (115, 479, N'Howell', 862, 0, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (116, 478, N'0', 862, 0, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (117, 516, N'2', 899, 0, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (118, 517, N'hi', 899, 0, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (119, 518, N'0', 899, 0, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (120, 530, N'3', 919, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (121, 535, N'3', 919, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (122, 537, N'1', 919, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (123, 538, N'0', 919, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (124, 544, N'0', 919, 1, 5)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (125, 529, N'', 919, 0, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (126, 532, N'', 919, 0, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (127, 533, N'', 919, 1, 4)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (128, 539, N'', 919, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (129, 541, N'', 919, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (130, 531, N'', 919, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (131, 534, N'', 919, 1, 4)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (132, 536, N'1', 919, 1, 3)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (133, 540, N'0', 919, 0, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (134, 542, N'0', 919, 1, 1)
INSERT [dbo].[Choice] ([ChoiceID], [QuestionID], [Choice], [StudentAssignmentID], [isCorrect], [PointValue]) VALUES (135, 543, N'0', 919, 0, 4)
SET IDENTITY_INSERT [dbo].[Choice] OFF
SET IDENTITY_INSERT [dbo].[Class] ON 

INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (4, 0, N'HIStory', N'HI', CAST(N'2015-01-15' AS Date), NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (5, 2, N'American Government', N'PL', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (10, 2, N'Biology', N'SC', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (11, 2, N'Health', N'SC', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (12, 2, N'Chemistry', N'SC', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (13, 2, N'Health', N'ED', CAST(N'2018-02-12' AS Date), CAST(N'2019-05-07' AS Date))
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (14, 2, N'Pharmacology', N'NU', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (17, 2, N'Geometry', N'MA', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (18, 2, N'Algebra', N'MA', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (19, 2, N'General Mathematics', N'MA', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (24, 2, N'Computer Science Survey', N'CS', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (59, 2, N'Systems Design', N'CS', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (60, 1027, N'A Cool Class', N'NG', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (61, 2, N'A New Class', N'HI', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (62, 2, N'Intro to Memes', N'MS', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (63, 1027, N'New Class', N'HB', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (64, 1027, N'New New Class', N'CS', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (65, 2, N'MYSTERIOS', N'FG', NULL, NULL)
INSERT [dbo].[Class] ([ClassID], [InstructorID], [ClassTitle], [GroupName], [StartDate], [EndDate]) VALUES (66, 2, N'Special ED', N'ED', NULL, NULL)
SET IDENTITY_INSERT [dbo].[Class] OFF
SET IDENTITY_INSERT [dbo].[ClassStudent] ON 

INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1, 5, 1013, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1001, 5, 1015, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1002, 5, 1018, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1004, 10, 1015, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1007, 12, 1022, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1008, 13, 1024, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1009, 5, 2, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1011, 10, 1023, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1012, 10, 1025, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1023, 11, 1022, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1024, 11, 1023, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1025, 11, 1026, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1026, 11, 1020, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1027, 17, 1023, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1028, 17, 1020, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1029, 11, 1025, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1030, 11, 1024, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1031, 11, 1013, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1032, 10, 1013, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1033, 14, 1020, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1034, 12, 1013, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1035, 10, 1027, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1036, 4, 1022, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1037, 19, 1013, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1038, 19, 1020, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1039, 19, 1023, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1040, 4, 1024, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1041, 4, 1013, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1042, 4, 1020, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1043, 4, 1023, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1044, 4, 1025, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1045, 4, 1026, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1046, 4, 1027, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1047, 5, 1020, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1048, 5, 1025, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1049, 5, 1026, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1050, 24, 1020, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1051, 24, 1013, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1052, 24, 1022, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1053, 24, 1023, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1054, 24, 1024, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1055, 24, 1026, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1056, 24, 1039, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1057, 24, 1045, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1058, 24, 1046, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1059, 24, 1044, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1060, 18, 1025, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1061, 5, 1039, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1062, 5, 3, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1063, 11, 3, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1064, 12, 3, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1065, 62, 3, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1066, 62, 1013, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1067, 62, 1020, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1068, 62, 1022, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1069, 62, 1023, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1070, 62, 1024, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1071, 62, 1025, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1072, 5, 1024, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1073, 5, 1022, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1074, 5, 1023, 0)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1075, 5, 1044, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1076, 5, 1045, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1077, 13, 3, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1078, 60, 3, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1079, 60, 1013, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1080, 60, 1020, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1081, 66, 1026, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1082, 66, 1039, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1083, 66, 1041, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1084, 66, 1042, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1085, 66, 1043, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1086, 66, 1044, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1087, 66, 1045, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1088, 66, 3, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1089, 4, 3, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1090, 4, 1039, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1091, 4, 1041, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1092, 4, 1042, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1093, 4, 1043, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1094, 4, 1044, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1095, 4, 1045, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1096, 4, 1046, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1097, 4, 1069, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1098, 65, 111111, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1099, 5, 129445, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1100, 66, 129445, 1)
INSERT [dbo].[ClassStudent] ([ClassStudent], [ClassID], [StudentID], [IsEnrolled]) VALUES (1101, 62, 129445, 1)
SET IDENTITY_INSERT [dbo].[ClassStudent] OFF
SET IDENTITY_INSERT [dbo].[FasTestUser] ON 

INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (0, NULL, 2, N'Not', N'Assigned', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1, N'a4ayc/80/OGda4BO/1o/V0etpOqiLx1JwB5S3beHW0s=', 1, N'Code', N'Runners', NULL, N'L9UzMA7Su8FY')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (2, N'1HNeOiZeFu7gP1lxi5tdAwGcB9i2xR+Q2jpmbuwTqzU=', 2, N'Dr. Robert', N'Howell', NULL, N'CIyTEy64')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (3, N'TgdAhWK+24tgzgXB3s/jrRa3IjCWfeAfZAt+Rym0n84=', 3, N'Code', N'Runners', NULL, N'hZN4TEC9Gn8=')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1013, N'student', 3, N'Amber', N'Lipton', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1015, N'1HNeOiZeFu7gP1lxi5tdAwGcB9i2xR+Q2jpmbuwTqzU=', 1, N'Zach', N'Hogan', NULL, N'CIyTEy64')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1018, N'asdf', 2, N'Susan', N'Jones', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1020, N'1000', 3, N'Dustin', N'Henderson', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1022, N'1', 3, N'Jim', N'Hopper', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1023, N'test2', 3, N'dude', N'Johnson', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1024, N'unsecure', 3, N'Mike', N'Wheeler', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1025, N'jkjk', 3, N'Daniel', N'Johnson', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1026, N'jkl;', 3, N'Tito', N'Smith', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1027, N'pink', 2, N'Bethany', N'Fiedler', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1039, N'PbGG1AVw+G178m6U/rVnFzb0l3tgZPA9SmpBiSEfRSw=', 3, N'Coco', N'Coco', NULL, N'krktacs5QO6E')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1040, N'1HNeOiZeFu7gP1lxi5tdAwGcB9i2xR+Q2jpmbuwTqzU=', 2, N'Arnie', N'Nelson', NULL, N'oT4hbYE1KB0=')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1041, N'asdfg', 3, N'new', N's', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1042, N'asdfg', 3, N'new211', N'2', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1043, N'gasdg', 3, N'1', N'2', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1044, N'tJPUg2Sv5E0RwBZc9HCkFk0eJgmRHvmYvoaNRq3j3k4=', 3, N'sadg', N'gsad', NULL, N'0qU7TGPFWg==')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1045, N'gda', 3, N'gdsa', N'sdg', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1046, N'adfhfhj', 3, N'gfda', N'asdgg', NULL, NULL)
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1069, N'TgdAhWK+24tgzgXB3s/jrRa3IjCWfeAfZAt+Rym0n84=', 3, N'Student', N'Student', NULL, N'hZN4TEC9Gn8=')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1089, N'TgdAhWK+24tgzgXB3s/jrRa3IjCWfeAfZAt+Rym0n84=', 3, N'bob', N't', NULL, N'Y3MYV8BtSZM=')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1090, N'SyJ3d9TdH8Ycb4hPSGQdArTRIdP9Moywi1Ux/Kzav4o=', 3, N'bob', N'y', NULL, N'NRQ9vO7h5JI=')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1091, N'eQJpm+Qsio5G+7tFAXJlF+hrIsVqGJ92JabaSQgbJFE=', 3, N'bob', N'yu', NULL, N'be9ZmGqCZpsp')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (1095, N'TgdAhWK+24tgzgXB3s/jrRa3IjCWfeAfZAt+Rym0n84=', 3, N'Daniel', N'Johnson', NULL, N'o4qBvcovZ19s')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (111111, N'SN5JADPSZLOAVzGVIV7JqX7dZFKQoYINvWBKjZdgIyI=', 3, N'Daniel', N'Johnson', NULL, N'T6dM9+8gMyA=')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (129444, N'nLQvtcNzK24xtxNTpkkN1TXlumC0+DbgWd8cZco1nfE=', 3, N'Mathew', N'Argue', NULL, N'aL2/OtLc')
INSERT [dbo].[FasTestUser] ([IDNumber], [Password], [CredentialLevel], [FirstName], [LastName], [UserImage], [Salt]) VALUES (129445, N'jZae727K08KaOmKSgOaGzww/XVqGr/PKEgIMkjrcbJI=', 3, N'Stephen', N'Gowans', NULL, N'qFQ+CBhqig==')
SET IDENTITY_INSERT [dbo].[FasTestUser] OFF
SET IDENTITY_INSERT [dbo].[Question] ON 

INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (378, 3, N'Stephen is awesome', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (379, 1, N'Stephen''s favorite color is...', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (380, 2, N'Stephen works in...', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (383, 1, N'Stephen''s favorite color is...', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (384, 2, N'Stephen works in...', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (386, 3, N'Stephen is awesome', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (387, 3, N'Stephen is awesome', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (388, 1, N'Stephen''s favorite color is...', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (389, 2, N'Stephen works in...', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (390, 3, N'Stephen is awesome', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (391, 2, N'This project is...', 7)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (392, 2, N'Its all about that ', 7)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (394, 3, N'Tis a twue fwase', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (395, 3, N'Stephen is useless', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (396, 1, N'The Best group member', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (397, 1, N'My name is', 8)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (398, 1, N'dafdwa', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (400, 2, N'I have no Idears', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (401, 3, N'Taste the Rainbow', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (402, 1, N'The answer to life', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (403, 2, N'Where is the good stuff', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (404, 3, N'I like chocolate', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (405, 1, N'a', 2)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (406, 2, N'dagf', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (407, 1, N'dafdwa', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (408, 2, N'Where is the good stuff', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (409, 3, N'I like chocolate', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (412, 3, N'Don''t stop believin', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (413, 2, N'Guns are what?', 2)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (414, 3, N'I don''t like programming', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (415, 1, N'May the _____ be with you', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (416, 1, N'fgfg', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (417, 3, N'hghfg', 2)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (418, 2, N'This project is...', 7)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (419, 2, N'Its all about that ', 7)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (420, 3, N'Tis a twue fwase', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (421, 3, N'three point question which is true', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (422, 1, N'4 point - Answer B', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (423, 2, N'5 point question - Answer 5', 5)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (424, 1, N'dafdwa', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (425, 1, N'2 + 2 = ?', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (426, 3, N'True', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (427, 3, N'False', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (428, 3, N'True', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (429, 3, N'False', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (433, 1, N'What is the color of the rainbow', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (434, 2, N'How many bones are in the human body?', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (435, 3, N'There is no spoon', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (436, 1, N'The head bone is connected to the _________', 5)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (437, 2, N'How many bones are in the human body?', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (438, 3, N'There is no spoon', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (439, 1, N'The head bone is connected to the _________', 5)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (440, 2, N'How many bones are in the human body?', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (441, 3, N'There is no spoon', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (442, 1, N'The head bone is connected to the _________', 5)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (443, 1, N'mv', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (444, 1, N'kjhji', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (445, 2, N'This project is...', 7)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (446, 3, N'2', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (447, 3, N'gfgsgf', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (448, 3, N'gfgd', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (449, 3, N'gfgdgf', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (450, 3, N'', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (451, 2, N'gdhg', 5)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (452, 2, N'sgfd', 5)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (453, 2, N'fddbhg', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (454, 3, N'ghgfgh', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (455, 1, N'How many bones are in the human body?', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (456, 1, N'gfjgh', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (457, 3, N'jhgjh', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (458, 2, N'ghjh', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (459, 2, N'Where is the good stuff', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (460, 3, N'I like chocolate', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (461, 1, N'a', 2)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (462, 3, N'ghfhgfh', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (463, 2, N'How many bones are in the human body?', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (464, 1, N'What is smaller?', 5)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (465, 1, N'2+2', 7)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (466, 1, N'2+2', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (467, 3, N'Stephen is good looking', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (468, 3, N'Daniel is Good looking', 10)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (469, 3, N'Matt is good looking', 10)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (470, 2, N'_______ looks the best', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (471, 1, N'The best meme', 5)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (472, 3, N'Stephen is good looking', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (473, 3, N'Daniel is Good looking', 10)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (474, 3, N'Matt is good looking', 10)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (475, 2, N'_______ looks the best', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (476, 1, N'The best meme', 5)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (477, 1, N'The color of the Sky', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (478, 3, N'Pensacola Christian College stands for PCC', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (479, 2, N'Dr. Robert', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (480, 3, N'A false question', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (481, 2, N'The answer is you', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (482, 1, N'A terrible person', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (483, 3, N'Treu', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (484, 2, N'Dr. Robert', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (485, 3, N'Pensacola Christian College stands for PCC', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (486, 1, N'The color of the Sky', 3)
GO
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (487, 3, N'True', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (488, 3, N'False', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (489, 1, N'The color of the Sky', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (490, 3, N'Pensacola Christian College stands for PCC', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (491, 2, N'Dr. Robert', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (492, 1, N'5+5', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (493, 3, N'Are you here?', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (495, 3, N'Are you here?', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (496, 3, N'Are you here?', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (497, 3, N'Are you here?', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (498, 1, N'2 + 2 = ?', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (499, 3, N'', 6)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (500, 3, N'Are you here?', 6)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (501, 3, N'Are you here?', 6)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (502, 3, N'', 6)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (503, 3, N'', 6)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (504, 3, N'', 6)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (505, 3, N'', 6)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (506, 3, N'', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (507, 3, N'', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (508, 3, N'', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (509, 3, N'', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (510, 3, N'', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (511, 3, N'', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (514, 3, N'', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (516, 1, N'Answer A', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (517, 2, N'answer', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (518, 3, N'True', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (519, 3, N'shdg', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (521, 2, N'Hello auidhf World it is an awesome day for a very long question to test this gridview', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (522, 3, N'Treu', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (523, 2, N'How many bones are in the human body?', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (524, 1, N'The head bone is connected to the _________', 5)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (525, 3, N'There is no spoon', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (526, 2, N'Where is the good stuff', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (527, 3, N'I like chocolate', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (528, 1, N'a', 2)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (529, 2, N'The color of the sky', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (530, 1, N'The best game at SE', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (531, 3, N'Pensacola Christian College stands for PCC', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (532, 2, N'Dr. Robert', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (533, 2, N'The answer is you', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (534, 3, N'A false question', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (535, 1, N'A terrible person', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (536, 3, N'Are you here?', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (537, 1, N'kjhji', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (538, 1, N'mv', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (539, 2, N'How many bones are in the human body?', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (540, 3, N'Don''t stop believin', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (541, 2, N'Hello auidhf World it is an awesome day for a very long question to test this gridview', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (542, 3, N'', 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (543, 3, N'There is no spoon', 4)
INSERT [dbo].[Question] ([QuestionID], [QuestionType], [QuestionDescription], [PointValue]) VALUES (544, 1, N'The head bone is connected to the _________', 5)
SET IDENTITY_INSERT [dbo].[Question] OFF
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (379, N'blue', N'green', N'barf yellow', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (383, N'blue', N'green', N'barf yellow', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (396, N'Michael', N'Stephen', N'Matt', N'Jesus', 4)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (397, N'Daniel', N'Nada', N'Zilch', N'Oh no...', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (398, N'', N'', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (402, N'16', N'32', N'42', N'85', 3)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (405, N'a', N'b', N'c', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (407, N'', N'', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (415, N'Chocolate', N'Icecream', N'force', N'CIS', 3)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (416, N'fdg', N'fgdg', N'ghshg', N'', 3)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (422, N'A', N'B', N'C', N'', 2)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (424, N'', N'', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (425, N'4', N'2', N'1', N'6', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (433, N'red', N'blue', N'green', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (436, N'leg bone', N'shoulder bone', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (439, N'leg bone', N'shoulder bone', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (442, N'leg bone', N'shoulder bone', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (443, N'', N'', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (444, N'', N'', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (455, N'frgfsd', N'', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (456, N'jhjkghk', N'', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (461, N'a', N'b', N'c', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (464, N'mouse', N'elephant', N'kangaroo', N'turtle', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (465, N'4', N'2', N'1', N'5', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (466, N'4', N'2', N'1', N'5', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (471, N'Smiley', N'Heart', N'Angry face', N'', 2)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (476, N'Smiley', N'Heart', N'Angry face', N'', 2)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (477, N'Blue', N'Green', N'Red', N'Orange', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (482, N'God', N'Jesus', N'Daniel', N'', 3)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (486, N'Blue', N'Green', N'Red', N'Orange', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (489, N'Blue', N'Green', N'Red', N'Orange', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (492, N'12', N'4', N'15', N'10', 4)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (498, N'4', N'2', N'1', N'6', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (516, N'a', N'b', N'c', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (524, N'leg bone', N'shoulder bone', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (528, N'a', N'b', N'c', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (530, N'New Horizon', N'No clue', N'no clue', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (535, N'God', N'Jesus', N'Daniel', N'', 3)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (537, N'', N'', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (538, N'', N'', N'', N'', 1)
INSERT [dbo].[QuestionMultipleChoice] ([QuestionID], [PossibleAnswer1], [PossibleAnswer2], [PossibleAnswer3], [PossibleAnswer4], [Answer]) VALUES (544, N'leg bone', N'shoulder bone', N'', N'', 1)
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (380, N'The I.T. department at Subway')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (384, N'The I.T. department at Subway')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (391, N'Awesome')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (392, N'Bass')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (400, N'yes')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (403, N'not here')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (406, N'dhg')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (408, N'not here')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (413, N'Cool')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (418, N'Awesome')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (419, N'Bass')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (423, N'5')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (434, N'296')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (437, N'296')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (440, N'296')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (445, N'Awesome')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (451, N'hgjghj')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (452, N'ghdg')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (453, N'gfhfgh')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (458, N'ghkgj')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (459, N'not here')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (463, N'296')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (470, N'my wife')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (475, N'my wife')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (479, N'Howell')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (481, N'you')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (484, N'Howell')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (491, N'Howell')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (517, N'answer')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (521, N'Cool')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (523, N'296')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (526, N'not here')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (529, N'Blue')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (532, N'Howell')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (533, N'you')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (539, N'296')
INSERT [dbo].[QuestionShortAnswer] ([QuestionID], [Answer]) VALUES (541, N'Cool')
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (378, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (386, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (394, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (395, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (401, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (404, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (409, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (412, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (414, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (417, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (420, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (421, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (426, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (427, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (428, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (429, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (435, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (438, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (441, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (446, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (447, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (448, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (449, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (450, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (454, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (457, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (460, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (462, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (467, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (468, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (469, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (472, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (473, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (474, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (478, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (480, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (483, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (485, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (487, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (488, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (490, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (493, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (495, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (496, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (497, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (499, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (500, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (501, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (502, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (503, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (504, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (505, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (506, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (507, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (508, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (509, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (510, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (511, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (514, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (518, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (519, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (522, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (525, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (527, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (531, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (534, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (536, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (540, 1)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (542, 0)
INSERT [dbo].[QuestionTrueFalse] ([QuestionID], [Answer]) VALUES (543, 1)
SET IDENTITY_INSERT [dbo].[StudentAssignment] ON 

INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (507, 5, 1015, 189, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (508, 5, 1018, 189, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (509, 5, 2, 189, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (510, 5, 1020, 189, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (511, 5, 1025, 189, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (512, 5, 1026, 189, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (513, 5, 1039, 189, CAST(58.06 AS Decimal(5, 2)), 18, 1, 1, 0, CAST(N'2018-04-17T20:43:05.380' AS DateTime), 1)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (514, 5, 3, 189, CAST(122.58 AS Decimal(5, 2)), 38, 1, 1, 1, CAST(N'2018-04-07T15:37:49.277' AS DateTime), 1)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (555, 19, 1020, 202, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (556, 19, 1023, 202, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (557, 5, 1015, 203, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (558, 5, 1018, 203, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (559, 5, 2, 203, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (560, 5, 1020, 203, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (561, 5, 1025, 203, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (562, 5, 1026, 203, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (563, 5, 1039, 203, CAST(0.00 AS Decimal(5, 2)), 0, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (564, 5, 3, 203, CAST(0.00 AS Decimal(5, 2)), 0, 1, 1, 0, CAST(N'2018-04-07T19:52:00.000' AS DateTime), 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (565, 5, 1015, 205, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (566, 5, 1018, 205, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (567, 5, 2, 205, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (568, 5, 1020, 205, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (569, 5, 1025, 205, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (570, 5, 1026, 205, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (571, 5, 1039, 205, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (572, 5, 3, 205, CAST(33.33 AS Decimal(5, 2)), 3, 1, 1, 1, CAST(N'2018-04-10T12:54:10.823' AS DateTime), 1)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (573, 5, 1015, 206, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (574, 5, 1018, 206, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (575, 5, 2, 206, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (576, 5, 1020, 206, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (577, 5, 1025, 206, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (578, 5, 1026, 206, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (579, 5, 1039, 206, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (580, 5, 3, 206, CAST(100.00 AS Decimal(5, 2)), 1, 1, 1, 1, CAST(N'2018-04-10T21:06:55.350' AS DateTime), 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (581, 5, 1015, 207, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (582, 5, 1018, 207, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (583, 5, 2, 207, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (584, 5, 1020, 207, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (585, 5, 1025, 207, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (586, 5, 1026, 207, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (587, 5, 1039, 207, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (588, 5, 3, 207, CAST(15.00 AS Decimal(5, 2)), 3, 0, 1, 0, CAST(N'2018-04-10T19:04:52.347' AS DateTime), 1)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (589, 5, 1015, 208, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (590, 5, 1018, 208, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (591, 5, 2, 208, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (592, 5, 1020, 208, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (593, 5, 1025, 208, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (594, 5, 1026, 208, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (595, 5, 1039, 208, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (596, 5, 3, 208, NULL, NULL, 0, 1, 0, CAST(N'2018-04-10T21:19:48.853' AS DateTime), 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (597, 5, 1015, 209, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (598, 5, 1018, 209, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (599, 5, 2, 209, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (600, 5, 1020, 209, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (601, 5, 1025, 209, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (602, 5, 1026, 209, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (603, 5, 1039, 209, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (604, 5, 3, 209, NULL, NULL, 1, 0, 0, CAST(N'2018-04-10T21:42:46.873' AS DateTime), 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (605, 5, 1015, 210, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (606, 5, 1018, 210, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (607, 5, 2, 210, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (608, 5, 1020, 210, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (609, 5, 1025, 210, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (610, 5, 1026, 210, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (611, 5, 1039, 210, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (612, 5, 3, 210, CAST(100.00 AS Decimal(5, 2)), 13, 1, 1, 1, CAST(N'2018-04-11T10:40:57.877' AS DateTime), 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (613, 10, 1015, 211, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (614, 10, 1027, 211, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (615, 5, 1015, 212, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (616, 5, 1018, 212, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (617, 5, 2, 212, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (618, 5, 1020, 212, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (619, 5, 1025, 212, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (620, 5, 1026, 212, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (621, 5, 1039, 212, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (622, 5, 3, 212, CAST(75.00 AS Decimal(5, 2)), 3, 1, 1, 1, CAST(N'2018-04-12T13:32:45.193' AS DateTime), 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (636, 13, 1024, 214, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (637, 10, 1015, 215, CAST(0.00 AS Decimal(5, 2)), NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (638, 10, 1027, 215, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (639, 11, 1023, 216, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (640, 11, 1026, 216, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (641, 11, 1020, 216, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (642, 11, 1025, 216, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (643, 11, 1024, 216, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (644, 11, 1013, 216, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (645, 11, 3, 216, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (715, 11, 1023, 228, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (716, 11, 1026, 228, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (717, 11, 1020, 228, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (718, 11, 1025, 228, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (719, 11, 1024, 228, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (720, 11, 1013, 228, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (721, 11, 3, 228, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (738, 11, 1023, 231, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (739, 11, 1026, 231, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (740, 11, 1020, 231, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (741, 11, 1025, 231, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (742, 11, 1024, 231, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (743, 11, 1013, 231, NULL, NULL, 0, 0, 0, NULL, 0)
GO
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (744, 11, 3, 231, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (815, 5, 1015, 245, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (816, 5, 1018, 245, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (817, 5, 2, 245, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (818, 5, 1026, 245, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (819, 5, 1039, 245, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (820, 5, 3, 245, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (821, 5, 1044, 245, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (822, 5, 1045, 245, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (823, 12, 1022, 246, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (824, 12, 1013, 246, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (825, 12, 3, 246, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (828, 5, 1015, 249, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (829, 5, 1018, 249, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (830, 5, 2, 249, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (831, 5, 1026, 249, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (832, 5, 1039, 249, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (833, 5, 3, 249, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (834, 5, 1044, 249, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (835, 5, 1045, 249, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (840, 10, 1015, 252, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (841, 10, 1027, 252, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (842, 10, 1015, 253, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (843, 10, 1027, 253, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (844, 12, 1022, 254, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (845, 12, 1013, 254, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (846, 12, 3, 254, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (847, 62, 3, 255, CAST(100.00 AS Decimal(5, 2)), 31, 1, 1, 1, CAST(N'2018-04-17T15:27:35.843' AS DateTime), 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (848, 62, 1013, 255, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (849, 62, 1020, 255, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (850, 62, 1022, 255, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (851, 62, 1023, 255, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (852, 62, 1024, 255, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (853, 62, 1025, 255, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (854, 62, 3, 257, NULL, NULL, 0, 1, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (855, 62, 1013, 257, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (856, 62, 1020, 257, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (857, 62, 1022, 257, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (858, 62, 1023, 257, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (859, 62, 1024, 257, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (860, 62, 1025, 257, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (861, 66, 1026, 258, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (862, 66, 1039, 258, CAST(0.00 AS Decimal(5, 2)), 0, 1, 1, 1, CAST(N'2018-04-17T20:45:15.060' AS DateTime), 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (863, 66, 1041, 258, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (864, 66, 1042, 258, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (865, 66, 1043, 258, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (866, 66, 1044, 258, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (867, 66, 1045, 258, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (868, 66, 3, 258, CAST(100.00 AS Decimal(5, 2)), 5, 1, 1, 1, CAST(N'2018-04-17T19:57:16.987' AS DateTime), 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (869, 66, 1026, 259, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (870, 66, 1039, 259, CAST(0.00 AS Decimal(5, 2)), 0, 1, 0, 0, CAST(N'2018-04-17T20:17:18.187' AS DateTime), 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (871, 66, 1041, 259, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (872, 66, 1042, 259, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (873, 66, 1043, 259, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (874, 66, 1044, 259, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (875, 66, 1045, 259, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (876, 66, 3, 259, CAST(55.56 AS Decimal(5, 2)), 5, 1, 1, 1, CAST(N'2018-04-17T20:13:40.660' AS DateTime), 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (877, 65, 111111, 260, CAST(50.00 AS Decimal(5, 2)), 3, 1, 1, 1, CAST(N'2018-04-17T20:32:33.073' AS DateTime), 1)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (878, 65, 111111, 261, CAST(100.00 AS Decimal(5, 2)), 7, 1, 1, 1, CAST(N'2018-04-17T20:34:34.737' AS DateTime), 1)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (879, 5, 1015, 262, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (880, 5, 1018, 262, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (881, 5, 2, 262, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (882, 5, 1026, 262, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (883, 5, 1039, 262, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (884, 5, 3, 262, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (885, 5, 1044, 262, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (886, 5, 1045, 262, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (887, 19, 1020, 263, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (888, 19, 1023, 263, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (889, 10, 1015, 264, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (890, 10, 1027, 264, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (891, 5, 1015, 265, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (892, 5, 1018, 265, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (893, 5, 2, 265, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (894, 5, 1026, 265, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (895, 5, 1039, 265, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (896, 5, 3, 265, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (897, 5, 1044, 265, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (898, 5, 1045, 265, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (899, 5, 129445, 265, CAST(0.00 AS Decimal(5, 2)), 0, 1, 0, 0, CAST(N'2018-04-19T20:50:59.863' AS DateTime), 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (900, 10, 1015, 266, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (901, 10, 1027, 266, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (902, 11, 1023, 267, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (903, 11, 1026, 267, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (904, 11, 1020, 267, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (905, 11, 1025, 267, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (906, 11, 1024, 267, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (907, 11, 1013, 267, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (908, 11, 3, 267, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (909, 66, 1026, 268, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (910, 66, 1039, 268, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (911, 66, 1041, 268, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (912, 66, 1042, 268, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (913, 66, 1043, 268, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (914, 66, 1044, 268, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (915, 66, 1045, 268, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (916, 66, 3, 268, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (917, 66, 129445, 258, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (918, 66, 129445, 259, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (919, 66, 129445, 268, CAST(78.79 AS Decimal(5, 2)), 26, 1, 1, 1, CAST(N'2018-04-19T21:06:06.453' AS DateTime), 0)
GO
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (920, 62, 129445, 255, NULL, NULL, 0, 0, 0, NULL, 0)
INSERT [dbo].[StudentAssignment] ([StudentAssignmentID], [ClassId], [StudentID], [AssignmentID], [Grade], [PointsEarned], [isCompleted], [isGraded], [isVisible], [TimeStarted], [PledgeSigned]) VALUES (921, 62, 129445, 257, NULL, NULL, 0, 0, 0, NULL, 0)
SET IDENTITY_INSERT [dbo].[StudentAssignment] OFF
ALTER TABLE [dbo].[Assignment] ADD  CONSTRAINT [DF_Assignment_PointsPossible]  DEFAULT ((0)) FOR [PointsPossible]
GO
ALTER TABLE [dbo].[Assignment] ADD  CONSTRAINT [DF_Assignment_allGraded]  DEFAULT ((0)) FOR [allGraded]
GO
ALTER TABLE [dbo].[StudentAssignment] ADD  CONSTRAINT [DF_StudentAssignment_isCompleted]  DEFAULT ((0)) FOR [isCompleted]
GO
ALTER TABLE [dbo].[StudentAssignment] ADD  CONSTRAINT [DF_StudentAssignment_isGraded]  DEFAULT ((0)) FOR [isGraded]
GO
ALTER TABLE [dbo].[StudentAssignment] ADD  CONSTRAINT [DF_StudentAssignment_isVisible]  DEFAULT ((0)) FOR [isVisible]
GO
ALTER TABLE [dbo].[AssignmentQuestions]  WITH CHECK ADD  CONSTRAINT [FK_AssignmentQuestions_Assignment] FOREIGN KEY([AssignmentID])
REFERENCES [dbo].[Assignment] ([AssignmentID])
GO
ALTER TABLE [dbo].[AssignmentQuestions] CHECK CONSTRAINT [FK_AssignmentQuestions_Assignment]
GO
ALTER TABLE [dbo].[AssignmentQuestions]  WITH CHECK ADD  CONSTRAINT [FK_AssignmentQuestions_Question] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Question] ([QuestionID])
GO
ALTER TABLE [dbo].[AssignmentQuestions] CHECK CONSTRAINT [FK_AssignmentQuestions_Question]
GO
ALTER TABLE [dbo].[Choice]  WITH CHECK ADD  CONSTRAINT [PKStudentAssignmentFKFasTestUser] FOREIGN KEY([ChoiceID])
REFERENCES [dbo].[Choice] ([ChoiceID])
GO
ALTER TABLE [dbo].[Choice] CHECK CONSTRAINT [PKStudentAssignmentFKFasTestUser]
GO
ALTER TABLE [dbo].[ClassQuestions]  WITH CHECK ADD  CONSTRAINT [PKClassFKClassQuestions] FOREIGN KEY([ClassID])
REFERENCES [dbo].[Class] ([ClassID])
GO
ALTER TABLE [dbo].[ClassQuestions] CHECK CONSTRAINT [PKClassFKClassQuestions]
GO
ALTER TABLE [dbo].[ClassStudent]  WITH CHECK ADD  CONSTRAINT [PKClassFKClassStudent] FOREIGN KEY([ClassID])
REFERENCES [dbo].[Class] ([ClassID])
GO
ALTER TABLE [dbo].[ClassStudent] CHECK CONSTRAINT [PKClassFKClassStudent]
GO
ALTER TABLE [dbo].[ClassStudent]  WITH CHECK ADD  CONSTRAINT [PKFasTestUserFKClassStudent] FOREIGN KEY([StudentID])
REFERENCES [dbo].[FasTestUser] ([IDNumber])
GO
ALTER TABLE [dbo].[ClassStudent] CHECK CONSTRAINT [PKFasTestUserFKClassStudent]
GO
ALTER TABLE [dbo].[QuestionTrueFalse]  WITH CHECK ADD  CONSTRAINT [PKQuestionFKQuestionTF] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Question] ([QuestionID])
GO
ALTER TABLE [dbo].[QuestionTrueFalse] CHECK CONSTRAINT [PKQuestionFKQuestionTF]
GO
/****** Object:  StoredProcedure [dbo].[Add_Class]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Add_Class]
	  @pClassTitle varchar(50),
	  @pGroupName varchar(20),
	  @pInstructorID int
	  
AS
BEGIN
      DECLARE @NewID INT = 0;
      INSERT INTO Class( ClassTitle, GroupName, InstructorID)
			VALUES (@pClassTitle, @pGroupName, @pInstructorID);
END;
GO
/****** Object:  StoredProcedure [dbo].[Add_Existing_Question]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Add_Existing_Question]
	@AssignmentID int,
	@QuestionID int
as
begin
	if not exists (select AssignmentID, QuestionID from AssignmentQuestions
					where AssignmentID = @AssignmentID
					AND QuestionID = @QuestionID)
	begin
		insert into AssignmentQuestions(AssignmentID, QuestionID)
		values(@AssignmentID, @QuestionID)
	end
end
GO
/****** Object:  StoredProcedure [dbo].[Add_MultipleChoice]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Add_MultipleChoice]
	@pAssignmentID int,
	@pQuestionDesc varchar(200),
	@pChoice1 varchar(100),
	@pChoice2 varchar(100),
	@pChoice3 varchar(100),
	@pChoice4 varchar(100),
	@pAnswer int,
	@pPointValue int
as
begin
	declare @QuestionID int --New question id

	--Create new question
	insert into Question
	values(1, @pQuestionDesc, @pPointValue)

	--Get new question id
	select @QuestionID = max(QuestionID) from Question

	--Add question to list for its test
	insert into AssignmentQuestions (AssignmentID, QuestionID) 
	values (@pAssignmentID, @QuestionID)

	--Add choices and answer
	insert into QuestionMultipleChoice
	values(@QuestionID, @pChoice1, @pChoice2, @pChoice3, @pChoice4, @pAnswer)

	--Add points of new question to test
	update Assignment
	set PointsPossible = PointsPossible + @pPointValue
	where AssignmentID = @pAssignmentID
end
GO
/****** Object:  StoredProcedure [dbo].[Add_ShortAnswer]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Add_ShortAnswer]
	@pAssignmentID int,
	@pQuestionDesc varchar(200),
	@pAnswer varchar(100),
	@pPointValue int
as
begin
	declare @QuestionID int --New question id

	--Create new question
	insert into Question
	values(2, @pQuestionDesc, @pPointValue)

	--Get new question id
	select @QuestionID = max(QuestionID) from Question

	--Add  question to list for its test
	insert into AssignmentQuestions (AssignmentID, QuestionID) 
	values (@pAssignmentID, @QuestionID)

	--Add answer
	insert into QuestionShortAnswer
	values(@QuestionID, @pAnswer)

	--Add points of new question to test
	update Assignment
	set PointsPossible = PointsPossible + @pPointValue
	where AssignmentID = @pAssignmentID
end
GO
/****** Object:  StoredProcedure [dbo].[Add_Student_Choice]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Add_Student_Choice]
	@pStudentTestID int,
	@pQuestionID int,
	@pChoice varchar(100)
as
begin
	declare @PointValue int
	declare @isCorrect bit

	--Get point value of question
	select @PointValue = PointValue from Question
	where QuestionID = @pQuestionID

	--Check student's answer
	execute Grade_Student_Choice 
	@pQuestionID, @pChoice, @isCorrect output

	--Check if question has already been answered
	if((select QuestionID from Choice where StudentAssignmentID = @pStudentTestID and QuestionID = @pQuestionID) = @pQuestionID)
	begin
		--Already answered; change answer
		update Choice
		set Choice = @pChoice, isCorrect = @isCorrect
		where StudentAssignmentID = @pStudentTestID and QuestionID = @pQuestionID
	end
	
	else
	begin
		--Not answered yet; add student selection
		insert into Choice(QuestionID, Choice, StudentAssignmentID, isCorrect, PointValue)
		values(@pQuestionID, @pChoice, @pStudentTestID, @isCorrect, @PointValue)
	end
end
GO
/****** Object:  StoredProcedure [dbo].[Add_TrueFalse]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Add_TrueFalse]
	@pAssignmentID int,
	@pQuestionDesc varchar(200),
	@pAnswer bit,
	@pPointValue int
as
begin
	declare @QuestionID int --New question id

	--Create new question
	insert into Question
	values(3, @pQuestionDesc, @pPointValue) 

	--Get new question id
	select @QuestionID = max(QuestionID) from Question

	--Add question to list for its test
	insert into AssignmentQuestions (AssignmentID, QuestionID) 
	values (@pAssignmentID, @QuestionID)

	--Add answer
	insert into QuestionTrueFalse
	values(@QuestionID, @pAnswer)

	--Add points of new question to test
	update Assignment
	set PointsPossible = PointsPossible + @pPointValue
	where AssignmentID = @pAssignmentID
end
GO
/****** Object:  StoredProcedure [dbo].[Add_User]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Add_User]
      @pPassword NVARCHAR(50),
	  @pSalt NVARCHAR(15),
	  @pCredentialLevel INT,
	  @pFirstName NVARCHAR(20),
	  @pLastName NVARCHAR (20)
	  
AS
BEGIN
      DECLARE @NewID INT = 0;
      INSERT INTO FasTestUser( [Password], Salt, CredentialLevel, FirstName, LastName)
			VALUES (@pPassword, @pSalt, @pCredentialLevel, @pFirstName, @pLastName);
END;
GO
/****** Object:  StoredProcedure [dbo].[Change_Enrollment]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Change_Enrollment]
	@pClassID int,
	@pStudentID int,
	@pEnrollCode bit
as
begin
	declare test_Cursor cursor for 
	select AssignmentID from Assignment 
	where ClassID = @pClassID

	declare @TestID int

	if @pEnrollCode = 1 --Enroll student
		begin
			--Student was previously enrolled
			if @pStudentID = (select DISTINCT StudentID from ClassStudent where StudentID = @pStudentID )
			and @pClassID = (select DISTINCT ClassID from ClassStudent where ClassID = @pClassID and StudentID = @pStudentID)
				update ClassStudent
				set IsEnrolled = @pEnrollCode
				where StudentID = @pStudentID and ClassID = @pClassID
			--Student was not enrolled before
			else
				insert into ClassStudent(StudentID, ClassID, IsEnrolled)
				values(@pStudentID, @pClassID, @pEnrollCode)
				-- Copy all Tests  --
				open test_Cursor
				fetch next from test_Cursor into @TestID
				while @@FETCH_STATUS = 0
					begin
						insert into StudentAssignment(ClassId, StudentID, AssignmentID)
						values(@pClassID, @pStudentID, @TestID)
						fetch next from test_Cursor into @TestID
					end
				close test_Cursor
			deallocate test_Cursor
		end
	else if @pEnrollCode = 0 --Unenroll student
		update ClassStudent
		set IsEnrolled = @pEnrollCode
		where StudentID = @pStudentID and ClassID = @pClassID
end
GO
/****** Object:  StoredProcedure [dbo].[Change_Pledge_Signed]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Change_Pledge_Signed]
	@pStudentTestID int,
	@pPledgeSigned bit
as
begin
	declare @PointsEarned int
	declare @PointsPossible int
	declare @Grade decimal(5,2)

	--Change pledge to signed/unsigned
	update StudentAssignment
	set PledgeSigned = @pPledgeSigned
	where StudentAssignmentID = @pStudentTestID

	--Set grade to 0 if pledge not signed
	if(@pPledgeSigned = 0)
	begin
		update StudentAssignment
		set Grade = 0.00
		where StudentAssignmentID = @pStudentTestID
	end

	--Calculate grade if pledge signed
	else if(@pPledgeSigned = 1)
	begin
		--Get points earned by student
		select @PointsEarned = PointsEarned
		from StudentAssignment
		where StudentAssignmentID = @pStudentTestID

		--Get total points in test
		select @PointsPossible = PointsPossible from Assignment
		where AssignmentID = (select AssignmentID from StudentAssignment where StudentAssignmentID = @pStudentTestID);

		--Calculate grade based on points
		select @Grade = cast(@PointsEarned as float) / cast(@PointsPossible as float) * 100;

		--Set student's test grade
		update StudentAssignment
		set Grade = @Grade 
		where StudentAssignmentID = @pStudentTestID
	end
end
GO
/****** Object:  StoredProcedure [dbo].[Change_Pledge_Signed_Grading]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Change_Pledge_Signed_Grading]
	@pSigned bit,
	@pStudentID int,
	@pAssignmentID int
as
begin
	declare @pStudentTestID int
	select @pStudentTestID = StudentAssignmentID from StudentAssignment where StudentID = @pStudentID and AssignmentID = @pAssignmentID
	execute Change_Pledge_Signed @pStudentTestID, @pPledgeSigned = @pSigned
end
GO
/****** Object:  StoredProcedure [dbo].[Change_Test_Visiblity]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Change_Test_Visiblity]
	@pVisible bit,
	@pStudentID int,
	@pAssignmentID int
as
begin
	update StudentAssignment set isVisible = @pVisible where StudentID = @pStudentID and AssignmentID = @pAssignmentID
end
GO
/****** Object:  StoredProcedure [dbo].[Check_Pledge_Signed]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Check_Pledge_Signed]
	@pStudentTestID int
as
begin
	--Check if the student signed the pledge for the test
	select PledgeSigned
	from StudentAssignment
	where StudentAssignmentID = @pStudentTestID
end
GO
/****** Object:  StoredProcedure [dbo].[Check_Test_Expiration]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Check_Test_Expiration]
	@pStudentTestID int
as
begin
	declare @TestStart datetime
	declare @TestDuration int
	declare @TestEnd datetime

	--Get when the student started the test
	select @TestStart = TimeStarted
	from StudentAssignment
	where StudentAssignmentID = @pStudentTestID

	--Get test time limit
	select @TestDuration = TestDuration
	from Assignment
	where AssignmentID = (select AssignmentID from StudentAssignment where StudentAssignmentID = @pStudentTestID)

	--Calculate test end time
	select @TestEnd = DATEADD(minute, @TestDuration, @TestStart)

	--Check if test has expired
	if(@TestEnd < GETDATE())
	begin
		select 0 --Time has expired
	end
	else
	begin
		select 1 --Test time remains
	end
end
GO
/****** Object:  StoredProcedure [dbo].[Copy_Question]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Copy_Question]
	@pQuestionID int,  --Question being copied
	@pAssignmentID int --Test that the question is being copied into
as
begin
	declare @QuestionDescription varchar(200);
	declare @NewQuestionID int;
	declare @QuestionType int;

	select @QuestionDescription = QuestionDescription from Question where QuestionID = @pQuestionID
	select @QuestionType = QuestionType from Question where QuestionID = @pQuestionID
    
	--Check to make sure question being copied is not already in test
	if not exists(select AssignmentID, AssignmentQuestions.QuestionID 
				  from AssignmentQuestions 
				  join Question on AssignmentQuestions.QuestionID = Question.QuestionID
				  where AssignmentID = @pAssignmentID AND QuestionDescription = @QuestionDescription)
	begin
		--True/False
		if @QuestionType = 3
		begin
			--Copy question details into new question
			insert into Question
			select QuestionType, QuestionDescription, PointValue from Question
			where QuestionID = @pQuestionID

			--Get new question id
			select @NewQuestionID = max(QuestionID) from Question

			--Copy question answer into new question
			insert into QuestionTrueFalse 
			select @NewQuestionID, Answer from QuestionTrueFalse
			where QuestionID = @pQuestionID
		end

		--Short answer
		else if @QuestionType = 2
		begin
			--Copy question details into new question
			insert into Question
			select QuestionType, QuestionDescription, PointValue from Question
			where QuestionID = @pQuestionID

			--Get new question id
			select @NewQuestionID = max(QuestionID) from Question

			--Copy question answer into new question
			insert into QuestionShortAnswer 
			select @NewQuestionID, Answer from QuestionShortAnswer
			where QuestionID = @pQuestionID
		end

		--Multiple choice
		else if @QuestionType = 1
		begin
			--Copy question details into new question
			insert into Question
			select QuestionType, QuestionDescription, PointValue from Question
			where QuestionID = @pQuestionID

			--Get new question id
			select @NewQuestionID = max(QuestionID) from Question

			--Copy question choices and answer into new question
			insert into QuestionMultipleChoice 
			select @NewQuestionID, PossibleAnswer1, PossibleAnswer2, PossibleAnswer3, PossibleAnswer4, Answer 
			from QuestionMultipleChoice
			where QuestionID = @pQuestionID
		end
	
	--Insert copied question into test list of questions
	insert into AssignmentQuestions (AssignmentID, QuestionID) values (@pAssignmentID, @NewQuestionID)

	--Add points of copied question into test
	update Assignment
	set PointsPossible = PointsPossible + (select PointValue from Question where QuestionID = @pQuestionID)
	where AssignmentID = @pAssignmentID
	end
end
GO
/****** Object:  StoredProcedure [dbo].[Create_Test]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Create_Test]
	@pClassID int,
	@pTestName varchar(50)
as
begin
	declare @TestID int
	declare @StudentID int

	declare Student_Cursor cursor for 
	select StudentID from ClassStudent 
	where ClassID = @pClassID and IsEnrolled = 1

	--Check for duplicate test name in class
	if @pTestName = (select AssignmentName from Assignment where ClassID = @pClassID and AssignmentName = @pTestName)
		begin
			select -1
		end
	else
		begin
			--Insert new test
			insert into Assignment(ClassID, AssignmentName)
			values(@pClassID, @pTestName)

			--Get new test id
			select @TestID = AssignmentID from Assignment
			where ClassID = @pClassID and AssignmentName = @pTestName

			select @TestID

			--Create test for each student
			open Student_Cursor
			fetch next from Student_Cursor into @StudentID
			while @@FETCH_STATUS = 0
				begin
					insert into StudentAssignment(ClassId, StudentID, AssignmentID, PledgeSigned)
					values(@pClassID, @StudentID, @TestID, 0)
					fetch next from Student_Cursor into @StudentID
				end
			close Student_Cursor
			deallocate Student_Cursor
		end
end
GO
/****** Object:  StoredProcedure [dbo].[Delete_Enrollment]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Delete_Enrollment]
	@pClassID int,
	@pStudentID int
as
begin
	delete from ClassStudent
	where ClassID = @pClassID
	and StudentID = @pStudentID
end
GO
/****** Object:  StoredProcedure [dbo].[Delete_Question_From_Test]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Delete_Question_From_Test]
 @AssignmentID int,
 @QuestionID int
 as
 begin
	declare @QuestionType int
	declare @PointValue int

	select @PointValue = PointValue 
	from Question 
	where QuestionID = @QuestionID
	
	if(((select PointsPossible from Assignment where AssignmentID = @AssignmentID) - @PointValue) < 0)
	begin
		update Assignment
		set PointsPossible = 0
		where AssignmentID = @AssignmentID
	end
	else
	begin
		update Assignment
		set PointsPossible = PointsPossible - @PointValue
		where AssignmentID = @AssignmentID
	end
	
	select @QuestionType = QuestionType from Question where QuestionID = @QuestionID;
	delete from AssignmentQuestions where AssignmentID = @AssignmentID and QuestionID = @QuestionID
	
	if @QuestionType = 3
		delete from QuestionTrueFalse where QuestionID = @QuestionID;
	else if @QuestionType = 2
		delete from QuestionShortAnswer where QuestionID = @QuestionID;
	else if @QuestionType = 1
		delete from QuestionMultipleChoice where QuestionID = @QuestionID;
	delete from Question where QuestionID = @QuestionID

	
	
end
GO
/****** Object:  StoredProcedure [dbo].[Delete_Test]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Delete_Test]
	@pTestID int
as
begin
	--Check that no students have taken the test
	if(0 = all(select isCompleted from StudentAssignment where AssignmentID = @pTestID))
	begin
		
		--Delete list of questions
		delete from AssignmentQuestions
		where AssignmentID = @pTestID

		--Delete each multiple choice question
		delete from QuestionMultipleChoice
		where QuestionID in (select QuestionID from AssignmentQuestions where AssignmentID = @pTestID)

		--Delete each short answer question
		delete from QuestionShortAnswer
		where QuestionID in (select QuestionID from AssignmentQuestions where AssignmentID = @pTestID)

		--Delete each true/false question
		delete from QuestionTrueFalse
		where QuestionID in (select QuestionID from AssignmentQuestions where AssignmentID = @pTestID)

		--Delete each question
		delete from Question
		where QuestionID in (select QuestionID from AssignmentQuestions where AssignmentID = @pTestID)

		--Delete each student's copy of the test
		delete from StudentAssignment
		where AssignmentID = @pTestID

		--Delete test
		delete from Assignment
		where AssignmentID = @pTestID
	end
		
end
GO
/****** Object:  StoredProcedure [dbo].[Delete_User]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Delete_User]
	@pUserID int
as
begin
	declare @credentialLevel int
	declare @ClassesEnrolled int
	select @credentialLevel = credentialLevel from FasTestUser where IDNumber = @pUserID
	if @credentialLevel = 1
		delete from FasTestUser where @pUserID = IDNumber
	else if @credentialLevel = 2
	begin
		update class set InstructorID = 0 where InstructorID = @pUserID
		delete from FasTestUser where IDNumber = @pUserID
	end
	else if @credentialLevel = 3
	begin
		
	select @ClassesEnrolled = count(ClassID) from ClassStudent where StudentID = @pUserID
	if @ClassesEnrolled = 0
		delete from FasTestUser where @pUserID = IDNumber
	else
		return 1;
	end
end
GO
/****** Object:  StoredProcedure [dbo].[Display_Answers_To_Student]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Display_Answers_To_Student]
	@pStudentTestID int
as
begin
	declare @TestID int

	--Get official test id
	select @TestID = AssignmentID
	from StudentAssignment
	where StudentAssignmentID = @pStudentTestID

	--Get questions from the specific test
	select Q.QuestionDescription as 'Question',
	--Get student's answers from the specific test
	case Q.QuestionType 
		when 1 then case C.Choice
					when 1 then concat('A:', ' ', QMC.PossibleAnswer1)
					when 2 then concat('B:', ' ', QMC.PossibleAnswer2)
					when 3 then concat('C:', ' ', QMC.PossibleAnswer3)
					when 4 then concat('D:', ' ', QMC.PossibleAnswer4)
					end
		when 2 then C.Choice
		when 3 then case C.Choice
						when 0 then 'False'
						when 1 then 'True'
						end
		end as'Student Answer',
	Q.PointValue as 'Points', C.isCorrect as 'Correct'
	from Question Q
	left join QuestionMultipleChoice QMC on Q.QuestionID = QMC.QuestionID
	left join QuestionShortAnswer QSA on Q.QuestionID = QSA.QuestionID
	left join QuestionTrueFalse QTF on Q.QuestionID = QTF.QuestionID
	join Choice C on Q.QuestionID = C.QuestionID
	where Q.QuestionID in (select QuestionID from AssignmentQuestions where AssignmentID = @TestID)
	and C.StudentAssignmentID = @pStudentTestID
end
GO
/****** Object:  StoredProcedure [dbo].[Display_Student_Class_Grades]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Display_Student_Class_Grades]
	@pStudentID int,
	@pClassID int
as
begin
	--Get a student's test grades for a single class
	select AssignmentName, concat(PointsEarned, '/', PointsPossible) Points, Concat(cast(Grade as int), '%') Grade, concat( DATEPART(month, TimeStarted), '/', DATEPART(day, TimeStarted), '/', DATEPART(year, TimeStarted)) Date
	from Assignment A
	join StudentAssignment SA on SA.AssignmentID = A.AssignmentID
	where StudentID = @pStudentID 
	      and SA.ClassID = @pClassID 
		  and isVisible = 1
		  and Grade is not null
end
GO
/****** Object:  StoredProcedure [dbo].[Display_Student_Grades]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Display_Student_Grades]
	@pStudentID int
as
begin
	--Get all of a student's test grades
	select ClassTitle, AssignmentName, Grade
	from StudentAssignment SA
	join Assignment A on A.AssignmentID = SA.AssignmentID
	join Class C on C.ClassID = A.ClassID
	where StudentID = @pStudentID and isGraded = 1 and Grade is not null
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Admin_Stats]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Admin_Stats]
as
begin
	declare @UserCount int
	declare @ClassCount int
	declare @TestCount int
	declare @NullFlag int = -99

	--Get number of users, classes, and tests in the database
	select @UserCount = count(IDNumber) from FasTestUser
	select @ClassCount = count(ClassID) from Class
	select @TestCount = count(AssignmentID) from Assignment

	--Check for null values before returning
	if(@UserCount is null)
		select @UserCount = @NullFlag
	else if(@ClassCount is null)
		select @ClassCount = @NullFlag
	else if(@TestCount is null)
		select @TestCount = @NullFlag

	--Return stats
	select @UserCount, @ClassCount, @TestCount
end
GO
/****** Object:  StoredProcedure [dbo].[Get_All_Students_Tests]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_All_Students_Tests]
	@pTestID int
as
begin
	select isVisible, SA.StudentID, CONCAT(U.FirstName, ' ', U.LastName) as StudentName,
	--Get correct answers from the specific test
	case SA.isGraded
		when  0 then 
			case SA.isCompleted
				when 0 then
					case
						when SA.TimeStarted is null then 'Not Started'
						when SA.TimeStarted is not null then 'In Progress'
					end
				when 1 then 'Not Graded'
			end
		when 1 then Concat(Cast(Cast(Grade as int) as varchar), '%') 
		end as 'Grade', PledgeSigned as 'isSigned'
	
	
	 from StudentAssignment SA join FasTestUser U on SA.StudentID = U.IDNumber where AssignmentID = @pTestID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Assignment_ID]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Assignment_ID]
 @AssignmentName varchar(50)
as
begin
	select AssignmentID from Assignment where AssignmentName = @AssignmentName
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Assignment_Questions]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Get_Assignment_Questions]
		@AssignmentID INT
AS
BEGIN
      select Question.QuestionID, QuestionDescription, 
	  case Question.QuestionType
		when 3 then 'True/False'
		when 2 then 'Short Answer'
		when 1 then 'Multiple Choice'
		end as 'QuestionType'
		from Question join AssignmentQuestions on Question.QuestionID = AssignmentQuestions.QuestionID where AssignmentQuestions.AssignmentID = @AssignmentID

END;
GO
/****** Object:  StoredProcedure [dbo].[Get_Bob_Some_Bananas]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Bob_Some_Bananas]
	@pStudentID int
as
begin
	--Get classes where the student has a test grade visible
	select distinct C.ClassID, LastName + ', ' + FirstName as 'Teacher', ClassTitle, 
	--Calculate and display student's class letter grade 
	case
		when sum(SA.Grade) / count(StudentAssignmentID) >= 97 then 'A+'
		when sum(SA.Grade) / count(StudentAssignmentID) >= 93 then 'A'
		when sum(SA.Grade) / count(StudentAssignmentID) >= 90 then 'A-'
		when sum(SA.Grade) / count(StudentAssignmentID) >= 87 then 'B+'
		when sum(SA.Grade) / count(StudentAssignmentID) >= 83 then 'B'
		when sum(SA.Grade) / count(StudentAssignmentID) >= 80 then 'B-'
		when sum(SA.Grade) / count(StudentAssignmentID) >= 77 then 'C+'
		when sum(SA.Grade) / count(StudentAssignmentID) >= 73 then 'C'
		when sum(SA.Grade) / count(StudentAssignmentID) >= 70 then 'C-'
		when sum(SA.Grade) / count(StudentAssignmentID) >= 67 then 'D+'
		when sum(SA.Grade) / count(StudentAssignmentID) >= 63 then 'D'
		when sum(SA.Grade) / count(StudentAssignmentID) >= 60 then 'D-'
		else 'F'
	end as 'LetterGrade'
	from Class C
	join FasTestUser FTU on C.InstructorID = FTU.IDNumber
	join StudentAssignment SA on SA.ClassId = C.ClassID
	where C.ClassID in (select ClassID from ClassStudent where StudentID = @pStudentID)
	  and StudentAssignmentID = any(select StudentAssignmentID from StudentAssignment where isVisible = 1 and StudentID = @pStudentID)
	group by C.ClassID, LastName, FirstName, ClassTitle
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Class_Details]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Class_Details]
	@pClassID int
as
begin
	declare @DaysLeft int
	declare @StudentCount int
	declare @HighGrade int
	declare @LowGrade int
	declare @AvgGrade int

	--Calculate number of days till the end of the class
	select @DaysLeft = DATEDIFF(second, getdate(), (select EndDate from Class where ClassID = @pClassID)) / 60 / 60 / 24 % 7

	--Get number of students enrolled in the class
	select @StudentCount = count(StudentID) from ClassStudent where ClassID = @pClassID and IsEnrolled = 1

	--Get highest student class average
	select @HighGrade = (select top 1 sum(Grade) / count(StudentAssignmentID)
						 from StudentAssignment
						 where Grade is not null and ClassId = @pClassID and isCompleted = 1
						 group by StudentID
						 order by sum(Grade) / count(StudentAssignmentID) desc)

	--Get lowest student class average
	select @LowGrade = (select top 1 sum(Grade) / count(StudentAssignmentID)
						 from StudentAssignment
						 where Grade is not null and ClassId = @pClassID and isCompleted = 1
						 group by StudentID
						 order by sum(Grade) / count(StudentAssignmentID) asc)

	--Get class average
	--select @AvgGrade = 

	--Return details of a specific class
	select StartDate, EndDate, @DaysLeft as DaysLeft, @StudentCount as StudentCount, @HighGrade as HighGrade, @LowGrade as LowGrade
	from Class
	where ClassID = @pClassID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Class_Information]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Class_Information]
as
begin
	select ClassID,  ClassTitle,  U.InstructorName, 
		   GroupName, StartDate, EndDate
	from Class 
	left join (select IDNumber, concat(FirstName, ' ', LastName) as InstructorName from FasTestUser) U on U.IDNumber = Class.InstructorID 
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Class_Instructor]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Get_Class_Instructor]
	@pClassID int
as
	
begin
	select (select concat(FirstName, ' ', LastName) from FasTestUser where IDNumber = C.InstructorID) InstructorName from Class C where @pClassID = ClassID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Class_Test_Names]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Class_Test_Names]
 @ClassID int
 as
 begin
	select distinct SA.AssignmentID, A.AssignmentName  from StudentAssignment SA 
    join Assignment A on SA.AssignmentID = A.AssignmentID where SA.AssignmentID 
	not in (select distinct AssignmentID from StudentAssignment where isCompleted = 1) and SA.ClassID = @ClassID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Class_Tests]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Class_Tests]
	@pClassID int,
	@pStudentID int
as
begin
	--Get list of tests that are currently open to take for a student in one class
	select distinct A.AssignmentID,  AssignmentName, StartDate,
	       Deadline, TestDuration, PointsPossible
	from Assignment A
	join StudentAssignment SA on A.AssignmentID = SA.AssignmentID
	where A.ClassID = @pClassID and StudentID = @pStudentID
		  and GETDATE() >= StartDate 
		  and GETDATE() < Deadline
		  and isCompleted = 0
	order by Deadline
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Class_Tests_For_Administering]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Class_Tests_For_Administering]
	@pClassID int
as
begin
	--Get list of tests that are currently open to take
	select AssignmentID,  AssignmentName, StartDate,
	       Deadline, TestDuration, PointsPossible
    from Assignment
	where ClassID = @pClassID
	
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Class_Title]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Class_Title]
	@pClassID int
as
	
begin
	select ClassTitle from class where @pClassID = ClassID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Credential_Level]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Get_Credential_Level]
		@Username NVARCHAR(20)
AS
BEGIN
	  
	  DECLARE @UserId INT
	  DECLARE @UserLevel INT

      SELECT  @UserLevel = CredentialLevel, @UserId = IDNumber
      FROM FasTestUser WHERE IDNumber = @Username

	   IF @UserId IS NULL
            SELECT -1 -- User invalid.
	  ELSE
		SELECT @UserLevel
      
END;
GO
/****** Object:  StoredProcedure [dbo].[Get_Enrolled_Users]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Enrolled_Users]
	@pClassID int
as
begin
	--Get all students enrolled in a class
	select IDNumber, CONCAT(FirstName, ' ', LastName) AS Name from FasTestUser
	where IDNumber in (select StudentID from ClassStudent where ClassID = @pClassID)
	and CredentialLevel = 3
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Existing_Class_Test_Names]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Get_Existing_Class_Test_Names]
 @ClassID int
 as
 begin
	select AssignmentID, AssignmentName from Assignment where ClassID = @ClassID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Existing_Class_Test_Names_For_Grading]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Get_Existing_Class_Test_Names_For_Grading]
 @ClassID int
 as
 begin
	select A.AssignmentID, A.AssignmentName from Assignment A where A.ClassID = @ClassID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_IDs]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_IDs]
as
begin
	select IDNumber as 'ID' from FasTestUser
end
GO
/****** Object:  StoredProcedure [dbo].[Get_MC_Information]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Get_MC_Information]
	@QuestionID int
as
begin
	select PossibleAnswer1, PossibleAnswer2, PossibleAnswer3, PossibleAnswer4, Answer from QuestionMultipleChoice where QuestionID = @QuestionID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Multiple_Choice]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Multiple_Choice]
	@pAssignmentID int
as
begin
	select Question.QuestionID , QuestionType, QuestionDescription
	from Question join AssignmentQuestions on AssignmentQuestions.QuestionID = question.QuestionID
	where AssignmentID = @pAssignmentID and QuestionType = 1
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Question_Choice]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Question_Choice]
	@pStudentAssignmentID int,
	@pQuestionID int
as
begin
	declare @StudentChoice varchar(100)

	--Get student's answer for a specific question
	select @StudentChoice = Choice
	from Choice
	where QuestionID = @pQuestionID and StudentAssignmentID = @pStudentAssignmentID

	--Check if student has answered question
	if(@StudentChoice is null)
	begin
		select '-1'
	end
	--Student has answered; get selection
	else
	begin
		select @StudentChoice
	end
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Question_Details]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Question_Details]
	@pQuestionID int,
	@pChoice1 varchar(100) output,
	@pChoice2 varchar(100) output,
	@pChoice3 varchar(100) output,
	@pChoice4 varchar(100) output,
	@pAnswer varchar(100) output
as
begin
	if (select QuestionType from Question where QuestionID = @pQuestionID) = 1 --Multiple choice
		begin
			select @pChoice1 = PossibleAnswer1, @pChoice2 = PossibleAnswer2, @pChoice3 = PossibleAnswer3, 
				   @pChoice4 = PossibleAnswer4, @pAnswer = Answer
			from QuestionMultipleChoice
			where QuestionID = @pQuestionID
		end
	else if (select QuestionType from Question where QuestionID = @pQuestionID) = 2 --Short answer
		begin
			select @pAnswer = Answer
			from QuestionShortAnswer
			where QuestionID = @pQuestionID

			select @pChoice1 = null, @pChoice2 = null, @pChoice3 = null, @pChoice4 = null
		end
	else if (select QuestionType from Question where QuestionID = @pQuestionID) = 3 --True/false
		begin
			select @pAnswer = Answer 
			from QuestionTrueFalse
			where QuestionID = @pQuestionID

			select @pChoice1 = null, @pChoice2 = null, @pChoice3 = null, @pChoice4 = null
		end
	else --Invalid question type
		begin
			select -1
		end
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Question_Information]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Question_Information]
@QuestionID int
as
begin
	select QuestionDescription, QuestionType, PointValue from Question where QuestionID = @QuestionID
	end
GO
/****** Object:  StoredProcedure [dbo].[Get_Questions_And_Choices]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Questions_And_Choices]
	@pTestID int
as
begin
	--Get each question with its possible answers from a specific assignment
	select Q.QuestionID, QuestionDescription, QuestionType, 
		   QMC.PossibleAnswer1, QMC.PossibleAnswer2, QMC.PossibleAnswer3, QMC.PossibleAnswer4
	from Question Q
	left join QuestionMultipleChoice QMC on Q.QuestionID = QMC.QuestionID
	where Q.QuestionID in (select QuestionID from AssignmentQuestions where AssignmentID = @pTestID)
	order by QuestionType
end
GO
/****** Object:  StoredProcedure [dbo].[Get_SA_Information]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Get_SA_Information]
	@QuestionID int
as
begin
	select answer from QuestionShortAnswer where QuestionID = @QuestionID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Short_Answer]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Short_Answer]
	@pAssignmentID int
as
begin
	select Question.QuestionID as 'ID', QuestionType as 'Type', QuestionDescription as 'Question'
	from Question join AssignmentQuestions on AssignmentQuestions.QuestionID = question.QuestionID
	where AssignmentID = @pAssignmentID and QuestionType = 2
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Student_Assignment]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Get_Student_Assignment]
	@pStudentID int,
	@pTestID int
as
begin
	select StudentAssignmentID 
	from StudentAssignment
	where StudentID = @pStudentID and AssignmentID = @pTestID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Student_Classes]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Student_Classes]
	@pStudentID int
as
begin
	--Get classes that the student is enrolled in
	select distinct ClassID, LastName + ', ' + FirstName as 'Teacher', ClassTitle, 
	       GroupName, StartDate, EndDate
	from Class C
	join FasTestUser FTU on C.InstructorID = FTU.IDNumber
	where ClassID in (select ClassID from ClassStudent where StudentID = @pStudentID)
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Student_Graded_Tests]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Student_Graded_Tests]
	@pStudentID int
as
begin
	--Get the student's tests that have been graded
	select StudentAssignmentID, C.ClassTitle, A.AssignmentName, Grade
	from StudentAssignment SA
	join Class C on SA.ClassId = C.ClassID
	join Assignment A on SA.AssignmentID = A.AssignmentID
	where StudentID = @pStudentID and isVisible = 1
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Student_Stats]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Student_Stats]
	@pStudentID int
as
begin
	declare @HighestScore int
	declare @TestAverage int
	declare @TestCount int
	declare @NullFlag int = -99

	--Get the student's highest test score
	select @HighestScore = max(Grade)
	from StudentAssignment
	where StudentID = @pStudentID 
	  and isGraded = 1
	  and isVisible = 1

	--Get average of student's test scores
	select @TestAverage = (sum(Grade) / count(StudentAssignmentID))
	from StudentAssignment
	where StudentID = @pStudentID 
	  and isGraded = 1
	  and isVisible = 1

	--Get number of available tests student can take
	select @TestCount = count(StudentAssignmentID)
	from StudentAssignment SA
	join Assignment A on A.AssignmentID = SA.AssignmentID
	where StudentID = @pStudentID
	  and isCompleted = 0
	  and GETDATE() >= StartDate
	  and GETDATE() < Deadline

	--Check for null values before returning
	if(@HighestScore is null)
		select @HighestScore = @NullFlag
	else if(@TestAverage is null)
		select @TestAverage = @NullFlag
	else if(@TestCount is null)
		select @TestCount = @NullFlag
	
	--Return stats
	select @HighestScore, @TestAverage, @TestCount
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Student_Test_Answers]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Student_Test_Answers]
	@pTestID int,
	@pStudentID int
as
begin
	declare @StudentTestID int

	--Get student's copy of the test
	select @StudentTestID = StudentAssignmentID 
	from StudentAssignment
	where AssignmentID = @pTestID and StudentID = @pStudentID

	--Get questions from the specific test
	select C.ChoiceID, Q.QuestionDescription as 'Question',
	--Get correct answers from the specific test
	case Q.QuestionType
		when 1 then case QMC.Answer
						when 1 then concat('A:', ' ', QMC.PossibleAnswer1)
						when 2 then concat('B:', ' ', QMC.PossibleAnswer2)
						when 3 then concat('C:', ' ', QMC.PossibleAnswer3)
						when 4 then concat('D:', ' ', QMC.PossibleAnswer4)
						end
		when 2 then QSA.Answer
		when 3 then case QTF.Answer
						when 0 then 'False'
						when 1 then 'True'
						end
		end as 'Correct Answer',
	--Get student's answers from a specific test
	case Q.QuestionType 
		when 1 then case C.Choice
					when 1 then concat('A:', ' ', QMC.PossibleAnswer1)
					when 2 then concat('B:', ' ', QMC.PossibleAnswer2)
					when 3 then concat('C:', ' ', QMC.PossibleAnswer3)
					when 4 then concat('D:', ' ', QMC.PossibleAnswer4)
					end
		when 2 then C.Choice
		when 3 then case C.Choice
						when 0 then 'False'
						when 1 then 'True'
						end
		end as'Student Answer',
	Q.PointValue as 'Points', C.isCorrect as 'Correct'
	from Question Q
	left join QuestionMultipleChoice QMC on Q.QuestionID = QMC.QuestionID
	left join QuestionShortAnswer QSA on Q.QuestionID = QSA.QuestionID
	left join QuestionTrueFalse QTF on Q.QuestionID = QTF.QuestionID
	join Choice C on Q.QuestionID = C.QuestionID
	where Q.QuestionID in (select QuestionID from AssignmentQuestions where AssignmentID = @pTestID)
	and C.StudentAssignmentID = @StudentTestID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Teacher_Class_Names]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Get_Teacher_Class_Names]
	@InstructorID int
as
begin
	SELECT ClassID, ClassTitle from class where InstructorID = @InstructorID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Teacher_Classes]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Teacher_Classes]
	@pTeacherID int
as
begin
	select ClassID , InstructorID , ClassTitle , 
		   GroupName , StartDate , EndDate
	from Class
	where InstructorID = @pTeacherID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Teacher_Questions]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Teacher_Questions]
 @InstructorID int,
 @AssignmentID int
as
begin
	select distinct Question.QuestionID, Question.QuestionDescription, 
	 case Question.QuestionType
		when 3 then 'True/False'
		when 2 then 'Short Answer'
		when 1 then 'Multiple Choice'
		end as 'QuestionType'
	 from Class join Assignment on Class.ClassID = Assignment.ClassID 
	            join AssignmentQuestions on Assignment.AssignmentID = AssignmentQuestions.AssignmentID 
				join Question on AssignmentQuestions.QuestionID = Question.QuestionID where InstructorID = @InstructorID and AssignmentQuestions.AssignmentID = @AssignmentID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Teacher_Stats]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Teacher_Stats]
	@pTeacherID int
as
begin
	declare @ClassCount int
	declare @TestName varchar(50)
	declare @ClassName varchar(50)
	declare @TestTime datetime
	declare @Days int
	declare @Hours int
	declare @Minutes int
	declare @NullFlag int = -99

	--Get number of classes the instructor is teaching
	select @ClassCount = count(ClassID) 
	from Class 
	where InstructorID = @pTeacherID

	--Get last test the teacher created
	select @TestName = AssignmentName, @ClassName = ClassTitle
	from Assignment A 
	join Class C on A.ClassID = C.ClassID 
	where C.InstructorID = @pTeacherID and AssignmentID = (select max(AssignmentID) from Assignment)

	--Get time last student took a test
	select @TestTime = max(TimeStarted) from StudentAssignment
	
	--Get number of days, hours, and minutes since last test was taken
	select @Days = DATEDIFF(second, @TestTime, getdate()) / 60 / 60 / 24 % 7
	select @Hours = DATEDIFF(second, @TestTime, getdate()) / 60 / 60 % 24
	select @Minutes = DATEDIFF(second, @TestTime, getdate()) / 60 % 60

	--Check for null values before returning
	if(@ClassCount is null)
		select @ClassCount = @NullFlag
	else if(@ClassName is null)
		select @ClassName = cast(@NullFlag as varchar)
	else if(@TestName is null)
		select @TestName = cast(@NullFlag as varchar)
	else if(@Days is null)
		select @Days = @NullFlag
	else if(@Hours is null)
		select @Hours = @NullFlag
	else if(@Minutes is null)
		select @Minutes = @NullFlag

	--Return stats
	select @ClassCount, @TestName, @ClassName, @Days, @Hours, @Minutes
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Teacher_Test_Names]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Get_Teacher_Test_Names]
 @InstructorID int
 as
 begin
	select AssignmentID, AssignmentName from Assignment join class on class.ClassID = Assignment.ClassID where @InstructorID = class.InstructorID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Teacher_Tests]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Teacher_Tests]
 @InstructorID int
as
begin
	select Question.QuestionID, Question.QuestionDescription, 
	 case Question.QuestionType
		when 3 then 'True/False'
		when 2 then 'Short Answer'
		when 1 then 'Multiple Choice'
		end as 'QuestionType'
	 from Class join Assignment on Class.ClassID = Assignment.ClassID 
	            join AssignmentQuestions on Assignment.AssignmentID = AssignmentQuestions.AssignmentID 
				join Question on AssignmentQuestions.QuestionID = Question.QuestionID where InstructorID = @InstructorID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Teachers]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Teachers]
as
begin
	select IDNumber, CONCAT(FirstName, ' ', LastName) AS Name from FasTestUser where CredentialLevel = 2;
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Test_Graded]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[Get_Test_Graded]
 @pTestID int,
 @pStudentID int
as
begin
	select isGraded from StudentAssignment where AssignmentID = @pTestID and StudentID = @pStudentID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Test_Name]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Get_Test_Name]
	@pTestID int
as
begin
	select AssignmentName 
	from Assignment
	where AssignmentID = @pTestID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Test_Name_And_Dates]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Get_Test_Name_And_Dates]
	@pTestID int
as
begin
	select AssignmentName, StartDate, Deadline, TestDuration 
	from Assignment
	where AssignmentID = @pTestID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Test_Time_Info]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Get_Test_Time_Info]
	@pStudentTestID int
as
begin
	declare @TestStart datetime
	declare @TestDuration int
	declare @TestEnd datetime

	--Get when the student started the test
	select @TestStart = TimeStarted
	from StudentAssignment
	where StudentAssignmentID = @pStudentTestID

	--Get test time limit
	select @TestDuration = TestDuration
	from Assignment
	where AssignmentID = (select AssignmentID from StudentAssignment where StudentAssignmentID = @pStudentTestID)

	--Calculate test end time
	select @TestEnd = DATEADD(minute, @TestDuration, @TestStart)

	--Return time values
	select @TestStart, @TestDuration, @TestEnd 
end
GO
/****** Object:  StoredProcedure [dbo].[Get_TF_Information]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Get_TF_Information]
	@QuestionID int
as
begin
	select answer from QuestionTrueFalse where QuestionID = @QuestionID
end
GO
/****** Object:  StoredProcedure [dbo].[Get_True_False]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_True_False]
	@pAssignmentID int
as
begin
	select Question.QuestionID as 'ID', QuestionType as 'Type', QuestionDescription as 'Question'
	from Question join AssignmentQuestions on AssignmentQuestions.QuestionID = question.QuestionID
	where AssignmentID = @pAssignmentID and QuestionType = 3
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Unenrolled_Users]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Unenrolled_Users]
	@pClassID int
as
begin
	select IDNumber, CONCAT(FirstName, ' ', LastName) AS Name from FasTestUser
	where IDNumber not in (select StudentID from ClassStudent where ClassID = @pClassID)
	and CredentialLevel = 3
end
GO
/****** Object:  StoredProcedure [dbo].[Get_Ungraded_Tests]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Get_Ungraded_Tests]
	@pTeacherID int
as
begin
	--Get teacher's ungraded tests that have been completed by the students
	select AssignmentName as 'Assignment', 'Pending Grading', DateDiff(hour, getDate(), Deadline) as 'Hours Since End' from StudentAssignment s join Assignment a on a.AssignmentID = s.AssignmentID
	where s.ClassId in (select ClassID from Class where InstructorID = @pTeacherID)
	      and isCompleted = 1
	      and isGraded = 0
		  and  Deadline  <= getdate()
	order by DateDiff(hour, Deadline, getDate())

	
end


--select * from assignment
GO
/****** Object:  StoredProcedure [dbo].[Get_Users_Name]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[Get_Users_Name]
	@pUserID int
as
	
begin
	select concat(FirstName, ' ', LastName) UsersName from FasTestUser where IDNumber = @pUserID
end
GO
/****** Object:  StoredProcedure [dbo].[GetGroupNames]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetGroupNames]
as
begin
	select distinct groupname as 'Group' from class
end
GO
/****** Object:  StoredProcedure [dbo].[Grade_Short_Answer]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Grade_Short_Answer]
	@pStudentTestID int,
	@pQuestionID int,
	@pPointsEarned int
as
begin
	declare @PointsPossible int

	--Get maximum points possible for question
	select @PointsPossible = PointValue from Question
	where QuestionID = @pQuestionID

	--Enter full or partial credit awarded by teacher for the question
	if(@pPointsEarned > 0 and @pPointsEarned <= @PointsPossible)
	begin
		update Choice
		set isCorrect = 1, PointValue = @pPointsEarned
		where StudentAssignmentID = @pStudentTestID and QuestionID = @pQuestionID
	end
	--Student got answer completely wrong
	else if(@pPointsEarned = 0)
	begin
		update Choice
		set isCorrect = 0
		where StudentAssignmentID = @pStudentTestID and QuestionID = @pQuestionID
	end
end
GO
/****** Object:  StoredProcedure [dbo].[Grade_Student_Choice]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Grade_Student_Choice]
	@pQuestionID int,
	@pChoice varchar(100),
	@pIsCorrect bit output
as
begin
	declare @QuestionType int

	--Get question type
	select @QuestionType = QuestionType from Question
	where QuestionID = @pQuestionID

	--Compare student choice and answer
	if(@QuestionType = 1) --Multiple choice
	begin
		if(@pChoice = (select convert(varchar(100), (select Answer from QuestionMultipleChoice where QuestionID = @pQuestionID))))
		begin
			select @pIsCorrect = 1
		end
		else
		begin
			select @pIsCorrect = 0
		end
	end

	else if(@QuestionType = 2) --Short answer
	begin
		--Mark correct if they put the exact answer
		if(@pChoice = (select Answer from QuestionShortAnswer where QuestionID = @pQuestionID))
		begin
			select @pIsCorrect = 1
		end
		--Teacher will review short answer questions
		else
		begin
			select @pIsCorrect = 0
		end
	end

	else if(@QuestionType = 3) --True/false
	begin
		if(@pChoice = (select convert(varchar(100), (select Answer from QuestionTrueFalse where QuestionID = @pQuestionID))))
		begin
			select @pIsCorrect = 1
		end
		else
		begin
			select @pIsCorrect = 0
		end
	end
end
GO
/****** Object:  StoredProcedure [dbo].[Grade_Student_Test]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Grade_Student_Test]
	@pStudentTestID int,
	@pPledgeSigned bit
as
begin
	declare @PointsEarned int
	declare @PointsPossible int
	declare @Grade decimal(5,2)

	--Add points of correct answers
	select @PointsEarned = sum(PointValue) from Choice
	where StudentAssignmentID = @pStudentTestID and isCorrect = 1;

	--Assign points earned to the student's test
	if(@PointsEarned is null)
	begin
		update StudentAssignment
		set PointsEarned = 0
		where StudentAssignmentID = @pStudentTestID;
	end
	else
	begin
		update StudentAssignment
		set PointsEarned = @PointsEarned
		where StudentAssignmentID = @pStudentTestID;
	end

	--Get total test points
	select @PointsPossible = PointsPossible from Assignment
	where AssignmentID = (select AssignmentID from StudentAssignment where StudentAssignmentID = @pStudentTestID);

	--Calculate grade based on points
	if(@PointsEarned is null)
		select @Grade = 0.00
	else
		select @Grade = cast(@PointsEarned as float) / cast(@PointsPossible as float) * 100;

	--Assign grade to student's test
	update StudentAssignment
	set Grade = @Grade
	where StudentAssignmentID = @pStudentTestID;

	--Mark test as completed
	update StudentAssignment
	set isCompleted = 1
	where StudentAssignmentID = @pStudentTestID;

	--Mark pledge as signed/unsigned
	update StudentAssignment
	set PledgeSigned = @pPledgeSigned
	where StudentAssignmentID = @pStudentTestID

	--Set grade to 0 if pledge not signed
	if(@pPledgeSigned = 0)
	begin
		update StudentAssignment
		set Grade = 0.00
		where StudentAssignmentID = @pStudentTestID
	end
end
GO
/****** Object:  StoredProcedure [dbo].[Mark_Test_Completed]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Mark_Test_Completed]
	@pStudentTestID int
as
begin
	update StudentAssignment set isCompleted = 1 where AssignmentID = @pStudentTestID
end
GO
/****** Object:  StoredProcedure [dbo].[Mark_Test_Graded]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Mark_Test_Graded]
 @pTestID int,
 @pStudentID int,
 @pGraded bit
as
begin
	update StudentAssignment set isGraded = @pGraded where AssignmentID = @pTestID and StudentID = @pStudentID
end
GO
/****** Object:  StoredProcedure [dbo].[Set_Test_Started]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Set_Test_Started]
	@pTestID int,
	@pStudentID int
as
begin
	declare @StudentTestID int

	--Get student's copy of the test
	select @StudentTestID = StudentAssignmentID 
	from StudentAssignment 
	where AssignmentID = @pTestID and StudentID = @pStudentID

	--Enter time that the student started the test
	if((select TimeStarted from StudentAssignment where StudentAssignmentID = @StudentTestID) is null)
	begin
		update StudentAssignment
		set TimeStarted = GETDATE()
		where StudentAssignmentID = @StudentTestID
	end
	
end
GO
/****** Object:  StoredProcedure [dbo].[Update_Class_Group]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Update_Class_Group]
	@pClassID int,
	@pGroupValue varchar(20)
as
begin		
				update Class
				set GroupName = @pGroupValue
				where ClassID = @pClassID
end
GO
/****** Object:  StoredProcedure [dbo].[Update_Class_Title]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Update_Class_Title]
	@pClassID int,
	@pClassTitle varchar(50)
as
begin		
				update Class
				set ClassTitle = @pClassTitle
				where ClassID = @pClassID
end
GO
/****** Object:  StoredProcedure [dbo].[Update_Multiple_Choice]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Update_Multiple_Choice]
	@pQuestionID int,
	@pQuestionDesc varchar(200),
	@pChoice1 varchar(100),
	@pChoice2 varchar(100),
	@pChoice3 varchar(100),
	@pChoice4 varchar(100),
	@pAnswer int,
	@pPointValue int
as
begin
	declare @TestID int

	--Get test that the question is in
	select @TestID = AssignmentID from AssignmentQuestions where QuestionID = @pQuestionID

	--Subtract old point value from test
	update Assignment
	set PointsPossible = PointsPossible - (select PointValue from Question where QuestionID = @pQuestionID)
	where AssignmentID = @TestID

	--Update question text and point value
	update Question
	set QuestionDescription = @pQuestionDesc, PointValue = @pPointValue
	where QuestionID = @pQuestionID

	--Update choices and answers
	update QuestionMultipleChoice
	set PossibleAnswer1 = @pChoice1, PossibleAnswer2 = @pChoice2, PossibleAnswer3 = @pChoice3, 
		PossibleAnswer4 = @pChoice4, Answer = @pAnswer
	where QuestionID = @pQuestionID

	--Add new point value into test
	update Assignment
	set PointsPossible = PointsPossible + (select PointValue from Question where QuestionID = @pQuestionID)
	where AssignmentID = @TestID
end
GO
/****** Object:  StoredProcedure [dbo].[Update_Password]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Update_Password]
	@pUserID int,
	@pSalt varchar(15),
	@pNewPassword varchar(50)
as
begin
	update FasTestUser
	set [Password] = @pNewPassword, Salt = @pSalt
	where IDNumber = @pUserID
end
GO
/****** Object:  StoredProcedure [dbo].[Update_Question_Correct]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[Update_Question_Correct]
	@pCorrect bit,
	@pChoiceID int
as
begin
	declare @PointValue int
	declare @PointsEarned int
	declare @StudentAssignmentID int
	declare @StudentGrade float
	declare @PointsPossible int
	select @StudentAssignmentID = StudentAssignmentID from Choice where ChoiceID = @pChoiceID
	Select @PointValue = PointValue from Choice where ChoiceID = @pChoiceID
	Select @PointsEarned = PointsEarned  from StudentAssignment where StudentAssignmentID = (Select StudentAssignmentID from Choice where ChoiceID =@pChoiceID)
	if @pCorrect = 1
		select @PointsEarned = @PointsEarned + @PointValue;
	else
		select @PointsEarned = @PointsEarned - @PointValue;
	update Choice set isCorrect = @pCorrect where ChoiceID = @pChoiceID
	update StudentAssignment set PointsEarned = @PointsEarned where StudentAssignmentID = @StudentAssignmentID
	Select @StudentGrade = (Cast(@PointsEarned as float) / Cast(PointsPossible as float)* 100) from Assignment A Join StudentAssignment SA on A.AssignmentID = SA.AssignmentID where SA.StudentAssignmentID = @StudentAssignmentID
	update StudentAssignment set Grade = @StudentGrade where StudentAssignmentID = @StudentAssignmentID
end
GO
/****** Object:  StoredProcedure [dbo].[Update_Short_Answer]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Update_Short_Answer]
	@pQuestionID int,
	@pQuestionDesc varchar(200),
	@pAnswer varchar(100),
	@pPointValue int
as
begin
	declare @TestID int

	--Get test that the question is in
	select @TestID = AssignmentID from AssignmentQuestions where QuestionID = @pQuestionID

	--Subtract old point value from test
	update Assignment
	set PointsPossible = PointsPossible - (select PointValue from Question where QuestionID = @pQuestionID)
	where AssignmentID = @TestID

	--Update question text and point value
	update Question
	set QuestionDescription = @pQuestionDesc, PointValue = @pPointValue
	where QuestionID = @pQuestionID

	--Update answer
	update QuestionShortAnswer
	set Answer = @pAnswer
	where QuestionID = @pQuestionID

	--Add new point value into test
	update Assignment
	set PointsPossible = PointsPossible + (select PointValue from Question where QuestionID = @pQuestionID)
	where AssignmentID = @TestID
end
GO
/****** Object:  StoredProcedure [dbo].[Update_Start_Or_End_Date]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Update_Start_Or_End_Date]
	@pTestID int,
	@pNewStartDate datetime,
	@pNewEndDate datetime
as
begin
	--Change start date if new value
	if(@pNewStartDate is not null)
	begin
		update Assignment
		set StartDate = @pNewStartDate
		where AssignmentID = @pTestID
	end

	--Change end date if new value
	if(@pNewEndDate is not null)
	begin
		update Assignment
		set Deadline = @pNewEndDate
		where AssignmentID = @pTestID
	end
end
GO
/****** Object:  StoredProcedure [dbo].[Update_Teacher]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Update_Teacher]
	@pClassID int,
	@pInstructorID int
as
begin		
				update Class
				set InstructorID = @pInstructorID
				where ClassID = @pClassID
end
GO
/****** Object:  StoredProcedure [dbo].[Update_Test_Name_And_Dates]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Update_Test_Name_And_Dates]
	@pTestID int,
	@pTestName varchar(50),
	@pStartDate datetime,
	@pDeadline datetime,
	@pTestDuration int
as
begin
	update Assignment
	set AssignmentName = @pTestName, StartDate = @pStartDate, Deadline = @pDeadline, TestDuration = @pTestDuration
	where AssignmentID = @pTestID
end
GO
/****** Object:  StoredProcedure [dbo].[Update_True_False]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Update_True_False]
	@pQuestionID int,
	@pQuestionDesc varchar(200),
	@pAnswer bit,
	@pPointValue int
as
begin
	declare @TestID int

	--Get test that the question is in
	select @TestID = AssignmentID from AssignmentQuestions where QuestionID = @pQuestionID

	--Subtract old point value from test
	update Assignment
	set PointsPossible = PointsPossible - (select PointValue from Question where QuestionID = @pQuestionID)
	where AssignmentID = @TestID

	--Update question text and point value
	update Question
	set QuestionDescription = @pQuestionDesc, PointValue = @pPointValue
	where QuestionID = @pQuestionID

	--Update answer
	update QuestionTrueFalse
	set Answer = @pAnswer
	where QuestionID = @pQuestionID

	--Add new point value into test
	update Assignment
	set PointsPossible = PointsPossible + (select PointValue from Question where QuestionID = @pQuestionID)
	where AssignmentID = @TestID
end
GO
/****** Object:  StoredProcedure [dbo].[Update_Users_Name]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Update_Users_Name]
 @pUserID int,
 @pUserFirstName varchar(25),
 @pUserLastName varchar(25)
 as
 begin
	update FasTestUser set FirstName = @pUserFirstName, LastName = @pUserLastName where IDNumber = @pUserID
 end
GO
/****** Object:  StoredProcedure [dbo].[Validate_Password]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Validate_Password]
	@pUserID int,
	@pPassword varchar(50) output,
	@pSalt varchar(15) output,
	@CredentialLevel int output
as
begin
	--Get encoded password and hash to be compared for validation
	select @CredentialLevel = CredentialLevel, @pPassword = [Password], @pSalt = Salt
	from FasTestUser
	where IDNumber = @pUserID
end
GO
/****** Object:  StoredProcedure [dbo].[Validate_User]    Script Date: 4/19/2018 9:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Validate_User]
      @Username NVARCHAR(20),
      @Password NVARCHAR(20)
AS
BEGIN
      DECLARE @UserId INT
	  DECLARE @UserLevel INT
      
      SELECT @UserId = IDNumber, @UserLevel = CredentialLevel
      FROM FasTestUser WHERE IDNumber = @Username AND [Password] = @Password
      
      IF @UserId IS NULL
            SELECT -1 -- User invalid.
	  ELSE
		SELECT @UserLevel
END;
GO
USE [master]
GO
ALTER DATABASE [CS414_FasTest] SET  READ_WRITE 
GO
