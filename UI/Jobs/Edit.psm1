function Show-JobEdit {
  $pos = $global:menuPositionY
  $job = $global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate
  $width = $global:containerWidth

  Write-Host ""
  Show-JobHeading $jobTitle $jobType $jobRate $true
  Write-Host "  |$(Get-PaddedString)|  "
  $titleLine = "  $(Get-CheckBox ($pos -eq 0))Title"
  Write-Host "  |$(Get-PaddedString $titleLine)|  "
  $typeLine = "  $(Get-CheckBox ($pos -eq 1))Type"
  Write-Host "  |$(Get-PaddedString $typeLine)|  "
  if ($jobType -eq 'Quest') {
    $rateLine = "  $(Get-CheckBox ($pos -eq 2))Rewards"
    Write-Host "  |$(Get-PaddedString $rateLine)|  "
    # $lastPos = 3
  } # } else {
    # $lastPos = 2
  # }
  # Write-Host "  |$(Get-PaddedString)|  "
  # $cancelLine = "  $(Get-CheckBox ($pos -eq $lastPos))Cancel"
  # Write-Host "  |$(Get-PaddedString $cancelLine)|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString '  Press [Enter] to select' -Width ($width ))|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

function Show-JobEditFailed {
  Param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$reason
  )

  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Job not editted.")|  "
  if ($reason) {
    Write-Host "  |$(Get-PaddedString "  $reason")|  "  
  }
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Press [any key] to continue.")|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  $char = Read-Character -Blocking $true
}

function Show-JobField {
  $job = $global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate
  $field = $global:currentField

  Clear-Host
  Write-Host ""
  Show-JobHeading $jobTitle $jobType $jobRate $true
  Write-Host "  |$(Get-PaddedString)|  "

  if ($field -eq 'Title') {
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    Write-Host "   $(Get-PaddedString "(enter 'q' to return)" -Right $true)"
    Write-Host ""
    $title = Read-Host "  Edit Title"
    $global:inputValue = $title
  } elseif ($field -eq 'Type') {
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    Write-Host "   $(Get-PaddedString "(enter 'Esc' to return)" -Right $true)"
    Write-Host ""
    Write-Host "  Edit Type (Q)uest/(D)aily/(Rare)"
    do {
      $type = Read-Character
    } until($type -eq 'q' `
      -or $type -eq 'd' `
      -or $type -eq 'r' `
      -or $type -eq [System.ConsoleKey]::Escape)
    $global:inputValue = $type
  } elseif ($field -eq 'Rate') {
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    Write-Host "   $(Get-PaddedString "(enter 'q' to return)" -Right $true)"
    Write-Host ""
    if ($jobType -eq 'Quest') {
      Write-Host "  Game Time points per hour"
    }
    else {
      Write-Host "  Game Time points per completion"
    }
    $rate = Read-Host "  Edit Rewards"
    $global:inputValue = $rate
  }
}