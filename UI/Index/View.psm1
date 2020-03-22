function Show-MainMenu {
  $width = $global:containerWidth
  $pos = $global:menuPositionY
  $jobLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))Jobs"
  $gameLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))Points"
  $logLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 2))Logs"

  Write-Host ""
  Show-Heading "Main Menu"
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Pages:")|  "
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