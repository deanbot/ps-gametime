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
$global:DevMode = $true
$Global:Debug = "Continue"
$Global:SilentStatusReturn = $false
$Global:SessionName = $SessionName
$Global:StorageLocation = $StorageLocation

# . $pwd\Config.ps1

Import-Module $pwd\DataAccess.psm1 -Force
Import-Module $pwd\Utilities.psm1 -Force
Import-Module $pwd\UI\UI.psm1 -Force

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
      if (!$global:forceRepaint) {
        $repaint = Read-Input
      }
      else {
        $repaint = $true
        $global:forceRepaint = $false
      }
    }
    while (-not $global:quit)
  }
  finally {
    Restore-Display
  }
}

. Main