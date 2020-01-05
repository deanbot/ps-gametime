function Show-LogsMenu {
  $width = $global:containerWidth
  Write-Host ""
  Write-Host "    .------,"
  # Write-Host "  / Logs /___________________________   "
  Write-Host "   $(Get-PaddedString '/ Logs /' '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}