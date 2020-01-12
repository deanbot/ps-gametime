if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

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
  $global:hideHeader = $false
  $global:hideFooter = $false
  $global:forceRepaint = $false
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
  $global:currentJobType = ''
  $global:menuPositionX = $menuPositionX
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 3
  $global:maxMenuPositionsY = 0
  $global:canChangeMenuPositonX = $true
  $global:canChangeMenuPositonY = $false
  $global:showEsc = $true
  $global:hideHeader = $false
  $global:hideFooter = $false
  Initialize-JobsSubSection
}

function Initialize-JobsSubSection {
  $global:canChangeMenuPositonX = $true
  $global:menuPositionY = 0

  # get sub section jobs
  $jobType = Get-CurrentJobType

  $jobs = (Get-Jobs) | Where-Object { $_.Type -eq $jobType }
  if ($jobs) {
    $jobs = , $jobs
  }
  $global:currentJobs = $jobs

  # one extra position to support add job option
  $global:maxMenuPositionsY = $jobs.Length + 1

  # allow vertical nav if multiple jobs
  $global:canChangeMenuPositonY = $jobs.Length -gt 0
}

function Initialize-JobsSingle {
  $global:subPage = $jobPageSingle
  $global:menuPositionY = 0
  $global:maxMenuPositionsY = 3
  $global:canChangeMenuPositonX = $false
  $global:canChangeMenuPositonY = $true
}

function Initialize-JobsNew {
  $global:subPage = $jobPageNew
  $global:canChangeMenuPositonX = $false
  $global:menuPositionY = 0
  $global:maxMenuPositionsY = 0
  $global:hideHeader = $true
  $global:hideFooter = $true
  $global:newJobTitle = ""
  $global:newJobRate = 0
}

function Initialize-JobsRemove {
  $global:subPage = $jobPageRemove
  $global:menuPositionY = 0
  $global:maxMenuPositionsY = 0
  $global:canChangeMenuPositonX = $false
  $global:canChangeMenuPositonY = $false
}

function Initialize-JobsComplete {
  $global:subPage = $jobPageComplete
  $global:menuPositionY = 0
  $global:maxMenuPositionsY = 0
  $global:canChangeMenuPositonX = $false
  $global:canChangeMenuPositonY = $false
  $global:notesStepPassed = $false
  $global:notes = ""
  $job = $global:currentJob
  if ($job.Type -ne 'Quest') {
    $global:duration = 1
  } else {
    $global:duration = 0
  }
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
          if ($global:menuPositionY -lt $global:maxMenuPositionsY - 1) {
            $global:currentJob = Get-CurrentJob
            if ($global:currentJob) {
              Initialize-JobsSingle
              $foundMatch = $true
            }
          }
          else {
            $global:currentJobType = Get-CurrentJobType
            Initialize-JobsNew
            $foundMatch = $true
          }
        }
        else {
          switch ($character) {
            'A' {
              if ($global:menuPositionY -ne $global:maxMenuPositionsY - 1) {
                $global:menuPositionY = $global:maxMenuPositionsY - 1;
                $foundMatch = $true
              }
            }
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
        elseif ($character -eq [System.ConsoleKey]::Enter) {
          switch($global:menuPositionY) {
            0 {
              Initialize-JobsComplete
              $foundMatch = $true
            } 1 {
              Initialize-JobsEdit
              $foundMatch = $true
            } 2 {
              Initialize-JobsRemove
              $foundMatch = $true
            }
          }
        }
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
      # elseif ($subPage -eq $jobPageNew) {
        # if ($character -eq [System.ConsoleKey]::Escape) {
          # init jobs menu and restore menu section
          # Initialize-JobsMenu $global:prevMenuPositionX
        #   $foundMatch = $true
        #   $global:prevMenuPositionX = 0
        # }
      # }
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

function Get-CurrentJobType {
  $pos = $global:menuPositionX
  switch ($pos) {
    0 {
      $jobType = 'Quest'
    } 1 {
      $jobType = 'Daily'
    } 2 {
      $jobType = 'Rare'
    }
  }
  $jobType
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
    elseif ($jobPage -eq $jobPageNew) {
      do {
        Show-JobsNew
        Read-NewJobInputVal
      } while ($global:subPage -eq $jobPageNew)
    } elseif ($jobPage -eq $jobPageComplete) {
      do {
        Show-JobConfirmComplete
        Read-JobCompleteInputVal
      } while ($global:subPage -eq $jobPageComplete)
    } elseif ($jobPage -eq $jobPageRemove) {
      do {
        Show-JobConfirmRemove
        Read-JobRemoveInputVal
      } while ($global:subPage -eq $jobPageRemove)
    }
  }
  elseif ($section -eq $sectionGameMenu) {
    Show-GameMenu
  }
  elseif ($section -eq $sectionLogsMenu) {
    Show-LogsMenu
  }
}

function Read-JobRemoveInputVal {
  $inputVal = $global:inputValue
  $quit = $false

  if ($inputVal -eq 'y') {
    $job = $global:currentJob
    if ($job) {
      $jobId = $job.Id
      try {
        $success = Remove-Job $jobId
        if ($success) {
          
        } else {
          Show-JobRemoveFailed
          $quit = $true
        }
      } catch {
        Show-JobRemoveFailed
        $quit = $true
      }
    } else {
      Show-JobRemoveFailed "Job ID not found"
      $quit = $true
    }
  } elseif ($inputVal -eq 'n' -or $inputVal -eq [System.ConsoleKey]::Escape) {
    $quit = $true
  }

  if ($quit) {
    Initialize-JobsMenu $global:prevMenuPositionX
    $global:prevMenuPositionX = 0
    $global:forceRepaint = $true
  }
} 

function Read-JobCompleteInputVal {
  $inputVal = $global:inputValue
  $quit = $false

  # first form step
  if (!$global:duration) {
    if ($inputVal -eq 'q') {
      $quit = $true
    } else {
      $warn = $false
      if (!$inputVal) {
        $warn = $true
      } else {
        try {
          if ([decimal]$inputVal -is [decimal]) {
            $inputVal = [decimal]$inputVal
          } else {
            $warn = $true
          }
        } catch {
          $warn = $true
        }
      }
      if ($warn -eq $true) {
        Show-JobCompleteDurationWarning
      } else {
        $global:duration = $inputVal
      }
    }
  } 
  
  # second form step
  elseif (!$global:notesStepPassed) {
    $global:notesStepPassed = $true
    $global:notes = $inputVal
  }

  # confirm step
  else {
    if ($inputVal -eq [System.ConsoleKey]::Escape `
      -or $inputVal -eq 'n') {
      $quit = $true
    } elseif ($inputVal -eq 'y') {
      try {
        $job = $global:currentJob
        $jobId = $job.Id 
        $notes = $global:notes
        $duration = $global:duration
        $transaction = New-JobTransaction $jobId $duration $notes
        if ($transaction) {
          $log = $transaction.Log
          Show-JobCompleteSuccess $log 
          $quit = $true
        } else {
          Show-JobCompleteFailed
          $quit = $true
        }
      } catch {
        Show-JobCompleteFailed
        $quit = $true
      }
    }
  }

  if ($quit) {
    Initialize-JobsMenu $global:prevMenuPositionX
    $global:prevMenuPositionX = 0
    $global:forceRepaint = $true
  }
}

function Read-NewJobInputVal {
  $inputVal = $global:newInputValue
  $quit = $false

  # step 1 of input form
  if (!$global:newJobTitle) {
    # if empty title return
    if ($inputVal -eq 'q') {
      Show-JobNewFailed
      $quit = $true
    } elseif (!$inputVal) {
      Show-JobTitleWarning
    }
    # set new title
    else {
      $global:newJobTitle = $inputVal
    }
  }

  # step 2 of input form
  elseif (!$global:newJobRate) {
    if ($inputVal -eq 'q') {
      Show-JobNewFailed
      $quit = $true
    } else {
      $warn = $false
      if (!$inputVal) {
        $warn = $true
      } else {
        try {
          if ([decimal]$inputVal -is [decimal]) {
            $inputVal = [decimal]$inputVal
          } else {
            $warn = $true
          }
        } catch {
          $warn = $true
        }
      }
      if ($warn -eq $true) {
        Show-JobRateWarning 
      } else {
        $global:newJobRate = $inputVal
      }
    } 
    
  }

  # step 3 of input form
  else {
    if ($inputVal -eq 'q' `
      -or $inputVal -eq 'n') {
      Show-JobNewFailed
      $quit = $true
    } else {
      $success = New-Job $global:newJobTitle $global:currentJobType $global:newJobRate
      if ($success) {
        Show-JobNewSuccess
      } else {
        Show-JobNewFailed
      }
      $quit = $true
    }
  }

  if ($quit) {
    Initialize-JobsMenu $global:prevMenuPositionX
    $global:prevMenuPositionX = 0
    $global:forceRepaint = $true
  }
}