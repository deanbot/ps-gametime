function Show-JobsMenu {
  $posX = $global:menuPositionX
  $isQuest = $posX -eq 0
  $isDaily = $posX -eq 1
  $isRare = $posx -eq 2
  $jobs = $global:currentJobs

  Write-Host ""
  if ($isQuest) {
    Write-Host "   .-------, ________  _______               "
    Write-Host "  / Quest /_/ Daily /_/ Rare /____________   "
  }
  elseif ($isDaily) {
    Write-Host "   ________  .-------, _______"
    Write-Host "  / Quest /_/ Daily /_/ Rare /____________   "
  }
  elseif ($isRare) {
    Write-Host "   ________  ________  .------,              "
    Write-Host "  / Quest /_/ Daily /_/ Rare /____________   "
  }
  Write-Host "  |$(Get-PaddedString)|  "
  Show-JobCheckBoxes $jobs
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
  $jobTitle = $job.Title
  $jobRate = $job.Rate
  $jobRateSuffix = ""
  if ($job.Type -eq "Quest") {
    $jobRateSuffix = " per hour"
  }
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  $jobTitle")|  "
  Write-Host "  |$(Get-PaddedString "  (rewards: $jobRate$jobRateSuffix)")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  $completeLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))(C)omplete"
  Write-Host "  |$completeLine|  "
  $editLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))(E)dit"
  Write-Host "  |$editLine|  "
  $removeLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 2))(R)emove"
  Write-Host "  |$removeLine|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

function Show-JobCheckBoxes {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    $jobs
  )
  $jobs = , $jobs
  $pos = $global:menuPositionY
  for ($i = 0; $i -lt $jobs.Length; $i++) {
    $job = $jobs[$i]
    $selected = $pos -eq $i
    $jobLine = "  $(Get-CheckBox $selected) $($job.Title)"
    Write-Host "  |$(Get-PaddedString $jobLine)|  "
  }
}