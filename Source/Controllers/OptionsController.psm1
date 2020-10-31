function Reset-Points {
  # add deduct transaction to set balance to 0
}

# remove jobs and logs files
function Reset-GameTime {
  Remove-TransationsDb
  Remove-JobsDb
}
