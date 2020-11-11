function Initialize-Constants {
  Set-Variable JobTypeQuest -option Constant -value 'Quest' -S Global
  Set-Variable JobTypeQuestTimed -option Constant -value 'Quest-Timed' -S Global
  Set-Variable JobTypeDaily -option Constant -value 'Daily' -S Global
  Set-Variable JobTypeRare -option Constant -value 'Rare' -S Global

  Set-Variable Prompt_Job_New -option Constant -value "NewJob" -s Global
  Set-Variable Prompt_Job_Complete -option Constant -value "CompleteJob" -s Global
  Set-Variable Prompt_Job_Edit -option Constant -value "EditJob" -s Global
  Set-Variable Prompt_Job_Remove -option Constant -value "RemoveJob" -s Global
  Set-Variable Prompt_Game_Spend -option Constant -value "GameSpend" -s Global
  Set-Variable Prompt_Options_DemoContent -option Constant -value "DemoContent" -s Global
  Set-Variable Prompt_Options_ResetPoint -option Constant -value "ResetPoints" -s Global
  Set-Variable Prompt_Options_FactoryReset -option Constant -value "FactoryReset" -s Global
  Set-Variable Prompt_Options_EditLogNotes -option Constant -value "EditLogNotes" -s Global

  Set-Variable Section_MainMenu -option Constant -value "Options" -s Global
  Set-Variable Section_Jobs -option Constant -value "Jobs" -s Global
  Set-Variable Section_Game -option Constant -value "Game" -s Global
  Set-Variable Section_Options -option Constant -value "Options" -s Global
  Set-Variable Section_Logs -option Constant -value "Logs" -s Global

  Set-Variable Page_Job_New -option Constant -value "NewJob" -s Global
  Set-Variable Page_Job_Single -option Constant -value "SingleJob" -s Global
  Set-Variable Page_Job_Complete -option Constant -value "CompleteJob" -s Global
  Set-Variable Page_Job_Edit -option Constant -value "EditJob" -s Global
  Set-Variable Page_Job_Remove -option Constant -value "RemoveJob" -s Global
  Set-Variable Page_Game_Spend -option Constant -value "GameSpend" -s Global
  Set-Variable Page_Log_Single -option Constant -value "SingleLog" -s Global
  Set-Variable Page_Log_Notes -option Constant -value "LogNotes" -s Global
  Set-Variable Page_Log_Edit -option Constant -value "LogEdit" -s Global
  Set-Variable Page_Options_DemoContent -option Constant -value "DemoContent" -s Global
  Set-Variable Page_Options_ConfirmDemoContent -option Constant -value "DemoContentConfirm" -s Global
  Set-Variable Page_Options_ResetPoint -option Constant -value "ResetPoints" -s Global
  Set-Variable Page_Options_FactoryReset -option Constant -value "FactoryReset" -s Global
  Set-Variable Page_Options_EditLogNotes -option Constant -value "EditLogNotes" -s Global
  Set-Variable Page_Options_StorageLocation -option Constant -value "StorageLocation" -s Global
}

function Initialize-Labels {
  Set-Variable Label_Single_Quest -option Constant -value "Quest" -s Global
  Set-Variable Label_Plural_Quest -option Constant -value "Quests" -s Global
  Set-Variable Label_Single_Quest_Lower -option Constant -value "quest" -s Global
  Set-Variable Label_Plural_Quest_Lower -option Constant -value "quests" -s Global
}
