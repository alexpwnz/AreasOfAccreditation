CREATE TABLE [dbo].[LogEvent]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY,
	[IdLogTableField] [int] NOT NULL,
	[IdObj] [int] NOT NULL,
	[OperType] [NVARCHAR](1) NOT NULL,
	[OperTime] [datetime] NOT NULL,
	[User] [NVARCHAR](100) NOT NULL,
	[OldVal] [NVARCHAR](1500) NULL,
	[NewVal] [NVARCHAR](1500) NULL,
)
