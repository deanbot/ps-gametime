function Show-JobEdit {
  $pos = $Global:menuPositionY
  $job = $Global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate
  # $width = $Global:containerWidth

  $isQuest = $jobType -like '*Quest*';
  $isTimed = $jobType -eq 'Quest-Timed';

  Write-Host ""
  Show-JobHeading $jobTitle $jobType $jobRate $true
  $titleLine = "  $(Get-CheckBox ($pos -eq 0))Title"
  Write-Host "  |$(Get-PaddedString $titleLine)|  "
  $typeLine = "  $(Get-CheckBox ($pos -eq 1))Type"
  Write-Host "  |$(Get-PaddedString $typeLine)|  "
  if ($isQuest) {
    if ($isTimed) {
      $subTypeLine = "  $(Get-CheckBox ($pos -eq 2))Change to Standard"
    }
    else {
      $subTypeLine = "  $(Get-CheckBox ($pos -eq 2))Change to Timed"
    }
    Write-Host "  |$(Get-PaddedString $subTypeLine)|  "
  }
  if ($isQuest) {
    $rateLine = "  $(Get-CheckBox ($pos -eq 3))Rewards"
  }
  else {
    $rateLine = "  $(Get-CheckBox ($pos -eq 2))Rewards"
  }
  Write-Host "  |$(Get-PaddedString $rateLine)|  "
  Write-Host "  |$(Get-PaddedString)|  "
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
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  Write-Host "  Press [any key] to continue..."
  Write-Host ""

  $char = Read-Character -Blocking $true
}

function Show-JobField {
  $job = $Global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate

  $field = $Global:currentField

  Clear-Host
  Write-Host ""
  Show-JobHeading $jobTitle $jobType $jobRate $true
  Write-Host "  |$(Get-PaddedString)|  "

  if ($field -eq 'Title') {
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
    Write-Host ""
    $title = Read-InputLine "  Title: "
    $Global:inputValue = $title
  }
  elseif ($field -eq 'Type') {
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Press [Esc/Bksp] to return" -Right $true)"
    Write-Host ""
    Write-Host "  Select Job Type "
    Write-Host "  [Q] Quest  [D] Daily  [R] Rare: "
    Write-Host ""
    do {
      $type = Read-Character
    } until($type -eq 'q' `
        -or $type -eq 'd' `
        -or $type -eq 'r' `
        -or $type -eq [System.ConsoleKey]::Escape)
    $Global:inputValue = $type
  }
  elseif ($field -eq 'Rate') {
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
    Write-Host ""
    if ($jobType -eq 'Quest') {
      Write-Host "  Game Time points per hour"
    }
    else {
      Write-Host "  Game Time points per completion"
    }
    $rate = Read-InputLine "  Rewards: "
    $Global:inputValue = $rate
  }
}