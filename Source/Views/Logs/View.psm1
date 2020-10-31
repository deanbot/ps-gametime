$Path = $PSScriptRoot

Import-Module $Path\Shared.psm1 -Force
Import-Module $Path\Single.psm1 -Force

function Show-LogsMenu {
  $logs = $Global:currentTransactions
  Write-Host ""
  Show-Heading "Logs"
  Write-Host "  |$(Get-PaddedString)|  "
  if ($logs) {
    Write-Host "  |$(Get-PaddedString "  Select log to see details:")|  "
    Write-Host "  |$(Get-PaddedString)|  "
    Show-LogCheckBoxes $logs
    Show-LogPagination
  } else {
    Write-Host "  |$(Get-PaddedString "No logs found." -Center $true)|  "
    Write-Host "  |$(Get-PaddedString)|  "
    Write-Host "  |$(Get-PaddedString "Try completing some tasks or" -Center $true)|  "
    Write-Host "  |$(Get-PaddedString "redeeming points to see logs here." -Center $true)|  "

  }

  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}
