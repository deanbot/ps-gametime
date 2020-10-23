if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

function Get-HasPromptInput {
  if ($Global:currentPrompt -ne '') {
    $true
  }
  $false
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
