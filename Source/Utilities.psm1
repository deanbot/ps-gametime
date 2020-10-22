if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

$JobTypeQuest = 'Quest'
$JobTypeQuestTimed = 'Quest-Timed'
$JobTypeDaily = 'Daily'
$JobTypeRare = 'Rare'

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

function Get-Logs {
  $logs = (Get-TransactionsDb)
  $logs
}

function Get-TypeIsValid {
  Param(
    # input type
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Type
  )
  if ($Type -eq $JobTypeQuest `
      -or $Type -eq $JobTypeQuestTimed `
      -or $Type -eq $JobTypeDaily `
      -or $Type -eq $JobTypeRare) {
    $true
  }
  else {
    $false
  }
}

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

function Get-MessageNoJobFound {
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [decimal]$JobId
  )
  "No job found for id: $JobId."
}

function Get-MessageInvalidJobType {
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Type
  )
  "Invalid job type: $Type."
}

function Get-MessageTooFewPoints {
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [int]$Available
  )
  "Not enough game time points (available balance: $Available)"
}

function Get-MessageDeductTransactionLog {
  param(
    # degree of transaction
    [Parameter(Mandatory = $true, Position = 0)]
    [decimal]$Degree
  )
  "Spent $Degree Game Time points for a total of $($Degree * 20) minutes of gaming."
}

function Get-MessageTransactionLog {
  param(
    # type of job
    [Parameter(Mandatory = $false)]
    [string]$JobType = "",

    # title of job
    [Parameter(Mandatory = $false)]
    [string]$JobTitle = "",

    # rate of job
    [Parameter(Mandatory = $false)]
    [decimal]$JobRate,

    # degree of transaction
    [Parameter(Mandatory = $false)]
    [decimal]$Degree = 1
  )

  $message = ""
  $value = $Degree * $JobRate
  switch ($JobType) {
    'Quest' {
      $message = "Completed Quest, '$JobTitle', for $Degree hours. Awarded $value points (rated at $JobRate per hour)."
    } 'Daily' {
      $message = "Completed Daily Quest, '$JobTitle'. Awarded $value points."
    } 'Rare' {
      $message = "Completed Rare Quest, '$JobTitle'. Awarded $value points."
    }
  }
  $message
}

function Get-HasPromptInput {
  if ($Global:currentPrompt -ne '') {
    $true
  }
  $false
}
