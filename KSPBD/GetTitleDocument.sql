CREATE FUNCTION [dbo].[GetTitleDocument]
(
	@ID int
)
RETURNS VARCHAR(max)
AS
BEGIN
DECLARE @Names VARCHAR(max)
	SELECT @Names = COALESCE(@Names + CHAR(13),'')+CONCAT([Document].[Number],' ',[Document].[Name],' ',[Document].[Date])
	FROM [dbo].[Document] 	
	JOIN  [dbo].[DocumentType] ON  [dbo].[Document].[FK_DocumentType]=[dbo].[DocumentType].[Id]
	JOIN [dbo].[TitleOwnershipDeed] ON [dbo].[TitleOwnershipDeed].FK_Document=[dbo].[Document].Id
	WHERE [dbo].[TitleOwnershipDeed].FK_MeasuringInstrument= @ID
	RETURN @Names
END
