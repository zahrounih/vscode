$Path="c:\power\flights.JSON"
$params = @{'server'='PO-X012569\SQLEXPRESS';'Database'='LSSNG_hz'}
$connectionString = "Data Source=PO-X012569\SQLEXPRESS; Integrated Security=True;Initial Catalog=LSSNG_hz;"
$bulkCopy = new-object ("Data.SqlClient.SqlBulkCopy") $connectionString
$myObject = Get-Content -Path $Path | ConvertFrom-Json
$simulationId =$myObject.simID
$abisVersion = $myObject.ABIS
$conn = new-object System.Data.Odbc.OdbcConnection
$conn.connectionstring = "DSN=BTS01UAT;Uid=BTS_DBO;Pwd=tmptmp"
foreach ($item in $myObject.flights) {
    $coicao=$item.Fli
    $flnum=$item.Num
    $flopsfx=$item.Suff
    $ofstad=$myObject.sdate
    $ofTimeS=$item.timeS
    $sqlCommand="select xfli1_ofsdtad,xfli1_coicao, xfli1_flnum,xfli1_flopsfx,xfli1_ofardep,xfli_apiata, xfli_handler,xfli_lstad,xfli_ofbkblk
    from tb_xfli
    Where xfli1_coicao='$coicao'
    AND xfli1_flnum='$flnum'
    AND xfli1_flopsfx ='$flopsfx'
    AND xfli1_ofsdtad = '$ofstad'"

    $sqlCommandAlloc="select xalc1_sdt,xalc1_coicao,xalc1_flnum,xalc1_flopsfx, xalc_sorstr,xalc_dtfr,xalc_dtto,xalc_bie,xalc_ch from tb_xalc
    Where xalc1_coicao='$coicao'
    AND xalc1_flnum='$flnum'
    AND xalc1_flopsfx ='$flopsfx'
    AND xalc1_sdt = '$ofstad'"
    
    $conn.open()
    $cmd = New-object System.Data.Odbc.OdbcCommand($sqlCommand,$conn)
    $dataset = New-Object System.Data.DataSet
    (New-Object System.Data.Odbc.OdbcDataAdapter($cmd)).Fill($dataSet)
    $conn.Close()

    #$bulkCopy = new-object ("Data.SqlClient.SqlBulkCopy") $connectionString
    #$bulkCopy.DestinationTableName = 'Flights_staging'
    #$bulkCopy.WriteToServer($dataset.Tables[0])

    #copy data from staging to final_table
    $sqlOfsdtad=$dataSet.Tables[0].Rows.xfli1_ofsdtad
    $sqlCoicao=$dataSet.Tables[0].Rows.xfli1_coicao
    $sqlFlnum=$dataSet.Tables[0].Rows.xfli1_flnum
    $sqlFlopsfx=$dataset.Tables[0].Rows.xfli1_flopsfx
    $sqlOfardep=$dataSet.Tables[0].Rows.xfli1_ofardep
    $sqlApiata=$dataSet.Tables[0].Rows.xfli_apiata
    $sqlHandler=$dataSet.Tables[0].Rows.xfli_handler
    $sqlLstad=$dataSet.Tables[0].Rows.xfli_lstad
    $sqlOfbkblk=$dataSet.Tables[0].Rows.xfli_ofbkblk

    $sqlInsertFlights = "INSERT INTO [dbo].[Flights]
    ([simId]
    ,[ABISv]
    ,[xfli1_ofsdtad]
    ,[xfli1_coicao]
    ,[xfli1_flnum]
    ,[xfli1_flopsfx]
    ,[xfli1_ofardep]
    ,[xfli_apiata]
    ,[xfli_handler]
    ,[xfli_lstad]
    ,[xfli_ofbkblk]
    ,[timeS])
    VALUES
    ($simulationId
    ,$abisVersion
    ,'$sqlOfsdtad'
    ,'$sqlCoicao'
    ,'$sqlFlnum'
    ,'$sqlFlopsfx'
    ,'$sqlOfardep'
    ,'$sqlApiata'
    ,'$sqlHandler'
    ,'$sqlLstad'
    ,'$sqlOfbkblk'
    ,'$ofTimeS')
GO"

Invoke-Sqlcmd @params -Query $sqlInsertFlights

$conn.open()
$cmd = New-object System.Data.Odbc.OdbcCommand($sqlCommandAlloc,$conn)
$dataSetAlloc = New-Object System.Data.DataSet
(New-Object System.Data.Odbc.OdbcDataAdapter($cmd)).Fill($dataSetAlloc)
$conn.Close()
$conn.Disposed
$dataAlloc=$dataSetAlloc.Tables[0]

$b=0
foreach ($row in $dataAlloc){
    
    $sqlOfsdtadAlloc = $dataAlloc.Rows[$b].xalc1_sdt
    $sqlCoicaoAlloc =$dataAlloc.Rows[$b].xalc1_coicao
    $sqlFlnumAlloc = $dataAlloc.Rows[$b].xalc1_flnum
    $sqlFlopsfxAlloc = $dataAlloc.Rows[$b].xalc1_flopsfx
    $sqlSorstrAlloc = $dataAlloc.Rows[$b].xalc_sorstr
    $sqlDtfrAlloc = $dataAlloc.Rows[$b].xalc_dtfr
    $sqlDttoAlloc = $dataAlloc.Rows[$b].xalc_dtto
    $sqlBieAlloc = $dataAlloc.Rows[$b].xalc_bie
    $sqlChAlloc = $dataAlloc.Rows[$b].xalc_ch
    
    
       

    $sqlInsertAllocs="INSERT INTO [dbo].[Allocs]
    ([simId]
    ,[ABISv]
    ,[xalc1_sdt]
    ,[xalc1_coicao]
    ,[xalc1_flnum]
    ,[xalc1_flopsfx]
    ,[xalc_sorstr]
    ,[xalc_dtfr]
    ,[xalc_dtto]
    ,[xalc_bie]
    ,[xalc_ch]
    ,[timeS])
    VALUES
    ($simulationId
    ,$abisVersion
    ,'$sqlOfsdtadAlloc'
    ,'$sqlCoicaoAlloc'
    ,'$sqlFlnumAlloc'
    ,'$sqlFlopsfxAlloc'
    ,'$sqlSorstrAlloc'
    ,'$sqlDtfrAlloc'
    ,'$sqlDttoAlloc'
    ,'$sqlBieAlloc'
    ,'$sqlChAlloc'
    ,'$ofTimeS')
    GO"
    Invoke-Sqlcmd @params -Query $sqlInsertAllocs
    $b++

}



  
}
