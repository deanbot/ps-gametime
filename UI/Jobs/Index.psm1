function Show-JobsMenu {
  $posX = $global:menuPositionX
  $posY = $global:menuPositionY
  $jobs = $global:currentJobs
  $width = $global:containerWidth
  $widthLeft = [System.Math]::Floor($width / 2)
  $widthRight = [System.Math]::Ceiling($width / 2)

  Write-Host ""
  Show-JobsTabs $posX
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Jobs: " -Width $widthLeft)$(Get-PaddedString "[N] New  " -Right $true -Width $widthRight)|  "
  Write-Host "  |$(Get-PaddedString)|  "

  if ($jobs) {
    Show-JobCheckBoxes $jobs
  }
  else {
    $jobType = Get-CurrentJobType
    Write-Host "  |$(Get-PaddedString "  No $jobType Jobs found.")|  "
  }
  # Write-Host "  |$(Get-PaddedString "  ")|  "
  # $addLine = "    [N] New job"
  # Write-Host "  |$(Get-PaddedString $addLine)|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}