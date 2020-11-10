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
  "No $Label_Single_Quest_Lower found for id: $JobId."
}

function Get-MessageInvalidJobType {
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Type
  )
  "Invalid $Label_Single_Quest_Lower type: $Type."
}

function Get-MessageTooFewPoints {
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [int]$Available
  )
  "Not enough Game Time points (available balance: $Available)"
}

function Get-MessageDeductTransactionLog {
  param(
    # degree of transaction
    [Parameter(Mandatory = $true, Position = 0)]
    [decimal]$Degree
  )
  if ($Degree -ne 1) {
    $unit = "points"
  } else {
    $unit = "point"
  }
  "Exchanged $Degree $unit for $($Degree * 20) minutes of gaming time."
}

function Get-MessageTransactionLog {
  param(
    # type of $Label_Single_Quest_Lower
    [Parameter(Mandatory = $false)]
    [string]$JobType = "",

    # title of $Label_Single_Quest_Lower
    [Parameter(Mandatory = $false)]
    [string]$JobTitle = "",

    # rate of $Label_Single_Quest_Lower
    [Parameter(Mandatory = $false)]
    [decimal]$JobRate,

    # degree of transaction
    [Parameter(Mandatory = $false)]
    [decimal]$Degree = 1
  )

  $message = ""
  # $value = $Degree * $JobRate
  switch ($JobType) {
    'Quest-Timed' {
      $message = "Completed '$JobTitle' for $Degree hours."
    } 'Daily' {
      $message = "Completed (Daily) '$JobTitle'."
    } 'Rare' {
      $message = "Completed (Rare) '$JobTitle'."
    } default {
      $message = "Completed '$JobTitle'."
    }
  }
  $message
}

function Get-FormattedDate {
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    $DateStamp
  )
  try {
    $Date = [datetime]::ParseExact($DateStamp, 'yyyyMMddTHHmmssffff', $null)
    $formattedDate = '{0:MM/dd/yyyy}' -f $date
  } catch {}
  $formattedDate
}
