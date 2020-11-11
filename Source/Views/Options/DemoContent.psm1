function Show-OptionsDemoContentMenu {
  $width = $global:containerWidth
  $pos = $global:menuPositionY
  Write-Host ""
  Show-Heading "Install Demo Content"
  Write-Host "  |$(Get-PaddedString)|  "
  $message = "Clear all existing data and add demo content. See how to use Game Time for different scenarios."
  $textLines = Get-TextLines $message ($width - 4)
  foreach ($line in $textLines) {
    Write-Host "  |$(Get-PaddedString "  $line" )|  "
  }
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Select a demo:")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))Language learning")|  "
  Write-Host "  |$(Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))Weight loss")|  "
  Write-Host "  |$(Get-PaddedString "  $(Get-CheckBox ($pos -eq 2))Writing a book")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
}

function Show-OptionsConfirmDemoContent {
  $width = $global:containerWidth
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  $heading = "Install Demo Content?"
  $main = "Warning: this will clear all game data. Example quests and logs will be created."
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
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
}

function Show-PromptOptionsDemoContent {
  Show-PromptBool "Install Demo Content?"
}
