# View Engine
# ... Listen to inputs and indicate when display should repaint
# ... Show correct view
# ... Call controller methods

if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

Import-Module $Global:ScriptRoot\Views\Views.psm1 -Force
Import-Module $Global:ScriptRoot\ViewControllers\ViewControllers.psm1 -Force

# constants
$sectionMainMenu = 'Main Menu'
$sectionJobsMenu = 'Jobs'
$sectionGameMenu = 'Game Time'
$sectionLogsMenu = 'Logs'
$jobPageSingle = 'Single'
$jobPageNew = 'New'
$jobPageComplete = 'Complete'
$jobPageRemove = 'Remove'
$jobPageEdit = 'Edit'
$gamePageSpend = 'Spend'

function Initialize-Variables {
  $Global:quit = $false
  $Global:section = ''
  $Global:subPage = ''
  $Global:menuPositionX = 0
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsX = 0
  $Global:maxMenuPositionsY = 0
  $Global:containerWidth = 39
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
  $Global:showReturn = $false

  $Global:showQuit = $true
  $Global:hideHeader = $false
  $Global:hideFooter = $false
  $Global:forceRepaint = $false
  $Global:invertY = $false
}

function Read-PositionInput {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$value
  )
  $foundMatch = $false
  if ($Global:canChangeMenuPositionX) {
    if ($character -eq [System.ConsoleKey]::LeftArrow) {
      if ($Global:menuPositionX -gt 0) {
        $Global:menuPositionX--
        $foundMatch = $true
      }
    }
    elseif ($character -eq [System.ConsoleKey]::RightArrow) {
      if ($Global:menuPositionX -lt ($Global:maxMenuPositionsX - 1)) {
        $Global:menuPositionX++
        $foundMatch = $true
      }
    }
  }
  if (!$foundMatch) {
    if ($Global:canChangeMenuPositionY) {
      if (!$Global:invertY) {
        # position starts at top and goes down the page
        if ($character -eq [System.ConsoleKey]::DownArrow) {
          if ($Global:menuPositionY -lt ($Global:maxMenuPositionsY - 1)) {
            $Global:menuPositionY++
            $foundMatch = $true
          }
        }
        elseif ($character -eq [System.ConsoleKey]::UpArrow) {
          if ($Global:menuPositionY -gt 0) {
            $Global:menuPositionY--
            $foundMatch = $true
          }
        }
      }
      else {
        # position starts at bottom and goes up
        if ($character -eq [System.ConsoleKey]::UpArrow) {
          if ($Global:menuPositionY -lt ($Global:maxMenuPositionsY - 1)) {
            $Global:menuPositionY++
            $foundMatch = $true
          }
        }
        elseif ($character -eq [System.ConsoleKey]::DownArrow) {
          if ($Global:menuPositionY -gt 0) {
            $Global:menuPositionY--
            $foundMatch = $true
          }
        }
      }
    }
  }
  $foundMatch
}

function Read-Input {
  $character = Read-Character
  $foundMatch = Read-PositionInput $character
  $section = $Global:section
  $subPage = $Global:subPage

  # section specific input
  if (!$foundMatch) {

    #  main menu
    if ($section -eq $sectionMainMenu) {
      if ($character -eq [System.ConsoleKey]::Enter) {
        switch ($Global:menuPositionY) {
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
            $Global:menuPositionY = 0
            $foundMatch = $true
          } 'g' {
            $Global:menuPositionY = 1
            $foundMatch = $true
          } 'l' {
            $Global:menuPositionY = 2
            $foundMatch = $true
          }
        }
      }
    }
    #  jobs menu
    elseif ($section -eq $sectionJobsMenu) {
      if (!$subPage) {
        if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          Initialize-MainMenu
          $foundMatch = $true
        }
        elseif ($character -eq [System.ConsoleKey]::Enter) {
          $Global:prevMenuPositionX = $Global:menuPositionX
          $Global:currentJob = Get-CurrentJob
          if ($Global:currentJob) {
            Initialize-JobSingle
            $foundMatch = $true
          }
        }
        else {
          switch ($character) {
            'N' {
              $Global:currentJobType = Get-CurrentJobType
              Initialize-JobNew
              $foundMatch = $true
            }
          }
        }
      }
      elseif ($subPage -eq $jobPageSingle) {
        if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          # init jobs menu and restore menu section
          Initialize-JobsMenu $Global:prevMenuPositionX
          $foundMatch = $true
          $Global:prevMenuPositionX = 0
        }
        elseif ($character -eq [System.ConsoleKey]::Enter) {
          switch ($Global:menuPositionY) {
            0 {
              Initialize-JobComplete
              $foundMatch = $true
            } 1 {
              Initialize-JobEdit
              $foundMatch = $true
            } 2 {
              Initialize-JobRemove
              $foundMatch = $true
            }
          }
        }
        else {
          switch ($character) {
            'C' {
              $Global:menuPositionY = 0
              $foundMatch = $true
            } 'E' {
              $Global:menuPositionY = 1
              $foundMatch = $true
            } 'R' {
              $Global:menuPositionY = 2
              $foundMatch = $true
            }
          }
        }
      }
      elseif ($subPage -eq $jobPageEdit) {
        if ($character -eq [System.ConsoleKey]::Enter) {
          # uncomment if including cancel option
          # if ($Global:menuPositionY -eq $Global:maxMenuPositionsY - 1) {
          #   Initialize-JobSingle
          # } else {
          Initialize-JobEditField
          # }
          $foundMatch = $true
        }
        elseif ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          Initialize-JobSingle
          $foundMatch = $true
        }
      }
      # elseif ($subPage -eq $jobPageNew) {
      # if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
      # init jobs menu and restore menu section
      # Initialize-JobsMenu $Global:prevMenuPositionX
      #   $foundMatch = $true
      #   $Global:prevMenuPositionX = 0
      # }
      # }
    }
    # game menu
    elseif ($section -eq $sectionGameMenu) {
      $hasAvailableBalance = Get-AvailableBalance -gt 0
      if ($hasAvailableBalance) {
        if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          Initialize-MainMenu
          $foundMatch = $true
        }
        elseif ($character -eq [System.ConsoleKey]::Enter) {
          if ($Global:menuPositionY -gt 0) {
            Initialize-GameConfirmPage
            $foundMatch = $true
          }
        }
        elseif ($character -eq [System.ConsoleKey]::OemPlus) {
          if ($Global:menuPositionY -lt ($Global:maxMenuPositionsY - 1)) {
            $Global:menuPositionY++
            $foundMatch = $true
          }
        }
        elseif ($character -eq [System.ConsoleKey]::OemMinus) {
          if ($Global:menuPositionY -gt 0) {
            $Global:menuPositionY--
            $foundMatch = $true
          }
        }
      }
      else {
        if ($character) {
          Initialize-MainMenu
          $foundMatch = $true
        }
      }
    }
    # logs menu
    elseif ($section -eq $sectionLogsMenu) {
      if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
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
        if ($character -eq [System.ConsoleKey]::LeftArrow `
            -or $character -eq [System.ConsoleKey]::RightArrow) {
          Initialize-JobsSubSection
        }
      }
    }
    if ($section -eq $sectionGameMenu) {
      if ($Global:menuPositionY -gt 0) {
        $Global:showSelect = $true
      }
      else {
        $Global:showSelect = $false
      }
    }
  }
  if (!$foundMatch) {
    if ($character -eq "q") {
      $Global:quit = $true
      $foundMatch = $true
    }
  }
  $foundMatch
}


# view body content routing
function Show-BodyContent {
  $section = $Global:section
  if ($section -eq $sectionMainMenu) {
    Show-MainMenu
  }
  elseif ($section -eq $sectionJobsMenu) {
    $jobPage = $Global:subPage
    if (!$jobPage) {
      Show-JobsMenu
    }
    elseif ($jobPage -eq $jobPageSingle) {
      Show-JobSingle
    }
    elseif ($jobPage -eq $jobPageNew) {
      do {
        Show-JobNew
        Read-NewJobInputVal
      } while ($Global:subPage -eq $jobPageNew)
    }
    elseif ($jobPage -eq $jobPageComplete) {
      do {
        Show-JobConfirmComplete
        Read-JobCompleteInputVal
      } while ($Global:subPage -eq $jobPageComplete)
    }
    elseif ($jobPage -eq $jobPageRemove) {
      do {
        Show-JobConfirmRemove
        Read-JobRemoveInputVal
      } while ($Global:subPage -eq $jobPageRemove)
    }
    elseif ($jobPage -eq $jobPageEdit) {
      if ($Global:currentField) {
        do {
          Show-JobField
          Read-JobEditInputVal
        } while ($Global:currentField)
      }
      else {
        Show-JobEdit
      }
    }
  }
  elseif ($section -eq $sectionGameMenu) {
    $subPage = $Global:subPage
    if (!$subPage) {
      Show-GameMenu
    }
    elseif ($subPage -eq $gamePageSpend) {
      do {
        Show-GameConfirmSpend
        Read-GameConfirmInputVal
      } while ($Global:subPage -eq $gamePageSpend)
    }
  }
  elseif ($section -eq $sectionLogsMenu) {
    Show-LogsMenu
  }
}

# full layout
function Show-Screen {
  Show-Header
  Show-BodyContent
  Show-Footer
}