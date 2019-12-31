function Show-Menu {
  Clear-Host
  Write-Host "================ Welcome to Game Time ================"

  Write-Host "1: List all jobs"
  Write-Host "2: Log job completion"
  Write-Host "3: Add job"
  # Write-Host "4: Edit job"
  # Write-Host "5: Remove job"
  Write-Host "B: Balance"
  Write-Host "G: Spend Game Time points"
  Write-Host "Q: Quit"
}


function Show-PromptNewJob {
  Write-Host "================ Create Job ================"
  Write-Host "Follow prompts (at any time enter Q to Quit)."

  # get title
  Write-Host
  do {
    $Title = Read-Host "Enter Job Title"
  }
  until ($Title -eq 'q' -or $Title -ne '')
  if ($Title -eq 'q') {
    return
  }

  # get type
  Write-Host ""
  Write-Host "Enter Job Type"
  Write-Host "1: Quest (can complete multiple times per day or for an amount of time)"
  Write-Host "2: Daily (can complete once a day)"
  Write-Host "3: Rare (can complete once)"
  do {
    $Type = Read-Host "Please make a selection"
  }
  until ($Type -eq 'q' `
      -or $Type -eq 1 `
      -or $Type -eq 2 `
      -or $Type -eq 3)
  if ($Type -eq 'q') {
    return
  }
  elseif ($Type -eq 1) {
    $Type = 'Quest'
  }
  elseif ($Type -eq 2) {
    $Type = 'Daily'
  }
  elseif ($Type -eq 3) {
    $Type = 'Rare'
  }

  # get rate
  Write-Host ""
  do {
    $Rate = Read-Host "Enter Job Rate (amount returned for completion or per hour)"
  }
  until ($Rate -eq 'q' `
      -or $Rate -eq '' `
      -or [decimal]$Rate -is [decimal] `
  )
  if ($Rate -eq 'q') {
    return
  }

  Write-Host ""

  $success = New-Job $Title $Type $Rate
  if ($success) {
    Write-Host "Job created successfully."
  }
  else {
    Write-Host "Job not created."
  }
}


function Show-PromptEditJob {

}

function Show-PromptRemoveJob {

}

function Show-PromptNewTransaction {
  do {
    Clear-Host
    Write-Host "================ Log Job Completion ================"
    Write-Host "Follow prompts (at any time enter L to list Jobs or Q to Quit)."
    if ($JobId -eq 'l') {
      Get-Jobs | Format-Table
    }
    else {
      Write-Host ""
    }
    $JobId = Read-Host "Select Job by Id"
  }
  until(
    $JobId -ne 'l' `
      -or $JobId -eq 'q'
  )
  if ($JobId -eq 'q') {
    return;
  }

  $valid = $true
  if (!$JobId) {
    $valid = $false
  }
  else {
    try {
      $JobId = [int]$JobId
    }
    catch {
      $valid = $false
    }
  }
  if (!$valid) {
    Write-Host "Enter a valid job id."
    return;
  }

  $job = Get-Job $JobId
  if ($job) {
    $job | Format-Table
    if ($job.Type -eq 'Quest') {
      $isDecimal = $false
      do {
        $Degree = Read-Host "Enter Duration (in hours, i.e. 1 or .75)"
        try {
          $test = [decimal]$Degree
          $isDecimal = $test -is [decimal]
        }
        catch {
          Write-Host "Enter a valid duration"
        }
      } until (
        $isDecimal -or $Degree -eq 'q'
      )
    }
    else {
      $Duration = 1
    }
    if ($Duration -eq 'q') {
      return
    }
    $Note = Read-Host 'Enter note (optional)'

    $confirm = Read-Host "Are you sure (y/Y)"
    if ($confirm -eq 'y') {
      try {
        $transaction = New-Transaction $JobId -Degree $Degree -Note $Note
      }
      catch {
        Write-Host "An error occurred:"
        Write-Host $_
      }
      if ($transaction) {
        Write-Host "Success!"
        Write-Host $($transaction.Log)
      }
    }
    else {
      Write-Host "Job completion not logged."
    }
  }
  else {
    Write-Host "Job not found"
  }
}

function Show-PromptGameTime {
  Clear-Host
  Write-Host "================ Spend Game Time Points ================"
  Write-Host "Follow prompts (at any time enter Q to Quit)."
  Write-Host ""

  $available = Get-AvailableBalance
  Write-Host "Balance $(Get-Balance) | Available Balance $Available"
  WRite-Host "1 point = 20 minutes of gaming"
  WRite-Host ""

  if ($available -ge 1) {
    do {
      $spend = Read-Host "Points to spend "
      $isInt = $false
      $isAvailable = $false
      try {
        $val = [int32]$spend
        $isInt = $val -is [int32]
      }
      catch {
      }
      if ($isInt) {
        $isAvailable = $val -le $available
        if (!$isAvailable) {
          Write-Host "Spend from your available balance (available: $available)"
        }
      }
      else {
        Write-host "Enter valid point value. Points must be a whole number (i.e. 1 or 2)."
        Write-host ""
      }
    }
    until (
      $spend -eq 'q' `
        -or ($isInt -and - $isAvailable)
    )
    if ($spend -ne 'q') {
      Write-host ""
      $Note = Read-Host 'Enter note (optional)'
      Write-host ""

      $confirm = Read-Host "Are you sure (y/Y)"
      if ($confirm -eq 'y') {
        try {
          $transaction = New-Transaction -1 -Degree $spend -Note $Note
        }
        catch {
          Write-Host "An error occurred:"
          Write-Host $_
        }
        if ($transaction) {
          Write-Host "Success!"
          Write-Host $($transaction.Log)
        }
      }
      else {
        Write-Host "Points not spent"
      }
    }
  }
  else {
    Write-Host "No available balance to spend."
  }
}