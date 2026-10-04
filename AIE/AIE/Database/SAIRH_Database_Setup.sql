-- ============================================================================
-- SAIRH 2026 - Saudi 1st AI Summit in Radiology and Health Innovation
-- Database Creation & Schema Setup Script
-- Engine: Microsoft SQL Server 2019 / 2022
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

-- ----------------------------------------------------------------------------
-- 2. Lookup Table: Countries (for Registration & Profile forms)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[Countries]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Countries] (
        [CountryID]       INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [CountryCode]      VARCHAR(5) NOT NULL UNIQUE,
        [CountryNameEn]    NVARCHAR(100) NOT NULL,
        [CountryNameAr]    NVARCHAR(100) NOT NULL,
        [NationalityEn]    NVARCHAR(100) NOT NULL,
        [NationalityAr]    NVARCHAR(100) NOT NULL,
        [PathLocation]     NVARCHAR(255) NULL,
        [Sorting]          INT DEFAULT 99,
        [IsActive]         BIT DEFAULT 1
    );
END
GO

-- Compatibility view for existing ASP.NET controls expecting 'qryCountries'
IF OBJECT_ID(N'[dbo].[qryCountries]', N'V') IS NOT NULL
    DROP VIEW [dbo].[qryCountries];
GO

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
-- 3. Speakers & Faculty Table
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[Speakers]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Speakers] (
        [SpeakerID]         INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [FullNameEn]        NVARCHAR(150) NOT NULL,
        [FullNameAr]        NVARCHAR(150) NOT NULL,
        [JobTitleEn]        NVARCHAR(200) NULL,
        [JobTitleAr]        NVARCHAR(200) NULL,
        [OrganizationEn]    NVARCHAR(200) NULL,
        [OrganizationAr]    NVARCHAR(200) NULL,
        [BioEn]             NVARCHAR(MAX) NULL,
        [BioAr]             NVARCHAR(MAX) NULL,
        [Email]             VARCHAR(150) NULL,
        [Phone]             VARCHAR(50) NULL,
        [ImagePath]         NVARCHAR(500) DEFAULT '~/Content/images/speakers/default-speaker.png',
        [CvPdfPath]         NVARCHAR(500) NULL,
        [LinkedInUrl]       VARCHAR(300) NULL,
        [Category]          TINYINT DEFAULT 0,  -- 0: Keynote / International, 1: National / IAU
        [IsKeynote]         BIT DEFAULT 0,
        [Sorting]           INT DEFAULT 0,
        [IsActive]          BIT DEFAULT 1,
        [CreatedAt]         DATETIME DEFAULT GETDATE()
    );

    CREATE INDEX IX_Speakers_Category ON [dbo].[Speakers]([Category]);
    CREATE INDEX IX_Speakers_Sorting ON [dbo].[Speakers]([Sorting]);
END
GO

-- Compatibility view for existing legacy pages expecting 'Judges'
IF OBJECT_ID(N'[dbo].[Judges]', N'V') IS NOT NULL
    DROP VIEW [dbo].[Judges];
GO

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
    [Category],
    [Sorting]
FROM [dbo].[Speakers]
WHERE [IsActive] = 1;
GO

-- ----------------------------------------------------------------------------
-- 4. Sessions & Scientific Program Table
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[Sessions]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Sessions] (
        [SessionID]         INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [SpeakerID]         INT NULL,
        [TitleEn]           NVARCHAR(300) NOT NULL,
        [TitleAr]           NVARCHAR(300) NOT NULL,
        [DescriptionEn]     NVARCHAR(MAX) NULL,
        [DescriptionAr]     NVARCHAR(MAX) NULL,
        [TrackEn]           NVARCHAR(100) NULL,
        [TrackAr]           NVARCHAR(100) NULL,
        [RoomEn]            NVARCHAR(100) NULL,
        [RoomAr]            NVARCHAR(100) NULL,
        [StartDateTime]     DATETIME NOT NULL,
        [EndDateTime]       DATETIME NOT NULL,
        [DayNumber]         INT DEFAULT 1,
        [Sorting]           INT DEFAULT 0,
        [IsActive]          BIT DEFAULT 1,
        [CreatedAt]         DATETIME DEFAULT GETDATE(),

        -- Foreign Key constraint with graceful nulling on speaker deletion
        CONSTRAINT FK_Sessions_Speakers FOREIGN KEY ([SpeakerID]) 
            REFERENCES [dbo].[Speakers]([SpeakerID]) 
            ON DELETE SET NULL
            ON UPDATE CASCADE
    );

    CREATE INDEX IX_Sessions_SpeakerID ON [dbo].[Sessions]([SpeakerID]);
    CREATE INDEX IX_Sessions_Time ON [dbo].[Sessions]([StartDateTime], [EndDateTime]);
    CREATE INDEX IX_Sessions_Day ON [dbo].[Sessions]([DayNumber]);
END
GO

-- ----------------------------------------------------------------------------
-- 5. Attendees & Registration Pass Table
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[Attendees]', N'U') IS NULL
BEGIN
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

        CONSTRAINT FK_Attendees_Countries FOREIGN KEY ([CountryID])
            REFERENCES [dbo].[Countries]([CountryID])
            ON DELETE SET NULL
    );

    CREATE INDEX IX_Attendees_Email ON [dbo].[Attendees]([Email]);
    CREATE INDEX IX_Attendees_PassCode ON [dbo].[Attendees]([PassCode]);
END
GO

-- ----------------------------------------------------------------------------
-- 6. Contact Inquiries Table
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[ContactInquiries]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[ContactInquiries] (
        [InquiryID]         INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [FullName]          NVARCHAR(150) NOT NULL,
        [Email]             VARCHAR(100) NOT NULL,
        [MobileNo]          VARCHAR(25) NULL,
        [Message]           NVARCHAR(MAX) NOT NULL,
        [IsResolved]        BIT DEFAULT 0,
        [SubmittedAt]       DATETIME DEFAULT GETDATE()
    );
END
GO

-- Compatibility view for existing pages expecting 'qryApiContactUs'
IF OBJECT_ID(N'[dbo].[qryApiContactUs]', N'V') IS NOT NULL
    DROP VIEW [dbo].[qryApiContactUs];
GO

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
IF NOT EXISTS (SELECT 1 FROM [dbo].[Countries])
BEGIN
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
END
GO

-- Seed Speakers (Summit Faculty)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Speakers])
BEGIN
    SET IDENTITY_INSERT [dbo].[Speakers] ON;

    INSERT INTO [dbo].[Speakers] (
        [SpeakerID], [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], [Category], [IsKeynote], [Sorting]
    ) VALUES
    (1, N'Dr. Ahmed Al-Qahtani', N'د. أحمد القحطاني', N'Consultant Radiologist', N'استشاري أشعة', 
     N'Imam Abdulrahman Bin Faisal University', N'جامعة الإمام عبدالرحمن بن فيصل', 
     N'~/Content/images/speakers/default-speaker.png', N'~/Content/docs/speakers/dr-ahmed-alqahtani-cv.pdf', 0, 1, 1),

    (2, N'Dr. Sara Mohammed', N'د. سارة محمد', N'Assistant Professor of Artificial Intelligence', N'أستاذ مساعد في الذكاء الاصطناعي', 
     N'King Fahd University Hospital', N'مستشفى الملك فهد الجامعي', 
     N'~/Content/images/speakers/default-speaker.png', N'~/Content/docs/speakers/dr-sara-mohammed-cv.pdf', 0, 1, 2),

    (3, N'Dr. Reem Al-Harbi', N'د. ريم الحربي', N'Consultant Diagnostic Radiologist', N'استشارية أشعة تشخيصية', 
     N'King Fahd Specialist Hospital', N'مستشفى الملك فهد التخصصي', 
     N'~/Content/images/speakers/default-speaker.png', N'~/Content/docs/speakers/dr-reem-alharbi-cv.pdf', 1, 0, 3),

    (4, N'Dr. Fahad Al-Zahrani', N'د. فهد الزهراني', N'Medical Image Processing Researcher', N'باحث في معالجة الصور الطبية', 
     N'King Abdulaziz City for Science and Technology', N'مدينة الملك عبدالعزيز للعلوم والتقنية', 
     N'~/Content/images/speakers/default-speaker.png', N'~/Content/docs/speakers/dr-fahad-alzahrani-cv.pdf', 1, 0, 4),

    (5, N'Dr. Noura Al-Shehri', N'د. نورة الشهري', N'Health Informatics Consultant', N'استشارية معلوماتية صحية', 
     N'Saudi Data and AI Authority (SDAIA)', N'الهيئة السعودية للبيانات والذكاء الاصطناعي (سدايا)', 
     N'~/Content/images/speakers/default-speaker.png', N'~/Content/docs/speakers/dr-noura-alshehri-cv.pdf', 0, 1, 5),

    (6, N'Dr. Khalid Al-Dosari', N'د. خالد الدوسري', N'Consultant Neuro-Radiologist', N'استشاري أشعة الجهاز العصبي', 
     N'Dhahran Health Center', N'مركز الظهران الصحي', 
     N'~/Content/images/speakers/default-speaker.png', N'~/Content/docs/speakers/dr-khalid-aldosari-cv.pdf', 1, 0, 6),

    (7, N'Dr. Maha Al-Otaibi', N'د. مها العتيبي', N'Clinical AI Ethics Specialist', N'أخصائية أخلاقيات الذكاء الاصطناعي السريري', 
     N'Ministry of Health', N'وزارة الصحة', 
     N'~/Content/images/speakers/default-speaker.png', N'~/Content/docs/speakers/dr-maha-alotaibi-cv.pdf', 0, 0, 7),

    (8, N'Dr. Tariq Al-Ghamdi', N'د. طارق الغامدي', N'Healthcare Innovation Director', N'مدير الابتكار في الرعاية الصحية', 
     N'Imam Abdulrahman Bin Faisal University', N'جامعة الإمام عبدالرحمن بن فيصل', 
     N'~/Content/images/speakers/default-speaker.png', N'~/Content/docs/speakers/dr-tariq-alghamdi-cv.pdf', 1, 0, 8);

    SET IDENTITY_INSERT [dbo].[Speakers] OFF;
END
GO

-- Seed Sessions (Summit Agenda)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Sessions])
BEGIN
    SET IDENTITY_INSERT [dbo].[Sessions] ON;

    INSERT INTO [dbo].[Sessions] (
        [SessionID], [SpeakerID], [TitleEn], [TitleAr], [TrackEn], [TrackAr], 
        [RoomEn], [RoomAr], [StartDateTime], [EndDateTime], [DayNumber], [Sorting]
    ) VALUES
    (1, 1, N'Artificial Intelligence in Diagnostic Radiology', N'الذكاء الاصطناعي في الأشعة التشخيصية', 
     N'Diagnostic AI Track', N'مسار الذكاء الاصطناعي التشخيصي', N'Main Hall', N'القاعة الرئيسية', 
     '2026-12-13 07:00:00', '2026-12-13 07:45:00', 1, 1),

    (2, 2, N'Deep Learning Applications in Medical Imaging', N'تطبيقات التعلم العميق في التصوير الطبي', 
     N'Deep Learning Track', N'مسار التعلم العميق', N'Hall B', N'القاعة ب', 
     '2026-12-13 08:00:00', '2026-12-13 08:45:00', 1, 2),

    (3, 3, N'Generative AI in Radiology Reporting', N'الذكاء الاصطناعي التوليدي في تقارير الأشعة', 
     N'Generative AI Track', N'مسار الذكاء الاصطناعي التوليدي', N'Hall C', N'القاعة ج', 
     '2026-12-13 09:00:00', '2026-12-13 09:50:00', 1, 3),

    (4, 4, N'AI-Based Enhancement of Radiology Images', N'تحسين جودة صور الأشعة باستخدام الذكاء الاصطناعي', 
     N'Image Enhancement Track', N'مسار تحسين الصور الطبية', N'Hall D', N'القاعة د', 
     '2026-12-13 10:15:00', '2026-12-13 11:00:00', 1, 4),

    (5, 5, N'Regulatory Governance & Ethics of AI in Healthcare', N'الحوكمة التنظيمية وأخلاقيات الذكاء الاصطناعي في الصحة', 
     N'Governance Track', N'مسار الحوكمة والسياسات', N'Main Hall', N'القاعة الرئيسية', 
     '2026-12-13 11:30:00', '2026-12-13 12:15:00', 1, 5),

    (6, 6, N'Automated Brain MRI Lesion Detection via AI', N'الكشف الآلي عن آفات الرنين المغناطيسي للمخ عبر الذكاء الاصطناعي', 
     N'Neuro-Imaging Track', N'مسار التصوير العصبي المتقدم', N'Hall B', N'القاعة ب', 
     '2026-12-13 13:00:00', '2026-12-13 13:50:00', 1, 6),

    (7, 7, N'Safety Protocols & Clinical AI Validation', N'معايير الأمان والتحقق السريري للذكاء الاصطناعي', 
     N'Clinical Validation Track', N'مسار التحقق السريري', N'Hall C', N'القاعة ج', 
     '2026-12-13 14:15:00', '2026-12-13 15:00:00', 1, 7),

    (8, 8, N'Future Horizons: AI-Driven Health Innovation 2030', N'آفاق المستقبل: الابتكار الصحي المدعوم بالذكاء الاصطناعي 2030', 
     N'Health Innovation Track', N'مسار الابتكار الصحي', N'Main Hall', N'القاعة الرئيسية', 
     '2026-12-13 16:00:00', '2026-12-13 16:45:00', 1, 8);

    SET IDENTITY_INSERT [dbo].[Sessions] OFF;
END
GO
