CREATE TABLE [dbo].[DocumentType]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(10) NULL, 
    [IdExt] INT NULL , 
    [GuidExt] UNIQUEIDENTIFIER NULL
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Обозначение типа документа',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'DocumentType',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO

CREATE INDEX [IX_DocumentType_GuidExt] ON [dbo].[DocumentType] ([GuidExt])

GO

CREATE INDEX [IX_DocumentType_IdExt] ON [dbo].[DocumentType] ([IdExt])
