# ascii logo via http://patorjk.com/software/taag/
param(
  # optional suffix to db file names
  [Parameter(Mandatory = $false, Position = 0)]
  [string]$SessionName = "",

  # alternate storage directory
  [Parameter(Mandatory = $false, Position = 1)]
  [string]$StorageLocation = ""

)

# import game time utilities
$Global:DevMode = $true
$Global:Debug = "Continue"
$Global:Debug = "SilentlyContinue"
$Global:SilentStatusReturn = $false
$Global:SessionName = $SessionName
$Global:StorageLocation = $StorageLocation
$Global:ScriptRoot = $PSScriptRoot

. $Global:ScriptRoot\Main.ps1