CREATE TABLE [dbo].[TitleOwnershipDeed]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [FK_MeasuringInstrument] INT NOT NULL, 
    [FK_Document] INT NOT NULL, 
    [IdExt] INT NULL , 
    [GuidExt] UNIQUEIDENTIFIER NULL  
    CONSTRAINT [FK_TitleOwnershipDeed_ToMeasuringInstrument] FOREIGN KEY ([FK_MeasuringInstrument]) REFERENCES [MeasuringInstrument]([Id]), 
    CONSTRAINT [FK_TitleOwnershipDeed_ToDocument] FOREIGN KEY ([FK_Document]) REFERENCES [Document]([Id]) 
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Объект владения',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'TitleOwnershipDeed',
    @level2type = N'COLUMN',
    @level2name = N'FK_MeasuringInstrument'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Документ подтверждающий право владения',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'TitleOwnershipDeed',
    @level2type = N'COLUMN',
    @level2name = N'FK_Document'
GO


CREATE INDEX [IX_TitleOwnershipDeed_FK_MeasuringInstrument] ON [dbo].[TitleOwnershipDeed] ([FK_MeasuringInstrument])

GO

CREATE INDEX [IX_TitleOwnershipDeed_FK_Document] ON [dbo].[TitleOwnershipDeed] ([FK_Document])
GO

              
GO            
