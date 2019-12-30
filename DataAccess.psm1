# ============
# Data Access Layer
# ============

function Get-JobCsvPath {
  if ($Global:JobCsvPath) {
    $Global:JobCsvPath
  } else {
    "$pwd\Database\Job.csv"
  }
}

function Get-TransactionCsvPath {
  if ($Global:TansactionCsvPath) {
    $Global:TansactionCsvPath
  } else {
    "$pwd\Database\Transaction.csv"
  }
}

# create jobs csv if not exists
function Initialize-JobsDb {
  $csvFile = Get-JobCsvPath
  $exists = Test-Path $csvFile -PathType Leaf
  if (!$exists) {
    $headers = "Type", "Id", "Title", "Rate"
    $psObject = New-Object psobject
    foreach ($header in $headers) {
      Add-Member -InputObject $psobject -MemberType noteproperty `
        -Name $header -Value ""
    }
    $psObject | Export-Csv $csvfile -NoTypeInformation
  }
}

# create transactions csv if not exits
function Initialize-TransactionsDb {
  $csvFile = Get-TransactionCsvPath
  $exists = Test-Path $csvFile -PathType Leaf
  if (!$exists) {
    $headers = "Date", "JobId", "Change", "Log", "Note"
    $psObject = New-Object psobject
    foreach ($header in $headers) {
      Add-Member -InputObject $psobject -MemberType noteproperty `
        -Name $header -Value ""
    }
    $psObject | Export-Csv $csvfile -NoTypeInformation
  }
}

# get all jobs from db
function Get-JobsDb {
  Initialize-JobsDb
  $csvFile = Get-JobCsvPath
  Import-Csv $csvFile -Header Type, Id, Title, Rate
}

# set all jobs in db
function Set-JobsDb {
  param (
    # array of jobs
    [Parameter(Mandatory = $true, Position = 0)]
    [array]
    $Jobs
  )
  Initialize-JobsDb
  $csvFile = Get-JobCsvPath
  $Jobs | Export-Csv $csvFile -NoTypeInformation -Force
}

# append job to jobs db
function Add-JobDb {
  Param(
    # new job
    [Parameter(Mandatory = $true, Position = 0)]
    [hashtable]$Job
  )
  $csvFile = Get-JobCsvPath
  $Job | Export-Csv $csvFile -NoTypeInformation -Force -Append
}

function Set-JobDb {
  Param(
    # id of job to edit
    [Parameter(Mandatory = $true, Position = 0)]
    [int]$JobId,

    # new job
    [Parameter(Mandatory = $true, Position = 1)]
    [hashtable]$Job
  )
  Initialize-JobsDb

  $jobFound = $false
  $jobs = Get-JobsDb | ForEach {
    if ($_.Id -eq $JobId) {
      $jobFound = $true
      $_.Type = $Job.Type
      $_.Title = $Job.Title
      $_.Rate = $Job.Rate
    }
    $_
  }

  # set jobs and return success
  if ($jobFound) {
    Write-Host "New jobs:"
    Write-Host $jobs
    Write-Host "does this look right? if so uncomment set jobs db"
    # Set-JobsDb $jobs
    $true
  } else {
    $false
  }
}

function Get-JobDb {
  Param(
    # id of job to get
    [Parameter(Mandatory = $true, Position = 0)]
    [int]$JobId
  )
  Initialize-JobsDb

  $job = Get-JobsDb | Where{$_.Id -eq $JobId}

  # return job or failure
  if ($job) {
    $job
  } else {
    $false
  }
}

function Remove-JobDb {
  Param(
    # id of job to remove
    [Parameter(Mandatory = $true, Position = 0)]
    [int]$JobId
  )
  Initialize-JobsDb

  # build new jobs array without specified job
  $jobFound = $false
  $jobs = Get-JobsDb | ForEach {
    if ($_.Id -ne $JobId){
      $_
    } else {
      $jobFound = $true
    }
  }

  # foreach ($job in $jobs) {
  #   if ($job.Id -ne $JobId) {
  #     $newJobs += $job
  #   } else {
  #     $jobFound = $true
  #   }
  # }

  # set jobs and return success
  if ($jobFound) {
    Write-Host "New jobs:"
    Write-Host $jobs
    Write-Host "does this look right? if so uncomment set jobs db"
    # Set-JobsDb $jobs
    $true
  } else {
    $false
  }
}

function Add-TransactionDb {
  Param(
    # transaction
    [Parameter(Mandatory = $true, Position = 0)]
    [hashtable]$Transaction
  )
}