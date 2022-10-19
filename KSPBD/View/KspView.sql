CREATE VIEW [dbo].[KspView]
	AS
	SELECT DISTINCT 
	ROW_NUMBER() OVER(ORDER BY [MeasuringInstrument].[FactoryNumber]) as [Uid]   
	,[MeasuringInstrument].[CommissioningDate],
	[MeasuringInstrument].[FactoryNumber],
	[InstallationLocation].[Name] AS [Name_InstallationLocation],
	[MeasuringInstrument].[InventoryNumber],
	[MeasuringInstrument].[IssueDate],
	[MeasuringInstrument].[RegistrationNumber],
	[MiGroup].[Characteristic]  as [MiGroup_Characteristic],
	[MiGroup].[Code] as [MiGroup_Code],
	[MiGroup].[Name] as [MiGroup_Name],
	[MiGroup].[Range] as [MiGroup_Range],
	[MeasurementField].[Code] as [MeasurementFieldCode],
	[MeasurementField].[Name] as [MeasurementFieldName],
	[VerificationTool].[CertificateDate],
	[VerificationTool].[CertificateNumber],
	[VerificationTool].[FirsVerificationNumber],
	[VerificationTool].MiVerificationNumber,
	[VerificationTool].[Name] AS [VerificationToolName],
	[VerificationTool].[ValidityCertificateDate],
	[VerificationTool].[VerificationNumber],
	[VerificationTool].[Range] AS [VerificationTool_Range],	
	[VerificationTool].[Characteristic] AS [VerificationTool_Characteristic],
	[VerificationTool].[Discharge] AS [VerificationTool_Discharge],
	[TypeSi].[Designation],
	[TypeSi].[Name] AS [TypeSiName],
	[Manufacturer].[LegalForm] AS [Manufacturer_LegalForm],
	[Manufacturer].[Name] AS [Manufacturer_Name],	
	[Manufacturer].[Country] AS [Manufacturer_Country],
	[Manufacturer].[Name] AS [Manufacturer_Region],
	[Owner].[Name] AS [Owner_Name],
	[Owner].[LegalForm] AS [Owner_LegalForm],
	[Owner].[Country] AS [Owner_Country],
	[Owner].[Region] AS [Owner_Region],
	(SELECT [dbo].[GetMiGroupDocument]([MiGroup].[Id])) AS MiGroupDocument ,	
	(SELECT [dbo].[GetTitleDocument]([MeasuringInstrument].[Id])) AS TitleDocument, 
	[LINKNNFIF],
	CAST(CONCAT([MeasurementField].[Code],[MiGroup].[Code]) AS INT) AS [CODE]
	FROM [dbo].[KSP] 
	JOIN [dbo].[MeasuringInstrument] on [KSP].[FK_MeasuringInstrument] =[MeasuringInstrument].[Id]--Добавляем измерительные устройства
	JOIN [dbo].[MiGroup] on [KSP].[FK_MiGroup]=[MiGroup].[Id] --Добавляем группу си
	JOIN [dbo].[MeasurementField] ON [MeasurementField].[Id]=[MiGroup].[FK_MeasurementField] --добавляем область измерения
	LEFT JOIN [dbo].[VerificationTool] ON [VerificationTool].[FK_MeasuringInstrument]=[MeasuringInstrument].[Id] --добавляем сведения о эталонах/поверках
	JOIN [dbo].[TypeSi] ON [TypeSi].[Id]=[MeasuringInstrument].[FK_TypeSi] --добавляем сведения о типе СИ
	LEFT JOIN [dbo].[Organization] [Owner] ON [Owner].[Id]=[MeasuringInstrument].[FK_Ownership] -- добавляем сведения о владельце
	LEFT JOIN [dbo].[InstallationLocation] ON [InstallationLocation].[Id]=[MeasuringInstrument].FK_InstallationLocation -- добавляем сведения о месте установки
	LEFT JOIN [dbo].[Organization] [Manufacturer] ON [Manufacturer].[Id]=[MeasuringInstrument].[FK_Manufacturer] --Добавляем сведения о изготовителе
	LEFT JOIN [dbo].[TitleOwnershipDeed] ON [TitleOwnershipDeed].[FK_MeasuringInstrument] =[MeasuringInstrument].[Id]   --добавляем связь о право устанавливающем документе
	LEFT JOIN [dbo].[Document] [TitleDocument] ON [TitleDocument].[Id]=[TitleOwnershipDeed].[FK_Document] -- добавляем связь с право устанавливающем документом


