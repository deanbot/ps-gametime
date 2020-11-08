if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

# constants
$sectionMainMenu = 'Main Menu'

function Initialize-MainMenu {
  $Global:section = $sectionMainMenu
  $Global:subPage = ''
  $Global:menuPositionX = 0
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsX = 0
  $Global:maxMenuPositionsY = 4
  $Global:canChangeMenuY = $true
  $Global:canChangeMenuPositionY = $true
  $Global:canChangeMenuPositionX = $false
  $Global:showReturn = $false
  $Global:showSelect = $true
  $Global:invertY = $false
  $Global:currentPrompt = ''
  $Global:prevMenuPositionY = 0
  $Global:prevMenuPositionX = 0
}
