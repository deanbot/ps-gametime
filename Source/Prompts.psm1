function Show-Prompt {
  $prompt = $Global:currentPrompt
  if ($prompt -eq $$Prompt_Job_New) {
    Show-PromptNewJob
  } elseif ($prompt -eq $Prompt_Job_Complete) {
    Show-PromptCompleteJob
  } elseif ($prompt -eq $Prompt_Job_Edit) {
    Show-PromptEditJob
  } elseif ($prompt -eq $Prompt_Job_Remove) {
    Show-PromptRemoveJob
  } elseif ($prompt -eq $Prompt_Game_Spend) {
    Show-PromptSpend
  } elseif ($prompt -eq $Prompt_Options_ResetPoints) {
    Show-PromptOptionsResetPoints
  } elseif ($prompt -eq $Prompt_Options_FactoryReset) {
    Show-PromptOptionsFactoryReset
  } elseif ($prompt -eq $Prompt_Options_DemoContent) {
    Show-PromptOptionsDemoContent
  } elseif ($prompt -eq $Prompt_Options_EditLogNotes) {
    Show-PromptEditLogNotes
  }
}

function Read-PromptInput {
  $section = $Global:section
  $subPage = $Global:subPage
  if ($section -eq $Section_Jobs) {
    if ($subPage -eq $Page_Job_New) {
      Read-NewJobInputVal
    } elseif ($subPage -eq $Page_Job_Complete) {
      Read-JobCompleteInputVal
    } elseif ($subPage -eq $Page_Job_Remove) {
      Read-JobRemoveInputVal
    } elseif ($subPage -eq $Page_Job_Edit) {
      Read-JobEditInputVal
    }
  } elseif ($section -eq $Section_Game) {
    if ($subPage -eq $Page_Game_Spend) {
      Read-GameConfirmInputVal
    }
  } elseif ($section -eq $Section_Options) {
    Read-OptionsPromptInputVals
  } elseif ($section -eq $Section_Logs) {
    Read-LogsPromptInputVals
  }
}
