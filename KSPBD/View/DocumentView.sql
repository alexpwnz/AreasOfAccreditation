CREATE VIEW [dbo].[DocumentView]
WITH SCHEMABINDING	
	AS SELECT
	ROW_NUMBER() OVER(ORDER BY [Document].[Id]) as [Uid]          
	 ,[DocumentType].[Name] AS [DocumentType_Name],
	[Document].[Date],
	[Document].[Name],
	[Document].[Number],
	[Document].[FK_DocumentType],
	[Document].[Id]
	FROM [dbo].[Document] 
	JOIN [dbo].[DocumentType] ON [DocumentType].Id=[Document].[FK_DocumentType]
