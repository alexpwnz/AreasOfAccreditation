CREATE TABLE [dbo].[InstallationLocation]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(300) NULL, 
    [IdExt] INT NULL , 
    [GuidExt] UNIQUEIDENTIFIER NULL 
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Наименование места установки',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'InstallationLocation',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO

CREATE INDEX [IX_InstallationLocation_IdExt] ON [dbo].[InstallationLocation] ([IdExt])

GO

CREATE INDEX [IX_InstallationLocation_GuidExt] ON [dbo].[InstallationLocation] ([GuidExt])
