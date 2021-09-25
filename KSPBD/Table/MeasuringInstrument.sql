CREATE TABLE [dbo].[MeasuringInstrument]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [FactoryNumber] NVARCHAR(100) NULL, 
    [InventoryNumber] NVARCHAR(100) NULL, 
    [FK_TypeSi] INT NOT NULL, 
    [RegistrationNumber] NVARCHAR(50) NULL, 
    [FK_Ownership] INT NULL, 
    [FK_InstallationLocation] INT NULL, 
    [IssueDate] DATE NULL, 
    [CommissioningDate] DATE NULL, 
    [FK_Manufacturer] INT NULL, 
    [IdExt] INT NULL , 
    [GuidExt] UNIQUEIDENTIFIER NULL  
    CONSTRAINT [FK_MeasuringInstrument_ToManufacturer] FOREIGN KEY ([FK_Manufacturer]) REFERENCES [Organization]([Id]), 
    CONSTRAINT [FK_MeasuringInstrument_ToTypeSi] FOREIGN KEY ([FK_TypeSi]) REFERENCES [TypeSi]([Id]), 
    CONSTRAINT [FK_MeasuringInstrument_ToOwner] FOREIGN KEY ([FK_Ownership]) REFERENCES [Organization]([Id]), 
    CONSTRAINT [FK_MeasuringInstrument_ToInstallationLocation] FOREIGN KEY ([FK_InstallationLocation]) REFERENCES [InstallationLocation]([Id])
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Регистрационный номер СИ в ГосРеестре',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MeasuringInstrument',
    @level2type = N'COLUMN',
    @level2name = N'RegistrationNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Заводской номер',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MeasuringInstrument',
    @level2type = N'COLUMN',
    @level2name = N'FactoryNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Инвентарный номер',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MeasuringInstrument',
    @level2type = N'COLUMN',
    @level2name = N'InventoryNumber'
GO

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Внешний ключ Тип СИ ',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MeasuringInstrument',
    @level2type = N'COLUMN',
    @level2name = 'FK_TypeSi'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Право собственности',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MeasuringInstrument',
    @level2type = N'COLUMN',
    @level2name = 'FK_Ownership'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Место установки',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MeasuringInstrument',
    @level2type = N'COLUMN',
    @level2name = 'FK_InstallationLocation'

GO

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Дата выпуска',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MeasuringInstrument',
    @level2type = N'COLUMN',
    @level2name = N'IssueDate'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Дата ввода в эксплуатацию',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MeasuringInstrument',
    @level2type = N'COLUMN',
    @level2name = N'CommissioningDate'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Внешний ключ на организацию изготовителя',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'MeasuringInstrument',
    @level2type = N'COLUMN',
    @level2name = N'FK_Manufacturer'
GO


CREATE INDEX [IX_MeasuringInstrument_FK_TypeSi] ON [dbo].[MeasuringInstrument] ([FK_TypeSi])

GO

CREATE INDEX [IX_MeasuringInstrument_FK_Ownership] ON [dbo].[MeasuringInstrument] ([FK_Ownership])

GO

CREATE INDEX [IX_MeasuringInstrument_FK_InstallationLocation] ON [dbo].[MeasuringInstrument] ([FK_InstallationLocation])

GO

CREATE INDEX [IX_MeasuringInstrument_FK_Manufacturer] ON [dbo].[MeasuringInstrument] ([FK_Manufacturer])

GO


CREATE INDEX [IX_MeasuringInstrument_IdExt] ON [dbo].[MeasuringInstrument] ([IdExt])

GO

CREATE INDEX [IX_MeasuringInstrument_GuidExt] ON [dbo].[MeasuringInstrument] ([GuidExt])
