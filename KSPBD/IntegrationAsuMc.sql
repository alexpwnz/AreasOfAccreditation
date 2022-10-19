
GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseNameSourse "OGMetr"
:setvar DatabaseNameTarget "OGMetr_KSP_test"
GO
:on error exit
GO
/*
Проверьте режим SQLCMD и отключите выполнение скрипта, если режим SQLCMD не поддерживается.
Чтобы повторно включить скрипт после включения режима SQLCMD выполните следующую инструкцию:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Для успешного выполнения этого скрипта должен быть включен режим SQLCMD.';
        SET NOEXEC ON;
    END


GO

IF (DB_ID(N'$(DatabaseNameSourse)') IS NULL) 
BEGIN
	  THROW 50000, N'База-Источник [$(DatabaseNameSourse)] отсутствует',1;
END

IF (DB_ID(N'$(DatabaseNameTarget)') IS NULL) 
BEGIN
	 THROW 50000, N'Целевая база [$(DatabaseNameTarget)] отсутствует',1;
END


DECLARE @query  NVARCHAR(max)

--set @query = 'SELECT * FROM [$(DatabaseNameSourse)].dbo.[EKZ]'


  -- создаем временную таблицу для хранения списка последних событий
  create table #lastMK (
    idekzmk int  )

  -- заполняем временную таблицу последними событиями для эталонов ( имеющих доп. сведения об эталонах)
    ;with ctemk ([IDEKZ], [IDSPVDMK], [IDGRSI], [DTMKFK]) as 
    (
      select MK.[IDEKZ], MK.[IDSPVDMK], MK.[IDGRSI], MAX(MK.[DTMKFK]) 
      from [dev_Metr7_OGMetr].dbo.[EKZMK] MK
        join [dev_Metr7_OGMetr].dbo.[SPVDMK] VDMK on  MK.[IDSPVDMK] = VDMK.[IDSPVDMK]
      where MK.[DTMKFK] is not NULL and  (VDMK.[NMVDMK] = 'Поверка' or VDMK.[NMVDMK] = 'Аттестация')
	  
      group by MK.[IDEKZ], MK.[IDSPVDMK], MK.[IDGRSI]
    )
	insert into #lastMK(idekzmk)
    select distinct [dev_Metr7_OGMetr].dbo.[EKZMK].[IDEKZMK]     
    from [dev_Metr7_OGMetr].dbo.[EKZMK] 
    join [dev_Metr7_OGMetr].dbo.[EKZ] on [dev_Metr7_OGMetr].dbo.[EKZ].[IDEKZ] = [dev_Metr7_OGMetr].dbo.[EKZMK].[IDEKZ]
    join ctemk on [dev_Metr7_OGMetr].dbo.[EKZMK].[IDEKZ] = ctemk.idekz and 
                  [dev_Metr7_OGMetr].dbo.[EKZMK].[IDSPVDMK] = ctemk.idspvdmk 
				   and                   [dev_Metr7_OGMetr].dbo.[EKZMK].[DTMKFK] = ctemk.dtmkfk 
				   and                   ISNULL( [dev_Metr7_OGMetr].dbo.[EKZMK].[IDGRSI], 0) = ISNULL(ctemk.idgrsi, 0)
				   WHERE [dev_Metr7_OGMetr].dbo.[EKZ].[IDEKZ] IN (SELECT [dev_Metr7_OGMetr].dbo.[EKZ].[IDEKZ] FROM [dev_Metr7_OGMetr].dbo.[EKZ] JOIN [dev_Metr7_OGMetr].dbo.[EKZETL] ON [dev_Metr7_OGMetr].dbo.[EKZETL].[IDEKZ]=[dev_Metr7_OGMetr].dbo.[EKZ].[IDEKZ])



SELECT [dev_Metr7_OGMetr].dbo.[EKZ].[IDEKZ],
[dev_Metr7_OGMetr].dbo.[EKZ].[NNZV],
[dev_Metr7_OGMetr].dbo.[EKZ].[NNIN],
[dev_Metr7_OGMetr].dbo.[EKZ].[NNEKZGR],
[dev_Metr7_OGMetr].dbo.[EKZ].[DTVP],
[dev_Metr7_OGMetr].dbo.[EKZ].[DTVVEK],
[dev_Metr7_OGMetr].dbo.[TPRZ].[IDTPRZ],
[dev_Metr7_OGMetr].dbo.[TIPS].[TP],
[dev_Metr7_OGMetr].dbo.[SPNMTP].[NMTP],
[dev_Metr7_OGMetr].dbo.[EKZETL].[NMEKZETLGR],
[dev_Metr7_OGMetr].dbo.[EKZETL].[NNEKZETLGR],
[dev_Metr7_OGMetr].dbo.[EKZETL].[NNEKZETLGPEGR],
[dev_Metr7_OGMetr].dbo.[EKZETL].[NNEKZSIETLFIF],
[dev_Metr7_OGMetr].dbo.[EKZETL].[RangeDescr],
[dev_Metr7_OGMetr].dbo.[EKZETL].[AccuracyCharacteristicDescr],
[dev_Metr7_OGMetr].dbo.[VerifHierarchySchemeRankClassifier].[Name] AS [VerifHierarchySchemeRankClassifier],
[dev_Metr7_OGMetr].dbo.[DMS].[NND],
[dev_Metr7_OGMetr].dbo.[EKZMK].[DTMKFK], 
[dev_Metr7_OGMetr].dbo.[EKZ].[IDFRPDIZ], --Данные организаций Изготовитель
[dev_Metr7_OGMetr].dbo.[EKZ].[IDFRPDV],-- Владелец
[dev_Metr7_OGMetr].dbo.[EKZ].[IDSPDPKL2],
[dev_Metr7_OGMetr].dbo.[EKZETL].[IDEKZETL],
(SELECT SUBSTRING([dev_Metr7_OGMetr].dbo.[EKZMKDH].[LINKNNFIF], LEN([dev_Metr7_OGMetr].dbo.[EKZMKDH].[LINKNNFIF]) - CHARINDEX('/', REVERSE([dev_Metr7_OGMetr].dbo.[EKZMKDH].[LINKNNFIF]))+2, LEN([dev_Metr7_OGMetr].dbo.[EKZMKDH].[LINKNNFIF])) 
FROM [dev_Metr7_OGMetr].dbo.[EKZMKDH]
WHERE [dev_Metr7_OGMetr].dbo.[EKZMKDH].[IDEKZMK]=[dev_Metr7_OGMetr].dbo.[EKZMK].[IDEKZMK]) AS [LINKNNFIF],
 DATEADD(day,-1, DATEADD(mm,[dev_Metr7_OGMetr].dbo.[EKZMK].[PRMK],[dev_Metr7_OGMetr].dbo.[EKZMK].[DTMKFK])) AS DTGDDO
 
   into #infoSourse
  FROM [dev_Metr7_OGMetr].dbo.[EKZ] 
JOIN [dev_Metr7_OGMetr].dbo.[TPRZ] ON [dev_Metr7_OGMetr].dbo.[TPRZ].[IDTPRZ]=  [dev_Metr7_OGMetr].dbo.[EKZ].[IDTPRZ]
JOIN [dev_Metr7_OGMetr].dbo.[TIPS] ON [dev_Metr7_OGMetr].dbo.[TIPS].[IDTIPS] = [dev_Metr7_OGMetr].dbo.[TPRZ].[IDTIPS]
JOIN [dev_Metr7_OGMetr].dbo.[SPNMTP] ON [dev_Metr7_OGMetr].dbo.[SPNMTP].[IDSPNMTP]=[dev_Metr7_OGMetr].dbo.[TIPS].[IDSPNMTP]
LEFT JOIN [dev_Metr7_OGMetr].dbo.[FRPD]  [FRPDIZ] ON [FRPDIZ].[IDFRPD]=[dev_Metr7_OGMetr].dbo.[EKZ].[IDFRPDIZ]
LEFT JOIN [dev_Metr7_OGMetr].dbo.[FRPD]  [FRPDVL] ON [FRPDVL].[IDFRPD]=[dev_Metr7_OGMetr].dbo.[EKZ].[IDFRPDV]
LEFT JOIN [dev_Metr7_OGMetr].dbo.[FRPDRK] [FRPDRKIZ] ON [FRPDRKIZ].[IDFRPD]=[FRPDIZ].[IDFRPD]
LEFT JOIN [dev_Metr7_OGMetr].dbo.[FRPDRK] [FRPDRKVL]ON [FRPDRKVL].[IDFRPD]=[FRPDVL].[IDFRPD]
JOIN [dev_Metr7_OGMetr].dbo.[EKZETL] ON [dev_Metr7_OGMetr].dbo.[EKZETL].[IDEKZ]=[dev_Metr7_OGMetr].dbo.[EKZ].[IDEKZ]
LEFT JOIN [dev_Metr7_OGMetr].dbo.[VerifHierarchySchemeRankClassifier] ON [dev_Metr7_OGMetr].dbo.[EKZETL].[IdVerifHierarchySchemeRank]=[dev_Metr7_OGMetr].dbo.[VerifHierarchySchemeRankClassifier].[Id]
LEFT JOIN [OGMetr_2022_01_24].dbo.[EKZMK] ON [OGMetr_2022_01_24].dbo.[EKZMK].[IDEKZETL]=[OGMetr_2022_01_24].dbo.[EKZETL].[IDEKZETL] AND [OGMetr_2022_01_24].dbo.[EKZMK].[IDEKZMK] IN (SELECT * FROM #lastMK)
LEFT JOIN [dev_Metr7_OGMetr].dbo.[DMS] ON [dev_Metr7_OGMetr].[dbo].[DMS].[IDOD]=[dev_Metr7_OGMetr].dbo.[EKZMK].[IDEKZMK] AND [dev_Metr7_OGMetr].[dbo].[DMS].[IDVDODVDD] = 
  --получаем ID типа документа (свидетельства)
  (SELECT idvdodvdd from [dev_Metr7_OGMetr].dbo.[VDODVDD] v where v.[IDSPVDOD] = 2 and v.[IDSPVDD] = 6)
    WHERE  [dev_Metr7_OGMetr].dbo.[EKZETL].[IsDeleted] is NULL
  GO
-- удаляем временную таблицу для хранения списка последних событий
drop table #lastMK
GO




--Заполняем данными Типы СИ объедением
MERGE [KSPBD].dbo.[TypeSi] AS target
    USING (Select [IDTPRZ],[NMTP],[TP] FROM #infoSourse GROUP BY  [IDTPRZ],[NMTP],[TP]) AS source 
    ON (target.[IdExt] = source.[IDTPRZ])
    WHEN MATCHED THEN 
        UPDATE SET [Name] = source.[NMTP],
                   [Designation] = source.[TP],
                   [IdExt] = source.[IDTPRZ]
WHEN NOT MATCHED THEN
    INSERT  ([IdExt],[Name] ,[Designation])
    VALUES (source.[IDTPRZ], source.[NMTP], source.[TP]);


GO


--Заполняем данными Организации объедением
MERGE [KSPBD].dbo.[Organization] AS target
    USING (Select Distinct   [dev_Metr7_OGMetr].dbo.[FRPD].[IDFRPD],[NMFRPD], [REGION], [COUNTRY], [NMTPVL]  FROM [dev_Metr7_OGMetr].dbo.[FRPD]  
    LEFT JOIN [dev_Metr7_OGMetr].dbo.[FRPDRK] ON [FRPDRK].[IDFRPD]=[dev_Metr7_OGMetr].dbo.[FRPD].[IDFRPD]    
    LEFT JOIN [dev_Metr7_OGMetr].dbo.[SPTPVL] ON [dev_Metr7_OGMetr].dbo.[SPTPVL].[IDSPTPVL]=[FRPDRK].[IDSPTPVL]) AS source 
    ON (target.[IdExt] = source.[IDFRPD])
    WHEN MATCHED THEN 
        UPDATE SET [Name] = source.[NMFRPD],
                   [Region] = source.[REGION],
                   [Country] = source.[COUNTRY],
                   [LegalForm] = source.[NMTPVL]
WHEN NOT MATCHED THEN
    INSERT   ([IdExt]
		   ,[Name]
		   ,[Region]
           ,[Country]
           ,[LegalForm])
    VALUES (source.[IDFRPD], source.[NMFRPD], source.[REGION], source.[COUNTRY], source.[NMTPVL]);

GO
--Заполняем данными  место установки из доп класса 2 объедением
MERGE [KSPBD].dbo.[InstallationLocation] AS target
    USING (SELECT [IDSPDPKL2],[NMDPKL2]  FROM [dev_Metr7_OGMetr].[dbo].[SPDPKL2] ) AS source 
    ON (target.[IdExt] = source.[IDSPDPKL2])
    WHEN MATCHED THEN 
        UPDATE SET [Name] = source.[NMDPKL2]
WHEN NOT MATCHED THEN
    INSERT   ([IdExt]
		   ,[Name])
    VALUES (source.[IDSPDPKL2], source.[NMDPKL2]);

GO

--заполняем информацию об измерительном оборудовании объедением
MERGE [KSPBD].dbo.[MeasuringInstrument] AS target
    USING ( SELECT Distinct [NNZV], [NNIN], (SELECT Id FROM [KSPBD].dbo.TypeSi WHERE IdExt=[IDTPRZ]) AS [FK_TypeSi],
		    [NNEKZGR], 
			(SELECT Id FROM [KSPBD].dbo.[Organization] WHERE IdExt=[IDFRPDV]) AS [FK_Ownership],
			(SELECT Id FROM [KSPBD].dbo.[InstallationLocation] WHERE IdExt= [IDSPDPKL2]) AS [FK_InstallationLocation],
			[DTVP],
			[DTVVEK],
			(SELECT Id FROM [KSPBD].dbo.[Organization] WHERE IdExt=[IDFRPDIZ]) AS [FK_Manufacturer],
			[IDEKZ] FROM #infoSourse) AS source 
    ON (target.[IdExt] = source.[IDEKZ])
    WHEN MATCHED THEN 
        UPDATE SET [FactoryNumber] = source.[NNZV],
        [InventoryNumber] = source.[NNIN],
        [FK_TypeSi] = source.[FK_TypeSi],
        [RegistrationNumber] = source.[NNEKZGR],
        [FK_Ownership] = source.[FK_Ownership],
        [FK_InstallationLocation] = source.[FK_InstallationLocation],
        [IssueDate] = source.[DTVP],
        [CommissioningDate] = source.[DTVVEK],
        [FK_Manufacturer] = source.[FK_Manufacturer],
        [IdExt] = source.[IDEKZ]
WHEN NOT MATCHED THEN
    INSERT   ([FactoryNumber]
           ,[InventoryNumber]
           ,[FK_TypeSi]
           ,[RegistrationNumber]
           ,[FK_Ownership]
           ,[FK_InstallationLocation]
           ,[IssueDate]
           ,[CommissioningDate]
           ,[FK_Manufacturer]
           ,[IdExt])
    VALUES (source.[NNZV], source.[NNIN], source.[FK_TypeSi], source.[NNEKZGR], source.[FK_Ownership],
    source.[FK_InstallationLocation], source.[DTVP], source.[DTVVEK], source.[FK_Manufacturer], source.[IDEKZ]);


GO

--заполняем информацию об эталонах объедением

MERGE [KSPBD].dbo.[VerificationTool] AS target
    USING ( SELECT  [NMEKZETLGR],[NNEKZETLGR],[NNEKZETLGPEGR],[NNEKZSIETLFIF],[NND], [DTMKFK], [DTGDDO],[RangeDescr],[AccuracyCharacteristicDescr]
		   ,[VerifHierarchySchemeRankClassifier]
		   ,[KSPBD].dbo.[MeasuringInstrument].[Id] AS [EKZ] 
		   ,[IDEKZETL], [LINKNNFIF] FROM #infoSourse 
		   JOIN  [KSPBD].dbo.[MeasuringInstrument] ON [KSPBD].dbo.[MeasuringInstrument].[IdExt]=#infoSourse.[IDEKZ]) AS source 
    ON (target.[IdExt] = source.[IDEKZETL])
    WHEN MATCHED THEN 
        UPDATE SET [Name] = source.[NMEKZETLGR],
        [VerificationNumber] = source.[NNEKZETLGR],
        [FirsVerificationNumber] = source.[NNEKZETLGPEGR],
        [MiVerificationNumber] = source.[NNEKZSIETLFIF],
        [CertificateNumber] = source.[NND],
        [CertificateDate] = source.[DTMKFK],
        [ValidityCertificateDate] = source.[DTGDDO],
        [Range] = source.[RangeDescr],
        [Characteristic] = source.[AccuracyCharacteristicDescr],
        [Discharge] = source.[VerifHierarchySchemeRankClassifier],
        [FK_MeasuringInstrument] = source.[EKZ],
        [LINKNNFIF]=source.[LINKNNFIF],
        [IdExt] = source.[IDEKZETL]

WHEN NOT MATCHED THEN
    INSERT    ([Name]
           ,[VerificationNumber]
           ,[FirsVerificationNumber]
           ,[MiVerificationNumber]
           ,[CertificateNumber]
           ,[CertificateDate]
           ,[ValidityCertificateDate]
		   ,[Range]
		   ,[Characteristic]
		   ,[Discharge]
           ,[FK_MeasuringInstrument]
           ,[LINKNNFIF]
           ,[IdExt])
    VALUES (source.[NMEKZETLGR], source.[NNEKZETLGR], source.[NNEKZETLGPEGR], source.[NNEKZSIETLFIF],
    source.[NND], source.[DTMKFK], source.[DTGDDO], source.[RangeDescr]
    , source.[AccuracyCharacteristicDescr], source.[VerifHierarchySchemeRankClassifier], source.[EKZ], source.[LINKNNFIF], source.[IDEKZETL]);


 GO

--Заполняем информацию об областях измерения объедением
MERGE [KSPBD].dbo.[MeasurementField] AS target
    USING (SELECT [NMOI],[KDOI], [IDSPOI] FROM [dev_Metr7_OGMetr].dbo.[SPOI]) AS source 
    ON (target.[IdExt] = source.[IDSPOI])
    WHEN MATCHED THEN 
        UPDATE SET [Name] = source.[NMOI],
        [Code] = source.[KDOI],
        [IdExt] = source.[IDSPOI]

WHEN NOT MATCHED THEN
    INSERT   ([Name]
		   ,[Code],
           [IdExt])
    VALUES (source.[NMOI], source.[KDOI], source.[IDSPOI]);

  GO

drop table #infoSourse
GO


--exec Sp_executeSQL @query

