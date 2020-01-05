function Show-GameMenu {
  $width = $global:containerWidth
  Write-Host ""
  Write-Host "   .-----------,"
  # Write-Host "  / Game Time /___________________________   "
  Write-Host "  $(Get-PaddedString '/ Game Time /' '_' ($width+1))  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}