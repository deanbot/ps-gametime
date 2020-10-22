if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

# constants
$sectionLogsMenu = 'Logs'
$logsPerPage = 5

function Initialize-LogsMenu {
  $Global:section = $sectionLogsMenu
  $Global:subPage = ''
  $Global:menuPositionX = 0
  $Global:menuPositionY = 0
  $Global:maxMenuPositionsY = 0
  $Global:canChangeMenuPositionY = $false
  $Global:showReturn = $true
  $Global:showSelect = $false
  $Global:logs = Get-Logs
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
  $logs = $Global:logs
  $numPages = 0
  if ($logs) {
    $logCount = @($logs).Length
    $numPages = [math]::ceiling($logCount / $logsPerPage)
  }
  $numPages
}

function Get-CurrentLogs {
  $logs = $Global:logs
  $currentLogs = @()
  if ($logs) {
    # get page of logs
    $logCount = @($logs).Length
    $page = $Global:menuPositionX
    $logStart = $page * $logsPerPage
    $logEnd = $logCount
    if ($logStart + $logsPerPage -le $logCount) {
      $logEnd = $logStart + $logsPerPage
    }
    $currentLogs = $logs[$logStart..$logEnd]
  }
  return $currentLogs
}

function Initialize-LogsPage {
  $currentLogs = Get-CurrentLogs
  $Global:currentLogs = $currentLogs
  if ($currentLogs) {
    $currentLogCount = @($currentLogs).Length
    $Global:maxMenuPositionsY = $currentLogCount

    # allow vertical nav if multiple logs
    $Global:canChangeMenuPositionY = $currentLogCount -gt 1
    $Global:showSelect = $currentLogCount -gt 0
  }
}
