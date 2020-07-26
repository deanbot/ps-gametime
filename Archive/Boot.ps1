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
      Show-PromptNewTransaction
    } '3' {
      # Add job
      Show-PromptNewJob
    } '4' {
      # Edit job
      Show-PromptEditJob
    } '5' {
      # Remove job
      Show-PromptRemoveJob
    } 'b' {
      # balance
      Clear-Host
      $balance = Get-Balance
      $available = Get-AvailableBalance
      Write-Host "Balance: $balance | Available Balance: $available"
    } 'l' {
      Clear-Host
      $trans = Get-Transactions
      $trans | Select-Object Log | Format-Table
    } 'g' {
      # game time
      Show-PromptGameTime
    }
  }
  if ($selection -ne 'q') {
    pause
  }
}
until ($selection -eq 'q' -or $selection -eq '')

$Global:Debug = ""