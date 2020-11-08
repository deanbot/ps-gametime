$Global:DevMode = $true
$Global:Debug = "Continue"
$Global:Debug = "SilentlyContinue"
$Global:SilentStatusReturn = $false

if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

# UI Labels
$Global:unit = "pts"

Import-Module $Global:ScriptRoot\Constants.psm1 -Force
Import-Module $Global:ScriptRoot\DataAccess.psm1 -Force
Import-Module $Global:ScriptRoot\Controllers\Controllers.psm1 -Force
Import-Module $Global:ScriptRoot\Utilities.psm1 -Force
Import-Module $Global:ScriptRoot\ViewEngine.psm1 -Force

function Main {
  try {
    # set up console and store initial settings
    Initialize-Display

    # set up constants
    Initialize-Constants
    Initialize-Labels

    # initialzie view engine variables
    Initialize-Variables

    # start at main menu page
    Initialize-MainMenu

    # pause

    # main loop
    [bool]$repaint = $true
    do {
      # update screen only if a key being listened for was pressed
      if ($repaint) {
        Clear-Host
        Show-Screen
      }

      # respond to input and check if screen should repaint
      if (Get-HasPromptInput) {
        # maybe fall back to Read-Input but this could cause unexpected errors
        Read-PromptInput
        $repaint = $true
      }
      elseif (!$Global:forceRepaint) {
        $repaint = Read-Input
      }
      else {
        $repaint = $true
        $Global:forceRepaint = $false
      }
    }
    while (-not $Global:quit)
  }
  finally {
    # cleanup
    Restore-Display
  }
}

. Main
