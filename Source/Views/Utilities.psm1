# UI utilities
if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}


function Wait-ForKeyPress {
  do {
    Start-Sleep -milliseconds 100
  } until ($Host.UI.RawUI.KeyAvailable)
  $Host.UI.RawUI.FlushInputBuffer()
}

function Read-Character {
  param(
    [Parameter(Mandatory = $false, Position = 0)]
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

# like Read-Line but respond to Esc
function Read-InputLine {
  param (
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Prompt = "",

    [Parameter(Mandatory = $false, Position = 1)]
    [int]$CancelKeyCode = 27 # 27 = Escape
  )
  $Host.UI.RawUI.FlushInputBuffer()

  # display initial prompt
  if ($Prompt.Length -gt 0) {
    Write-Host "`r$Prompt" -NoNewLine
  }

  # accept and display input until enter or esc is pressed
  $cancelled = $false
  $inputLine = "";
  $inputLineDisplay = ""
  do {
    # Test to see if escape was pressed within the loop
    $key = $Host.UI.RawUI.ReadKey("IncludeKeyUp,NoEcho")

    # exit if enter or esc pressed
    # 13 = Enter
    $exit = $key.VirtualKeyCode -eq 13 -or $key.VirtualKeyCode -eq $CancelKeyCode

    # add char to input line
    if (!$exit -and $key.Character) {
      $inputLine += $key.Character
    }
    elseif ($key.VirtualKeyCode -eq $CancelKeyCode) {
      $cancelled = $true
    }

    $maxWidth = $Host.Ui.RawUI.WindowSize.Width

    # 8 = Backspace
    if ($key.VirtualKeyCode -eq 8) {
      # remove last character from input line
      $newLength = $inputLine.Length - 2;
      if ($newLength -lt 0) {
        $newLength = 0
      }
      $inputLine = $inputLine.Substring(0, $newLength)
    }

    # update display line (truncate if console edge reached)
    $startIndex = 0
    $totalLength = $prompt.Length + $inputLine.Length
    $inputLineDisplay = if ($totalLength -le $maxWidth - 1) {
      $inputLine
    }
    else {
      $startIndex = $totalLength - $maxWidth
      $inputLine.SubString($startIndex, ($inputLine.Length - $startIndex))
    }

    # replace line with blank space
    if ($totalLength -le $maxWidth - 1) {
      $blank = ""
      $lineLength = $prompt.length + $inputLine.Length
      if ($lineLength -gt $maxWidth) {
        $lineLength = $maxWidth
      }
      for ($l = 0; $l -le $lineLength; $l++) {
        $blank = $blank + " "
      }
      Write-Host "`r$blank" -NoNewline
    }

    # replace line with new input line
    if (!$exit) {
      Write-Host "`r$prompt$inputLineDisplay" -NoNewline
    }
  } while (!$exit)

  # replace line with blank space
  $blank = ""
  $lineLength = $prompt.length + $inputLine.Length
  if ($lineLength -gt $maxWidth) {
    $lineLength = $maxWidth
  }
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

function Get-TextExcerpt {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Text,

    [Parameter(Mandatory = $false, Position = 1)]
    [int]$Length = 20,

    [Parameter(Mandatory = $false, Position = 2)]
    [string]$Suffix = "...",

    [Parameter(Mandatory = $false, Position = 3)]
    [bool]$OmitSuffix = $false
  )
  $excerpt = $Text
  if ($Text.Length -gt $Length) {
    $pullLength = if ($OmitSuffix) { $Length } else { $Length - $Suffix.Length }
    $excerpt = $excerpt.Substring(0, $pullLength)
    $excerpt = "$excerpt$suffix"
  }
  $excerpt
}

function Get-TextLines {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$text,

    [Parameter(Mandatory = $false, Position = 1)]
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
    $index = 0;
    $remaining = $text.Length - 1
    do {
      if ($remaining - $width -lt 0) {
        $line = $text.SubString($index, $remaining)
      } else {
        $line = $text.SubString($index, $width);
      }
      $index += $width
      $remaining -= $width
      $lines += $line
    } while($index -lt $text.Length)
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
