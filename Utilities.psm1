

function Show-Menu {
  Clear-Host
  Write-Host "================ Welcome to Game Time ================"

  Write-Host "1: List all jobs"
  Write-Host "2: Log job completion"
  Write-Host "3: Add job"
  Write-Host "4: Edit job"
  Write-Host "5: Remove job"
  Write-Host "G: Game time"
  Write-Host "Q: Quit"
}

$JobTypeQuest = 'Quest'
$JobTypeDaily = 'Daily'
$JobTypeRare = 'Rare'

function Get-TypeIsValid {
  Param(
    # input type
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Type
  )
  if ($Type -eq $JobTypeQuest `
    -or $Type -eq $JobTypeDaily `
    -or $Type -eq $JobTypeRare) {
    $true
  } else {
    $false
  }
}

function Get-MessageNoJobFound {
  Param(
    [decimal]$JobId
  )
  "No job found for id: $JobId"
}

function Get-MessageInvalidJobType {
  Param(
    [string]$Type
  )
  "Invalid job type: $Type"
}

function Prompt-NewTransaction {

}

function New-Transaction {
  Param(
    # id of job being performed
    [Parameter(Mandatory = $true, Position = 0)]
    [int]
    $JobId,

    # duration (hours) job is performed (for quest type jobs)
    [Parameter(Mandatory = $false, Position = 1)]
    [decimal]
    $Duration = 1,

    # note
    [Parameter(Mandatory = $false, Position = 2)]
    [string]$Note = ""
  )

  $job = Get-JobDb $JobId
  if ($job) {
    $date = Get-Date
    $change = $Duration * $job.Rate
    $log = "$($job.Type)_$($job.Title)_$($job.Rate)_$Duration)"
    $transaction = [PSCustomObject]@{
      Date = $date
      JobId = $job.Id
      Change = $change
      Log = $log
      Note = $Note
    }
    $success = Add-TransactionDb $transaction
    if ($success) {
      Write-Host "Transaction created successfully"
    } else {
      Write-Host "Transaction not created"
    }
  } else {
    Write-Error Get-MessageNoJobFound
  }
}

function Prompt-NewJob {

}

function New-Job {
  Param(
    # title of job
    [Parameter(Mandatory = $true)]
    [string]$Title,

    # job type: Quest, Daily, or Rare
    [Parameter(Mandatory = $true)]
    [string]$Type

    # rate of return (per hour)
    [Parameter(Mandatory = $false)]
    [decimal]$Rate = 1
  )

  # validate
  $valid = $true
  $validType = Get-TypeIsValid $Type
  if (!$validType) {
    $valid = $false
  }

  # create new job
  if ($valid) {
    $job = [PSCustomObject]@{
      Type = $Type
      Title = $Title
      $Rate = $Rate
    }
    $success = Add-JobDb $job
    if ($success) {
      Write-Host "Job created successfully"
    } else {
      Write-Host "Job not created"
    }
  } else {
    Write-Error Get-MessageInvalidJobType
    Write-Host "Job not created"
  }
}

function Prompt-EditJob {

}

function Edit-Job {
  Param(
    # id of job to edit
    [Parameter(Mandatory = $true, Position = 1)]
    [int]$JobId,

    # title of job
    [Parameter(Mandatory = $true)]
    [string]$Title,

    # job type: Quest, Daily, or Rare
    [Parameter(Mandatory = $true)]
    [string]$Type

    # rate of return (per hour)
    [Parameter(Mandatory = $false)]
    [decimal]$Rate = 1
  )

  # validate
  $valid = $true
  $validType = Get-TypeIsValid $Type
  if (!$validType) {
    $valid = $false
  }
  $jobExists = Get-JobDb $JobId
  if (!$jobExists) {
    $valid = $false
  }

  if ($valid) {
    $job = [PSCustomObject]@{
      Type = $Type
      Title = $Title
      Rate = $Rate
    }
    $success = Set-JobDb $JobId $job
    if ($success) {
      Write-Host "Job editted successfully"
    } else {
      Write-Host "Job not editted"
    }
  } else {
    if (!$jobExists) {
      Write-Error Get-MessageNoJobFound
    } elseif (!$validType) {
      Write-Error Get-MessageInvalidJobType
    }
    Write-Host "Job not editted"
  }
}

function Prompt-RemoveJob {

}

function Remove-Job {
  Param(
    # id of job to remove
    [Parameter(Mandatory = $true, Position = 1)]
    [int]
    $JobId
  )

  $success = Remove-JobDb $JobId
  if ($success) {
    Write-Host "Job removed successfully."
  } else {
    Write-Error Get-MessageNoJobFound
  }
}

