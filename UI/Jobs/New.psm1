function Show-JobsNew {
  Clear-Host
  Write-Host ""
  Write-Host "    .-------------,"
  # Write-Host "   / Add New Job /___________________________   "
  Write-Host "   $(Get-PaddedString '/ Add New Job /' -Fill '_' -Width ($width))  "
  Write-Host "  |$(Get-PaddedString)|  "
  # Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  $title = $global:newJobTitle
  $type = $global:currentJobType
  $rate = $global:newJobRate

  if ($title) {
    Write-Host "  |$(Get-PaddedString "  Type:    $type")|  "
    Write-Host "  |$(Get-PaddedString "  Title:   $title")|  "
    if ($rate) {
      Write-Host "  |$(Get-PaddedString "  Rewards: $rate")|  "
      Write-Host "  |$(Get-PaddedString -Fill '_')|  "
      Write-Host ""
      Write-Host "  Create Job? Enter [y/n]"
      do {
        $createJob = Read-Character
      } until ($createJob -eq 'y' `
        -or $createJob -eq 'n' `
        -or $createJob -eq 'q')
      $global:newInputValue = $createJob
    }
    else {
      Write-Host "  |$(Get-PaddedString "  [...]")|  "
      Write-Host "  |$(Get-PaddedString -Fill '_')|  "
      Write-Host ""
      Write-Host "   $(Get-PaddedString "(enter 'q' to quit)" -Right $true)"
      Write-Host ""
      if ($type -eq 'Quest') {
        Write-Host "  Game Time points per hour"
      }
      else {
        Write-Host "  Game Time points per completion"
      }
      $rate = Read-Host "  Rewards"
      $global:newInputValue = $rate
    }
  }
  else {
    Write-Host "  |$(Get-PaddedString "  Type:    $type")|  "
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    Write-Host "   $(Get-PaddedString "(enter 'q' to quit)" -Right $true)"
    Write-Host ""
    $title = Read-Host "  Title"
    $global:newInputValue = $title
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
  Write-Host "  |$(Get-PaddedString "  Press [any key] to continue.")|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
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
  Write-Host "  |$(Get-PaddedString "  Press [any key] to continue.")|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  $char = Read-Character -Blocking $true
}