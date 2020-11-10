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

function Get-Transactions {
  Get-TransactionsDb
}

function Get-Balance {
  $transactions = Get-Transactions
  $balance = $transactions | Select-Object Change, @{Name = "CastedChange"; Expression = { [decimal]$_.Change } } | Measure-Object CastedChange -Sum
  if ($balance.Sum) {
    $balance.Sum
  }
  else {
    0
  }
}

function Get-AvailableBalance {
  $balance = Get-Balance
  [Math]::Floor([decimal]($balance))
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

    # todo move degree to 3rd param
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
  $date = Get-Date -format 'yyyyMMddTHHmmssffff'
  if ($isDaily) {
    # check transactions for same day same job id
    $transactions = Get-TransactionsDb
    $foundTransaction = $transactions | Where-Object { $_.Date -eq $date -and $_.JobId -eq $JobId }
    if ($foundTransaction) {
      $dailyJobAlreadyAdded = $true
      $valid = $false
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
    $date = Get-Date -format 'yyyyMMddTHHmmssffff'
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

function Set-Transaction {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Transaction
  )
  Set-TransactionDb $Transaction
}
