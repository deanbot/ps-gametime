# view body content routing
function Show-BodyContent {
  $section = $Global:section
  $subPage = $Global:subPage
  if ($section -eq $Section_Main) {
    Show-MainMenu
  }
  elseif ($section -eq $Section_Jobs) {
    if (!$subPage) {
      Show-JobsMenu
    }
    elseif ($subPage -eq $Page_Job_Single) {
      Show-JobSingle
    }
    elseif ($subPage -eq $Page_Job_New) {
      Show-JobNew
    }
    elseif ($subPage -eq $Page_Job_Complete) {
      Show-JobConfirmComplete
    }
    elseif ($subPage -eq $Page_Job_Remove) {
      Show-JobConfirmRemove
    }
    elseif ($subPage -eq $Page_Job_Edit) {
      if ($Global:currentField) {
        Show-JobField
      }
      else {
        Show-JobEdit
      }
    }
  }
  elseif ($section -eq $Section_Game) {
    if (!$subPage) {
      Show-GameMenu
    }
    elseif ($subPage -eq $Page_Game_Spend) {
      Show-GameConfirmSpend
    }
  }
  elseif ($section -eq $Section_Logs) {
    if (!$subPage) {
      Show-LogsMenu
    } elseif ($subPage -eq $Page_Log_Single) {
      Show-LogSingle
    } elseif ($subPage -eq $Page_Log_Notes) {
      Show-LogNotes
    } elseif ($subPage -eq $Page_Log_Edit) {
      Show-LogEditNotes
    }
  }
  elseif ($section -eq $Section_Options) {
    if (!$subPage) {
      Show-OptionsMenu
    } elseif ($subPage -eq $Page_Options_FactoryReset) {
      Show-OptionsConfirmFactoryReset
    } elseif ($subPage -eq $Page_Options_ResetPoints) {
      Show-OptionsConfirmResetPoints
    } elseif ($subPage -eq $Page_Options_DemoContent) {
      Show-OptionsDemoContentMenu
    } elseif ($subPage -eq $Page_Options_ConfirmDemoContent) {
      Show-OptionsConfirmDemoContent
    } elseif ($subPage -eq $Page_Options_StorageLocation) {
      Show-OptionsStorageLocation
    }
  }
}
