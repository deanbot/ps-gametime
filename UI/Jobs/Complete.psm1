function Show-JobConfirmComplete {
  $job = $global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate

  Clear-Host
  Write-Host ""
  Show-JobHeading "Complete: $jobTitle" $jobType $jobRate

  $passedNotes = $global:notesStepPassed
  $notes = $global:notes
  $duration = $global:duration
  $isQuest = $jobType -eq 'Quest'

  if ($isQuest) {
    if (!$duration) {
      # prompt for duration
      Write-Host "  |$(Get-PaddedString "  [...]")|  "
      Write-Host "  |$(Get-PaddedString -Fill '_')|  "
      Write-Host ""
      Write-Host "   $(Get-PaddedString "Enter [Q] to return" -Right $true)"
      Write-Host ""
      $duration = Read-Host "  Duration (in hours, i.e. 1 or .75)"
      $global:inputValue = $duration
      return
    }
    else {
      # show duration
      Write-Host "  |$(Get-PaddedString "  Duration: $duration")|  "
    }
  }

  if (!$passedNotes) {
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Enter [Q] to return" -Right $true)"
    Write-Host ""
    $notes = Read-Host "  Notes (optional)"
    $global:inputValue = $notes
  }
  else {
    Write-Host "  |$(Get-PaddedString "  Notes:    [...]")|  "
    Write-Host "  |$(Get-PaddedString)|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Press [Esc/Bksp] to return" -Right $true)"
    Write-Host ""
    Write-Host "  Complete Job?"
    Write-Host "  [Y] Yes  [N] No: "
    Write-Host ""
    do {
      $char = Read-Character
    } until ($char -eq 'y' `
        -or $char -eq 'n' `
        -or $char -eq [System.ConsoleKey]::Escape `
        -or $char -eq [System.ConsoleKey]::Backspace)
    $global:inputValue = $char
  }
}

function Show-JobCompleteSuccess {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Message
  )
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  $Message")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  Write-Host "  Press [any key] to continue..."
  Write-Host ""
  $char = Read-Character -Blocking $true
}

function Show-JobCompleteFailed {
  Param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$reason
  )

  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Job not completed.")|  "
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

function Show-JobCompleteDurationWarning {
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Notice!")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Enter duration as a decimal")|  "
  Write-Host "  |$(Get-PaddedString "  ... i.e. 1 or .25")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  Write-Host "  Press [any key] to continue..."
  Write-Host ""
  $char = Read-Character -Blocking $true
}