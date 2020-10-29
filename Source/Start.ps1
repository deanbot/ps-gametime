# ascii logo via http://patorjk.com/software/taag/
param(
  # alternate storage directory
  [Parameter(Mandatory = $false, Position = 0)]
  [string]$StorageLocation = "",

  # optional suffix to db file names
  [Parameter(Mandatory = $false, Position = 1)]
  [string]$SessionName = ""
)

$Global:SessionName = $SessionName
$Global:StorageLocation = $StorageLocation

$Global:ScriptRoot = $PSScriptRoot

. $Global:ScriptRoot\Main.ps1
