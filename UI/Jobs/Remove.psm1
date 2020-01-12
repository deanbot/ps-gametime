function Show-JobConfirmRemove {
  $job = $global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate

  Clear-Host
  Write-Host ""
  Show-JobHeading $jobTitle $jobType $jobRate
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Remove Job? Enter [y/n]")|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  do {
    $char = Read-Character
  } until ($char -eq 'y' `
      -or $char -eq 'n' `
      -or $char -eq [System.ConsoleKey]::Escape)
  $global:inputValue = $char
}
  
function Show-JobRemoveFailed {
  Param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$reason
  )

  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Job not removed.")|  "
  if ($reason) {
    Write-Host "  |$(Get-PaddedString "  $reason")|  "  
  }
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Press [any key] to continue.")|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  $char = Read-Character -Blocking $true
}

function Show-JobRemoveSuccess {

  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Job removed successfully!")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Press [any key] to continue.")|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  $char = Read-Character -Blocking $true
}
  