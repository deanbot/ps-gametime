# ps-gametime

## Overview

PowerShell implementation of [Game Time](./ABOUT.md) - a gamified habit-tracking & rewards system where progress on goals equates to real life gaming time.

## Get started

1. Review [Requirements](#Requirements) and [Install](#Install).
2. Learn how to use [Game Time](./ABOUT.md).
3. Launch `gametime` from a terminal. Use arrow keys and on-screen prompts to navigate.

_Productivity ensues._

### Specify storage location

The directory Game Time uses to store data (by default `<path/to/gametime>/Database`) can be customized via the optional *storage location* parameter, i.e. `gametime <storage location absolute pate>`.

#### Synchronize across devices

Game Time's minimal database can be synchronized across your devices by specifying a storage location that is synchronized by a service such as OneDrive, Dropbox, SpiderOak, etc.

```bash
gametime /c/Users/me/OneDrive/GameTime
```

## Requirements

* PowerShell

    PowerShell Core (i.e. PowerShell 7) is suggested, but alternative releases of PowerShell (i.e. Windows PowerShell 5.1) are supported.

    [Install PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-6)

## Install

1. Copy ps-gametime.
2. Add `./bin` to `PATH`.

I.e., in bash, add the following line to `~/.bashrc`:

```sh
export PATH="$PATH:$HOME/path/to/ps-gametime/bin"
```
