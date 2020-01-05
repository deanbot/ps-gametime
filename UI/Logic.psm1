# constants
$sectionMainMenu = 'Main Menu'
$sectionJobsMenu = 'Jobs'
$sectionGameMenu = 'Game Time'
$sectionLogsMenu = 'Logs'
$jobPageSingle = 'Single'

function Initialize-Variables {
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

function Initialize-MainMenu {
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

function Initialize-JobsMenu {
  param(
    [Parameter(Mandatory = $false, Position = 0)]
    [int32]$menuPositionX = 0
  )
  $global:section = $sectionJobsMenu
  $global:subPage = ''
  $global:currentJob = ''
  $global:menuPositionX = $menuPositionX
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 3
  $global:maxMenuPositionsY = 0
  $global:canChangeMenuPositonX = $true
  $global:canChangeMenuPositonY = $false
  $global:showEsc = $true
  Initialize-JobsSubSection
}

function Initialize-JobsSubSection {
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

function Initialize-JobsSingle {
  $global:subPage = $jobPageSingle
  $global:menuPositionY = 0
  $global:maxMenuPositionsY = 3
  $global:canChangeMenuPositonX = $false
  $global:canChangeMenuPositonY = $true
}

function Initialize-GameMenu {
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

function Initialize-LogsMenu {
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

function Read-QuitInput {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$value
  )
  $foundMatch = $false;
  if ($value -eq "q") {
    $global:quit = $true
    $foundMatch = $true
  }
  $foundMatch
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
            Initialize-JobsMenu
          } 1 {
            Initialize-GameMenu
          } 2 {
            Initialize-LogsMenu
          }
        }
        $foundMatch = $true
      }
      else {
        switch ($character) {
          'j' {
            $global:menuPositionY = 0
            $foundMatch = $true
          } 'g' {
            $global:menuPositionY = 1
            $foundMatch = $true
          } 'l' {
            $global:menuPositionY = 2
            $foundMatch = $true
          }
        }
      }
    }
    #  jobs menu
    elseif ($section -eq $sectionJobsMenu) {
      if (!$subPage) {
        if ($character -eq [System.ConsoleKey]::Escape) {
          Initialize-MainMenu
          $foundMatch = $true
        }
        elseif ($character -eq [System.ConsoleKey]::Enter) {
          $global:prevMenuPositionX = $global:menuPositionX
          $global:currentJob = Get-CurrentJob
          if ($global:currentJob) {
            Initialize-JobsSingle
            $foundMatch = $true
          }
        }
      }
      elseif ($subPage -eq $jobPageSingle) {
        if ($character -eq [System.ConsoleKey]::Escape) {
          # init jobs menu and restore menu section
          Initialize-JobsMenu $global:prevMenuPositionX
          $foundMatch = $true
          $global:prevMenuPositionX = 0
        }
        # elseif ($character -eq [System.ConsoleKey]::Enter) {

        # }
        else {
          switch ($character) {
            'C' {
              $global:menuPositionY = 0
              $foundMatch = $true
            } 'E' {
              $global:menuPositionY = 1
              $foundMatch = $true
            } 'R' {
              $global:menuPositionY = 2
              $foundMatch = $true
            }
          }
        }
      }
    }
    # game menu
    elseif ($section -eq $sectionGameMenu) {
      if ($character -eq [System.ConsoleKey]::Escape) {
        Initialize-MainMenu
        $foundMatch = $true
      }
    }
    # logs menu
    elseif ($section -eq $sectionLogsMenu) {
      if ($character -eq [System.ConsoleKey]::Escape) {
        Initialize-MainMenu
        $foundMatch = $true
      }
    }
  }
  else {
    # found direction instruction
    if ($section -eq $sectionJobsMenu) {
      # get jobs for current section
      if (!$subPage) {
        if ($character -eq [System.ConsoleKey]::LeftArrow -or $character -eq [System.ConsoleKey]::RightArrow) {
          Initialize-JobsSubSection
        }
      }
    }
  }
  if (!$foundMatch) {
    $foundMatch = Read-QuitInput $character
  }
  $foundMatch
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