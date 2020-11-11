function Initialize-OptionsMenu {
  $global:section = $Section_Options
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
  $global:subPage = $Page_Options_DemoContent
  $Global:currentPrompt = ''
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $true
  $Global:maxMenuPositionsY = 3
  $Global:menuPositionX = 0
}

function Initialize-OptionsConfirmDemoContent {
  $global:subPage = $Page_Options_ConfirmDemoContent
  $Global:currentPrompt = $Prompt_Options_DemoContent
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
}

function Initialize-OptionsResetPoints {
  $global:subPage = $Page_Options_ResetPoints
  $Global:currentPrompt = $Prompt_Options_ResetPoints
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
}

function Initialize-OptionsFactoryReset {
  $global:subPage = $Page_Options_FactoryReset
  $Global:currentPrompt = $Prompt_Options_FactoryReset
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
    Write-Host "  "
    Write-Host "  Working..."
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
  if ($subPage -eq $Page_Options_ResetPoints) {
    Read-ResetPointsInputVal
  } elseif ($subPage -eq $Page_Options_FactoryReset) {
    Read-FactoryResetInputVal
  } elseif ($subPage -eq $Page_Options_ConfirmDemoContent) {
    Read-DemoContentInputVal
  }
}
