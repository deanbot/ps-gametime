# set testing data access path
$Global:JobCsvPath = "$pwd\Database\Job-Test.csv"
$Global:TansactionCsvPath = "$pwd\Database\Transaction-Test.csv"
$Global:Debug = "Continue"
$Global:SilentStatusReturn = $true
$ErrorActionPreference = "Stop"

# import game time utilities
Import-Module $pwd\DataAccess.psm1 -Force
Import-Module $pwd\Utilities.psm1 -Force

function Clear-Jobs {
  if (Test-Path $Global:JobCsvPath -PathType Leaf) {
    Remove-Item $Global:JobCsvPath
  }
}

function Clear-Transactions {
  if (Test-Path $Global:TansactionCsvPath -PathType Leaf) {
    Remove-Item $Global:TansactionCsvPath
  }
}

# create Jobs
function Test-1 {
  New-Job "Read" "Quest" .75
  New-Job "Start Bullet Journal" "Rare" 1.5
  New-Job "Meditate twice a day" "Daily" .25
  $jobs = Get-Jobs
  $threeJobsInJobs = $jobs.Length -eq 3

  Write-Host "Test 1. Can create jobs: $($oneJobInJobs -and $threeJobsInJobs)"

  Clear-Jobs
}

# Read jobs
function Test-2 {
  New-Job "Read" "Quest" .75
  New-Job "Start Bullet Journal" "Rare" 1.5

  $Job1 = Get-Job 1
  $Job1TitleSuccess = $Job1.Title -eq "Read"
  $Job2 = Get-Job 2
  $Job2TitleSuccess = $Job2.Title -eq "Start Bullet Journal"

  $missingJobThrowsError = $false
  try {
    Get-Job 3
  }
  catch {
    $missingJobThrowsError = $true
  }

  Write-Host "Test 2. Can read individual jobs: $($Job1TitleSuccess -and $Job2TitleSuccess `
    -and $missingJobThrowsError)"
  Clear-Jobs
}

# Edit jobs
function Test-3 {
  New-Job "Read" "Quest" .75
  New-Job "Start Bullet Journal" "Rare" 1.5

  Edit-Job 1 -Title "Read Non-Fiction"
  Edit-Job 1 -Rate 1
  $Job1 = Get-Job 1
  $canEditJob1 = $Job1.Title -eq "Read Non-Fiction" `
    -and $Job1.Rate -eq 1

  Edit-Job 2 "Write in Bullet Journal" "Daily" .25
  $Job2 = Get-Job 2
  $canEditJob2 = $Job2.Type -eq "Daily" `
    -and $Job2.Rate -eq .25

  $missingJobThrowsError = $false
  try {
    Edit-Job 3 "Read Non-Fiction" "Quest" 1
  }
  catch {
    $missingJobThrowsError = $true
  }

  $invalidTypeThrowsError = $true
  try {
    Edit-Job 1 "Press Snooze" "Obstacle" 1
  }
  catch {
    $invalidTypeThrowsError = $true
  }

  Write-Host "Test 3. Can edit jobs: $($canEditJob1 -and $canEditJob2 -and $missingJobThrowsError -and $invalidTypeThrowsError)"

  Clear-Jobs
}

# Delete jobs
function Test-4 {
  New-Job "Read" "Quest" .75
  New-Job "Start Bullet Journal" "Rare" 1.5
  New-Job "Meditate twice a day" "Daily" .25

  $job1Removed = $false
  Remove-Job 1
  try {
    Get-Job 1
  }
  catch {
    $job1Removed = $true
    $jobs = Get-Jobs
    $job1Removed = $jobs.Length -eq 2
  }

  $missingJobThrowsError = $false
  try {
    Remove-Job 1
  }
  catch {
    $missingJobThrowsError = $true
    $jobs = Get-Jobs
    $missingJobThrowsError = $jobs.Length -eq 2
  }

  Write-Host "Test 4. Can remove jobs: $($job1Removed -and $missingJobThrowsError)"

  Clear-Jobs
}

# Create transactions
function Test-5 {
  New-Job "Read" "Quest" .75
  New-Job "Start Bullet Journal" "Rare" 1.5
  New-Job "Meditate twice a day" "Daily" .25

  $canCreateTransaction = $false
  New-Transaction 1 -Note "Read on train"
  $transactions = Get-Transactions
  $canCreateTransaction = $transactions.Length -eq 1

  New-Transaction 1 -Duration 2
  $transactions = Get-Transactions
  $canCreateTransactions = $transactions.Length -eq 2

  $durationAffectsChange =
  $transactions[0].Change -eq .75 `
    -and $transactions[1].Change -eq 1.5

  $missingJobThrowsError = $false
  try {
    New-Transaction 4
  }
  catch {
    $missingJobThrowsError = $true
  }

  Remove-Job 1
  $transactions = Get-Transactions
  $deletingJobLeavesTransactions = $transactions.Length -eq 2


  Write-Host "Test 4. Can create transactions: $($canCreateTransaction -and $canCreateTransactions -and $durationAffectsChange -and $missingJobThrowsError -and $deletingJobLeavesTransactions)"

  Clear-Jobs
  Clear-Transactions
}

# calculate balance
function Test-6 {
  New-Job "Read" "Quest" .75
  New-Job "Start Bullet Journal" "Rare" 1.5
  New-Job "Meditate twice a day" "Daily" .25

  New-Transaction 1
  New-Transaction 1
  $balanceCalculated = Get-Balance -eq 1.5

  Edit-Job 1 -Rate 1.5
  New-Transaction 1
  $changingJobRateAffectsFutureBalance = Get-Balance -eq 3

  Write-Host "Test 6. Can calculate balance: $($balanceCalculated -and $changingJobRateAffectsFutureBalance)"

  Clear-Jobs
  Clear-Transactions
}

# ========
# Do tests
# ========
Test-1
Test-2
Test-3
Test-4
Test-5
Test-6

# clean up
Clear-Jobs
Clear-Transactions
$Global:JobCsvPath = ""
$Global:TansactionCsvPath = ""
$Global:Debug = ""
$Global:SilentStatusReturn = $false
$ErrorActionPreference = "Continue"