$P = Import-Csv -Path c:\power\alloc_early.csv -Delimiter ";"
#$P | Format-Table
$output="C:\power\create_allocs.txt"
$i=3000
foreach ($item in $p) {
    $string=""
    $from=$item.bie_from
    $to=$item.bie_to
    $hdl=$item.hdl_id
    $stat=$item.bgstat
    $stat=$stat.Trim()
    $srt=$item.srt_bufgrp_id
    $scr=$item.scrn_bufgrp_id
    $string="exec pr_ab_buf_alc 'I',$i,'$from','$to','LE',$hdl,$srt,$scr"
    $string
    Add-Content $output $string
    $i++
    $string="exec pr_ab_buf_alc 'I',$i,'$from','$to','ME',$hdl,$srt,$scr"
    $string
    Add-Content $output $string
    $i++
}