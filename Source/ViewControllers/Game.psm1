if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}


# constants
$sectionGameMenu = 'Game Time'

function Initialize-GameMenu {
  $Global:section = $sectionGameMenu
  $Global:subPage = ''
  $Global:menuPositionX = 0
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsX = 0
  $Global:canChangeMenuPositionX = $false
  $Global:notesStepPassed = $false
  $Global:notes = ""
  $Global:hideFooter = $false
  $Global:showReturn = $true
  $Global:showSelect = $false

  $availableBalance = Get-AvailableBalance
  $hasAvailableBalance = $availableBalance -gt 0
  if ($hasAvailableBalance) {
    $Global:maxMenuPositionsY = $availableBalance + 1
    $Global:canChangeMenuPositionY = $true
    $Global:invertY = $true
  }
  else {
    $Global:maxMenuPositionsY = 0
    $Global:canChangeMenuPositionY = $false
  }
}

function Initialize-GameConfirmPage {
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
  $Global:subPage = $gamePageSpend
  $Global:showReturn = $true
  $Global:hideFooter = $true
}

function Read-GameConfirmInputVal {
  $inputVal = $Global:inputValue
  $quit = $false

  # first form step
  if (!$Global:notesStepPassed) {
    $Global:notesStepPassed = $true
    $Global:notes = $inputVal
  }

  # confirm step
  else {
    if ($inputVal -eq 'y') {
      try {
        $notes = $Global:notes
        $points = $Global:menuPositionY
        $transaction = New-DeductTransaction $points $notes
        if ($transaction) {
          Show-GameSpendSuccess $message
          $quit = $true
        }
        else {
          Show-GameSpendFailed
          $quit = $true
        }
      }
      catch {
        Show-GameSpendFailed $_
        $quit = $true
      }
    }
    elseif ($inputVal -eq 'n' -or $inputVal -eq [System.ConsoleKey]::Escape) {
      $quit = $true
    }
  }

  if ($quit) {
    Initialize-GameMenu
    $Global:forceRepaint = $true
  }
}