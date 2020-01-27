function Show-JobsMenu {
  $posX = $global:menuPositionX
  $posY = $global:menuPositionY
  $addSelected = $posY -eq $global:maxMenuPositionsY - 1
  $jobs = $global:currentJobs

  Write-Host ""
  Show-JobsTabs $posX
  Write-Host "  |$(Get-PaddedString)|  "
  if ($jobs) {
    Show-JobCheckBoxes $jobs
  }
  else {
    $jobType = Get-CurrentJobType
    Write-Host "  |$(Get-PaddedString "  No $jobType Jobs found.")|  "
  }
  Write-Host "  |$(Get-PaddedString)|  "
  $addLine = "  $(Get-CheckBox $addSelected)Add job"
  Write-Host "  |$(Get-PaddedString $addLine)|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}