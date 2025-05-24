//=============================================================================
// RangeHandlerFactoryTrolloc.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class RangeHandlerFactoryTrolloc expands RangeHandlerFactoryGrunt;

defaultproperties
{
     HandlerCreateParams(21)=(HandlerTemplate=(HT_MovementPatternClass=Class'WOTPawns.MovementPatternTrolloc0'))
     HandlerCreateParams(23)=(HandlerTemplate=(HT_MovementPatternClass=Class'Legend.MovementPatternNavigating'))
     ComponentHandlerCreateParams(1)=(bEnabled=True,HandlerClass=Class'WOT.RangeHandlerSniping',HandlerTemplate=(HT_Name=Acquired_GP_Visible_Component,HT_AssociatedState=AcquiredVisible,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal',HT_MovementPatternClass=Class'WOTPawns.MovementPatternTrolloc1'))
}
