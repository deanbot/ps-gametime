# set testing data access path
$Global:JobCsvPath = "$pwd\Database\Job-Test.csv"
$Global:TansactionCsvPath = "$pwd\Database\Transaction-Test.csv"

# import game time utilities
Import-Module $pwd\DataAccess.psm1 -Force
Import-Module $pwd\Utilities.psm1 -Force

# ========
# Do tests
# ========

# create Job
# create Job
# create Job
# get Job
# edit Job
# delete Job
# can't edit missing job
# can't delete missing job
# create transaction
# create transaction
# create transaction
# get jobs
# can't create transaction for missing job

# clean up
$Global:JobCsvPath = ""
$Global:TansactionCsvPath = ""