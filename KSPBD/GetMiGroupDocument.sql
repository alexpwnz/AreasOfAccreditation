CREATE FUNCTION [dbo].[GetMiGroupDocument]
(
	@ID int
)
RETURNS VARCHAR(max)
AS
BEGIN
DECLARE @Names VARCHAR(max)
	SELECT @Names = COALESCE(@Names + CHAR(13),'')+CONCAT([DocumentType].[Name],' ',[Document].[Number],' ',[Document].[Name])
	FROM [dbo].[Document] 	
	JOIN  [dbo].[DocumentType] ON  [dbo].[Document].[FK_DocumentType]=[dbo].[DocumentType].[Id]
	JOIN [dbo].[MiGroupDocument] ON [dbo].[MiGroupDocument].FK_Document=[dbo].[Document].Id
	WHERE [dbo].[MiGroupDocument].FK_MiGroup= @ID
	RETURN @Names
END
