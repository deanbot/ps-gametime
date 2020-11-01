# ascii logo via http://patorjk.com/software/taag/
param(
  # alternate storage directory
  [Parameter(Mandatory = $false, Position = 0)]
  [string]$StorageLocation = ""
)

$Global:StorageLocation = $StorageLocation
$Global:ScriptRoot = $PSScriptRoot
. $Global:ScriptRoot\Main.ps1
