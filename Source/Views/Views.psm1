# Views & UI elements/utilities

$Path = $PSScriptRoot

Import-Module $Path\UI.psm1 -Force
Import-Module $Path\Utilities.psm1 -Force
Import-Module $Path\Game\View.psm1 -Force
Import-Module $Path\Index\View.psm1 -Force
Import-Module $Path\Jobs\View.psm1 -Force
Import-Module $Path\Logs\View.psm1 -Force
Import-Module $Path\Options\View.psm1 -Force

function Initialize-Display {
  # hide cursor
  try {
    $Global:originalCursorVisible = [System.Console]::CursorVisible
  }
  catch {
    # 'not supported on this platform
    $Global:originalCursorVisible = $true
  }
  [System.Console]::CursorVisible = $false

  $Global:originalBufferWidth = [System.Console]::BufferWidth
  $Global:originalBufferHeight = [System.Console]::BufferHeight
  $Global:originalWindowHeight = [System.Console]::WindowHeight
  $Global:originalWindowWidth = [System.Console]::WindowWidth
  # $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(55, 110)
  # $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(160, 5000)
  # $width = 160
  # $height = 61
  # if ([System.Console]::BufferWidth -gt $width -or [System.Console]::BufferHeight -gt $height) {
  #   [System.Console]::SetWindowSize(1, 1);
  # }
  # [System.Console]::SetBufferSize(160, 200); [System.Console]::SetWindowSize(160, 200);
}

function Restore-Display {
  # reset cursor visible
  [System.Console]::CursorVisible = $Global:originalCursorVisible

  Clear-Host
  try {
    if ([System.Console]::BufferWidth -gt $Global:originalBufferWidth -or [System.Console]::BufferHeight -gt $Global:originalBufferHeight) {
      [System.Console]::SetWindowSize(1, 1);
    }
    [System.Console]::SetBufferSize($Global:originalBufferWidth, $Global:originalBufferHeight);
    [System.Console]::SetWindowSize($Global:originalWindowWidth, $Global:originalWindowHeight);
  }
  catch {
    # 'not supported on this platform'
  }
}
