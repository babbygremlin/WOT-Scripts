//=============================================================================
// RangeHandlerFactoryLegion.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class RangeHandlerFactoryLegion expands RangeHandlerFactoryChampion;

defaultproperties
{
     HandlerCreateParams(21)=(HandlerTemplate=(HT_MovementPatternClass=Class'WOTPawns.MovementPatternLegion0'))
     HandlerCreateParams(23)=(HandlerTemplate=(HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal'))
     HandlerCreateParams(24)=(bEnabled=False,HandlerTemplate=(HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal'))
     HandlerCreateParams(32)=(HandlerTemplate=(HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal'))
     HandlerCreateParams(33)=(HandlerTemplate=(HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal'))
     HandlerCreateParams(34)=(HandlerTemplate=(HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal'))
}
