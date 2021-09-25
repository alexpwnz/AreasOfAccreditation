CREATE TABLE [dbo].[MeasurementField]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Code] NVARCHAR(10) NOT NULL, 
    [Name] NVARCHAR(300) NOT NULL
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Код области',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Table',
    @level2type = N'COLUMN',
    @level2name = N'Code'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Наименование области',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Table',
    @level2type = N'COLUMN',
    @level2name = N'Name'