function Show-OptionsMenu {
  $width = $global:containerWidth
  $pos = $global:menuPositionY
  $resetPointsLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))Reset Points"
  $factoryResetLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))Factory Reset"



  Write-Host ""
  Show-Heading "Main Menu"
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Pages:")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$resetPointsLine|  "
  Write-Host "  |$factoryResetLine|  "
  Write-Host "  |$(Get-PaddedString)|  "
  # Write-Host "  |$(Get-PaddedString '  Press [Enter] to select')|  "
  # Show-ControlsFooter
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}
