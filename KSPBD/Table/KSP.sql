CREATE TABLE [dbo].[KSP]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [FK_MeasuringInstrument] INT NOT NULL, 
    [FK_MiGroup] INT NOT NULL, 
    [IdExt] INT NULL , 
    [GuidExt] UNIQUEIDENTIFIER NULL 
    CONSTRAINT [FK_KSP_ToMeasuringInstrument] FOREIGN KEY ([FK_MeasuringInstrument]) REFERENCES [MeasuringInstrument]([Id]) ON DELETE CASCADE, 
    CONSTRAINT [FK_KSP_ToMiGroup] FOREIGN KEY ([FK_MiGroup]) REFERENCES [MiGroup]([Id]) ON DELETE CASCADE,
    UNIQUE([FK_MeasuringInstrument],[FK_MiGroup])
)

GO

CREATE INDEX [IX_KSP_FK_MeasuringInstrument] ON [dbo].[KSP] ([FK_MeasuringInstrument])

GO

CREATE INDEX [IX_KSP_FK_MiGroup] ON [dbo].[KSP] ([FK_MiGroup])

GO

CREATE INDEX [IX_KSP_IdExt] ON [dbo].[KSP] ([IdExt])

GO

CREATE INDEX [IX_KSP_GuidExt] ON [dbo].[KSP] ([GuidExt])
