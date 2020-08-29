function Get-CheckBox {
  param(
    [Parameter(Mandatory = $false, Position = 0)]
    [bool]$checked
  )
  if ($checked) {
    "[*] "
  }
  else {
    "[0] "
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
    $width = $Global:containerWidth
  }
  $lines = @()
  if ($text.Length -lt $width) {
    $lines = @($text)
  }
  else {
    # $original = $text;
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
    $Width = $Global:containerWidth
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

function Read-Character {
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

# Read-Line but respond to Esc
function Read-InputLine {
  param (
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Prompt = ""
  )

  # display initial prompt
  if ($Prompt.Length -gt 0) {
    Write-Host "`r$Prompt" -NoNewLine
  }

  # accept and display input until enter or esc is pressed
  $cancelled = $false
  $inputLine = "";
  do {
    # Test to see if escape was pressed within the loop
    $key = $Host.UI.RawUI.ReadKey("IncludeKeyUp,NoEcho")

    # exit if enter or esc pressed
    # 13 = Enter, 27 = Esc
    $exit = $key.VirtualKeyCode -eq 13 -or $key.VirtualKeyCode -eq 27

    # add char to input line
    if (!$exit) {
      $inputLine += $key.Character
    }
    elseif ($key.VirtualKeyCode -eq 27) {
      $cancelled
    }

    # 8 = Backspace
    if ($key.VirtualKeyCode -eq 8) {
      # remove last character from input line
      $newLength = $inputLine.Length - 2;
      if ($newLength -lt 0) {
        $newLength = 0
      }
      $inputLine = $inputLine.Substring(0, $newLength)

      # replace line with blank space
      $blank = ""
      $lineLength = $prompt.length + $inputLine.Length
      for ($l = 0; $l -le $lineLength; $l++) {
        $blank = $blank + " "
      }
      Write-Host "`r$blank" -NoNewline
    }

    # replace line with new input line
    if (!$exit) {
      Write-Host "`r$prompt$inputLine" -NoNewline
    }
  } while (!$exit)

  # replace line with blank space
  $blank = ""
  $lineLength = $prompt.length + $inputLine.Length
  for ($l = 0; $l -le $lineLength; $l++) {
    $blank = $blank + " "
  }
  Write-Host "`r$blank" -NoNewline

  # empty input line if esc pressed
  if ($cancelled) {
    $inputLine = $false
  }

  # start console at beginning of line
  Write-Host "`r" -NoNewline
  $inputLine
}

function Initialize-Display {
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

function Get-JobTypeByPosition {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [int32]$posX
  )
  $jobType = "";
  switch ($posX) {
    0 {
      $jobType = 'Quest'
    } 1 {
      $jobType = 'Daily'
    } 2 {
      $jobType = 'Rare'
    }
  }
  $jobType
}