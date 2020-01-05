function Get-CheckBox {
  param(
    [Parameter(Mandatory = $false, Position = 0)]
    [bool]$checked
  )
  if ($checked) {
    "[*] "
  }
  else {
    "[ ] "
  }
}

function Get-TextLines {
  param(
    [Paramter(Mandatory = $true, Position = 0)]
    [string]$text,

    [Parameter(Mandatory = $false, Position = 2)]
    [int]$width
  )

  if (!$width) {
    $width = $global:containerWidth
  }
  $lines = @()
  if ($text.Length -lt $width) {
    $lines = @($text)
  }
  else {
    $original = $text;
    do {
      $pullLength = $width
      if ($pullLength -gt $text.Length - 1) {
        $pullLength = $text.Length - 1
      }
      $line = $text.SubString(0, $pullLength)
      if ($pullLength -ge $text.Length - 1) {
        $text = ""
      }
      else {
        $text = $text.SubString($pullLength, $text.Length - 1)
      }
      $lines += $line
    }
    while ($text.Length -ne 0)
  }
  return , $lines
}

function Get-PaddedString {
  param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$text = "",

    [Parameter(Mandatory = $false, Position = 1)]
    [string]$fill = " ",

    [Parameter(Mandatory = $false, Position = 2)]
    [int]$width,

    [Parameter(Mandatory = $false, Position = 3)]
    [boolean]$centered = $false
  )
  if (!$width) {
    $width = $global:containerWidth
  }
  $padded = $text
  if ($padded.Length -lt $width) {
    do {
      $padded += $fill
    }
    until($padded.Length -ge $width)
  }
  $padded
}

function Read-Character() {
  param(
    [bool]$blocking = $true
  )
  if ($blocking) {
    return [System.Console]::ReadKey($true).Key.ToString()
  }
  elseif ([System.Console]::KeyAvailable) {
    return [System.Console]::ReadKey($true).Key.ToString()
  }
  return 0
  # if ($host.ui.RawUI.KeyAvailable) {
  # return $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp").Character
  # }
}

function Initialize-Display {
  $global:originalBufferWidth = [System.Console]::BufferWidth
  $global:originalBufferHeight = [System.Console]::BufferHeight
  $global:originalWindowHeight = [System.Console]::WindowHeight
  $global:originalWindowWidth = [System.Console]::WindowWidth
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
  Clear-Host
  if ([System.Console]::BufferWidth -gt $global:originalBufferWidth -or [System.Console]::BufferHeight -gt $global:originalBufferHeight) {
    [System.Console]::SetWindowSize(1, 1);
  }
  [System.Console]::SetBufferSize($global:originalBufferWidth, $global:originalBufferHeight);
  [System.Console]::SetWindowSize($global:originalWindowWidth, $global:originalWindowHeight);
}