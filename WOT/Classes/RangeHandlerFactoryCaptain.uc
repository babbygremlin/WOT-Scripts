//=============================================================================
// RangeHandlerFactoryCaptain.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class RangeHandlerFactoryCaptain expands RangeHandlerFactoryGrunt;

defaultproperties
{
     HandlerCreateParams(45)=(bEnabled=True,HandlerTemplate=(HT_Name=FindHelp_GP_Reached,HT_AssociatedState=HelpReached,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal',HT_ObjIntersectReq=OIR_Require))
     HandlerCreateParams(46)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerReachable',HandlerTemplate=(HT_Name=FindHelp_GP_Reachable,HT_AssociatedState=HelpReachable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(48)=(bEnabled=True,HandlerTemplate=(HT_Name=FindHelp_GP_Pathable,HT_AssociatedState=HelpPathable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(50)=(bEnabled=True,HandlerTemplate=(HT_Name=NavigatingToSeal_GP_Reached,HT_AssociatedState=SealReached,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGreatestLOS',HT_ObjIntersectReq=OIR_Require))
     HandlerCreateParams(51)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerReachable',HandlerTemplate=(HT_Name=NavigatingToSeal_GP_Reachable,HT_AssociatedState=SealReachable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(53)=(bEnabled=True,HandlerTemplate=(HT_Name=NavigatingToSeal_GP_Pathable,HT_AssociatedState=SealPathable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(54)=(bEnabled=True,HandlerTemplate=(HT_Name=NavigatingToSeal_GP_UnNavigable,HT_AssociatedState=SealUnNavigable,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGreatestLOS'))
     HandlerCreateParams(55)=(bEnabled=True,HandlerTemplate=(HT_Name=NavigatingToSealAltar_GP_Reached,HT_AssociatedState=SealAltarReached,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGreatestLOS',HT_ObjIntersectReq=OIR_Require))
     HandlerCreateParams(56)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerReachable',HandlerTemplate=(HT_Name=NavigatingToSealAltar_GP_Reachable,HT_AssociatedState=SeeAltarReachable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(58)=(bEnabled=True,HandlerTemplate=(HT_Name=NavigatingToSealAltar_GP_Pathable,HT_AssociatedState=SealAltarPathable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(59)=(bEnabled=True,HandlerTemplate=(HT_Name=NavigatingToSealAltar_GP_UnNavigable,HT_AssociatedState=SealAltarUnNavigable,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGreatestLOS'))
     HandlerCreateParams(60)=(bEnabled=True,HandlerTemplate=(HT_Name=SoundAlarm_GP_Reached,HT_AssociatedState=SuccessfullyNavigatedToAlarmToSound,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal',HT_ObjIntersectReq=OIR_Require))
     HandlerCreateParams(61)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerReachable',HandlerTemplate=(HT_Name=SoundAlarm_GP_Reachable,HT_AssociatedState=AlarmReachable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(63)=(bEnabled=True,HandlerTemplate=(HT_Name=SoundAlarm_GP_Pathable,HT_AssociatedState=AlarmPathable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(64)=(bEnabled=True,HandlerTemplate=(HT_Name=SoundAlarm_GP_UnNavigable,HT_AssociatedState=AlarmUnNavigable,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint'))
     ComponentHandlerCreateParams(1)=(bEnabled=True,HandlerClass=Class'WOT.RangeHandlerSniping',HandlerTemplate=(HT_Name=Acquired_GP_Visible_Component,HT_AssociatedState=AcquiredVisible,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal'))
}
