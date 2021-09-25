CREATE TABLE [dbo].[Document]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(400) NULL, 
    [Date] DATE NULL, 
    [Number] NVARCHAR(100) NULL, 
    [FK_DocumentType] INT NULL, 
    CONSTRAINT [FK_Document_ToDocumentType] FOREIGN KEY ([FK_DocumentType]) REFERENCES [DocumentType]([Id])
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Наименование документа',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Document',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Дата документа',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Document',
    @level2type = N'COLUMN',
    @level2name = N'Date'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Номер документа',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Document',
    @level2type = N'COLUMN',
    @level2name = N'Number'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Обозначение документа',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Document',
    @level2type = N'COLUMN',
    @level2name = N'FK_DocumentType'
GO

CREATE INDEX [IX_Document_FK_DocumentType] ON [dbo].[Document] ([FK_DocumentType])

GO


