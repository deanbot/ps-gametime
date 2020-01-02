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
  Write-Host "  Bal: $(Get-Balance)         "

}


function Show-Footer {
  Write-Host "                                             "
  if ($global:showEsc) {
    Write-Host "  <- (Esc)               Press (Q) to quit   "
  } else {
    Write-Host "                         Press (Q) to quit   "
  }
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
  $global:subPage = ''
  $global:menuPositionX = 0
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 0
  $global:maxMenuPositionsY = 0
  $global:containerWidth = 39
  $global:canChangeMenuPositonX = $false
  $global:canChangeMenuPositonY = $false
  $global:showEsc = $false
}

function Init-MainMenu {
  $global:section = $sectionMainMenu
  $global:subPage = ''
  $global:menuPositionX = 0
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 0
  $global:maxMenuPositionsY = 3
  $global:canChangeMenuPositonY = $true
  $global:canChangeMenuPositonX = $false
  $global:showEsc = $false
}

function Init-JobsMenu {
  $global:section = $sectionJobsMenu
  $global:subPage = ''
  $global:menuPositionX = 0
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 3
  $global:maxMenuPositionsY = 0
  $global:canChangeMenuPositonX = $true
  $global:canChangeMenuPositonY = $false
  $global:showEsc = $true
  Init-JobsSubSection
}

function Init-JobsSubSection {
  $global:canChangeMenuPositonX = $true
  $global:canChangeMenuPositonY = $false

  # get sub section jobs
  $posX = $global:menuPositionX
  switch ($posX) {
    0 {
      $jobType = 'Quest'
    } 1 {
      $jobType = 'Daily'
    } 2 {
      $jobType = 'Rare'
    }
  }
  $jobs = (Get-Jobs) | Where-Object { $_.Type -eq $jobType }
  $global:currentJobs = $jobs
  $jobs = , $jobs

  # allow vertical nav if multiple jobs
  $global:canChangeMenuPositonY = $jobs.Length -gt 1
}

function Init-JobsSingle {
  $global:subPage = $jobPageSingle
  $global:menuPositionY = 0
  $global:maxMenuPositionsY = 3
  $global:canChangeMenuPositonX = $false
  $global:canChangeMenuPositonY = $true
}

function Init-GameMenu {
  $global:section = $sectionGameMenu
  $global:subPage = ''
  $global:menuPositionX = 0
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 0
  $global:maxMenuPositionsY = 0
  $global:canChangeMenuPositonX = $false
  $global:canChangeMenuPositonY = $false
  $global:showEsc = $true
}

function Init-LogsMenu {
  $global:section = $sectionLogsMenu
  $global:subPage = ''
  $global:menuPositionX = 0
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 0
  $global:maxMenuPositionsY = 0
  $global:canChangeMenuPositonX = $false
  $global:canChangeMenuPositonY = $false
  $global:showEsc = $true
}

# constants
$sectionMainMenu = 'Main Menu'
$sectionJobsMenu = 'Jobs'
$sectionGameMenu = 'Game Time'
$sectionLogsMenu = 'Logs'
$jobPageSingle = 'single'

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
  $jobs = $global:currentJobs

  Write-Host ""
  if ($isQuest) {
    Write-Host "   .-------, ________  _______               "
    Write-Host "  / Quest /_/ Daily /_/ Rare /____________   "
  }
  elseif ($isDaily) {
    Write-Host "   ________  .-------, _______"
    Write-Host "  / Quest /_/ Daily /_/ Rare /____________   "
  }
  elseif ($isRare) {
    Write-Host "   ________  ________  .------,              "
    Write-Host "  / Quest /_/ Daily /_/ Rare /____________   "
  }
  Write-Host "  |$(Get-PaddedString)|  "
  Show-JobCheckBoxes $jobs
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString '  Press [Enter] to select')|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
  # Write-Host "  |  (R)emove job                         |  "
  # # Write-Host "  (B)alance"
  # Write-Host "  |  (S)pend Game Time points             |  "
  # Write-Host "  |  (V)iew logs                          |  "
}

function Show-JobsSingle {
  $pos = $global:menuPositionY
  $job = Get-CurrentJob
  $jobTitle = $job.Title
  $jobRate = $job.Rate
  $jobRateSuffix = ""
  if ($job.Type -eq "Quest") {
    $jobRateSuffix = " per hour"
  }
  Write-Host ""
  Write-Host "   $(Get-PaddedString -Fill '_')  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  $jobTitle")|  "
  Write-Host "  |$(Get-PaddedString "  (rewards: $jobRate$jobRateSuffix)")|  "
  Write-Host "  |$(Get-PaddedString)|  "
  $completeLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 0))(C)omplete"
  Write-Host "  |$completeLine|  "
  $editLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 1))(E)dit"
  Write-Host "  |$editLine|  "
  $removeLine = Get-PaddedString "  $(Get-CheckBox ($pos -eq 2))(R)emove"
  Write-Host "  |$removeLine|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

function Show-GameMenu {
  $width = $global:containerWidth
  Write-Host ""
  Write-Host "   .-----------,"
  # Write-Host "  / Game Time /___________________________   "
  Write-Host "  $(Get-PaddedString '/ Game Time /' '_' ($width+1))  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

function Show-LogsMenu {
  $width = $global:containerWidth
  Write-Host ""
  Write-Host "   .------,"
  # Write-Host "  / Logs /___________________________   "
  Write-Host "  $(Get-PaddedString '/ Logs /' '_' ($width+1))  "
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

function Show-JobCheckBoxes {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    $jobs
  )
  $jobs = , $jobs
  $pos = $global:menuPositionY
  for ($i = 0; $i -lt $jobs.Length; $i++) {
    $job = $jobs[$i]
    $selected = $pos -eq $i
    $jobLine = "  $(Get-CheckBox $selected) $($job.Title)"
    Write-Host "  |$(Get-PaddedString $jobLine)|  "
  }
}

function Get-CurrentJob {
  $pos = $global:menuPositionY
  $jobs = $global:currentJobs
  if ($jobs -and $jobs.Length -ge ($pos - 1) ) {
    return $jobs[$pos]
  }
  return $false
}

function Show-BodyContent {
  $section = $global:section
  if ($section -eq $sectionMainMenu) {
    Show-MainMenu
  }
  elseif ($section -eq $sectionJobsMenu) {
    $jobPage = $global:subPage
    if (!$jobPage) {
      Show-JobsMenu
    }
    elseif ($jobPage -eq $jobPageSingle) {
      Show-JobsSingle
    }
  }
  elseif ($section -eq $sectionGameMenu) {
    Show-GameMenu
  }
  elseif ($section -eq $sectionLogsMenu) {
    Show-LogsMenu
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
        if ($global:menuPositionY -lt ($global:maxMenuPositionsY - 1)) {
          $global:menuPositionY++
          $foundMatch = $true
        }
      }
      elseif ($character -eq [System.ConsoleKey]::UpArrow) {
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
  $section = $global:section
  $subPage = $global:subPage

  # section specific input
  if (!$foundMatch) {

    #  main menu
    if ($section -eq $sectionMainMenu) {
      if ($character -eq [System.ConsoleKey]::Enter) {
        switch ($global:menuPositionY) {
          0 {
            Init-JobsMenu
          } 1 {
            Init-GameMenu
          } 2 {
            Init-LogsMenu
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
      if (!$subPage) {
        if ($character -eq [System.ConsoleKey]::Escape) {
          Init-MainMenu
        }
        elseif ($character -eq [System.ConsoleKey]::Enter) {
          $global:prevMenuPositionX = $global:menuPositionX
          Init-JobsSingle
        }
      }
      elseif ($subPage -eq $jobPageSingle) {
        if ($character -eq [System.ConsoleKey]::Escape) {
          Init-JobsMenu
          $global:menuPositionX = $global:prevMenuPositionX
          $global:prevMenuPositionX = 0
        }
        # elseif ($character -eq [System.ConsoleKey]::Enter) {

        # }
      }
    }
    # game menu
    elseif ($section -eq $sectionGameMenu) {
      if ($character -eq [System.ConsoleKey]::Escape) {
        Init-MainMenu
      }
    }
    # logs menu
    elseif ($section -eq $sectionLogsMenu) {
      if ($character -eq [System.ConsoleKey]::Escape) {
        Init-MainMenu
      }
    }
  } else {
    # direction instruction
    if ($section -eq $sectionJobsMenu) {
      if (!$subPage) {
        if ($character -eq [System.ConsoleKey]::LeftArrow -or $character -eq [System.ConsoleKey]::RightArrow) {
          Init-JobsSubSection
        }
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