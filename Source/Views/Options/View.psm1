$Path = $PSScriptRoot
Import-Module $Path\DemoContent.psm1 -Force

function Show-OptionsMenu {
  $width = $global:containerWidth
  $pos = $global:menuPositionY
  Write-Host ""
  Show-Heading "Options"
  Write-Host "  |$(Get-PaddedString)|  "
  $demoContentLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))Install Demo Content"
  $resetPointsLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))Reset Points"
  $factoryResetLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 2))Factory Reset"
  $storageLocationLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 3))Storage Location"
  Write-Host "  |$demoContentLine|  "
  Write-Host "  |$resetPointsLine|  "
  Write-Host "  |$factoryResetLine|  "
  Write-Host "  |$storageLocationLine|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

function Show-OptionsStorageLocation {
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString "Storage Location: $($global:storageLocation))|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "   $(Get-PaddedString -Fill '_')  "
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
  if ($heading -and $Main) {
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
  $main = "This will clear all $Label_Plural_Quest_Lower and logs?"
  $textLines = Get-TextLines $heading ($width - 4)
  foreach ($line in $textLines) {
    Write-Host "  |$(Get-PaddedString "  $line" )|  "
  }
  if ($heading -and $Main) {
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
