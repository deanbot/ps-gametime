# ascii logo via http://patorjk.com/software/taag/

# import game time utilities
$Global:Debug = "Continue"
$Global:SilentStatusReturn = $false
Import-Module $pwd\DataAccess.psm1 -Force
Import-Module $pwd\Utilities.psm1 -Force
Import-Module $pwd\UI\UI.psm1 -Force

function Main {
  try {
    Initialize-Display
    Initialize-Variables
    Initialize-MainMenu
    $repaint = $true
    do {
      # update screen only if a key being listened for was pressed
      if ($repaint) {
        Clear-Host
        Show-Header
        Show-BodyContent
        Show-Footer
      }

      # respond to input and check if screen should repaint
      $repaint = Read-Input
    }
    while (-not $global:quit)
  }
  finally {
    Restore-Display
  }
}

. Main