$lssng1Views = 'C:\power\lssng1.txt'
$lssng2Views = 'C:\power\lssng2.txt'
$lssng1CompareViews = 'C:\power\lssng1_compare.txt'
$lssng2CompareViews = 'C:\power\lssng2_compare.txt'
$params = @{'server'='PO-X012569\SQLEXPRESS';'Database'='LSSNG_hz'}

#LSSNG1
foreach ($line in get-content $lssng1Views) {
   $tableName=$line
   $sqlTableName=$line.substring($tableName.length-13)
   $sqlCreateView="USE [LSSNG_hz]
      GO

      /****** Object:  View [dbo].[$tableName]    Script Date: 28/01/2021 18:34:55 ******/
      SET ANSI_NULLS ON
      GO

      SET QUOTED_IDENTIFIER ON
      GO

      CREATE VIEW [dbo].[$tableName] AS
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
            ,[xbpm_ob_flopsfx]
            ,[xbpm_ob_apiata]
            ,[xbpm_ib_coicao]
            ,[xbpm_ib_flnum]
            ,[xbpm_ib_flopsfx]
            ,[xbpm_ib_apiata]
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
            ,[xbsm_sorstr]
      FROM [LSSNG_hz].[dbo].[$sqlTableName]
      

      
      GO"
   #Invoke-Sqlcmd @params -Query $sqlCreateView
}

#LSSNG2
foreach ($line in get-content $lssng2Views) {
   $tableName=$line
   $sqlTableName=$line.substring($tableName.length-13)
   $sqlCreateView="USE [LSSNG_hz]
      GO

      /****** Object:  View [dbo].[$tableName]    Script Date: 28/01/2021 18:34:55 ******/
      SET ANSI_NULLS ON
      GO

      SET QUOTED_IDENTIFIER ON
      GO

      CREATE VIEW [dbo].[$tableName] AS
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
            ,[xbpm_ob_flopsfx]
            ,[xbpm_ob_apiata]
            ,[xbpm_ib_coicao]
            ,[xbpm_ib_flnum]
            ,[xbpm_ib_flopsfx]
            ,[xbpm_ib_apiata]
            ,[xbpm_bgerrst]
         ,CONCAT_WS('_'
            ,RIGHT('000'+CAST(bag_index AS VARCHAR(4)),4)
            ,xbpm_bgstat
            ,xbpm_evtp
            ,iif(xbpm_evtp = 'S','Screening',iif(xbpm_evgen like 'LSSNG%','LSSNG',xbpm_evgen))
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
            ,[xbsm_sorstr]
      FROM [LSSNG_hz].[dbo].[$sqlTableName]
      

      
      GO"
      #Invoke-Sqlcmd @params -Query $sqlCreateView
    
}

#LSSNG1_Compare
foreach ($line in get-content $lssng1CompareViews) {
   $tableName=$line

   #$sqlTableName="vw_$($line.substring($tableName.length-13))"
   $sqlTableName=$line.substring($tableName.length-13)
   $sqlTableName2=$sqlTableName -replace "1","2"
   $sqlCreateView="CREATE VIEW [dbo].[$tableName] AS
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
            ,[xbpm_ob_flopsfx]
            ,CONCAT (trim(xbpm_ob_coicao),trim(xbpm_ob_flnum),trim(xbpm_ob_flopsfx)) AS Flight
            ,[xbpm_ob_apiata]
            ,CONCAT (trim(xbpm_ib_coicao),trim(xbpm_ib_flnum),trim(xbpm_ib_flopsfx)) AS iFlight
            ,[xbpm_ib_apiata]
            ,[compare_string]
            ,Case When EXISTS (select compare_string from vw_$sqlTableName2 where vw_$sqlTableName.compare_string=vw_$sqlTableName2.compare_string) Then 'OK'
               ELSE 'NOK'
            END AS compare_result
            ,[xbpm_bgerrst]
            ,[xbpm_evloc]
            ,[xbpm_shrtevloc]
            ,[xbpm_agid]
            ,[xbpm_evdt_ldt]
            ,[xbsm_sorstr]
      FROM [LSSNG_hz].[dbo].[vw_$sqlTableName]"
   Invoke-Sqlcmd @params -Query $sqlCreateView
}

#LSSNG2_Compare
foreach ($line in get-content $lssng2CompareViews) {
   $tableName=$line

   #$sqlTableName="vw_$($line.substring($tableName.length-13))"
   $sqlTableName=$line.substring($tableName.length-13)
   $sqlTableName2=$sqlTableName -replace "2","1"
   $sqlCreateView="CREATE VIEW [dbo].[$tableName] AS
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
            ,[xbpm_ob_flopsfx]
            ,CONCAT (trim(xbpm_ob_coicao),trim(xbpm_ob_flnum),trim(xbpm_ob_flopsfx)) AS Flight
            ,[xbpm_ob_apiata]
            ,CONCAT (trim(xbpm_ib_coicao),trim(xbpm_ib_flnum),trim(xbpm_ib_flopsfx)) AS iFlight
            ,[xbpm_ib_apiata]
            ,[compare_string]
            ,Case When EXISTS (select compare_string from vw_$sqlTableName2 where vw_$sqlTableName.compare_string=vw_$sqlTableName2.compare_string) Then 'OK'
               ELSE 'NOK'
            END AS compare_result
            ,[xbpm_bgerrst]
            ,[xbpm_evloc]
            ,[xbpm_shrtevloc]
            ,[xbpm_agid]
            ,[xbpm_evdt_ldt]
            ,[xbsm_sorstr]
      FROM [LSSNG_hz].[dbo].[vw_$sqlTableName]"
   Invoke-Sqlcmd @params -Query $sqlCreateView
}