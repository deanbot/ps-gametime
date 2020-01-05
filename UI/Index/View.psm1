function Show-MainMenu {
  $width = $global:containerWidth
  $pos = $global:menuPositionY
  $jobLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))(J)obs"
  $gameLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))(G)ame"
  $logLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 2))(L)Log"

  Write-Host ""
  # Write-Host "   _______________________________________"
  Write-Host "   .-----------,"
  # Write-Host "  / Main Menu /___________________________   "
  Write-Host "  $(Get-PaddedString '/ Main Menu /' '_' ($width+1))  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$jobLine|  "
  Write-Host "  |$gameLine|  "
  Write-Host "  |$logLine|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString '  Press [Enter] to select')|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}