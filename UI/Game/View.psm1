function Show-GameMenu {
  $width = $global:containerWidth
  Write-Host ""
  Write-Host "    .-----------,"
  # Write-Host "  / Game Time /___________________________   "
  Write-Host "   $(Get-PaddedString '/ Game Time /' '_')  "
  Write-Host "  |$(Get-PaddedString)|  "

  $available = Get-AvailableBalance
  if ($available -gt 0) {
    $posY = $global:menuPositionY
    Write-Host "  |$(Get-PaddedString "  Spend Points: $posY")|  "
    Write-Host "  |$(Get-PaddedString)|  "
    Write-Host "  |$(Get-PaddedString "  Press [enter] to continue.")|  "
  } else {
    Write-Host "  |$(Get-PaddedString "  No game time points to spend...")|  "
    Write-Host "  |$(Get-PaddedString)|  "
    Write-Host "  |$(Get-PaddedString "  Press [any key] to continue.")|  "
  }
  
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

function Show-GameConfirmSpend {

  Clear-Host
  Write-Host ""
  Write-Host "  |$(Get-PaddedString)|  "

  $passedNotes = $global:notesStepPassed
  $notes = $global:notes
  $points = $global:menuPositionY
  
  Write-Host "  |$(Get-PaddedString "  Points: $points")|  "

  if (!$passedNotes) {
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    $notes = Read-Host "  Notes (optional)"
    $global:inputValue = $notes
  } else {
    
    Write-Host "  |$(Get-PaddedString "  Notes:  [...]")|  "
    Write-Host "  |$(Get-PaddedString)|  "
    Write-Host "  |$(Get-PaddedString "  Spend Game Time Points? Enter [y/n]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
    Write-Host ""
    do {
      $char = Read-Character
    } until ($char -eq 'y' `
        -or $char -eq 'n' `
        -or $char -eq [System.ConsoleKey]::Escape)
    $global:inputValue = $char
  }
}
  
function Show-GameSpendFailed {
  Param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$reason
  )

  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Points not spent.")|  "
  if ($reason) {
    Write-Host "  |$(Get-PaddedString "  $reason")|  "  
  }
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Press [any key] to continue.")|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  $char = Read-Character -Blocking $true
}

function Show-GameSpendSuccess {
  $points = $globalMenuPositionY
  $minutes = $points * 20
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Spent $points points for $minutes minutes.")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Press [any key] to continue.")|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  $char = Read-Character -Blocking $true
}
  