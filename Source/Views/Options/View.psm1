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

function Show-OptionsConfirmResetPoints {
  $width = $global:containerWidth
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  $heading = "Reset Game Time Points?"
  $main = "This will set your balance to 0."
  $textLines = Get-TextLines $heading ($width - 4)
  foreach ($line in $textLines) {
    Write-Host "  |$(Get-PaddedString "  $line" )|  "
  }
  if ($heading && $Main) {
    Write-Host "  |$(Get-PaddedString)|  "
  }
  $textLines = Get-TextLines $main ($width - 4)
  foreach ($line in $textLines) {
    Write-Host "  |$(Get-PaddedString "  $line" )|  "
  }
  Write-Host "  |$(Get-PaddedString "  Logs will not be deleted.")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
}

function Show-OptionsConfirmFactoryReset {
  $width = $global:containerWidth
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  $heading = "Reset Game Time?"
  $main = "This will clear all jobs and logs?"
  $textLines = Get-TextLines $heading ($width - 4)
  foreach ($line in $textLines) {
    Write-Host "  |$(Get-PaddedString "  $line" )|  "
  }
  if ($heading && $Main) {
    Write-Host "  |$(Get-PaddedString)|  "
  }
  $textLines = Get-TextLines $main ($width - 4)
  foreach ($line in $textLines) {
    Write-Host "  |$(Get-PaddedString "  $line" )|  "
  }
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
}

function Show-PromptOptionsFactoryReset {
  Show-PromptBool "Factory Reset?"
}

function Show-PromptOptionsResetPoints {
  Show-PromptBool "Reset Points?"
}
