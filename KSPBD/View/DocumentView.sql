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
