function Show-JobNew {
  Clear-Host
  Write-Host ""
  Show-Heading "New Job"
  Write-Host "  |$(Get-PaddedString)|  "
  $title = $global:newJobTitle
  $type = $global:currentJobType
  $rate = $global:newJobRate

  if ($title) {
    Write-Host "  |$(Get-PaddedString "  Type:    $type")|  "
    Write-Host "  |$(Get-PaddedString "  Title:   $title")|  "
    if ($rate) {
      Write-Host "  |$(Get-PaddedString "  Rewards: $rate pts")|  "
      Write-Host "  |$(Get-PaddedString -Fill '_')|  "
      Write-Host ""
      Write-Host "   $(Get-PaddedString "Press [Esc/Bksp] to return" -Right $true)"
      Write-Host ""
      Write-Host "  Create Job?"
      Write-Host "  [Y] Yes  [N] No: "
      do {
        $createJob = Read-Character
      } until ($createJob -eq 'y' `
          -or $createJob -eq 'n' `
          -or $createJob -eq 'q')
      $global:inputValue = $createJob
    }
    else {
      Write-Host "  |$(Get-PaddedString "  [...]")|  "
      Write-Host "  |$(Get-PaddedString -Fill '_')|  "
      Write-Host ""
      Write-Host "   $(Get-PaddedString "Enter [Q] to return" -Right $true)"
      Write-Host ""
      if ($type -eq 'Quest') {
        Write-Host "  Game Time points per hour"
      }
      else {
        Write-Host "  Game Time points earned for completion"
      }
      $rate = Read-Host "  Rewards"
      $global:inputValue = $rate
    }
  }
  else {
    Write-Host "  |$(Get-PaddedString "  Type:    $type")|  "
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Enter [Q] to return" -Right $true)"
    Write-Host ""
    $title = Read-Host "  Title"
    $global:inputValue = $title
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