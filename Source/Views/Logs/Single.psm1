function Show-LogSingle {
  $log = $global:currentTransaction
  $unit = $Global:unit
  $width = $global:containerWidth
  $logText = $log.Log
  $logDate = Get-FormattedDate $log.Date
  $logChange = $log.Change
  $logNotes = $log.Note

  Write-Host ""
  Show-Heading "View Log"
  Write-Host "  |$(Get-PaddedString)|  "

  $dateText = "($logDate)"
  $availableSpace = $width - 4
  if ($logChange -gt 0) {
    $changeText = "Gained +$($logChange) $unit"
  } else {
    $changeText = "Spent $(-1 * $logChange) $unit"
  }
  $changeText = Get-TextExcerpt $changeText ($availableSpace - $dateText.Length - 1)
  $dateText = Get-PaddedString $dateText -Right $true -Width ($availableSpace - $changeText.Length)
  $logLine = "  $(Get-TextExcerpt ($changeText + $dateText) $availableSpace)"
  Write-Host "  |$(Get-PaddedString $logLine)|  "
  Write-Host "  |$(Get-PaddedString)|  "

  $textLines = Get-TextLines $logText $availableSpace
  foreach ($line in $textLines) {
    Write-Host "  |$(Get-PaddedString "  $line" )|  "
  }

  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Notes: $(Get-TextExcerpt $logNotes ($width - 10))" )|  "
  Write-Host "  |$(Get-PaddedString)|  "

  $logLine = "  $(Get-CheckBox $true)View/Edit Notes"
  Write-Host "  |$(Get-PaddedString $logLine)|  "

  Write-Host "  |$(Get-PaddedString -Fill ' ')|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

function Show-LogNotes {
  $log = $global:currentTransaction
  $unit = $Global:unit
  $width = $global:containerWidth
  $availableSpace = $width - 4

  Write-Host ""
  Show-Heading "View Log Notes"
  Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  Notes: " )|  "

  if ($log.Note) {
    Write-Host "  |$(Get-PaddedString)|  "
    $textLines = Get-TextLines $log.Note $availableSpace
    foreach ($line in $textLines) {
      Write-Host "  |$(Get-PaddedString "  $line" )|  "
    }
  }

  Write-Host "  |$(Get-PaddedString)|  "
  $logLine = "  $(Get-CheckBox $true)Edit Notes"
  Write-Host "  |$(Get-PaddedString $logLine)|  "
  Write-Host "  |$(Get-PaddedString -Fill ' ')|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
  Write-Host ""
}

function Show-LogEditNotes {
  $log = $global:currentTransaction
  $unit = $Global:unit
  $width = $global:containerWidth
  $logText = $log.Log
  $logDate = $log.Date
  $logChange = $log.Change

  Write-Host ""
  Show-Heading "Edit Log Notes"
  Write-Host "  |$(Get-PaddedString)|  "

  # $dateText = "($logDate)"
  # $availableSpace = $width - 4
  # if ($logChange -gt 0) {
  #   $changeText = "Gained +$($logChange) $unit"
  # } else {
  #   $changeText = "Spent $(-1 * $logChange) $unit"
  # }
  # $changeText = Get-TextExcerpt $changeText ($availableSpace - $dateText.Length - 1)
  # $dateText = Get-PaddedString $dateText -Right $true -Width ($availableSpace - $changeText.Length)
  # $logLine = "  $(Get-TextExcerpt ($changeText + $dateText) $availableSpace)"
  # Write-Host "  |$(Get-PaddedString $logLine)|  "
  # Write-Host "  |$(Get-PaddedString)|  "

  # $textLines = Get-TextLines $logText $availableSpace
  # foreach ($line in $textLines) {
  #   Write-Host "  |$(Get-PaddedString "  $line" )|  "
  # }

  # Write-Host "  |$(Get-PaddedString)|  "
  Write-Host "  |$(Get-PaddedString "  [...]")|  "
  Write-Host "  |$(Get-PaddedString -Fill '_')|  "
}

function Show-PromptEditLogNotes {
  Write-Host ""
  Write-Host "   $(Get-PaddedString "Press [Esc] to return" -Right $true)"
  Write-Host "   $(Get-PaddedString "[Enter] to continue" -Right $true)"
  Write-Host ""
  $notes = Read-InputLine "  Notes (optional): "
  $Global:inputValue = $notes
}
