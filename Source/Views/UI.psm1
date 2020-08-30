# Shared layout elements

function Show-Header {
  $width = $Global:containerWidth
  $widthLeft = [System.Math]::Floor($width / 2) - 6
  $widthRight = [System.Math]::Ceiling($width / 2) + 6
  if (!$Global:hideHeader) {
    Write-Host "    _____                 _______            "
    Write-Host "   / ___/__  __ _  ___   /_  __(_)_ _  ___   "
    Write-Host "  / (_ / _ ``/  ' \/ -_)   / / / /  ' \/ -_)  "
    Write-Host "  \___/\_,_/_/_/_/\__/   /_/ /_/_/_/_/\__/   "
    Write-Host "                                             "
    if ($Global:showQuit) {
      Write-Host "  $(Get-PaddedString "Bal: $(Get-Balance)" -Width $widthLeft)$(Get-PaddedString "[Q] Quit" -Right $true -Width $widthRight)"
    }
    else {
      Write-Host "  Bal: $(Get-Balance)"
    }
  }
}

function Show-Footer {
  if (!$Global:hideFooter) {
    Show-ControlsFooter
  }
  Write-Host ""
}

function Show-ControlsFooter {
  $canNavX = $Global:canChangeMenuPositionX
  $canNavY = $Global:canChangeMenuPositionY
  $posX = $Global:menuPositionX
  $posY = $Global:menuPositionY
  $maxX = $Global:maxMenuPositionsX
  $maxY = $Global:maxMenuPositionsY
  $invertY = $Global:invertY
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
  # $width = $Global:containerWidth
  # $widthLeft = [System.Math]::Floor($width / 2) - 6
  # $widthRight = [System.Math]::Ceiling($width / 2) + 6

  if ($Global:showSelect) {
    Write-Host "  $(Get-PaddedString "   Press [Enter] to select      [$n]")  "
  }
  else {
    Write-Host "  $(Get-PaddedString "                                [$n]")  "
  }
  Write-Host "  $(Get-PaddedString "                             [$w]   [$e]")  "
  if ($Global:showReturn) {
    Write-Host "  $(Get-PaddedString "   <- [Esc/Bksp]                [$s]")  "
  }
  else {
    Write-Host "  $(Get-PaddedString "                                [$s]")  "
  }
}

function Show-Heading {
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Text
  )
  $width = $Global:containerWidth
  Write-Host "    .$(Get-PaddedString -Fill '-' -Width ($width -4)).  "
  Write-Host "   /$(Get-PaddedString $(Get-TextExcerpt $Text ($width-6)) -Center $true -Width ($width-2))\  "
  Write-Host "  |$(Get-PaddedString -Fill "-" )|  "
}