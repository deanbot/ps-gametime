Import-Module $pwd\UI\Utilities.psm1 -Force
Import-Module $pwd\UI\Logic.psm1 -Force
Import-Module $pwd\UI\Game\View.psm1 -Force
Import-Module $pwd\UI\Index\View.psm1 -Force
Import-Module $pwd\UI\Jobs\View.psm1 -Force
Import-Module $pwd\UI\Logs\View.psm1 -Force

function Show-Header {
  $width = $global:containerWidth
  $widthLeft = [System.Math]::Floor($width / 2) - 6
  $widthRight = [System.Math]::Ceiling($width / 2) + 6
  if (!$global:hideHeader) {
    Write-Host "    _____                 _______            "
    Write-Host "   / ___/__  __ _  ___   /_  __(_)_ _  ___   "
    Write-Host "  / (_ / _ ``/  ' \/ -_)   / / / /  ' \/ -_)  "
    Write-Host "  \___/\_,_/_/_/_/\__/   /_/ /_/_/_/_/\__/   "
    Write-Host "                                             "
    # Write-Host "  $(Get-PaddedString "Bal: $(Get-Balance)" -Width $widthLeft)$(Get-PaddedString "Press (Q) to quit" -Right $true -Width $widthRight)"
    Write-Host "  $(Get-PaddedString "Bal: $(Get-Balance)" -Width $widthLeft)$(Get-PaddedString "[Q]uit" -Right $true -Width $widthRight)"
  }
}

function Show-Footer {
  Show-ControlsFooter

  if (!$global:hideFooter) {
    Write-Host "                                             "
    # Write-Host "  $(Get-PaddedString "( < Navigate > )" -Center $true)  "
    if ($global:showEsc) {
      if ($global:showQuit) {
        # Write-Host "    <- (Esc)             Press (Q) to quit   "
        # Write-Host "    <- (Esc)                                 "
      }
      else {
        # Write-Host "    <- (Esc)                                 "
      }
    }
    else {
      if ($global:showQuit) {
        # Write-Host "                         Press (Q) to quit   "
        # Write-Host "                                             "
      }
    }
    Write-Host "                                             "
  }
}

function Show-ControlsFooter {
  $canNavX = $global:canChangeMenuPositionX
  $canNavY = $global:canChangeMenuPositionY
  $posX = $global:menuPositionX
  $posY = $global:menuPositionY
  $maxX = $global:maxMenuPositionsX
  $maxY = $global:maxMenuPositionsY
  $invertY = $global:invertY
  $n = '0'
  $e = '0'
  $s = '0'
  $w = '0'

  if ($canNavX) {
    if ($posX -gt 0) {
      $w = '<'
    }
    if ($posX -lt $maxX - 1) {
      $e = '>'
    }
  }
  if ($canNavY) {
    if (!$invertY) {
      if ($posY -gt 0) {
        $n = '^'
      }
      if ($posY -lt $maxY - 1) {
        $s = 'v'
      }
    }
    else {
      if ($posY -gt 0) {
        $s = 'v'
      }
      if ($posY -lt $maxY - 1) {
        $n = '^'
      }
    }
  }
  $width = $global:containerWidth
  $widthLeft = [System.Math]::Floor($width / 2) - 6
  $widthRight = [System.Math]::Ceiling($width / 2) + 6

  # Write-Host "  $(Get-PaddedString "($n)    " -Right $true)  "
  Write-Host "  $(Get-PaddedString "  Press [Enter] to select       [$n]")  "
  # Write-Host "  $(Get-PaddedString "  Press [Enter] to select    ($w)   ($e)")  "
  Write-Host "  $(Get-PaddedString "                             [$w]   [$e]")  "
  # Write-Host "  $(Get-PaddedString "($s)    " -Right $true)  "
  # Write-Host "  $(Get-PaddedString "  Press [Enter] to select       ($s)")  "
  if ($global:showEsc) {
    Write-Host "  $(Get-PaddedString "  <- [Esc/Bksp]                 [$s]")  "
  } else {
    Write-Host "  $(Get-PaddedString "                                [$s]")  "
  }
  # Write-Host "  $(Get-PaddedString "  Press [Back] to return" -Width $widthLeft)$(Get-PaddedString "($s)" -Right $true -Width $widthRight)  "
}