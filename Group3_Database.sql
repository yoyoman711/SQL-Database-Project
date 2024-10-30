/****** Object:  Database [Group3]    Script Date: 12/18/2023 4:24:56 PM ******/
CREATE DATABASE [Group3]  (EDITION = 'GeneralPurpose', SERVICE_OBJECTIVE = 'GP_S_Gen5_1', MAXSIZE = 5 GB) WITH CATALOG_COLLATION = SQL_Latin1_General_CP1_CI_AS, LEDGER = OFF;
GO
ALTER DATABASE [Group3] SET COMPATIBILITY_LEVEL = 150
GO
ALTER DATABASE [Group3] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Group3] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Group3] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Group3] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Group3] SET ARITHABORT OFF 
GO
ALTER DATABASE [Group3] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Group3] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Group3] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Group3] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Group3] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Group3] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Group3] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Group3] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Group3] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [Group3] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Group3] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [Group3] SET  MULTI_USER 
GO
ALTER DATABASE [Group3] SET ENCRYPTION ON
GO
ALTER DATABASE [Group3] SET QUERY_STORE = ON
GO
ALTER DATABASE [Group3] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
/*** The scripts of database scoped configurations in Azure should be executed inside the target database connection. ***/
GO
-- ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
/****** Object:  User [Group3Admin]    Script Date: 12/18/2023 4:24:57 PM ******/
CREATE USER [Group3Admin] FOR LOGIN [Group3Admin] WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'Group3Admin'
GO
/****** Object:  Table [dbo].[Department]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartmentID] [int] NOT NULL,
	[DepartmentName] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeID] [int] NOT NULL,
	[DepartmentID] [int] NULL,
	[PositionID] [int] NULL,
	[FirstName] [varchar](255) NULL,
	[LastName] [varchar](255) NULL,
	[HireDate] [date] NULL,
	[EndDate] [date] NULL,
	[Salary] [decimal](10, 2) NULL,
	[TaxDeduction] [decimal](10, 2) NULL,
	[Bonus] [decimal](10, 2) NULL,
	[PTOHours] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[DepartmentBonusAndPTOView]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [dbo].[DepartmentBonusAndPTOView]
AS
SELECT
    d.DepartmentName as 'Department',
    (e.FirstName + ' ' + e.LastName) as 'Name',
    e.Bonus,
    e.PTOHours as 'PTO'
FROM dbo.Employee e
JOIN dbo.Department d ON e.DepartmentID = d.DepartmentID
GO
/****** Object:  View [dbo].[DepartmentSummary]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--A view that provides a list of departments along with a count of employees in each department.
create VIEW [dbo].[DepartmentSummary] AS
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS #ofEmployees
FROM dbo.Department d
LEFT JOIN dbo.Employee e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;
GO
/****** Object:  Table [dbo].[TimeCard]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimeCard](
	[TimeCardID] [int] NOT NULL,
	[EmployeeID] [int] NULL,
	[HolidayID] [int] NULL,
	[JobCode] [varchar](50) NULL,
	[HoursWorked] [decimal](5, 2) NULL,
	[Date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TimeCardID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[EmployeeTimeCardsView]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[EmployeeTimeCardsView] AS
SELECT 
	(e.FirstName + ' ' + e.LastName) as 'Name',
    tc.Date as 'DateWorked',
    SUM(tc.HoursWorked) AS TotalHoursWorkedOnDate
FROM 
    dbo.TimeCard tc JOIN Employee e on tc.EmployeeID = e.EmployeeID
GROUP BY 
    e.FirstName,
	e.LastName,
    tc.Date;
GO
/****** Object:  Table [dbo].[Position]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Position](
	[PositionID] [int] NOT NULL,
	[PositionName] [varchar](255) NULL,
	[JobCode] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PositionID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[EmployeeDetails]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--A view that shows employee details along with their department and position names.
create VIEW [dbo].[EmployeeDetails] AS
SELECT (e.FirstName + ' ' + e.LastName) as 'Name', d.DepartmentName, p.PositionName, e.HireDate, e.EndDate, e.Salary, e.Bonus, e.PTOHours
FROM dbo.Employee e
JOIN dbo.Department d ON e.DepartmentID = d.DepartmentID
JOIN dbo.Position p ON e.PositionID = p.PositionID;
GO
/****** Object:  Table [dbo].[JobPosting]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobPosting](
	[PostingID] [int] NOT NULL,
	[PositionID] [int] NULL,
	[DatePosted] [date] NULL,
	[HRApproval] [bit] NULL,
	[Description] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[PostingID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantTracking]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantTracking](
	[ApplicantID] [int] NOT NULL,
	[EmployeeID] [int] NULL,
	[FirstName] [varchar](255) NULL,
	[LastName] [varchar](255) NULL,
	[PositionAppliedFor] [int] NULL,
	[ApplicationDate] [date] NULL,
	[Status] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ApplicantID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[PositionSummary]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[PositionSummary] AS
SELECT  p.PositionName as Position, p.JobCode,
   	COUNT(j.PostingID) AS JobPostingsCount,
   	COUNT(a.ApplicantID) AS ApplicantsCount
FROM dbo.Position p
LEFT JOIN dbo.JobPosting j ON p.PositionID = j.PositionID
LEFT JOIN dbo.ApplicantTracking a ON p.PositionID = a.PositionAppliedFor
GROUP BY p.PositionID, p.PositionName, p.JobCode;
GO
/****** Object:  View [dbo].[AvgSalaryByPositionView]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[AvgSalaryByPositionView]
AS
SELECT
    p.PositionName,
    CAST(AVG(e.Salary) AS DECIMAL(10, 2)) AS AverageSalary  -- Truncates the average salary to two decimal places
FROM dbo.Employee e
JOIN dbo.Position p ON e.PositionID = p.PositionID
GROUP BY p.PositionName;



GO
/****** Object:  View [dbo].[PayrollReportWithDepartment]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[PayrollReportWithDepartment] AS
SELECT 
    e.FirstName + ' ' + e.LastName as [Name], 
    e.Salary as 'Gross Salary', e.TaxDeduction, e.Bonus,
    d.DepartmentName as [Department],
    (e.Salary - e.TaxDeduction + e.Bonus) AS NetSalary
FROM [dbo].[Employee] e
JOIN [dbo].[Department] d ON e.DepartmentID = d.DepartmentID;
GO
/****** Object:  View [dbo].[SumOfDepartmentSalaries]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SumOfDepartmentSalaries]
AS
SELECT 
    d.DepartmentName as 'Department',
    SUM(e.Salary) AS TotalDepartmentSalary
FROM 
    dbo.Employee e
JOIN 
    dbo.Department d ON e.DepartmentID = d.DepartmentID
GROUP BY 
	d.DepartmentName;
GO
/****** Object:  View [dbo].[HighestPaidEmployeeByDepartment]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [dbo].[HighestPaidEmployeeByDepartment]
AS
WITH RankedSalaries AS (
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.Salary,
        d.DepartmentID,
        d.DepartmentName,
        RANK() OVER (PARTITION BY e.DepartmentID ORDER BY e.Salary DESC) AS SalaryRank
    FROM dbo.Employee e
    JOIN dbo.Department d ON e.DepartmentID = d.DepartmentID
)
SELECT
    DepartmentName,
    (FirstName + ' ' + LastName) as 'Name',
    Salary
FROM RankedSalaries
WHERE SalaryRank = 1;
GO
/****** Object:  View [dbo].[ApplicantDetails]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--A view to display applicants with details about the position they applied for and the status of their application.
create VIEW [dbo].[ApplicantDetails] AS
SELECT (at.FirstName + ' ' + at.LastName) as 'Name', p.PositionName as 'PositionAppliedFor', at.ApplicationDate, at.Status
FROM dbo.ApplicantTracking at
JOIN dbo.Position p ON at.PositionAppliedFor = p.PositionID;
GO
/****** Object:  View [dbo].[JobPostingView]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create VIEW [dbo].[JobPostingView] AS
SELECT 
    p.PositionName,
    jp.DatePosted,
    CASE 
        WHEN jp.HRApproval = 1 THEN 'Yes'
        ELSE 'No Potatoes For You'
    END AS HRApprovalStatus
FROM 
    dbo.JobPosting jp
JOIN 
    dbo.Position p ON jp.PositionID = p.PositionID;


GO
/****** Object:  Table [dbo].[Holiday]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Holiday](
	[HolidayID] [int] NOT NULL,
	[HolidayName] [varchar](255) NULL,
	[Date] [date] NULL,
	[IsPaid] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[HolidayID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[UpcomingHolidaysWithDaysUntil]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[UpcomingHolidaysWithDaysUntil]
AS
SELECT
    HolidayName,
    Date AS HolidayDate,
    DATEDIFF(DAY, CAST(GETDATE() AS DATE), Date) AS DaysUntilHoliday
FROM dbo.Holiday
WHERE Date >= CAST(GETDATE() AS DATE);
GO
/****** Object:  Table [dbo].[DeductionOption]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionOption](
	[DeductionOptionID] [int] NOT NULL,
	[Description] [text] NULL,
	[Amount] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[DeductionOptionID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeDeduction]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeDeduction](
	[DeductionOptionID] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[AmountDeducted] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[DeductionOptionID] ASC,
	[EmployeeID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeRole]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeRole](
	[EmployeeID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC,
	[RoleID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayrollCycle]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollCycle](
	[PayrollID] [int] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[PayDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[PayrollID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemRole]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemRole](
	[RoleID] [int] NOT NULL,
	[RoleName] [varchar](255) NULL,
	[Description] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ThirdPartyInterface]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThirdPartyInterface](
	[InterfaceID] [int] NOT NULL,
	[Name] [varchar](255) NULL,
	[Description] [text] NULL,
	[Type] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[InterfaceID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VacationOption]    Script Date: 12/18/2023 4:24:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VacationOption](
	[VacationID] [int] NOT NULL,
	[YearsOfServiceFrom] [int] NULL,
	[YearsOfServiceTo] [int] NULL,
	[HoursPerWeekFrom] [decimal](5, 2) NULL,
	[HoursPerWeekTo] [decimal](5, 2) NULL,
	[VacationDays] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[VacationID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (1, NULL, N'John', N'Doe', 1, CAST(N'2023-01-15' AS Date), N'Applied')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (2, NULL, N'Jane', N'Smith', 2, CAST(N'2023-01-20' AS Date), N'Applied')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (3, NULL, N'Michael', N'Johnson', 3, CAST(N'2023-02-05' AS Date), N'Under Review')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (4, NULL, N'Emily', N'Davis', 4, CAST(N'2023-02-10' AS Date), N'Under Review')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (5, NULL, N'Robert', N'Wilson', 1, CAST(N'2023-03-02' AS Date), N'Rejected')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (6, NULL, N'Sarah', N'Brown', 2, CAST(N'2023-03-10' AS Date), N'Interview Scheduled')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (7, NULL, N'William', N'Lee', 3, CAST(N'2023-03-15' AS Date), N'Interview Scheduled')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (8, NULL, N'Jessica', N'Martinez', 4, CAST(N'2023-04-01' AS Date), N'Offer Extended')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (9, NULL, N'David', N'Taylor', 1, CAST(N'2023-04-05' AS Date), N'Offer Accepted')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (10, NULL, N'Olivia', N'Anderson', 2, CAST(N'2023-04-20' AS Date), N'Hired')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (11, NULL, N'James', N'Garcia', 3, CAST(N'2023-05-05' AS Date), N'Applied')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (12, NULL, N'Sophia', N'Hernandez', 4, CAST(N'2023-05-10' AS Date), N'Applied')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (13, NULL, N'Benjamin', N'Moore', 1, CAST(N'2023-06-02' AS Date), N'Under Review')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (14, NULL, N'Ava', N'Wilson', 2, CAST(N'2023-06-10' AS Date), N'Under Review')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (15, NULL, N'Ethan', N'Clark', 3, CAST(N'2023-07-01' AS Date), N'Interview Scheduled')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (16, NULL, N'Mia', N'Lewis', 4, CAST(N'2023-07-15' AS Date), N'Interview Scheduled')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (17, NULL, N'Daniel', N'Walker', 1, CAST(N'2023-08-05' AS Date), N'Offer Extended')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (18, NULL, N'Sofia', N'Young', 2, CAST(N'2023-08-10' AS Date), N'Offer Declined')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (19, NULL, N'Matthew', N'Hall', 3, CAST(N'2023-09-02' AS Date), N'Applied')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (20, NULL, N'Avery', N'White', 4, CAST(N'2023-09-20' AS Date), N'Applied')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (21, NULL, N'Oliver', N'Lopez', 1, CAST(N'2023-10-05' AS Date), N'Under Review')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (22, NULL, N'Chloe', N'Scott', 2, CAST(N'2023-10-10' AS Date), N'Under Review')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (23, NULL, N'Emma', N'Adams', 3, CAST(N'2023-11-01' AS Date), N'Interview Scheduled')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (24, NULL, N'Jackson', N'Green', 4, CAST(N'2023-11-15' AS Date), N'Interview Scheduled')
GO
INSERT [dbo].[ApplicantTracking] ([ApplicantID], [EmployeeID], [FirstName], [LastName], [PositionAppliedFor], [ApplicationDate], [Status]) VALUES (25, NULL, N'Noah', N'Carter', 1, CAST(N'2023-12-01' AS Date), N'Offer Extended')
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (1, N'Health Insurance Premium', CAST(200.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (2, N'Dental Insurance Premium', CAST(50.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (3, N'Vision Insurance Premium', CAST(30.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (4, N'401(k) Contribution', CAST(150.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (5, N'HSA Contribution', CAST(100.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (6, N'FSA Contribution', CAST(50.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (7, N'Life Insurance Premium', CAST(20.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (8, N'Disability Insurance Premium', CAST(25.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (9, N'Union Dues', CAST(75.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (10, N'Charitable Contribution', CAST(10.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (11, N'Stock Purchase Plan', CAST(200.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (12, N'Childcare FSA Contribution', CAST(75.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (13, N'Gym Membership Deduction', CAST(30.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (14, N'Professional Development Fund', CAST(50.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (15, N'Parking Fees Deduction', CAST(40.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (16, N'Transportation Subsidy', CAST(60.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (17, N'Employee Stock Purchase Plan', CAST(100.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (18, N'Wellness Program Deduction', CAST(15.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (19, N'Education Assistance Deduction', CAST(75.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (20, N'Union Membership Dues', CAST(50.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (21, N'Alumni Association Membership', CAST(10.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (22, N'Child Support Deduction', CAST(75.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (23, N'Credit Union Membership', CAST(20.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (24, N'Employee Assistance Program', CAST(15.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[DeductionOption] ([DeductionOptionID], [Description], [Amount]) VALUES (25, N'Other Deduction', CAST(50.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName]) VALUES (1, N'Human Resources')
GO
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName]) VALUES (2, N'Finance')
GO
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName]) VALUES (3, N'Information Technology')
GO
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName]) VALUES (4, N'Marketing')
GO
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName]) VALUES (5, N'Operations')
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (1, 1, 1, N'John', N'Smith', CAST(N'2020-01-15' AS Date), NULL, CAST(75000.00 AS Decimal(10, 2)), CAST(10000.00 AS Decimal(10, 2)), CAST(5000.00 AS Decimal(10, 2)), 80)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (2, 1, 2, N'Jane', N'Johnson', CAST(N'2020-02-01' AS Date), NULL, CAST(80000.00 AS Decimal(10, 2)), CAST(11000.00 AS Decimal(10, 2)), CAST(5500.00 AS Decimal(10, 2)), 90)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (3, 2, 3, N'Michael', N'Williams', CAST(N'2020-03-10' AS Date), NULL, CAST(90000.00 AS Decimal(10, 2)), CAST(12000.00 AS Decimal(10, 2)), CAST(6000.00 AS Decimal(10, 2)), 100)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (4, 2, 4, N'Emily', N'Brown', CAST(N'2020-04-05' AS Date), NULL, CAST(95000.00 AS Decimal(10, 2)), CAST(13000.00 AS Decimal(10, 2)), CAST(6500.00 AS Decimal(10, 2)), 85)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (5, 3, 1, N'Robert', N'Jones', CAST(N'2020-05-15' AS Date), NULL, CAST(70000.00 AS Decimal(10, 2)), CAST(9000.00 AS Decimal(10, 2)), CAST(4500.00 AS Decimal(10, 2)), 75)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (6, 3, 2, N'Sarah', N'Davis', CAST(N'2020-06-01' AS Date), NULL, CAST(75000.00 AS Decimal(10, 2)), CAST(10000.00 AS Decimal(10, 2)), CAST(5000.00 AS Decimal(10, 2)), 80)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (7, 4, 3, N'William', N'Miller', CAST(N'2020-07-10' AS Date), NULL, CAST(80000.00 AS Decimal(10, 2)), CAST(11000.00 AS Decimal(10, 2)), CAST(5500.00 AS Decimal(10, 2)), 90)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (8, 4, 4, N'Jessica', N'Wilson', CAST(N'2020-08-05' AS Date), NULL, CAST(90000.00 AS Decimal(10, 2)), CAST(12000.00 AS Decimal(10, 2)), CAST(6000.00 AS Decimal(10, 2)), 100)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (9, 5, 1, N'David', N'Martinez', CAST(N'2020-09-15' AS Date), NULL, CAST(95000.00 AS Decimal(10, 2)), CAST(13000.00 AS Decimal(10, 2)), CAST(6500.00 AS Decimal(10, 2)), 85)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (10, 5, 2, N'Olivia', N'Taylor', CAST(N'2020-10-01' AS Date), NULL, CAST(70000.00 AS Decimal(10, 2)), CAST(9000.00 AS Decimal(10, 2)), CAST(4500.00 AS Decimal(10, 2)), 75)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (11, 1, 3, N'James', N'Lee', CAST(N'2020-11-10' AS Date), NULL, CAST(75000.00 AS Decimal(10, 2)), CAST(10000.00 AS Decimal(10, 2)), CAST(5000.00 AS Decimal(10, 2)), 80)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (12, 1, 4, N'Sophia', N'Anderson', CAST(N'2020-12-05' AS Date), NULL, CAST(80000.00 AS Decimal(10, 2)), CAST(11000.00 AS Decimal(10, 2)), CAST(5500.00 AS Decimal(10, 2)), 90)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (13, 2, 1, N'Benjamin', N'Hernandez', CAST(N'2021-01-15' AS Date), NULL, CAST(90000.00 AS Decimal(10, 2)), CAST(12000.00 AS Decimal(10, 2)), CAST(6000.00 AS Decimal(10, 2)), 100)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (14, 2, 2, N'Ava', N'Moore', CAST(N'2021-02-01' AS Date), NULL, CAST(95000.00 AS Decimal(10, 2)), CAST(13000.00 AS Decimal(10, 2)), CAST(6500.00 AS Decimal(10, 2)), 85)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (15, 3, 3, N'Ethan', N'Clark', CAST(N'2021-03-10' AS Date), NULL, CAST(70000.00 AS Decimal(10, 2)), CAST(9000.00 AS Decimal(10, 2)), CAST(4500.00 AS Decimal(10, 2)), 75)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (16, 3, 4, N'Mia', N'Lewis', CAST(N'2021-04-05' AS Date), NULL, CAST(75000.00 AS Decimal(10, 2)), CAST(10000.00 AS Decimal(10, 2)), CAST(5000.00 AS Decimal(10, 2)), 80)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (17, 4, 1, N'Daniel', N'Walker', CAST(N'2021-05-15' AS Date), NULL, CAST(80000.00 AS Decimal(10, 2)), CAST(11000.00 AS Decimal(10, 2)), CAST(5500.00 AS Decimal(10, 2)), 90)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (18, 4, 2, N'Sofia', N'Young', CAST(N'2021-06-01' AS Date), NULL, CAST(90000.00 AS Decimal(10, 2)), CAST(12000.00 AS Decimal(10, 2)), CAST(6000.00 AS Decimal(10, 2)), 100)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (19, 5, 3, N'Matthew', N'Hall', CAST(N'2021-07-10' AS Date), NULL, CAST(95000.00 AS Decimal(10, 2)), CAST(13000.00 AS Decimal(10, 2)), CAST(6500.00 AS Decimal(10, 2)), 85)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (20, 5, 4, N'Avery', N'White', CAST(N'2021-08-05' AS Date), NULL, CAST(70000.00 AS Decimal(10, 2)), CAST(9000.00 AS Decimal(10, 2)), CAST(4500.00 AS Decimal(10, 2)), 75)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (21, 1, 1, N'Oliver', N'Lopez', CAST(N'2021-09-15' AS Date), NULL, CAST(75000.00 AS Decimal(10, 2)), CAST(10000.00 AS Decimal(10, 2)), CAST(5000.00 AS Decimal(10, 2)), 80)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (22, 1, 2, N'Chloe', N'Scott', CAST(N'2021-10-01' AS Date), NULL, CAST(80000.00 AS Decimal(10, 2)), CAST(11000.00 AS Decimal(10, 2)), CAST(5500.00 AS Decimal(10, 2)), 90)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (23, 2, 3, N'Emma', N'Adams', CAST(N'2021-11-10' AS Date), NULL, CAST(90000.00 AS Decimal(10, 2)), CAST(12000.00 AS Decimal(10, 2)), CAST(6000.00 AS Decimal(10, 2)), 100)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (24, 2, 4, N'Jackson', N'Green', CAST(N'2021-12-05' AS Date), NULL, CAST(95000.00 AS Decimal(10, 2)), CAST(13000.00 AS Decimal(10, 2)), CAST(6500.00 AS Decimal(10, 2)), 85)
GO
INSERT [dbo].[Employee] ([EmployeeID], [DepartmentID], [PositionID], [FirstName], [LastName], [HireDate], [EndDate], [Salary], [TaxDeduction], [Bonus], [PTOHours]) VALUES (25, 3, 1, N'Noah', N'Carter', CAST(N'2022-01-15' AS Date), NULL, CAST(70000.00 AS Decimal(10, 2)), CAST(9000.00 AS Decimal(10, 2)), CAST(4500.00 AS Decimal(10, 2)), 75)
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (1, 1, CAST(200.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (1, 2, CAST(200.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (1, 5, CAST(200.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (2, 2, CAST(50.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (2, 4, CAST(50.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (3, 2, CAST(30.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (4, 1, CAST(150.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (4, 3, CAST(150.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (4, 5, CAST(150.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (6, 4, CAST(50.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (7, 3, CAST(20.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (8, 4, CAST(25.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (9, 1, CAST(75.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (10, 5, CAST(10.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeDeduction] ([DeductionOptionID], [EmployeeID], [AmountDeducted]) VALUES (12, 3, CAST(75.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (1, 1)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (2, 1)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (2, 2)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (3, 1)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (3, 3)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (4, 1)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (4, 2)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (5, 1)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (5, 3)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (6, 2)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (7, 3)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (8, 2)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (9, 3)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (10, 2)
GO
INSERT [dbo].[EmployeeRole] ([EmployeeID], [RoleID]) VALUES (11, 3)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (1, N'New Year''s Day', CAST(N'2023-01-01' AS Date), 1)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (2, N'Independence Day', CAST(N'2023-07-04' AS Date), 1)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (3, N'Thanksgiving Day', CAST(N'2023-11-23' AS Date), 1)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (4, N'Christmas Day', CAST(N'2023-12-25' AS Date), 1)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (5, N'Labor Day', CAST(N'2023-09-04' AS Date), 1)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (6, N'Memorial Day', CAST(N'2023-05-29' AS Date), 1)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (7, N'Martin Luther King Jr. Day', CAST(N'2023-01-16' AS Date), 1)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (8, N'Presidents'' Day', CAST(N'2023-02-20' AS Date), 1)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (9, N'Veterans Day', CAST(N'2023-11-11' AS Date), 1)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (10, N'Columbus Day', CAST(N'2023-10-09' AS Date), 1)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (11, N'Valentine''s Day', CAST(N'2023-02-14' AS Date), 0)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (12, N'Easter Sunday', CAST(N'2023-04-09' AS Date), 0)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (13, N'Mother''s Day', CAST(N'2023-05-14' AS Date), 0)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (14, N'Father''s Day', CAST(N'2023-06-18' AS Date), 0)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (15, N'Halloween', CAST(N'2023-10-31' AS Date), 0)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (16, N'Thanksgiving (Canada)', CAST(N'2023-10-09' AS Date), 0)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (17, N'Boxing Day (Canada)', CAST(N'2023-12-26' AS Date), 0)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (18, N'Diwali', CAST(N'2023-11-01' AS Date), 0)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (19, N'Hanukkah', CAST(N'2023-12-12' AS Date), 0)
GO
INSERT [dbo].[Holiday] ([HolidayID], [HolidayName], [Date], [IsPaid]) VALUES (20, N'Chinese New Year', CAST(N'2023-01-22' AS Date), 0)
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (1, 1, CAST(N'2023-01-15' AS Date), 1, N'We are hiring a Senior Software Engineer for our engineering team.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (2, 2, CAST(N'2023-02-01' AS Date), 1, N'Join our marketing department as a Marketing Manager and help us grow our brand.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (3, 3, CAST(N'2023-03-10' AS Date), 1, N'We are looking for a Network Administrator to maintain our IT infrastructure.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (4, 4, CAST(N'2023-04-05' AS Date), 1, N'Join our finance team as a Financial Analyst and assist with financial planning.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (5, 1, CAST(N'2023-05-15' AS Date), 1, N'We have an opening for a Junior Software Developer to join our software development team.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (6, 2, CAST(N'2023-06-01' AS Date), 1, N'We are hiring a Content Writer to create engaging content for our website and marketing materials.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (7, 3, CAST(N'2023-07-10' AS Date), 1, N'Join our IT support team as a Help Desk Technician and provide technical assistance to employees.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (8, 4, CAST(N'2023-08-05' AS Date), 1, N'We have an opening for a Senior Accountant to manage financial records and reports.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (9, 1, CAST(N'2023-09-15' AS Date), 1, N'We are looking for a Front-End Developer to create user-friendly web interfaces.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (10, 2, CAST(N'2023-10-01' AS Date), 1, N'Join our marketing team as a Social Media Specialist and manage our social media presence.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (11, 3, CAST(N'2023-11-10' AS Date), 1, N'We have an opening for a Systems Administrator to oversee our IT systems.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (12, 4, CAST(N'2023-12-05' AS Date), 1, N'Join our finance department as a Budget Analyst and assist with financial planning and analysis.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (13, 1, CAST(N'2024-01-15' AS Date), 1, N'We are hiring a QA Engineer to ensure the quality of our software products.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (14, 2, CAST(N'2024-02-01' AS Date), 1, N'Join our marketing team as a Graphic Designer and create visually appealing marketing materials.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (15, 3, CAST(N'2024-03-10' AS Date), 1, N'We are looking for a Database Administrator to manage our databases.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (16, 4, CAST(N'2024-04-05' AS Date), 1, N'Join our finance department as a Tax Accountant and handle tax-related matters.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (17, 1, CAST(N'2024-05-15' AS Date), 1, N'We have an opening for a Data Scientist to analyze and interpret data for business insights.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (18, 2, CAST(N'2024-06-01' AS Date), 1, N'Join our marketing team as a Marketing Coordinator and assist with marketing campaigns.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (19, 3, CAST(N'2024-07-10' AS Date), 1, N'We are hiring a Network Engineer to design and maintain our network infrastructure.')
GO
INSERT [dbo].[JobPosting] ([PostingID], [PositionID], [DatePosted], [HRApproval], [Description]) VALUES (20, 4, CAST(N'2024-08-05' AS Date), 1, N'Join our finance team as a Financial Planner and assist clients with financial planning.')
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (1, CAST(N'2023-01-01' AS Date), CAST(N'2023-01-15' AS Date), CAST(N'2023-01-20' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (2, CAST(N'2023-01-16' AS Date), CAST(N'2023-01-30' AS Date), CAST(N'2023-02-04' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (3, CAST(N'2023-01-31' AS Date), CAST(N'2023-02-14' AS Date), CAST(N'2023-02-19' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (4, CAST(N'2023-02-15' AS Date), CAST(N'2023-03-01' AS Date), CAST(N'2023-03-06' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (5, CAST(N'2023-03-02' AS Date), CAST(N'2023-03-16' AS Date), CAST(N'2023-03-21' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (6, CAST(N'2023-03-17' AS Date), CAST(N'2023-03-31' AS Date), CAST(N'2023-04-05' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (7, CAST(N'2023-04-01' AS Date), CAST(N'2023-04-15' AS Date), CAST(N'2023-04-20' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (8, CAST(N'2023-04-16' AS Date), CAST(N'2023-04-30' AS Date), CAST(N'2023-05-05' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (9, CAST(N'2023-05-01' AS Date), CAST(N'2023-05-15' AS Date), CAST(N'2023-05-20' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (10, CAST(N'2023-05-16' AS Date), CAST(N'2023-05-30' AS Date), CAST(N'2023-06-04' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (11, CAST(N'2023-05-31' AS Date), CAST(N'2023-06-14' AS Date), CAST(N'2023-06-19' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (12, CAST(N'2023-06-15' AS Date), CAST(N'2023-06-29' AS Date), CAST(N'2023-07-04' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (13, CAST(N'2023-06-30' AS Date), CAST(N'2023-07-14' AS Date), CAST(N'2023-07-19' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (14, CAST(N'2023-07-15' AS Date), CAST(N'2023-07-29' AS Date), CAST(N'2023-08-03' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (15, CAST(N'2023-07-30' AS Date), CAST(N'2023-08-13' AS Date), CAST(N'2023-08-18' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (16, CAST(N'2023-08-14' AS Date), CAST(N'2023-08-28' AS Date), CAST(N'2023-09-02' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (17, CAST(N'2023-08-29' AS Date), CAST(N'2023-09-12' AS Date), CAST(N'2023-09-17' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (18, CAST(N'2023-09-13' AS Date), CAST(N'2023-09-27' AS Date), CAST(N'2023-10-02' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (19, CAST(N'2023-09-28' AS Date), CAST(N'2023-10-12' AS Date), CAST(N'2023-10-17' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (20, CAST(N'2023-10-13' AS Date), CAST(N'2023-10-27' AS Date), CAST(N'2023-11-01' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (21, CAST(N'2023-10-28' AS Date), CAST(N'2023-11-11' AS Date), CAST(N'2023-11-16' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (22, CAST(N'2023-11-12' AS Date), CAST(N'2023-11-26' AS Date), CAST(N'2023-12-01' AS Date))
GO
INSERT [dbo].[PayrollCycle] ([PayrollID], [StartDate], [EndDate], [PayDate]) VALUES (23, CAST(N'2023-11-27' AS Date), CAST(N'2023-12-11' AS Date), CAST(N'2023-12-16' AS Date))
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (1, N'Software Engineer', N'SE001')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (2, N'Marketing Manager', N'MM002')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (3, N'Network Administrator', N'NA003')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (4, N'Financial Analyst', N'FA004')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (5, N'Front-End Developer', N'FE005')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (6, N'Content Writer', N'CW006')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (7, N'Help Desk Technician', N'HDT007')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (8, N'Senior Accountant', N'SA008')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (9, N'QA Engineer', N'QA009')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (10, N'Social Media Specialist', N'SMS010')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (11, N'Database Administrator', N'DBA011')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (12, N'Financial Planner', N'FP012')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (13, N'Data Scientist', N'DS013')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (14, N'Graphic Designer', N'GD014')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (15, N'Marketing Coordinator', N'MC015')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (16, N'Network Engineer', N'NE016')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (17, N'Tax Accountant', N'TA017')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (18, N'Systems Administrator', N'SA018')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (19, N'Budget Analyst', N'BA019')
GO
INSERT [dbo].[Position] ([PositionID], [PositionName], [JobCode]) VALUES (20, N'IT Support Specialist', N'ITSS020')
GO
INSERT [dbo].[SystemRole] ([RoleID], [RoleName], [Description]) VALUES (1, N'Admin', N'Administrator with full access and control.')
GO
INSERT [dbo].[SystemRole] ([RoleID], [RoleName], [Description]) VALUES (2, N'Manager', N'Manager with limited administrative access.')
GO
INSERT [dbo].[SystemRole] ([RoleID], [RoleName], [Description]) VALUES (3, N'Employee', N'Standard employee with restricted access.')
GO
INSERT [dbo].[SystemRole] ([RoleID], [RoleName], [Description]) VALUES (4, N'Supervisor', N'Supervisor role with some managerial responsibilities.')
GO
INSERT [dbo].[SystemRole] ([RoleID], [RoleName], [Description]) VALUES (5, N'Guest', N'Guest role with minimal access for visitors.')
GO
INSERT [dbo].[SystemRole] ([RoleID], [RoleName], [Description]) VALUES (6, N'Analyst', N'Role for data analysts with access to analytics tools.')
GO
INSERT [dbo].[SystemRole] ([RoleID], [RoleName], [Description]) VALUES (7, N'Developer', N'Developer role for software development access.')
GO
INSERT [dbo].[SystemRole] ([RoleID], [RoleName], [Description]) VALUES (8, N'Support', N'Support role for customer support and assistance.')
GO
INSERT [dbo].[SystemRole] ([RoleID], [RoleName], [Description]) VALUES (9, N'Marketing', N'Marketing role with access to marketing tools.')
GO
INSERT [dbo].[SystemRole] ([RoleID], [RoleName], [Description]) VALUES (10, N'HR', N'Human Resources role for HR-related tasks.')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (1, N'Payment Gateway', N'Interface for processing online payments.', N'Payment')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (2, N'Email Service', N'Interface for sending and receiving emails.', N'Communication')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (3, N'SMS Gateway', N'Interface for sending SMS messages.', N'Communication')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (4, N'Authentication API', N'Interface for user authentication.', N'Security')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (5, N'Geolocation Service', N'Interface for retrieving location data.', N'Data')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (6, N'Weather API', N'Interface for accessing weather information.', N'Data')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (7, N'Inventory System Integration', N'Interface for syncing inventory data.', N'Integration')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (8, N'CRM Integration', N'Interface for integrating with a CRM system.', N'Integration')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (9, N'Social Media API', N'Interface for posting to social media platforms.', N'Social')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (10, N'Analytics API', N'Interface for collecting and analyzing data.', N'Data')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (11, N'Notification Service', N'Interface for sending push notifications.', N'Communication')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (12, N'File Storage API', N'Interface for storing and retrieving files.', N'Storage')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (13, N'Calendar Integration', N'Interface for syncing with calendar applications.', N'Integration')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (14, N'Voice Recognition Service', N'Interface for voice recognition functionality.', N'Speech')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (15, N'Video Streaming API', N'Interface for streaming video content.', N'Media')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (16, N'IoT Device Integration', N'Interface for connecting and controlling IoT devices.', N'IoT')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (17, N'Payment Processor', N'Interface for processing offline payments.', N'Payment')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (18, N'Translation Service', N'Interface for language translation.', N'Language')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (19, N'E-commerce Integration', N'Interface for e-commerce platform integration.', N'Integration')
GO
INSERT [dbo].[ThirdPartyInterface] ([InterfaceID], [Name], [Description], [Type]) VALUES (20, N'AI Chatbot API', N'Interface for implementing AI-powered chatbots.', N'AI')
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (1, 1, 1, N'SE001', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-01-02' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (2, 2, 1, N'MM002', CAST(7.50 AS Decimal(5, 2)), CAST(N'2023-01-02' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (3, 3, 1, N'NA003', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-01-02' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (4, 4, 1, N'FA004', CAST(7.75 AS Decimal(5, 2)), CAST(N'2023-01-02' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (5, 5, 1, N'FE005', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-01-02' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (6, 1, NULL, N'SE001', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-01-03' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (7, 2, NULL, N'MM002', CAST(7.50 AS Decimal(5, 2)), CAST(N'2023-01-03' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (8, 3, NULL, N'NA003', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-01-03' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (9, 4, NULL, N'FA004', CAST(7.75 AS Decimal(5, 2)), CAST(N'2023-01-03' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (10, 5, NULL, N'FE005', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-01-03' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (11, 1, 2, N'SE001', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-01-16' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (12, 2, 2, N'MM002', CAST(7.50 AS Decimal(5, 2)), CAST(N'2023-01-16' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (13, 3, 2, N'NA003', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-01-16' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (14, 4, 2, N'FA004', CAST(7.75 AS Decimal(5, 2)), CAST(N'2023-01-16' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (15, 5, 2, N'FE005', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-01-16' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (16, 1, 3, N'SE001', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-02-20' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (17, 2, 3, N'MM002', CAST(7.50 AS Decimal(5, 2)), CAST(N'2023-02-20' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (18, 3, 3, N'NA003', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-02-20' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (19, 4, 3, N'FA004', CAST(7.75 AS Decimal(5, 2)), CAST(N'2023-02-20' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (20, 5, 3, N'FE005', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-02-20' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (21, 1, 4, N'SE001', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-05-29' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (22, 2, 4, N'MM002', CAST(7.50 AS Decimal(5, 2)), CAST(N'2023-05-29' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (23, 3, 4, N'NA003', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-05-29' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (24, 4, 4, N'FA004', CAST(7.75 AS Decimal(5, 2)), CAST(N'2023-05-29' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (25, 5, 4, N'FE005', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-05-29' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (26, 1, NULL, N'SE001', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-06-05' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (27, 2, NULL, N'MM002', CAST(7.50 AS Decimal(5, 2)), CAST(N'2023-06-05' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (28, 3, NULL, N'NA003', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-06-05' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (29, 4, NULL, N'FA004', CAST(7.75 AS Decimal(5, 2)), CAST(N'2023-06-05' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (30, 5, NULL, N'FE005', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-06-05' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (31, 1, 5, N'SE001', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-07-04' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (32, 2, 5, N'MM002', CAST(7.50 AS Decimal(5, 2)), CAST(N'2023-07-04' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (33, 3, 5, N'NA003', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-07-04' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (34, 4, 5, N'FA004', CAST(7.75 AS Decimal(5, 2)), CAST(N'2023-07-04' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (35, 5, 5, N'FE005', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-07-04' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (36, 1, 6, N'SE001', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-09-04' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (37, 2, 6, N'MM002', CAST(7.50 AS Decimal(5, 2)), CAST(N'2023-09-04' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (38, 3, 6, N'NA003', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-09-04' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (39, 4, 6, N'FA004', CAST(7.75 AS Decimal(5, 2)), CAST(N'2023-09-04' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (40, 5, 6, N'FE005', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-09-04' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (41, 1, NULL, N'SE001', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-09-11' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (42, 2, NULL, N'MM002', CAST(7.50 AS Decimal(5, 2)), CAST(N'2023-09-11' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (43, 3, NULL, N'NA003', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-09-11' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (44, 4, NULL, N'FA004', CAST(7.75 AS Decimal(5, 2)), CAST(N'2023-09-11' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (45, 5, NULL, N'FE005', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-09-11' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (46, 1, 7, N'SE001', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-10-09' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (47, 2, 7, N'MM002', CAST(7.50 AS Decimal(5, 2)), CAST(N'2023-10-09' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (48, 3, 7, N'NA003', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-10-09' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (49, 4, 7, N'FA004', CAST(7.75 AS Decimal(5, 2)), CAST(N'2023-10-09' AS Date))
GO
INSERT [dbo].[TimeCard] ([TimeCardID], [EmployeeID], [HolidayID], [JobCode], [HoursWorked], [Date]) VALUES (50, 5, 7, N'FE005', CAST(8.00 AS Decimal(5, 2)), CAST(N'2023-10-09' AS Date))
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (1, 0, 1, CAST(0.00 AS Decimal(5, 2)), CAST(29.99 AS Decimal(5, 2)), 5)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (2, 0, 1, CAST(30.00 AS Decimal(5, 2)), CAST(39.99 AS Decimal(5, 2)), 7)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (3, 0, 1, CAST(40.00 AS Decimal(5, 2)), CAST(49.99 AS Decimal(5, 2)), 10)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (4, 0, 1, CAST(50.00 AS Decimal(5, 2)), CAST(59.99 AS Decimal(5, 2)), 12)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (5, 0, 1, CAST(60.00 AS Decimal(5, 2)), CAST(69.99 AS Decimal(5, 2)), 15)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (6, 2, 4, CAST(0.00 AS Decimal(5, 2)), CAST(29.99 AS Decimal(5, 2)), 10)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (7, 2, 4, CAST(30.00 AS Decimal(5, 2)), CAST(39.99 AS Decimal(5, 2)), 12)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (8, 2, 4, CAST(40.00 AS Decimal(5, 2)), CAST(49.99 AS Decimal(5, 2)), 15)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (9, 2, 4, CAST(50.00 AS Decimal(5, 2)), CAST(59.99 AS Decimal(5, 2)), 17)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (10, 2, 4, CAST(60.00 AS Decimal(5, 2)), CAST(69.99 AS Decimal(5, 2)), 20)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (11, 5, 9, CAST(0.00 AS Decimal(5, 2)), CAST(29.99 AS Decimal(5, 2)), 15)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (12, 5, 9, CAST(30.00 AS Decimal(5, 2)), CAST(39.99 AS Decimal(5, 2)), 17)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (13, 5, 9, CAST(40.00 AS Decimal(5, 2)), CAST(49.99 AS Decimal(5, 2)), 20)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (14, 5, 9, CAST(50.00 AS Decimal(5, 2)), CAST(59.99 AS Decimal(5, 2)), 22)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (15, 5, 9, CAST(60.00 AS Decimal(5, 2)), CAST(69.99 AS Decimal(5, 2)), 25)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (16, 10, 19, CAST(0.00 AS Decimal(5, 2)), CAST(29.99 AS Decimal(5, 2)), 20)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (17, 10, 19, CAST(30.00 AS Decimal(5, 2)), CAST(39.99 AS Decimal(5, 2)), 22)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (18, 10, 19, CAST(40.00 AS Decimal(5, 2)), CAST(49.99 AS Decimal(5, 2)), 25)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (19, 10, 19, CAST(50.00 AS Decimal(5, 2)), CAST(59.99 AS Decimal(5, 2)), 27)
GO
INSERT [dbo].[VacationOption] ([VacationID], [YearsOfServiceFrom], [YearsOfServiceTo], [HoursPerWeekFrom], [HoursPerWeekTo], [VacationDays]) VALUES (20, 10, 19, CAST(60.00 AS Decimal(5, 2)), CAST(69.99 AS Decimal(5, 2)), 30)
GO
ALTER TABLE [dbo].[ApplicantTracking]  WITH CHECK ADD FOREIGN KEY([PositionAppliedFor])
REFERENCES [dbo].[Position] ([PositionID])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([PositionID])
REFERENCES [dbo].[Position] ([PositionID])
GO
ALTER TABLE [dbo].[EmployeeDeduction]  WITH CHECK ADD FOREIGN KEY([DeductionOptionID])
REFERENCES [dbo].[DeductionOption] ([DeductionOptionID])
GO
ALTER TABLE [dbo].[EmployeeDeduction]  WITH CHECK ADD FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([EmployeeID])
GO
ALTER TABLE [dbo].[EmployeeRole]  WITH CHECK ADD FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([EmployeeID])
GO
ALTER TABLE [dbo].[EmployeeRole]  WITH CHECK ADD FOREIGN KEY([RoleID])
REFERENCES [dbo].[SystemRole] ([RoleID])
GO
ALTER TABLE [dbo].[JobPosting]  WITH CHECK ADD FOREIGN KEY([PositionID])
REFERENCES [dbo].[Position] ([PositionID])
GO
ALTER TABLE [dbo].[TimeCard]  WITH CHECK ADD FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([EmployeeID])
GO
ALTER TABLE [dbo].[TimeCard]  WITH CHECK ADD FOREIGN KEY([HolidayID])
REFERENCES [dbo].[Holiday] ([HolidayID])
GO
/****** Object:  StoredProcedure [dbo].[AccruePTOHours]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AccruePTOHours]
    @PTOHoursAccruedPerPeriod INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Update the PTOHours for each employee
        UPDATE [dbo].[Employee]
        SET PTOHours = ISNULL(PTOHours, 0) + @PTOHoursAccruedPerPeriod

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[AddNewEmployee]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddNewEmployee]
    @EmployeeID int,
    @DepartmentID int,
    @PositionID int,
    @FirstName varchar(255),
    @LastName varchar(255),
    @HireDate date,
    @Salary decimal(10, 2),
    @TaxDeduction decimal(10, 2),
    @Bonus decimal(10, 2),
    @PTOHours int,
    @DeductionOptionID int,
    @AmountDeducted decimal(10, 2),
    @RoleID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION

        -- Insert into Employee table
        INSERT INTO [dbo].[Employee] (EmployeeID, DepartmentID, PositionID, FirstName, LastName, HireDate, Salary, TaxDeduction, Bonus, PTOHours)
        VALUES (@EmployeeID, @DepartmentID, @PositionID, @FirstName, @LastName, @HireDate, @Salary, @TaxDeduction, @Bonus, @PTOHours)

        -- Insert into EmployeeDeduction table
        INSERT INTO [dbo].[EmployeeDeduction] (DeductionOptionID, EmployeeID, AmountDeducted)
        VALUES (@DeductionOptionID, @EmployeeID, @AmountDeducted)

        -- Insert into EmployeeRole table
        INSERT INTO [dbo].[EmployeeRole] (EmployeeID, RoleID)
        VALUES (@EmployeeID, @RoleID)

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[AddNewPositionWithJobPosting]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddNewPositionWithJobPosting]
    @PositionName varchar(255),
    @JobCode varchar(50),
    @DatePosted date,
    @HRApproval bit,
    @Description text
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PositionID int;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Insert into Position table
        INSERT INTO [dbo].[Position] (PositionName, JobCode)
        VALUES (@PositionName, @JobCode)
        SET @PositionID = SCOPE_IDENTITY(); -- Capture the ID of the newly created position

        -- Insert into JobPosting table
        INSERT INTO [dbo].[JobPosting] (PositionID, DatePosted, HRApproval, Description)
        VALUES (@PositionID, @DatePosted, @HRApproval, @Description)

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[AdjustSalariesForMarket]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdjustSalariesForMarket]
    @PercentageIncrease DECIMAL(5, 2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Update the salary for each employee based on the percentage increase
        UPDATE [dbo].[Employee]
        SET Salary = Salary + (Salary * (@PercentageIncrease / 100))

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteJobPosting]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteJobPosting]
    @PostingID int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Delete from JobPosting table
        DELETE FROM [dbo].[JobPosting]
        WHERE PostingID = @PostingID

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[GiveDepartmentBonus]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GiveDepartmentBonus]
    @DepartmentID int,
    @BonusAmount decimal(10, 2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Update the Bonus field for all employees in the specified department
        UPDATE [dbo].[Employee]
        SET Bonus = ISNULL(Bonus, 0) + @BonusAmount
        WHERE DepartmentID = @DepartmentID

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[GoOnHiringFreeze]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GoOnHiringFreeze]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Update the status of all applicants in the ApplicantTracking table
        UPDATE [dbo].[ApplicantTracking]
        SET Status = 'Cancelled'

        -- Delete all records from the JobPosting table
        DELETE FROM [dbo].[JobPosting]

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[LayoffAndDropDepartment]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LayoffAndDropDepartment]
    @DepartmentID int,
    @EndDate date
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Update the Employee table to set the EndDate for all employees in the specified department
        UPDATE [dbo].[Employee]
        SET EndDate = @EndDate
        WHERE DepartmentID = @DepartmentID AND EndDate IS NULL

        -- Delete the department from the Department table
        DELETE FROM [dbo].[Department]
        WHERE DepartmentID = @DepartmentID

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[MoveApplicantToNextStage]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MoveApplicantToNextStage]
    @ApplicantID int,
    @NewStatus varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Update the status of the applicant in the ApplicantTracking table
        UPDATE [dbo].[ApplicantTracking]
        SET Status = @NewStatus
        WHERE ApplicantID = @ApplicantID

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[PurgeOldApplicantDataForSecurity]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PurgeOldApplicantDataForSecurity]
    @RetentionPeriodInYears INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CutoffDate DATE = DATEADD(YEAR, -@RetentionPeriodInYears, GETDATE());

    BEGIN TRY
        BEGIN TRANSACTION

        -- Delete applicant records older than the retention period
        DELETE FROM [dbo].[ApplicantTracking]
        WHERE ApplicationDate < @CutoffDate

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SubmitTimeCardEntry]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SubmitTimeCardEntry]
    @EmployeeID int,
    @JobCode varchar(50),
    @HoursWorked decimal(5, 2),
    @Date date
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Insert into TimeCard table
        INSERT INTO [dbo].[TimeCard] (EmployeeID, JobCode, HoursWorked, Date)
        VALUES (@EmployeeID, @JobCode, @HoursWorked, @Date)

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[TerminateEmployee]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TerminateEmployee]
    @EmployeeID int,
    @EndDate date
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION

        -- Update the Employee table to set the EndDate
        UPDATE [dbo].[Employee]
        SET EndDate = @EndDate
        WHERE EmployeeID = @EmployeeID

        -- Optional: Remove employee from EmployeeDeduction
        -- Depending on business logic, you might want to keep the record for historical purposes
        DELETE FROM [dbo].[EmployeeDeduction] WHERE EmployeeID = @EmployeeID

        -- Optional: Remove employee from EmployeeRole
        DELETE FROM [dbo].[EmployeeRole] WHERE EmployeeID = @EmployeeID

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateForNewYear]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateForNewYear]
    @SalaryIncrementPercentage DECIMAL(5, 2),
    @NewPTOHours INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Update the salary for each employee
        UPDATE [dbo].[Employee]
        SET Salary = Salary + (Salary * (@SalaryIncrementPercentage / 100))

        -- Reset the PTOHours for each employee
        UPDATE [dbo].[Employee]
        SET PTOHours = @NewPTOHours

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateHolidayPay]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateHolidayPay]
    @EmployeeID int,
    @HolidayID int,
    @RateMultiplier decimal(5, 2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Update the HoursWorked field in TimeCard table for the given holiday
        UPDATE tc
        SET tc.HoursWorked = tc.HoursWorked * @RateMultiplier
        FROM [dbo].[TimeCard] tc
        INNER JOIN [dbo].[Holiday] h ON tc.HolidayID = h.HolidayID
        WHERE tc.EmployeeID = @EmployeeID AND tc.HolidayID = @HolidayID

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[UsePTOHours]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UsePTOHours]
    @EmployeeID int,
    @PTOHoursUsed int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Check if the employee has enough PTOHours
        IF EXISTS (SELECT 1 FROM [dbo].[Employee]
                   WHERE EmployeeID = @EmployeeID AND PTOHours >= @PTOHoursUsed)
        BEGIN
            -- Deduct the PTOHoursUsed from the employee's PTOHours
            UPDATE [dbo].[Employee]
            SET PTOHours = PTOHours - @PTOHoursUsed
            WHERE EmployeeID = @EmployeeID
        END
        ELSE
        BEGIN
            -- Raise an error if not enough PTOHours
            RAISERROR('Not enough PTOHours available.', 16, 1)
        END

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO
/****** Object:  Trigger [dbo].[DeductPTOHours]    Script Date: 12/18/2023 4:25:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[DeductPTOHours]
ON [dbo].[TimeCard]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @hoursToDeduct DECIMAL(5, 2);
    DECLARE @EmployeeID INT;

    -- Get the EmployeeID and JobCode of the inserted row
    SELECT @EmployeeID = i.EmployeeID, @hoursToDeduct = 8.0
    FROM INSERTED i
    WHERE i.JobCode = 'PTO';

    -- Check if a PTO day was inserted
    IF @EmployeeID IS NOT NULL
    BEGIN
        -- Update the PTOHours in the Employee table
        UPDATE Employee
        SET PTOHours = GREATEST(0, PTOHours - @hoursToDeduct)
        WHERE EmployeeID = @EmployeeID;
    END
END;
GO
ALTER TABLE [dbo].[TimeCard] ENABLE TRIGGER [DeductPTOHours]
GO
ALTER DATABASE [Group3] SET  READ_WRITE 
GO
