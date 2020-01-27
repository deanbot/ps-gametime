function Show-JobSingle {
  $pos = $global:menuPositionY
  $job = $global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate
  $width = $global:containerWidth

  Write-Host ""
  Show-JobHeading $jobTitle $jobType $jobRate
  Write-Host "  |$(Get-PaddedString)|  "
  $completeLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))Complete job (log completion)"
  Write-Host "  |$completeLine|  "
  $editLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))Edit job"
  Write-Host "  |$editLine|  "
  $removeLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 2))Remove job"
  Write-Host "  |$removeLine|  "
  Write-Host "  |$(Get-PaddedString)|  "
  # Show-ControlsFooter
  # Write-Host "  |$(Get-PaddedString '  Press [Enter] to select' -Width ($width ))|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}