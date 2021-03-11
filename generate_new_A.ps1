
    [string] $handler ="AP"
    [string] $sorter="A"
    [string] $depArr="D"
    [Int]$simid=190
    
    $JsonPath="c:\power\flights.JSON"
    $texFile="c:\BAHA\68_Report"+$handler+"_"+$sorter+".tex"
    NeW-item $texFile
    [string] $Server= "PO-X014795"
    [string] $Database = "LSSNG_hz"
   
    
    $Number_Of_Columns = 8
    $x=0


    function ExecuteSqlQuery ($Server, $Database, $SQLQuery) {
        $Datatable = New-Object System.Data.DataTable
        
        $Connection = New-Object System.Data.SQLClient.SQLConnection
        $Connection.ConnectionString = "server='$Server';database='$Database';trusted_connection=true;"
        $Connection.Open()
        $Command = New-Object System.Data.SQLClient.SQLCommand
        $Command.Connection = $Connection
        $Command.CommandText = $SQLQuery
        $Reader = $Command.ExecuteReader()
        $Datatable.Load($Reader)
        $Connection.Close()
        
        return $Datatable
    }
    
    function GetBagTag ($index,$handler,$sorter,$lss)
    {
        [string] $Server= "PO-X014795"
        [string] $Database = "LSSNG_hz"
        [string] $SQL_getTag= $("SELECT DISTINCT xbpm_tag from vw_compare_$lss`_$handler`_$sorter`_$depArr where bag_index = $index")
        $result=ExecuteSqlQuery $Server $Database $SQL_getTag
        return $result
    }

    function GetBagSorting ($index,$handler,$sorter,$lss)
    {
        [string] $Server= "PO-X014795"
        [string] $Database = "LSSNG_hz"
        [string] $SQL_getTag= $("SELECT DISTINCT xbsm_sorstr from vw_compare_$lss`_$handler`_$sorter`_$depArr where bag_index = $index")
        $result=ExecuteSqlQuery $Server $Database $SQL_getTag
        return $result
    }

    function GetiBagSorting ($index,$handler,$sorter,$lss)
    {
        [string] $Server= "PO-X014795"
        [string] $Database = "LSSNG_hz"
        [string] $SQL_getTag= $("SELECT DISTINCT xbsm_sorstr from vw_compare_$lss`_$handler`_$sorter`_A where xbpm_tag = $index")
        $result=ExecuteSqlQuery $Server $Database $SQL_getTag
        return $result
    }

    function GetBagFlight ($index,$handler,$sorter,$lss)
    {
        [string] $Server= "PO-X014795"
        [string] $Database = "LSSNG_hz"
        [string] $SQL_getTag= $("SELECT DISTINCT Flight from vw_compare_$lss`_$handler`_$sorter`_$depArr where bag_index = $index")
        $result=ExecuteSqlQuery $Server $Database $SQL_getTag
        return $result
    }

    function GetBagiFlight ($index,$handler,$sorter,$lss)
    {
        [string] $Server= "PO-X014795"
        [string] $Database = "LSSNG_hz"
        [string] $SQL_getTag= $("SELECT DISTINCT iFlight from vw_compare_$lss`_$handler`_$sorter`_$depArr where xbpm_tag = $index and iFlight <>''")
        $result=ExecuteSqlQuery $Server $Database $SQL_getTag
        return $result
    }

    function Allocs ($idSim,$abisSim,$time)
    {
        [string] $Server= "PO-X014795"
        [string] $Database = "LSSNG_hz"
        [string] $SQL_getAllocs= $("select convert(varchar,xalc1_sdt, 105) as sdt
		,Flight
		,xalc_sorstr
		,CONCAT(xalc_bie,xalc_ch) as chute
		,convert(varchar,xalc_dtfr, 8) as ch_open
		,convert(varchar,xalc_dtto, 8) as ch_close
		from vw_allocs
		where simid =$idSim and ABISv=$abisSim and timeS='$time'")
        $result=ExecuteSqlQuery $Server $Database $SQL_getAllocs
        return $result
    }

    Add-Content -Path $texFile -value '\documentclass{report}'
    Add-Content -Path $texFile -value '\usepackage[table]{xcolor}'
    Add-Content -Path $texFile -value '\usepackage{a4}'
    Add-Content -Path $texFile -Value '\usepackage[a4paper, left=15mm,right=15mm,bottom=20mm,top=20mm]{geometry}'
    Add-Content -Path $texFile -value '\usepackage{booktabs}'
    Add-Content -Path $texFile -value '\usepackage{blindtext}'
    Add-Content -Path $texFile -value '\usepackage[T1]{fontenc}'
    Add-Content -Path $texFile -value '\usepackage[utf8]{inputenc}'
    Add-Content -Path $texFile -value "\usepackage{adjustbox}"
    Add-Content -Path $texFile -Value '\usepackage{pdflscape}'
    Add-Content -Path $texFile -Value '\usepackage{longtable}'
    Add-Content -Path $texFile -Value '
    \usepackage{hyperref}
    \hypersetup{
        colorlinks,
        citecolor=black,
        filecolor=black,
        linkcolor=black,
        urlcolor=black
    }'
    Add-Content -Path $texFile -Value '\definecolor{lightgray}{gray}{0.9}'
    Add-Content -Path $texFile -value '\begin{document}'
    Add-Content -Path $texFile -Value "
    \begin{titlepage}
    \begin{center}
        \vspace*{1cm}
            
        \Huge
        \textbf{ABISv2 sorting tests results}
            
        \vspace{0.5cm}
        \LARGE
        Handler: $handler / Sorter: $sorter
        
        
        \includegraphics[width=0.4\textwidth]{BAC1}
        \Large            
    \end{center}
\end{titlepage}
\tableofcontents"
    Add-Content -Path $texFile -Value '\begin{landscape}
    \chapter*{The big picture}
    \addcontentsline{toc}{chapter}{The big picture}
    \begin{center}
    \includegraphics[width=1.1\textwidth]{visio}
    \end{center}
    \end{landscape}'
    Add-Content -Path $texFile -value '\chapter*{Flights and chutes allocations}'
    Add-Content -Path $texFile -Value '\addcontentsline{toc}{chapter}{Flights and chutes allocations}'
    Add-Content -Path $texFile -value "\subsection*{ABISv2 allocations}"
    
    ####Early

    Add-Content -Path $texFile -value "\subsubsection*{Early}"
    $resultAllocs= Allocs $simid 2 "Early"
    Add-Content -Path $texFile -value "\paragraph{}"
    Add-Content -Path $texFile -value "\begin{longtable}{ccccc}    \toprule"
    Add-Content -Path $texFile -value "\rowcolor{white!50}"
    Add-Content -Path $texFile -Value "\textbf{Flight} & \textbf{Sorting} & \textbf{Chute} & \textbf{Open} & \textbf{Close} \\\midrule"
    
    $line=""
    foreach ($al in $resultAllocs) {

        #$date=$al.sdt
        $sorting=$al.xalc_sorstr
        $fli=$al.Flight
        $chute=$al.Chute
        $chOpen=$al.ch_open
        $chClose=$al.ch_close
        $line = "$fli & $sorting & $chute & $chOpen & $chClose\\"
        Add-Content -Path $texFile -value $line        
    }
    Add-Content -Path $texFile -value "\bottomrule"
    Add-Content -Path $texFile -value "\end{longtable}"

    ####ONTIME

    Add-Content -Path $texFile -value "\subsubsection*{Ontime}"
    $resultAllocs= Allocs $simid 2 "Ontime"
    Add-Content -Path $texFile -value "\paragraph{}"
    Add-Content -Path $texFile -value "\begin{longtable}{ccccc}    \toprule"
    Add-Content -Path $texFile -value "\rowcolor{white!50}"
    Add-Content -Path $texFile -Value "\textbf{Flight} & \textbf{Sorting} & \textbf{Chute} & \textbf{Open} & \textbf{Close} \\\midrule"
    
    $line=""
    foreach ($al in $resultAllocs) {

        #$date=$al.sdt
        $sorting=$al.xalc_sorstr
        $fli=$al.Flight
        $chute=$al.Chute
        $chOpen=$al.ch_open
        $chClose=$al.ch_close
        $line = "$fli & $sorting & $chute & $chOpen & $chClose\\"
        Add-Content -Path $texFile -value $line        
    }
    Add-Content -Path $texFile -value "\bottomrule"
    Add-Content -Path $texFile -value "\end{longtable}"

    ###LATE

    Add-Content -Path $texFile -value "\subsubsection*{Late and too late}"
    $resultAllocs= Allocs $simid 2 "Late"
    Add-Content -Path $texFile -value "\paragraph{}"
    Add-Content -Path $texFile -value "\begin{longtable}{ccccc}    \toprule"
    Add-Content -Path $texFile -value "\rowcolor{white!50}"
    Add-Content -Path $texFile -Value "\textbf{Flight} & \textbf{Sorting} & \textbf{Chute} & \textbf{Open} & \textbf{Close} \\\midrule"
    
    $line=""
    foreach ($al in $resultAllocs) {

        #$date=$al.sdt
        $sorting=$al.xalc_sorstr
        $fli=$al.Flight
        $chute=$al.Chute
        $chOpen=$al.ch_open
        $chClose=$al.ch_close
        $line = "$fli & $sorting & $chute & $chOpen & $chClose\\"
        Add-Content -Path $texFile -value $line        
    }
    Add-Content -Path $texFile -value "\bottomrule"
    Add-Content -Path $texFile -value "\end{longtable}"
    #----------------------------------------------------------------------------------------------

    #Add-Content -Path $texFile -Value '\addcontentsline{toc}{chapter}{Chutes allocations}'
    Add-Content -Path $texFile -value "\subsection*{ABISv1 allocations}"

        ####Early

        Add-Content -Path $texFile -value "\subsubsection*{Early}"
        $resultAllocs= Allocs $simid 1 "Early"
        Add-Content -Path $texFile -value "\paragraph{}"
        Add-Content -Path $texFile -value "\begin{longtable}{ccccc}    \toprule"
        Add-Content -Path $texFile -value "\rowcolor{white!50}"
        Add-Content -Path $texFile -Value "\textbf{Flight} & \textbf{Sorting} & \textbf{Chute} & \textbf{Open} & \textbf{Close} \\\midrule"
        
        $line=""
        foreach ($al in $resultAllocs) {
    
            #$date=$al.sdt
            $sorting=$al.xalc_sorstr
            $fli=$al.Flight
            $chute=$al.Chute
            $chOpen=$al.ch_open
            $chClose=$al.ch_close
            $line = "$fli & $sorting & $chute & $chOpen & $chClose\\"
            Add-Content -Path $texFile -value $line        
        }
        Add-Content -Path $texFile -value "\bottomrule"
        Add-Content -Path $texFile -value "\end{longtable}"
    
        ####ONTIME
    
        Add-Content -Path $texFile -value "\subsubsection*{Ontime}"
        $resultAllocs= Allocs $simid 1 "Ontime"
        Add-Content -Path $texFile -value "\paragraph{}"
        Add-Content -Path $texFile -value "\begin{longtable}{ccccc}    \toprule"
        Add-Content -Path $texFile -value "\rowcolor{white!50}"
        Add-Content -Path $texFile -Value "\textbf{Flight} & \textbf{Sorting} & \textbf{Chute} & \textbf{Open} & \textbf{Close} \\\midrule"
        
        $line=""
        foreach ($al in $resultAllocs) {
    
            #$date=$al.sdt
            $sorting=$al.xalc_sorstr
            $fli=$al.Flight
            $chute=$al.Chute
            $chOpen=$al.ch_open
            $chClose=$al.ch_close
            $line = "$fli & $sorting & $chute & $chOpen & $chClose\\"
            Add-Content -Path $texFile -value $line        
        }
        Add-Content -Path $texFile -value "\bottomrule"
        Add-Content -Path $texFile -value "\end{longtable}"
    
        ###LATE
    
        Add-Content -Path $texFile -value "\subsubsection*{Late and too late}"
        $resultAllocs= Allocs $simid 1 "Late"
        Add-Content -Path $texFile -value "\paragraph{}"
        Add-Content -Path $texFile -value "\begin{longtable}{ccccc}    \toprule"
        Add-Content -Path $texFile -value "\rowcolor{white!50}"
        Add-Content -Path $texFile -Value "\textbf{Flight} & \textbf{Sorting} & \textbf{Chute} & \textbf{Open} & \textbf{Close} \\\midrule"
        
        $line=""
        foreach ($al in $resultAllocs) {
    
            #$date=$al.sdt
            $sorting=$al.xalc_sorstr
            $fli=$al.Flight
            $chute=$al.Chute
            $chOpen=$al.ch_open
            $chClose=$al.ch_close
            $line = "$fli & $sorting & $chute & $chOpen & $chClose\\"
            Add-Content -Path $texFile -value $line        
        }
        Add-Content -Path $texFile -value "\bottomrule"
        Add-Content -Path $texFile -value "\end{longtable}"
        #--------------------------------------------------------------------------------------

    #----------STARTBAGSLSSNG2

    Add-Content -Path $texFile -value '\chapter*{Local and Transfer bags}'
    Add-Content -Path $texFile -Value '\addcontentsline{toc}{chapter}{Local and Transfer bags}'
    #Add-Content -Path $texFile -value '\rowcolors{2}{gray!25}{white}'
    
    

    
    
    $i=0
    for ($i = 1; $i -le 1440; $i++)
    {
        $bag=$i
        
        [string] $UserSqlQueryDep= $("SELECT xbpm_tag,xbpm_evloc,
        ISNULL(xbpm_evtp,'') AS xbpm_evtp,
        convert (varchar(35),xbpm_evdt,108) as xbpm_evdt,
        ISNULL(xbpm_ob_apiata,'') AS xbpm_ob_apiata,
        ISNULL(xbpm_bgstat,'') AS xbpm_bgstat,
        ISNULL(xbpm_bie,'') AS xbpm_bie,
        ISNULL(xbpm_tobie,'') AS xbpm_tobie,
        ISNULL(compare_result,'') AS compare_result,
        ISNULL(xbpm_ob_coicao,'') AS xbpm_ob_coicao,
        ISNULL(xbpm_ob_flnum,'') AS xbpm_ob_flnum,
        ISNULL(xbpm_ob_flopsfx,'') AS xbpm_ob_flopsfx
        FROM vw_compare_LSSNG2_$handler`_$sorter`_$depArr where bag_index=$bag order by bag_index, xbpm_evdt")
    
        [string] $UserSqlQueryLPT= $("SELECT xbpm_tag,xbpm_evloc,
        ISNULL(xbpm_evtp,'') AS xbpm_evtp,
        convert (varchar(35),xbpm_evdt,108) as xbpm_evdt,
        ISNULL(xbpm_ob_apiata,'') AS xbpm_ob_apiata,
        ISNULL(xbpm_bgstat,'') AS xbpm_bgstat,
        ISNULL(xbpm_bie,'') AS xbpm_bie,
        ISNULL(xbpm_tobie,'') AS xbpm_tobie,
        ISNULL(compare_result,'') AS compare_result,
        ISNULL(xbpm_ob_coicao,'') AS xbpm_ob_coicao,
        ISNULL(xbpm_ob_flnum,'') AS xbpm_ob_flnum,
        ISNULL (xbpm_ob_flopsfx,'') AS xbpm_ob_flopsfx
        FROM vw_compare_LSSNG1_$handler`_$sorter`_$depArr where bag_index=$bag order by bag_index, xbpm_evdt")
    
        $resultsDataTable = New-Object System.Data.DataTable
        $resultTags=New-Object System.Data.DataTable
        $resultsDataTable = ExecuteSqlQuery $Server $Database $UserSqlQueryDep
        
        $topics= $resultsDataTable | Format-Table
        $Number_Of_Rows = ($topics.Count -3)
        
        

        Add-Content -Path $texFile -value "\section*{Simulation bag $bag}"
       

        $lss="LSSNG2"
        $resultTags=GetBagTag $bag $handler $sorter $lss
        $resultBagSorting=GetBagSorting $bag $handler $sorter $lss
        $resultFlight=GetBagFlight $bag $handler $sorter $lss
        $resultiFlight=GetBagiFlight $bag $handler $sorter $lss
        [string]$tag=$resultTags[0]
        [string]$FliBag=$resultFlight[0]
        [string]$bagStr=$resultBagSorting[0]
        if ($null -eq $resultiFlight) {
            [string]$iFli=''            
        }else {
            [string]$iFli=$resultiFlight[0]
        }
        


        if ($iFli -eq '') {

            Add-Content -Path $texFile -value "\subsection*{ABISv2 bagtag: $tag Outbound flight: $FliBag}"
            
        }else {
            Add-Content -Path $texFile -value "\subsection*{ABISv2 bagtag: $tag / Outbound flight: $FliBag / Inbound flight: $iFli}"
        }
        Add-Content -Path $texFile -value "\textbf{Sorting string} $bagStr"
        Add-Content -Path $texFile -value "\paragraph{}"
        Add-Content -Path $texFile -value "\begin{longtable}{cccccccc}    \toprule"
        Add-Content -Path $texFile -value "\rowcolor{white!50}"
        Add-Content -Path $texFile -Value "\textbf{Ev.Type} & \textbf{Ev.Location} & \textbf{Ev.Time} & \textbf{Outbound} & \textbf{Bag Stat.} & \textbf{BIE} & \textbf{toBIE} & \textbf{Matches ABISv1} \\\midrule"
        #Add-Content -Path $texFile -value "\rowcolor{gray!25}"

        


        
        $x=2
        [string]$row=""
        Foreach($t in $resultsDataTable)
        {
            
            $evtp = $t.xbpm_evtp
            $evloc=$t.xbpm_evloc
            $evdt=$t.xbpm_evdt
            $apiata=$t.xbpm_ob_apiata
            $bgstat=$t.xbpm_bgstat
            $bie=$t.xbpm_bie.Trim()
            $tobie=$t.xbpm_tobie.Trim()
            $result=$t.compare_result
            $Flight=$t.xbpm_ob_coicao.Trim()+$t.xbpm_ob_flnum.Trim()+$t.xbpm_ob_flopsfx.Trim()
            $Flight=$flight.trim()
           
            if ($t.compare_result -eq "#N/A")
            {
                $a = 'NOK'
            }Else
            {
                $a = $t.compare_result
            }
            if ($t.compare_result -eq "Matches_V1")
            {
                $a = 'OK'
            }
            $row="$evtp & $evloc & $evdt  & $apiata & $bgstat & $bie & $tobie & $result\\" 
            Add-Content -Path $texFile -value $row
            
            $x++
    

        } 
        Add-Content -Path $texFile -value "\bottomrule"
        Add-Content -Path $texFile -value "\end{longtable}"
        
        #———————————————————————————————————————————————————————————————————————————————————————————————————
        #---------------STARTBAGSLSSNG1

        $resultsDataTable = New-Object System.Data.DataTable
        $resultTags=New-Object System.Data.DataTable
        $resultsDataTable = ExecuteSqlQuery $Server $Database $UserSqlQueryLPT
        
        $topics= $resultsDataTable | Format-Table
        $Number_Of_Rows = ($topics.Count -3)
    
        
        $lss="LSSNG1"
        $resultTags=GetBagTag $bag $handler $sorter $lss
        $resultBagSorting=GetBagSorting $bag $handler $sorter $lss
        $resultFlight=GetBagFlight $bag $handler $sorter $lss
        $resultiFlight=GetBagiFlight $bag $handler $sorter $lss
        [string]$tag=$resultTags[0]
        [string]$FliBag=$resultFlight[0]
        [string]$bagStr=$resultBagSorting[0]
        if ($null -eq $resultiFlight) {
            [string]$iFli=''            
        }else {
            [string]$iFli=$resultiFlight[0]
        }
        
        if ($iFli -eq '') {

            Add-Content -Path $texFile -value "\subsection*{ABISv1 bagtag: $tag Outbound flight: $FliBag}"
        }else {
            Add-Content -Path $texFile -value "\subsection*{ABISv1 bagtag: $tag / Outbound flight: $FliBag / Inbound flight: $iFli}"
        }
        Add-Content -Path $texFile -value "\textbf{Sorting string} $bagStr"
        Add-Content -Path $texFile -value "\paragraph{}"
        Add-Content -Path $texFile -value "\begin{longtable}{cccccccc}    \toprule"
        Add-Content -Path $texFile -value "\rowcolor{white!50}"
        Add-Content -Path $texFile -Value "\textbf{Ev.Type} & \textbf{Ev.Location} & \textbf{Ev.Time} & \textbf{Outbound} & \textbf{Bag Stat.} & \textbf{BIE} & \textbf{toBIE} & \textbf{Matches ABISv2} \\\midrule"
        
        
        $x=2
        Foreach($t in $resultsDataTable)
        {
    
            $evtp = $t.xbpm_evtp
            $evloc=$t.xbpm_evloc
            $evdt=$t.xbpm_evdt
            $apiata=$t.xbpm_ob_apiata
            $bgstat=$t.xbpm_bgstat
            $bie=$t.xbpm_bie.Trim()
            $tobie=$t.xbpm_tobie.Trim()
            $result=$t.compare_result
            $Flight=$t.xbpm_ob_coicao.Trim()+$t.xbpm_ob_flnum.Trim()+$t.xbpm_ob_flopsfx.Trim()
            $Flight=$flight.trim()
            if ($t.compare_result -eq "#N/A")
            {
                $a = 'NOK'
            }Else
            {
                $a = $t.compare_result
            }
            if ($t.compare_result -eq "Matches_V2")
            {
                $a = 'OK'
            }
            $row="$evtp & $evloc & $evdt  & $apiata & $bgstat & $bie & $tobie & $result\\" 
            Add-Content -Path $texFile -value $row
            $x++
        }
        Add-Content -Path $texFile -value "\bottomrule"
        Add-Content -Path $texFile -value "\end{longtable}" 
        Add-Content -Path $texFile -Value '\pagebreak'
    
        
        
    }
    #-----------------TERMINATINGBAGS
   
    Add-Content -Path $texFile -value '\chapter*{Terminating bags}'
    Add-Content -Path $texFile -Value '\addcontentsline{toc}{chapter}{Terminating bags}'

    
    
    $j=0
    $depArr="A"
    $lss='LSSNG2'
    $getListOfBags ="SELECT DISTINCT (xbpm_tag) FROM vw_compare_LSSNG2_$handler`_$sorter`_$depArr order by xbpm_tag"

    $resultsDataTable = New-Object System.Data.DataTable
    $resultTags=New-Object System.Data.DataTable
    $resultsDataTable = ExecuteSqlQuery $Server $Database $getListOfBags
            
    $topics= $resultsDataTable | Format-Table

    $x=2
    $l=1
    
    Foreach($b in $resultsDataTable)
    {
        $bagTag=$b.xbpm_tag
        [string] $UserSqlQueryArr= $("SELECT xbpm_tag,xbpm_evloc,
        ISNULL(xbpm_evtp,'') AS xbpm_evtp,
        convert (varchar(35),xbpm_evdt,108) as xbpm_evdt,
        ISNULL (iFlight,'') AS iFlight,
        ISNULL(xbpm_ib_apiata,'') AS xbpm_ib_apiata,
        ISNULL(xbpm_bgstat,'') AS xbpm_bgstat,
        ISNULL(xbpm_bie,'') AS xbpm_bie,
        ISNULL(xbpm_tobie,'') AS xbpm_tobie,
        ISNULL(compare_result,'') AS compare_result
        FROM vw_compare_LSSNG2_$handler`_$sorter`_$depArr where xbpm_tag=$bagTag order by bag_index, xbpm_evdt")
        $resultsDataTables = New-Object System.Data.DataTable
        $resultTagss=New-Object System.Data.DataTable
        $resultsDataTables = ExecuteSqlQuery $Server $Database $UserSqlQueryArr
            
        $topics= $resultsDataTables | Format-Table
        Add-Content -Path $texFile -value "\section*{Simulation bag $l}"
        
        [string]$tag=$bagTag
 
 
 
        #$resultTagss=GetBagTag $bag $handler $sorter $lss
        $resultBagSorting=GetiBagSorting $tag $handler $sorter $lss
        $resultiFlight=GetBagiFlight $tag $handler $sorter $lss
        
        [string]$bagStr=$resultBagSorting[0]
        
        if ($null -eq $resultiFlight) {
            [string]$iFli=''            
        }else {
            [string]$iFli=$resultiFlight[0]
        }
        


        if ($iFli -eq '') {

            Add-Content -Path $texFile -value "\subsection*{ABISv2 bagtag: $bagTag}"
            
        }else {
            Add-Content -Path $texFile -value "\subsection*{ABISv2 bagtag: $bagTag / Inbound flight: $iFli}"
        }

        Add-Content -Path $texFile -value "\textbf{Sorting string} $bagStr"
        Add-Content -Path $texFile -value "\paragraph{}"
        Add-Content -Path $texFile -value "\begin{longtable}{ccccccc}    \toprule"
        Add-Content -Path $texFile -value "\rowcolor{white!50}"
        Add-Content -Path $texFile -Value "\textbf{Ev.Type} & \textbf{Ev.Location} & \textbf{Ev.Time} & \textbf{Inbound} & \textbf{Bag Stat.} & \textbf{BIE} & \textbf{toBIE} \\\midrule"

        $p=2
        [string]$row=""
        Foreach($t in $resultsDataTables)
        {
            
            $evtp = $t.xbpm_evtp
            $evloc=$t.xbpm_evloc
            $evdt=$t.xbpm_evdt
            $apiata=$t.xbpm_ib_apiata
            $bgstat=$t.xbpm_bgstat
            $bie=$t.xbpm_bie.Trim()
            $tobie=$t.xbpm_tobie.Trim()
            $result=$t.compare_result
            $Flight=$t.iFlight
           
            if ($t.compare_result -eq "#N/A")
            {
                $a = 'NOK'
            }Else
            {
                $a = $t.compare_result
            }
            if ($t.compare_result -eq "Matches_V1")
            {
                $a = 'OK'
            }
            $row="$evtp & $evloc & $evdt  & $apiata & $bgstat & $bie & $tobie \\" 
            Add-Content -Path $texFile -value $row
            
            $p++
            
    

        } 
        Add-Content -Path $texFile -value "\bottomrule"
        Add-Content -Path $texFile -value "\end{longtable}"



        $x++
        $l++
    }



    # for ($j=1; $j -le 180; $j++)
    # {
    #     $bag=$j
        
    #     [string] $UserSqlQueryArr= $("SELECT xbpm_tag,xbpm_evloc,
    #     ISNULL(xbpm_evtp,'') AS xbpm_evtp,
    #     convert (varchar(35),xbpm_evdt,108) as xbpm_evdt,
    #     ISNULL (iFlight,'') AS iFlight,
    #     ISNULL(xbpm_ib_apiata,'') AS xbpm_ib_apiata,
    #     ISNULL(xbpm_bgstat,'') AS xbpm_bgstat,
    #     ISNULL(xbpm_bie,'') AS xbpm_bie,
    #     ISNULL(xbpm_tobie,'') AS xbpm_tobie,
    #     ISNULL(compare_result,'') AS compare_result
    #     FROM vw_compare_LSSNG2_$handler`_$sorter`_$depArr where bag_index=$bag order by bag_index, xbpm_evdt")

    #     $resultsDataTable = New-Object System.Data.DataTable
    #     $resultTags=New-Object System.Data.DataTable
    #     $resultsDataTable = ExecuteSqlQuery $Server $Database $UserSqlQueryArr
            
    #     $topics= $resultsDataTable | Format-Table
    #     Add-Content -Path $texFile -value "\section*{Simulation bag $bag}"
        
    #     $lss="LSSNG2"
    #     $resultTags=GetBagTag $bag $handler $sorter $lss
    #     $resultBagSorting=GetBagSorting $bag $handler $sorter $lss
    #     $resultiFlight=GetBagiFlight $bag $handler $sorter $lss
    #     [string]$tag=$resultTags[0]
    #     [string]$bagStr=$resultBagSorting[0]
        
    #     if ($null -eq $resultiFlight) {
    #         [string]$iFli=''            
    #     }else {
    #         [string]$iFli=$resultiFlight[0]
    #     }
        


    #     if ($iFli -eq '') {

    #         Add-Content -Path $texFile -value "\subsection*{ABISv2 bagtag: $tag}"
            
    #     }else {
    #         Add-Content -Path $texFile -value "\subsection*{ABISv2 bagtag: $tag / Inbound flight: $iFli}"
    #     }
    #     Add-Content -Path $texFile -value "\textbf{Sorting string} $bagStr"
    #     Add-Content -Path $texFile -value "\paragraph{}"
    #     Add-Content -Path $texFile -value "\begin{longtable}{ccccccc}    \toprule"
    #     Add-Content -Path $texFile -value "\rowcolor{white!50}"
    #     Add-Content -Path $texFile -Value "\textbf{Ev.Type} & \textbf{Ev.Location} & \textbf{Ev.Time} & \textbf{Inbound} & \textbf{Bag Stat.} & \textbf{BIE} & \textbf{toBIE} \\\midrule"

    #     $x=2
    #     [string]$row=""
    #     Foreach($t in $resultsDataTable)
    #     {
            
    #         $evtp = $t.xbpm_evtp
    #         $evloc=$t.xbpm_evloc
    #         $evdt=$t.xbpm_evdt
    #         $apiata=$t.xbpm_ib_apiata
    #         $bgstat=$t.xbpm_bgstat
    #         $bie=$t.xbpm_bie.Trim()
    #         $tobie=$t.xbpm_tobie.Trim()
    #         $result=$t.compare_result
    #         $Flight=$t.iFlight
           
    #         if ($t.compare_result -eq "#N/A")
    #         {
    #             $a = 'NOK'
    #         }Else
    #         {
    #             $a = $t.compare_result
    #         }
    #         if ($t.compare_result -eq "Matches_V1")
    #         {
    #             $a = 'OK'
    #         }
    #         $row="$evtp & $evloc & $evdt  & $apiata & $bgstat & $bie & $tobie \\" 
    #         Add-Content -Path $texFile -value $row
            
    #         $x++
    

    #     } 
    #     Add-Content -Path $texFile -value "\bottomrule"
    #     Add-Content -Path $texFile -value "\end{longtable}"


    # }

      

    
    
    Add-Content -Path $texFile -value "\end{document}"
    #'pdflatex  --max-print-line=10000 -synctex=1 -interaction=nonstopmode -file-line-error -recorder -output-directory="c:/Users/zahrounh.BRU-AIR.000/OneDrive - Brussels Airport Company"  "c:\Users\zahrounh.BRU-AIR.000\OneDrive - Brussels Airport Company\test.tex"'
    #Remove-Variable * -ErrorAction SilentlyContinue