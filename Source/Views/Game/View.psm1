function Show-GameMenu {
  $width = $global:containerWidth
  $widthLeft = [System.Math]::Floor($width / 2)
  $widthRight = [System.Math]::Ceiling($width / 2)

  Write-Host ""
  Show-Heading "Spend Points"
  Write-Host "  |$(Get-PaddedString)|  "

  $available = Get-AvailableBalance
  if ($available -gt 0) {
    Write-Host "  |$(Get-PaddedString "  Spend Points:" -Width $widthLeft)$(Get-PaddedString "1 pt = 20 m GT " -Right $true -Width $widthRight)|  "
    Write-Host "  |$(Get-PaddedString)|  "
    $posY = $global:menuPositionY
    Write-Host "  |$(Get-PaddedString "(+)" -Center $true)|  "
    Write-Host "  |$(Get-PaddedString "$posY" -Center $true)|  "
    if ($posY -gt 0) {
      Write-Host "  |$(Get-PaddedString "(-)" -Center $true)|  "
    }
    else {
      Write-Host "  |$(Get-PaddedString "( )" -Center $true)|  "
    }
    Write-Host "  |$(Get-PaddedString)|  "
    # Write-Host "  |$(Get-PaddedString "  Press [enter] to continue.")|  "
    # Show-ControlsFooter
  }
  else {
    Write-Host "  |$(Get-PaddedString "  No Game Time points to spend...")|  "
    Write-Host "  |$(Get-PaddedString "  Complete $Label_Plural_Quest_Lower to earn points.")|  "
    Write-Host "  |$(Get-PaddedString)|  "
  }

  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

function Show-PromptSpend {
  $passedNotes = $global:notesStepPassed
  if (!$passedNotes) {
    Write-Host ""
    Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
    Write-Host ""
    $notes = Read-InputLine "  Notes (optional): "
    $global:inputValue = $notes
  } else {
    Write-Host ""
    Write-Host "  Spend Game Time Points?"
    Write-Host "  [Y] Yes  [N] No:"
    Write-Host ""
    do {
      $char = Read-Character
    } until ($char -eq 'y' `
        -or $char -eq 'n' `
        -or $char -eq [System.ConsoleKey]::Escape)
    $global:inputValue = $char
  }
}

function Show-GameConfirmSpend {
  $passedNotes = $global:notesStepPassed
  $notes = $global:notes
  $points = $global:menuPositionY
  $width = $global:containerWidth

  Clear-Host
  Write-Host ""
  Write-Host "    .-----------,"
  # Write-Host "  / Game Time /___________________________   "
  Write-Host "   $(Get-PaddedString '/ Game Time /' '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Spend Points")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Points: $points")|  "

  if (!$passedNotes) {
    Write-Host "  |$(Get-PaddedString "  [...]")|  "
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  }
  else {
    if ($notes) {
      Write-Host "  |$(Get-PaddedString "  Notes: $(Get-TextExcerpt $notes ($width-11))")|  "
      Write-Host "  |$(Get-PaddedString)|  "
    }
    Write-Host "  |$(Get-PaddedString -Fill '_')|  "
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
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  Write-Host "  Press [any key] to continue..."
  Write-Host ""
  $char = Read-Character -Blocking $true
}

function Show-GameSpendSuccess {
  $width = $global:containerWidth
  $points = $global:menuPositionY
  Clear-Host
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  $message = Get-MessageDeductTransactionLog $points
  $textLines = Get-TextLines $message ($width - 4)
  foreach ($line in $textLines) {
    Write-Host "  |$(Get-PaddedString "  $line" )|  "
  }
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Have fun!")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  Write-Host "  Press [any key] to continue..."
  Write-Host ""
  $char = Read-Character -Blocking $true
}
