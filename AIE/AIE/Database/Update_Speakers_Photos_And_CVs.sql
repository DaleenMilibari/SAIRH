-- ============================================================================
-- SAIRH 2026 - Official Normalized Database Setup: Speakers & Sessions
-- Database: SAIRH
-- noinspection SqlResolve
-- noinspection SqlInsertValues
-- Structure:
--   1. [dbo].[Speakers] - Speaker profile information only
--   2. [dbo].[Sessions] - Scientific sessions with Foreign Key (SpeakerID),
--                         title, room, track, day, time, and speaker role.
--   3. [dbo].[vw_SummitSpeakers] - Comprehensive VIEW joining Speakers & Sessions
-- ============================================================================

USE [SAIRH];
GO

-- 1. Drop existing views and tables if they exist (Clean Start)
IF OBJECT_ID(N'[dbo].[vw_SummitSpeakers]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_SummitSpeakers];
IF OBJECT_ID(N'[dbo].[Judges]', N'V') IS NOT NULL DROP VIEW [dbo].[Judges];
GO

-- Drop any foreign key constraints pointing to Speakers
DECLARE @sqlFK NVARCHAR(MAX) = N'';
SELECT @sqlFK += N'ALTER TABLE ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name) 
               + N' DROP CONSTRAINT ' + QUOTENAME(f.name) + N';' + CHAR(13)
FROM sys.foreign_keys f
INNER JOIN sys.tables t ON f.parent_object_id = t.object_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE f.referenced_object_id = OBJECT_ID(N'[dbo].[Speakers]');
IF @sqlFK <> N'' EXEC sp_executesql @sqlFK;
GO

IF OBJECT_ID(N'[dbo].[Sessions]', N'U') IS NOT NULL DROP TABLE [dbo].[Sessions];
IF OBJECT_ID(N'[dbo].[Speakers]', N'U') IS NOT NULL DROP TABLE [dbo].[Speakers];
GO

-- 2. Create [dbo].[Speakers] Table (Profile data only)
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

-- 3. Create [dbo].[Sessions] Table (Session metadata with Foreign Key to Speaker)
CREATE TABLE [dbo].[Sessions] (
    [SessionID]         INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [SpeakerID]         INT NULL,                               -- Foreign Key to [dbo].[Speakers]
    [TitleEn]           NVARCHAR(500) NOT NULL,                 -- عنوان الجلسة بالإنجليزية
    [TitleAr]           NVARCHAR(500) NOT NULL,                 -- عنوان الجلسة بالعربية
    [Track]             NVARCHAR(50) NOT NULL DEFAULT 'track-a', -- المسار (track-a, track-b, track-c)
    [TrackNameEn]       NVARCHAR(200) NULL,
    [TrackNameAr]       NVARCHAR(200) NULL,
    [RoomEn]            NVARCHAR(100) NOT NULL,                 -- القاعة (Hall 1, Hall 2, Hall 3)
    [RoomAr]            NVARCHAR(100) NOT NULL,                 -- القاعة الأولى، الثانية، الثالثة
    [DayNumber]         INT NOT NULL DEFAULT 1,                 -- اليوم (اليوم الأول، إلخ)
    [StartTime]         VARCHAR(20) NULL DEFAULT '09:00 AM',    -- وقت البدء (مثال: 09:00 AM)
    [EndTime]           VARCHAR(20) NULL DEFAULT '09:40 AM',    -- وقت الانتهاء (مثال: 09:40 AM)
    [StartDateTime]     DATETIME NULL DEFAULT '2026-12-13 09:00:00', -- تاريخ ووقت البدء الفعلي
    [EndDateTime]       DATETIME NULL DEFAULT '2026-12-13 09:40:00', -- تاريخ ووقت الانتهاء الفعلي
    [RoleEn]            NVARCHAR(100) NOT NULL DEFAULT 'Speaker',-- الدور (Keynote Speaker, Speaker, ...)
    [RoleAr]            NVARCHAR(100) NOT NULL DEFAULT N'متحدث',  -- الدور بالعربية (متحدث رئيسي، متحدث، ...)
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

-- 4. Create [dbo].[vw_SummitSpeakers] VIEW joining Speakers with Sessions
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

-- 7. Verification Queries
SELECT Track, COUNT(*) AS TotalSpeakers FROM [dbo].[vw_SummitSpeakers] GROUP BY Track ORDER BY Track;
SELECT SpeakerID, FullNameEn, LectureTitleEn, RoomEn, StartTime, EndTime, SessionRoleEn FROM [dbo].[vw_SummitSpeakers] ORDER BY SpeakerID;
GO
