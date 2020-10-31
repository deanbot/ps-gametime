function Show-JobsMenu {
  $posX = $global:menuPositionX
  # $posY = $global:menuPositionY
  $jobs = $global:currentJobs
  $width = $global:containerWidth
  $widthLeft = [System.Math]::Floor($width / 2)
  $widthRight = [System.Math]::Ceiling($width / 2)

  Write-Host ""
  Show-JobsTabs $posX
  Write-Host "  |$(Get-PaddedString)|  "
  if ($jobs) {
    Write-Host "  |$(Get-PaddedString "  Select a $($Label_Single_Quest_Lower): " -Width $widthLeft)$(Get-PaddedString "[N] New  " -Right $true -Width $widthRight)|  "
  } 
  else {
    Write-Host "  |$(Get-PaddedString " " -Width $widthLeft)$(Get-PaddedString "[N] New  " -Right $true -Width $widthRight)|  "
  }
  Write-Host "  |$(Get-PaddedString)|  "

  $jobType = Get-CurrentJobType
  if ($jobs) {
    Show-JobCheckBoxes $jobs
  }
  else {
    if ($jobType -eq "Quest") {
      Write-Host "  |$(Get-PaddedString "  No $Label_Plural_Quest found." -Center $true)|  "
      
    }
    else {
      Write-Host "  |$(Get-PaddedString "  No $jobType $Label_Plural_Quest found." -Center $true)|  "
    }
    Write-Host "  |$(Get-PaddedString)|  "
    Write-Host "  |$(Get-PaddedString "Create a $Label_Single_Quest_Lower to see it here." -Center $true)|  "
  }
  # Write-Host "  |$(Get-PaddedString "  ")|  "
  # $addLine = "    [N] New job"
  # Write-Host "  |$(Get-PaddedString $addLine)|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}
