CREATE TABLE [dbo].[MeasurementField]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(200) NULL, 
    [Code] NVARCHAR(10) NULL , 
    [IdExt] INT NULL , 
    [GuidExt] UNIQUEIDENTIFIER NULL,
    UNIQUE([Name],[Code])
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Наименование области измерения',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MeasurementField',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Код области измерения',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MeasurementField',
    @level2type = N'COLUMN',
    @level2name = N'Code'
GO

CREATE INDEX [IX_MeasurementField_IdExt] ON [dbo].[MeasurementField] ([IdExt])

GO

CREATE INDEX [IX_MeasurementField_GuidExt] ON [dbo].[MeasurementField] ([GuidExt])
