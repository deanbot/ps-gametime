function Show-JobNew {
  Clear-Host
  Write-Host ""
  Show-Heading "New Job"
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
        Write-Host ""
        Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
        Write-Host ""
        if ($isTimed) {
          Write-Host "  Input pts/h then press [Enter]..."
        }
        else {
          Write-Host "  Input pts then press [Enter]..."
        }
        Write-Host ""
        $rate = Read-InputLine "  Rewards: "
        $Global:inputValue = $rate
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
        Write-Host ""
        Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
        Write-Host ""
        Write-Host "  Create Job?"
        Write-Host "  [Y] Yes  [N] No: "
        do {
          $createJob = Read-Character
        } until ($createJob -eq 'y' `
            -or $createJob -eq 'n' `
            -or $createJob -eq [System.ConsoleKey]::Escape)
        $Global:inputValue = $createJob
      }
    }
    else {
      Write-Host "  |$(Get-PaddedString -Fill ' ')|  "
      Write-Host "  |$(Get-PaddedString -Fill '_')|  "
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
  else {
    # Title Prompt
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString "  Type:    $type")|  "
    Write-Host "  |$(Get-PaddedString -Fill ' ')|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
    Write-Host ""
    Write-Host "  Input title then press [Enter]..."
    Write-Host ""
    $title = Read-InputLine "  Title: "
    $Global:inputValue = $title
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
  Write-Host "  |$(Get-PaddedString "  No job created.")|  "
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
  Write-Host "  |$(Get-PaddedString "  Job created successfully!")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  Write-Host "  Press [any key] to continue..."
  Write-Host ""
  $char = Read-Character -Blocking $true
}
