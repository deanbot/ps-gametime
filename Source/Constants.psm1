function Initialize-Constants {
  Set-Variable JobTypeQuest -option Constant -value 'Quest' -S Global
  Set-Variable JobTypeQuestTimed -option Constant -value 'Quest-Timed' -S Global
  Set-Variable JobTypeDaily -option Constant -value 'Daily' -S Global
  Set-Variable JobTypeRare -option Constant -value 'Rare' -S Global
}

function Initialize-Labels {
  Set-Variable Label_Single_Quest -option Constant -value "Quest" -s Global
  Set-Variable Label_Plural_Quest -option Constant -value "Quests" -s Global
  Set-Variable Label_Single_Quest_Lower -option Constant -value "quest" -s Global
  Set-Variable Label_Plural_Quest_Lower -option Constant -value "quests" -s Global
}
