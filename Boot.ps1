# import game time utilities
$Global:Debug = "Continue"
$Global:SilentStatusReturn = $false
Import-Module $pwd\DataAccess.psm1 -Force
Import-Module $pwd\Utilities.psm1 -Force
Import-Module $pwd\UI.psm1 -Force

do {
  Show-Menu
  Write-Host ""
  $selection = Read-Host "Please make a selection"
  switch ($selection) {
    '1' {
      # List all jobs
      Clear-Host
      $jobs = Get-Jobs
      $jobs | format-table
    } '2' {
      # Log job completion
      Clear-Host
      "Log job completion"
    } '3' {
      # Add job
      Clear-Host
      Show-PromptNewJob
    } '4' {
      # Edit job
      Clear-Host
      "Edit job"
    } '5' {
      # Remove job
      Clear-Host
      "Remove job"
    } 'b' {
      # balance
      Clear-Host
      $balance = Get-Balance

      Write-Host "Balance: $balance"
    } 'g' {
      # game time
      Clear-Host
      "Game Time"
    }
  }
  if ($selection -ne 'q') {
    pause
  }
}
until ($selection -eq 'q' -or $selection -eq '')

$Global:Debug = ""