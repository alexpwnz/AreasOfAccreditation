CREATE TABLE [dbo].[MiGroupDocument]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [FK_Document] INT NOT NULL, 
    [FK_MiGroup] INT NOT NULL, 
    [IdExt] INT NULL , 
    [GuidExt] UNIQUEIDENTIFIER NULL  
    CONSTRAINT [FK_MiGroupDocument_ToDocument] FOREIGN KEY ([FK_Document]) REFERENCES [Document]([Id]) ON DELETE CASCADE, 
    CONSTRAINT [FK_MiGroupDocument_ToMiGroup] FOREIGN KEY ([FK_MiGroup]) REFERENCES [MiGroup]([Id]) ON DELETE CASCADE
)

GO

CREATE INDEX [IX_MiGroupDocument_FK_Document] ON [dbo].[MiGroupDocument] ([FK_Document])

GO

CREATE INDEX [IX_MiGroupDocument_FK_MiGroup] ON [dbo].[MiGroupDocument] ([FK_MiGroup])

GO

CREATE INDEX [IX_MiGroupDocument_IdExt] ON [dbo].[MiGroupDocument] ([IdExt])

GO

CREATE INDEX [IX_MiGroupDocument_GuidExt] ON [dbo].[MiGroupDocument] ([GuidExt])
