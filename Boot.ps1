# import game time utilities
Import-Module $pwd\DataAccess.psm1 -Force
Import-Module $pwd\Utilities.psm1 -Force

do
{
  Show-Menu
  $selection = Read-Host "Please make a selection"
  switch ($selection)
  {
    '1' {
      # List all jobs
      Clear-Host
      "List all jobs"
    } '2' {
      # Log job completion
      Clear-Host
      "Log job completion"
    } '3' {
      # Add job
      Clear-Host
      "Add job"
    } '4' {
      # Edit job
      Clear-Host
      "Edit job"
    } '5' {
      # Remove job
      Clear-Host
      "Remove job"
    } 'g' {
      # game time
      Clear-Host
      "Game Time"
    }
  }
  pause
}
until ($selection -eq 'q')