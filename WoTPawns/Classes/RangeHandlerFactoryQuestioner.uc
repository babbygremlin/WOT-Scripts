//=============================================================================
// RangeHandlerFactoryQuestioner.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class RangeHandlerFactoryQuestioner expands RangeHandlerFactoryChampion;

defaultproperties
{
     HandlerCreateParams(21)=(HandlerTemplate=(HT_MovementPatternClass=Class'WOTPawns.MovementPatternQuestioner0'))
     ComponentHandlerCreateParams(1)=(HandlerTemplate=(HT_MovementPatternClass=Class'WOTPawns.MovementPatternQuestioner1'))
}
