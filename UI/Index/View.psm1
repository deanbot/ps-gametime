function Show-MainMenu {
  $width = $global:containerWidth
  $pos = $global:menuPositionY
  $jobLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))View Jobs"
  $gameLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))Spend Points"
  $logLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 2))Review Logs"

  Write-Host ""
  Write-Host "    .-----------,"
  # Write-Host "  / Main Menu /___________________________   "
  Write-Host "   $(Get-PaddedString '/ Main Menu /' -Fill '_' -Width ($width))  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$jobLine|  "
  Write-Host "  |$gameLine|  "
  Write-Host "  |$logLine|  "
  Write-Host "  |$(Get-PaddedString)|  "
  # Write-Host "  |$(Get-PaddedString '  Press [Enter] to select')|  "
  # Show-ControlsFooter
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}