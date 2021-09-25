CREATE TABLE [dbo].[VerificationTool]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(1200) NULL, 
    [VerificationNumber] NVARCHAR(32) NULL, 
    [FirsVerificationNumber] NVARCHAR(32) NULL, 
    [MiVerificationNumber] NVARCHAR(32) NULL, 
    [CertificateNumber] NVARCHAR(30) NULL, 
    [CertificateDate] DATE NULL, 
    [ValidityCertificateDate] DATE NULL, 
    [FK_MeasuringInstrument] INT NOT NULL, 
    [Range] NVARCHAR(300) NULL, 
    [Characteristic] NVARCHAR(200) NULL,    
    [Discharge] NVARCHAR(100) NULL,
    [LINKNNFIF] NVARCHAR(500) NULL,
    [IdExt] INT NULL , 
    [GuidExt] UNIQUEIDENTIFIER NULL  
    CONSTRAINT [FK_VerificationTool_ToMeasuringInstrument] FOREIGN KEY ([FK_MeasuringInstrument]) REFERENCES [MeasuringInstrument]([Id]) ON DELETE CASCADE
 
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Наименование эталона по реестру ФИФ ОЕИ',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VerificationTool',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Номер эталона по реестру ФИФ ОЕИ',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VerificationTool',
    @level2type = N'COLUMN',
    @level2name = 'VerificationNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Номер государственного первичного эталона',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VerificationTool',
    @level2type = N'COLUMN',
    @level2name = 'FirsVerificationNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Номер СИ в качестве эталона по реестру ФИФ ОЕИ',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VerificationTool',
    @level2type = N'COLUMN',
    @level2name = N'MiVerificationNumber'
GO

GO

GO

GO

GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Номер свидетельства о поверке/калибровки',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VerificationTool',
    @level2type = N'COLUMN',
    @level2name = 'CertificateNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Дата поверки/калибровки',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VerificationTool',
    @level2type = N'COLUMN',
    @level2name = 'CertificateDate'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Дата действия сертификата',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VerificationTool',
    @level2type = N'COLUMN',
    @level2name = N'ValidityCertificateDate'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ключ измерительного устройства',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VerificationTool',
    @level2type = N'COLUMN',
    @level2name = N'FK_MeasuringInstrument'
GO



CREATE INDEX [IX_VerificationTool_FK_MeasuringInstrument] ON [dbo].[VerificationTool] ([FK_MeasuringInstrument])
GO

              
GO            

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Диапазон',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VerificationTool',
    @level2type = N'COLUMN',
    @level2name = N'Range'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Характеристика',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VerificationTool',
    @level2type = N'COLUMN',
    @level2name = N'Characteristic'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Разряд',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VerificationTool',
    @level2type = N'COLUMN',
    @level2name = N'Discharge'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Номер записи ФИФ',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VerificationTool',
    @level2type = N'COLUMN',
    @level2name = N'LINKNNFIF'