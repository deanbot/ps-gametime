Import-Module $pwd\UI\Utilities.psm1 -Force
Import-Module $pwd\UI\Logic.psm1 -Force
Import-Module $pwd\UI\Game\View.psm1 -Force
Import-Module $pwd\UI\Index\View.psm1 -Force
Import-Module $pwd\UI\Jobs\View.psm1 -Force
Import-Module $pwd\UI\Logs\View.psm1 -Force

function Show-Header {
  if (!$global:hideHeader) {
    Write-Host "    _____                 _______            "
    Write-Host "   / ___/__  __ _  ___   /_  __(_)_ _  ___   "
    Write-Host "  / (_ / _ ``/  ' \/ -_)   / / / /  ' \/ -_)  "
    Write-Host "  \___/\_,_/_/_/_/\__/   /_/ /_/_/_/_/\__/   "
    Write-Host "                                             "
    Write-Host "  Bal: $(Get-Balance)         "
  }
}

function Show-Footer {
  if (!$global:hideFooter) {
    Write-Host "                                             "
    if ($global:showEsc) {
      Write-Host "  <- (Esc)               Press (Q) to quit   "
    }
    else {
      Write-Host "                         Press (Q) to quit   "
    }
    Write-Host "                                             "
  }
}