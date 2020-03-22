function Show-LogsMenu {
  $width = $global:containerWidth
  Write-Host ""
  Show-Heading "Logs"
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}