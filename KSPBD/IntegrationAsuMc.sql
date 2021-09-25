
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
      from [OGMetr].dbo.[EKZMK] MK
        join [OGMetr].dbo.[SPVDMK] VDMK on  MK.[IDSPVDMK] = VDMK.[IDSPVDMK]
      where MK.[DTMKFK] is not NULL and  VDMK.[NMVDMK] =[OGMetr].dbo.GetTxtDesc(7907)
	  
      group by MK.[IDEKZ], MK.[IDSPVDMK], MK.[IDGRSI]
    )
	insert into #lastMK(idekzmk)
    select distinct [OGMetr].dbo.[EKZMK].[IDEKZMK]     
    from [OGMetr].dbo.[EKZMK] 
    join [OGMetr].dbo.[EKZ] on [OGMetr].dbo.[EKZ].[IDEKZ] = [OGMetr].dbo.[EKZMK].[IDEKZ]
    join ctemk on [OGMetr].dbo.[EKZMK].[IDEKZ] = ctemk.idekz and 
                  [OGMetr].dbo.[EKZMK].[IDSPVDMK] = ctemk.idspvdmk 
				   and                   [OGMetr].dbo.[EKZMK].[DTMKFK] = ctemk.dtmkfk 
				   and                   ISNULL( [OGMetr].dbo.[EKZMK].[IDGRSI], 0) = ISNULL(ctemk.idgrsi, 0)
				   WHERE [OGMetr].dbo.[EKZ].[IDEKZ] IN (SELECT [OGMetr].dbo.[EKZ].[IDEKZ] FROM [OGMetr].dbo.[EKZ] JOIN [OGMetr].dbo.[EKZETL] ON [OGMetr].dbo.[EKZETL].[IDEKZ]=[OGMetr].dbo.[EKZ].[IDEKZ])



SELECT [OGMetr].dbo.[EKZ].[IDEKZ],
[OGMetr].dbo.[EKZ].[NNZV],
[OGMetr].dbo.[EKZ].[NNIN],
[OGMetr].dbo.[EKZ].[NNEKZGR],
[OGMetr].dbo.[EKZ].[DTVP],
[OGMetr].dbo.[EKZ].[DTVVEK],
[OGMetr].dbo.[TPRZ].[IDTPRZ],
[OGMetr].dbo.[TIPS].[TP],
[OGMetr].dbo.[SPNMTP].[NMTP],
[OGMetr].dbo.[EKZETL].[NMEKZETLGR],
[OGMetr].dbo.[EKZETL].[NNEKZETLGR],
[OGMetr].dbo.[EKZETL].[NNEKZETLGPEGR],
[OGMetr].dbo.[EKZETL].[NNEKZSIETLFIF],
[OGMetr].dbo.[EKZETL].[RangeDescr],
[OGMetr].dbo.[EKZETL].[AccuracyCharacteristicDescr],
[OGMetr].dbo.[VerifHierarchySchemeRankClassifier].[Name] AS [VerifHierarchySchemeRankClassifier],
[OGMetr].dbo.[DMS].[NND],
[OGMetr].dbo.[EKZMK].[DTMKFK], 
[OGMetr].dbo.[EKZ].[IDFRPDIZ], --Данные организаций Изготовитель
[OGMetr].dbo.[EKZ].[IDFRPDV],-- Владелец
[OGMetr].dbo.[EKZ].[IDSPDPKL2],
[OGMetr].dbo.[EKZETL].[IDEKZETL],
(SELECT SUBSTRING([OGMetr].dbo.[EKZMKDH].[LINKNNFIF], LEN([OGMetr].dbo.[EKZMKDH].[LINKNNFIF]) - CHARINDEX('/', REVERSE([OGMetr].dbo.[EKZMKDH].[LINKNNFIF]))+2, LEN([OGMetr].dbo.[EKZMKDH].[LINKNNFIF])) 
FROM [OGMetr].dbo.[EKZMKDH]
WHERE [OGMetr].dbo.[EKZMKDH].[IDEKZMK]=[OGMetr].dbo.[EKZMK].[IDEKZMK]) AS [LINKNNFIF],
 DATEADD(day,-1, DATEADD(mm,[OGMetr].dbo.[EKZMK].[PRMK],[OGMetr].dbo.[EKZMK].[DTMKFK])) AS DTGDDO
 
   into #infoSourse
  FROM [OGMetr].dbo.[EKZ] 
JOIN [OGMetr].dbo.[TPRZ] ON [OGMetr].dbo.[TPRZ].[IDTPRZ]=  [OGMetr].dbo.[EKZ].[IDTPRZ]
JOIN [OGMetr].dbo.[TIPS] ON [OGMetr].dbo.[TIPS].[IDTIPS] = [OGMetr].dbo.[TPRZ].[IDTIPS]
JOIN [OGMetr].dbo.[SPNMTP] ON [OGMetr].dbo.[SPNMTP].[IDSPNMTP]=[OGMetr].dbo.[TIPS].[IDSPNMTP]
LEFT JOIN [OGMetr].dbo.[FRPD]  [FRPDIZ] ON [FRPDIZ].[IDFRPD]=[OGMetr].dbo.[EKZ].[IDFRPDIZ]
LEFT JOIN [OGMetr].dbo.[FRPD]  [FRPDVL] ON [FRPDVL].[IDFRPD]=[OGMetr].dbo.[EKZ].[IDFRPDV]
LEFT JOIN [OGMetr].dbo.[FRPDRK] [FRPDRKIZ] ON [FRPDRKIZ].[IDFRPD]=[FRPDIZ].[IDFRPD]
LEFT JOIN [OGMetr].dbo.[FRPDRK] [FRPDRKVL]ON [FRPDRKVL].[IDFRPD]=[FRPDVL].[IDFRPD]
JOIN [OGMetr].dbo.[EKZETL] ON [OGMetr].dbo.[EKZETL].[IDEKZ]=[OGMetr].dbo.[EKZ].[IDEKZ]
LEFT JOIN [OGMetr].dbo.[VerifHierarchySchemeRankClassifier] ON [OGMetr].dbo.[EKZETL].[IdVerifHierarchySchemeRank]=[OGMetr].dbo.[VerifHierarchySchemeRankClassifier].[Id]
LEFT JOIN [OGMetr].dbo.[EKZMK] ON [OGMetr].dbo.[EKZMK].[IDEKZ]=[OGMetr].dbo.[EKZ].[IDEKZ] AND [OGMetr].dbo.[EKZMK].[IDEKZMK] IN (SELECT * FROM #lastMK)
LEFT JOIN [OGMetr].dbo.[DMS] ON [OGMetr].[dbo].[DMS].[IDOD]=[OGMetr].dbo.[EKZMK].[IDEKZMK] AND [OGMetr].[dbo].[DMS].[IDVDODVDD] = 
  --получаем ID типа документа (свидетельства)
  (SELECT idvdodvdd from [OGMetr].dbo.[VDODVDD] v where v.[IDSPVDOD] = 2 and v.[IDSPVDD] = 6)
    WHERE  [OGMetr].dbo.[EKZETL].[IsDeleted] is NULL
  GO
-- удаляем временную таблицу для хранения списка последних событий
drop table #lastMK
GO




--Заполняем данными Типы СИ объедением
MERGE [OGMetr_KSP_test].dbo.[TypeSi] AS target
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
MERGE [OGMetr_KSP_test].dbo.[Organization] AS target
    USING (Select Distinct   [OGMetr].dbo.[FRPD].[IDFRPD],[NMFRPD], [REGION], [COUNTRY], [NMTPVL]  FROM [OGMetr].dbo.[FRPD]  
    LEFT JOIN [OGMetr].dbo.[FRPDRK] ON [FRPDRK].[IDFRPD]=[OGMetr].dbo.[FRPD].[IDFRPD]    
    LEFT JOIN [OGMetr].dbo.[SPTPVL] ON [OGMetr].dbo.[SPTPVL].[IDSPTPVL]=[FRPDRK].[IDSPTPVL]) AS source 
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
MERGE [OGMetr_KSP_test].dbo.[InstallationLocation] AS target
    USING (SELECT [IDSPDPKL2],[NMDPKL2]  FROM [OGMetr].[dbo].[SPDPKL2] ) AS source 
    ON (target.[IdExt] = source.[IDSPDPKL2])
    WHEN MATCHED THEN 
        UPDATE SET [Name] = source.[NMDPKL2]
WHEN NOT MATCHED THEN
    INSERT   ([IdExt]
		   ,[Name])
    VALUES (source.[IDSPDPKL2], source.[NMDPKL2]);

GO

--заполняем информацию об измерительном оборудовании объедением
MERGE [OGMetr_KSP_test].dbo.[MeasuringInstrument] AS target
    USING ( SELECT Distinct [NNZV], [NNIN], (SELECT Id FROM [OGMetr_KSP_test].dbo.TypeSi WHERE IdExt=[IDTPRZ]) AS [FK_TypeSi],
		    [NNEKZGR], 
			(SELECT Id FROM [OGMetr_KSP_test].dbo.[Organization] WHERE IdExt=[IDFRPDV]) AS [FK_Ownership],
			(SELECT Id FROM [OGMetr_KSP_test].dbo.[InstallationLocation] WHERE IdExt= [IDSPDPKL2]) AS [FK_InstallationLocation],
			[DTVP],
			[DTVVEK],
			(SELECT Id FROM [OGMetr_KSP_test].dbo.[Organization] WHERE IdExt=[IDFRPDIZ]) AS [FK_Manufacturer],
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
MERGE [OGMetr_KSP_test].dbo.[VerificationTool] AS target
    USING ( SELECT  [NMEKZETLGR],[NNEKZETLGR],[NNEKZETLGPEGR],[NNEKZSIETLFIF],[NND], [DTMKFK], [DTGDDO],[RangeDescr],[AccuracyCharacteristicDescr]
		   ,[VerifHierarchySchemeRankClassifier]
		   ,[OGMetr_KSP_test].dbo.[MeasuringInstrument].[Id] AS [EKZ] 
		   ,[IDEKZETL], [LINKNNFIF] FROM #infoSourse 
		   JOIN  [OGMetr_KSP_test].dbo.[MeasuringInstrument] ON [OGMetr_KSP_test].dbo.[MeasuringInstrument].[IdExt]=#infoSourse.[IDEKZ]) AS source 
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
MERGE [OGMetr_KSP_test].dbo.[MeasurementField] AS target
    USING (SELECT [NMOI],[KDOI], [IDSPOI] FROM [OGMetr].dbo.[SPOI]) AS source 
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

