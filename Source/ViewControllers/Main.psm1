if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

function Initialize-MainMenu {
  param(
    [Parameter(Mandatory = $false, Position = 0)]
    [int32]$menuPositionY = 0
  )
  $Global:section = $Section_Main
  $Global:subPage = ''
  $Global:menuPositionX = 0
  $Global:menuPositionY = $menuPositionY
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
  $Global:prevMainMenuPositionY = 0;
}
