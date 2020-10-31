function Show-MainMenu {
  $width = $global:containerWidth
  $pos = $global:menuPositionY
  $jobLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))Browse $Label_Plural_Quest"
  $gameLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))Spend Points"
  $logLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 2))View Logs"
  $optionsLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 3))Options"

  Write-Host ""
  Show-Heading "Main Menu"
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Pages:")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$jobLine|  "
  Write-Host "  |$gameLine|  "
  Write-Host "  |$logLine|  "
  Write-Host "  |$optionsLine|  "
  Write-Host "  |$(Get-PaddedString)|  "
  # Write-Host "  |$(Get-PaddedString '  Press [Enter] to select')|  "
  # Show-ControlsFooter
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}
