$setionOptionsMenu = 'Options'

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
