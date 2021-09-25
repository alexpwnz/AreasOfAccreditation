CREATE TABLE [dbo].[Organization]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(300) NOT NULL, 
    [Country] NVARCHAR(100) NULL, 
    [Region] NVARCHAR(200)  NULL,
    [LegalForm] NVARCHAR(10) NULL, 
    [IdExt] INT NULL , 
    [GuidExt] UNIQUEIDENTIFIER NULL,
     UNIQUE([Name],[Country],[Region],[LegalForm] )

)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Наименование организации',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Organization',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Страна',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Organization',
    @level2type = N'COLUMN',
    @level2name = N'Country'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Организационно-Правовая форма',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Organization',
    @level2type = N'COLUMN',
    @level2name = N'LegalForm'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Регион (Город)',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Organization',
    @level2type = N'COLUMN',
    @level2name = N'Region'
GO

CREATE INDEX [IX_Organization_IdExt] ON [dbo].[Organization] ([IdExt])
GO

CREATE INDEX [IX_Organization_GuidExt] ON [dbo].[Organization] ([GuidExt])
GO
