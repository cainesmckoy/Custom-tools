$company = Read-host "What is the company" 

$BDreport = Read-host "what is the report file name"
& {
        #The Path to the file you want to extract from
    
    $sourceFile = "C:\Users\username\Downloads\$company\Computer Worksheet.xlsx"
                                                                        #The Path of the output for each company
    $outFile = "C:\Users\username\Downloads\$company\data.txt"
    #The Row to start on
    $startRow = 11
    #The Column to start on
    $col = 4
    
    $usedCellType = 11

    $excelApp = New-Object -ComObject Excel.Application 

    try {
        $excelApp.visible = $false;
        $excelApp.DisplayAlerts = $false 

        $workbook = $excelApp.Workbooks.Open($sourceFile) 
                                                #The name of the SHEET. This is at the bottom of the Excel document. In reference to using many differnt sheets
        $worksheet = $workbook.WorkSheets.item("sheet")
        $endRow = $worksheet.UsedRange.SpecialCells($usedCellType).Row

        $rangeAddress = $worksheet.Cells.Item($startRow, $col).Address() + ":" + $worksheet.Cells.Item($endRow, $col).Address()
        Write-Host "Using range $($rangeAddress)"

        $worksheet.Range($rangeAddress).Value2 | Out-File -FilePath $outFile
        $workbook.Close($false) 
    }
    finally {
        $excelApp.Quit()
    }
}
