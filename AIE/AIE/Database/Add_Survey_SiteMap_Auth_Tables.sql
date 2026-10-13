-- ============================================================================
-- SAIRH 2026 - Migration Script: Survey, SiteMap Exhibition Floor, and Password Reset
-- Engine: Microsoft SQL Server 2019 / 2022 / Azure SQL
-- ============================================================================

USE [SAIRH];
GO

-- ----------------------------------------------------------------------------
-- 1. Ensure HasCompletedSurvey column exists on dbo.Attendees
-- ----------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[Attendees]') 
      AND name = N'HasCompletedSurvey'
)
BEGIN
    ALTER TABLE [dbo].[Attendees] 
    ADD [HasCompletedSurvey] BIT NOT NULL CONSTRAINT DF_Attendees_HasCompletedSurvey DEFAULT 0;
    PRINT N'[+] Added column [HasCompletedSurvey] to dbo.Attendees';
END
GO

-- ----------------------------------------------------------------------------
-- 2. Create dbo.PasswordResetTokens Table
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[PasswordResetTokens]', N'U') IS NULL
BEGIN
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
    PRINT N'[+] Created table dbo.PasswordResetTokens';
END
GO

-- ----------------------------------------------------------------------------
-- 3. Create dbo.Booths Table (Sponsor Booths & Research Screens)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[Booths]', N'U') IS NULL
BEGIN
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
    PRINT N'[+] Created table dbo.Booths';
END
GO

-- ----------------------------------------------------------------------------
-- 4. Create dbo.SurveyResponses Table
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[SurveyResponses]', N'U') IS NULL
BEGIN
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
    PRINT N'[+] Created table dbo.SurveyResponses';
END
GO

-- ----------------------------------------------------------------------------
-- 5. Create dbo.BoothVisits Table (NFC Tap & Check-in Scans)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[BoothVisits]', N'U') IS NULL
BEGIN
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
    PRINT N'[+] Created table dbo.BoothVisits';
END
GO

-- ----------------------------------------------------------------------------
-- 6. Seed All 15 Sponsor Booths & 30 Research Screens into dbo.Booths
-- ----------------------------------------------------------------------------
IF (SELECT COUNT(*) FROM [dbo].[Booths]) = 0
BEGIN
    PRINT N'[*] Seeding 15 Sponsor Booths (S1 to S15)...';
    
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

    PRINT N'[*] Seeding 30 Research Screens (R1 to R30)...';
    
    -- Coordinates from floor layout:
    -- Top row R1 to R12: x: 90, 140, 190, 240, 290, 340, 390, 440, 490, 540, 590, 640; y: 35
    -- Left col R13 to R18: x: 35; y: 70, 98, 126, 154, 182, 210
    -- Bottom row R19 to R30: x: 90, 140, 190, 240, 290, 340, 390, 440, 490, 540, 590, 640; y: 220
    
    DECLARE @r INT = 1;
    DECLARE @x INT, @y INT;
    DECLARE @catEn NVARCHAR(500), @catAr NVARCHAR(500);

    WHILE @r <= 30
    BEGIN
        IF @r <= 12
        BEGIN
            SET @x = 90 + (@r - 1) * 50;
            SET @y = 35;
        END
        ELSE IF @r <= 18
        BEGIN
            SET @x = 35;
            SET @y = 70 + (@r - 13) * 28;
        END
        ELSE
        BEGIN
            SET @x = 90 + (@r - 19) * 50;
            SET @y = 220;
        END

        IF (@r % 6) = 1
        BEGIN
            SET @catEn = N'AI & Digital Technology, Research & Education, Research Displays, Research';
            SET @catAr = N'الذكاء الاصطناعي والتقنية الرقمية, البحث والتعليم, منصات عرض الأبحاث, أبحاث سريرية';
        END
        ELSE IF (@r % 6) = 2
        BEGIN
            SET @catEn = N'Medical Imaging & Radiology, Research & Education, Research Displays, Research';
            SET @catAr = N'التصوير الطبي والأشعة, البحث والتعليم, منصات عرض الأبحاث, أبحاث سريرية';
        END
        ELSE IF (@r % 6) = 3
        BEGIN
            SET @catEn = N'Health Innovation, Research & Education, Research Displays, Research';
            SET @catAr = N'الابتكار الصحي, البحث والتعليم, منصات عرض الأبحاث, أبحاث سريرية';
        END
        ELSE IF (@r % 6) = 4
        BEGIN
            SET @catEn = N'AI & Digital Technology, Medical Imaging & Radiology, Research Displays, New Technology';
            SET @catAr = N'الذكاء الاصطناعي والتقنية الرقمية, التصوير الطبي والأشعة, منصات عرض الأبحاث, تقنيات جديدة';
        END
        ELSE IF (@r % 6) = 5
        BEGIN
            SET @catEn = N'Healthcare Technology, Health Innovation, Research Displays, Healthcare Solutions';
            SET @catAr = N'تقنية الرعاية الصحية, الابتكار الصحي, منصات عرض الأبحاث, حلول الرعاية الصحية';
        END
        ELSE
        BEGIN
            SET @catEn = N'AI & Digital Technology, Research & Education, Research Displays, New Technology';
            SET @catAr = N'الذكاء الاصطناعي والتقنية الرقمية, البحث والتعليم, منصات عرض الأبحاث, تقنيات جديدة';
        END

        INSERT INTO [dbo].[Booths] ([BoothCode], [NameEn], [NameAr], [OrganizationEn], [OrganizationAr], [Type], [HallEn], [HallAr], [CategoriesEn], [CategoriesAr], [X], [Y])
        VALUES (
            'R' + CAST(@r AS VARCHAR(5)),
            N'Research Screen R' + CAST(@r AS NVARCHAR(5)),
            N'شاشة البحث R' + CAST(@r AS NVARCHAR(5)),
            N'Research Project ' + CAST(@r AS NVARCHAR(5)),
            N'مشروع بحثي ' + CAST(@r AS NVARCHAR(5)),
            'ResearchScreen',
            N'Research Screen Hall',
            N'قاعة العروض البحثية',
            @catEn,
            @catAr,
            @x,
            @y
        );

        SET @r = @r + 1;
    END

    PRINT N'[SUCCESS] Seeded 15 Sponsor Booths and 30 Research Screens successfully!';
END
GO
