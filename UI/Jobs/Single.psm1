function Show-JobsSingle {
  $pos = $global:menuPositionY
  $job = $global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate
  $width = $global:containerWidth

  Write-Host ""
  Show-JobHeading $jobTitle $jobType $jobRate
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