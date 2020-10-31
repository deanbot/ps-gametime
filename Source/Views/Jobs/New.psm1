
if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

function Show-JobNew {
  Clear-Host
  Write-Host ""
  Show-Heading "New $Label_Single_Quest"
  Write-Host "  |$(Get-PaddedString)|  "
  $title = $Global:newJobTitle
  $type = $Global:currentJobType
  $rate = $Global:newJobRate
  $subType = $Global:newJobSubType
  $isTimed = $subType -eq 'Timed'

  if ($title) {
    Write-Host "  |$(Get-PaddedString "  Title:   $title")|  "
    if ($isTimed) {
      Write-Host "  |$(Get-PaddedString "  Type:    $type (Timed)")|  "
    }
    else {
      Write-Host "  |$(Get-PaddedString "  Type:    $type")|  "
    }

    if ($subType -or $type -ne 'Quest') {
      if (!$rate) {
        # Rewards/Rate prompt
        Write-Host "  |$(Get-PaddedString "  [...]")|  "
        Write-Host "  |$(Get-PaddedString -Fill ' ')|  "
        Write-Host "  |$(Get-PaddedString -Fill '_')|  "
      }
      else {
        if ($isTimed) {
          Write-Host "  |$(Get-PaddedString "  Rewards: $rate pts/h")|  "
        }
        else {
          Write-Host "  |$(Get-PaddedString "  Rewards: $rate pts")|  "
        }
        Write-Host "  |$(Get-PaddedString -Fill ' ')|  "
        Write-Host "  |$(Get-PaddedString -Fill '_')|  "
      }
    }
    else {
      Write-Host "  |$(Get-PaddedString -Fill ' ')|  "
      Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    }
  }
  else {
    # Title Prompt
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString "  Type:    $type")|  "
    Write-Host "  |$(Get-PaddedString -Fill ' ')|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  }
}

function Show-PromptNewJob() {
  $title = $Global:newJobTitle
  $type = $Global:currentJobType
  $rate = $Global:newJobRate
  $subType = $Global:newJobSubType
  $isTimed = $subType -eq 'Timed'
  if (!$title) {
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
    Write-Host ""
    $title = Read-InputLine "  Title: "
    $Global:inputValue = $title
  } elseif ($subType -or $type -ne 'Quest') {
    if (!$rate) {
      Write-Host ""
      Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
      Write-Host ""
      if ($isTimed) {
        Write-Host "  Input pts/h..."
      }
      else {
        Write-Host "  Input pts..."
      }
      Write-Host ""
      $rate = Read-InputLine "  Rewards: "
      $Global:inputValue = $rate
    } else {
      Write-Host ""
      Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
      Write-Host ""
      Write-Host "  Create $Label_Single_Quest"
      Write-Host "  [Y] Yes  [N] No: "
      do {
        $createJob = Read-Character
      } until ($createJob -eq 'y' `
        -or $createJob -eq 'n' `
        -or $createJob -eq [System.ConsoleKey]::Escape)
      $Global:inputValue = $createJob
    }
  } else {
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
    Write-Host ""
    Write-Host "  Is Quest Timed?"
    Write-Host "  [Y] Yes  [N] No: "
    do {
      $timed = Read-Character
    } until ($timed -eq 'y' `
      -or $timed -eq 'n' `
      -or $timed -eq [System.ConsoleKey]::Escape)
    $Global:inputValue = $timed
  }
}

function Show-JobNewFailed {
  Param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$reason
  )

  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  No $Label_Single_Quest_Lower created.")|  "
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

function Show-JobNewSuccess {
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  $Label_Single_Quest created successfully!")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  Write-Host "  Press [any key] to continue..."
  Write-Host ""
  $char = Read-Character -Blocking $true
}
