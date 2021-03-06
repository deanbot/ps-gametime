# ============
# Data Access Layer
# ============

if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

function Get-JobCsvPath {
  if ($Global:JobCsvPath) {
    return $Global:JobCsvPath
  }
  else {
    $filename = "Job.csv"
    if ($Global:StorageLocation) {
      $path = $Global:StorageLocation
      if ($path[$path.Length - 1] -ne "\") {
        $path = "$path\"
      }
    }
    else {
      $path = "$Global:ScriptRoot\..\Database\"
    }
    return "$path$filename"
  }
}

function Get-TransactionCsvPath {
  if ($Global:TansactionCsvPath) {
    return $Global:TansactionCsvPath
  }
  else {
    $filename = "Transaction.csv"
    if ($Global:StorageLocation) {
      $path = $Global:StorageLocation
      if ($path[$path.Length - 1] -ne "\") {
        $path = "$path\"
      }
    }
    else {
      $path = "$Global:ScriptRoot\..\Database\"
    }
    return "$path$filename"
  }
}

function Initialize-Path {
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$filename
  )

  $path = $filename.split('\')
  $path = $path[$path.Length - 1]
  $path = $filename.SubString(0, $filename.IndexOf($path) - 1 )
  if (!(Test-Path $path -PathType Container)) {
    New-Item -Type directory $path
  }
}

function Remove-TransationsDb {
  $path = Get-TransactionCsvPath
  if (Test-Path $path -PathType Leaf) {
    Remove-Item $path
  }
}

function Remove-JobsDb {
  $path = Get-JobCsvPath
  if (Test-Path $path -PathType Leaf) {
    Remove-Item $path
  }
}

# get all jobs from db
function Get-JobsDb {
  $csvFile = Get-JobCsvPath
  Initialize-Path $csvFile
  $jobs = @()
  if (Test-Path $csvFile -PathType Leaf) {
    $imported = Import-Csv $csvFile
    foreach ($job in $imported) {
      $jobs += [PSCustomObject]@{
        Type  = $job.Type
        Id    = $job.Id
        Title = $job.Title
        Rate  = [decimal]$job.Rate
      }
    }
  }
  if ($jobs) {
    return @($jobs)
  }
  else {
    $jobs
  }
}

# set all jobs in db
function Set-JobsDb {
  param (
    # array of jobs
    [Parameter(Mandatory = $true, Position = 0)]
    [array]$Jobs
  )
  $csvFile = Get-JobCsvPath
  Initialize-Path $csvFile
  $Jobs | Export-Csv $csvFile -NoTypeInformation -Force
  $true
}

# append job to jobs db
function Add-JobDb {
  Param(
    # new job
    [Parameter(Mandatory = $true, Position = 0)]
    $Job
  )

  $Job.Id = Get-Date -format 'yyMMddTHHmmss'

  # add to csv
  $csvFile = Get-JobCsvPath
  $Job | Export-Csv $csvFile -NoTypeInformation -Append -Force
  $Job.Id
}

function Set-JobDb {
  Param(
    # id of job to edit
    [Parameter(Mandatory = $true, Position = 0)]
    $JobId,

    # new job
    [Parameter(Mandatory = $true, Position = 1)]
    $Job
  )

  $jobFound = $false
  $jobs = Get-JobsDb
  foreach ($_job in $jobs) {
    if ($_job.Id -eq $JobId) {
      $jobFound = $true
      $_job.Type = $Job.Type
      $_job.Title = $Job.Title
      $_job.Rate = $Job.Rate
    }
  }

  # set jobs and return success
  if ($jobFound) {
    Set-JobsDb $jobs
    $true
  }
  else {
    $false
  }
}

function Get-JobDb {
  Param(
    # id of job to get
    [Parameter(Mandatory = $true, Position = 0)]
    $JobId
  )

  $Jobs = Get-JobsDb
  $job = $Jobs | Where-Object { $_.Id -eq $JobId }

  # return job or failure
  if ($job) {
    $job
  }
  else {
    $false
  }
}

function Remove-JobDb {
  Param(
    # id of job to remove
    [Parameter(Mandatory = $true, Position = 0)]
    $JobId
  )

  # build new jobs array without specified job
  $jobFound = $false
  $prevJobs = Get-JobsDb
  $jobs = @()
  foreach ($job in $prevJobs) {
    if ($job.Id -ne $JobId) {
      $jobs += $job
    }
    else {
      $jobFound = $true
    }
  }

  # set jobs and return success
  if ($jobFound) {
    if ($jobs.Length -ne 0) {
      Set-JobsDb $jobs
    } else {
      Remove-JobsDb
    }
    $true
  }
  else {
    $false
  }
}

function Get-TransactionsDb {
  $csvFile = Get-TransactionCsvPath
  Initialize-Path $csvFile
  $transactions = @()
  if (Test-Path $csvFile -PathType Leaf) {
    foreach ($item in Import-Csv $csvFile) {
      $obj = [PSCustomObject]@{
        Date = $item.Date
        JobId  = $item.JobId
        Change = [decimal]$item.Change
        Log    = $item.Log
        Note   = $item.Note
      }
      $transactions += $obj
    }
  }

  # Sort by date value descending
  $transactions = $transactions | Sort-Object @{Expression = {
    $_.Date
  }; Ascending = $false }

  return , $transactions
}

function Set-TransactionsDb {
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [array]
    $Transactions
  )
  $csvFile = Get-TransactionCsvPath
  Initialize-Path $csvFile
  $Transactions | Export-Csv $csvFile -NoTypeInformation -Force
  $true
}

function Add-TransactionDb {
  Param(
    # transaction
    [Parameter(Mandatory = $true, Position = 0)]
    $Transaction
  )
  $csvFile = Get-TransactionCsvPath
  Initialize-Path $csvFile

  $jobId = $Transaction.JobId
  $job = Get-JobDb $jobId
  if ($job.Type -eq $JobTypeDaily) {
    # check transactions for same day same job id
    $today = Get-Date -format 'yyyyMMdd'
    $transactions = Get-TransactionsDb
    $foundTransaction = $transactions | Where-Object { $_.Date.ToString().SubString(0, 8) -eq $today -and $_.JobId -eq $jobId }
    if ($foundTransaction) {
      Throw "Daily transaction already created for $($job.Title)"
      return $false
    }
  }

  $Transaction | Export-Csv $csvFile -NoTypeInformation -Force -Append
  $true
}

function Set-TransactionDb {
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    $Item
  )
  $log = $Item
  $transactionFound = $false
  $transactions = Get-TransactionsDb
  foreach ($_transaction in $transactions) {
    if ($_transaction.Date -eq $log.Date) {
      $transactionFound = $true
      $_transaction.JobId = $log.JobId
      $_transaction.Log = $log.Log
      $_transaction.Note = $log.Note
      $_transaction.Change = $log.Change
    }
  }

  if ($transactionFound) {
    Set-TransactionsDb $transactions
    $true
  }
  else {
    # write-host "transaction not found"
    $false
  }
}
