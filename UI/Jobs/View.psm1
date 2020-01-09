function Show-JobsMenu {
  $posX = $global:menuPositionX
  $posY = $global:menuPositionY
  $addSelected = $posY -eq $global:maxMenuPositionsY - 1
  $isQuest = $posX -eq 0
  $isDaily = $posX -eq 1
  $isRare = $posx -eq 2
  $jobs = $global:currentJobs
  $jobType = "";

  Write-Host ""
  if ($isQuest) {
    $jobType = 'Quest'
    Write-Host "    .-------, ________  _______               "
    Write-Host "   / Quest /_/ Daily /_/ Rare /___________   "
  }
  elseif ($isDaily) {
    $jobType = 'Daily'
    Write-Host "    ________  .-------, _______"
    Write-Host "   / Quest /_/ Daily /_/ Rare /___________   "
  }
  elseif ($isRare) {
    $jobType = 'Rare'
    Write-Host "    ________  ________  .------,              "
    Write-Host "   / Quest /_/ Daily /_/ Rare /___________   "
  }
  Write-Host "  |$(Get-PaddedString)|  "
  if ($jobs) {
    Show-JobCheckBoxes $jobs
  }
  else {
    Write-Host "  |$(Get-PaddedString "  No $jobType Jobs found.")|  "
  }
  Write-Host "  |$(Get-PaddedString)|  "
  $addLine = "  $(Get-CheckBox $addSelected)Add job"
  Write-Host "  |$(Get-PaddedString $addLine)|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString '  Press [Enter] to select')|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  # Write-Host "  |  (R)emove job                         |  "
  # # Write-Host "  (B)alance"
  # Write-Host "  |  (S)pend Game Time points             |  "
  # Write-Host "  |  (V)iew logs                          |  "
}

function Show-JobsSingle {
  $pos = $global:menuPositionY
  $job = $global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate
  $jobRateSuffix = ""
  if ($jobType -eq "Quest") {
    $jobRateSuffix = " pts/h"
  }
  else {
    $jobRateSuffix = " pts"
  }
  $width = $global:containerWidth
  $widthLeft = [System.Math]::Floor($width / 2)
  $widthRight = [System.Math]::Ceiling($width / 2)

  Write-Host ""
  Write-Host "    .$(Get-PaddedString -Fill '-' -Width ($width -4)).  "
  Write-Host "   /$(Get-PaddedString "$jobTitle" -Center $true -Width ($width-2))\  "
  Write-Host "  |$(Get-PaddedString -Fill "-" )|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Type: $jobType" -Width $widthLeft)$(Get-PaddedString "Rate: $jobRate$jobRateSuffix  " -Right $true -Width $widthRight)|  "
  # Write-Host "  |$(Get-PaddedString -Fill "-")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  $completeLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))(C)omplete"
  Write-Host "  |$completeLine|  "
  $editLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))(E)dit"
  Write-Host "  |$editLine|  "
  $removeLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 2))(R)emove"
  Write-Host "  |$removeLine|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString '  Press [Enter] to select' -Width ($width ))|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

# TODO return object instead of individual properties
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
    Write-Host "  |$(Get-PaddedString "  Type: $type")|  "
    Write-Host "  |$(Get-PaddedString)|  "
    Write-Host "  |$(Get-PaddedString "  Title: $title")|  "
    Write-Host "  |$(Get-PaddedString)|  "
    if ($rate) {
      Write-Host "  |$(Get-PaddedString "  Rewards: $rate")|  "
      Write-Host "  |$(Get-PaddedString -Fill '_')|  "
      Write-Host ""
      Write-Host "  Create Job? Enter [y/n]"
      Write-Host ""
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
      if ($type -eq 'Quest') {
        Write-Host "  Input amount of Game Time points per hour of completion (enter 'q' to quit)"
      }
      else {
        Write-Host "  Input amount of Game Time points for job completion (enter 'q' to quit)"
      }
      $rate = Read-Host "  Rewards"
      $global:newInputValue = $rate
    }
  }
  else {
    Write-Host "  |$(Get-PaddedString "  Type: $type")|  "
    Write-Host "  |$(Get-PaddedString)|  "
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
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
  Write-Host "    .-------------,"
  # Write-Host "   / Add New Job /___________________________   "
  Write-Host "   $(Get-PaddedString '/ Add New Job /' -Fill '_' -Width ($width))  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  No job created.")|  "
  Write-Host "  |$(Get-PaddedString "  Press any key to continue.")|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

function Show-JobCheckBoxes {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    $jobs
  )
  if ($jobs) {
    $jobs = , $jobs
  }
  $pos = $global:menuPositionY
  for ($i = 0; $i -lt $jobs.Length; $i++) {
    $job = $jobs[$i]
    $selected = $pos -eq $i
    $jobLine = "  $(Get-CheckBox $selected) $($job.Title)"
    Write-Host "  |$(Get-PaddedString $jobLine)|  "
  }
}