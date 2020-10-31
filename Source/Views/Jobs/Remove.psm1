function Show-JobConfirmRemove {
  $job = $Global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate

  Clear-Host
  Write-Host ""
  Show-JobHeading "Remove: $jobTitle" $jobType $jobRate
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
  Write-Host ""
  Write-Host "  Remove Job?"
  Write-Host "  [Y] Yes  [N] No"
  Write-Host ""
  do {
    $char = Read-Character
  } until ($char -eq 'y' `
      -or $char -eq 'n' `
      -or $char -eq [System.ConsoleKey]::Escape `
      -or $char -eq [System.ConsoleKey]::Backspace)

  $Global:inputValue = $char
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
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  Write-Host "  Press [any key] to continue..."
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
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  Write-Host "  Press [any key] to continue..."
  Write-Host ""
  $char = Read-Character -Blocking $true
}
