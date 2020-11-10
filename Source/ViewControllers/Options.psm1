$setionOptionsMenu = 'Options'
$promptResetPoints = 'ResetPoints'
$promptFactoryReset = 'FactoryReset'
$promptDemoContent = 'DemoContent'
$optionsPageResetPoints = 'ResetPoints'
$optionsPageFactoryReset = 'FactoryReset'
$optionsPageDemoContent = 'DemoContent'
$optionsPageConfirmDemoContent = 'ConfirmDemoContent'

function Initialize-OptionsMenu {
  $global:section = $setionOptionsMenu
  $global:subPage = ''
  $Global:menuPositionX = 0
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsX = 0
  $Global:maxMenuPositionsY = 3
  $Global:canChangeMenuPositionY = $true
  $Global:canChangeMenuPositionX = $false
  $Global:showReturn = $true
  $Global:showSelect = $true
  $Global:invertY = $false
  $Global:currentPrompt = ''
}

function Initialize-OptionsDemoContent {
  $global:subPage = $optionsPageDemoContent
  $Global:currentPrompt = ''
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $true
  $Global:maxMenuPositionsY = 3
  $Global:menuPositionX = 0
}

function Initialize-OptionsConfirmDemoContent {
  $global:subPage = $optionsPageConfirmDemoContent
  $Global:currentPrompt = $promptDemoContent
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
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
    Reset-Points
    $quit = $true
  }
  elseif ($inputVal -eq 'n' -or $inputVal -eq [System.ConsoleKey]::Escape) {
    $quit = $true
  }

  if ($quit) {
    $prevPosition = $Global:menuPositionY
    Initialize-OptionsMenu
    $Global:menuPositionY = $prevPosition
  }
}

function Read-FactoryResetInputVal {
  $inputVal = $Global:inputValue
  $quit = $false

  if ($inputVal -eq 'y') {
    Reset-GameTime
    $quit = $true
  }
  elseif ($inputVal -eq 'n' -or $inputVal -eq [System.ConsoleKey]::Escape) {
    $quit = $true
  }

  if ($quit) {
    $prevPosition = $Global:menuPositionY
    Initialize-OptionsMenu
    $Global:menuPositionY = $prevPosition
  }
}

function Read-DemoContentInputVal {
  $inputVal = $Global:inputValue
  $pos = $menuPositionY
  if ($inputVal -eq 'y') {
    Add-DemoContent $pos
    Show-Notice "Demo Content installed successfully!"
    Initialize-OptionsMenu
    $Global:menuPositionY = $global:prevMenuPositionY
  }
  elseif ($inputVal -eq 'n' -or $inputVal -eq [System.ConsoleKey]::Escape) {
    $prev = $menuPositionY
    Initialize-OptionsDemoContent
    $global:menuPositionY = $prev
  }
}

function Read-OptionsPromptInputVals {
  $subPage = $Global:subPage
  if ($subPage -eq $optionsPageResetPoints) {
    Read-ResetPointsInputVal
  } elseif ($subPage -eq $optionsPageFactoryReset) {
    Read-FactoryResetInputVal
  } elseif ($subPage -eq $optionsPageConfirmDemoContent) {
    Read-DemoContentInputVal
  }
}
