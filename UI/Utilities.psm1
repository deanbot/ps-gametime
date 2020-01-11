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
    [string]$Text = "",

    [Parameter(Mandatory = $false, Position = 1)]
    [string]$Fill = " ",

    [Parameter(Mandatory = $false, Position = 2)]
    [int]$Width,

    # whether text should be centered. not compatible with right
    [Parameter(Mandatory = $false)]
    [boolean]$Center = $false,

    # whether text should be right aligned. not compatible with centered
    [Parameter(Mandatory = $false)]
    [boolean]$Right = $false
  )
  if (!$Width) {
    $Width = $global:containerWidth
  }
  $padded = $Text
  if ($padded.Length -lt $Width -and $Fill.Length -gt 0) {
    # if not centered or there is nothing to center add fill to remainder of padding
    if (!$Center -or $padded.Length -eq 0) {
      do {
        if (!$Right) {
          $padded += $Fill
        }
        else {
          $padded = "$Fill$padded"
        }
      }
      until($padded.Length -ge $Width)
    }
    else {
      # add fill to left and right of text
      $alt = $false
      do {
        if (!$alt) {
          $padded += $Fill
          $alt = $true
        }
        else {
          $padded = "$Fill$padded"
          $alt = $false
        }
      }
      until($padded.Length -ge $Width)
    }
  }
  $padded
}

function Read-Character() {
  param(
    [bool]$Blocking = $true
  )
  if ($Blocking) {
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
  try {
    if ([System.Console]::BufferWidth -gt $global:originalBufferWidth -or [System.Console]::BufferHeight -gt $global:originalBufferHeight) {
      [System.Console]::SetWindowSize(1, 1);
    }
    [System.Console]::SetBufferSize($global:originalBufferWidth, $global:originalBufferHeight);
    [System.Console]::SetWindowSize($global:originalWindowWidth, $global:originalWindowHeight);
  } catch {
    # 'not supported on this platform'
  }
}