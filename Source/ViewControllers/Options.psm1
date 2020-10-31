$setionOptionsMenu = 'Options'
$promptResetPoints = 'ResetPoints'
$promptFactoryReset = 'FactoryReset'
$optionsPageResetPoints = 'ResetPoints'
$optionsPageFactoryReset = 'FactoryReset'

function Initialize-OptionsMenu {
  $global:section = $setionOptionsMenu
  $global:subPage = ''
  $Global:menuPositionX = 0
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsX = 0
  $Global:maxMenuPositionsY = 2
  $Global:canChangeMenuPositionY = $true
  $Global:canChangeMenuPositionX = $false
  $Global:showReturn = $false
  $Global:showSelect = $true
  $Global:invertY = $false
  $Global:currentPrompt = ''
}

function Initialize-OptionsResetPoints {
  $global:subPage = $optionsPageResetPoints
  $Global:currentPrompt = $promptResetPoints
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
}

function Initialize-OptionsFactoryReset {
  $global:subPage = $optionsPageFactoryReset
  $Global:currentPrompt = $promptFactoryReset
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
}

function Read-ResetPointsInputVal {
  $inputVal = $Global:inputValue
  $quit = $false

  if ($inputVal -eq 'y') {
    Write-Host "todo reset points"
    pause
    $quit = $true
  }
  elseif ($inputVal -eq 'n' -or $inputVal -eq [System.ConsoleKey]::Escape) {
    $quit = $true
  }

  if ($quit) {
    Initialize-OptionsMenu
  }
}

function Read-FactoryResetInputVal {
  $inputVal = $Global:inputValue
  $quit = $false

  if ($inputVal -eq 'y') {
    Write-Host "todo factory reset"
    pause
    $quit = $true
  }
  elseif ($inputVal -eq 'n' -or $inputVal -eq [System.ConsoleKey]::Escape) {
    $quit = $true
  }

  if ($quit) {
    Initialize-OptionsMenu
  }
}

function Read-OptionsPromptInputVals {
  $subPage = $Global:subPage
  if ($subPage -eq $optionsPageResetPoints) {
    Read-ResetPointsInputVal
  } elseif ($subPage -eq $optionsPageFactoryReset) {
    Read-FactoryResetInputVal
  }
}
