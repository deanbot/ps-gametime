function Show-JobTitleWarning {
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Notice!")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Enter a $Label_Single_Quest_Lower title")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Show-BlockingPressAnyKey
}

function Show-JobRateWarning {
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Notice!")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Enter rewards as a decimal")|  "
  Write-Host "  |$(Get-PaddedString "  ... i.e. 1 or .25")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Show-BlockingPressAnyKey
}

function Show-JobCheckBoxes {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    $jobs
  )
  $width = $global:containerWidth
  $pos = $global:menuPositionY
  for ($i = 0; $i -lt @($jobs).Length; $i++) {
    $job = $jobs[$i]
    $selected = $pos -eq $i
    $jobLine = "  $(Get-CheckBox $selected)$(Get-TextExcerpt $job.Title ($width-8))"
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

  $Type = $JobType
  $isTimed = $false
  if ($Type -like '*Quest*') {
    if ($Type -eq 'Quest-Timed') {
      $Type = 'Quest'
      $isTimed = $true
    }
  }

  $jobRateSuffix = ""
  if ($isTimed -eq "Quest") {
    $jobRateSuffix = " pts/h"
  }
  else {
    $jobRateSuffix = " pts"
  }
  if ($Edit) {
    $heading = "Edit: $JobTitle"
  }
  else {
    $heading = $JobTitle
  }

  Show-Heading $heading
  Write-Host "  |$(Get-PaddedString)|  "

  $widthField = 13
  $widthHeading = $widthField - 2
  $widthBorder = $widthField - 2
  $widthValue = $widthField - 4
  $labelLineLeft = Get-PaddedString "   $(Get-PaddedString -Width $widthHeading "Type" )" -Width $widthLeft
  $labelLineRight = Get-PaddedString "$(Get-PaddedString -Width $widthHeading "Rate" )   " -Width $widthRight -Right $true
  Write-Host "  |$labelLineLeft$labelLineRight|  "
  $borderLineLeft = Get-PaddedString "  +$(Get-PaddedString -Fill "-" -Width $widthBorder )+" -Width $widthLeft
  $borderLineRight = Get-PaddedString "+$(Get-PaddedString -Fill "-" -Width $widthBorder )+  " -Width $widthRight -Right $true
  Write-Host "  |$borderLineLeft$borderLineRight|  "
  $valueLineLeft = Get-PaddedString "  | $(Get-PaddedString $Type -Width $widthValue ) |" -Width $widthLeft
  $valueLineRight = Get-PaddedString "| $(Get-PaddedString "$JobRate$jobRateSuffix" -Width $widthValue ) |  " -Width $widthRight -Right $true
  Write-Host "  |$valueLineLeft$valueLineRight|  "
  Write-Host "  |$borderLineLeft$borderLineRight|  "
  Write-Host "  |$(Get-PaddedString)|  "
}
