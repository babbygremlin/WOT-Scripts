//=============================================================================
// RangeHandlerFactoryGrunt.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================

class RangeHandlerFactoryGrunt expands RangeHandlerFactoryLegendPawn;

defaultproperties
{
     HandlerCreateParams(21)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerReachable',HandlerTemplate=(HT_Name=Acquired_GP_Reachable,HT_AssociatedState=AcquiredReachable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal'))
     HandlerCreateParams(22)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerComposite',HandlerTemplate=(HT_Name=Acquired_GP_Visible_Composite),bCompositeHandler=True,ComponentCount=1)
     HandlerCreateParams(23)=(bEnabled=True,HandlerTemplate=(HT_Name=Acquired_GP_Pathable,HT_AssociatedState=AcquiredPathable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(24)=(bEnabled=True,HandlerTemplate=(HT_Name=Acquired_GP_UnNavigable,HT_AssociatedState=AcquiredUnNavigable,HT_SelectorClassWpt=Class'Legend.WaypointSelectorApproaching',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(25)=(bEnabled=True,HandlerTemplate=(HT_Name=Investigating_GP_Reached,HT_AssociatedState=GoalInvestigated,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnActor',HT_ObjIntersectReq=OIR_Require))
     HandlerCreateParams(26)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerReachable',HandlerTemplate=(HT_Name=Investigating_GP_Reachable,HT_AssociatedState=Investigating,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal'))
     HandlerCreateParams(28)=(bEnabled=True,HandlerTemplate=(HT_Name=Investigating_GP_Pathable,HT_AssociatedState=Investigating,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(32)=(bEnabled=True,HandlerTemplate=(HT_Name=Searching_GP_Visible,HT_AssociatedState=SearchingVisible,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_bReentrant=False))
     HandlerCreateParams(33)=(bEnabled=True,HandlerTemplate=(HT_Name=Searching_GP_Pathable,HT_AssociatedState=SearchingPathable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint'))
     HandlerCreateParams(34)=(bEnabled=True,HandlerTemplate=(HT_Name=Searching_GP_UnNavigable,HT_AssociatedState=SearchingUnNavigable,HT_SelectorClassWpt=Class'Legend.WaypointSelectorApproaching',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(35)=(bEnabled=True,HandlerTemplate=(HT_Name=NavigatingToGoal_GP_Reached,HT_AssociatedState=SuccessfullyNavigatedToGoal,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal',HT_ObjIntersectReq=OIR_Require))
     HandlerCreateParams(36)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerReachable',HandlerTemplate=(HT_Name=NavigatingToGoal_GP_Reachable,HT_AssociatedState=NavigatingToGoal,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal'))
     HandlerCreateParams(38)=(bEnabled=True,HandlerTemplate=(HT_Name=NavigatingToGoal_GP_Pathable,HT_AssociatedState=NavigatingToGoal,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(40)=(bEnabled=True,HandlerTemplate=(HT_Name=SeekRefuge_GP_Reached,HT_AssociatedState=RefugeReached,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorTurnAround',HT_ObjIntersectReq=OIR_Require))
     HandlerCreateParams(41)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerReachable',HandlerTemplate=(HT_Name=SeekRefuge_GP_Reachable,HT_AssociatedState=Antagonized,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint'))
     HandlerCreateParams(43)=(bEnabled=True,HandlerTemplate=(HT_Name=SeekRefuge_GP_Pathable,HT_AssociatedState=NavigatingToRefuge,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint'))
     HandlerCreateParams(44)=(bEnabled=True,HandlerTemplate=(HT_Name=SeekRefuge_GP_UnNavigable,HT_AssociatedState=RefugeUnNavigable,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGreatestLOS'))
     ComponentHandlerCreateParams(0)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerVisible',HandlerTemplate=(HT_Name=Acquired_GP_Visible_Component,HT_AssociatedState=InitialAcquisition,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal',HT_ObjIntersectReq=OIR_Forbid,HT_bReentrant=False,HT_MinEntryInterval=60.000000))
}
