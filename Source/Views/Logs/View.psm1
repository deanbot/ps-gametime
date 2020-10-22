function Show-LogsMenu {
  $width = $global:containerWidth
  $logs = $global:logs
  Write-Host ""
  Show-Heading "Logs"
  Write-Host "  |$(Get-PaddedString)|  "

  if ($logs) {
    Write-Host "  |$(Get-PaddedString "  Logs:")|  "
    Write-Host "  |$(Get-PaddedString)|  "
    $pos = $global:menuPositionY
    for ($i = 0; $i -lt @($logs).Length; $i++) {
      $log = $logs[$i]
      $logNote = ""
      if ($log.Log) {
        $logNote = $log.Log
      } elseif ($log.Note) {
        $logNote = $log.Note
      }
      if ($logNote) {
        $logLine = "  $(Get-TextExcerpt $logNote ($width-4))"
        Write-Host "  |$(Get-PaddedString $logLine)|  "
      }
    }
  }

  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}
