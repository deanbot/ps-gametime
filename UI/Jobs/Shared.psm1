function Show-JobTitleWarning {
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Notice")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Enter a job title")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Press [any key] to continue.")|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  $char = Read-Character -Blocking $true
}

function Show-JobRateWarning {
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Notice")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Enter rewards as a decimal")|  "
  Write-Host "  |$(Get-PaddedString "  ... i.e., 1 or .25")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Press [any key] to continue.")|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  $char = Read-Character -Blocking $true
}

function Show-JobCheckBoxes {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    $jobs
  )

  $pos = $global:menuPositionY
  for ($i = 0; $i -lt @($jobs).Length; $i++) {
    $job = $jobs[$i]
    $selected = $pos -eq $i
    $jobLine = "  $(Get-CheckBox $selected)$($job.Title)"
    Write-Host "  |$(Get-PaddedString $jobLine)|  "
  }
}

function Show-JobsTabs {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [int32]$posX
  )

  $isQuest = $posX -eq 0
  $isDaily = $posX -eq 1
  $isRare = $posx -eq 2

  # Write-Host "   [<]                                 [>]   "
  # Write-Host "   / Quest /_/ Daily /_/ Rare /___________   "

  if ($isQuest) {
    # Write-Host "    .-------, ________  _______      (</>)      "
    Write-Host "    .-------, ________  _______               "
    Write-Host "   / Quest /_/ Daily /_/ Rare /___________   "
  }
  elseif ($isDaily) {
    Write-Host "    ________  .-------, _______"
    Write-Host "   / Quest /_/ Daily /_/ Rare /___________   "
  }
  elseif ($isRare) {
    Write-Host "    ________  ________  .------,              "
    Write-Host "   / Quest /_/ Daily /_/ Rare /___________   "
  }
}

function Show-JobHeading {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$JobTitle,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$JobType,

    [Parameter(Mandatory = $true, Position = 2)]
    $JobRate,

    [Parameter(Mandatory = $false, Position = 3)]
    [bool]$Edit = $false
  )

  $width = $global:containerWidth
  $widthLeft = [System.Math]::Floor($width / 2)
  $widthRight = [System.Math]::Ceiling($width / 2)
  $jobRateSuffix = ""
  if ($JobType -eq "Quest") {
    $jobRateSuffix = " pts/h"
  }
  else {
    $jobRateSuffix = " pts"
  }

  Write-Host "    .$(Get-PaddedString -Fill '-' -Width ($width -4)).  "
  if ($Edit) {
    Write-Host "   /$(Get-PaddedString "Edit: $JobTitle" -Center $true -Width ($width-2))\  "
  }
  else {
    Write-Host "   /$(Get-PaddedString "$JobTitle" -Center $true -Width ($width-2))\  "
  }
  Write-Host "  |$(Get-PaddedString -Fill "-" )|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Type: $JobType" -Width $widthLeft)$(Get-PaddedString "Rate: $JobRate$jobRateSuffix  " -Right $true -Width $widthRight)|  "
}