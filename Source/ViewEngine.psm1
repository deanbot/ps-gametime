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
$sectionOptionsMenu = 'Options'
$jobPageSingle = 'Single'
$jobPageNew = 'New'
$jobPageComplete = 'Complete'
$jobPageRemove = 'Remove'
$jobPageEdit = 'Edit'
$gamePageSpend = 'Spend'
$logPageSingle = 'Single'
$promptNewJob = 'NewJob'
$promptCompleteJob = 'CompleteJob'
$promptEditJob = 'EditJob'
$promptRemoveJob = 'RemoveJob'
$promptGameSpend = 'GameSpend'

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
  $Global:currentPrompt = '';
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

function Read-PromptInput {
  $section = $Global:section
  $subPage = $Global:subPage
  if ($section -eq $sectionJobsMenu) {
    if ($subPage -eq $jobPageNew) {
      Read-NewJobInputVal
    } elseif ($subPage -eq $jobPageComplete) {
      Read-JobCompleteInputVal
    } elseif ($subPage -eq $jobPageRemove) {
      Read-JobRemoveInputVal
    } elseif ($subPage -eq $jobPageEdit) {
      Read-JobEditInputVal
    }
  } elseif ($section -eq $sectionGameMenu) {
    if ($subPage -eq $gamePageSpend) {
      Read-GameConfirmInputVal
    }
  }
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
          } 3 {
            Initialize-OptionsMenu
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
      elseif ($subPage -eq $jobPageNew) {
      }
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
      if (!$subPage) {
        if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          Initialize-MainMenu
          $foundMatch = $true
        }
        elseif ($character -eq [System.ConsoleKey]::Enter) {
          $Global:prevMenuPositionX = $Global:menuPositionX
          $Global:currentTransaction = Get-CurrentTransaction
          if ($Global:currentTransaction) {
            Initialize-LogSingle
            $foundMatch = $true
          }
        }
      } elseif ($subPage -eq $logPageSingle) {
        if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          # init logs menu and restore page
          Initialize-LogsMenu $Global:prevMenuPositionX
          $foundMatch = $true
          $Global:prevMenuPositionX = 0
        }
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
    elseif ($section -eq $sectionGameMenu) {
      if ($Global:menuPositionY -gt 0) {
        $Global:showSelect = $true
      }
      else {
        $Global:showSelect = $false
      }
    }
    elseif ($section -eq $sectionLogsMenu) {
      if ($character -eq [System.ConsoleKey]::LeftArrow `
          -or $character -eq [System.ConsoleKey]::RightArrow) {
        Initialize-LogsPage
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
  $subPage = $Global:subPage
  if ($section -eq $sectionMainMenu) {
    Show-MainMenu
  }
  elseif ($section -eq $sectionJobsMenu) {
    if (!$subPage) {
      Show-JobsMenu
    }
    elseif ($subPage -eq $jobPageSingle) {
      Show-JobSingle
    }
    elseif ($subPage -eq $jobPageNew) {
      Show-JobNew
    }
    elseif ($subPage -eq $jobPageComplete) {
      Show-JobConfirmComplete
    }
    elseif ($subPage -eq $jobPageRemove) {
      Show-JobConfirmRemove
    }
    elseif ($subPage -eq $jobPageEdit) {
      if ($Global:currentField) {
        Show-JobField
      }
      else {
        Show-JobEdit
      }
    }
  }
  elseif ($section -eq $sectionGameMenu) {
    if (!$subPage) {
      Show-GameMenu
    }
    elseif ($subPage -eq $gamePageSpend) {
      Show-GameConfirmSpend
    }
  }
  elseif ($section -eq $sectionLogsMenu) {
    if (!$subPage) {
      Show-LogsMenu
    } elseif ($subPage -eq $logPageSingle) {
      Show-LogSingle
    }
  }
  elseif ($section -eq $sectionOptionsMenu) {
    Show-OptionsMenu
  } else {
    write-Host $section
    pause
  }
}

function Show-Prompt {
  $prompt = $Global:currentPrompt
  if ($prompt -eq $promptNewJob) {
    Show-PromptNewJob
  } elseif ($prompt -eq $promptCompleteJob) {
    Show-PromptCompleteJob
  } elseif ($prompt -eq $promptEditJob) {
    Show-PromptEditJob
  } elseif ($prompt -eq $promptRemoveJob) {
    Show-PromptRemoveJob
  } elseif ($prompt -eq $promptGameSpend) {
    Show-PromptSpend
  }
}

# full layout
function Show-Screen {
  Show-Header
  Show-BodyContent
  if (!(Get-HasPromptInput)) {
    Show-Footer
  } else {
    Show-Prompt
  }
}
