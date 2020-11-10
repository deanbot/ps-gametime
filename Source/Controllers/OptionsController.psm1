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
      Reset-GameTime

      # Create Jobs
      $quest1Id = New-Job "Course book Section" $jobTypeQuest .75
      $quest2Id = New-Job "Two page essay" $jobTypeQuest 1
      $timedQuest1Id = New-Job "Read fiction" $jobTypeQuestTimed .5
      $timedQuest2Id = New-Job "Watch TV with German dub and subtitle" $jobTypeQuestTimed .20
      $dailyQuest1Id = New-Job "Duolingo" $jobTypeDaily .25
      $dailyQuest2Id = New-Job "Flash cards" $jobTypeDaily .5
      $dailyQuest3Id = New-Job "German lesson podcast" $jobTypeDaily .5
      $rareQuest1Id = New-Job "Chapter 1 test" $jobTypeRare 2
      $rareQuest2Id = New-Job "Chapter 2 test" $jobTypeRare 2
      $rareQuest3Id = New-Job "Chapter 3 test" $jobTypeRare 2
      $rareQuest4Id = New-Job "Pass A1 level competency test" $jobTypeRare 4

      # example complete quest
      $transaction = New-Transaction $quest1Id -Note "Chapter 1.1"
      $transaction = New-Transaction $quest2Id -Note "Wrote about what I did last summer"
      $transaction = New-Transaction $quest1Id -Note "Chapter 1.2"
      $transaction = New-Transaction $quest2Id -Note "Short story about an office party"
      $transaction = New-Transaction $quest1Id -Note "Chapter 1.3"
      $transaction = New-Transaction $quest2Id -Note "A family tree and memories of my immediate family"
      $transaction = New-Transaction $timedQuest1Id -Degree .75 -Note "Chapter 1 of Vorübergehend tot"
      $transaction = New-Transaction $timedQuest2Id -Degree 1.2 -Note "Watched two episodes of King of the Hill in German"
      $transaction = New-Transaction $dailyQuest1Id -Note "Downloaded the flirting module and completed it"
      $transaction = New-Transaction $dailyQuest2Id -Note "Studied Chapter 1.2 flashcards"
      $transaction = New-Transaction $rareQuest1Id -Note "Finished practice test and got 97%!"

      # example CA$H in
      $transaction = New-DeductTransaction 3 "Ghost of Tsushima. 100% liberated!"
      $transaction = New-DeductTransaction 1 "Relaxed with a few rounds of Peggle 2 while waiting for pizza delivery"
      $transaction = New-DeductTransaction 2 "Co-op Breakforcist Battle with my favorite cousin"
      $transaction = New-DeductTransaction 2 "Hatoful Boyfriend was really weird"

    }
    # weight loss
    1 {
      Reset-GameTime

      # Create Jobs
      $quest1Id = New-Job "Logged a meal" $jobTypeQuest .08
      $timedQuest1Id = New-Job "Ringfit" $jobTypeQuestTimed .2
      $timedQuest2Id = New-Job "Running" $jobTypeQuestTimed .25
      $dailyQuest1Id = New-Job "Within 5% of calorie goal" $jobTypeDaily .25
      $dailyQuest2Id = New-Job "Drank 1 gallon of water" $jobTypeDaily .3
      $rareQuest1Id = New-Job "Body fat 25%" $jobTypeRare 1
      $rareQuest2Id = New-Job "Body fat 20%" $jobTypeRare 1.2
      $rareQuest3Id = New-Job "Body fat 16%" $jobTypeRare 1.6
      $rareQuest4Id = New-Job "Body fat 12%" $jobTypeRare 2.3
      $rareQuest5Id = New-Job "10 minute mile" $jobTypeRare 2
      $rareQuest6Id = New-Job "8 minute mile" $jobTypeRare 3


      # example complete quest
      $transaction = New-Transaction $quest1Id -Note "Breakfast"
      $transaction = New-Transaction $quest1Id -Note "Dinner"
      $transaction = New-Transaction $quest1Id -Note "Snack"
      $transaction = New-Transaction $quest1Id -Note "Breakfast"
      $transaction = New-Transaction $quest1Id -Note "Lunch"
      $transaction = New-Transaction $quest1Id -Note "Dinner"
      $transaction = New-Transaction $timedQuest1Id -Degree .3 -Note "Beat a high score for the balance mini-game."
      $transaction = New-Transaction $timedQuest2Id -Degree 1 -Note "Did a Zombie themed couch to 5k session. Ran 3 miles!"
      $transaction = New-Transaction $timedQuest1Id -Degree .5 -Note "Unlocked the wide squat exercise."
      $transaction = New-Transaction $dailyQuest1Id -Note "Hit my goal right on!"
      $transaction = New-Transaction $dailyQuest2Id
      $transaction = New-Transaction $rareQuest1Id
      $transaction = New-Transaction $rareQuest5Id

      # example CA$H in
      $transaction = New-DeductTransaction 2 "The new Sonic game!"
      $transaction = New-DeductTransaction 1 "Managed to get 8 hearts with Seth"
    }
    # Writing a book
    2 {
      Reset-GameTime

      # Create Jobs
      $timedQuest1Id = New-Job "Research" $jobTypeQuestTimed .2
      $timedQuest2Id = New-Job "Words on page time" $jobTypeQuestTimed .5
      $timedQuest3Id = New-Job "Editing" $jobTypeQuestTimed .22
      $dailyQuest1Id = New-Job "Standup meeting with guild" $jobTypeDaily .15
      $dailyQuest2Id = New-Job "Bonus for touching project today" $jobTypeDaily .1
      $rareQuest1Id = New-Job "Write outline" $jobTypeRare 3
      $rareQuest2Id = New-Job "Finish chapter 1" $jobTypeRare 2
      $rareQuest3Id = New-Job "Finish first draft" $jobTypeRare 5
      $rareQuest4Id = New-Job "Complete Editors notes" $jobTypeRare 2

      # example complete quest
      $transaction = New-Transaction $timedQuest1Id -Degree 4 -Note "Researched Civil War for Antebellum conversation in 3rd chapter"
      $transaction = New-Transaction $timedQuest3Id -Degree 1 -Note "Took note on natural conversation, changed pace of dialogue during breakup in epilogue."
      $transaction = New-Transaction $timedQuest1Id -Degree .75 -Note "Research on how railroads are constructed for character background"
      $transaction = New-Transaction $timedQuest2Id -Degree 2 -Note "Groove, finished 20 pages"
      $transaction = New-Transaction $dailyQuest1Id -Note "Volunteered for getaway camp next year"
      $transaction = New-Transaction $dailyQuest2Id -Note "Didn't do much today but did get in some research on timeline"
      $transaction = New-Transaction $rareQuest1Id -Note "Time traveling southern saytr on the run from dark past"
      $transaction = New-Transaction $rareQuest2Id -Note "Editor loved the first chapter and outline!!"

      # example CA$H in
      $transaction = New-DeductTransaction 3 "The book club came over and we played Jackbox for hours"
    }
  }
}
