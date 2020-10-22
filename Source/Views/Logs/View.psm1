$Path = $PSScriptRoot

Import-Module $Path\Shared.psm1 -Force

function Show-LogsMenu {
  $width = $global:containerWidth
  $logs = $global:currentLogs
  Write-Host ""
  Show-Heading "Logs"
  Write-Host "  |$(Get-PaddedString)|  "

  if ($logs) {
    Write-Host "  |$(Get-PaddedString "  Logs:")|  "
    Write-Host "  |$(Get-PaddedString)|  "

    Show-LogCheckBoxes $logs
  }

  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}
