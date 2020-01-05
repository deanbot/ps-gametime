function Show-JobsMenu {
  $posX = $global:menuPositionX
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
  Write-Host "   /$(Get-PaddedString "$jobTitle" -Center $true -Width ($width -2))\  "
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
  Write-Host "  |$(Get-PaddedString '  Press [Enter] to select')|  "
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