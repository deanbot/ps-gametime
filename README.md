# Game Time

## Overview

PowerShell implementation of Game Time - a gamified habit-tracking/rewards system.

Read more about the [Game Time system](./ABOUT.md).

## Setup

Game Time requires PowerShell. PowerShell Core (i.e. PowerShell 7) is suggested, but you can use alternative releases of PowerShell (i.e. Windows PowerShell 5.1). You may also want to add the start script to your path.

* [Install PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-6)
* See Launch for additional config (i.e., create symlink, alias, etc...)

## Launch

To launch Game Time, execute the `gametime` wrapper script from a terminal. Use `-l` parameter to execute with Windows PowerShell instead of PowerShell core.

### Example 1: Add symlink of gametime to path

1. add `~/bin` to path

    Add the following line to your .bashrc file:

    ```sh
    export PATH="$PATH:$HOME/bin"
    ```

    Source changes to your .bashrc file, i.e. `source ~/.bashrc`

2. make `~/bin` if missing and add symlink.

    Execute the following scripts in your terminal, replacing `$HOME/path/to/ps-gametime` with your install directory.

    ```sh
    mkdir -p ~/bin
    ln -s $HOME/path/to/ps-gametime/gametime $HOME/bin/gametime
    ```

### Example 2: Use alias to target install path

1. Add the following line to your .bashrc file, replacing `$HOME/path/to/ps-gametime` with your install directory:

    ```sh
    alias gametime="$HOME/path/to/ps-gametime/gametime
    ```

2. Source changes to your .bashrc file. i.e. `source ~/.bashrc`
