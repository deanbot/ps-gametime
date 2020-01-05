function Show-GameMenu {
  $width = $global:containerWidth
  Write-Host ""
  Write-Host "    .-----------,"
  # Write-Host "  / Game Time /___________________________   "
  Write-Host "   $(Get-PaddedString '/ Game Time /' '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}