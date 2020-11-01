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

      # Create Jobs

      # example quest
      $quest1Id = New-Job "Course book Section" $jobTypeQuest .75

      # example timed quest
      $timedQuest1Id = New-Job "Read fiction" $jobTypeQuestTimed .5

      # example daily
      $dailyQuest1Id = New-Job "Duolingo" $jobTypeDaily .25
      $dailyQuest2Id = New-Job "Flash cards" $jobTypeDaily .5

      # example rare
      $rareQuest1Id = New-Job "Complete practice test" $jobTypeRare 2

      # Create Logs

      # example complete quest
      New-Transaction $quest1Id -Note "Chapter 2.3" # .75
      New-Transaction $timedQuest1Id -Degree .75 -Note "<book title>" # 1.10
      New-Transaction $dailyQuest1Id -Note "" # 1.35
      New-Transaction $dailyQuest2Id -Note "Studied Chapter 2 flashcards" #1.85
      New-Transaction $rareQuest1Id -Note "Finished practice test and got 97%!" #3.85

      # example CA$H in
      # 1 hour of gaming
      New-DeductTransaction 3 "Played god of war. I learned a new <swordmagic>ability that lets me launch people into the air..."

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
