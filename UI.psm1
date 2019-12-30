function Show-Menu {
  Clear-Host
  Write-Host "================ Welcome to Game Time ================"

  Write-Host "1: List all jobs"
  Write-Host "2: Log job completion"
  Write-Host "3: Add job"
  # Write-Host "4: Edit job"
  # Write-Host "5: Remove job"
  Write-Host "B: Balance"
  Write-Host "G: Game time"
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
  Clear-Host
  Write-Host "================ Log Job Completion ================"

  Write-Host ''
}