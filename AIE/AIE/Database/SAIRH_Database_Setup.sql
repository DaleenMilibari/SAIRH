-- ============================================================================
-- SAIRH 2026 - Saudi 1st AI Summit in Radiology and Health Innovation
-- Database Creation & Schema Setup Script
-- Engine: Microsoft SQL Server 2019 / 2022
-- noinspection SqlResolve
-- noinspection SqlInsertValues
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Create Database
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'SAIRH')
BEGIN
    CREATE DATABASE [SAIRH];
END
GO

USE [SAIRH];
GO

-- ============================================================================
-- 0. CLEAN SLATE: DROP EXISTING VIEWS, CONSTRAINTS, AND TABLES (IF EXIST)
-- ============================================================================
PRINT N'======================================================================';
PRINT N'SAIRH 2026: Dropping existing views, constraints, and tables (Clean Start)';
PRINT N'======================================================================';

-- 1. Drop all Views if they exist
IF OBJECT_ID(N'[dbo].[vw_SummitSpeakers]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_SummitSpeakers];
IF OBJECT_ID(N'[dbo].[Judges]', N'V') IS NOT NULL DROP VIEW [dbo].[Judges];
IF OBJECT_ID(N'[dbo].[qryCountries]', N'V') IS NOT NULL DROP VIEW [dbo].[qryCountries];
IF OBJECT_ID(N'[dbo].[qryApiContactUs]', N'V') IS NOT NULL DROP VIEW [dbo].[qryApiContactUs];
GO

-- 2. Drop all Foreign Key constraints in dbo to prevent any drop-table blocks
DECLARE @dropFKs NVARCHAR(MAX) = N'';
SELECT @dropFKs += N'ALTER TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name) 
                 + N' DROP CONSTRAINT ' + QUOTENAME(f.name) + N';' + CHAR(13)
FROM sys.foreign_keys f
INNER JOIN sys.tables t ON f.parent_object_id = t.object_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'dbo';
IF @dropFKs <> N'' EXEC sp_executesql @dropFKs;
GO

-- 3. Drop all Tables in reverse dependency order
IF OBJECT_ID(N'[dbo].[BoothVisits]', N'U') IS NOT NULL DROP TABLE [dbo].[BoothVisits];
IF OBJECT_ID(N'[dbo].[SurveyResponses]', N'U') IS NOT NULL DROP TABLE [dbo].[SurveyResponses];
IF OBJECT_ID(N'[dbo].[PasswordResetTokens]', N'U') IS NOT NULL DROP TABLE [dbo].[PasswordResetTokens];
IF OBJECT_ID(N'[dbo].[Booths]', N'U') IS NOT NULL DROP TABLE [dbo].[Booths];
IF OBJECT_ID(N'[dbo].[LoginAudit]', N'U') IS NOT NULL DROP TABLE [dbo].[LoginAudit];
IF OBJECT_ID(N'[dbo].[Attendees]', N'U') IS NOT NULL DROP TABLE [dbo].[Attendees];
IF OBJECT_ID(N'[dbo].[ContactInquiries]', N'U') IS NOT NULL DROP TABLE [dbo].[ContactInquiries];
IF OBJECT_ID(N'[dbo].[Sessions]', N'U') IS NOT NULL DROP TABLE [dbo].[Sessions];
IF OBJECT_ID(N'[dbo].[Speakers]', N'U') IS NOT NULL DROP TABLE [dbo].[Speakers];
IF OBJECT_ID(N'[dbo].[Countries]', N'U') IS NOT NULL DROP TABLE [dbo].[Countries];
GO

-- ----------------------------------------------------------------------------
-- 1. Lookup Table: Countries (for Registration & Profile forms)
-- ----------------------------------------------------------------------------
CREATE TABLE [dbo].[Countries] (
    [CountryID]        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CountryCode]      VARCHAR(5) NOT NULL UNIQUE,
    [CountryNameEn]    NVARCHAR(100) NOT NULL,
    [CountryNameAr]    NVARCHAR(100) NOT NULL,
    [NationalityEn]    NVARCHAR(100) NOT NULL,
    [NationalityAr]    NVARCHAR(100) NOT NULL,
    [PathLocation]     NVARCHAR(255) NULL,
    [Sorting]          INT DEFAULT 99,
    [IsActive]         BIT DEFAULT 1
);
GO

-- Compatibility view for existing ASP.NET controls expecting 'qryCountries'
CREATE VIEW [dbo].[qryCountries] AS
SELECT 
    [CountryID],
    [CountryNameEn],
    [CountryNameAr],
    [NationalityEn],
    [NationalityAr],
    [PathLocation],
    [Sorting]
FROM [dbo].[Countries]
WHERE [IsActive] = 1;
GO

-- ----------------------------------------------------------------------------
-- 2. Speakers & Faculty Table (Speaker Profile Data Only)
-- ----------------------------------------------------------------------------
CREATE TABLE [dbo].[Speakers] (
    [SpeakerID]         INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [FullNameEn]        NVARCHAR(150) NOT NULL,
    [FullNameAr]        NVARCHAR(150) NOT NULL,
    [JobTitleEn]        NVARCHAR(250) NULL,
    [JobTitleAr]        NVARCHAR(250) NULL,
    [OrganizationEn]    NVARCHAR(250) NULL,
    [OrganizationAr]    NVARCHAR(250) NULL,
    [Sector]            NVARCHAR(50) NOT NULL DEFAULT 'clinical',
    [SectorNameEn]      NVARCHAR(100) NULL,
    [SectorNameAr]      NVARCHAR(100) NULL,
    [Region]            NVARCHAR(50) NOT NULL DEFAULT 'national',
    [RegionNameEn]      NVARCHAR(100) NULL,
    [RegionNameAr]      NVARCHAR(100) NULL,
    [ImagePath]         NVARCHAR(500) NOT NULL DEFAULT '/Content/images/speakers/Speaker-Photo.png',
    [CvPdfPath]         NVARCHAR(500) NULL,
    [Flag]              NVARCHAR(20) NULL DEFAULT N'🇸🇦',
    [Initials]          NVARCHAR(10) NULL,
    [Sorting]           INT NOT NULL DEFAULT 0,
    [IsActive]          BIT NOT NULL DEFAULT 1
);
GO

CREATE INDEX IX_Speakers_Sorting ON [dbo].[Speakers]([Sorting]);
GO

-- Compatibility view for existing legacy pages expecting 'Judges'
CREATE VIEW [dbo].[Judges] AS
SELECT 
    [SpeakerID] AS [ID],
    [SpeakerID],
    [FullNameEn] AS [NameEn],
    [FullNameAr] AS [NameAr],
    [JobTitleEn] AS [PositionEn],
    [JobTitleAr] AS [PositionAr],
    [OrganizationEn],
    [OrganizationAr],
    [ImagePath],
    [CvPdfPath] AS [PdfPath],
    [ImagePath] AS [PdfImage],
    [Sorting]
FROM [dbo].[Speakers]
WHERE [IsActive] = 1;
GO

-- ----------------------------------------------------------------------------
-- 3. Sessions Table (Foreign Key references dbo.Speakers)
-- ----------------------------------------------------------------------------
CREATE TABLE [dbo].[Sessions] (
    [SessionID]         INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [SpeakerID]         INT NULL,
    [TitleEn]           NVARCHAR(500) NOT NULL,
    [TitleAr]           NVARCHAR(500) NOT NULL,
    [Track]             NVARCHAR(50) NOT NULL DEFAULT 'track-a',
    [TrackNameEn]       NVARCHAR(200) NULL,
    [TrackNameAr]       NVARCHAR(200) NULL,
    [RoomEn]            NVARCHAR(100) NOT NULL,
    [RoomAr]            NVARCHAR(100) NOT NULL,
    [DayNumber]         INT NOT NULL DEFAULT 1,
    [StartTime]         VARCHAR(20) NULL DEFAULT '09:00 AM',
    [EndTime]           VARCHAR(20) NULL DEFAULT '09:40 AM',
    [StartDateTime]     DATETIME NULL DEFAULT '2026-12-13 09:00:00',
    [EndDateTime]       DATETIME NULL DEFAULT '2026-12-13 09:40:00',
    [RoleEn]            NVARCHAR(100) NOT NULL DEFAULT 'Speaker',
    [RoleAr]            NVARCHAR(100) NOT NULL DEFAULT N'متحدث',
    [DescriptionEn]     NVARCHAR(MAX) NULL,
    [DescriptionAr]     NVARCHAR(MAX) NULL,
    [Sorting]           INT NOT NULL DEFAULT 0,
    [IsActive]          BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_Sessions_Speakers FOREIGN KEY ([SpeakerID]) 
        REFERENCES [dbo].[Speakers]([SpeakerID]) 
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
GO

CREATE INDEX IX_Sessions_SpeakerID ON [dbo].[Sessions]([SpeakerID]);
CREATE INDEX IX_Sessions_Track ON [dbo].[Sessions]([Track]);
CREATE INDEX IX_Sessions_DayNumber ON [dbo].[Sessions]([DayNumber]);
GO

-- View joining Speakers and Sessions
CREATE VIEW [dbo].[vw_SummitSpeakers] AS
SELECT 
    s.[SpeakerID],
    s.[FullNameEn],
    s.[FullNameAr],
    s.[JobTitleEn],
    s.[JobTitleAr],
    s.[OrganizationEn],
    s.[OrganizationAr],
    s.[ImagePath],
    s.[CvPdfPath],
    s.[Sector],
    s.[SectorNameEn],
    s.[SectorNameAr],
    s.[Region],
    s.[RegionNameEn],
    s.[RegionNameAr],
    s.[Flag],
    s.[Initials],
    s.[Sorting],
    s.[IsActive],
    sess.[SessionID],
    sess.[TitleEn] AS [LectureTitleEn],
    sess.[TitleAr] AS [LectureTitleAr],
    sess.[Track],
    sess.[TrackNameEn],
    sess.[TrackNameAr],
    sess.[RoomEn],
    sess.[RoomAr],
    sess.[DayNumber],
    sess.[StartTime],
    sess.[EndTime],
    sess.[StartDateTime],
    sess.[EndDateTime],
    sess.[RoleEn] AS [SessionRoleEn],
    sess.[RoleAr] AS [SessionRoleAr]
FROM [dbo].[Speakers] s
LEFT JOIN [dbo].[Sessions] sess ON s.[SpeakerID] = sess.[SpeakerID]
WHERE s.[IsActive] = 1;
GO

-- ----------------------------------------------------------------------------
-- 4. Attendees & Registration Pass Table
-- ----------------------------------------------------------------------------
CREATE TABLE [dbo].[Attendees] (
    [AttendeeID]        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CountryID]         INT NULL,
    [FullName]          NVARCHAR(150) NOT NULL,
    [Email]             VARCHAR(100) NOT NULL UNIQUE,
    [PasswordHash]      NVARCHAR(256) NULL,
    [MobileNo]          VARCHAR(25) NULL,
    [Organization]      NVARCHAR(200) NULL,
    [JobTitle]          NVARCHAR(150) NULL,
    [Specialty]         NVARCHAR(150) NULL,
    [LinkedInUrl]       VARCHAR(300) NULL,
    [PassCode]          VARCHAR(50) NULL UNIQUE,
    [QrCodePath]        NVARCHAR(500) NULL,
    [IsCheckedIn]       BIT DEFAULT 0,
    [CheckedInAt]       DATETIME NULL,
    [RegisteredAt]      DATETIME DEFAULT GETDATE(),

    -- Website account / authentication (see Content/classes/AuthService.cs)
    -- PasswordHash format: PBKDF2-SHA512$iterations$salt$hash  (never store plaintext passwords)
    [UserLevel]         VARCHAR(20) NOT NULL CONSTRAINT DF_Attendees_UserLevel DEFAULT 'User',  -- 'User' or 'Admin'
    [IsBlocked]         BIT NOT NULL CONSTRAINT DF_Attendees_IsBlocked DEFAULT 0,
    [FailedLoginCount]  INT NOT NULL CONSTRAINT DF_Attendees_FailedLoginCount DEFAULT 0,
    [LockoutEndUtc]     DATETIME2 NULL,
    [LastLoginAtUtc]    DATETIME2 NULL,
    [HasCompletedSurvey] BIT NOT NULL CONSTRAINT DF_Attendees_HasCompletedSurvey DEFAULT 0,

    CONSTRAINT FK_Attendees_Countries FOREIGN KEY ([CountryID])
        REFERENCES [dbo].[Countries]([CountryID])
        ON DELETE SET NULL
);

CREATE INDEX IX_Attendees_Email ON [dbo].[Attendees]([Email]);
CREATE INDEX IX_Attendees_PassCode ON [dbo].[Attendees]([PassCode]);
GO

-- ----------------------------------------------------------------------------
-- 5. Login Audit Table (sign-in attempts; passwords are never logged)
-- ----------------------------------------------------------------------------
CREATE TABLE [dbo].[LoginAudit] (
    [LoginAuditID]      BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [AttendeeID]        INT NULL,           -- NULL when the email is not registered
    [Email]             VARCHAR(100) NULL,
    [IpAddress]         VARCHAR(45) NULL,
    [UserAgent]         NVARCHAR(400) NULL,
    [Succeeded]         BIT NOT NULL,
    [CreatedAtUtc]      DATETIME2 NOT NULL CONSTRAINT DF_LoginAudit_CreatedAtUtc DEFAULT SYSUTCDATETIME()
);

CREATE INDEX IX_LoginAudit_AttendeeID ON [dbo].[LoginAudit]([AttendeeID], [CreatedAtUtc]);
GO

-- ----------------------------------------------------------------------------
-- 6. Contact Inquiries Table
-- ----------------------------------------------------------------------------
CREATE TABLE [dbo].[ContactInquiries] (
    [InquiryID]         INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [FullName]          NVARCHAR(150) NOT NULL,
    [Email]             VARCHAR(100) NOT NULL,
    [MobileNo]          VARCHAR(25) NULL,
    [Message]           NVARCHAR(MAX) NOT NULL,
    [IsResolved]        BIT DEFAULT 0,
    [SubmittedAt]       DATETIME DEFAULT GETDATE()
);
GO

-- Compatibility view for existing pages expecting 'qryApiContactUs'
CREATE VIEW [dbo].[qryApiContactUs] AS
SELECT 
    [InquiryID] AS [ContactUsId],
    [FullName],
    [Email],
    [MobileNo],
    [Message]
FROM [dbo].[ContactInquiries];
GO

-- ============================================================================
-- SEED DATA: SAIRH 2026 Core Data
-- ============================================================================

-- Seed Countries
INSERT INTO [dbo].[Countries] ([CountryCode], [CountryNameEn], [CountryNameAr], [NationalityEn], [NationalityAr], [PathLocation], [Sorting])
VALUES 
('SA', N'Saudi Arabia', N'المملكة العربية السعودية', N'Saudi', N'سعودي', N'Content/images/flags/sa.png', 1),
('AE', N'United Arab Emirates', N'الإمارات العربية المتحدة', N'Emirati', N'إماراتي', N'Content/images/flags/ae.png', 2),
('BH', N'Bahrain', N'مملكة البحرين', N'Bahraini', N'بحريني', N'Content/images/flags/bh.png', 3),
('KW', N'Kuwait', N'دولة الكويت', N'Kuwaiti', N'كويتي', N'Content/images/flags/kw.png', 4),
('QA', N'Qatar', N'دولة قطر', N'Qatari', N'قطري', N'Content/images/flags/qa.png', 5),
('OM', N'Oman', N'سلطنة عمان', N'Omani', N'عماني', N'Content/images/flags/om.png', 6),
('EG', N'Egypt', N'جمهورية مصر العربية', N'Egyptian', N'مصري', N'Content/images/flags/eg.png', 7),
('US', N'United States', N'الولايات المتحدة الأمريكية', N'American', N'أمريكي', N'Content/images/flags/us.png', 8),
('GB', N'United Kingdom', N'المملكة المتحدة', N'British', N'بريطاني', N'Content/images/flags/gb.png', 9);
GO

-- 5. Insert Speakers Data (Profiles Only)
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Fahad Almsned', N'د. فهد المسند', N'Director of Research Operations', N'مدير العمليات البحثية',
    N'King Fahad Specialist Hospital - Dammam', N'مستشفى الملك فهد التخصصي - الدمام', N'clinical', N'Hospitals &amp; Healthcare', N'رعاية صحية ومستشفيات',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Fahad-Almsned-Photo.jpeg', N'/Content/docs/speakers/Fahad-Almsned-CV.pdf',
    N'🇸🇦', N'FA', 1, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Eman Alshehri', N'د. إيمان الشهري', N'Assistant Professor, Computer Department', N'أستاذ مساعد، قسم الحاسب الآلي',
    N'Imam Abdulrahman Bin Faisal University', N'جامعة الإمام عبدالرحمن بن فيصل', N'academic', N'Academic &amp; Universities', N'أكاديمي وجامعي',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Speaker-Photo.png', N'/Content/docs/speakers/Eman-Alshehri-CV.pdf',
    N'🇸🇦', N'EA', 2, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Ms. Fadwa AlBawardi, MSc', N'أ. فدوى البواردي', N'Founder and CEO', N'المؤسس والرئيس التنفيذي',
    N'FSAB Consulting', N'إف إس إيه بي للاستشارات', N'industry', N'Industry &amp; Consulting', N'استشارات وتقنية',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Fadwa-AlBawardi-Photo.jpg', N'/Content/docs/speakers/Fadwa-AlBawardi-CV.pdf',
    N'🇸🇦', N'FB', 3, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Aseel Aldawood', N'د. أسيل الداوود', N'KSA Leader, EMEA AI Center of Excellence', N'قائد المملكة لمركز التميز للذكاء الاصطناعي في أوروبا والشرق الأوسط وأفريقيا',
    N'EMEA AI Center of Excellence', N'مركز التميز للذكاء الاصطناعي (EMEA)', N'industry', N'Industry &amp; AI Leadership', N'قطاع التقنية والذكاء الاصطناعي',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Speaker-Photo.png', N'/Content/docs/speakers/Aseel-Addawood-CV.pdf',
    N'🇸🇦', N'AA', 4, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Mostafa Youldash', N'د. مصطفى يلدش', N'Assistant Professor, Department Chairperson (Computer Engineering)', N'أستاذ مساعد، رئيس قسم هندسة الحاسب الآلي',
    N'Imam Abdulrahman Bin Faisal University, Dammam', N'جامعة الإمام عبدالرحمن بن فيصل - الدمام', N'academic', N'Academic &amp; Universities', N'أكاديمي وجامعي',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Speaker-Photo.png', N'/Content/docs/speakers/Mustafa-Yoldash-CV.pdf',
    N'🇸🇦', N'MY', 5, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Mr. Yazeed Alsudays, MBA', N'أ. يزيد السديس', N'Strategic Account Manager', N'مدير الحسابات الاستراتيجية',
    N'Solventum', N'سولفنتوم', N'industry', N'Healthcare Technology', N'تقنية الرعاية الصحية',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Yazeed-Alsudays-Photo.jpg', N'/Content/docs/speakers/Yazeed-Alsudays-CV.pdf',
    N'🇸🇦', N'YA', 6, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Abeer Alalmaie', N'د. عبير الألمعي', N'Advisor to the President of King Khalid University for IP Commercialization', N'مستشار رئيس جامعة الملك خالد لتسويق الملكية الفكرية',
    N'King Khalid University', N'جامعة الملك خالد', N'academic', N'Academic &amp; Innovation', N'أكاديمي وابتكار',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Abeer-Alalmaie-Photo.png', N'/Content/docs/speakers/Abeer-Alalmaie-CV.pdf',
    N'🇸🇦', N'AA', 7, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Clare Rainey', N'د. كلير ريني', N'Lecturer in Medical Imaging and Radiation Therapy', N'محاضر في التصوير الطبي والعلاج الإشعاعي',
    N'University College Cork, Ireland', N'كلية جامعة كورك - أيرلندا', N'international', N'International Faculty', N'هيئة تدريس دولية',
    N'international', N'Ireland', N'أيرلندا', N'/Content/images/speakers/Clare-Rainey-Photo.jpg.png', N'/Content/docs/speakers/Clare-Rainey-CV.pdf',
    N'🇮🇪', N'CR', 8, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Rebecca Vaz', N'د. ريبيكا فاز', N'Clinical Research Officer', N'مسؤولة الأبحاث السريرية',
    N'Voithy', N'فويثي', N'international', N'Clinical Research', N'أبحاث سريرية',
    N'international', N'Brazil', N'البرازيل', N'/Content/images/speakers/Rebeca-Queiroz-Photo.JPG', N'/Content/docs/speakers/Rebeca-Queiroz-CV.pdf',
    N'🇧🇷', N'RV', 9, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Moath Ameer', N'معاذ أمير', N'Medical Student', N'طالب بكلية الطب',
    N'Imam Abdulrahman Bin Faisal University', N'جامعة الإمام عبدالرحمن بن فيصل - كلية الطب', N'academic', N'Student Innovation', N'ابتكار طلابي',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Speaker-Photo.png', NULL,
    N'🇸🇦', N'MA', 10, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Amna Kashgari', N'د. آمنة كاشقري', N'Head of Radiology AI Transformation, Medical Imaging Department', N'رئيسة التحول الرقمي للذكاء الاصطناعي في الأشعة، قسم التصوير الطبي',
    N'King Abdulaziz Medical City (MNGHA)', N'مدينة الملك عبدالعزيز الطبية - الحرس الوطني', N'clinical', N'Hospitals &amp; Healthcare', N'رعاية صحية ومستشفيات',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Amna-Kashgari-Photo.jpg', N'/Content/docs/speakers/Amna-Kashgari-CV.pdf',
    N'🇸🇦', N'AK', 11, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Prof. Karen Knapp', N'بروفيسور كارين ناب', N'Professor of Musculoskeletal Imaging, Head of Health and Care Professions', N'أستاذة التصوير العضلي الهيكلي، رئيسة المهن الصحية والرعاية',
    N'University of Exeter, UK', N'جامعة إكستر - المملكة المتحدة', N'international', N'International Faculty', N'هيئة تدريس دولية',
    N'international', N'United Kingdom', N'المملكة المتحدة', N'/Content/images/speakers/Karen-Knapp-Photo.jpg', N'/Content/docs/speakers/Karen-Knapp-CV.pdf',
    N'🇬🇧', N'KK', 12, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Mohammed Asiri', N'د. محمد عسيري', N'Assistant Professor', N'أستاذ مساعد',
    N'Taif University', N'جامعة الطائف', N'academic', N'Academic &amp; Universities', N'أكاديمي وجامعي',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Mohammed-Asiri-Photo.jpeg', N'/Content/docs/speakers/Mohammed-Asiri-CV.pdf',
    N'🇸🇦', N'MA', 13, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Yasser Hadi', N'د. ياسر هادي', N'Senior CT Technologist', N'أخصائي أول أشعة مقطعية',
    N'King Abdullah Medical City (KAMC)', N'مدينة الملك عبدالله الطبية', N'clinical', N'Hospitals &amp; Healthcare', N'رعاية صحية ومستشفيات',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Yasser-Hadi-Photo.JPG', N'/Content/docs/speakers/Yasser-Hadi.pdf',
    N'🇸🇦', N'YH', 14, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Abdulkarem Alqahtani', N'د. عبدالكريم القحطاني', N'Lecturer in Medical Ultrasound', N'محاضر في الموجات فوق الصوتية الطبية',
    N'Taibah University', N'جامعة طيبة', N'academic', N'Academic &amp; Universities', N'أكاديمي وجامعي',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Abdulkareem-Alqahtani-Photo.jpeg', N'/Content/docs/speakers/Abdulkareem-Alqahtani-CV.pdf',
    N'🇸🇦', N'AA', 15, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Abdulaziz Almulhim', N'د. عبدالعزيز الملحم', N'Vascular and Interventional Radiology Consultant', N'استشاري الأشعة التداخلية والقسطرة الوعائية',
    N'Eastern Province &ndash; Alahsa Health Cluster', N'تجمع الأحساء الصحي &ndash; المنطقة الشرقية', N'clinical', N'Hospitals &amp; Healthcare', N'رعاية صحية ومستشفيات',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Abdulaziz-Almulhim-Photo.png', N'/Content/docs/speakers/Abdulaziz-AlMulhim-CV.pdf',
    N'🇸🇦', N'AA', 16, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Sonyia McFadden', N'د. سونيا ماكفادين', N'Senior Lecturer (Diagnostic Imaging)', N'محاضر أول (التصوير التشخيصي)',
    N'Ulster University, UK', N'جامعة أولستر - المملكة المتحدة', N'international', N'International Faculty', N'هيئة تدريس دولية',
    N'international', N'United Kingdom', N'المملكة المتحدة', N'/Content/images/speakers/Sonyia-McFadden-Photo.jpg', N'/Content/docs/speakers/Sonyia-McFadden-CV.pdf',
    N'🇬🇧', N'SM', 17, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Raid Alshinibr', N'د. رائد الشنيبر', N'Head of Radiology', N'رئيس قسم الأشعة',
    N'Care Medical Group - AlSalam Hospital', N'مستشفى السلام - مجموعة رعاية الطبية', N'clinical', N'Hospitals &amp; Healthcare', N'رعاية صحية ومستشفيات',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Raid-Alshinibr-Photo.png', N'/Content/docs/speakers/Raid-Alshinibr-CV.pdf',
    N'🇸🇦', N'RA', 18, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Minyar Sassi', N'د. منيار الساسي', N'Full Professor in Computer Science', N'أستاذة في علوم الحاسب الآلي',
    N'National Engineering School of Tunis, Tunis El Manar University, Tunisia', N'المدرسة الوطنية للمهندسين بتونس - جامعة تونس المنار', N'international', N'International Faculty', N'هيئة تدريس دولية',
    N'international', N'Tunisia', N'تونس', N'/Content/images/speakers/Minyar-Hidr-Photo.jpg', N'/Content/docs/speakers/Minyar-Hidr-CV.pdf',
    N'🇹🇳', N'MS', 19, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Hairil Abdul Razak', N'د. هيريل عبدالرزاق', N'Senior Lecturer, Medical Imaging', N'محاضر أول، التصوير الطبي',
    N'University of Exeter, UK', N'جامعة إكستر - المملكة المتحدة', N'international', N'International Faculty', N'هيئة تدريس دولية',
    N'international', N'United Kingdom', N'المملكة المتحدة', N'/Content/images/speakers/Hairil-AbdulRazak-Photo.jpg', N'/Content/docs/speakers/Hairil-AbdulRazak-CV.pdf',
    N'🇬🇧', N'HR', 20, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Abdulaziz M. Al-Sharydah', N'د. عبدالعزيز محمد الشريدة', N'Associate Professor - Chairman of Radiology Department', N'أستاذ مشارك - رئيس قسم الأشعة',
    N'Imam Abdulrahman Bin Faisal University', N'جامعة الإمام عبدالرحمن بن فيصل', N'academic', N'Academic &amp; Hospitals', N'أكاديمي ورعاية صحية',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Speaker-Photo.png', NULL,
    N'🇸🇦', N'AA', 21, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Mohammede Alsaadi', N'د. محمد السعدي', N'Associate Professor in Radiology and Medical Imaging', N'أستاذ مشارك في الأشعة والتصوير الطبي',
    N'Prince Sattam bin Abdulaziz University', N'جامعة الأمير سطام بن عبدالعزيز', N'academic', N'Academic &amp; Universities', N'أكاديمي وجامعي',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Mohammed-Saadi-Photo.jpeg', N'/Content/docs/speakers/Mohammed-Saadi-CV.pdf',
    N'🇸🇦', N'MA', 22, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Oun Al-iedani', N'د. عون العيداني', N'Postdoctoral Researcher, MS Fellow, School of Biomedical Sciences and Pharmacy', N'باحث ما بعد الدكتوراه وزميل التصلب المتعدد، كلية العلوم الطبية الحيوية والصيدلة',
    N'University of Newcastle, Australia', N'جامعة نيوكاسل - أستراليا', N'international', N'International Research', N'أبحاث دولية',
    N'international', N'Australia', N'أستراليا', N'/Content/images/speakers/Oun-Aliedani-Photo.jpg', N'/Content/docs/speakers/Oun-Aliedani-CV.pdf',
    N'🇦🇺', N'OA', 23, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Amal Alsalamah', N'د. أمل السلامة', N'Head of Radiological Sciences Program', N'رئيسة برنامج العلوم الإشعاعية',
    N'Batterjee Medical College', N'كلية بترجي الطبية', N'academic', N'Academic &amp; Innovation', N'أكاديمي وابتكار',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Amal-Alsalamah-Photo.jpeg', N'/Content/docs/speakers/Amal-Alsalamah-CV.pdf',
    N'🇸🇦', N'AA', 24, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Rasha Alafaleg', N'د. رشا العفالق', N'Assistant Professor of Dental Education and Basic Oral Medical Science', N'أستاذ مساعد في تعليم طب الأسنان والعلوم الطبية الأساسية للفم',
    N'University of Qassim', N'جامعة القصيم', N'academic', N'Academic &amp; Universities', N'أكاديمي وجامعي',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Rasha-Alafaleg-Photo.jpeg', N'/Content/docs/speakers/Rasha-Alafaleg-CV.pdf',
    N'🇸🇦', N'RA', 25, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Ali Alhailiy', N'د. علي الهيلي', N'Head of Radiology and Medical Imaging Department', N'رئيس قسم الأشعة والتصوير الطبي',
    N'Prince Sattam Bin AbdulAziz University', N'جامعة الأمير سطام بن عبدالعزيز', N'academic', N'Academic &amp; Universities', N'أكاديمي وجامعي',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Ali-Alhaili-Photo.jpg', N'/Content/docs/speakers/Ali-Alhailiy-CV.pdf',
    N'🇸🇦', N'AA', 26, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Mr. Fahad Alsadan, MSc', N'أ. فهد السعدان', N'Innovation and Scientific Partnership, Innovation Center Manager', N'مدير مركز الابتكار والشراكات العلمية',
    N'Siemens Healthineers', N'سيمنز هيلثينيرز', N'industry', N'Healthcare Industry', N'قطاع التقنية الصحية',
    N'national', N'Saudi Arabia', N'المملكة العربية السعودية', N'/Content/images/speakers/Fahad-Alsadan-Photo.jpg', N'/Content/docs/speakers/Fahad-Alsadan-CV.pdf',
    N'🇸🇦', N'FA', 27, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Prof. Mark McEntee', N'بروفيسور مارك ماكنتي', N'Vice Head of Learning and Teaching, UCC College of Medicine and Health', N'نائب رئيس التعليم والتعلم، كلية الطب والصحة بجامعة كورك',
    N'University College Cork, Ireland', N'كلية جامعة كورك - أيرلندا', N'international', N'International Faculty', N'هيئة تدريس دولية',
    N'international', N'Ireland', N'أيرلندا', N'/Content/images/speakers/Mark-McEntee-Photo.jpeg', N'/Content/docs/speakers/Mark-McEntee-CV.pdf',
    N'🇮🇪', N'MM', 28, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Laura McLaughlin', N'د. لورا ماكلوغلين', N'Lecturer in Diagnostic Radiography and Imaging', N'محاضر في التصوير الإشعاعي التشخيصي',
    N'Ulster University, UK', N'جامعة أولستر - المملكة المتحدة', N'international', N'International Faculty', N'هيئة تدريس دولية',
    N'international', N'United Kingdom', N'المملكة المتحدة', N'/Content/images/speakers/Laura-McLaughlin-Photo.jpg', N'/Content/docs/speakers/Laura-McLaughlin-CV.pdf',
    N'🇬🇧', N'LM', 29, 1
);
INSERT INTO [dbo].[Speakers] (
    [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr],
    [OrganizationEn], [OrganizationAr], [Sector], [SectorNameEn], [SectorNameAr],
    [Region], [RegionNameEn], [RegionNameAr], [ImagePath], [CvPdfPath],
    [Flag], [Initials], [Sorting], [IsActive]
) VALUES (
    N'Dr. Andrew England', N'د. أندرو إنغلاند', N'Senior Lecturer in Medical Imaging / Radiation Therapy', N'محاضر أول في التصوير الطبي والعلاج الإشعاعي',
    N'University College Cork, Ireland', N'كلية جامعة كورك - أيرلندا', N'international', N'International Faculty', N'هيئة تدريس دولية',
    N'international', N'Ireland', N'أيرلندا', N'/Content/images/speakers/Speaker-Photo.png', N'/Content/docs/speakers/Andrew-England-CV.pdf',
    N'🇮🇪', N'AE', 30, 1
);

GO
-- 6. Insert Sessions Data (Linked via SpeakerID Foreign Key)
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    1, N'THE FUTURE OF DATA-DRIVEN MEDICINE IS BEING WRITTEN TODAY &mdash; Moving from ''AI Hype'' to ''Integrated Clinical Reality''', N'مستقبل الطب المبني على البيانات يُكتب اليوم &mdash; الانتقال من ضجيج الذكاء الاصطناعي إلى واقع سريري متكامل',
    N'track-a', N'Track A &ndash; AI &amp; Digital Technology Transformation', N'المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي',
    N'Hall 1', N'القاعة الأولى', 1,
    N'09:00 AM', N'09:40 AM',
    '2026-12-13 09:00:00', '2026-12-13 09:40:00', N'Keynote Speaker', N'متحدث رئيسي',
    1, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    2, N'Artificial Intelligence in Medical Imaging: From Data-Driven Insights to Clinical Impact', N'الذكاء الاصطناعي في التصوير الطبي: من الرؤى المعتمدة على البيانات إلى التأثير السريري',
    N'track-a', N'Track A &ndash; AI &amp; Digital Technology Transformation', N'المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي',
    N'Hall 1', N'القاعة الأولى', 1,
    N'09:45 AM', N'10:15 AM',
    '2026-12-13 09:45:00', '2026-12-13 10:15:00', N'Speaker', N'متحدث',
    2, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    3, N'AI vs. The Human Eye: Spotting Hidden Fractures', N'الذكاء الاصطناعي في مواجهة العين البشرية: اكتشاف الكسور الخفية',
    N'track-a', N'Track A &ndash; AI &amp; Digital Technology Transformation', N'المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي',
    N'Hall 1', N'القاعة الأولى', 1,
    N'10:20 AM', N'10:50 AM',
    '2026-12-13 10:20:00', '2026-12-13 10:50:00', N'Speaker', N'متحدث',
    3, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    4, N'From AI Pilots to Clinical Impact', N'من المشاريع التجريبية للذكاء الاصطناعي إلى الأثر السريري الملموس',
    N'track-a', N'Track A &ndash; AI &amp; Digital Technology Transformation', N'المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي',
    N'Hall 1', N'القاعة الأولى', 1,
    N'11:00 AM', N'11:30 AM',
    '2026-12-13 11:00:00', '2026-12-13 11:30:00', N'Speaker', N'متحدث',
    4, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    5, N'Transforming Radiology with AI and Agentic AI', N'تحول طب الأشعة بالذكاء الاصطناعي والذكاء الاصطناعي الوكيل',
    N'track-a', N'Track A &ndash; AI &amp; Digital Technology Transformation', N'المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي',
    N'Hall 1', N'القاعة الأولى', 1,
    N'11:35 AM', N'12:05 PM',
    '2026-12-13 11:35:00', '2026-12-13 12:05:00', N'Speaker', N'متحدث',
    5, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    6, N'Practical Use of AI in Dental Panoramic Imaging', N'التطبيقات العملية للذكاء الاصطناعي في التصوير البانورامي للأسنان',
    N'track-a', N'Track A &ndash; AI &amp; Digital Technology Transformation', N'المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي',
    N'Hall 1', N'القاعة الأولى', 1,
    N'01:00 PM', N'01:30 PM',
    '2026-12-13 12:10:00', '2026-12-13 12:40:00', N'Speaker', N'متحدث',
    6, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    7, N'Integrating Neuro-AI for Brain and Behaviour Analysis', N'دمج الذكاء العصبي الاصطناعي لتحليل الدماغ والسلوك',
    N'track-a', N'Track A &ndash; AI &amp; Digital Technology Transformation', N'المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي',
    N'Hall 1', N'القاعة الأولى', 1,
    N'01:35 PM', N'02:05 PM',
    '2026-12-13 13:00:00', '2026-12-13 13:30:00', N'Speaker', N'متحدث',
    7, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    8, N'Human-Computer Collaboration and Ethical AI Principles', N'التعاون بين الإنسان والحاسوب ومبادئ الذكاء الاصطناعي الأخلاقي',
    N'track-a', N'Track A &ndash; AI &amp; Digital Technology Transformation', N'المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي',
    N'Hall 1', N'القاعة الأولى', 1,
    N'02:10 PM', N'02:40 PM',
    '2026-12-13 13:35:00', '2026-12-13 14:05:00', N'Speaker', N'متحدث',
    8, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    9, N'Convolutional Neural Networks as a Tool for Oral Cancer Diagnosis', N'الشبكات العصبية الالتفافية كأداة لتشخيص سرطان الفم',
    N'track-a', N'Track A &ndash; AI &amp; Digital Technology Transformation', N'المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي',
    N'Hall 1', N'القاعة الأولى', 1,
    N'02:45 PM', N'03:15 PM',
    '2026-12-13 14:10:00', '2026-12-13 14:40:00', N'Speaker', N'متحدث',
    9, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    10, N'Student Innovations in AI', N'ابتكارات طلابية في الذكاء الاصطناعي',
    N'track-a', N'Track A &ndash; AI &amp; Digital Technology Transformation', N'المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي',
    N'Hall 1', N'القاعة الأولى', 1,
    N'03:20 PM', N'03:45 PM',
    '2026-12-13 14:45:00', '2026-12-13 15:15:00', N'Student Innovator', N'مبتكر طلابي',
    10, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    11, N'Radiology AI Adaptations: From Dependency to Empowerment', N'تبني الذكاء الاصطناعي في الأشعة: من التبعية إلى التمكين',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'09:00 AM', N'09:40 AM',
    '2026-12-13 09:00:00', '2026-12-13 09:30:00', N'Keynote Speaker', N'متحدث رئيسي',
    11, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    12, N'Clinical Risk Factors for Fracture Prediction', N'عوامل الخطر السريرية للتنبؤ بالكسور',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'09:45 AM', N'10:15 AM',
    '2026-12-13 09:35:00', '2026-12-13 10:05:00', N'Keynote Speaker', N'متحدث رئيسي',
    12, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    13, N'Advanced Ultrasound Applications in Bone Health Assessment', N'تطبيقات الموجات فوق الصوتية المتقدمة في تقييم صحة العظام',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'10:20 AM', N'10:45 AM',
    '2026-12-13 10:10:00', '2026-12-13 10:40:00', N'Speaker', N'متحدث',
    13, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    14, N'Positioning in CT: Is Automation Likely to be Helpful?', N'تموضع المريض في الأشعة المقطعية: هل الأتمتة مفيدة سريرياً؟',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'10:50 AM', N'11:15 AM',
    '2026-12-13 10:45:00', '2026-12-13 11:15:00', N'Speaker', N'متحدث',
    14, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    15, N'The Future of AI-Driven Ultrasound', N'مستقبل الموجات فوق الصوتية المدعومة بالذكاء الاصطناعي',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'11:20 AM', N'11:45 AM',
    '2026-12-13 11:20:00', '2026-12-13 11:50:00', N'Speaker', N'متحدث',
    15, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    16, N'The Smart Angio Suite with AI for Interventional Radiologists', N'جناح القسطرة الذكي المدعوم بالذكاء الاصطناعي للأشعة التداخلية',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'11:50 AM', N'12:15 PM',
    '2026-12-13 11:55:00', '2026-12-13 12:25:00', N'Speaker', N'متحدث',
    16, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    17, N'AI in the lung cancer pathway: a cross sectional survey and interview study.', N'الذكاء الاصطناعي في مسار سرطان الرئة: دراسة مسحية ومقابلات مستعرضة',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'01:00 PM', N'01:25 PM',
    '2026-12-13 12:30:00', '2026-12-13 13:00:00', N'Speaker', N'متحدث',
    17, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    18, N'Beyond Automation: Integrating AI into Clinical Radiology Workflows', N'ما بعد الأتمتة: دمج الذكاء الاصطناعي في مسارات عمل الأشعة السريرية',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'01:30 PM', N'01:55 PM',
    '2026-12-13 13:15:00', '2026-12-13 13:45:00', N'Speaker', N'متحدث',
    18, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    19, N'AI Ethics, Bias, and Governance in Radiology AI', N'أخلاقيات الذكاء الاصطناعي والتحيز وحوكمة الذكاء الاصطناعي في الأشعة',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'02:00 PM', N'02:25 PM',
    '2026-12-13 13:50:00', '2026-12-13 14:20:00', N'Speaker', N'متحدث',
    19, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    20, N'The Role of FDG PET/CT Imaging in Detecting Air-Borne Diseases', N'دور التصوير المقطعي بالإصدار البوزيتروني FDG PET/CT في الكشف عن الأمراض المنقولة جواً',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'02:30 PM', N'02:55 PM',
    '2026-12-13 14:25:00', '2026-12-13 14:55:00', N'Speaker', N'متحدث',
    20, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    21, N'Current State and Future of Artificial Intelligence in Pediatric Interventional Radiology: A Narrative Review', N'واقع ومستقبل الذكاء الاصطناعي في الأشعة التداخلية للأطفال: مراجعة سردية',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'03:00 PM', N'03:25 PM',
    '2026-12-13 15:00:00', '2026-12-13 15:30:00', N'Speaker', N'متحدث',
    21, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    22, N'Updates in Emergency Ultrasound', N'مستجدات الموجات فوق الصوتية في حالات الطوارئ',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'03:30 PM', N'03:55 PM',
    '2026-12-13 15:35:00', '2026-12-13 16:05:00', N'Speaker', N'متحدث',
    22, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    23, N'Multi-Modal MRI Post-Processing Method for AI-Driven Prediction of Multiple Sclerosis Progression: A Translational Imaging Framework', N'طريقة معالجة الرنين المغناطيسي متعدد الوسائط للتنبؤ بتطور التصلب المتعدد بالذكاء الاصطناعي',
    N'track-b', N'Track B &ndash; Advanced Clinical Radiology', N'المسار ب &ndash; الأشعة السريرية المتقدمة',
    N'Hall 2', N'القاعة الثانية', 1,
    N'04:00 PM', N'04:25 PM',
    '2026-12-13 16:10:00', '2026-12-13 16:40:00', N'Speaker', N'متحدث',
    23, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    24, N'Evaluation of the Face Validity of a Smart MRI Simulator', N'تقييم الصدق الظاهري لمحاكي الرنين المغناطيسي الذكي',
    N'track-c', N'Track C &ndash; Health Innovation', N'المسار ج &ndash; الابتكار الصحي',
    N'Hall 3', N'القاعة الثالثة', 1,
    N'09:00 AM', N'09:40 AM',
    '2026-12-13 09:00:00', '2026-12-13 09:40:00', N'Keynote Speaker', N'متحدث رئيسي',
    24, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    25, N'The Role of AI in Dental Imaging in Education', N'دور الذكاء الاصطناعي في تصوير الأسنان التعليمي',
    N'track-c', N'Track C &ndash; Health Innovation', N'المسار ج &ndash; الابتكار الصحي',
    N'Hall 3', N'القاعة الثالثة', 1,
    N'09:45 AM', N'10:15 AM',
    '2026-12-13 09:45:00', '2026-12-13 10:15:00', N'Speaker', N'متحدث',
    25, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    26, N'Functional and Radiomic Biomarkers in Virtual Colonoscopy', N'المؤشرات الحيوية الوظيفية والراديومية في تنظير القولون الافتراضي',
    N'track-c', N'Track C &ndash; Health Innovation', N'المسار ج &ndash; الابتكار الصحي',
    N'Hall 3', N'القاعة الثالثة', 1,
    N'10:20 AM', N'10:50 AM',
    '2026-12-13 10:20:00', '2026-12-13 10:50:00', N'Speaker', N'متحدث',
    26, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    27, N'Barriers and Opportunities in Scaling Innovation in Saudi Arabia', N'عوائق وفرص توسيع نطاق الابتكار في المملكة العربية السعودية',
    N'track-c', N'Track C &ndash; Health Innovation', N'المسار ج &ndash; الابتكار الصحي',
    N'Hall 3', N'القاعة الثالثة', 1,
    N'11:00 AM', N'11:30 AM',
    '2026-12-13 11:00:00', '2026-12-13 11:30:00', N'Speaker', N'متحدث',
    27, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    28, N'AI and the Future Challenges for Medical Imaging Education', N'الذكاء الاصطناعي والتحديات المستقبلية لتعليم التصوير الطبي',
    N'track-c', N'Track C &ndash; Health Innovation', N'المسار ج &ndash; الابتكار الصحي',
    N'Hall 3', N'القاعة الثالثة', 1,
    N'11:35 AM', N'12:05 PM',
    '2026-12-13 11:35:00', '2026-12-13 12:05:00', N'Keynote Speaker', N'متحدث رئيسي',
    28, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    29, N'Research AI and MRI Tools for Image Interpretation', N'أدوات أبحاث الذكاء الاصطناعي والرنين المغناطيسي لتفسير الصور',
    N'track-c', N'Track C &ndash; Health Innovation', N'المسار ج &ndash; الابتكار الصحي',
    N'Hall 3', N'القاعة الثالثة', 1,
    N'01:00 PM', N'01:30 PM',
    '2026-12-13 13:00:00', '2026-12-13 13:30:00', N'Speaker', N'متحدث',
    29, 1
);
INSERT INTO [dbo].[Sessions] (
    [SpeakerID], [TitleEn], [TitleAr], [Track], [TrackNameEn], [TrackNameAr],
    [RoomEn], [RoomAr], [DayNumber], [StartTime], [EndTime], [StartDateTime], [EndDateTime], [RoleEn], [RoleAr],
    [Sorting], [IsActive]
) VALUES (
    30, N'Grant Writing, Publishing & Research Innovation', N'كتابة المنح والنشر والابتكار البحثي',
    N'track-c', N'Track C &ndash; Health Innovation', N'المسار ج &ndash; الابتكار الصحي',
    N'Hall 3', N'القاعة الثالثة', 1,
    N'01:35 PM', N'02:05 PM',
    '2026-12-13 13:35:00', '2026-12-13 14:05:00', N'Speaker', N'متحدث',
    30, 1
);
GO

-- ----------------------------------------------------------------------------
-- 7. Password Reset Tokens Table
-- ----------------------------------------------------------------------------
CREATE TABLE [dbo].[PasswordResetTokens] (
    [TokenID]        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [AttendeeID]     INT NOT NULL,
    [Email]          VARCHAR(100) NOT NULL,
    [ResetToken]     VARCHAR(100) NOT NULL UNIQUE,
    [ExpiresAtUtc]   DATETIME2 NOT NULL,
    [IsUsed]         BIT NOT NULL CONSTRAINT DF_PasswordResetTokens_IsUsed DEFAULT 0,
    [CreatedAtUtc]   DATETIME2 NOT NULL CONSTRAINT DF_PasswordResetTokens_CreatedAtUtc DEFAULT SYSUTCDATETIME(),
    
    CONSTRAINT FK_PasswordResetTokens_Attendees FOREIGN KEY ([AttendeeID])
        REFERENCES [dbo].[Attendees]([AttendeeID])
        ON DELETE CASCADE
);

CREATE INDEX IX_PasswordResetTokens_Token ON [dbo].[PasswordResetTokens]([ResetToken], [IsUsed], [ExpiresAtUtc]);
CREATE INDEX IX_PasswordResetTokens_Email ON [dbo].[PasswordResetTokens]([Email]);
GO

-- ----------------------------------------------------------------------------
-- 8. Booths Table (15 Sponsor Booths & 30 Research Screens)
-- ----------------------------------------------------------------------------
CREATE TABLE [dbo].[Booths] (
    [BoothID]          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [BoothCode]        VARCHAR(10) NOT NULL UNIQUE,
    [NameEn]           NVARCHAR(150) NOT NULL,
    [NameAr]           NVARCHAR(150) NOT NULL,
    [OrganizationEn]   NVARCHAR(200) NOT NULL,
    [OrganizationAr]   NVARCHAR(200) NOT NULL,
    [Type]             VARCHAR(50) NOT NULL, -- 'SponsorBooth' or 'ResearchScreen'
    [HallEn]           NVARCHAR(100) NOT NULL, -- 'Sponsor Hall' or 'Research Screen Hall'
    [HallAr]           NVARCHAR(100) NOT NULL,
    [CategoriesEn]     NVARCHAR(500) NOT NULL,
    [CategoriesAr]     NVARCHAR(500) NOT NULL,
    [X]                INT NOT NULL DEFAULT 0,
    [Y]                INT NOT NULL DEFAULT 0,
    [CooldownMinutes]  INT NOT NULL DEFAULT 5,
    [LastScannedAtUtc] DATETIME2 NULL,
    [IsActive]         BIT NOT NULL DEFAULT 1
);

CREATE INDEX IX_Booths_Code ON [dbo].[Booths]([BoothCode]);
CREATE INDEX IX_Booths_Type ON [dbo].[Booths]([Type]);
GO

-- ----------------------------------------------------------------------------
-- 9. Survey Responses Table
-- ----------------------------------------------------------------------------
CREATE TABLE [dbo].[SurveyResponses] (
    [ResponseID]        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [AttendeeID]        INT NULL,
    [UserEmail]         VARCHAR(100) NOT NULL,
    [Interests]         NVARCHAR(MAX) NOT NULL,
    [BoothTypes]        NVARCHAR(MAX) NOT NULL,
    [Goals]             NVARCHAR(MAX) NOT NULL,
    [BoothCount]        INT NOT NULL DEFAULT 5,
    [RecommendedBooths] NVARCHAR(MAX) NOT NULL, -- JSON array of booth codes e.g. ["S1","S4","R6","R12","R18"]
    [Language]          VARCHAR(10) NOT NULL DEFAULT 'en',
    [SubmittedAtUtc]    DATETIME2 NOT NULL CONSTRAINT DF_SurveyResponses_SubmittedAtUtc DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_SurveyResponses_Attendees FOREIGN KEY ([AttendeeID])
        REFERENCES [dbo].[Attendees]([AttendeeID])
        ON DELETE SET NULL
);

CREATE INDEX IX_SurveyResponses_Email ON [dbo].[SurveyResponses]([UserEmail], [SubmittedAtUtc]);
GO

-- ----------------------------------------------------------------------------
-- 10. Booth Visits Table (NFC Tap & Check-in Scans)
-- ----------------------------------------------------------------------------
CREATE TABLE [dbo].[BoothVisits] (
    [VisitID]        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [AttendeeID]     INT NULL,
    [UserEmail]      VARCHAR(100) NOT NULL,
    [BoothCode]      VARCHAR(10) NOT NULL,
    [VisitedAtUtc]   DATETIME2 NOT NULL CONSTRAINT DF_BoothVisits_VisitedAtUtc DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_BoothVisits_Attendees FOREIGN KEY ([AttendeeID])
        REFERENCES [dbo].[Attendees]([AttendeeID])
        ON DELETE SET NULL
);

CREATE INDEX IX_BoothVisits_EmailCode ON [dbo].[BoothVisits]([UserEmail], [BoothCode]);
GO

-- ----------------------------------------------------------------------------
-- 11. Seed 15 Sponsor Booths & 30 Research Screens into dbo.Booths
-- ----------------------------------------------------------------------------
INSERT INTO [dbo].[Booths] ([BoothCode], [NameEn], [NameAr], [OrganizationEn], [OrganizationAr], [Type], [HallEn], [HallAr], [CategoriesEn], [CategoriesAr], [X], [Y])
VALUES
('S1', N'Sponsor Booth S1', N'جناح الراعي S1', N'AI Imaging Sponsor', N'راعي الذكاء الاصطناعي والتصوير', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'AI & Digital Technology, Medical Imaging & Radiology, AI Companies, New Technology', N'الذكاء الاصطناعي والتقنية الرقمية, التصوير الطبي والأشعة, شركات الذكاء الاصطناعي, تقنيات جديدة', 755, 195),
('S2', N'Sponsor Booth S2', N'جناح الراعي S2', N'Radiology Technology Sponsor', N'راعي تقنيات الأشعة', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'Medical Imaging & Radiology, Healthcare Technology, Medical Imaging Companies, Products', N'التصوير الطبي والأشعة, تقنية الرعاية الصحية, شركات التصوير الطبي, منتجات وخدمات', 755, 235),
('S3', N'Sponsor Booth S3', N'جناح الراعي S3', N'Healthcare Innovation Sponsor', N'راعي الابتكار الصحي', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'Health Innovation, Healthcare Technology, Healthcare Organizations, Healthcare Solutions', N'الابتكار الصحي, تقنية الرعاية الصحية, المنظمات الصحية, حلول الرعاية الصحية', 755, 275),
('S4', N'Sponsor Booth S4', N'جناح الراعي S4', N'AI Solutions Sponsor', N'راعي حلول الذكاء الاصطناعي', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'AI & Digital Technology, AI Companies, Healthcare Technology, New Technology', N'الذكاء الاصطناعي والتقنية الرقمية, شركات الذكاء الاصطناعي, تقنية الرعاية الصحية, تقنيات جديدة', 755, 315),
('S5', N'Sponsor Booth S5', N'جناح الراعي S5', N'Medical Imaging Sponsor', N'راعي التصوير الطبي', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'Medical Imaging & Radiology, Medical Imaging Companies, Products, New Technology', N'التصوير الطبي والأشعة, شركات التصوير الطبي, منتجات وخدمات, تقنيات جديدة', 755, 355),
('S6', N'Sponsor Booth S6', N'جناح الراعي S6', N'University Partner', N'الشريك الأكاديمي والجامعي', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'Research & Education, Universities & Colleges, Research, Networking', N'البحث والتعليم, الجامعات والكليات, أبحاث سريرية, تواصل مهني', 755, 395),
('S7', N'Sponsor Booth S7', N'جناح الراعي S7', N'Health Organization Partner', N'شريك المنظمات الصحية', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'Health Innovation, Healthcare Organizations, Healthcare Solutions, Networking', N'الابتكار الصحي, المنظمات الصحية, حلول الرعاية الصحية, تواصل مهني', 755, 435),
('S8', N'Sponsor Booth S8', N'جناح الراعي S8', N'Medical Technology Sponsor', N'راعي التقنيات الطبية المتقدمة', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'Healthcare Technology, Medical Imaging & Radiology, Medical Imaging Companies, Products', N'تقنية الرعاية الصحية, التصوير الطبي والأشعة, شركات التصوير الطبي, منتجات وخدمات', 920, 115),
('S9', N'Sponsor Booth S9', N'جناح الراعي S9', N'AI Healthcare Sponsor', N'راعي الذكاء الاصطناعي الصحي', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'AI & Digital Technology, Health Innovation, AI Companies, Healthcare Solutions', N'الذكاء الاصطناعي والتقنية الرقمية, الابتكار الصحي, شركات الذكاء الاصطناعي, حلول الرعاية الصحية', 920, 155),
('S10', N'Sponsor Booth S10', N'جناح الراعي S10', N'Startup Sponsor', N'راعي الشركات الناشئة والريادة', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'Startups & Innovation, Startups, Innovation, Networking', N'الشركات الناشئة والابتكار, الشركات الناشئة, ابتكار وتقنيات واعدة, تواصل مهني', 920, 195),
('S11', N'Sponsor Booth S11', N'جناح الراعي S11', N'Digital Health Sponsor', N'راعي الصحة الرقمية', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'AI & Digital Technology, Health Innovation, Healthcare Technology, New Technology', N'الذكاء الاصطناعي والتقنية الرقمية, الابتكار الصحي, تقنية الرعاية الصحية, تقنيات جديدة', 920, 235),
('S12', N'Sponsor Booth S12', N'جناح الراعي S12', N'Research Partner', N'الشريك البحثي الوطني', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'Research & Education, Universities & Colleges, Research, Networking', N'البحث والتعليم, الجامعات والكليات, أبحاث سريرية, تواصل مهني', 920, 275),
('S13', N'Sponsor Booth S13', N'جناح الراعي S13', N'Clinical Technology Sponsor', N'راعي التقنيات السريرية', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'Medical Imaging & Radiology, Healthcare Organizations, Healthcare Solutions, Products', N'التصوير الطبي والأشعة, المنظمات الصحية, حلول الرعاية الصحية, منتجات وخدمات', 920, 315),
('S14', N'Sponsor Booth S14', N'جناح الراعي S14', N'Innovation Sponsor', N'راعي الابتكار المستقبلي', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'Startups & Innovation, Health Innovation, Innovation, New Technology', N'الشركات الناشئة والابتكار, الابتكار الصحي, ابتكار وتقنيات واعدة, تقنيات جديدة', 920, 355),
('S15', N'Sponsor Booth S15', N'جناح الراعي S15', N'AI Research Sponsor', N'راعي أبحاث الذكاء الاصطناعي', 'SponsorBooth', N'Sponsor Hall', N'قاعة الرعاة', N'AI & Digital Technology, Research & Education, AI Companies, Research', N'الذكاء الاصطناعي والتقنية الرقمية, البحث والتعليم, شركات الذكاء الاصطناعي, أبحاث سريرية', 920, 395);

DECLARE @r_init INT = 1;
DECLARE @x_init INT, @y_init INT;
DECLARE @catEn_init NVARCHAR(500), @catAr_init NVARCHAR(500);

WHILE @r_init <= 30
BEGIN
    IF @r_init <= 12
    BEGIN
        SET @x_init = 90 + (@r_init - 1) * 50;
        SET @y_init = 35;
    END
    ELSE IF @r_init <= 18
    BEGIN
        SET @x_init = 35;
        SET @y_init = 70 + (@r_init - 13) * 28;
    END
    ELSE
    BEGIN
        SET @x_init = 90 + (@r_init - 19) * 50;
        SET @y_init = 220;
    END

    IF (@r_init % 6) = 1
    BEGIN
        SET @catEn_init = N'AI & Digital Technology, Research & Education, Research Displays, Research';
        SET @catAr_init = N'الذكاء الاصطناعي والتقنية الرقمية, البحث والتعليم, منصات عرض الأبحاث, أبحاث سريرية';
    END
    ELSE IF (@r_init % 6) = 2
    BEGIN
        SET @catEn_init = N'Medical Imaging & Radiology, Research & Education, Research Displays, Research';
        SET @catAr_init = N'التصوير الطبي والأشعة, البحث والتعليم, منصات عرض الأبحاث, أبحاث سريرية';
    END
    ELSE IF (@r_init % 6) = 3
    BEGIN
        SET @catEn_init = N'Health Innovation, Research & Education, Research Displays, Research';
        SET @catAr_init = N'الابتكار الصحي, البحث والتعليم, منصات عرض الأبحاث, أبحاث سريرية';
    END
    ELSE IF (@r_init % 6) = 4
    BEGIN
        SET @catEn_init = N'AI & Digital Technology, Medical Imaging & Radiology, Research Displays, New Technology';
        SET @catAr_init = N'الذكاء الاصطناعي والتقنية الرقمية, التصوير الطبي والأشعة, منصات عرض الأبحاث, تقنيات جديدة';
    END
    ELSE IF (@r_init % 6) = 5
    BEGIN
        SET @catEn_init = N'Healthcare Technology, Health Innovation, Research Displays, Healthcare Solutions';
        SET @catAr_init = N'تقنية الرعاية الصحية, الابتكار الصحي, منصات عرض الأبحاث, حلول الرعاية الصحية';
    END
    ELSE
    BEGIN
        SET @catEn_init = N'AI & Digital Technology, Research & Education, Research Displays, New Technology';
        SET @catAr_init = N'الذكاء الاصطناعي والتقنية الرقمية, البحث والتعليم, منصات عرض الأبحاث, تقنيات جديدة';
    END

    INSERT INTO [dbo].[Booths] ([BoothCode], [NameEn], [NameAr], [OrganizationEn], [OrganizationAr], [Type], [HallEn], [HallAr], [CategoriesEn], [CategoriesAr], [X], [Y])
    VALUES (
        'R' + CAST(@r_init AS VARCHAR(5)),
        N'Research Screen R' + CAST(@r_init AS NVARCHAR(5)),
        N'شاشة البحث R' + CAST(@r_init AS NVARCHAR(5)),
        N'Research Project ' + CAST(@r_init AS NVARCHAR(5)),
        N'مشروع بحثي ' + CAST(@r_init AS NVARCHAR(5)),
        'ResearchScreen',
        N'Research Screen Hall',
        N'قاعة العروض البحثية',
        @catEn_init,
        @catAr_init,
        @x_init,
        @y_init
    );

    SET @r_init = @r_init + 1;
END
GO



