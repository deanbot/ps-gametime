# Game Time

## Overview

PowerShell implementation of Game Time - a gamified habit-tracking/rewards system.

Create Quest, Daily, and Rare jobs. Log job completions and get game time points. Cash out your points to get gaming time - 1 point equals 20 minutes of gaming.

### Jobs

* **Quest** - A job you can repeat like reading or studying a new language. Quests are assigned a points per hour rate, and completions are logged for a specified duration, i.e. 1.5 hours.
* **Daily** - A job you can complete, but once-a-day like meditating or doing yoga. A job completion will reward the points specified by the job's rate.
* **Rare** - A one-off job that you can complete once like doing your taxes or cleaning the garage. A job completion will reward the points specified by the job's rate and then the job will be removed.

## Setup

* [Install](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-6)

## Run

In powershell terminal:

```powershell
cd [project\directory]
.\Boot.ps1
```

## Testing

In powershell terminal:

```powershell
cd [project\directory]
.\Test.ps1
```

## Gotchyas

If manually editting csv's be sure to leave a new line at the end of the file.