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
$gamePageSpend = 'Spend'

function Initialize-Variables {
  $global:quit = $false
  $global:section = ''
  $global:subPage = ''
  $global:menuPositionX = 0
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 0
  $global:maxMenuPositionsY = 0
  $global:containerWidth = 39
  $global:canChangeMenuPositionX = $false
  $global:canChangeMenuPositionY = $false
  $global:showEsc = $false
  $global:showQuit = $true
  $global:hideHeader = $false
  $global:hideFooter = $false
  $global:forceRepaint = $false
  $global:invertY = $false
}

function Initialize-MainMenu {
  $global:section = $sectionMainMenu
  $global:subPage = ''
  $global:menuPositionX = 0
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 0
  $global:maxMenuPositionsY = 3
  $global:canChangeMenuY = $true
  $global:canChangeMenuPositionY = $true
  $global:canChangeMenuPositionX = $false
  $global:showEsc = $false
  $global:invertY = $false
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
  $global:canChangeMenuPositionX = $true
  $global:canChangeMenuPositionY = $false
  $global:showEsc = $true
  $global:hideHeader = $false
  $global:hideFooter = $false
  Initialize-JobsSubSection
}

function Initialize-JobsSubSection {
  $global:canChangeMenuPositionX = $true
  $global:menuPositionY = 0

  # get sub section jobs
  $jobs = Get-CurrentJobs
  $global:currentJobs = $jobs

  # one extra position to support add job option
  $global:maxMenuPositionsY = $jobs.Length + 1

  # allow vertical nav if multiple jobs
  $global:canChangeMenuPositionY = $jobs.Length -gt 0
}

function Initialize-JobSingle {
  $global:subPage = $jobPageSingle
  $global:menuPositionY = 0
  $global:maxMenuPositionsY = 3
  $global:canChangeMenuPositionX = $false
  $global:canChangeMenuPositionY = $true
}

function Initialize-JobEdit {
  $global:subPage = $jobPageEdit
  $global:menuPositionY = 0
  $job = $global:currentJob
  # increment each max y by 1 if using Cancel option
  if ($job.Type -eq 'Quest') {
    $global:maxMenuPositionsY = 3 #4
  } else {
    $global:maxMenuPositionsY = 2 #3
  }
  $global:canChangeMenuPositionX = $false
  $global:canChangeMenuPositionY = $true
  $global:currentField = $false
  $global:showQuit = $true
}

function Initialize-JobEditField {
  $posY = $global:menuPositionY
  $field = ''
  switch ($posY) {
    0 {
      $field = 'Title'
    } 1 {
      $field = 'Type'
    } 2 {
      # can only reach in Quest job
      $field = 'Rate'
    }
  }
  $global:currentField = $field
  if ($field -eq 'Type') {
    $global:showQuit = $false
  }
}

function Initialize-JobNew {
  $global:subPage = $jobPageNew
  $global:canChangeMenuPositionX = $false
  $global:menuPositionY = 0
  $global:maxMenuPositionsY = 0
  $global:hideHeader = $true
  $global:hideFooter = $true
  $global:newJobTitle = ""
  $global:newJobRate = 0
}

function Initialize-JobRemove {
  $global:subPage = $jobPageRemove
  $global:menuPositionY = 0
  $global:maxMenuPositionsY = 0
  $global:canChangeMenuPositionX = $false
  $global:canChangeMenuPositionY = $false
}

function Initialize-JobComplete {
  $global:subPage = $jobPageComplete
  $global:menuPositionY = 0
  $global:maxMenuPositionsY = 0
  $global:canChangeMenuPositionX = $false
  $global:canChangeMenuPositionY = $false
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
  $global:canChangeMenuPositionX = $false
  $global:notesStepPassed = $false
  $global:notes = ""

  $availableBalance = Get-AvailableBalance
  $hasAvailableBalance = $availableBalance -gt 0
  if ($hasAvailableBalance) {
    $global:maxMenuPositionsY = $availableBalance + 1
    $global:canChangeMenuPositionY = $true
    $global:showEsc = $true
    $global:invertY = $true
  } else {
    $global:maxMenuPositionsY = 0
    $global:canChangeMenuPositionY = $false
    $global:showEsc = $false
  }
}

function Initialize-GameConfirmPage {
  $global:canChangeMenuPositionX = $false
  $global:canChangeMenuPositionY = $false
  $global:subPage = $gamePageSpend
  $global:showEsc = $true
}

function Initialize-LogsMenu {
  $global:section = $sectionLogsMenu
  $global:subPage = ''
  $global:menuPositionX = 0
  $global:menuPositionY = 0
  $global:maxMenuPositionsX = 0
  $global:maxMenuPositionsY = 0
  $global:canChangeMenuPositionX = $false
  $global:canChangeMenuPositionY = $false
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
  if ($global:canChangeMenuPositionX) {
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
    if ($global:canChangeMenuPositionY) {
      if (!$global:invertY) {  
        # position starts at top and goes down the page 
        if ($character -eq [System.ConsoleKey]::DownArrow) {
          if ($global:menuPositionY -lt ($global:maxMenuPositionsY - 1)) {
            $global:menuPositionY++
            $foundMatch = $true
          }
        } elseif ($character -eq [System.ConsoleKey]::UpArrow) {
          if ($global:menuPositionY -gt 0) {
            $global:menuPositionY--
            $foundMatch = $true
          }
        }
      } else {
        # position starts at bottom and goes up
        if ($character -eq [System.ConsoleKey]::UpArrow) {
          if ($global:menuPositionY -lt ($global:maxMenuPositionsY - 1)) {
            $global:menuPositionY++
            $foundMatch = $true
          }
        } elseif ($character -eq [System.ConsoleKey]::DownArrow) {
          if ($global:menuPositionY -gt 0) {
            $global:menuPositionY--
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
              Initialize-JobSingle
              $foundMatch = $true
            }
          }
          else {
            $global:currentJobType = Get-CurrentJobType
            Initialize-JobNew
            $foundMatch = $true
          }
        }
        else {
          # hidden option (not advertised)
          switch ($character) {
            'A' {
              if ($global:menuPositionY -ne $global:maxMenuPositionsY - 1) {
                $global:menuPositionY = $global:maxMenuPositionsY - 1;
                $jobs = $global:currentJobs
                $global:menuPositionY = $jobs.Length
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
      elseif ($subPage -eq $jobPageEdit) {
        if ($character -eq [System.ConsoleKey]::Enter) {
          # uncomment if including cancel option
          # if ($global:menuPositionY -eq $global:maxMenuPositionsY - 1) {
          #   Initialize-JobSingle
          # } else {
            Initialize-JobEditField
          # }
          $foundMatch = $true
        } elseif ([System.ConsoleKey]::Escape) {
          Initialize-JobSingle
          $foundMatch = $true
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
      $hasAvailableBalance = Get-AvailableBalance -gt 0
      if ($hasAvailableBalance) {
        if ($character -eq [System.ConsoleKey]::Escape) {
          Initialize-MainMenu
          $foundMatch = $true
        } elseif ($character -eq [System.ConsoleKey]::Enter) {
          if ($global:menuPositionY -gt 0) {
            Initialize-GameConfirmPage
            $foundMatch = $true
          }
        }
      } else {
        if ($character) {
          Initialize-MainMenu
          $foundMatch = $true
        }
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
  $jobType = Get-JobTypeByPosition $pos
  $jobType
}

function Get-CurrentJobs {
  $jobType = Get-CurrentJobType
  $jobs = (Get-Jobs) | Where-Object { $_.Type -eq $jobType }
  $jobs
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
      Show-JobSingle
    }
    elseif ($jobPage -eq $jobPageNew) {
      do {
        Show-JobNew
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
    } elseif ($jobPage -eq $jobPageEdit) {
      if ($global:currentField) {
        do {
          Show-JobField
          Read-JobEditInputVal
        } while ($global:currentField)
      } else {
        Show-JobEdit
      }
    }
  }
  elseif ($section -eq $sectionGameMenu) {
    $subPage = $global:subPage
    if (!$subPage) {
      Show-GameMenu
    } elseif ($subPage -eq $gamePageSpend) {
      do {
        Show-GameConfirmSpend
        Read-GameConfirmInputVal
      } while ($global:subPage -eq $gameSpageSpend)
    }
    
  }
  elseif ($section -eq $sectionLogsMenu) {
    Show-LogsMenu
  }
}

function Read-GameConfirmInputVal {
  $inputVal = $global:inputValue
  $quit = $false

  # first form step
  if (!$global:notesStepPassed) {
    $global:notesStepPassed = $true
    $global:notes = $inputVal
  }

  # confirm step
  else {
    if ($inputVal -eq 'y') {
    } elseif ($inputVal -eq 'n' -or $inputVal -eq [System.ConsoleKey]::Escape) {
      $quit = $true
    }
  }

  if ($quit) {
    Initialize-GameMenu
    $global:forceRepaint = $true
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
          $quit = $true
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
          $message = "Gained $($transaction.Change) points!"
          Show-JobCompleteSuccess $message
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
  $inputVal = $global:inputValue
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

function Read-JobEditInputVal {
  $inputVal = $global:inputValue
  $quit = $false
  $update = $false
  $field = $global:currentField
  
  if ($inputVal -eq 'q' -and $field -ne 'Type') {
    $quit = $true
  } else {
    $job = $global:currentJob
    $jobId = $job.Id
    if ($field -eq 'Title') {
      if (!$inputVal) {
        Show-JobTitleWarning
      } else {
        $success = Edit-Job $jobId $inputVal
        if (!$success) {
          Show-JobEditFailed
        } else {
          $update = $true
        }
        $quit = $true
      }
    } elseif ($field -eq 'Type') {
      $oldType = $job.Type
      $newType = ''
      switch ($inputVal) {
        'Q' {
          $newType = 'Quest'
        } 'D' {
          $newType = 'Daily'
        } 'R' {
          $newType = 'Rare'
        }
        [System.ConsoleKey]::Escape {
          $quit = $true
        }
      }
      if (!$quit) {
        if ($newType -ne $oldType) {
          $success = Edit-Job $jobId -Type $newType
          if (!$success) {
            Show-JobEditFailed
          } else {
            $update = $true
          }
          $quit = $true
        } else {
          $quit = $true
        }
      }
    } elseif ($field -eq 'Rate') {
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
        $success = Edit-Job $jobId -Rate $inputVal
        if (!$success) {
          Show-JobEditFailed
        } else {
          $update = $true
        }
        $quit = $true
      }
    }
  }

  # get new job data from db
  if ($update) {
    $global:currentJob = Get-Job $jobId
  }

  if ($quit) {
    Initialize-JobEdit
    $global:forceRepaint = $true
  }
}