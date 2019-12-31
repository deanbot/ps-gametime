if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
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
  }
  else {
    $false
  }
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

function Get-Jobs {
  return Get-JobsDb
}

function Get-Transactions {
  Get-TransactionsDb
}

function Get-Balance {
  $transactions = Get-Transactions
  $balance = $transactions | Select-Object Change, @{Name = "CastedChange"; Expression = { [decimal]$_.Change } } | Measure-Object CastedChange -Sum
  $balance.Sum
}

function Get-AvailableBalance {
  $balance = Get-Balance
  [Math]::Floor([decimal]($balance))
}

function Get-Job {
  Param(
    # id of job to get
    [Parameter(Mandatory = $true, Position = 0)]
    [int]$JobId
  )
  $Job = Get-JobDb $JobId
  if ($Job) {
    $Job
  }
  else {
    Throw $(Get-MessageNoJobFound $JobId)
    if (!$Global:SilentStatusReturn) {
      $false
    }
  }
}


function New-Job {
  Param(
    # title of job
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Title,

    # job type: Quest, Daily, or Rare
    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Type,

    # rate of return (per hour)
    [Parameter(Mandatory = $false, Position = 2)]
    [decimal]$Rate = 1
  )

  # normalize
  if ($Rate -eq "") {
    $Rate = 1
  }

  # validate
  $valid = $true
  $validType = Get-TypeIsValid $Type
  if (!$validType) {
    $valid = $false
  }

  # create new job
  if ($valid) {
    $job = [PSCustomObject]@{
      Type  = $Type
      Id    = 0
      Title = $Title
      Rate  = [decimal]$Rate
    }
    $success = Add-JobDb $job
    if ($success) {
      Write-Debug "Job created successfully."
    }
    else {
      Write-Debug "Job not created."
    }
    if (!$Global:SilentStatusReturn) {
      return $success
    }
  }
  else {
    Throw $(Get-MessageInvalidJobType $Type)
    Write-Debug "Job not created."
    if (!$Global:SilentStatusReturn) {
      return $false
    }
  }
}


function Edit-Job {
  Param(
    # id of job to edit
    [Parameter(Mandatory = $true, Position = 0)]
    [int]$JobId,

    # title of job
    [Parameter(Mandatory = $false, Position = 1)]
    [string]$Title,

    # job type: Quest, Daily, or Rare
    [Parameter(Mandatory = $false, Position = 2)]
    [string]$Type,

    # rate of return (per hour)
    [Parameter(Mandatory = $false, Position = 3)]
    [decimal]$Rate = 1
  )

  # validate
  $valid = $true
  if ($Type) {
    $validType = Get-TypeIsValid $Type
    if (!$validType) {
      $valid = $false
    }
  }
  $previousJob = Get-JobDb $JobId
  if (!$previousJob) {
    $valid = $false
  }

  if ($valid) {
    $job = [PSCustomObject]@{
      Type  = if ($Type) { $Type } else { $previousJob.Type }
      Id    = $JobId
      Title = if ($Title) { $Title } else { $previousJob.Title }
      Rate  = if ($Rate) { $Rate } else { $previousJob.Rate }
    }
    $success = Set-JobDb $JobId $job
    if ($success) {
      Write-Debug "Job editted successfully."
    }
    else {
      Write-Debug "Job not editted."
    }
    if (!$Global:SilentStatusReturn) {
      return $success
    }
  }
  else {
    if (!$jobExists) {
      Throw $(Get-MessageNoJobFound $JobId)
    }
    elseif (!$validType) {
      Throw $(Get-MessageInvalidJobType $Type)
    }
    Write-Debug "Job not editted."
    if (!$Global:SilentStatusReturn) {
      return $false
    }
  }
}

function Remove-Job {
  Param(
    # id of job to remove
    [Parameter(Mandatory = $true, Position = 0)]
    [int]$JobId
  )

  $success = Remove-JobDb $JobId
  if ($success) {
    Write-Debug "Job removed successfully."
  }
  else {
    Throw $(Get-MessageNoJobFound $JobId)
  }
  if (!$Global:SilentStatusReturn) {
    $success
  }
}


function New-Transaction {
  Param(
    # id of job being performed. use -1 to deduct from balance instead
    [Parameter(Mandatory = $true, Position = 0)]
    [int]$JobId,

    # duration (hours) job is performed (for quest type jobs)
    [Parameter(Mandatory = $false, Position = 1)]
    $Degree = 1,

    # note
    [Parameter(Mandatory = $false, Position = 2)]
    [string]$Note = ""
  )

  if ($JobId -eq -1) {
    $TransactionDegree = [int]$Degree
    return New-DeductTransaction $TransactionDegree $Note
  }
  else {
    $TransactionDegree = [decimal]$Degree
    return New-JobTransaction $JobId $TransactionDegree $Note
  }
}

function New-JobTransaction {
  Param(
    # id of job being performed. use -1 to deduct from balance instead
    [Parameter(Mandatory = $true, Position = 0)]
    [int]$JobId,

    # duration (hours) job is performed (for quest type jobs)
    [Parameter(Mandatory = $false, Position = 1)]
    [decimal]$Degree = 1,

    # note
    [Parameter(Mandatory = $false, Position = 2)]
    [string]$Note = ""
  )

  $valid = $true
  $job = Get-JobDb $JobId
  if (!$job) {
    $valid = $false
  }
  $isDaily = $job.Type -eq $JobTypeDaily
  $isRare = $job.Type -eq $JobTypeRare
  $dailyJobAlreadyAdded = $false
  $date = Get-Date -format 'MM/dd/yyyy'
  if ($isDaily) {
    # check transactions for same day same job id
    $transactions = Get-TransactionsDb
    $foundTransaction = $transactions | Where-Object { $_.Date -eq $Date }
    if ($foundTransaction) {
      $dailyJobAlreadyAdded = $true
    }
  }

  if ($valid) {
    $change = $Degree * $job.Rate
    $log = Get-MessageTransactionLog -JobType $job.Type -JobTitle $job.Title -JobRate $job.Rate -Degree $Degree
    $transaction = [PSCustomObject]@{
      Date   = $date
      JobId  = $JobId
      Change = $change
      Log    = $log
      Note   = $Note
    }
    $success = Add-TransactionDb $transaction
    if ($success) {
      Write-Debug "Transaction created successfully."
      if ($isRare) {
        $removeJobSuccess = Remove-Job $JobId
        if ($removeJobSuccess) {
          Write-Debug "Rare job removed successfully."
        }
        else {
          Write-Debug "Rare job not removed"
        }
      }
    }
    else {
      Write-Debug "Transaction not created."
    }
    if (!$Global:SilentStatusReturn) {
      if ($isRare -and $success) {
        if ($removeJobSuccess) {
          return $transaction
        }
        else {
          return $false
        }
      }
      elseif ($success) {
        return $transaction
      }
      else {
        return $false
      }
    }
  }
  else {
    if (!$job) {
      Throw $(Get-MessageNoJobFound $JobId)
    }
    elseif ($dailyJobAlreadyAdded) {
      Throw "Daily transaction already created for date: $date"
    }
    Write-Debug "Transaction not created."
    if (!$Global:SilentStatusReturn) {
      return $false
    }
  }
}

function New-DeductTransaction {
  param(
    # amount of game time points to use
    [Parameter(Mandatory = $true, Position = 0)]
    [int]$Degree,

    # note
    [Parameter(Mandatory = $false, Position = 1)]
    [string]$Note = ""
  )

  $available = Get-AvailableBalance
  if ($Degree -lt 1) {
    throw "Must spend at least one point"
  }
  elseif ($Degree -gt $available) {
    throw $(Get-MessageTooFewPoints $available)
  }
  else {
    $date = Get-Date -format 'MM/dd/yyyy'
    $log = Get-MessageDeductTransactionLog $Degree
    $transaction = [PSCustomObject]@{
      Date   = $date
      JobId  = -1
      Change = ($Degree * -1)
      Log    = $log
      Note   = $Note
    }
    $success = Add-TransactionDb $transaction
    if ($success) {
      Write-Debug "Transaction created successfully."
    }
    else {
      Write-Debug "Transaction not created."
    }
    if (!$Global:SilentStatusReturn) {
      if ($success) {
        return $transaction
      }
      else {
        return $false
      }

    }
  }
}