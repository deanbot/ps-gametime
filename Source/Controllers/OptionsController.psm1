if ($Global:Debug) {
  $DebugPreference = $Global:Debug
}
else {
  $DebugPreference = "SilentlyContinue"
}

function Reset-Points {
  # add deduct transaction to set balance to 0
  $balance = [decimal](Get-Balance)
  $date = Get-Date -format 'yyyyMMddTHHmmssffff'
  $transaction = [PSCustomObject]@{
    Date   = $date
    JobId  = -1
    Change = ($balance * -1)
    Log    = "Reset Points"
    Note   = ""
  }
  if ($success) {
    Write-Debug "Transaction created successfully."
  }
  else {
    Write-Debug "Transaction not created."
  }
  $success = Add-TransactionDb $transaction
}

# remove jobs and logs files
function Reset-GameTime {
  Remove-TransationsDb
  Remove-JobsDb
}

function Add-DemoContent {
  Write-Host "TODO Add Demo Content"
  pause
}
