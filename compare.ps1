$xlfile1 = "C:\power\1_AL_A_A.xlsx"
$xlfile2 ="C:\power\2_AL_A_A.xlsx"
$OuputXlFile="C:\power\output.xlsx"

Remove-Item -Path $OuputXlFile -ErrorAction SilentlyContinue

#Import-Excel $xlfile1 -WorkSheetname "Grid Results" | Export-Excel $OuputXlFile -WorkSheetname "V1D" -TableName V1D -AutoSize -FreezeTopRow
#Import-Excel $xlfile2 -WorkSheetname "Grid Results" | Export-Excel $OuputXlFile -WorkSheetname "V2D" -TableName V2D -AutoSize -FreezeTopRow

Copy-ExcelWorksheet -SourceWorkbook $xlfile1 -SourceWorkSheet "Grid Results" -DestinationWorkSheet V1A -DestinationWorkbook $OuputXlFile
Export-Excel $OuputXlFile -WorkSheetname "V1A" -TableName V1A -AutoSize -AutoFilter

Copy-ExcelWorksheet -SourceWorkbook $xlfile2 -SourceWorkSheet "Grid Results" -DestinationWorkSheet V2A -DestinationWorkbook $OuputXlFile
Export-Excel $OuputXlFile -WorkSheetname "V2A" -TableName V2A -AutoSize -AutoFilter

$excel = Open-ExcelPackage $OuputXlFile
$sheet1 = $excel.Workbook.Worksheets["V1A"]
$sheet1.InsertColumn(2, 1)
$sum = '=SUM(C2-$C$2)+1' -f $PSItem
Set-ExcelRange -Worksheet $sheet1 -Range 'B$_' -Formula $sum

Close-ExcelPackage $excel -Show



