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

function Initialize-MainMenu {
  $Global:section = $sectionMainMenu
  $Global:subPage = ''
  $Global:menuPositionX = 0
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsX = 0
  $Global:maxMenuPositionsY = 3
  $Global:canChangeMenuY = $true
  $Global:canChangeMenuPositionY = $true
  $Global:canChangeMenuPositionX = $false
  $Global:showReturn = $false
  $Global:showSelect = $true
  $Global:invertY = $false
}

function Initialize-JobsMenu {
  param(
    [Parameter(Mandatory = $false, Position = 0)]
    [int32]$menuPositionX = 0
  )
  $Global:section = $sectionJobsMenu
  $Global:subPage = ''
  $Global:currentJob = ''
  $Global:currentJobType = ''
  $Global:menuPositionX = $menuPositionX
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsX = 3
  $Global:maxMenuPositionsY = 0
  $Global:canChangeMenuPositionX = $true
  $Global:canChangeMenuPositionY = $false
  $Global:showReturn = $true
  $Global:hideHeader = $false
  $Global:hideFooter = $false
  Initialize-JobsSubSection
}

function Initialize-JobsSubSection {
  $Global:canChangeMenuPositionX = $true
  $Global:menuPositionY = 0

  # get sub section jobs
  $jobs = Get-CurrentJobs
  $Global:currentJobs = $jobs
  $jobCount = @($jobs).Length

  $Global:maxMenuPositionsY = $jobCount

  # allow vertical nav if multiple jobs
  $Global:canChangeMenuPositionY = $jobCount -gt 1
  $Global:showSelect = $jobCount -gt 0
}

function Initialize-JobSingle {
  $Global:subPage = $jobPageSingle
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsY = 3
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $true
  $Global:showSelect = $true
}

function Initialize-JobEdit {
  $Global:subPage = $jobPageEdit
  $Global:menuPositionY = 0

  $current = $Global:currentJob
  $type = $current.Type
  if ($type -like '*Quest*') {
    $Global:maxMenuPositionsY = 4
  }
  else {
    $Global:maxMenuPositionsY = 3
  }
  $Global:maxMenuPositionsY = 4
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $true
  $Global:currentField = $false
  $Global:showQuit = $true
  $Global:showSelect = $true
}

function Initialize-JobEditField {
  $posY = $Global:menuPositionY

  $current = $Global:currentJob
  $type = $current.Type

  $field = ''
  if ($type -like '*Quest*') {
    $isTimed = $Type -eq 'Quest-Timed'
    if ($posY -eq 2) {
      $jobId = $current.Id
      if ($isTimed) {
        $newType = 'Quest'
      }
      else {
        $newType = 'Quest-Timed'
      }
      $success = Edit-Job $jobId -Type $newType
      if (!$success) {
        Show-JobEditFailed
      }
      else {
        $Global:currentJob = Get-Job $jobId
        Initialize-JobEdit
        $Global:menuPositionY = $posY
        # $Global:forceRepaint = $true
      }
    }
    else {
      switch ($posY) {
        0 {
          $field = 'Title'
        } 1 {
          $field = 'Type'
        } 3 {
          $field = 'Rate'
        }
      }
    }
  }
  else {
    switch ($posY) {
      0 {
        $field = 'Title'
      } 1 {
        $field = 'Type'
      } 2 {
        $field = 'Rate'
      }
    }
  }

  if ($field) {
    $Global:currentField = $field
    if ($field -eq 'Type') {
      $Global:showQuit = $false
    }
  }
}

function Initialize-JobNew {
  $Global:subPage = $jobPageNew
  $Global:canChangeMenuPositionX = $false
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsY = 0
  $Global:hideHeader = $true
  $Global:hideFooter = $true
  $Global:newJobTitle = ""
  $Global:newJobSubtype = ""
  $Global:newJobRate = 0
}

function Initialize-JobRemove {
  $Global:subPage = $jobPageRemove
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsY = 0
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
}

function Initialize-JobComplete {
  $Global:subPage = $jobPageComplete
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsY = 0
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
  $Global:notesStepPassed = $false
  $Global:notes = ""
  $job = $Global:currentJob
  if ($job.Type -ne 'Quest-Timed') {
    $Global:duration = 1
  }
  else {
    $Global:duration = 0
  }
}

function Initialize-GameMenu {
  $Global:section = $sectionGameMenu
  $Global:subPage = ''
  $Global:menuPositionX = 0
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsX = 0
  $Global:canChangeMenuPositionX = $false
  $Global:notesStepPassed = $false
  $Global:notes = ""
  $Global:hideFooter = $false
  $Global:showReturn = $true
  $Global:showSelect = $false

  $availableBalance = Get-AvailableBalance
  $hasAvailableBalance = $availableBalance -gt 0
  if ($hasAvailableBalance) {
    $Global:maxMenuPositionsY = $availableBalance + 1
    $Global:canChangeMenuPositionY = $true
    $Global:invertY = $true
  }
  else {
    $Global:maxMenuPositionsY = 0
    $Global:canChangeMenuPositionY = $false
  }
}

function Initialize-GameConfirmPage {
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
  $Global:subPage = $gamePageSpend
  $Global:showReturn = $true
  $Global:hideFooter = $true
}

function Initialize-LogsMenu {
  $Global:section = $sectionLogsMenu
  $Global:subPage = ''
  $Global:menuPositionX = 0
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsX = 0
  $Global:maxMenuPositionsY = 0
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
  $Global:showReturn = $true
  $Global:showSelect = $false
}

function Read-QuitInput {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$value
  )
  $foundMatch = $false;
  if ($value -eq "q") {
    $Global:quit = $true
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
        if ($character -eq [System.ConsoleKey]::LeftArrow -or $character -eq [System.ConsoleKey]::RightArrow) {
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
    $foundMatch = Read-QuitInput $character
  }
  $foundMatch
}

function Get-CurrentJob {
  $pos = $Global:menuPositionY
  $jobs = $Global:currentJobs
  if ($jobs -and $jobs.Length -ge ($pos - 1) ) {
    return $jobs[$pos]
  }
  return $false
}

function Get-CurrentJobType {
  $pos = $Global:menuPositionX
  $jobType = Get-JobTypeByPosition $pos
  $jobType
}

function Get-CurrentJobs {
  $jobType = Get-CurrentJobType
  $jobs = (Get-Jobs) | Where-Object { $_.Type -like "*$jobType*" }
  $jobs
}

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

function Read-GameConfirmInputVal {
  $inputVal = $Global:inputValue
  $quit = $false

  # first form step
  if (!$Global:notesStepPassed) {
    $Global:notesStepPassed = $true
    $Global:notes = $inputVal
  }

  # confirm step
  else {
    if ($inputVal -eq 'y') {
      try {
        $notes = $Global:notes
        $points = $Global:menuPositionY
        $transaction = New-DeductTransaction $points $notes
        if ($transaction) {
          Show-GameSpendSuccess $message
          $quit = $true
        }
        else {
          Show-GameSpendFailed
          $quit = $true
        }
      }
      catch {
        Show-GameSpendFailed $_
        $quit = $true
      }
    }
    elseif ($inputVal -eq 'n' -or $inputVal -eq [System.ConsoleKey]::Escape) {
      $quit = $true
    }
  }

  if ($quit) {
    Initialize-GameMenu
    $Global:forceRepaint = $true
  }
}

function Read-JobRemoveInputVal {
  $inputVal = $Global:inputValue
  $quit = $false

  if ($inputVal -eq 'y') {
    $job = $Global:currentJob
    if ($job) {
      $jobId = $job.Id
      try {
        $success = Remove-Job $jobId
        if ($success) {
          $quit = $true
        }
        else {
          Show-JobRemoveFailed
          $quit = $true
        }
      }
      catch {
        Show-JobRemoveFailed
        $quit = $true
      }
    }
    else {
      Show-JobRemoveFailed "Job ID not found"
      $quit = $true
    }
  }
  elseif ($inputVal -eq 'n' -or $inputVal -eq [System.ConsoleKey]::Escape) {
    $quit = $true
  }

  if ($quit) {
    Initialize-JobsMenu $Global:prevMenuPositionX
    $Global:prevMenuPositionX = 0
    $Global:forceRepaint = $true
  }
}

function Read-JobCompleteInputVal {
  $inputVal = $Global:inputValue
  $quit = $false

  # first form step
  if (!$Global:duration) {
    if ($inputVal -eq 'q') {
      $quit = $true
    }
    else {
      $warn = $false
      if (!$inputVal) {
        $warn = $true
      }
      else {
        try {
          if ([decimal]$inputVal -is [decimal]) {
            $inputVal = [decimal]$inputVal
          }
          else {
            $warn = $true
          }
        }
        catch {
          $warn = $true
        }
      }
      if ($warn -eq $true) {
        Show-JobCompleteDurationWarning
      }
      else {
        $Global:duration = $inputVal
      }
    }
  }

  # second form step
  elseif (!$Global:notesStepPassed) {
    $Global:notesStepPassed = $true
    $Global:notes = $inputVal
  }

  # confirm step
  else {
    if ($inputVal -eq [System.ConsoleKey]::Escape `
        -or $inputVal -eq [System.ConsoleKey]::Backspace) {
      $quit = $true
    }
    elseif ($inputVal -eq [System.ConsoleKey]::Enter) {
      try {
        $job = $Global:currentJob
        $jobId = $job.Id
        $notes = $Global:notes
        $duration = $Global:duration
        $transaction = New-JobTransaction $jobId $duration $notes
        if ($transaction) {
          if ($transaction.Change -ne 1) {
            $message = "Gained $($transaction.Change) points!"
          }
          else {
            $message = "Gained $($transaction.Change) point!"
          }
          Show-JobCompleteSuccess $message
          $quit = $true
        }
        else {
          Show-JobCompleteFailed
          $quit = $true
        }
      }
      catch {
        Show-JobCompleteFailed
        $quit = $true
      }
    }
  }

  if ($quit) {
    Initialize-JobSingle
    $Global:forceRepaint = $true
  }
}

function Read-NewJobInputVal {
  $inputVal = $Global:inputValue
  $quit = $false

  # step 1 of input form
  if (!$Global:newJobTitle) {
    # if empty title return
    if ($inputVal -eq 'q') {
      # Show-JobNewFailed
      $quit = $true
    }
    elseif (!$inputVal) {
      Show-JobTitleWarning
    }
    # set new title
    else {
      $Global:newJobTitle = $inputVal
    }
  }

  else {
    $type = $Global:currentJobType
    $subType = $Global:newJobSubType
    if ($type -like '*Quest*' -and !$subType) {
      if ($inputVal -eq 'q') {
        # Show-JobNewFailed
        $quit = $true
      }
      elseif ($inputVal -eq 'n') {
        $Global:newJobSubType = 'Standard'
      }
      elseif ($inputVal -eq 'y') {
        $Global:newJobSubType = 'Timed'
      }
    }
    elseif (!$Global:newJobRate) {
      if ($inputVal -eq 'q') {
        # Show-JobNewFailed
        $quit = $true
      }
      else {
        $warn = $false
        if (!$inputVal) {
          $warn = $true
        }
        else {
          try {
            if ([decimal]$inputVal -is [decimal]) {
              $inputVal = [decimal]$inputVal
            }
            else {
              $warn = $true
            }
          }
          catch {
            $warn = $true
          }
        }
        if ($warn -eq $true) {
          Show-JobRateWarning
        }
        else {
          $Global:newJobRate = $inputVal
        }
      }
    }  # step 3 of input form
    else {
      if ($inputVal -eq 'q' `
          -or $inputVal -eq 'n') {
        Show-JobNewFailed
        $quit = $true
      }
      else {
        $newType = $Global:currentJobType;
        if ($type -eq 'Quest' -and $subType -eq 'Timed') {
          $newType = "$newType-Timed"
        }
        $success = New-Job $Global:newJobTitle $newType $Global:newJobRate
        if ($success) {
          Show-JobNewSuccess
        }
        else {
          Show-JobNewFailed
        }
        $quit = $true
      }
    }

  }

  if ($quit) {
    Initialize-JobsMenu $Global:prevMenuPositionX
    $Global:prevMenuPositionX = 0
    $Global:forceRepaint = $true
  }
}

function Read-JobEditInputVal {
  $inputVal = $Global:inputValue
  $quit = $false
  $update = $false
  $field = $Global:currentField

  if ($inputVal -eq 'q' -and $field -ne 'Type') {
    $quit = $true
  }
  else {
    $job = $Global:currentJob
    $jobId = $job.Id
    if ($field -eq 'Title') {
      if (!$inputVal) {
        Show-JobTitleWarning
      }
      else {
        $success = Edit-Job $jobId $inputVal
        if (!$success) {
          Show-JobEditFailed
        }
        else {
          $update = $true
        }
        $quit = $true
      }
    }
    elseif ($field -eq 'Type') {
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
        [System.ConsoleKey]::Backspace {
          $quit = $true
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
          }
          else {
            $update = $true
          }
          $quit = $true
        }
        else {
          $quit = $true
        }
      }
    }
    elseif ($field -eq 'Rate') {
      if (!$inputVal) {
        $warn = $true
      }
      else {
        try {
          if ([decimal]$inputVal -is [decimal]) {
            $inputVal = [decimal]$inputVal
          }
          else {
            $warn = $true
          }
        }
        catch {
          $warn = $true
        }
      }
      if ($warn -eq $true) {
        Show-JobRateWarning
      }
      else {
        $success = Edit-Job $jobId -Rate $inputVal
        if (!$success) {
          Show-JobEditFailed
        }
        else {
          $update = $true
        }
        $quit = $true
      }
    }
  }

  # get new job data from db
  if ($update) {
    $Global:currentJob = Get-Job $jobId
  }

  if ($quit) {
    Initialize-JobEdit
    $Global:forceRepaint = $true
  }
}