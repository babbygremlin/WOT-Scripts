//=============================================================================
// RangeHandlerFactoryLegendPawn.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class RangeHandlerFactoryLegendPawn expands RangeHandlerFactory;

defaultproperties
{
     HandlerCreateParams(0)=(bEnabled=True,HandlerTemplate=(HT_Name=Returning_GP_Reached,HT_AssociatedState=WaitingIdle,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnAssociatedRot',HT_ObjIntersectReq=OIR_Require))
     HandlerCreateParams(1)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerReachable',HandlerTemplate=(HT_Name=Returning_GP_Reachable,HT_AssociatedState=ReturningReachable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(3)=(bEnabled=True,HandlerTemplate=(HT_Name=Returning_GP_Pathable,HT_AssociatedState=ReturningPathable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(4)=(bEnabled=True,HandlerTemplate=(HT_Name=Returning_GP_UnNavigable,HT_AssociatedState=UnableToReturn,HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGreatestLOS',HT_ObjIntersectReq=OIR_Forbid,HT_bRequireValidGoal=False))
     HandlerCreateParams(5)=(bEnabled=True,HandlerTemplate=(HT_Name=Tracking_GP_Reached,HT_AssociatedState=Tracking,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint'))
     HandlerCreateParams(13)=(bEnabled=True,HandlerTemplate=(HT_Name=Retreating_GP_Pathable,HT_AssociatedState=Retreating,HT_SelectorClassWpt=Class'Legend.WaypointSelectorRetreat',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint'))
     HandlerCreateParams(15)=(bEnabled=True,HandlerTemplate=(HT_Name=ExternalDirective_GP_Reached,HT_AssociatedState=ExternalDirectiveReached,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal',HT_ObjIntersectReq=OIR_Require))
     HandlerCreateParams(16)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerReachable',HandlerTemplate=(HT_Name=ExternalDirective_GP_Reachable,HT_AssociatedState=ExternalDirectiveReachable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(17)=(bEnabled=True,HandlerClass=Class'Legend.RangeHandlerVisible',HandlerTemplate=(HT_Name=ExternalDirective_GP_Visible,HT_AssociatedState=ExternalDirectiveVisible,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid,HT_bReentrant=False))
     HandlerCreateParams(18)=(bEnabled=True,HandlerTemplate=(HT_Name=ExternalDirective_GP_Pathable,HT_AssociatedState=ExternalDirectivePathable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnWaypoint',HT_ObjIntersectReq=OIR_Forbid))
     HandlerCreateParams(19)=(bEnabled=True,HandlerTemplate=(HT_Name=ExternalDirective_GP_UnNavigable,HT_AssociatedState=ExternalDirectiveUnNavigable,HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGreatestLOS',HT_ObjIntersectReq=OIR_Forbid))
}
