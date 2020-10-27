if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}


function Show-PromptCompleteJob {
  $job = $Global:currentJob
  $jobType = $job.Type
  $passedNotes = $Global:notesStepPassed
  $notes = $Global:notes
  $duration = $Global:duration
  $isTimed = $jobType -eq 'Quest-Timed'

  if ($isTimed -and !$duration) {
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
    Write-Host "   $(Get-PaddedString "[Enter] to continue" -Right $true)"
    Write-Host ""
    $duration = Read-InputLine "  Duration: "
    $Global:inputValue = $duration
  } elseif (!$passedNotes) {
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
    Write-Host "   $(Get-PaddedString "[Enter] to continue" -Right $true)"
    Write-Host ""
    $notes = Read-InputLine "  Notes (optional): "
    $Global:inputValue = $notes
  }
  # Uncomment to add confirm step
  #  else {
  #   Write-Host ""
  #   Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
  #   Write-Host ""
  #   Write-Host "  Press [any key] to continue..."
  #   Write-Host ""
  #   do {
  #     $char = Read-Character
  #   } until ($char -eq [System.ConsoleKey]::Enter `
  #     -or $char -eq [System.ConsoleKey]::Escape)
  #   $Global:inputValue = $char
  # }
}

function Show-JobConfirmComplete {
  $job = $Global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate

  Clear-Host
  Write-Host ""
  Show-JobHeading "Complete: $jobTitle" $jobType $jobRate

  $width = $Global:containerWidth
  $passedNotes = $Global:notesStepPassed
  $notes = $Global:notes
  $duration = $Global:duration
  $isTimed = $jobType -eq 'Quest-Timed'

  if ($isTimed -and !$duration) {
    # prompt for duration
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  } else {
    # show duration
    Write-Host "  |$(Get-PaddedString "  Duration: $duration")|  "
    if (!$passedNotes) {
      Write-Host "  |$(Get-PaddedString "  [...]")|  "
      Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    }
    else {
      if ($notes) {
        Write-Host "  |$(Get-PaddedString "  Notes: $(Get-TextExcerpt $notes ($width-11))")|  "
        Write-Host "  |$(Get-PaddedString)|  "
      }
      Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    }
  }
}

function Show-JobCompleteSuccess {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Heading,
    [Parameter(Mandatory = $false, Position = 1)]
    [string]$Message = ''
  )
  $width = $global:containerWidth

  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  $Heading")|  "
  if ($Message -ne '') {
    Write-Host "  |$(Get-PaddedString)|  "
    $textLines = Get-TextLines $Message ($width - 4)
    foreach ($line in $textLines) {
      Write-Host "  |$(Get-PaddedString "  $line" )|  "
    }
  }
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
