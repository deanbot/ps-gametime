if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

function Get-Jobs {
  return Get-JobsDb
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
    [decimal]$Rate
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