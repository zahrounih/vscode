$Path="C:\power\bie.txt"
$PathTo="C:\power\to.txt"
$PathStatus="C:\power\status.txt"
$output="C:\power\create_allocs.txt"
$json="C:\power\handler.json"
$jsonNSS="C:\power\handler_NSS.json"
$jsonPS1="C:\power\handler_PS1.json"
$jsonEBS="C:\power\handler_EBS.json"

$myObject = Get-Content -Path $json | ConvertFrom-Json
$i=3000

foreach ($bie in get-content $Path) {
    foreach ($sorter in $myObject.sorters)
    {
       foreach ($status in $sorter.status)
       {
           foreach ($handler in $status.handlers) 
           {
                $sor=$sorter.sorter
                $stat=$status.sta
                $hand=$handler.id
                $buf=$handler.buffer
                $buf

                $string = ""
                $string="exec pr_ab_buf_alc 'I',$i,'$bie','$sor','$stat',$hand,$buf,41"
                $string
                Add-Content $output $string
                $i++
           }
       }
    }
   
    
}

#-----NSS
$myObject = Get-Content -Path $jsonNSS | ConvertFrom-Json
foreach ($sorter in $myObject.sorters)
{
    foreach ($status in $sorter.status)
    {
        foreach ($handler in $status.handlers) 
        {
            $sor=$sorter.sorter
            $stat=$status.sta
            $hand=$handler.id
            $buf=$handler.buffer

            $string = ""
            $string="exec pr_ab_buf_alc 'I',$i,'NSS','$sor','$stat',$hand,$buf,45"
            $string
            Add-Content $output $string
            $i++
        }
    }
}

#-----PS1
$myObject = Get-Content -Path $jsonPS1 | ConvertFrom-Json
foreach ($sorter in $myObject.sorters)
{
    foreach ($status in $sorter.status)
    {
        foreach ($handler in $status.handlers) 
        {
            $sor=$sorter.sorter
            $stat=$status.sta
            $hand=$handler.id
            $buf=$handler.buffer

            $string = ""
            if ($sor -eq "C") {
                $string="exec pr_ab_buf_alc 'I',$i,'PS1','$sor','$stat',$hand,$buf,48"
            }else {
                $string="exec pr_ab_buf_alc 'I',$i,'PS1','$sor','$stat',$hand,$buf,47"
            }
            $string
            Add-Content $output $string
            $i++
        }
    }
}

#-----EBS
$myObject = Get-Content -Path $jsonEBS | ConvertFrom-Json
foreach ($sorter in $myObject.sorters)
{
    foreach ($status in $sorter.status)
    {
        foreach ($handler in $status.handlers) 
        {
            $sor=$sorter.sorter
            $stat=$status.sta
            $hand=$handler.id
            $buf=$handler.buffer

            $string = ""
            $string="exec pr_ab_buf_alc 'I',$i,'EBS','$sor','$stat',$hand,$buf,41"
            $string
            Add-Content $output $string
            $i++
        }
    }
}


   
    
