
$AbisVersion=2
$start_bag=5008000180
$number_bag = 179
$handler="AL"
$sorter="A"
$depArr="A"

$params = @{'server'='PO-X012569\SQLEXPRESS';'Database'='LSSNG_hz'}
$tableName="LSSNG$($AbisVersion)_$($handler)_$($sorter)_$($depArr)"

$sqlCommand= "Use BTS_PROD
Declare @firstBag Bigint
SET @firstBag=$start_bag
Select t1.xbpm_evdt,((t1.xbpm_tag-@firstBag)+1) as bag_index,t1.xbpm_tag,t1.xbpm_bgstat,t1.xbpm_evtp,t1.xbpm_evgen,t1.xbpm_bie,t1.xbpm_tobie,t1.xbpm_ch,t1.xbpm_ob_coicao,t1.xbpm_ob_flnum,t1.xbpm_ob_apiata,t1.xbpm_bgerrst,t1.xbpm_evloc,t1.xbpm_shrtevloc,t1.xbpm_agid,t1.xbpm_evdt_ldt,t1.xbpm_ob_flopsfx,t1.xbpm_ib_coicao,t1.xbpm_ib_flnum,t1.xbpm_ib_flopsfx,t1.xbpm_ib_apiata,t2.xbsm_sorstr
From tb_xbpm t1
inner join tb_xbsm t2
on t1.xbpm_xbsmid = t2.xbsm1_id
Where t1.xbpm_tag between @firstBag and (@firstBag+$number_bag) 
and t1.xbpm_evgen <> 'ABISV2'
and t1.xbpm_evgen <> 'BRS' 
order by t1.xbpm_tag,t1.xbpm_evdt"

$sqlCreateTable="USE [LSSNG_hz]
GO

/****** Object:  Table [dbo].[$tableName] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[$tableName]') AND type in (N'U'))
DROP TABLE [dbo].[$tableName]
GO

/****** Object:  Table [dbo].[$tableName]******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[$tableName](
    [xbpm_evdt] [datetime] NULL,
    [bag_index] [bigint] NULL,
	[xbpm_tag] [bigint] NULL,
	[xbpm_bgstat] [nvarchar](255) NULL,
	[xbpm_evtp] [nvarchar](255) NULL,
	[xbpm_evgen] [nvarchar](255) NULL,
	[xbpm_bie] [nvarchar](255) NULL,
	[xbpm_tobie] [nvarchar](255) NULL,
	[xbpm_ch] [int] NULL,
	[xbpm_ob_coicao] [nvarchar](255) NULL,
	[xbpm_ob_flnum] [nvarchar](255) NULL,
	[xbpm_ob_apiata] [nvarchar](255) NULL,
	[xbpm_bgerrst] [nvarchar](255) NULL,
	[xbpm_evloc] [nvarchar](255) NULL,
	[xbpm_shrtevloc] [nvarchar](255) NULL,
	[xbpm_agid] [nvarchar](255) NULL,
	[xbpm_evdt_ldt] [datetime] NULL
) ON [PRIMARY]
GO"

$sqlCreateView="USE [LSSNG_hz]
GO

/****** Object:  View [dbo].[vw_$tableName]    Script Date: 28/01/2021 18:34:55 ******/
DROP VIEW [dbo].[vw_$tableName]
GO

/****** Object:  View [dbo].[vw_$tableName]    Script Date: 28/01/2021 18:34:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_$tableName] AS
SELECT  [xbpm_evdt]
      ,[bag_index]
      ,[xbpm_tag]
      ,[xbpm_bgstat]
      ,[xbpm_evtp]
      ,[xbpm_evgen]
      ,[xbpm_bie]
      ,[xbpm_tobie]
      ,[xbpm_ch]
      ,[xbpm_ob_coicao]
      ,[xbpm_ob_flnum]
      ,[xbpm_ob_apiata]
      ,[xbpm_bgerrst]
	  ,CONCAT_WS('_'
		,RIGHT('000'+CAST(bag_index AS VARCHAR(4)),4)
		,xbpm_bgstat
		,xbpm_evtp
		,iif(xbpm_evgen like 'LSSNG%','LSSNG',xbpm_evgen)
		,iif(xbpm_evloc like 'EBS%','EBSEVT',xbpm_evloc)
		,xbpm_bie
		,iif(xbpm_evtp ='D','',xbpm_tobie)
		,xbpm_ch
		,xbpm_ob_coicao
		,xbpm_ob_apiata) AS compare_string
      ,[xbpm_evloc]
      ,[xbpm_shrtevloc]
      ,[xbpm_agid]
      ,[xbpm_evdt_ldt]
  FROM [LSSNG_hz].[dbo].[$tableName]
 

  
GO"

$sqlTruncateTable = "USE [LSSNG_hz]
TRUNCATE TABLE $tableName"


$conn = new-object System.Data.Odbc.OdbcConnection
$conn.connectionstring = "DSN=BTS01UAT;Uid=BTS_DBO;Pwd=tmptmp"
$conn.open()

$cmd = New-object System.Data.Odbc.OdbcCommand($sqlCommand,$conn)
$dataset = New-Object System.Data.DataSet
(New-Object System.Data.Odbc.OdbcDataAdapter($cmd)).Fill($dataSet)
$conn.Close()


Invoke-Sqlcmd @params -Query $sqlTruncateTable
#Invoke-Sqlcmd @params -Query $sqlCreateView

$connectionString = "Data Source=PO-X012569\SQLEXPRESS; Integrated Security=True;Initial Catalog=LSSNG_hz;"
$bulkCopy = new-object ("Data.SqlClient.SqlBulkCopy") $connectionString
$bulkCopy.DestinationTableName = $tableName
$bulkCopy.WriteToServer($dataset.Tables[0])


