-- ============================================================================
-- SAIRH 2026 - Speaker Photos & CVs Mapping Script
-- Database: SAIRH
-- Updates existing speakers or inserts full profile with photos and CVs
-- ============================================================================

USE [SAIRH];
GO

-- Set IDENTITY_INSERT ON in case we insert new speakers
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- 1. Dr. Fahad Almsned (د. فهد المسند)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Almsned%' OR [FullNameAr] LIKE '%المسند%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Fahad Almsned',
        [FullNameAr] = N'د. فهد المسند',
        [JobTitleEn] = N'Director of Research Operations',
        [JobTitleAr] = N'مدير العمليات البحثية',
        [OrganizationEn] = N'King Fahad Specialist Hospital - Dammam',
        [OrganizationAr] = N'مستشفى الملك فهد التخصصي - الدمام',
        [ImagePath] = N'~/Content/images/speakers/Fahad-Almsned-Photo.jpeg',
        [CvPdfPath] = N'~/Content/docs/speakers/Fahad-Almsned-CV.pdf',
        [Category] = 0,
        [Sorting] = 1,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Almsned%' OR [FullNameAr] LIKE '%المسند%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Fahad Almsned', N'د. فهد المسند', N'Director of Research Operations', N'مدير العمليات البحثية', 
        N'King Fahad Specialist Hospital - Dammam', N'مستشفى الملك فهد التخصصي - الدمام', N'~/Content/images/speakers/Fahad-Almsned-Photo.jpeg', N'~/Content/docs/speakers/Fahad-Almsned-CV.pdf', 
        0, 1, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 2. Dr. Eman Alshehri (د. إيمان الشهري)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Alshehri%' OR [FullNameAr] LIKE '%الشهري%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Eman Alshehri',
        [FullNameAr] = N'د. إيمان الشهري',
        [JobTitleEn] = N'Assistant Professor, Computer Department',
        [JobTitleAr] = N'أستاذ مساعد، قسم الحاسب الآلي',
        [OrganizationEn] = N'Imam Abdulrahman Bin Faisal University',
        [OrganizationAr] = N'جامعة الإمام عبدالرحمن بن فيصل',
        [ImagePath] = N'~/Content/images/speakers/Speaker-Photo.png',
        [CvPdfPath] = N'~/Content/docs/speakers/Eman-Alshehri-CV.pdf',
        [Category] = 1,
        [Sorting] = 2,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Alshehri%' OR [FullNameAr] LIKE '%الشهري%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Eman Alshehri', N'د. إيمان الشهري', N'Assistant Professor, Computer Department', N'أستاذ مساعد، قسم الحاسب الآلي', 
        N'Imam Abdulrahman Bin Faisal University', N'جامعة الإمام عبدالرحمن بن فيصل', N'~/Content/images/speakers/Speaker-Photo.png', N'~/Content/docs/speakers/Eman-Alshehri-CV.pdf', 
        1, 2, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 3. Ms. Fadwa AlBawardi, MSc (أ. فدوى البواردي)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%MSc%' OR [FullNameAr] LIKE '%البواردي%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Ms. Fadwa AlBawardi, MSc',
        [FullNameAr] = N'أ. فدوى البواردي',
        [JobTitleEn] = N'Founder & CEO',
        [JobTitleAr] = N'المؤسس والرئيس التنفيذي',
        [OrganizationEn] = N'FSK Advisory',
        [OrganizationAr] = N'استشارات FSK',
        [ImagePath] = N'~/Content/images/speakers/Fadwa-AlBawardi-Photo.jpg',
        [CvPdfPath] = N'~/Content/docs/speakers/Fadwa-AlBawardi-CV.pdf',
        [Category] = 0,
        [Sorting] = 3,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%MSc%' OR [FullNameAr] LIKE '%البواردي%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Ms. Fadwa AlBawardi, MSc', N'أ. فدوى البواردي', N'Founder & CEO', N'المؤسس والرئيس التنفيذي', 
        N'FSK Advisory', N'استشارات FSK', N'~/Content/images/speakers/Fadwa-AlBawardi-Photo.jpg', N'~/Content/docs/speakers/Fadwa-AlBawardi-CV.pdf', 
        0, 3, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 4. Dr. Aseel Aldawood (د. أصيل الداوود)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Aldawood%' OR [FullNameAr] LIKE '%الداوود%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Aseel Aldawood',
        [FullNameAr] = N'د. أصيل الداوود',
        [JobTitleEn] = N'Assistant Professor of Health Informatics',
        [JobTitleAr] = N'أستاذ مساعد في المعلوماتية الصحية',
        [OrganizationEn] = N'King Saud University',
        [OrganizationAr] = N'جامعة الملك سعود',
        [ImagePath] = N'~/Content/images/speakers/Speaker-Photo.png',
        [CvPdfPath] = N'~/Content/docs/speakers/Aseel-Addawood-CV.pdf',
        [Category] = 0,
        [Sorting] = 4,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Aldawood%' OR [FullNameAr] LIKE '%الداوود%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Aseel Aldawood', N'د. أصيل الداوود', N'Assistant Professor of Health Informatics', N'أستاذ مساعد في المعلوماتية الصحية', 
        N'King Saud University', N'جامعة الملك سعود', N'~/Content/images/speakers/Speaker-Photo.png', N'~/Content/docs/speakers/Aseel-Addawood-CV.pdf', 
        0, 4, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 5. Dr. Mustafa Yoldash (د. مصطفى يلدش)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Yoldash%' OR [FullNameAr] LIKE '%يلدش%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Mustafa Yoldash',
        [FullNameAr] = N'د. مصطفى يلدش',
        [JobTitleEn] = N'Consultant Clinical Radiologist',
        [JobTitleAr] = N'استشاري الأشعة الإكلينيكية',
        [OrganizationEn] = N'King Fahad Hospital',
        [OrganizationAr] = N'مستشفى الملك فهد',
        [ImagePath] = N'~/Content/images/speakers/Speaker-Photo.png',
        [CvPdfPath] = N'~/Content/docs/speakers/Mustafa-Yoldash-CV.pdf',
        [Category] = 0,
        [Sorting] = 5,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Yoldash%' OR [FullNameAr] LIKE '%يلدش%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Mustafa Yoldash', N'د. مصطفى يلدش', N'Consultant Clinical Radiologist', N'استشاري الأشعة الإكلينيكية', 
        N'King Fahad Hospital', N'مستشفى الملك فهد', N'~/Content/images/speakers/Speaker-Photo.png', N'~/Content/docs/speakers/Mustafa-Yoldash-CV.pdf', 
        0, 5, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 6. Mr. Yazeed Alsudays, MBA (أ. يزيد السديس)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%MBA%' OR [FullNameAr] LIKE '%السديس%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Mr. Yazeed Alsudays, MBA',
        [FullNameAr] = N'أ. يزيد السديس',
        [JobTitleEn] = N'Healthcare AI Strategy Consultant',
        [JobTitleAr] = N'مستشار استراتيجيات الذكاء الاصطناعي الصحي',
        [OrganizationEn] = N'Digital Health Center of Excellence',
        [OrganizationAr] = N'مركز التميز للصحة الرقمية',
        [ImagePath] = N'~/Content/images/speakers/Yazeed-Alsudays-Photo.jpg',
        [CvPdfPath] = N'~/Content/docs/speakers/Yazeed-Alsudays-CV.pdf',
        [Category] = 0,
        [Sorting] = 6,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%MBA%' OR [FullNameAr] LIKE '%السديس%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Mr. Yazeed Alsudays, MBA', N'أ. يزيد السديس', N'Healthcare AI Strategy Consultant', N'مستشار استراتيجيات الذكاء الاصطناعي الصحي', 
        N'Digital Health Center of Excellence', N'مركز التميز للصحة الرقمية', N'~/Content/images/speakers/Yazeed-Alsudays-Photo.jpg', N'~/Content/docs/speakers/Yazeed-Alsudays-CV.pdf', 
        0, 6, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 7. Dr. Abeer Alalmaie (د. عبير الألمعي)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Alalmaie%' OR [FullNameAr] LIKE '%الألمعي%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Abeer Alalmaie',
        [FullNameAr] = N'د. عبير الألمعي',
        [JobTitleEn] = N'Consultant Radiologist & Breast Imaging Lead',
        [JobTitleAr] = N'استشارية أشعة ورئيسة تصوير الثدي',
        [OrganizationEn] = N'King Faisal Specialist Hospital & Research Centre',
        [OrganizationAr] = N'مستشفى الملك فيصل التخصصي ومركز الأبحاث',
        [ImagePath] = N'~/Content/images/speakers/Abeer-Alalmaie-Photo.png',
        [CvPdfPath] = N'~/Content/docs/speakers/Abeer-Alalmaie-CV.pdf',
        [Category] = 0,
        [Sorting] = 7,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Alalmaie%' OR [FullNameAr] LIKE '%الألمعي%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Abeer Alalmaie', N'د. عبير الألمعي', N'Consultant Radiologist & Breast Imaging Lead', N'استشارية أشعة ورئيسة تصوير الثدي', 
        N'King Faisal Specialist Hospital & Research Centre', N'مستشفى الملك فيصل التخصصي ومركز الأبحاث', N'~/Content/images/speakers/Abeer-Alalmaie-Photo.png', N'~/Content/docs/speakers/Abeer-Alalmaie-CV.pdf', 
        0, 7, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 8. Dr. Clare Rainey (د. كلير ريني)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Rainey%' OR [FullNameAr] LIKE '%ريني%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Clare Rainey',
        [FullNameAr] = N'د. كلير ريني',
        [JobTitleEn] = N'Lecturer in Radiography & Health Sciences',
        [JobTitleAr] = N'محاضرة في علوم الأشعة والعلوم الصحية',
        [OrganizationEn] = N'Ulster University',
        [OrganizationAr] = N'جامعة أولستر',
        [ImagePath] = N'~/Content/images/speakers/Clare-Rainey-Photo.jpg.png',
        [CvPdfPath] = N'~/Content/docs/speakers/Clare-Rainey-CV.pdf',
        [Category] = 0,
        [Sorting] = 8,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Rainey%' OR [FullNameAr] LIKE '%ريني%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Clare Rainey', N'د. كلير ريني', N'Lecturer in Radiography & Health Sciences', N'محاضرة في علوم الأشعة والعلوم الصحية', 
        N'Ulster University', N'جامعة أولستر', N'~/Content/images/speakers/Clare-Rainey-Photo.jpg.png', N'~/Content/docs/speakers/Clare-Rainey-CV.pdf', 
        0, 8, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 9. Dr. Rebecca Vaz (د. ريبيكا فاز)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Vaz%' OR [FullNameAr] LIKE '%فاز%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Rebecca Vaz',
        [FullNameAr] = N'د. ريبيكا فاز',
        [JobTitleEn] = N'Senior Medical Imaging Specialist',
        [JobTitleAr] = N'أخصائية أولى في التصوير الطبي',
        [OrganizationEn] = N'Health Innovation Network',
        [OrganizationAr] = N'شبكة الابتكار الصحي',
        [ImagePath] = N'~/Content/images/speakers/Rebeca-Queiroz-Photo.JPG',
        [CvPdfPath] = N'~/Content/docs/speakers/Rebeca-Queiroz-CV.pdf',
        [Category] = 0,
        [Sorting] = 9,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Vaz%' OR [FullNameAr] LIKE '%فاز%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Rebecca Vaz', N'د. ريبيكا فاز', N'Senior Medical Imaging Specialist', N'أخصائية أولى في التصوير الطبي', 
        N'Health Innovation Network', N'شبكة الابتكار الصحي', N'~/Content/images/speakers/Rebeca-Queiroz-Photo.JPG', N'~/Content/docs/speakers/Rebeca-Queiroz-CV.pdf', 
        0, 9, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 10. Dr. Amna Kashgari (د. آمنة كاشغري)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Kashgari%' OR [FullNameAr] LIKE '%كاشغري%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Amna Kashgari',
        [FullNameAr] = N'د. آمنة كاشغري',
        [JobTitleEn] = N'Consultant Radiologist & Neuroradiology Fellow',
        [JobTitleAr] = N'استشارية أشعة وزميلة أشعة الأعصاب',
        [OrganizationEn] = N'Ministry of National Guard - Health Affairs',
        [OrganizationAr] = N'الشؤون الصحية بوزارة الحرس الوطني',
        [ImagePath] = N'~/Content/images/speakers/Amna-Kashgari-Photo.jpg',
        [CvPdfPath] = N'~/Content/docs/speakers/Amna-Kashgari-CV.pdf',
        [Category] = 0,
        [Sorting] = 10,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Kashgari%' OR [FullNameAr] LIKE '%كاشغري%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Amna Kashgari', N'د. آمنة كاشغري', N'Consultant Radiologist & Neuroradiology Fellow', N'استشارية أشعة وزميلة أشعة الأعصاب', 
        N'Ministry of National Guard - Health Affairs', N'الشؤون الصحية بوزارة الحرس الوطني', N'~/Content/images/speakers/Amna-Kashgari-Photo.jpg', N'~/Content/docs/speakers/Amna-Kashgari-CV.pdf', 
        0, 10, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 11. Prof. Karen Knapp (بروفيسور كارين ناب)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Knapp%' OR [FullNameAr] LIKE '%ناب%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Prof. Karen Knapp',
        [FullNameAr] = N'بروفيسور كارين ناب',
        [JobTitleEn] = N'Professor of Musculoskeletal Imaging',
        [JobTitleAr] = N'أستاذة تصوير الجهاز العضلي الهيكلي',
        [OrganizationEn] = N'University of Exeter',
        [OrganizationAr] = N'جامعة إكستر',
        [ImagePath] = N'~/Content/images/speakers/Karen-Knapp-Photo.jpg',
        [CvPdfPath] = N'~/Content/docs/speakers/Karen-Knapp-CV.pdf',
        [Category] = 0,
        [Sorting] = 11,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Knapp%' OR [FullNameAr] LIKE '%ناب%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Prof. Karen Knapp', N'بروفيسور كارين ناب', N'Professor of Musculoskeletal Imaging', N'أستاذة تصوير الجهاز العضلي الهيكلي', 
        N'University of Exeter', N'جامعة إكستر', N'~/Content/images/speakers/Karen-Knapp-Photo.jpg', N'~/Content/docs/speakers/Karen-Knapp-CV.pdf', 
        0, 11, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 12. Dr. Mohammed Asiri (د. محمد عسيري)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Asiri%' OR [FullNameAr] LIKE '%عسيري%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Mohammed Asiri',
        [FullNameAr] = N'د. محمد عسيري',
        [JobTitleEn] = N'Consultant Clinical Radiologist',
        [JobTitleAr] = N'استشاري أشعة سريرية',
        [OrganizationEn] = N'Armed Forces Hospitals Southern Region',
        [OrganizationAr] = N'مستشفيات القوات المسلحة بالمنطقة الجنوبية',
        [ImagePath] = N'~/Content/images/speakers/Mohammed-Asiri-Photo.jpeg',
        [CvPdfPath] = N'~/Content/docs/speakers/Mohammed-Asiri-CV.pdf',
        [Category] = 0,
        [Sorting] = 12,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Asiri%' OR [FullNameAr] LIKE '%عسيري%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Mohammed Asiri', N'د. محمد عسيري', N'Consultant Clinical Radiologist', N'استشاري أشعة سريرية', 
        N'Armed Forces Hospitals Southern Region', N'مستشفيات القوات المسلحة بالمنطقة الجنوبية', N'~/Content/images/speakers/Mohammed-Asiri-Photo.jpeg', N'~/Content/docs/speakers/Mohammed-Asiri-CV.pdf', 
        0, 12, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 13. Dr. Yasser Hadi (د. ياسر هادي)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Hadi%' OR [FullNameAr] LIKE '%هادي%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Yasser Hadi',
        [FullNameAr] = N'د. ياسر هادي',
        [JobTitleEn] = N'Consultant Diagnostic Radiologist',
        [JobTitleAr] = N'استشاري أشعة تشخيصية',
        [OrganizationEn] = N'Jazan University',
        [OrganizationAr] = N'جامعة جازان',
        [ImagePath] = N'~/Content/images/speakers/Yasser-Hadi-Photo.JPG',
        [CvPdfPath] = N'~/Content/docs/speakers/Yasser-Hadi.pdf',
        [Category] = 0,
        [Sorting] = 13,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Hadi%' OR [FullNameAr] LIKE '%هادي%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Yasser Hadi', N'د. ياسر هادي', N'Consultant Diagnostic Radiologist', N'استشاري أشعة تشخيصية', 
        N'Jazan University', N'جامعة جازان', N'~/Content/images/speakers/Yasser-Hadi-Photo.JPG', N'~/Content/docs/speakers/Yasser-Hadi.pdf', 
        0, 13, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 14. Dr. Abdulkarem Alqahtani (د. عبدالكريم القحطاني)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Alqahtani%' OR [FullNameAr] LIKE '%القحطاني%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Abdulkarem Alqahtani',
        [FullNameAr] = N'د. عبدالكريم القحطاني',
        [JobTitleEn] = N'Consultant Diagnostic & Interventional Radiologist',
        [JobTitleAr] = N'استشاري أشعة تشخيصية وتداخلية',
        [OrganizationEn] = N'King Fahad Specialist Hospital - Dammam',
        [OrganizationAr] = N'مستشفى الملك فهد التخصصي - الدمام',
        [ImagePath] = N'~/Content/images/speakers/Abdulkareem-Alqahtani-Photo.jpeg',
        [CvPdfPath] = N'~/Content/docs/speakers/Abdulkareem-Alqahtani-CV.pdf',
        [Category] = 0,
        [Sorting] = 14,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Alqahtani%' OR [FullNameAr] LIKE '%القحطاني%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Abdulkarem Alqahtani', N'د. عبدالكريم القحطاني', N'Consultant Diagnostic & Interventional Radiologist', N'استشاري أشعة تشخيصية وتداخلية', 
        N'King Fahad Specialist Hospital - Dammam', N'مستشفى الملك فهد التخصصي - الدمام', N'~/Content/images/speakers/Abdulkareem-Alqahtani-Photo.jpeg', N'~/Content/docs/speakers/Abdulkareem-Alqahtani-CV.pdf', 
        0, 14, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 15. Dr. Abdulaziz Almulhim (د. عبدالعزيز الملحم)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Almulhim%' OR [FullNameAr] LIKE '%الملحم%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Abdulaziz Almulhim',
        [FullNameAr] = N'د. عبدالعزيز الملحم',
        [JobTitleEn] = N'Consultant Pediatric Radiologist',
        [JobTitleAr] = N'استشاري أشعة الأطفال',
        [OrganizationEn] = N'King Fahad Medical City',
        [OrganizationAr] = N'مدينة الملك فهد الطبية',
        [ImagePath] = N'~/Content/images/speakers/Abdulaziz-Almulhim-Photo.png',
        [CvPdfPath] = N'~/Content/docs/speakers/Abdulaziz-AlMulhim-CV.pdf',
        [Category] = 0,
        [Sorting] = 15,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Almulhim%' OR [FullNameAr] LIKE '%الملحم%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Abdulaziz Almulhim', N'د. عبدالعزيز الملحم', N'Consultant Pediatric Radiologist', N'استشاري أشعة الأطفال', 
        N'King Fahad Medical City', N'مدينة الملك فهد الطبية', N'~/Content/images/speakers/Abdulaziz-Almulhim-Photo.png', N'~/Content/docs/speakers/Abdulaziz-AlMulhim-CV.pdf', 
        0, 15, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 16. Dr. Sonyia McFadden (د. سونيا مكفادين)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%McFadden%' OR [FullNameAr] LIKE '%مكفادين%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Sonyia McFadden',
        [FullNameAr] = N'د. سونيا مكفادين',
        [JobTitleEn] = N'Reader in Diagnostic Radiography',
        [JobTitleAr] = N'قارئة في الأشعة التشخيصية',
        [OrganizationEn] = N'Ulster University',
        [OrganizationAr] = N'جامعة أولستر',
        [ImagePath] = N'~/Content/images/speakers/Sonyia-McFadden-Photo.jpg',
        [CvPdfPath] = N'~/Content/docs/speakers/Sonyia-McFadden-CV.pdf',
        [Category] = 0,
        [Sorting] = 16,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%McFadden%' OR [FullNameAr] LIKE '%مكفادين%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Sonyia McFadden', N'د. سونيا مكفادين', N'Reader in Diagnostic Radiography', N'قارئة في الأشعة التشخيصية', 
        N'Ulster University', N'جامعة أولستر', N'~/Content/images/speakers/Sonyia-McFadden-Photo.jpg', N'~/Content/docs/speakers/Sonyia-McFadden-CV.pdf', 
        0, 16, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 17. Dr. Raid Alshinibr (د. رائد الشنيبر)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Alshinibr%' OR [FullNameAr] LIKE '%الشنيبر%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Raid Alshinibr',
        [FullNameAr] = N'د. رائد الشنيبر',
        [JobTitleEn] = N'Director of Healthcare Innovation',
        [JobTitleAr] = N'مدير الابتكار في الرعاية الصحية',
        [OrganizationEn] = N'National Center for Health Information (NHIC)',
        [OrganizationAr] = N'المركز الوطني للمعلومات الصحية',
        [ImagePath] = N'~/Content/images/speakers/Raid-Alshinibr-Photo.png',
        [CvPdfPath] = N'~/Content/docs/speakers/Raid-Alshinibr-CV.pdf',
        [Category] = 0,
        [Sorting] = 17,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Alshinibr%' OR [FullNameAr] LIKE '%الشنيبر%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Raid Alshinibr', N'د. رائد الشنيبر', N'Director of Healthcare Innovation', N'مدير الابتكار في الرعاية الصحية', 
        N'National Center for Health Information (NHIC)', N'المركز الوطني للمعلومات الصحية', N'~/Content/images/speakers/Raid-Alshinibr-Photo.png', N'~/Content/docs/speakers/Raid-Alshinibr-CV.pdf', 
        0, 17, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 18. Prof. Minyar Sassi (بروفيسور منيار ساسي)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Sassi%' OR [FullNameAr] LIKE '%ساسي%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Prof. Minyar Sassi',
        [FullNameAr] = N'بروفيسور منيار ساسي',
        [JobTitleEn] = N'Professor of AI in Medical Imaging',
        [JobTitleAr] = N'أستاذ الذكاء الاصطناعي في التصوير الطبي',
        [OrganizationEn] = N'Imam Abdulrahman Bin Faisal University',
        [OrganizationAr] = N'جامعة الإمام عبدالرحمن بن فيصل',
        [ImagePath] = N'~/Content/images/speakers/Minyar-Hidr-Photo.jpg',
        [CvPdfPath] = N'~/Content/docs/speakers/Minyar-Hidr-CV.pdf',
        [Category] = 1,
        [Sorting] = 18,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Sassi%' OR [FullNameAr] LIKE '%ساسي%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Prof. Minyar Sassi', N'بروفيسور منيار ساسي', N'Professor of AI in Medical Imaging', N'أستاذ الذكاء الاصطناعي في التصوير الطبي', 
        N'Imam Abdulrahman Bin Faisal University', N'جامعة الإمام عبدالرحمن بن فيصل', N'~/Content/images/speakers/Minyar-Hidr-Photo.jpg', N'~/Content/docs/speakers/Minyar-Hidr-CV.pdf', 
        1, 18, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 19. Dr. Abdul Razak Hairil (د. عبد الرزاق هيريل)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Hairil%' OR [FullNameAr] LIKE '%هيريل%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Abdul Razak Hairil',
        [FullNameAr] = N'د. عبد الرزاق هيريل',
        [JobTitleEn] = N'Senior Medical Physicist & AI Researcher',
        [JobTitleAr] = N'فيزيائي طبي أول وباحث ذكاء اصطناعي',
        [OrganizationEn] = N'International Atomic Energy Agency Collaborating Center',
        [OrganizationAr] = N'المركز المتعاون مع الوكالة الدولية للطاقة الذرية',
        [ImagePath] = N'~/Content/images/speakers/Hairil-AbdulRazak-Photo.jpg',
        [CvPdfPath] = N'~/Content/docs/speakers/Hairil-AbdulRazak-CV.pdf',
        [Category] = 0,
        [Sorting] = 19,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Hairil%' OR [FullNameAr] LIKE '%هيريل%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Abdul Razak Hairil', N'د. عبد الرزاق هيريل', N'Senior Medical Physicist & AI Researcher', N'فيزيائي طبي أول وباحث ذكاء اصطناعي', 
        N'International Atomic Energy Agency Collaborating Center', N'المركز المتعاون مع الوكالة الدولية للطاقة الذرية', N'~/Content/images/speakers/Hairil-AbdulRazak-Photo.jpg', N'~/Content/docs/speakers/Hairil-AbdulRazak-CV.pdf', 
        0, 19, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 20. Dr. Mohammed Alsaadi (د. محمد السعدي)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Alsaadi%' OR [FullNameAr] LIKE '%السعدي%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Mohammed Alsaadi',
        [FullNameAr] = N'د. محمد السعدي',
        [JobTitleEn] = N'Consultant Clinical Radiologist',
        [JobTitleAr] = N'استشاري أشعة سريرية',
        [OrganizationEn] = N'King Fahad University Hospital',
        [OrganizationAr] = N'مستشفى الملك فهد الجامعي',
        [ImagePath] = N'~/Content/images/speakers/Mohammed-Saadi-Photo.jpeg',
        [CvPdfPath] = N'~/Content/docs/speakers/Mohammed-Saadi-CV.pdf',
        [Category] = 1,
        [Sorting] = 20,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Alsaadi%' OR [FullNameAr] LIKE '%السعدي%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Mohammed Alsaadi', N'د. محمد السعدي', N'Consultant Clinical Radiologist', N'استشاري أشعة سريرية', 
        N'King Fahad University Hospital', N'مستشفى الملك فهد الجامعي', N'~/Content/images/speakers/Mohammed-Saadi-Photo.jpeg', N'~/Content/docs/speakers/Mohammed-Saadi-CV.pdf', 
        1, 20, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 21. Dr. Oun Al-iedani (د. عون العيداني)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Al-iedani%' OR [FullNameAr] LIKE '%العيداني%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Oun Al-iedani',
        [FullNameAr] = N'د. عون العيداني',
        [JobTitleEn] = N'Senior Lecturer in Medical Imaging',
        [JobTitleAr] = N'محاضر أول في التصوير الطبي',
        [OrganizationEn] = N'Deakin University',
        [OrganizationAr] = N'جامعة ديكين',
        [ImagePath] = N'~/Content/images/speakers/Oun-Aliedani-Photo.jpg',
        [CvPdfPath] = N'~/Content/docs/speakers/Oun-Aliedani-CV.pdf',
        [Category] = 0,
        [Sorting] = 21,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Al-iedani%' OR [FullNameAr] LIKE '%العيداني%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Oun Al-iedani', N'د. عون العيداني', N'Senior Lecturer in Medical Imaging', N'محاضر أول في التصوير الطبي', 
        N'Deakin University', N'جامعة ديكين', N'~/Content/images/speakers/Oun-Aliedani-Photo.jpg', N'~/Content/docs/speakers/Oun-Aliedani-CV.pdf', 
        0, 21, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 22. Dr. Amal Alsalamah (د. أمل السلامة)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Alsalamah%' OR [FullNameAr] LIKE '%السلامة%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Amal Alsalamah',
        [FullNameAr] = N'د. أمل السلامة',
        [JobTitleEn] = N'Assistant Professor of Health Informatics',
        [JobTitleAr] = N'أستاذ مساعد في المعلوماتية الصحية',
        [OrganizationEn] = N'Princess Nourah bint Abdulrahman University',
        [OrganizationAr] = N'جامعة الأميرة نورة بنت عبدالرحمن',
        [ImagePath] = N'~/Content/images/speakers/Amal-Alsalamah-Photo.jpeg',
        [CvPdfPath] = N'~/Content/docs/speakers/Amal-Alsalamah-CV.pdf',
        [Category] = 0,
        [Sorting] = 22,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Alsalamah%' OR [FullNameAr] LIKE '%السلامة%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Amal Alsalamah', N'د. أمل السلامة', N'Assistant Professor of Health Informatics', N'أستاذ مساعد في المعلوماتية الصحية', 
        N'Princess Nourah bint Abdulrahman University', N'جامعة الأميرة نورة بنت عبدالرحمن', N'~/Content/images/speakers/Amal-Alsalamah-Photo.jpeg', N'~/Content/docs/speakers/Amal-Alsalamah-CV.pdf', 
        0, 22, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 23. Dr. Rasha Alafaleg (د. رشا العفالق)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Alafaleg%' OR [FullNameAr] LIKE '%العفالق%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Rasha Alafaleg',
        [FullNameAr] = N'د. رشا العفالق',
        [JobTitleEn] = N'Consultant Diagnostic Radiologist',
        [JobTitleAr] = N'استشارية أشعة تشخيصية',
        [OrganizationEn] = N'King Fahad Hospital of the University',
        [OrganizationAr] = N'مستشفى الملك فهد الجامعي',
        [ImagePath] = N'~/Content/images/speakers/Rasha-Alafaleg-Photo.jpeg',
        [CvPdfPath] = N'~/Content/docs/speakers/Rasha-Alafaleg-CV.pdf',
        [Category] = 1,
        [Sorting] = 23,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Alafaleg%' OR [FullNameAr] LIKE '%العفالق%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Rasha Alafaleg', N'د. رشا العفالق', N'Consultant Diagnostic Radiologist', N'استشارية أشعة تشخيصية', 
        N'King Fahad Hospital of the University', N'مستشفى الملك فهد الجامعي', N'~/Content/images/speakers/Rasha-Alafaleg-Photo.jpeg', N'~/Content/docs/speakers/Rasha-Alafaleg-CV.pdf', 
        1, 23, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 24. Dr. Ali Alhailiy (د. علي الهيلي)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Alhailiy%' OR [FullNameAr] LIKE '%الهيلي%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Ali Alhailiy',
        [FullNameAr] = N'د. علي الهيلي',
        [JobTitleEn] = N'Assistant Professor of Radiology',
        [JobTitleAr] = N'أستاذ مساعد في الأشعة',
        [OrganizationEn] = N'Taibah University',
        [OrganizationAr] = N'جامعة طيبة',
        [ImagePath] = N'~/Content/images/speakers/Ali-Alhaili-Photo.jpg',
        [CvPdfPath] = N'~/Content/docs/speakers/Ali-Alhailiy-CV.pdf',
        [Category] = 0,
        [Sorting] = 24,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Alhailiy%' OR [FullNameAr] LIKE '%الهيلي%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Ali Alhailiy', N'د. علي الهيلي', N'Assistant Professor of Radiology', N'أستاذ مساعد في الأشعة', 
        N'Taibah University', N'جامعة طيبة', N'~/Content/images/speakers/Ali-Alhaili-Photo.jpg', N'~/Content/docs/speakers/Ali-Alhailiy-CV.pdf', 
        0, 24, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 25. Mr. Fahad Alsadan, MSc (أ. فهد السعدان)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%MSc%' OR [FullNameAr] LIKE '%السعدان%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Mr. Fahad Alsadan, MSc',
        [FullNameAr] = N'أ. فهد السعدان',
        [JobTitleEn] = N'Clinical Imaging Informatics Specialist',
        [JobTitleAr] = N'أخصائي معلوماتية التصوير الطبي السريري',
        [OrganizationEn] = N'King Saud University Medical City',
        [OrganizationAr] = N'المدينة الطبية بجامعة الملك سعود',
        [ImagePath] = N'~/Content/images/speakers/Fahad-Alsadan-Photo.jpg',
        [CvPdfPath] = N'~/Content/docs/speakers/Fahad-Alsadan-CV.pdf',
        [Category] = 0,
        [Sorting] = 25,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%MSc%' OR [FullNameAr] LIKE '%السعدان%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Mr. Fahad Alsadan, MSc', N'أ. فهد السعدان', N'Clinical Imaging Informatics Specialist', N'أخصائي معلوماتية التصوير الطبي السريري', 
        N'King Saud University Medical City', N'المدينة الطبية بجامعة الملك سعود', N'~/Content/images/speakers/Fahad-Alsadan-Photo.jpg', N'~/Content/docs/speakers/Fahad-Alsadan-CV.pdf', 
        0, 25, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 26. Prof. Mark McEntee (بروفيسور مارك ماكنتي)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%McEntee%' OR [FullNameAr] LIKE '%ماكنتي%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Prof. Mark McEntee',
        [FullNameAr] = N'بروفيسور مارك ماكنتي',
        [JobTitleEn] = N'Professor of Diagnostic Radiography',
        [JobTitleAr] = N'أستاذ الأشعة التشخيصية',
        [OrganizationEn] = N'University College Cork',
        [OrganizationAr] = N'جامعة كوليدج كورك',
        [ImagePath] = N'~/Content/images/speakers/Mark-McEntee-Photo.jpeg',
        [CvPdfPath] = N'~/Content/docs/speakers/Mark-McEntee-CV.pdf',
        [Category] = 0,
        [Sorting] = 26,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%McEntee%' OR [FullNameAr] LIKE '%ماكنتي%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Prof. Mark McEntee', N'بروفيسور مارك ماكنتي', N'Professor of Diagnostic Radiography', N'أستاذ الأشعة التشخيصية', 
        N'University College Cork', N'جامعة كوليدج كورك', N'~/Content/images/speakers/Mark-McEntee-Photo.jpeg', N'~/Content/docs/speakers/Mark-McEntee-CV.pdf', 
        0, 26, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 27. Dr. Laura McLaughlin (د. لورا ماكلوغلين)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%McLaughlin%' OR [FullNameAr] LIKE '%ماكلوغلين%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Laura McLaughlin',
        [FullNameAr] = N'د. لورا ماكلوغلين',
        [JobTitleEn] = N'Senior Lecturer in Medical Imaging',
        [JobTitleAr] = N'محاضرة أولى في التصوير الطبي',
        [OrganizationEn] = N'Ulster University',
        [OrganizationAr] = N'جامعة أولستر',
        [ImagePath] = N'~/Content/images/speakers/Laura-McLaughlin-Photo.jpg',
        [CvPdfPath] = N'~/Content/docs/speakers/Laura-McLaughlin-CV.pdf',
        [Category] = 0,
        [Sorting] = 27,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%McLaughlin%' OR [FullNameAr] LIKE '%ماكلوغلين%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Laura McLaughlin', N'د. لورا ماكلوغلين', N'Senior Lecturer in Medical Imaging', N'محاضرة أولى في التصوير الطبي', 
        N'Ulster University', N'جامعة أولستر', N'~/Content/images/speakers/Laura-McLaughlin-Photo.jpg', N'~/Content/docs/speakers/Laura-McLaughlin-CV.pdf', 
        0, 27, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 28. Dr. Andrew England (د. أندرو إنجلاند)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%England%' OR [FullNameAr] LIKE '%إنجلاند%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Andrew England',
        [FullNameAr] = N'د. أندرو إنجلاند',
        [JobTitleEn] = N'Senior Lecturer in Radiography',
        [JobTitleAr] = N'محاضر أول في علوم الأشعة',
        [OrganizationEn] = N'Keele University',
        [OrganizationAr] = N'جامعة كيلي',
        [ImagePath] = N'~/Content/images/speakers/Speaker-Photo.png',
        [CvPdfPath] = N'~/Content/docs/speakers/Andrew-England-CV.pdf',
        [Category] = 0,
        [Sorting] = 28,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%England%' OR [FullNameAr] LIKE '%إنجلاند%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Andrew England', N'د. أندرو إنجلاند', N'Senior Lecturer in Radiography', N'محاضر أول في علوم الأشعة', 
        N'Keele University', N'جامعة كيلي', N'~/Content/images/speakers/Speaker-Photo.png', N'~/Content/docs/speakers/Andrew-England-CV.pdf', 
        0, 28, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 29. Dr. Hussain Alarfaj (د. حسين العرفج)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Alarfaj%' OR [FullNameAr] LIKE '%العرفج%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Hussain Alarfaj',
        [FullNameAr] = N'د. حسين العرفج',
        [JobTitleEn] = N'Consultant Clinical Radiologist',
        [JobTitleAr] = N'استشاري أشعة سريرية',
        [OrganizationEn] = N'Imam Abdulrahman Bin Faisal University',
        [OrganizationAr] = N'جامعة الإمام عبدالرحمن بن فيصل',
        [ImagePath] = N'~/Content/images/speakers/Hussain-Alarfaj-Photo.jpg',
        [CvPdfPath] = N'~/Content/docs/speakers/Hussain-Alarfaj-CV.pdf',
        [Category] = 1,
        [Sorting] = 29,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Alarfaj%' OR [FullNameAr] LIKE '%العرفج%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Hussain Alarfaj', N'د. حسين العرفج', N'Consultant Clinical Radiologist', N'استشاري أشعة سريرية', 
        N'Imam Abdulrahman Bin Faisal University', N'جامعة الإمام عبدالرحمن بن فيصل', N'~/Content/images/speakers/Hussain-Alarfaj-Photo.jpg', N'~/Content/docs/speakers/Hussain-Alarfaj-CV.pdf', 
        1, 29, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 30. Dr. Qurain Alqurain (د. قرين القرين)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Alqurain%' OR [FullNameAr] LIKE '%القرين%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Qurain Alqurain',
        [FullNameAr] = N'د. قرين القرين',
        [JobTitleEn] = N'Consultant Radiologist',
        [JobTitleAr] = N'استشاري أشعة',
        [OrganizationEn] = N'Imam Abdulrahman Bin Faisal University',
        [OrganizationAr] = N'جامعة الإمام عبدالرحمن بن فيصل',
        [ImagePath] = N'~/Content/images/speakers/Qurain-Alqurain-Photo.png',
        [CvPdfPath] = N'~/Content/docs/speakers/Qurain-Alqurain-CV.pdf',
        [Category] = 1,
        [Sorting] = 30,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Alqurain%' OR [FullNameAr] LIKE '%القرين%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Qurain Alqurain', N'د. قرين القرين', N'Consultant Radiologist', N'استشاري أشعة', 
        N'Imam Abdulrahman Bin Faisal University', N'جامعة الإمام عبدالرحمن بن فيصل', N'~/Content/images/speakers/Qurain-Alqurain-Photo.png', N'~/Content/docs/speakers/Qurain-Alqurain-CV.pdf', 
        1, 30, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 31. Moath Ameer (معاذ أمير)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Moath%Ameer%' OR [FullNameAr] LIKE '%معاذ%أمير%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Moath Ameer',
        [FullNameAr] = N'معاذ أمير',
        [JobTitleEn] = N'Medical Student & AI Innovator',
        [JobTitleAr] = N'طالب طب ومبتكر في الذكاء الاصطناعي',
        [OrganizationEn] = N'Imam Abdulrahman Bin Faisal University',
        [OrganizationAr] = N'جامعة الإمام عبدالرحمن بن فيصل',
        [ImagePath] = N'~/Content/images/speakers/Speaker-Photo.png',
        [CvPdfPath] = NULL,
        [Category] = 0,
        [Sorting] = 31,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Moath%Ameer%' OR [FullNameAr] LIKE '%معاذ%أمير%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Moath Ameer', N'معاذ أمير', N'Medical Student & AI Innovator', N'طالب طب ومبتكر في الذكاء الاصطناعي', 
        N'Imam Abdulrahman Bin Faisal University', N'جامعة الإمام عبدالرحمن بن فيصل', N'~/Content/images/speakers/Speaker-Photo.png', NULL, 
        0, 31, 1
    );
END
GO

-- ----------------------------------------------------------------------------
-- 32. Dr. Abdulaziz M. Al-Sharydah (د. عبدالعزيز محمد الشريدة)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [dbo].[Speakers] WHERE [FullNameEn] LIKE '%Al-Sharydah%' OR [FullNameAr] LIKE '%الشريدة%')
BEGIN
    UPDATE [dbo].[Speakers]
    SET 
        [FullNameEn] = N'Dr. Abdulaziz M. Al-Sharydah',
        [FullNameAr] = N'د. عبدالعزيز محمد الشريدة',
        [JobTitleEn] = N'Associate Professor & Chairman of Radiology',
        [JobTitleAr] = N'أستاذ مشارك ورئيس قسم الأشعة',
        [OrganizationEn] = N'Imam Abdulrahman Bin Faisal University',
        [OrganizationAr] = N'جامعة الإمام عبدالرحمن بن فيصل',
        [ImagePath] = N'~/Content/images/speakers/Speaker-Photo.png',
        [CvPdfPath] = NULL,
        [Category] = 1,
        [Sorting] = 32,
        [IsActive] = 1
    WHERE [FullNameEn] LIKE '%Al-Sharydah%' OR [FullNameAr] LIKE '%الشريدة%';
END
ELSE
BEGIN
    INSERT INTO [dbo].[Speakers] (
        [FullNameEn], [FullNameAr], [JobTitleEn], [JobTitleAr], 
        [OrganizationEn], [OrganizationAr], [ImagePath], [CvPdfPath], 
        [Category], [Sorting], [IsActive]
    ) VALUES (
        N'Dr. Abdulaziz M. Al-Sharydah', N'د. عبدالعزيز محمد الشريدة', N'Associate Professor & Chairman of Radiology', N'أستاذ مشارك ورئيس قسم الأشعة', 
        N'Imam Abdulrahman Bin Faisal University', N'جامعة الإمام عبدالرحمن بن فيصل', N'~/Content/images/speakers/Speaker-Photo.png', NULL, 
        1, 32, 1
    );
END
GO

-- Verification query
SELECT [SpeakerID], [FullNameEn], [FullNameAr], [ImagePath], [CvPdfPath]
FROM [dbo].[Speakers]
ORDER BY [Sorting];
GO
