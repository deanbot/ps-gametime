function Show-JobSingle {
  $pos = $global:menuPositionY
  $job = $global:currentJob
  $jobType = $job.Type
  $jobTitle = $job.Title
  $jobRate = $job.Rate
  # $width = $global:containerWidth

  $isDailyCompleted = $false
  if ($jobType -eq $JobTypeDaily) {
    $isDailyCompleted = Get-HasDailyJobCompleted $job
  }

  Write-Host ""
  Show-JobHeading $jobTitle $jobType $jobRate
  Write-Host "  |$(Get-PaddedString "  Options:")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  $completeLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))Complete"
  IF ($isDailyCompleted) {
    $completeLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))Completed - Great Job!"
  }
  Write-Host "  |$completeLine|  "
  $editLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))Edit"
  Write-Host "  |$editLine|  "
  $removeLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 2))Remove"
  Write-Host "  |$removeLine|  "
  Write-Host "  |$(Get-PaddedString -Fill ' ')|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}
