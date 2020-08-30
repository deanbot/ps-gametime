if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}


function Show-JobConfirmComplete {
  $job = $Global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate

  Clear-Host
  Write-Host ""
  Show-JobHeading "Complete: $jobTitle" $jobType $jobRate

  $passedNotes = $Global:notesStepPassed
  $notes = $Global:notes
  $duration = $Global:duration
  $isTimed = $jobType -eq 'Quest-Timed'

  if ($isTimed) {
    if (!$duration) {
      # prompt for duration
      Write-Host "  |$(Get-PaddedString "  [...]")|  "
      Write-Host "  |$(Get-PaddedString -Fill '_')|  "
      Write-Host ""
      Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
      Write-Host ""
      Write-Host "  Input hours then press [Enter]..."
      Write-Host ""
      $duration = Read-InputLine "  Duration: "
      $Global:inputValue = $duration
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
    Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
    Write-Host ""
    Write-Host "  Input notes then press [Enter]..."
    Write-Host ""
    $notes = Read-InputLine "  Notes (optional): "
    $Global:inputValue = $notes
  }
  else {
    Write-Host "  |$(Get-PaddedString "  Notes:    [...]")|  "
    Write-Host "  |$(Get-PaddedString)|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
    Write-Host ""
    Write-Host "  Press [Enter] to complete"
    Write-Host ""
    do {
      $char = Read-Character
    } until ($char -eq [System.ConsoleKey]::Enter `
        -or $char -eq [System.ConsoleKey]::Escape)
    $Global:inputValue = $char
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