CREATE VIEW [dbo].[MiGroupView]
WITH SCHEMABINDING	
	AS SELECT [MiGroup].[Id],[MiGroup].Characteristic,[MiGroup].Name, [MiGroup].Range,[MeasurementField].Name as MeasurementField_Name, CAST(CONCAT([MeasurementField].[Code],[MiGroup].[Code]) AS INT) AS [CODE] FROM [dbo].[MiGroup] JOIN [dbo].[MeasurementField]
	ON [MeasurementField].[Id]= [MiGroup].FK_MeasurementField
