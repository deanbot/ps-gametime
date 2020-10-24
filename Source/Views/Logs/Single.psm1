function Show-LogSingle {
  $log = $global:currentTransaction
  $unit = $Global:unit
  $width = $global:containerWidth
  $logText = $log.Log
  $logNotes = $log.Note
  $logDate = $log.Date
  $logChange = $log.Change

  Write-Host ""
  Show-Heading "View Log"
  Write-Host "  |$(Get-PaddedString)|  "

  $dateText = "($logDate)"
  $availableSpace = $width - 4
  if ($logChange -gt 0) {
    $changeText = "Gained +$($logCHange) $unit"
  } else {
    $changeText = "Spent $(-1 * $logChange) $unit"
  }
  $changeText = Get-TextExcerpt $changeText ($availableSpace - $dateText.Length - 1)
  $dateText = Get-PaddedString $dateText -Right $true -Width ($availableSpace - $changeText.Length)
  $logLine = "  $(Get-TextExcerpt ($changeText + $dateText) $availableSpace)"
  Write-Host "  |$(Get-PaddedString $logLine)|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Details: " )|  "
  Write-Host "  |$(Get-PaddedString)|  "

  $textLines = Get-TextLines $logText $availableSpace
  foreach ($line in $textLines) {
    Write-Host "  |$(Get-PaddedString "  $line" )|  "
  }

  if ($logNotes) {
    Write-Host "  |$(Get-PaddedString)|  "
    Write-Host "  |$(Get-PaddedString "  Notes: " )|  "
    Write-Host "  |$(Get-PaddedString)|  "
    $textLines = Get-TextLines $logNotes $availableSpace
    foreach ($line in $textLines) {
      Write-Host "  |$(Get-PaddedString "  $line" )|  "
    }
  }
  Write-Host "  |$(Get-PaddedString -Fill ' ')|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}
