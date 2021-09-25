/*
Скрипт развертывания для KSPBD

Этот код был создан программным средством.
Изменения, внесенные в этот файл, могут привести к неверному выполнению кода и будут потеряны
в случае его повторного формирования.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "KSPBD"
:setvar DefaultFilePrefix "KSPBD"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Проверьте режим SQLCMD и отключите выполнение скрипта, если режим SQLCMD не поддерживается.
Чтобы повторно включить скрипт после включения режима SQLCMD выполните следующую инструкцию:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Для успешного выполнения этого скрипта должен быть включен режим SQLCMD.';
        SET NOEXEC ON;
    END


GO
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Идет создание базы данных $(DatabaseName)…'
GO
CREATE DATABASE [$(DatabaseName)] COLLATE Cyrillic_General_CI_AI
GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Параметры базы данных изменить нельзя. Применить эти параметры может только пользователь SysAdmin.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Параметры базы данных изменить нельзя. Применить эти параметры может только пользователь SysAdmin.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Идет создание Таблица [dbo].[LogEvent]…';


GO
CREATE TABLE [dbo].[LogEvent] (
    [Id]              INT             IDENTITY (1, 1) NOT NULL,
    [IdLogTableField] INT             NOT NULL,
    [IdObj]           INT             NOT NULL,
    [OperType]        NVARCHAR (1)    NOT NULL,
    [OperTime]        DATETIME        NOT NULL,
    [User]            NVARCHAR (100)  NOT NULL,
    [OldVal]          NVARCHAR (1500) NULL,
    [NewVal]          NVARCHAR (1500) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[TitleOwnershipDeed]…';


GO
CREATE TABLE [dbo].[TitleOwnershipDeed] (
    [Id]                     INT              IDENTITY (1, 1) NOT NULL,
    [FK_MeasuringInstrument] INT              NOT NULL,
    [FK_Document]            INT              NOT NULL,
    [IdExt]                  INT              NULL,
    [GuidExt]                UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[TitleOwnershipDeed].[IX_TitleOwnershipDeed_FK_MeasuringInstrument]…';


GO
CREATE NONCLUSTERED INDEX [IX_TitleOwnershipDeed_FK_MeasuringInstrument]
    ON [dbo].[TitleOwnershipDeed]([FK_MeasuringInstrument] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[TitleOwnershipDeed].[IX_TitleOwnershipDeed_FK_Document]…';


GO
CREATE NONCLUSTERED INDEX [IX_TitleOwnershipDeed_FK_Document]
    ON [dbo].[TitleOwnershipDeed]([FK_Document] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[MiGroupDocument]…';


GO
CREATE TABLE [dbo].[MiGroupDocument] (
    [Id]          INT              IDENTITY (1, 1) NOT NULL,
    [FK_Document] INT              NOT NULL,
    [FK_MiGroup]  INT              NOT NULL,
    [IdExt]       INT              NULL,
    [GuidExt]     UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[MiGroupDocument].[IX_MiGroupDocument_FK_Document]…';


GO
CREATE NONCLUSTERED INDEX [IX_MiGroupDocument_FK_Document]
    ON [dbo].[MiGroupDocument]([FK_Document] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[MiGroupDocument].[IX_MiGroupDocument_FK_MiGroup]…';


GO
CREATE NONCLUSTERED INDEX [IX_MiGroupDocument_FK_MiGroup]
    ON [dbo].[MiGroupDocument]([FK_MiGroup] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[MiGroupDocument].[IX_MiGroupDocument_IdExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_MiGroupDocument_IdExt]
    ON [dbo].[MiGroupDocument]([IdExt] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[MiGroupDocument].[IX_MiGroupDocument_GuidExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_MiGroupDocument_GuidExt]
    ON [dbo].[MiGroupDocument]([GuidExt] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[DocumentType]…';


GO
CREATE TABLE [dbo].[DocumentType] (
    [Id]      INT              IDENTITY (1, 1) NOT NULL,
    [Name]    NVARCHAR (10)    NULL,
    [IdExt]   INT              NULL,
    [GuidExt] UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[DocumentType].[IX_DocumentType_GuidExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_DocumentType_GuidExt]
    ON [dbo].[DocumentType]([GuidExt] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[DocumentType].[IX_DocumentType_IdExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_DocumentType_IdExt]
    ON [dbo].[DocumentType]([IdExt] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[Organization]…';


GO
CREATE TABLE [dbo].[Organization] (
    [Id]        INT              IDENTITY (1, 1) NOT NULL,
    [Name]      NVARCHAR (300)   NOT NULL,
    [Country]   NVARCHAR (100)   NULL,
    [Region]    NVARCHAR (200)   NULL,
    [LegalForm] NVARCHAR (10)    NULL,
    [IdExt]     INT              NULL,
    [GuidExt]   UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Name] ASC, [Country] ASC, [Region] ASC, [LegalForm] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[Organization].[IX_Organization_IdExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_Organization_IdExt]
    ON [dbo].[Organization]([IdExt] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[Organization].[IX_Organization_GuidExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_Organization_GuidExt]
    ON [dbo].[Organization]([GuidExt] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[InstallationLocation]…';


GO
CREATE TABLE [dbo].[InstallationLocation] (
    [Id]      INT              IDENTITY (1, 1) NOT NULL,
    [Name]    NVARCHAR (300)   NULL,
    [IdExt]   INT              NULL,
    [GuidExt] UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[InstallationLocation].[IX_InstallationLocation_IdExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_InstallationLocation_IdExt]
    ON [dbo].[InstallationLocation]([IdExt] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[InstallationLocation].[IX_InstallationLocation_GuidExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_InstallationLocation_GuidExt]
    ON [dbo].[InstallationLocation]([GuidExt] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[Document]…';


GO
CREATE TABLE [dbo].[Document] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (400) NULL,
    [Date]            DATE           NULL,
    [Number]          NVARCHAR (100) NULL,
    [FK_DocumentType] INT            NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[Document].[IX_Document_FK_DocumentType]…';


GO
CREATE NONCLUSTERED INDEX [IX_Document_FK_DocumentType]
    ON [dbo].[Document]([FK_DocumentType] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[VerificationTool]…';


GO
CREATE TABLE [dbo].[VerificationTool] (
    [Id]                      INT              IDENTITY (1, 1) NOT NULL,
    [Name]                    NVARCHAR (1200)  NULL,
    [VerificationNumber]      NVARCHAR (32)    NULL,
    [FirsVerificationNumber]  NVARCHAR (32)    NULL,
    [MiVerificationNumber]    NVARCHAR (32)    NULL,
    [CertificateNumber]       NVARCHAR (30)    NULL,
    [CertificateDate]         DATE             NULL,
    [ValidityCertificateDate] DATE             NULL,
    [FK_MeasuringInstrument]  INT              NOT NULL,
    [Range]                   NVARCHAR (300)   NULL,
    [Characteristic]          NVARCHAR (200)   NULL,
    [Discharge]               NVARCHAR (100)   NULL,
    [LINKNNFIF]               NVARCHAR (500)   NULL,
    [IdExt]                   INT              NULL,
    [GuidExt]                 UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[VerificationTool].[IX_VerificationTool_FK_MeasuringInstrument]…';


GO
CREATE NONCLUSTERED INDEX [IX_VerificationTool_FK_MeasuringInstrument]
    ON [dbo].[VerificationTool]([FK_MeasuringInstrument] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[TypeSi]…';


GO
CREATE TABLE [dbo].[TypeSi] (
    [Id]          INT              IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (300)   NOT NULL,
    [Designation] NVARCHAR (200)   NOT NULL,
    [IdExt]       INT              NULL,
    [GuidExt]     UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[TypeSi].[IX_TypeSi_IdExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_TypeSi_IdExt]
    ON [dbo].[TypeSi]([IdExt] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[TypeSi].[IX_TypeSi_GuidExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_TypeSi_GuidExt]
    ON [dbo].[TypeSi]([GuidExt] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[MiGroup]…';


GO
CREATE TABLE [dbo].[MiGroup] (
    [Id]                  INT              IDENTITY (1, 1) NOT NULL,
    [Code]                NVARCHAR (10)    NOT NULL,
    [Name]                NVARCHAR (200)   NOT NULL,
    [Characteristic]      NVARCHAR (300)   NOT NULL,
    [Range]               NVARCHAR (300)   NOT NULL,
    [FK_MeasurementField] INT              NOT NULL,
    [IdExt]               INT              NULL,
    [GuidExt]             UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Characteristic] ASC, [Range] ASC),
    UNIQUE NONCLUSTERED ([Code] ASC, [FK_MeasurementField] ASC, [Characteristic] ASC, [Range] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[MiGroup].[IX_MiGroup_FK_MeasurementField]…';


GO
CREATE NONCLUSTERED INDEX [IX_MiGroup_FK_MeasurementField]
    ON [dbo].[MiGroup]([FK_MeasurementField] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[MiGroup].[IX_MiGroup_GuidExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_MiGroup_GuidExt]
    ON [dbo].[MiGroup]([GuidExt] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[MiGroup].[IX_MiGroup_IdExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_MiGroup_IdExt]
    ON [dbo].[MiGroup]([IdExt] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[MeasuringInstrument]…';


GO
CREATE TABLE [dbo].[MeasuringInstrument] (
    [Id]                      INT              IDENTITY (1, 1) NOT NULL,
    [FactoryNumber]           NVARCHAR (100)   NULL,
    [InventoryNumber]         NVARCHAR (100)   NULL,
    [FK_TypeSi]               INT              NOT NULL,
    [RegistrationNumber]      NVARCHAR (50)    NULL,
    [FK_Ownership]            INT              NULL,
    [FK_InstallationLocation] INT              NULL,
    [IssueDate]               DATE             NULL,
    [CommissioningDate]       DATE             NULL,
    [FK_Manufacturer]         INT              NULL,
    [IdExt]                   INT              NULL,
    [GuidExt]                 UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[MeasuringInstrument].[IX_MeasuringInstrument_FK_TypeSi]…';


GO
CREATE NONCLUSTERED INDEX [IX_MeasuringInstrument_FK_TypeSi]
    ON [dbo].[MeasuringInstrument]([FK_TypeSi] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[MeasuringInstrument].[IX_MeasuringInstrument_FK_Ownership]…';


GO
CREATE NONCLUSTERED INDEX [IX_MeasuringInstrument_FK_Ownership]
    ON [dbo].[MeasuringInstrument]([FK_Ownership] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[MeasuringInstrument].[IX_MeasuringInstrument_FK_InstallationLocation]…';


GO
CREATE NONCLUSTERED INDEX [IX_MeasuringInstrument_FK_InstallationLocation]
    ON [dbo].[MeasuringInstrument]([FK_InstallationLocation] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[MeasuringInstrument].[IX_MeasuringInstrument_FK_Manufacturer]…';


GO
CREATE NONCLUSTERED INDEX [IX_MeasuringInstrument_FK_Manufacturer]
    ON [dbo].[MeasuringInstrument]([FK_Manufacturer] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[MeasuringInstrument].[IX_MeasuringInstrument_IdExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_MeasuringInstrument_IdExt]
    ON [dbo].[MeasuringInstrument]([IdExt] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[MeasuringInstrument].[IX_MeasuringInstrument_GuidExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_MeasuringInstrument_GuidExt]
    ON [dbo].[MeasuringInstrument]([GuidExt] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[MeasurementField]…';


GO
CREATE TABLE [dbo].[MeasurementField] (
    [Id]      INT              IDENTITY (1, 1) NOT NULL,
    [Name]    NVARCHAR (200)   NULL,
    [Code]    NVARCHAR (10)    NULL,
    [IdExt]   INT              NULL,
    [GuidExt] UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Name] ASC, [Code] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[MeasurementField].[IX_MeasurementField_IdExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_MeasurementField_IdExt]
    ON [dbo].[MeasurementField]([IdExt] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[MeasurementField].[IX_MeasurementField_GuidExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_MeasurementField_GuidExt]
    ON [dbo].[MeasurementField]([GuidExt] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[KSP]…';


GO
CREATE TABLE [dbo].[KSP] (
    [Id]                     INT              IDENTITY (1, 1) NOT NULL,
    [FK_MeasuringInstrument] INT              NOT NULL,
    [FK_MiGroup]             INT              NOT NULL,
    [IdExt]                  INT              NULL,
    [GuidExt]                UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([FK_MeasuringInstrument] ASC, [FK_MiGroup] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[KSP].[IX_KSP_FK_MeasuringInstrument]…';


GO
CREATE NONCLUSTERED INDEX [IX_KSP_FK_MeasuringInstrument]
    ON [dbo].[KSP]([FK_MeasuringInstrument] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[KSP].[IX_KSP_FK_MiGroup]…';


GO
CREATE NONCLUSTERED INDEX [IX_KSP_FK_MiGroup]
    ON [dbo].[KSP]([FK_MiGroup] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[KSP].[IX_KSP_IdExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_KSP_IdExt]
    ON [dbo].[KSP]([IdExt] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[KSP].[IX_KSP_GuidExt]…';


GO
CREATE NONCLUSTERED INDEX [IX_KSP_GuidExt]
    ON [dbo].[KSP]([GuidExt] ASC);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_TitleOwnershipDeed_ToMeasuringInstrument]…';


GO
ALTER TABLE [dbo].[TitleOwnershipDeed]
    ADD CONSTRAINT [FK_TitleOwnershipDeed_ToMeasuringInstrument] FOREIGN KEY ([FK_MeasuringInstrument]) REFERENCES [dbo].[MeasuringInstrument] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_TitleOwnershipDeed_ToDocument]…';


GO
ALTER TABLE [dbo].[TitleOwnershipDeed]
    ADD CONSTRAINT [FK_TitleOwnershipDeed_ToDocument] FOREIGN KEY ([FK_Document]) REFERENCES [dbo].[Document] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_MiGroupDocument_ToDocument]…';


GO
ALTER TABLE [dbo].[MiGroupDocument]
    ADD CONSTRAINT [FK_MiGroupDocument_ToDocument] FOREIGN KEY ([FK_Document]) REFERENCES [dbo].[Document] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_MiGroupDocument_ToMiGroup]…';


GO
ALTER TABLE [dbo].[MiGroupDocument]
    ADD CONSTRAINT [FK_MiGroupDocument_ToMiGroup] FOREIGN KEY ([FK_MiGroup]) REFERENCES [dbo].[MiGroup] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_Document_ToDocumentType]…';


GO
ALTER TABLE [dbo].[Document]
    ADD CONSTRAINT [FK_Document_ToDocumentType] FOREIGN KEY ([FK_DocumentType]) REFERENCES [dbo].[DocumentType] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_VerificationTool_ToMeasuringInstrument]…';


GO
ALTER TABLE [dbo].[VerificationTool]
    ADD CONSTRAINT [FK_VerificationTool_ToMeasuringInstrument] FOREIGN KEY ([FK_MeasuringInstrument]) REFERENCES [dbo].[MeasuringInstrument] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_MiGroup_ToMeasurementField]…';


GO
ALTER TABLE [dbo].[MiGroup]
    ADD CONSTRAINT [FK_MiGroup_ToMeasurementField] FOREIGN KEY ([FK_MeasurementField]) REFERENCES [dbo].[MeasurementField] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_MeasuringInstrument_ToManufacturer]…';


GO
ALTER TABLE [dbo].[MeasuringInstrument]
    ADD CONSTRAINT [FK_MeasuringInstrument_ToManufacturer] FOREIGN KEY ([FK_Manufacturer]) REFERENCES [dbo].[Organization] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_MeasuringInstrument_ToTypeSi]…';


GO
ALTER TABLE [dbo].[MeasuringInstrument]
    ADD CONSTRAINT [FK_MeasuringInstrument_ToTypeSi] FOREIGN KEY ([FK_TypeSi]) REFERENCES [dbo].[TypeSi] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_MeasuringInstrument_ToOwner]…';


GO
ALTER TABLE [dbo].[MeasuringInstrument]
    ADD CONSTRAINT [FK_MeasuringInstrument_ToOwner] FOREIGN KEY ([FK_Ownership]) REFERENCES [dbo].[Organization] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_MeasuringInstrument_ToInstallationLocation]…';


GO
ALTER TABLE [dbo].[MeasuringInstrument]
    ADD CONSTRAINT [FK_MeasuringInstrument_ToInstallationLocation] FOREIGN KEY ([FK_InstallationLocation]) REFERENCES [dbo].[InstallationLocation] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_KSP_ToMeasuringInstrument]…';


GO
ALTER TABLE [dbo].[KSP]
    ADD CONSTRAINT [FK_KSP_ToMeasuringInstrument] FOREIGN KEY ([FK_MeasuringInstrument]) REFERENCES [dbo].[MeasuringInstrument] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_KSP_ToMiGroup]…';


GO
ALTER TABLE [dbo].[KSP]
    ADD CONSTRAINT [FK_KSP_ToMiGroup] FOREIGN KEY ([FK_MiGroup]) REFERENCES [dbo].[MiGroup] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Триггер [dbo].[Trigger_MiGroupLog]…';


GO


CREATE TRIGGER [dbo].[Trigger_MiGroupLog]
    ON [dbo].[MiGroup]
    FOR DELETE, INSERT, UPDATE
    AS
    BEGIN
        SET NoCount ON
          DECLARE @dt_oper DATETIME

  SET @dt_oper = GETDATE()
        INSERT INTO [LogEvent] (idlogtablefield, idobj, opertype, opertime, [user], oldval, newval)
    SELECT
      1
     ,ISNULL(d.[Id], i.[Id])
     ,CASE
        WHEN i.Id IS NULL THEN 'D'
        WHEN d.Id IS NULL THEN 'I'
        ELSE 'U'
      END
     ,@dt_oper
     ,SYSTEM_USER
     ,d.[Name]
     ,i.[Name]
    FROM inserted i
    FULL JOIN deleted d
      ON d.[Id] = i.[Id]
    WHERE ISNULL(i.[Name], 0) <> ISNULL(d.[Name], 0)
    END
GO
PRINT N'Идет создание Представление [dbo].[MiGroupView]…';


GO
CREATE VIEW [dbo].[MiGroupView]
WITH SCHEMABINDING	
	AS SELECT [MiGroup].[Id],[MiGroup].Characteristic,[MiGroup].Name, [MiGroup].Range,[MeasurementField].Name as MeasurementField_Name, CAST(CONCAT([MeasurementField].[Code],[MiGroup].[Code]) AS INT) AS [CODE] FROM [dbo].[MiGroup] JOIN [dbo].[MeasurementField]
	ON [MeasurementField].[Id]= [MiGroup].FK_MeasurementField
GO
PRINT N'Идет создание Представление [dbo].[DocumentView]…';


GO
CREATE VIEW [dbo].[DocumentView]
WITH SCHEMABINDING	
	AS SELECT [DocumentType].[Name] AS [DocumentType_Name],
	[Document].[Date],
	[Document].[Name],
	[Document].[Number],
	[Document].[FK_DocumentType],
	[Document].[Id]
	FROM [dbo].[Document] 
	JOIN [dbo].[DocumentType] ON [DocumentType].Id=[Document].[FK_DocumentType]
GO
PRINT N'Идет создание Представление [dbo].[UnitView]…';


GO
CREATE VIEW [dbo].[UnitView]	
    WITH SCHEMABINDING	
	AS SELECT 
       [MeasuringInstrument].[Id]
      ,[VerificationTool].[Name]
      ,[VerificationTool].[VerificationNumber]
      ,[VerificationTool].[FirsVerificationNumber]
      ,[VerificationTool].[MiVerificationNumber]
      ,[VerificationTool].[CertificateNumber]
      ,[VerificationTool].[CertificateDate]
      ,[VerificationTool].[ValidityCertificateDate]
      ,[VerificationTool].[Range] AS [VerificationTool_Range]
	  ,[VerificationTool].[Characteristic] AS [VerificationTool_Characteristic]
	  ,[VerificationTool].[Discharge] AS [VerificationTool_Discharge]
      ,[MeasuringInstrument].[FactoryNumber]
      ,[MeasuringInstrument].[InventoryNumber]
      ,[MeasuringInstrument].[RegistrationNumber]
      ,[MeasuringInstrument].[IssueDate]
      ,[MeasuringInstrument].[CommissioningDate] 
      ,[InstallationLocation].[Name] as [InstallationLocation_Name]
      ,[Manufacturer].[Name] as [Manufacturer_Name]
      ,[Ownership].[Name] as [Ownership_Name]
      ,[dbo].[TypeSi].Name as [TypeSi_Name]   
      ,[dbo].[TypeSi].[Designation] as [TypeSi_Designation],
      [LINKNNFIF]
      FROM [dbo].[MeasuringInstrument]
	LEFT JOIN [dbo].[VerificationTool] ON [VerificationTool].[FK_MeasuringInstrument]=[MeasuringInstrument].[Id]
    JOIN [dbo].[TypeSi] ON [TypeSi].[Id]=[MeasuringInstrument].[FK_TypeSi]
    LEFT JOIN [dbo].[InstallationLocation] ON [InstallationLocation].[Id]=[MeasuringInstrument].[FK_InstallationLocation]    
    LEFT JOIN [dbo].[Organization] [Manufacturer]ON [Manufacturer].[Id]=[MeasuringInstrument].[FK_Manufacturer]
    LEFT JOIN [dbo].[Organization] [Ownership]ON [Manufacturer].[Id]=[MeasuringInstrument].[FK_Ownership]
GO
PRINT N'Идет создание Функция [dbo].[GetTitleDocument]…';


GO
CREATE FUNCTION [dbo].[GetTitleDocument]
(
	@ID int
)
RETURNS VARCHAR(max)
AS
BEGIN
DECLARE @Names VARCHAR(max)
	SELECT @Names = COALESCE(@Names + CHAR(13),'')+CONCAT([Document].[Number],' ',[Document].[Name],' ',[Document].[Date])
	FROM [dbo].[Document] 	
	JOIN  [dbo].[DocumentType] ON  [dbo].[Document].[FK_DocumentType]=[dbo].[DocumentType].[Id]
	JOIN [dbo].[TitleOwnershipDeed] ON [dbo].[TitleOwnershipDeed].FK_Document=[dbo].[Document].Id
	WHERE [dbo].[TitleOwnershipDeed].FK_MeasuringInstrument= @ID
	RETURN @Names
END
GO
PRINT N'Идет создание Функция [dbo].[GetMiGroupDocument]…';


GO
CREATE FUNCTION [dbo].[GetMiGroupDocument]
(
	@ID int
)
RETURNS VARCHAR(max)
AS
BEGIN
DECLARE @Names VARCHAR(max)
	SELECT @Names = COALESCE(@Names + CHAR(13),'')+CONCAT([DocumentType].[Name],' ',[Document].[Number],' ',[Document].[Name])
	FROM [dbo].[Document] 	
	JOIN  [dbo].[DocumentType] ON  [dbo].[Document].[FK_DocumentType]=[dbo].[DocumentType].[Id]
	JOIN [dbo].[MiGroupDocument] ON [dbo].[MiGroupDocument].FK_Document=[dbo].[Document].Id
	WHERE [dbo].[MiGroupDocument].FK_MiGroup= @ID
	RETURN @Names
END
GO
PRINT N'Идет создание Представление [dbo].[KspView]…';


GO
CREATE VIEW [dbo].[KspView]
	AS
	SELECT DISTINCT [MeasuringInstrument].[CommissioningDate],
	[MeasuringInstrument].[FactoryNumber],
	[InstallationLocation].[Name] AS [Name_InstallationLocation],
	[MeasuringInstrument].[InventoryNumber],
	[MeasuringInstrument].[IssueDate],
	[MeasuringInstrument].[RegistrationNumber],
	[MiGroup].[Characteristic]  as [MiGroup_Characteristic],
	[MiGroup].[Code] as [MiGroup_Code],
	[MiGroup].[Name] as [MiGroup_Name],
	[MiGroup].[Range] as [MiGroup_Range],
	[MeasurementField].[Code] as [MeasurementFieldCode],
	[MeasurementField].[Name] as [MeasurementFieldName],
	[VerificationTool].[CertificateDate],
	[VerificationTool].[CertificateNumber],
	[VerificationTool].[FirsVerificationNumber],
	[VerificationTool].MiVerificationNumber,
	[VerificationTool].[Name] AS [VerificationToolName],
	[VerificationTool].[ValidityCertificateDate],
	[VerificationTool].[VerificationNumber],
	[VerificationTool].[Range] AS [VerificationTool_Range],	
	[VerificationTool].[Characteristic] AS [VerificationTool_Characteristic],
	[VerificationTool].[Discharge] AS [VerificationTool_Discharge],
	[TypeSi].[Designation],
	[TypeSi].[Name] AS [TypeSiName],
	[Manufacturer].[LegalForm] AS [Manufacturer_LegalForm],
	[Manufacturer].[Name] AS [Manufacturer_Name],	
	[Manufacturer].[Country] AS [Manufacturer_Country],
	[Manufacturer].[Name] AS [Manufacturer_Region],
	[Owner].[Name] AS [Owner_Name],
	[Owner].[LegalForm] AS [Owner_LegalForm],
	[Owner].[Country] AS [Owner_Country],
	[Owner].[Region] AS [Owner_Region],
	(SELECT [dbo].[GetMiGroupDocument]([MiGroup].[Id])) AS MiGroupDocument ,	
	(SELECT [dbo].[GetTitleDocument]([MeasuringInstrument].[Id])) AS TitleDocument, 
	[LINKNNFIF],
	CAST(CONCAT([MeasurementField].[Code],[MiGroup].[Code]) AS INT) AS [CODE]
	FROM [dbo].[KSP] 
	JOIN [dbo].[MeasuringInstrument] on [KSP].[FK_MeasuringInstrument] =[MeasuringInstrument].[Id]--Добавляем измерительные устройства
	JOIN [dbo].[MiGroup] on [KSP].[FK_MiGroup]=[MiGroup].[Id] --Добавляем группу си
	JOIN [dbo].[MeasurementField] ON [MeasurementField].[Id]=[MiGroup].[FK_MeasurementField] --добавляем область измерения
	LEFT JOIN [dbo].[VerificationTool] ON [VerificationTool].[Id]=[MeasuringInstrument].[Id] --добавляем сведения о эталонах/поверках
	JOIN [dbo].[TypeSi] ON [TypeSi].[Id]=[MeasuringInstrument].[FK_TypeSi] --добавляем сведения о типе СИ
	LEFT JOIN [dbo].[Organization] [Owner] ON [Owner].[Id]=[MeasuringInstrument].[FK_Ownership] -- добавляем сведения о владельце
	LEFT JOIN [dbo].[InstallationLocation] ON [InstallationLocation].[Id]=[MeasuringInstrument].FK_InstallationLocation -- добавляем сведения о месте установки
	LEFT JOIN [dbo].[Organization] [Manufacturer] ON [Manufacturer].[Id]=[MeasuringInstrument].[FK_Manufacturer] --Добавляем сведения о изготовителе
	LEFT JOIN [dbo].[TitleOwnershipDeed] ON [TitleOwnershipDeed].[FK_MeasuringInstrument] =[MeasuringInstrument].[Id]   --добавляем связь о право устанавливающем документе
	LEFT JOIN [dbo].[Document] [TitleDocument] ON [TitleDocument].[Id]=[TitleOwnershipDeed].[FK_Document] -- добавляем связь с право устанавливающем документом
	LEFT JOIN [dbo].[MiGroupDocument] ON [MiGroupDocument].[FK_MiGroup]=[MiGroup].[Id] --добавляем связь о МП для групп 
	--LEFT JOIN [dbo].[Document] [MiGrDocument] ON [MiGroupDocument].Id=[MiGroupDocument].[FK_Document] -- добавляем МП для группы
	--LEFT JOIN [dbo].[DocumentType] [MiGrDocumentType] ON [MiGrDocument].[FK_DocumentType] =[MiGrDocumentType].[Id]
	--LEFT JOIN [dbo].[DocumentType] [TitleDocumentType] ON [MiGrDocument].[FK_DocumentType] =[TitleDocumentType].[Id]
GO
PRINT N'Идет создание Расширенное свойство [dbo].[TitleOwnershipDeed].[FK_MeasuringInstrument].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Объект владения', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TitleOwnershipDeed', @level2type = N'COLUMN', @level2name = N'FK_MeasuringInstrument';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[TitleOwnershipDeed].[FK_Document].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Документ подтверждающий право владения', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TitleOwnershipDeed', @level2type = N'COLUMN', @level2name = N'FK_Document';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[DocumentType].[Name].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Обозначение типа документа', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DocumentType', @level2type = N'COLUMN', @level2name = N'Name';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[Organization].[Name].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Наименование организации', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Organization', @level2type = N'COLUMN', @level2name = N'Name';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[Organization].[Country].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Страна', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Organization', @level2type = N'COLUMN', @level2name = N'Country';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[Organization].[Region].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Регион (Город)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Organization', @level2type = N'COLUMN', @level2name = N'Region';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[Organization].[LegalForm].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Организационно-Правовая форма', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Organization', @level2type = N'COLUMN', @level2name = N'LegalForm';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[InstallationLocation].[Name].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Наименование места установки', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InstallationLocation', @level2type = N'COLUMN', @level2name = N'Name';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[Document].[Name].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Наименование документа', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Document', @level2type = N'COLUMN', @level2name = N'Name';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[Document].[Date].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Дата документа', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Document', @level2type = N'COLUMN', @level2name = N'Date';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[Document].[Number].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Номер документа', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Document', @level2type = N'COLUMN', @level2name = N'Number';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[Document].[FK_DocumentType].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Обозначение документа', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Document', @level2type = N'COLUMN', @level2name = N'FK_DocumentType';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[VerificationTool].[Name].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Наименование эталона по реестру ФИФ ОЕИ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VerificationTool', @level2type = N'COLUMN', @level2name = N'Name';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[VerificationTool].[VerificationNumber].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Номер эталона по реестру ФИФ ОЕИ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VerificationTool', @level2type = N'COLUMN', @level2name = N'VerificationNumber';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[VerificationTool].[FirsVerificationNumber].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Номер государственного первичного эталона', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VerificationTool', @level2type = N'COLUMN', @level2name = N'FirsVerificationNumber';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[VerificationTool].[MiVerificationNumber].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Номер СИ в качестве эталона по реестру ФИФ ОЕИ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VerificationTool', @level2type = N'COLUMN', @level2name = N'MiVerificationNumber';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[VerificationTool].[CertificateNumber].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Номер свидетельства о поверке/калибровки', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VerificationTool', @level2type = N'COLUMN', @level2name = N'CertificateNumber';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[VerificationTool].[CertificateDate].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Дата поверки/калибровки', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VerificationTool', @level2type = N'COLUMN', @level2name = N'CertificateDate';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[VerificationTool].[ValidityCertificateDate].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Дата действия сертификата', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VerificationTool', @level2type = N'COLUMN', @level2name = N'ValidityCertificateDate';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[VerificationTool].[FK_MeasuringInstrument].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ключ измерительного устройства', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VerificationTool', @level2type = N'COLUMN', @level2name = N'FK_MeasuringInstrument';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[VerificationTool].[Range].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Диапазон', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VerificationTool', @level2type = N'COLUMN', @level2name = N'Range';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[VerificationTool].[Characteristic].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Характеристика', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VerificationTool', @level2type = N'COLUMN', @level2name = N'Characteristic';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[VerificationTool].[Discharge].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Разряд', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VerificationTool', @level2type = N'COLUMN', @level2name = N'Discharge';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[VerificationTool].[LINKNNFIF].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Номер записи ФИФ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VerificationTool', @level2type = N'COLUMN', @level2name = N'LINKNNFIF';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[TypeSi].[Name].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Наименование типа', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TypeSi', @level2type = N'COLUMN', @level2name = N'Name';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[TypeSi].[Designation].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Обозначение типа/модификация', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TypeSi', @level2type = N'COLUMN', @level2name = N'Designation';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MiGroup].[Code].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Код группы', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MiGroup', @level2type = N'COLUMN', @level2name = N'Code';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MiGroup].[Name].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Наименование группы', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MiGroup', @level2type = N'COLUMN', @level2name = N'Name';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MiGroup].[Characteristic].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Метрологическая характеристика группы', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MiGroup', @level2type = N'COLUMN', @level2name = N'Characteristic';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MiGroup].[Range].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Диапазон группы', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MiGroup', @level2type = N'COLUMN', @level2name = N'Range';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MiGroup].[FK_MeasurementField].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Внешний ключ области измерения', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MiGroup', @level2type = N'COLUMN', @level2name = N'FK_MeasurementField';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MeasuringInstrument].[FactoryNumber].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Заводской номер', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MeasuringInstrument', @level2type = N'COLUMN', @level2name = N'FactoryNumber';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MeasuringInstrument].[InventoryNumber].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Инвентарный номер', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MeasuringInstrument', @level2type = N'COLUMN', @level2name = N'InventoryNumber';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MeasuringInstrument].[FK_TypeSi].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Внешний ключ Тип СИ ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MeasuringInstrument', @level2type = N'COLUMN', @level2name = N'FK_TypeSi';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MeasuringInstrument].[RegistrationNumber].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Регистрационный номер СИ в ГосРеестре', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MeasuringInstrument', @level2type = N'COLUMN', @level2name = N'RegistrationNumber';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MeasuringInstrument].[FK_Ownership].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Право собственности', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MeasuringInstrument', @level2type = N'COLUMN', @level2name = N'FK_Ownership';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MeasuringInstrument].[FK_InstallationLocation].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Место установки', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MeasuringInstrument', @level2type = N'COLUMN', @level2name = N'FK_InstallationLocation';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MeasuringInstrument].[IssueDate].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Дата выпуска', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MeasuringInstrument', @level2type = N'COLUMN', @level2name = N'IssueDate';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MeasuringInstrument].[CommissioningDate].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Дата ввода в эксплуатацию', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MeasuringInstrument', @level2type = N'COLUMN', @level2name = N'CommissioningDate';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MeasuringInstrument].[FK_Manufacturer].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Внешний ключ на организацию изготовителя', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MeasuringInstrument', @level2type = N'COLUMN', @level2name = N'FK_Manufacturer';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MeasurementField].[Name].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Наименование области измерения', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MeasurementField', @level2type = N'COLUMN', @level2name = N'Name';


GO
PRINT N'Идет создание Расширенное свойство [dbo].[MeasurementField].[Code].[MS_Description]…';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Код области измерения', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MeasurementField', @level2type = N'COLUMN', @level2name = N'Code';


GO
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '18201ba4-0b4f-4e75-a343-4bab849617ea')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('18201ba4-0b4f-4e75-a343-4bab849617ea')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '0e209780-555c-4ca1-a417-01be77e22b30')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('0e209780-555c-4ca1-a417-01be77e22b30')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '04f75351-63ac-4c99-9539-d3da0ab6b9fe')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('04f75351-63ac-4c99-9539-d3da0ab6b9fe')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ea950875-2b52-49ee-b690-0a85b76aca51')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ea950875-2b52-49ee-b690-0a85b76aca51')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2381161a-ddfc-49e9-b0f4-5798ba00abfc')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2381161a-ddfc-49e9-b0f4-5798ba00abfc')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd3048d43-06b5-4717-a166-e9c90993eaa9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d3048d43-06b5-4717-a166-e9c90993eaa9')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7981997a-0c1b-4e35-8346-11d29900fba0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7981997a-0c1b-4e35-8346-11d29900fba0')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '15c23358-21c9-4c99-ad8e-3da0f91a00ee')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('15c23358-21c9-4c99-ad8e-3da0f91a00ee')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7f7ad842-84f5-4d60-8fec-1601e10ce9b1')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7f7ad842-84f5-4d60-8fec-1601e10ce9b1')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '838e4631-1661-4f28-b61a-144bb985e95a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('838e4631-1661-4f28-b61a-144bb985e95a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '828a48a4-0a2d-43d7-8ef8-4e977884efbf')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('828a48a4-0a2d-43d7-8ef8-4e977884efbf')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '755ec1b1-5280-4153-b5c9-0fbc6535e9fe')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('755ec1b1-5280-4153-b5c9-0fbc6535e9fe')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '0ff6ee26-5f4c-4f93-bc1a-398c8c54190f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('0ff6ee26-5f4c-4f93-bc1a-398c8c54190f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '25cc16a6-e66d-4698-ba43-38bcaf201842')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('25cc16a6-e66d-4698-ba43-38bcaf201842')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '28f333bd-011d-44d4-9340-300d80f7e049')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('28f333bd-011d-44d4-9340-300d80f7e049')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '4224d557-ea8a-4964-9563-3086bdae996f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('4224d557-ea8a-4964-9563-3086bdae996f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '735ff9ec-153b-465d-9835-624304947701')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('735ff9ec-153b-465d-9835-624304947701')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '31d1e9d6-1f22-4a85-9853-ae78b0fdee8c')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('31d1e9d6-1f22-4a85-9853-ae78b0fdee8c')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd460a475-6af1-43e8-8250-7b5f8121929b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d460a475-6af1-43e8-8250-7b5f8121929b')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '78f47625-54b8-4af7-b14d-5b70d7b71064')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('78f47625-54b8-4af7-b14d-5b70d7b71064')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2240f60f-a5fa-40d7-a6a3-ef98d77da1eb')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2240f60f-a5fa-40d7-a6a3-ef98d77da1eb')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'dc1c9771-d501-4203-8b5e-0fa69c3f2b80')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('dc1c9771-d501-4203-8b5e-0fa69c3f2b80')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '98653aca-3d90-44ad-aa32-c0cb2dd38cef')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('98653aca-3d90-44ad-aa32-c0cb2dd38cef')

GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET MULTI_USER 
    WITH ROLLBACK IMMEDIATE;


GO
PRINT N'Обновление завершено.';


GO
