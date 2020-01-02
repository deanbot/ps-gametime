# ascii logo via http://patorjk.com/software/taag/

# import game time utilities
$Global:Debug = "Continue"
$Global:SilentStatusReturn = $false
Import-Module $pwd\DataAccess.psm1 -Force
Import-Module $pwd\Utilities.psm1 -Force
Import-Module $pwd\UI.psm1 -Force

function Read-Character() {
  param(
    [bool]$blocking = $true
  )
  if ($blocking) {
    return [System.Console]::ReadKey($true).Key.ToString()
  }
  elseif ([System.Console]::KeyAvailable) {
    return [System.Console]::ReadKey($true).Key.ToString()
  }
  return 0
  # if ($host.ui.RawUI.KeyAvailable) {
  # return $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp").Character
  # }
}

function Setup-Display {
  $global:originalBufferWidth = [System.Console]::BufferWidth
  $global:originalBufferHeight = [System.Console]::BufferHeight
  $global:originalWindowHeight = [System.Console]::WindowHeight
  $global:originalWindowWidth = [System.Console]::WindowWidth
  # $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(55, 110)
  # $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(160, 5000)
  # $width = 160
  # $height = 61
  # if ([System.Console]::BufferWidth -gt $width -or [System.Console]::BufferHeight -gt $height) {
  #   [System.Console]::SetWindowSize(1, 1);
  # }
  # [System.Console]::SetBufferSize(160, 200); [System.Console]::SetWindowSize(160, 200);
}

function Reset-Display {
  Clear-Host
  if ([System.Console]::BufferWidth -gt $global:originalBufferWidth -or [System.Console]::BufferHeight -gt $global:originalBufferHeight) {
    [System.Console]::SetWindowSize(1, 1);
  }
  [System.Console]::SetBufferSize($global:originalBufferWidth, $global:originalBufferHeight);
  [System.Console]::SetWindowSize($global:originalWindowWidth, $global:originalWindowHeight);
}

function Show-Header {

  Write-Host "    _____                 _______            "
  Write-Host "   / ___/__ ___ _  ___   /_  __(_)_ _  ___   "
  Write-Host "  / (_ / _ ``/  ' \/ -_)   / / / /  ' \/ -_)  "
  Write-Host "  \___/\_,_/_/_/_/\__/   /_/ /_/_/_/_/\__/   "
  Write-Host "                                             "
  Write-Host "  Bal: $(Get-Balance)"

}


function Show-Footer {
  Write-Host "                                             "
  Write-Host "                         Press (Q) to quit   "
  Write-Host "                                             "
}

function Get-CheckBox {
  param(
    [Parameter(Mandatory = $false, Position = 0)]
    [bool]$checked
  )
  if ($checked) {
    "[*] "
  }
  else {
    "[ ] "
  }
}

function Get-PaddedString {
  param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$label = "",

    [Parameter(Mandatory = $false, Position = 1)]
    [string]$fill = " ",

    [Parameter(Mandatory = $false, Position = 2)]
    [int]$width
  )
  if (!$width) {
    $width = $global:containerWidth
  }
  $padded = $label
  if ($padded.Length -lt $width) {
    do {
      $padded += $fill
    }
    until($padded.Length -ge $width)
  }
  $padded
}

function Init {
  $global:quit = $false
  $global:section = ''
  $global:menuPositionX = 0
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 0
  $global:maxMenuPositionsY = 0
  $global:containerWidth = 39
  $global:canChangeMenuPositonX = $false
  $global:canChangeMenuPositonY = $false
}

function Init-MainMenu {
  $global:section = $sectionMainMenu
  $global:menuPositionX = 0
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 0
  $global:maxMenuPositionsY = 3
  $global:canChangeMenuPositonY = $true
  $global:canChangeMenuPositonX = $false
}

function Init-JobsMenu {
  $global:section = $sectionJobsMenu
  $global:menuPositionX = 0
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 3
  $global:maxMenuPositionsY = 0
  $global:canChangeMenuPositonX = $true
  $global:canChangeMenuPositonY = $false
}

# constants
$sectionMainMenu = 'Main Menu'
$sectionJobsMenu = 'Jobs'

function Show-MainMenu {
  $width = $global:containerWidth
  $pos = $global:menuPositionY
  $jobLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))(J)obs"
  $gameLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))(G)ame"
  $logLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 2))(L)Log"

  Write-Host ""
  # Write-Host "   _______________________________________"
  Write-Host "   .-----------,"
  # Write-Host "  / Main Menu /___________________________   "
  Write-Host "  $(Get-PaddedString '/ Main Menu /' '_' ($width+1))  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$jobLine|  "
  Write-Host "  |$gameLine|  "
  Write-Host "  |$logLine|  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString '  Press [Enter] to select')|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

function Show-JobsMenu {
  $posX = $global:menuPositionX
  $isQuest = $posX -eq 0
  $isDaily = $posX -eq 1
  $isRare = $posx -eq 2

  Write-Host ""
  if ($isQuest) {
    Write-Host "   .-------, ________  _______"
    Write-Host "  / Quest /_/ Daily /_/ Rare /____________   "
  }
  elseif ($isDaily) {
    Write-Host "   ________  .-------, _______"
    Write-Host "  / Quest /_/ Daily /_/ Rare /____________   "
  }
  elseif ($isRare) {
    Write-Host "   ________  ________  .------,"
    Write-Host "  / Quest /_/ Daily /_/ Rare /____________   "
  }
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  # Write-Host "  |  (E)dit job                           |  "
  # Write-Host "  |  (R)emove job                         |  "
  # # Write-Host "  (B)alance"
  # Write-Host "  |  (S)pend Game Time points             |  "
  # Write-Host "  |  (V)iew logs                          |  "
}

function Show-BodyContent {
  switch ($global:section) {
    $sectionMainMenu {
      Show-MainMenu
    } $sectionJobsMenu {
      Show-JobsMenu
    }
  }
}

function Read-QuitInput {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$value
  )

  if ($value -eq "q") {
    $global:quit = $true
  }
}

function Read-PositionInput {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$value
  )
  $foundMatch = $false
  if ($global:canChangeMenuPositonX) {
    if ($character -eq [System.ConsoleKey]::LeftArrow) {
      if ($global:menuPositionX -gt 0) {
        $global:menuPositionX--
        $foundMatch = $true
      }
    }
    elseif ($character -eq [System.ConsoleKey]::RightArrow) {
      if ($global:menuPositionX -lt ($global:maxMenuPositionsX - 1)) {
        $global:menuPositionX++
        $foundMatch = $true
      }
    }
  }
  if (!$foundMatch) {
    if ($global:canChangeMenuPositonY) {
      if ($character -eq [System.ConsoleKey]::DownArrow) {
        'down'
        if ($global:menuPositionY -lt ($global:maxMenuPositionsY - 1)) {
          $global:menuPositionY++
          $foundMatch = $true
        }
      }
      elseif ($character -eq [System.ConsoleKey]::UpArrow) {
        'up'
        if ($global:menuPositionY -gt 0) {
          $global:menuPositionY--
          $foundMatch = $true
        }
      }
    }
  }
  $foundMatch
}

function Read-Input {
  $character = Read-Character
  $foundMatch = Read-PositionInput $character

  # section specific input
  if (!$foundMatch) {

    #  main menu
    if ($section -eq $sectionMainMenu) {
      if ($character -eq [System.ConsoleKey]::Enter) {
        switch ($global:menuPositionY) {
          0 {
            Init-JobsMenu
          } 1 {

          } 2 {

          }
        }
      }
      else {
        switch ($character) {
          'j' {
            $global:menuPositionY = 0
          } 'g' {
            $global:menuPositionY = 1
          } 'l' {
            $global:menuPositionY = 2
          }
        }
      }
    }
    #  jobs menu
    elseif ($section -eq $sectionJobsMenu) {
      if ($character -eq [System.ConsoleKey]::Escape) {
        Init-MainMenu
      }
    }

  }
  Read-QuitInput $character
}

function Main {
  try {
    Setup-Display
    Init
    Init-MainMenu
    do {
      Clear-Host
      Show-Header
      Show-BodyContent
      Show-Footer
      Read-Input
    }
    while (-not $global:quit)
  }
  finally {
    Reset-Display
  }
}

. Main