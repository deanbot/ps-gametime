function Show-LogPagination {
  $numPages = $Global:maxMenuPositionsX
  Write-Host "  |$(Get-PaddedString)|  "
  $width = $Global:containerWidth - 4
  $pos = $Global:menuPositionX + 1

  # $numElements = $numPages
  # $hasRemainder = ($width - 4) % ($numElements - 1) -gt 0
  # $itemWidthDefault = [math]::Ceiling(($width - 4) / ($numElements - 1))
  # $output = ""
  # for ($i = 1; $i -le $numElements; $i++) {
  #   $val = $i
  #   $selected = $i -eq $pos
  #   if ($selected) {
  #     $val = "($val)"
  #   }
  #   else {
  #     $val = " $val "
  #   }
  #   $itemWidth = $itemWidthDefault
  #   if ($i -ne 1) {
  #     $output += Get-PaddedString $val -Right $true -Width $itemWidth
  #   } else {
  #     $output += Get-PaddedString $val -Width $("($i)".Length)
  #   }
  # }

  $output = "Page: $pos/$numPages"

  Write-Host "  |$(Get-PaddedString "  $output")|  "
}

function Show-LogCheckBoxes {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    $logs
  )
  $width = $global:containerWidth
  $pos = $global:menuPositionY
  for ($i = 0; $i -lt @($logs).Length; $i++) {
    $log = $logs[$i]
    $selected = $pos -eq $i
    $logText = ""
    $unit = $Global:unit
    $changeAmount = $log.Change
    $date = Get-FormattedDate $log.Date
    $dateText = "($date)"
    $availableSpace = $width - 8
    if ($changeAmount -gt 0) {
      $logText = "Gained +$($changeAmount) $unit"
    } else {
      $logText = "Spent $(-1 * $changeAmount) $unit"
    }
    $logText = Get-TextExcerpt $logText ($availableSpace - $dateText.Length - 1)
    $dateText = Get-PaddedString $dateText -Right $true -Width ($availableSpace - $logText.Length)
    $logText += $dateText
    if ($logText -ne "") {
      $logLine = "  $(Get-CheckBox $selected)$(Get-TextExcerpt $logText $availableSpace)"
      Write-Host "  |$(Get-PaddedString $logLine)|  "
    }
  }
}
