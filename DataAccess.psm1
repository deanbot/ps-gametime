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
    if ($Global:SessionName) {
      $filename = "Job-$($Global:SessionName).csv"
    }
    else {
      $filename = "Job.csv"
    }
    if ($Global:StorageLocation) {
      $path = $Global:StorageLocation
      if ($path[$path.Length - 1] -ne "\") {
        $path = "$path\"
      }
    }
    else {
      $path = "$Global:ScriptRoot\Database\"
    }
    return "$path$filename"
  }
}

function Get-TransactionCsvPath {
  if ($Global:TansactionCsvPath) {
    return $Global:TansactionCsvPath
  }
  else {
    if ($Global:SessionName) {
      $filename = "Transaction-$($Global:SessionName).csv"
    }
    else {
      $filename = "Transaction.csv"
    }
    if ($Global:StorageLocation) {
      $path = $Global:StorageLocation
      if ($path[$path.Length - 1] -ne "\") {
        $path = "$path\"
      }
    }
    else {
      $path = "$Global:ScriptRoot\Database\"
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
        Id    = [int]$job.Id
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
    [array]
    $Jobs
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

  # get next id for job
  [int]$newId = 0;
  $Jobs = Get-JobsDb
  if ($Jobs.Length -gt 0) {
    foreach ($_job in $Jobs) {
      $id = $_job.Id
      if ($id -gt $newId) {
        $newId = $id
      }
    }
  }

  # set job id
  $newId++
  $Job.Id = ($newId)

  # add to csv
  $csvFile = Get-JobCsvPath
  $Job | Export-Csv $csvFile -NoTypeInformation -Append -Force
  $newId
}

function Set-JobDb {
  Param(
    # id of job to edit
    [Parameter(Mandatory = $true, Position = 0)]
    [int]$JobId,

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
    [int]$JobId
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
    [int]$JobId
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
    Set-JobsDb $jobs
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
      $transactions += [PSCustomObject]@{
        Date   = $item.Date
        JobId  = [int]$item.JobId
        Change = [decimal]$item.Change
        Log    = $item.Log
        Note   = $item.Note
      }
    }
  }
  return , $transactions
}

function Add-TransactionDb {
  Param(
    # transaction
    [Parameter(Mandatory = $true, Position = 0)]
    $Transaction
  )
  $csvFile = Get-TransactionCsvPath
  Initialize-Path $csvFile
  $Transaction | Export-Csv $csvFile -NoTypeInformation -Force -Append
  $true
}