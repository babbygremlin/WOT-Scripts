//=============================================================================
// RangeHandlerFactoryTrollocMed.
//=============================================================================
class RangeHandlerFactoryTrollocMed expands RangeHandlerFactoryGrunt;

defaultproperties
{
     HandlerCreateParams(21)=(HandlerTemplate=(HT_MovementPatternClass=Class'WOTPawns.MovementPatternTrollocMed0'))
     ComponentHandlerCreateParams(1)=(bEnabled=True,HandlerClass=Class'WOT.RangeHandlerSniping',HandlerTemplate=(HT_Name=Acquired_GP_Visible_Component,HT_AssociatedState=AcquiredVisible,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal',HT_MovementPatternClass=Class'WOTPawns.MovementPatternTrollocMed1'))
}
