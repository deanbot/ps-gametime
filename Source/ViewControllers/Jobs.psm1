if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

# constants
$sectionJobsMenu = 'Jobs'
$jobPageSingle = 'Single'
$jobPageNew = 'New'
$jobPageComplete = 'Complete'
$jobPageRemove = 'Remove'
$jobPageEdit = 'Edit'
$JobTypeQuest = 'Quest'
$JobTypeQuestTimed = 'Quest-Timed'
$JobTypeDaily = 'Daily'
$JobTypeRare = 'Rare'
$promptNewJob = 'NewJob'
$promptCompleteJob = 'CompleteJob'
$promptEditJob = 'EditJob'
$promptRemoveJob = 'RemoveJob'


function Get-JobTypeByPosition {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [int32]$posX
  )
  $jobType = "";
  switch ($posX) {
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
  $Global:currentPrompt = ''
  Initialize-JobsSubSection
}

function Initialize-JobEdit {
  $Global:subPage = $jobPageEdit
  $Global:menuPositionY = 0

  $current = $Global:currentJob
  $type = $current.Type
  if ($type -like "*$JobTypeQuest*") {
    $Global:maxMenuPositionsY = 4
  }
  else {
    $Global:maxMenuPositionsY = 3
  }
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $true
  $Global:currentField = $false
  $Global:showQuit = $true
  $Global:showSelect = $true
  $Global:currentPrompt = ''
}

function Initialize-JobEditField {
  $posY = $Global:menuPositionY
  $current = $Global:currentJob
  $type = $current.Type

  $field = ''
  if ($type -like "*$JobTypeQuest*") {
    $isTimed = $Type -eq $JobTypeQuestTimed
    if ($posY -eq 2) {
      $jobId = $current.Id
      if ($isTimed) {
        $newType = $JobTypeQuest
      }
      else {
        $newType = $JobTypeQuestTimed
      }
      $success = Edit-Job $jobId -Type $newType
      if (!$success) {
        Show-JobEditFailed
      }
      else {
        $Global:currentJob = Get-Job $jobId
        Initialize-JobEdit
        $Global:menuPositionY = $posY
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
    $Global:currentPrompt = $promptEditJob
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
  $Global:currentPrompt = $promptNewJob
}

function Initialize-JobRemove {
  $Global:subPage = $jobPageRemove
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsY = 0
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
  $Global:currentPrompt = $promptRemoveJob
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
  if ($job.Type -ne $JobTypeQuestTimed) {
    $Global:duration = 1
  }
  else {
    $Global:duration = 0
  }
  $Global:currentPrompt = $promptCompleteJob
}

function Initialize-JobSingle {
  $Global:subPage = $jobPageSingle
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsY = 3
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $true
  $Global:showSelect = $true
  $Global:currentPrompt = ''
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
  }
}

function Read-JobCompleteInputVal {
  $inputVal = $Global:inputValue
  $quit = $false

  # first form step
  if (!$Global:duration) {
    if ($inputVal -eq $false) {
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
    write-debug "read notes input"
    if ($inputVal -eq $false) {
      $quit = $true
    }
    else {
      $Global:notesStepPassed = $true
      $Global:notes = $inputVal
    }
  }

  # confirm step
  else {
    if ($inputVal -eq [System.ConsoleKey]::Escape) {
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
  }
}

function Read-NewJobInputVal {
  $inputVal = $Global:inputValue
  $quit = $false

  if (!$Global:newJobTitle) {
    Write-Debug "reading title input"
    if ($inputVal -eq $false) {
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
      if ($inputVal -eq [System.ConsoleKey]::Escape) {
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
      if ($inputVal -eq $false) {
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
      if ($inputVal -eq [System.ConsoleKey]::Escape `
          -or $inputVal -eq 'n') {
        # Show-JobNewFailed
        $quit = $true
      }
      else {
        $newType = $Global:currentJobType;
        if ($type -eq $JobTypeQuest -and $subType -eq 'Timed') {
          $newType = $JobTypeQuestTimed
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
      if ($inputVal -eq $false) {
        $quit = $true
      }
      elseif (!$inputVal) {
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
      if ($inputVal -eq $false) {
        $quit = $true
      }
      elseif (!$inputVal) {
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

      if (!$quit -and $warn -eq $true) {
        Show-JobRateWarning
      }
      elseif (!$quit) {
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
  }
}
