# ascii logo via http://patorjk.com/software/taag/
param(
  # optional suffix to db file names
  [Parameter(Mandatory = $false, Position = 0)]
  [string]$SessionName = "",

  # alternate storage directory
  [Parameter(Mandatory = $false, Position = 1)]
  [string]$StorageLocation = ""

)

# import game time utilities
$Global:DevMode = $true
$Global:Debug = "Continue"
# $Global:Debug = "SilentlyContinue"
$Global:SilentStatusReturn = $false
$Global:SessionName = $SessionName
$Global:StorageLocation = $StorageLocation
$Global:ScriptRoot = $PSScriptRoot

# . $Global:ScriptRoot\Config.ps1

Import-Module $Global:ScriptRoot\DataAccess.psm1 -Force
Import-Module $Global:ScriptRoot\Utilities.psm1 -Force
Import-Module $Global:ScriptRoot\UI\UI.psm1 -Force

function Main {
  try {
    Initialize-Display
    Initialize-Variables
    Initialize-MainMenu
    [bool]$repaint = $true
    do {
      # update screen only if a key being listened for was pressed
      if ($repaint) {
        Clear-Host
        Show-Header
        Show-BodyContent
        Show-Footer
      }

      # respond to input and check if screen should repaint
      if (!$Global:forceRepaint) {
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
    Restore-Display
  }
}

. Main