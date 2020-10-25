if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

# constants
$sectionLogsMenu = 'Logs'
$logPageSingle = 'Single'
$logsPerPage = 5 # todo why is it showing 6?

function Get-CurrentTransactions {
  $transactions = $Global:transactions
  $page = $Global:menuPositionX
  $currentTransactions = Get-Page $transactions $page $logsPerPage
  return $currentTransactions
}

function Get-CurrentTransaction {
  $pos = $Global:menuPositionY
  $logs = $Global:currentTransactions
  if ($logs -and $logs.Length -ge ($pos - 1) ) {
    return $logs[$pos]
  }
  return $false
}

function Initialize-LogsMenu {
  param(
    [Parameter(Mandatory = $false, Position = 0)]
    [int32]$menuPositionX = 0
  )
  $Global:section = $sectionLogsMenu
  $Global:subPage = ''
  $Global:menuPositionX = menuPositionX
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsY = 0
  $Global:canChangeMenuPositionY = $false
  $Global:showReturn = $true
  $Global:showSelect = $false
  $Global:transactions = Get-Transactions
  $numPages = Get-NumLogPages
  $Global:maxMenuPositionsX = $numPages
  if ($numPages -gt 0) {
    $Global:canChangeMenuPositionX = $true
  } else {
    $Global:canChangeMenuPositionX = $false
  }
  Initialize-LogsPage
}

function Get-NumLogPages {
  $logs = $Global:transactions
  $numPages = 0
  if ($logs) {
    $logCount = @($logs).Length
    $numPages = [math]::ceiling($logCount / $logsPerPage)
  }
  $numPages
}

function Initialize-LogsPage {
  $currentLogs = Get-CurrentTransactions
  $Global:currentTransactions = $currentLogs
  if ($currentLogs) {
    $currentLogCount = @($currentLogs).Length
    $Global:maxMenuPositionsY = $currentLogCount

    # allow vertical nav if multiple logs
    $Global:canChangeMenuPositionY = $currentLogCount -gt 1
    $Global:showSelect = $currentLogCount -gt 0
  }
}

function Initialize-LogSingle {
  $Global:subPage = $logPageSingle
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsY = 0
  $Global:canChangeMenuPositionX = $false
  $Global:canChangeMenuPositionY = $false
  $Global:showSelect = $false
}
