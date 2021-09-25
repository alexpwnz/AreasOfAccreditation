CREATE TABLE [dbo].[TypeSi]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(300) NOT NULL, 
    [Designation] NVARCHAR(200) NOT NULL, 
    [IdExt] INT NULL , 
    [GuidExt] UNIQUEIDENTIFIER NULL 
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Обозначение типа/модификация',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'TypeSi',
    @level2type = N'COLUMN',
    @level2name = N'Designation'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Наименование типа',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'TypeSi',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO

CREATE INDEX [IX_TypeSi_IdExt] ON [dbo].[TypeSi] ([IdExt])
GO

CREATE INDEX [IX_TypeSi_GuidExt] ON [dbo].[TypeSi] ([GuidExt])
GO