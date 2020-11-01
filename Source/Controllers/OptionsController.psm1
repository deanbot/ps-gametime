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
  param (
    [Parameter(Mandatory=$true, Position=0)]
    $pos
  )
  switch ($pos) {
    # language learning
    0 {
      Write-Host "TODO add language learning demo content"
    }
    # weight loss
    1 {
      Write-Host "Todo add Weight Loss demo conent"
    }
    # Writing a book
    2 {
      Write-Host "Todo add writing a book demo content"
    }
  }
  pause
}
