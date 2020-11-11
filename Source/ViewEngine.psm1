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
Import-Module $Global:ScriptRoot\Views\Pages.psm1 -Force
Import-Module $Global:ScriptRoot\Views\Prompts.psm1 -Force
Import-Module $Global:ScriptRoot\ViewControllers\ViewControllers.psm1 -Force

# constants
  $Section_Main = 'Main Menu'
  $Section_Jobs = 'Jobs'
  $Section_Game = 'Game Time'
  $Section_Logs = 'Logs'
  $Section_Options = 'Options'
  $Page_Job_Single = 'Single'
  $Page_Job_New = 'New'
  $Page_Job_Complete = 'Complete'
  $Page_Job_Remove = 'Remove'
  $Page_Job_Edit = 'Edit'
  $Page_Game_Spend = 'Spend'
  $Page_Log_Single = 'Single'
  $Page_Log_Notes = 'Notes'
  $Page_Log_Edit = 'EditNotes'
  $Page_Options_DemoContent = 'DemoContent'
  $Page_Options_ConfirmDemoContent = 'ConfirmDemoContent'
  $Page_Options_ResetPoints = 'ResetPoints'
  $Page_Options_FactoryReset = 'FactoryReset'
  $Page_Options_StorageLocation = 'StorageLocation'

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

function Read-Input {
  $character = Read-Character
  $foundMatch = Read-PositionInput $character
  $section = $Global:section
  $subPage = $Global:subPage

  # section specific input
  if (!$foundMatch) {

    #  main menu
    if ($section -eq $Section_Main) {
      if ($character -eq [System.ConsoleKey]::Enter) {
        $Global:prevMainMenuPositionY = $Global:menuPositionY
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
    }
    #  jobs menu
    elseif ($section -eq $Section_Jobs) {
      if (!$subPage) {
        if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          Initialize-MainMenu $Global:prevMainMenuPositionY
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
              $Global:prevMenuPositionX = $Global:menuPositionX
              Initialize-JobNew
              $foundMatch = $true
            }
          }
        }
      }
      elseif ($subPage -eq $Page_Job_Single) {
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
      }
      elseif ($subPage -eq $Page_Job_Edit) {
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
      elseif ($subPage -eq $Page_Job_New) {
      }
    }
    # game menu
    elseif ($section -eq $Section_Game) {
      $hasAvailableBalance = Get-AvailableBalance -gt 0
      if ($hasAvailableBalance) {
        if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          Initialize-MainMenu $Global:prevMainMenuPositionY
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
          Initialize-MainMenu $Global:prevMainMenuPositionY
          $foundMatch = $true
        }
      }
    }
    # logs menu
    elseif ($section -eq $Section_Logs) {
      if (!$subPage) {
        if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          Initialize-MainMenu $Global:prevMainMenuPositionY
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
      } elseif ($subPage -eq $Page_Log_Single) {
        if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          # init logs menu and restore page
          Initialize-LogsMenu $Global:prevMenuPositionX
          $Global:prevMenuPositionX = 0
          $foundMatch = $true
        } elseif ($character -eq [System.ConsoleKey]::Enter) {
          Initialize-LogNotes
          $foundMatch = $true
        }
      } elseif ($subPage -eq $Page_Log_Notes) {
        if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          # init logs menu and restore page
          Initialize-LogSingle
          $foundMatch = $true
        } elseif ($character -eq [System.ConsoleKey]::Enter) {
          Initialize-LogEditNotes
          $foundMatch = $true
        }
      }
    }
    # options menu
    elseif ($section -eq $Section_Options) {
      if (!$subPage) {
        if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          Initialize-MainMenu $Global:prevMainMenuPositionY
          $foundMatch = $true
        }
        elseif ($character -eq [System.ConsoleKey]::Enter) {
          $global:prevMenuPositionY = $Global:menuPositionY
          switch ($Global:menuPositionY) {
            0 {
              Initialize-OptionsDemoContent
              $foundMatch = $true
            } 1 {
              Initialize-OptionsResetPoints
              $foundMatch = $true
            } 2 {
              Initialize-OptionsFactoryReset
              $foundMatch = $true
            }
          }
        }
      }
      elseif ($subPage -eq $Page_Options_DemoContent) {
        if ($character -eq [System.ConsoleKey]::Escape -or $character -eq [System.ConsoleKey]::Backspace) {
          Initialize-OptionsMenu
          $Global:menuPositionY = $global:prevMenuPositionY
          $global:prevMenuPositionY = 0
          $foundMatch = $true
        } elseif ($character -eq [System.ConsoleKey]::Enter) {
          Initialize-OptionsConfirmDemoContent
          $foundMatch = $true
        }
      }
    }
  }
  else {
    # found direction instruction
    if ($section -eq $Section_Jobs) {
      # get jobs for current section
      if (!$subPage) {
        if ($character -eq [System.ConsoleKey]::LeftArrow `
            -or $character -eq [System.ConsoleKey]::RightArrow) {
          Initialize-JobsSubSection
        }
      }
    }
    elseif ($section -eq $Section_Game) {
      if ($Global:menuPositionY -gt 0) {
        $Global:showSelect = $true
      }
      else {
        $Global:showSelect = $false
      }
    }
    elseif ($section -eq $Section_Logs) {
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
