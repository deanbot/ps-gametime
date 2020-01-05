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
    $changed = $true
    do {
      if ($changed) {
        Clear-Host
        Show-Header
        Show-BodyContent
        Show-Footer
      }
      $changed = Read-Input
    }
    while (-not $global:quit)
  }
  finally {
    Restore-Display
  }
}

. Main