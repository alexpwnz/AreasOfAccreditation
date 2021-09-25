CREATE TABLE [dbo].[MiGroup]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Code] NVARCHAR(10) NOT NULL, 
    [Name] NVARCHAR(200) NOT NULL, 
    [Characteristic] NVARCHAR(300) NOT NULL, 
    [Range] NVARCHAR(300) NOT NULL, 
    [FK_MeasurementField] INT NOT NULL, 
    [IdExt] INT NULL , 
    [GuidExt] UNIQUEIDENTIFIER NULL 
    CONSTRAINT [FK_MiGroup_ToMeasurementField] FOREIGN KEY ([FK_MeasurementField]) REFERENCES [MeasurementField]([Id]) ,
    UNIQUE([Code],[FK_MeasurementField],[Characteristic],[Range] ),
    UNIQUE([Characteristic],[Range] )
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Код группы',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MiGroup',
    @level2type = N'COLUMN',
    @level2name = N'Code'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Наименование группы',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MiGroup',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Метрологическая характеристика группы',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MiGroup',
    @level2type = N'COLUMN',
    @level2name = N'Characteristic'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Диапазон группы',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MiGroup',
    @level2type = N'COLUMN',
    @level2name = N'Range'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Внешний ключ области измерения',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MiGroup',
    @level2type = N'COLUMN',
    @level2name = N'FK_MeasurementField'
GO

CREATE INDEX [IX_MiGroup_FK_MeasurementField] ON [dbo].[MiGroup] ([FK_MeasurementField])

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

CREATE INDEX [IX_MiGroup_GuidExt] ON [dbo].[MiGroup] ([GuidExt])

GO

CREATE INDEX [IX_MiGroup_IdExt] ON [dbo].[MiGroup] ([IdExt])
