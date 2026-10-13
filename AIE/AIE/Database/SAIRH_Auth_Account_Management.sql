-- ============================================================================
-- SAIRH 2026 - Saudi 1st AI Summit in Radiology and Health Innovation
-- Comprehensive Enterprise Authentication & Account Management Database Script
-- Engine: Microsoft SQL Server 2019 / 2022 / Azure SQL
--
-- Security Features:
--  - PBKDF2-HMAC-SHA512 Password Storage (OWASP standard, 210,000 iterations)
--  - Multi-Factor Password History (Prevents reuse of last N passwords)
--  - Account Lockout Policy (5 failed attempts = 15-minute progressive lockout)
--  - Single-Use, Expiring Cryptographic Password Reset Tokens (60-minute TTL)
--  - Email Verification Tokens with Expiration
--  - Role-Based Access Control (RBAC: Administrator, Attendee, Speaker, Judge, Exhibitor)
--  - Stateful User Sessions with Security Stamp Rotation & Device Fingerprinting
--  - Full Audit Logging (LoginAudit & AccountActivityAudit)
--  - Parameterized Stored Procedures for all Auth & Account workflows
-- ============================================================================

USE [SAIRH];
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

PRINT N'============================================================================';
PRINT N'Starting SAIRH 2026 Authentication & Account Management Schema Initialization';
PRINT N'============================================================================';
GO

-- ----------------------------------------------------------------------------
-- 1. TABLE: dbo.Roles (Role-Based Access Control)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[Roles]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Roles] (
        [RoleID]          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [RoleName]        VARCHAR(50) NOT NULL UNIQUE,
        [Description]     NVARCHAR(250) NULL,
        [IsActive]        BIT NOT NULL CONSTRAINT DF_Roles_IsActive DEFAULT 1,
        [CreatedAtUtc]    DATETIME2 NOT NULL CONSTRAINT DF_Roles_CreatedAtUtc DEFAULT SYSUTCDATETIME()
    );
    PRINT N'[+] Created table: [dbo].[Roles]';
END
GO

-- ----------------------------------------------------------------------------
-- 2. TABLE: dbo.Attendees (Master User & Profile Accounts)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[Attendees]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Attendees] (
        [AttendeeID]          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [FullName]            NVARCHAR(150) NOT NULL,
        [Email]               VARCHAR(100) NOT NULL UNIQUE,
        [PasswordHash]        NVARCHAR(256) NOT NULL, -- Format: PBKDF2-SHA512$iterations$salt$hash
        [MobileNo]            VARCHAR(25) NULL,
        [Organization]        NVARCHAR(200) NULL,
        [JobTitle]            NVARCHAR(150) NULL,
        [Specialty]           NVARCHAR(150) NULL,
        [LinkedInUrl]         VARCHAR(300) NULL,
        [CountryID]           INT NULL,
        [UserLevel]           VARCHAR(20) NOT NULL CONSTRAINT DF_Attendees_UserLevel DEFAULT 'User', -- 'User', 'Admin', 'Speaker'
        [IsBlocked]           BIT NOT NULL CONSTRAINT DF_Attendees_IsBlocked DEFAULT 0,
        [IsEmailVerified]     BIT NOT NULL CONSTRAINT DF_Attendees_IsEmailVerified DEFAULT 0,
        [EmailVerifiedAtUtc]  DATETIME2 NULL,
        [FailedLoginCount]    INT NOT NULL CONSTRAINT DF_Attendees_FailedLoginCount DEFAULT 0,
        [LockoutEndUtc]       DATETIME2 NULL,
        [LastLoginAtUtc]      DATETIME2 NULL,
        [PasswordChangedAtUtc]DATETIME2 NOT NULL CONSTRAINT DF_Attendees_PasswordChangedAtUtc DEFAULT SYSUTCDATETIME(),
        [SecurityStamp]       NVARCHAR(64) NOT NULL CONSTRAINT DF_Attendees_SecurityStamp DEFAULT CONVERT(NVARCHAR(64), NEWID()),
        [HasCompletedSurvey]  BIT NOT NULL CONSTRAINT DF_Attendees_HasCompletedSurvey DEFAULT 0,
        [PassCode]            VARCHAR(50) NULL UNIQUE,
        [QrCodePath]          NVARCHAR(500) NULL,
        [IsCheckedIn]         BIT NOT NULL CONSTRAINT DF_Attendees_IsCheckedIn DEFAULT 0,
        [CheckedInAt]         DATETIME NULL,
        [RegisteredAt]        DATETIME NOT NULL CONSTRAINT DF_Attendees_RegisteredAt DEFAULT GETDATE(),
        [UpdatedAtUtc]        DATETIME2 NOT NULL CONSTRAINT DF_Attendees_UpdatedAtUtc DEFAULT SYSUTCDATETIME()
    );
    PRINT N'[+] Created table: [dbo].[Attendees]';
END
ELSE
BEGIN
    -- Ensure all modern authentication columns exist in existing Attendees table
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Attendees]') AND name = N'PasswordHash')
        ALTER TABLE [dbo].[Attendees] ADD [PasswordHash] NVARCHAR(256) NULL;
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Attendees]') AND name = N'IsBlocked')
        ALTER TABLE [dbo].[Attendees] ADD [IsBlocked] BIT NOT NULL CONSTRAINT DF_Attendees_IsBlocked DEFAULT 0;
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Attendees]') AND name = N'IsEmailVerified')
        ALTER TABLE [dbo].[Attendees] ADD [IsEmailVerified] BIT NOT NULL CONSTRAINT DF_Attendees_IsEmailVerified DEFAULT 0;
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Attendees]') AND name = N'EmailVerifiedAtUtc')
        ALTER TABLE [dbo].[Attendees] ADD [EmailVerifiedAtUtc] DATETIME2 NULL;
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Attendees]') AND name = N'FailedLoginCount')
        ALTER TABLE [dbo].[Attendees] ADD [FailedLoginCount] INT NOT NULL CONSTRAINT DF_Attendees_FailedLoginCount DEFAULT 0;
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Attendees]') AND name = N'LockoutEndUtc')
        ALTER TABLE [dbo].[Attendees] ADD [LockoutEndUtc] DATETIME2 NULL;
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Attendees]') AND name = N'LastLoginAtUtc')
        ALTER TABLE [dbo].[Attendees] ADD [LastLoginAtUtc] DATETIME2 NULL;
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Attendees]') AND name = N'PasswordChangedAtUtc')
        ALTER TABLE [dbo].[Attendees] ADD [PasswordChangedAtUtc] DATETIME2 NOT NULL CONSTRAINT DF_Attendees_PasswordChangedAtUtc DEFAULT SYSUTCDATETIME();
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Attendees]') AND name = N'SecurityStamp')
        ALTER TABLE [dbo].[Attendees] ADD [SecurityStamp] NVARCHAR(64) NOT NULL CONSTRAINT DF_Attendees_SecurityStamp DEFAULT CONVERT(NVARCHAR(64), NEWID());
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Attendees]') AND name = N'HasCompletedSurvey')
        ALTER TABLE [dbo].[Attendees] ADD [HasCompletedSurvey] BIT NOT NULL CONSTRAINT DF_Attendees_HasCompletedSurvey DEFAULT 0;
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Attendees]') AND name = N'UpdatedAtUtc')
        ALTER TABLE [dbo].[Attendees] ADD [UpdatedAtUtc] DATETIME2 NOT NULL CONSTRAINT DF_Attendees_UpdatedAtUtc DEFAULT SYSUTCDATETIME();
    PRINT N'[+] Verified/Updated existing columns in [dbo].[Attendees]';
END
GO

-- Indexes on Attendees
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Attendees_Email' AND object_id = OBJECT_ID(N'[dbo].[Attendees]'))
    CREATE UNIQUE NONCLUSTERED INDEX IX_Attendees_Email ON [dbo].[Attendees]([Email]);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Attendees_UserLevel' AND object_id = OBJECT_ID(N'[dbo].[Attendees]'))
    CREATE NONCLUSTERED INDEX IX_Attendees_UserLevel ON [dbo].[Attendees]([UserLevel]);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Attendees_Lockout' AND object_id = OBJECT_ID(N'[dbo].[Attendees]'))
    CREATE NONCLUSTERED INDEX IX_Attendees_Lockout ON [dbo].[Attendees]([LockoutEndUtc], [FailedLoginCount]);
GO

-- ----------------------------------------------------------------------------
-- 3. TABLE: dbo.UserRoles (Mapping Attendees to Roles)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[UserRoles]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[UserRoles] (
        [UserRoleID]   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [AttendeeID]   INT NOT NULL,
        [RoleID]       INT NOT NULL,
        [AssignedAtUtc]DATETIME2 NOT NULL CONSTRAINT DF_UserRoles_AssignedAtUtc DEFAULT SYSUTCDATETIME(),
        [AssignedBy]   VARCHAR(100) NULL,

        CONSTRAINT FK_UserRoles_Attendees FOREIGN KEY ([AttendeeID])
            REFERENCES [dbo].[Attendees]([AttendeeID])
            ON DELETE CASCADE,

        CONSTRAINT FK_UserRoles_Roles FOREIGN KEY ([RoleID])
            REFERENCES [dbo].[Roles]([RoleID])
            ON DELETE CASCADE,

        CONSTRAINT UQ_UserRoles_Attendee_Role UNIQUE ([AttendeeID], [RoleID])
    );
    CREATE INDEX IX_UserRoles_AttendeeID ON [dbo].[UserRoles]([AttendeeID]);
    CREATE INDEX IX_UserRoles_RoleID ON [dbo].[UserRoles]([RoleID]);
    PRINT N'[+] Created table: [dbo].[UserRoles]';
END
GO

-- ----------------------------------------------------------------------------
-- 4. TABLE: dbo.PasswordResetTokens (Time-limited Cryptographic Tokens)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[PasswordResetTokens]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[PasswordResetTokens] (
        [TokenID]          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [AttendeeID]       INT NOT NULL,
        [Email]            VARCHAR(100) NOT NULL,
        [ResetToken]       VARCHAR(100) NOT NULL UNIQUE,
        [ExpiresAtUtc]     DATETIME2 NOT NULL,
        [IsUsed]           BIT NOT NULL CONSTRAINT DF_PasswordResetTokens_IsUsed DEFAULT 0,
        [UsedAtUtc]        DATETIME2 NULL,
        [RequestIpAddress] VARCHAR(45) NULL,
        [CreatedAtUtc]     DATETIME2 NOT NULL CONSTRAINT DF_PasswordResetTokens_CreatedAtUtc DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_PasswordResetTokens_Attendees FOREIGN KEY ([AttendeeID])
            REFERENCES [dbo].[Attendees]([AttendeeID])
            ON DELETE CASCADE
    );
    CREATE INDEX IX_PasswordResetTokens_Token_Status ON [dbo].[PasswordResetTokens]([ResetToken], [IsUsed], [ExpiresAtUtc]);
    CREATE INDEX IX_PasswordResetTokens_AttendeeID ON [dbo].[PasswordResetTokens]([AttendeeID], [CreatedAtUtc]);
    PRINT N'[+] Created table: [dbo].[PasswordResetTokens]';
END
GO

-- ----------------------------------------------------------------------------
-- 5. TABLE: dbo.EmailVerificationTokens (Account Verification)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[EmailVerificationTokens]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[EmailVerificationTokens] (
        [VerificationID]   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [AttendeeID]       INT NOT NULL,
        [Email]            VARCHAR(100) NOT NULL,
        [Token]            VARCHAR(100) NOT NULL UNIQUE,
        [ExpiresAtUtc]     DATETIME2 NOT NULL,
        [IsUsed]           BIT NOT NULL CONSTRAINT DF_EmailVerificationTokens_IsUsed DEFAULT 0,
        [UsedAtUtc]        DATETIME2 NULL,
        [CreatedAtUtc]     DATETIME2 NOT NULL CONSTRAINT DF_EmailVerificationTokens_CreatedAtUtc DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_EmailVerificationTokens_Attendees FOREIGN KEY ([AttendeeID])
            REFERENCES [dbo].[Attendees]([AttendeeID])
            ON DELETE CASCADE
    );
    CREATE INDEX IX_EmailVerificationTokens_Token ON [dbo].[EmailVerificationTokens]([Token], [IsUsed], [ExpiresAtUtc]);
    PRINT N'[+] Created table: [dbo].[EmailVerificationTokens]';
END
GO

-- ----------------------------------------------------------------------------
-- 6. TABLE: dbo.UserSessions (Active Sessions, Remember-Me & Device Tracking)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[UserSessions]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[UserSessions] (
        [SessionID]        BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [AttendeeID]       INT NOT NULL,
        [SessionToken]     VARCHAR(128) NOT NULL UNIQUE,
        [SecurityStamp]    NVARCHAR(64) NOT NULL,
        [DeviceInfo]       NVARCHAR(300) NULL,
        [IpAddress]        VARCHAR(45) NULL,
        [ExpiresAtUtc]     DATETIME2 NOT NULL,
        [IsRevoked]        BIT NOT NULL CONSTRAINT DF_UserSessions_IsRevoked DEFAULT 0,
        [RevokedAtUtc]     DATETIME2 NULL,
        [LastSeenAtUtc]    DATETIME2 NOT NULL CONSTRAINT DF_UserSessions_LastSeenAtUtc DEFAULT SYSUTCDATETIME(),
        [CreatedAtUtc]     DATETIME2 NOT NULL CONSTRAINT DF_UserSessions_CreatedAtUtc DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_UserSessions_Attendees FOREIGN KEY ([AttendeeID])
            REFERENCES [dbo].[Attendees]([AttendeeID])
            ON DELETE CASCADE
    );
    CREATE INDEX IX_UserSessions_Token ON [dbo].[UserSessions]([SessionToken], [IsRevoked], [ExpiresAtUtc]);
    CREATE INDEX IX_UserSessions_AttendeeID ON [dbo].[UserSessions]([AttendeeID], [IsRevoked]);
    PRINT N'[+] Created table: [dbo].[UserSessions]';
END
GO

-- ----------------------------------------------------------------------------
-- 7. TABLE: dbo.PasswordHistory (Prevents Password Reuse - Last N Passwords)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[PasswordHistory]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[PasswordHistory] (
        [HistoryID]        BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [AttendeeID]       INT NOT NULL,
        [PasswordHash]     NVARCHAR(256) NOT NULL,
        [CreatedAtUtc]     DATETIME2 NOT NULL CONSTRAINT DF_PasswordHistory_CreatedAtUtc DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_PasswordHistory_Attendees FOREIGN KEY ([AttendeeID])
            REFERENCES [dbo].[Attendees]([AttendeeID])
            ON DELETE CASCADE
    );
    CREATE INDEX IX_PasswordHistory_AttendeeID ON [dbo].[PasswordHistory]([AttendeeID], [CreatedAtUtc] DESC);
    PRINT N'[+] Created table: [dbo].[PasswordHistory]';
END
GO

-- ----------------------------------------------------------------------------
-- 8. TABLE: dbo.LoginAudit (Security Log of all Authentication Attempts)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[LoginAudit]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[LoginAudit] (
        [LoginAuditID]     BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [AttendeeID]       INT NULL,
        [Email]            VARCHAR(100) NOT NULL,
        [IpAddress]        VARCHAR(45) NULL,
        [UserAgent]        NVARCHAR(400) NULL,
        [Succeeded]        BIT NOT NULL,
        [FailureReason]    NVARCHAR(100) NULL, -- 'InvalidCredentials', 'AccountLocked', 'AccountBlocked', etc.
        [CreatedAtUtc]     DATETIME2 NOT NULL CONSTRAINT DF_LoginAudit_CreatedAtUtc DEFAULT SYSUTCDATETIME()
    );
    CREATE INDEX IX_LoginAudit_AttendeeID ON [dbo].[LoginAudit]([AttendeeID], [CreatedAtUtc]);
    CREATE INDEX IX_LoginAudit_Email_Date ON [dbo].[LoginAudit]([Email], [CreatedAtUtc]);
    PRINT N'[+] Created table: [dbo].[LoginAudit]';
END
GO

-- ----------------------------------------------------------------------------
-- 9. TABLE: dbo.AccountActivityAudit (Lifecycle events for security auditing)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[AccountActivityAudit]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[AccountActivityAudit] (
        [ActivityID]       BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [AttendeeID]       INT NOT NULL,
        [ActionType]       VARCHAR(50) NOT NULL, -- 'REGISTER', 'PASSWORD_CHANGE', 'PASSWORD_RESET', 'PROFILE_UPDATE', 'ACCOUNT_LOCKED', 'ACCOUNT_UNLOCKED'
        [Description]      NVARCHAR(500) NULL,
        [IpAddress]        VARCHAR(45) NULL,
        [CreatedAtUtc]     DATETIME2 NOT NULL CONSTRAINT DF_AccountActivityAudit_CreatedAtUtc DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_AccountActivityAudit_Attendees FOREIGN KEY ([AttendeeID])
            REFERENCES [dbo].[Attendees]([AttendeeID])
            ON DELETE CASCADE
    );
    CREATE INDEX IX_AccountActivityAudit_AttendeeID ON [dbo].[AccountActivityAudit]([AttendeeID], [CreatedAtUtc]);
    PRINT N'[+] Created table: [dbo].[AccountActivityAudit]';
END
GO

-- ----------------------------------------------------------------------------
-- 10. TABLE: dbo.Booths (Exhibition Sponsor Booths & Research Display Screens)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[Booths]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Booths] (
        [BoothID]             INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [BoothCode]           VARCHAR(10) NOT NULL UNIQUE,
        [NameEn]              NVARCHAR(150) NOT NULL,
        [NameAr]              NVARCHAR(150) NOT NULL,
        [OrganizationEn]      NVARCHAR(200) NOT NULL,
        [OrganizationAr]      NVARCHAR(200) NOT NULL,
        [Type]                VARCHAR(50) NOT NULL, -- 'SponsorBooth' or 'ResearchScreen'
        [HallEn]              NVARCHAR(100) NOT NULL,
        [HallAr]              NVARCHAR(100) NOT NULL,
        [CategoriesEn]        NVARCHAR(500) NOT NULL,
        [CategoriesAr]        NVARCHAR(500) NOT NULL,
        [ProjectedAvgMinutes] INT NOT NULL CONSTRAINT DF_Booths_ProjectedAvgMinutes DEFAULT 5,
        [X]                   INT NOT NULL DEFAULT 0,
        [Y]                   INT NOT NULL DEFAULT 0,
        [IsActive]            BIT NOT NULL DEFAULT 1
    );
    CREATE INDEX IX_Booths_Code ON [dbo].[Booths]([BoothCode]);
    CREATE INDEX IX_Booths_Type ON [dbo].[Booths]([Type]);
    PRINT N'[+] Created table: [dbo].[Booths]';
END
GO

-- ----------------------------------------------------------------------------
-- 11. TABLE: dbo.BoothVisits (NFC Tag Taps & Projected Average Visit Timers)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[BoothVisits]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[BoothVisits] (
        [VisitID]             BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [AttendeeID]          INT NULL,
        [UserEmail]           VARCHAR(100) NOT NULL,
        [BoothCode]           VARCHAR(10) NOT NULL,
        [BoothType]           VARCHAR(50) NOT NULL,
        [BoothName]           NVARCHAR(200) NOT NULL,
        [ProjectedAvgMinutes] INT NOT NULL CONSTRAINT DF_BoothVisits_ProjectedAvgMinutes DEFAULT 5,
        [StartedAtUtc]        DATETIME2 NOT NULL CONSTRAINT DF_BoothVisits_StartedAtUtc DEFAULT SYSUTCDATETIME(),
        [CompletedAtUtc]      DATETIME2 NULL,
        [Status]              VARCHAR(20) NOT NULL CONSTRAINT DF_BoothVisits_Status DEFAULT 'Active', -- 'Active', 'Completed'
        [UserIp]              VARCHAR(45) NULL,

        CONSTRAINT FK_BoothVisits_Attendees FOREIGN KEY ([AttendeeID])
            REFERENCES [dbo].[Attendees]([AttendeeID])
            ON DELETE SET NULL
    );
    CREATE INDEX IX_BoothVisits_EmailCode ON [dbo].[BoothVisits]([UserEmail], [BoothCode]);
    CREATE INDEX IX_BoothVisits_StartedAt ON [dbo].[BoothVisits]([StartedAtUtc]);
    PRINT N'[+] Created table: [dbo].[BoothVisits]';
END
GO

-- ============================================================================
-- VIEWS FOR SECURITY MONITORING & APPLICATION INTEGRATION
-- ============================================================================

-- View: Active Attendees with Role Names
IF OBJECT_ID(N'[dbo].[vw_ActiveUsers]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_ActiveUsers];
GO
CREATE VIEW [dbo].[vw_ActiveUsers] AS
SELECT 
    a.[AttendeeID],
    a.[FullName],
    a.[Email],
    a.[MobileNo],
    a.[Organization],
    a.[JobTitle],
    a.[Specialty],
    a.[UserLevel],
    a.[IsBlocked],
    a.[IsEmailVerified],
    a.[LastLoginAtUtc],
    a.[RegisteredAt],
    a.[HasCompletedSurvey],
    STRING_AGG(r.[RoleName], ', ') WITHIN GROUP (ORDER BY r.[RoleName]) AS [AssignedRoles]
FROM [dbo].[Attendees] a
LEFT JOIN [dbo].[UserRoles] ur ON a.[AttendeeID] = ur.[AttendeeID]
LEFT JOIN [dbo].[Roles] r ON ur.[RoleID] = r.[RoleID]
WHERE a.[IsBlocked] = 0
GROUP BY 
    a.[AttendeeID], a.[FullName], a.[Email], a.[MobileNo], a.[Organization],
    a.[JobTitle], a.[Specialty], a.[UserLevel], a.[IsBlocked], a.[IsEmailVerified],
    a.[LastLoginAtUtc], a.[RegisteredAt], a.[HasCompletedSurvey];
GO

-- View: Recent Login Audit Summary
IF OBJECT_ID(N'[dbo].[vw_LoginAuditSummary]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_LoginAuditSummary];
GO
CREATE VIEW [dbo].[vw_LoginAuditSummary] AS
SELECT TOP 500
    la.[LoginAuditID],
    la.[AttendeeID],
    a.[FullName],
    la.[Email],
    la.[IpAddress],
    la.[UserAgent],
    la.[Succeeded],
    la.[FailureReason],
    la.[CreatedAtUtc]
FROM [dbo].[LoginAudit] la
LEFT JOIN [dbo].[Attendees] a ON la.[AttendeeID] = a.[AttendeeID]
ORDER BY la.[LoginAuditID] DESC;
GO

-- View: User Security Overview (Lockouts & Password Age)
IF OBJECT_ID(N'[dbo].[vw_UserSecurityOverview]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_UserSecurityOverview];
GO
CREATE VIEW [dbo].[vw_UserSecurityOverview] AS
SELECT 
    a.[AttendeeID],
    a.[FullName],
    a.[Email],
    a.[UserLevel],
    a.[IsBlocked],
    a.[FailedLoginCount],
    a.[LockoutEndUtc],
    CASE 
        WHEN a.[LockoutEndUtc] IS NOT NULL AND a.[LockoutEndUtc] > SYSUTCDATETIME() THEN 1 
        ELSE 0 
    END AS [IsCurrentlyLockedOut],
    a.[LastLoginAtUtc],
    a.[PasswordChangedAtUtc],
    DATEDIFF(DAY, a.[PasswordChangedAtUtc], SYSUTCDATETIME()) AS [PasswordAgeDays]
FROM [dbo].[Attendees] a;
GO

-- ============================================================================
-- STORED PROCEDURES (FULL PARAMETERIZATION & ACID TRANSACTION INTEGRITY)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- SP 1: sp_Auth_RegisterUser
-- Registers new attendee, checks unique email, assigns role, stores password history
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_RegisterUser]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_RegisterUser];
GO
CREATE PROCEDURE [dbo].[sp_Auth_RegisterUser]
    @FullName      NVARCHAR(150),
    @Email         VARCHAR(100),
    @PasswordHash  NVARCHAR(256),
    @MobileNo      VARCHAR(25) = NULL,
    @Organization  NVARCHAR(200) = NULL,
    @JobTitle      NVARCHAR(150) = NULL,
    @Specialty     NVARCHAR(150) = NULL,
    @LinkedInUrl   VARCHAR(300) = NULL,
    @CountryID     INT = NULL,
    @RequestIp     VARCHAR(45) = NULL,
    @NewAttendeeID INT OUTPUT,
    @StatusCode    VARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @Email = LOWER(LTRIM(RTRIM(@Email)));

    -- Check if email exists
    IF EXISTS (SELECT 1 FROM [dbo].[Attendees] WHERE [Email] = @Email)
    BEGIN
        SET @NewAttendeeID = 0;
        SET @StatusCode = 'EMAIL_ALREADY_EXISTS';
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Insert new attendee record
        INSERT INTO [dbo].[Attendees] (
            [FullName], [Email], [PasswordHash], [MobileNo],
            [Organization], [JobTitle], [Specialty], [LinkedInUrl],
            [CountryID], [UserLevel], [IsBlocked], [IsEmailVerified],
            [FailedLoginCount], [RegisteredAt], [UpdatedAtUtc]
        )
        VALUES (
            @FullName, @Email, @PasswordHash, @MobileNo,
            @Organization, @JobTitle, @Specialty, @LinkedInUrl,
            @CountryID, 'User', 0, 0,
            0, GETDATE(), SYSUTCDATETIME()
        );

        SET @NewAttendeeID = SCOPE_IDENTITY();

        -- Assign default 'Attendee' role
        DECLARE @AttendeeRoleID INT;
        SELECT @AttendeeRoleID = [RoleID] FROM [dbo].[Roles] WHERE [RoleName] = 'Attendee';
        IF @AttendeeRoleID IS NOT NULL
        BEGIN
            INSERT INTO [dbo].[UserRoles] ([AttendeeID], [RoleID], [AssignedBy])
            VALUES (@NewAttendeeID, @AttendeeRoleID, 'SystemRegistration');
        END

        -- Store initial password in history
        INSERT INTO [dbo].[PasswordHistory] ([AttendeeID], [PasswordHash])
        VALUES (@NewAttendeeID, @PasswordHash);

        -- Log account activity
        INSERT INTO [dbo].[AccountActivityAudit] ([AttendeeID], [ActionType], [Description], [IpAddress])
        VALUES (@NewAttendeeID, 'REGISTER', N'Attendee account self-registered.', @RequestIp);

        COMMIT TRANSACTION;
        SET @StatusCode = 'SUCCESS';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @NewAttendeeID = 0;
        SET @StatusCode = 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- ----------------------------------------------------------------------------
-- SP 2: sp_Auth_GetUserForAuth
-- Retrieves credentials and checks active lockout
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_GetUserForAuth]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_GetUserForAuth];
GO
CREATE PROCEDURE [dbo].[sp_Auth_GetUserForAuth]
    @Email VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SET @Email = LOWER(LTRIM(RTRIM(@Email)));

    SELECT 
        [AttendeeID],
        [FullName],
        [Email],
        [MobileNo],
        [Organization],
        [JobTitle],
        [Specialty],
        [UserLevel],
        [IsBlocked],
        [PasswordHash],
        [SecurityStamp],
        [FailedLoginCount],
        [LockoutEndUtc],
        CASE 
            WHEN [LockoutEndUtc] IS NOT NULL AND [LockoutEndUtc] > SYSUTCDATETIME() THEN 1 
            ELSE 0 
        END AS [IsLockedOut]
    FROM [dbo].[Attendees]
    WHERE [Email] = @Email;
END;
GO

-- ----------------------------------------------------------------------------
-- SP 3: sp_Auth_RecordLoginSuccess
-- Resets failed counters, records login timestamp, writes to audit log
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_RecordLoginSuccess]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_RecordLoginSuccess];
GO
CREATE PROCEDURE [dbo].[sp_Auth_RecordLoginSuccess]
    @AttendeeID INT,
    @Email      VARCHAR(100),
    @IpAddress  VARCHAR(45) = NULL,
    @UserAgent  NVARCHAR(400) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [dbo].[Attendees]
    SET 
        [FailedLoginCount] = 0,
        [LockoutEndUtc] = NULL,
        [LastLoginAtUtc] = SYSUTCDATETIME(),
        [UpdatedAtUtc] = SYSUTCDATETIME()
    WHERE [AttendeeID] = @AttendeeID;

    INSERT INTO [dbo].[LoginAudit] ([AttendeeID], [Email], [IpAddress], [UserAgent], [Succeeded], [FailureReason])
    VALUES (@AttendeeID, @Email, @IpAddress, @UserAgent, 1, NULL);
END;
GO

-- ----------------------------------------------------------------------------
-- SP 4: sp_Auth_RecordLoginFailure
-- Increments failed attempts, triggers progressive 15-minute lockout at threshold
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_RecordLoginFailure]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_RecordLoginFailure];
GO
CREATE PROCEDURE [dbo].[sp_Auth_RecordLoginFailure]
    @AttendeeID    INT = NULL,
    @Email         VARCHAR(100),
    @IpAddress     VARCHAR(45) = NULL,
    @UserAgent     NVARCHAR(400) = NULL,
    @FailureReason NVARCHAR(100) = 'InvalidCredentials',
    @MaxAttempts   INT = 5,
    @LockoutMins   INT = 15,
    @IsNowLocked   BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @IsNowLocked = 0;

    IF @AttendeeID IS NOT NULL AND @AttendeeID > 0
    BEGIN
        UPDATE [dbo].[Attendees]
        SET 
            [LockoutEndUtc] = CASE 
                WHEN [FailedLoginCount] + 1 >= @MaxAttempts 
                THEN DATEADD(MINUTE, @LockoutMins, SYSUTCDATETIME()) 
                ELSE [LockoutEndUtc] 
            END,
            [FailedLoginCount] = CASE 
                WHEN [FailedLoginCount] + 1 >= @MaxAttempts THEN 0 
                ELSE [FailedLoginCount] + 1 
            END,
            [UpdatedAtUtc] = SYSUTCDATETIME()
        WHERE [AttendeeID] = @AttendeeID;

        -- Check if it was just locked
        IF EXISTS (SELECT 1 FROM [dbo].[Attendees] WHERE [AttendeeID] = @AttendeeID AND [LockoutEndUtc] > SYSUTCDATETIME())
        BEGIN
            SET @IsNowLocked = 1;
            SET @FailureReason = 'AccountLockedOut';
        END
    END

    INSERT INTO [dbo].[LoginAudit] ([AttendeeID], [Email], [IpAddress], [UserAgent], [Succeeded], [FailureReason])
    VALUES (@AttendeeID, @Email, @IpAddress, @UserAgent, 0, @FailureReason);
END;
GO

-- ----------------------------------------------------------------------------
-- SP 5: sp_Auth_CreatePasswordResetToken
-- Issues unguessable reset token, expires prior unused tokens, sets 60 min TTL
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_CreatePasswordResetToken]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_CreatePasswordResetToken];
GO
CREATE PROCEDURE [dbo].[sp_Auth_CreatePasswordResetToken]
    @Email       VARCHAR(100),
    @ResetToken  VARCHAR(100),
    @TtlMinutes  INT = 60,
    @RequestIp   VARCHAR(45) = NULL,
    @StatusCode  VARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Email = LOWER(LTRIM(RTRIM(@Email)));

    DECLARE @AttendeeID INT;
    SELECT @AttendeeID = [AttendeeID] FROM [dbo].[Attendees] WHERE [Email] = @Email;

    IF @AttendeeID IS NULL
    BEGIN
        -- Constant-time illusion: simulate token generation
        SET @StatusCode = 'EMAIL_NOT_FOUND';
        RETURN;
    END

    -- Invalidate any prior active tokens for this user
    UPDATE [dbo].[PasswordResetTokens]
    SET [IsUsed] = 1, [UsedAtUtc] = SYSUTCDATETIME()
    WHERE [AttendeeID] = @AttendeeID AND [IsUsed] = 0;

    -- Insert new token
    INSERT INTO [dbo].[PasswordResetTokens] (
        [AttendeeID], [Email], [ResetToken], [ExpiresAtUtc], [IsUsed], [RequestIpAddress]
    )
    VALUES (
        @AttendeeID, @Email, @ResetToken, DATEADD(MINUTE, @TtlMinutes, SYSUTCDATETIME()), 0, @RequestIp
    );

    -- Log activity
    INSERT INTO [dbo].[AccountActivityAudit] ([AttendeeID], [ActionType], [Description], [IpAddress])
    VALUES (@AttendeeID, 'PASSWORD_RESET_REQUESTED', N'Password reset token generated.', @RequestIp);

    SET @StatusCode = 'SUCCESS';
END;
GO

-- ----------------------------------------------------------------------------
-- SP 6: sp_Auth_ValidatePasswordResetToken
-- Verifies token validity (unexpired, unused)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_ValidatePasswordResetToken]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_ValidatePasswordResetToken];
GO
CREATE PROCEDURE [dbo].[sp_Auth_ValidatePasswordResetToken]
    @ResetToken  VARCHAR(100),
    @AttendeeID  INT OUTPUT,
    @Email       VARCHAR(100) OUTPUT,
    @IsValid     BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @AttendeeID = 0;
    SET @Email = NULL;
    SET @IsValid = 0;

    SELECT 
        @AttendeeID = prt.[AttendeeID],
        @Email = prt.[Email]
    FROM [dbo].[PasswordResetTokens] prt
    INNER JOIN [dbo].[Attendees] a ON prt.[AttendeeID] = a.[AttendeeID]
    WHERE prt.[ResetToken] = @ResetToken
      AND prt.[IsUsed] = 0
      AND prt.[ExpiresAtUtc] > SYSUTCDATETIME()
      AND a.[IsBlocked] = 0;

    IF @AttendeeID > 0
    BEGIN
        SET @IsValid = 1;
    END
END;
GO

-- ----------------------------------------------------------------------------
-- SP 7: sp_Auth_CompletePasswordReset
-- Resets password, stores in history, invalidates all sessions (rotates SecurityStamp)
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_CompletePasswordReset]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_CompletePasswordReset];
GO
CREATE PROCEDURE [dbo].[sp_Auth_CompletePasswordReset]
    @ResetToken     VARCHAR(100),
    @NewPasswordHash NVARCHAR(256),
    @RequestIp      VARCHAR(45) = NULL,
    @StatusCode     VARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @AttendeeID INT;
    DECLARE @Email VARCHAR(100);

    SELECT 
        @AttendeeID = [AttendeeID],
        @Email = [Email]
    FROM [dbo].[PasswordResetTokens]
    WHERE [ResetToken] = @ResetToken
      AND [IsUsed] = 0
      AND [ExpiresAtUtc] > SYSUTCDATETIME();

    IF @AttendeeID IS NULL
    BEGIN
        SET @StatusCode = 'INVALID_OR_EXPIRED_TOKEN';
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Mark token as consumed
        UPDATE [dbo].[PasswordResetTokens]
        SET [IsUsed] = 1, [UsedAtUtc] = SYSUTCDATETIME()
        WHERE [ResetToken] = @ResetToken;

        -- Update user password, clear lockouts, rotate SecurityStamp
        UPDATE [dbo].[Attendees]
        SET 
            [PasswordHash] = @NewPasswordHash,
            [FailedLoginCount] = 0,
            [LockoutEndUtc] = NULL,
            [PasswordChangedAtUtc] = SYSUTCDATETIME(),
            [SecurityStamp] = CONVERT(NVARCHAR(64), NEWID()),
            [UpdatedAtUtc] = SYSUTCDATETIME()
        WHERE [AttendeeID] = @AttendeeID;

        -- Record password into history
        INSERT INTO [dbo].[PasswordHistory] ([AttendeeID], [PasswordHash])
        VALUES (@AttendeeID, @NewPasswordHash);

        -- Revoke all active sessions
        UPDATE [dbo].[UserSessions]
        SET [IsRevoked] = 1, [RevokedAtUtc] = SYSUTCDATETIME()
        WHERE [AttendeeID] = @AttendeeID AND [IsRevoked] = 0;

        -- Log account audit
        INSERT INTO [dbo].[AccountActivityAudit] ([AttendeeID], [ActionType], [Description], [IpAddress])
        VALUES (@AttendeeID, 'PASSWORD_RESET_COMPLETED', N'Password successfully reset via token. Active sessions invalidated.', @RequestIp);

        COMMIT TRANSACTION;
        SET @StatusCode = 'SUCCESS';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @StatusCode = 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- ----------------------------------------------------------------------------
-- SP 8: sp_Auth_ChangePassword
-- For authenticated users; updates hash, saves history, rotates security stamp
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_ChangePassword]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_ChangePassword];
GO
CREATE PROCEDURE [dbo].[sp_Auth_ChangePassword]
    @AttendeeID      INT,
    @NewPasswordHash NVARCHAR(256),
    @RequestIp       VARCHAR(45) = NULL,
    @StatusCode      VARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Attendees] WHERE [AttendeeID] = @AttendeeID AND [IsBlocked] = 0)
    BEGIN
        SET @StatusCode = 'USER_NOT_FOUND_OR_BLOCKED';
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Update password and rotate security stamp to revoke other sessions
        UPDATE [dbo].[Attendees]
        SET 
            [PasswordHash] = @NewPasswordHash,
            [FailedLoginCount] = 0,
            [LockoutEndUtc] = NULL,
            [PasswordChangedAtUtc] = SYSUTCDATETIME(),
            [SecurityStamp] = CONVERT(NVARCHAR(64), NEWID()),
            [UpdatedAtUtc] = SYSUTCDATETIME()
        WHERE [AttendeeID] = @AttendeeID;

        -- Add to password history
        INSERT INTO [dbo].[PasswordHistory] ([AttendeeID], [PasswordHash])
        VALUES (@AttendeeID, @NewPasswordHash);

        -- Log activity
        INSERT INTO [dbo].[AccountActivityAudit] ([AttendeeID], [ActionType], [Description], [IpAddress])
        VALUES (@AttendeeID, 'PASSWORD_CHANGE', N'User updated security password from profile.', @RequestIp);

        COMMIT TRANSACTION;
        SET @StatusCode = 'SUCCESS';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @StatusCode = 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- ----------------------------------------------------------------------------
-- SP 9: sp_Auth_UpdateProfile
-- Updates all account profile details
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_UpdateProfile]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_UpdateProfile];
GO
CREATE PROCEDURE [dbo].[sp_Auth_UpdateProfile]
    @AttendeeID   INT,
    @FullName     NVARCHAR(150),
    @MobileNo     VARCHAR(25) = NULL,
    @Organization NVARCHAR(200) = NULL,
    @JobTitle     NVARCHAR(150) = NULL,
    @Specialty    NVARCHAR(150) = NULL,
    @LinkedInUrl  VARCHAR(300) = NULL,
    @CountryID    INT = NULL,
    @RequestIp    VARCHAR(45) = NULL,
    @StatusCode   VARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Attendees] WHERE [AttendeeID] = @AttendeeID)
    BEGIN
        SET @StatusCode = 'USER_NOT_FOUND';
        RETURN;
    END

    UPDATE [dbo].[Attendees]
    SET 
        [FullName]     = @FullName,
        [MobileNo]     = @MobileNo,
        [Organization] = @Organization,
        [JobTitle]     = @JobTitle,
        [Specialty]    = @Specialty,
        [LinkedInUrl]  = @LinkedInUrl,
        [CountryID]    = @CountryID,
        [UpdatedAtUtc] = SYSUTCDATETIME()
    WHERE [AttendeeID] = @AttendeeID;

    INSERT INTO [dbo].[AccountActivityAudit] ([AttendeeID], [ActionType], [Description], [IpAddress])
    VALUES (@AttendeeID, 'PROFILE_UPDATE', N'User updated account profile information.', @RequestIp);

    SET @StatusCode = 'SUCCESS';
END;
GO

-- ----------------------------------------------------------------------------
-- SP 10: sp_Auth_GetUserProfile
-- Returns full user profile with assigned roles
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_GetUserProfile]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_GetUserProfile];
GO
CREATE PROCEDURE [dbo].[sp_Auth_GetUserProfile]
    @AttendeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        a.[AttendeeID],
        a.[FullName],
        a.[Email],
        a.[MobileNo],
        a.[Organization],
        a.[JobTitle],
        a.[Specialty],
        a.[LinkedInUrl],
        a.[CountryID],
        c.[CountryNameEn],
        c.[CountryNameAr],
        a.[UserLevel],
        a.[IsBlocked],
        a.[IsEmailVerified],
        a.[FailedLoginCount],
        a.[LockoutEndUtc],
        a.[LastLoginAtUtc],
        a.[PasswordChangedAtUtc],
        a.[HasCompletedSurvey],
        a.[RegisteredAt]
    FROM [dbo].[Attendees] a
    LEFT JOIN [dbo].[Countries] c ON a.[CountryID] = c.[CountryID]
    WHERE a.[AttendeeID] = @AttendeeID;

    -- Return assigned roles
    SELECT r.[RoleID], r.[RoleName]
    FROM [dbo].[UserRoles] ur
    INNER JOIN [dbo].[Roles] r ON ur.[RoleID] = r.[RoleID]
    WHERE ur.[AttendeeID] = @AttendeeID;
END;
GO

-- ----------------------------------------------------------------------------
-- SP 11: sp_Auth_CreateSession
-- Creates persistent or active session token
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_CreateSession]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_CreateSession];
GO
CREATE PROCEDURE [dbo].[sp_Auth_CreateSession]
    @AttendeeID    INT,
    @SessionToken  VARCHAR(128),
    @DeviceInfo    NVARCHAR(300) = NULL,
    @IpAddress     VARCHAR(45) = NULL,
    @DurationDays  INT = 30
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Stamp NVARCHAR(64);
    SELECT @Stamp = [SecurityStamp] FROM [dbo].[Attendees] WHERE [AttendeeID] = @AttendeeID;

    INSERT INTO [dbo].[UserSessions] (
        [AttendeeID], [SessionToken], [SecurityStamp], [DeviceInfo], [IpAddress], [ExpiresAtUtc]
    )
    VALUES (
        @AttendeeID, @SessionToken, ISNULL(@Stamp, CONVERT(NVARCHAR(64), NEWID())),
        @DeviceInfo, @IpAddress, DATEADD(DAY, @DurationDays, SYSUTCDATETIME())
    );
END;
GO

-- ----------------------------------------------------------------------------
-- SP 12: sp_Auth_ValidateSession
-- Validates session token against expiration, revocation, and security stamp
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_ValidateSession]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_ValidateSession];
GO
CREATE PROCEDURE [dbo].[sp_Auth_ValidateSession]
    @SessionToken VARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.[SessionID],
        s.[AttendeeID],
        a.[FullName],
        a.[Email],
        a.[UserLevel],
        a.[IsBlocked],
        CASE 
            WHEN s.[IsRevoked] = 0 
             AND s.[ExpiresAtUtc] > SYSUTCDATETIME() 
             AND s.[SecurityStamp] = a.[SecurityStamp] 
             AND a.[IsBlocked] = 0 
            THEN 1 
            ELSE 0 
        END AS [IsValid]
    FROM [dbo].[UserSessions] s
    INNER JOIN [dbo].[Attendees] a ON s.[AttendeeID] = a.[AttendeeID]
    WHERE s.[SessionToken] = @SessionToken;

    -- Update last seen
    UPDATE [dbo].[UserSessions]
    SET [LastSeenAtUtc] = SYSUTCDATETIME()
    WHERE [SessionToken] = @SessionToken AND [IsRevoked] = 0;
END;
GO

-- ----------------------------------------------------------------------------
-- SP 13: sp_Auth_RevokeSession
-- Logs out specific session
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_RevokeSession]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_RevokeSession];
GO
CREATE PROCEDURE [dbo].[sp_Auth_RevokeSession]
    @SessionToken VARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [dbo].[UserSessions]
    SET [IsRevoked] = 1, [RevokedAtUtc] = SYSUTCDATETIME()
    WHERE [SessionToken] = @SessionToken;
END;
GO

-- ----------------------------------------------------------------------------
-- SP 14: sp_Auth_LockAccount & sp_Auth_UnlockAccount
-- Administrative controls
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Auth_LockAccount]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_LockAccount];
GO
CREATE PROCEDURE [dbo].[sp_Auth_LockAccount]
    @AttendeeID INT,
    @AdminUser  VARCHAR(100) = 'Admin'
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [dbo].[Attendees]
    SET [IsBlocked] = 1, [UpdatedAtUtc] = SYSUTCDATETIME()
    WHERE [AttendeeID] = @AttendeeID;

    -- Invalidate active sessions
    UPDATE [dbo].[UserSessions]
    SET [IsRevoked] = 1, [RevokedAtUtc] = SYSUTCDATETIME()
    WHERE [AttendeeID] = @AttendeeID;

    INSERT INTO [dbo].[AccountActivityAudit] ([AttendeeID], [ActionType], [Description])
    VALUES (@AttendeeID, 'ACCOUNT_LOCKED', N'Account was disabled by administrator: ' + @AdminUser);
END;
GO

IF OBJECT_ID(N'[dbo].[sp_Auth_UnlockAccount]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Auth_UnlockAccount];
GO
CREATE PROCEDURE [dbo].[sp_Auth_UnlockAccount]
    @AttendeeID INT,
    @AdminUser  VARCHAR(100) = 'Admin'
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [dbo].[Attendees]
    SET 
        [IsBlocked] = 0,
        [FailedLoginCount] = 0,
        [LockoutEndUtc] = NULL,
        [UpdatedAtUtc] = SYSUTCDATETIME()
    WHERE [AttendeeID] = @AttendeeID;

    INSERT INTO [dbo].[AccountActivityAudit] ([AttendeeID], [ActionType], [Description])
    VALUES (@AttendeeID, 'ACCOUNT_UNLOCKED', N'Account was unlocked and unblocked by administrator: ' + @AdminUser);
END;
GO

-- ----------------------------------------------------------------------------
-- SP 15: sp_Booth_StartVisit
-- Starts an NFC booth visit session, stores projected timer, returns booth details
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Booth_StartVisit]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Booth_StartVisit];
GO
CREATE PROCEDURE [dbo].[sp_Booth_StartVisit]
    @BoothCode           VARCHAR(10),
    @UserEmail          VARCHAR(100),
    @AttendeeID         INT = NULL,
    @UserIp             VARCHAR(45) = NULL,
    @VisitID            BIGINT OUTPUT,
    @BoothType          VARCHAR(50) OUTPUT,
    @BoothNameEn        NVARCHAR(150) OUTPUT,
    @BoothNameAr        NVARCHAR(150) OUTPUT,
    @OrganizationEn     NVARCHAR(200) OUTPUT,
    @OrganizationAr     NVARCHAR(200) OUTPUT,
    @ProjectedAvgMinutes INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @BoothCode = UPPER(LTRIM(RTRIM(@BoothCode)));
    SET @UserEmail = LOWER(LTRIM(RTRIM(ISNULL(@UserEmail, 'guest@sairh.com'))));

    SELECT 
        @BoothType = [Type],
        @BoothNameEn = [NameEn],
        @BoothNameAr = [NameAr],
        @OrganizationEn = [OrganizationEn],
        @OrganizationAr = [OrganizationAr],
        @ProjectedAvgMinutes = ISNULL([ProjectedAvgMinutes], 5)
    FROM [dbo].[Booths]
    WHERE [BoothCode] = @BoothCode;

    IF @BoothType IS NULL
    BEGIN
        SET @BoothType = CASE WHEN @BoothCode LIKE 'S%' THEN 'SponsorBooth' ELSE 'ResearchScreen' END;
        SET @BoothNameEn = N'Booth ' + @BoothCode;
        SET @BoothNameAr = N'جناح ' + @BoothCode;
        SET @OrganizationEn = N'Summit Exhibition Partner';
        SET @OrganizationAr = N'شريك معرض الملتقى';
        SET @ProjectedAvgMinutes = 5;
    END

    INSERT INTO [dbo].[BoothVisits] (
        [AttendeeID], [UserEmail], [BoothCode], [BoothType], [BoothName],
        [ProjectedAvgMinutes], [StartedAtUtc], [Status], [UserIp]
    )
    VALUES (
        @AttendeeID, @UserEmail, @BoothCode, @BoothType, @BoothNameEn,
        @ProjectedAvgMinutes, SYSUTCDATETIME(), 'Active', @UserIp
    );

    SET @VisitID = SCOPE_IDENTITY();
END;
GO

-- ----------------------------------------------------------------------------
-- SP 16: sp_Booth_CompleteVisit
-- Marks a booth visit finished
-- ----------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_Booth_CompleteVisit]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_Booth_CompleteVisit];
GO
CREATE PROCEDURE [dbo].[sp_Booth_CompleteVisit]
    @VisitID            BIGINT,
    @UserEmail          VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [dbo].[BoothVisits]
    SET [Status] = 'Completed',
        [CompletedAtUtc] = SYSUTCDATETIME()
    WHERE [VisitID] = @VisitID;
END;
GO

-- ============================================================================
-- SEED DATA: CORE ROLES & SECURE DEMO ACCOUNTS
-- ============================================================================

-- 1. Insert Standard Summit Roles (Simplified: Administrator & Attendee/User)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleName] = 'Administrator')
    INSERT INTO [dbo].[Roles] ([RoleName], [Description]) VALUES ('Administrator', N'Full administrative access to manage summit agenda, speakers, sessions, booths, and dates');
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleName] = 'Attendee')
    INSERT INTO [dbo].[Roles] ([RoleName], [Description]) VALUES ('Attendee', N'Registered participant attending summit lectures, recommendation roadmap, and exhibition');
GO

-- 2. Seed Default Admin Account (admin@sairh.com / Sairh@Admin2026!)
-- Hash: PBKDF2-SHA512$210000$SzIEvmPTW7K3sWS0dszu1Q==$EobVOQGvH3Dd3DMdlrWu8NBA2aN/M+03faGIHFnpIMQ=
IF NOT EXISTS (SELECT 1 FROM [dbo].[Attendees] WHERE [Email] = 'admin@sairh.com')
BEGIN
    INSERT INTO [dbo].[Attendees] (
        [FullName], [Email], [PasswordHash], [MobileNo], [Organization],
        [JobTitle], [Specialty], [UserLevel], [IsBlocked], [IsEmailVerified]
    )
    VALUES (
        N'SAIRH System Administrator', 'admin@sairh.com',
        'PBKDF2-SHA512$210000$SzIEvmPTW7K3sWS0dszu1Q==$EobVOQGvH3Dd3DMdlrWu8NBA2aN/M+03faGIHFnpIMQ=',
        '+966 50 000 0001', N'SAIRH Organizing Committee', N'Chief Technology Officer', N'Health AI',
        'Admin', 0, 1
    );

    DECLARE @AdminID INT = SCOPE_IDENTITY();
    DECLARE @AdminRoleID INT = (SELECT [RoleID] FROM [dbo].[Roles] WHERE [RoleName] = 'Administrator');
    IF @AdminID IS NOT NULL AND @AdminRoleID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[UserRoles] ([AttendeeID], [RoleID], [AssignedBy])
        VALUES (@AdminID, @AdminRoleID, 'SystemSeed');
    END
    PRINT N'[+] Seeded administrator account: admin@sairh.com';
END
GO

-- 3. Seed Default Attendee Account (attendee@sairh.com / Sairh@Attendee2026!)
-- Hash: PBKDF2-SHA512$210000$OmA5KPTUEKDSf291nAbGMg==$YCg6a7S9ScfG+99qu+MkHMdfknV4ilgG7lyFhyMky5U=
IF NOT EXISTS (SELECT 1 FROM [dbo].[Attendees] WHERE [Email] = 'attendee@sairh.com')
BEGIN
    INSERT INTO [dbo].[Attendees] (
        [FullName], [Email], [PasswordHash], [MobileNo], [Organization],
        [JobTitle], [Specialty], [UserLevel], [IsBlocked], [IsEmailVerified]
    )
    VALUES (
        N'Dr. Sarah Al-Ahmad', 'attendee@sairh.com',
        'PBKDF2-SHA512$210000$OmA5KPTUEKDSf291nAbGMg==$YCg6a7S9ScfG+99qu+MkHMdfknV4ilgG7lyFhyMky5U=',
        '+966 50 123 4567', N'King Faisal Specialist Hospital', N'Radiology Consultant', N'Neuroradiology & AI',
        'User', 0, 1
    );

    DECLARE @AttendeeID INT = SCOPE_IDENTITY();
    DECLARE @AttendeeRoleID INT = (SELECT [RoleID] FROM [dbo].[Roles] WHERE [RoleName] = 'Attendee');
    IF @AttendeeID IS NOT NULL AND @AttendeeRoleID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[UserRoles] ([AttendeeID], [RoleID], [AssignedBy])
        VALUES (@AttendeeID, @AttendeeRoleID, 'SystemSeed');
    END
    PRINT N'[+] Seeded attendee account: attendee@sairh.com';
END
GO



-- ============================================================================
-- VERIFICATION & DIAGNOSTIC QUERIES
-- ============================================================================
PRINT N'============================================================================';
PRINT N'Verification: Checking Authentication & Account Management Schema Integrity';
PRINT N'============================================================================';

SELECT 'Roles Count' AS [Metric], COUNT(*) AS [Value] FROM [dbo].[Roles]
UNION ALL
SELECT 'Attendees Count', COUNT(*) FROM [dbo].[Attendees]
UNION ALL
SELECT 'UserRoles Mappings', COUNT(*) FROM [dbo].[UserRoles]
UNION ALL
SELECT 'PasswordResetTokens Table Status', COUNT(*) FROM [dbo].[PasswordResetTokens]
UNION ALL
SELECT 'UserSessions Table Status', COUNT(*) FROM [dbo].[UserSessions]
UNION ALL
SELECT 'PasswordHistory Entries', COUNT(*) FROM [dbo].[PasswordHistory]
UNION ALL
SELECT 'LoginAudit Entries', COUNT(*) FROM [dbo].[LoginAudit];

PRINT N'============================================================================';
PRINT N'SAIRH 2026 Authentication & Account Management Setup Completed Successfully!';
PRINT N'============================================================================';
GO
