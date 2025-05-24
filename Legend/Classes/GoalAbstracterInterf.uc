//=============================================================================
// GoalAbstracterInterf.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class GoalAbstracterInterf expands GoalBase abstract native;

native function bool IsGoalA( Object InvokingObject, Name GoalTypeName );
native function bool IsValid( Object InvokingObject );
native function bool IsEquivalent( Object InvokingObject, GoalAbstracterInterf OtherGoalInterf );
native function AssignObject( Object InvokingObject, Object OtherObject );
native function AssignVector( Object InvokingObject, Vector NewGoalVector, optional bool bAdjustLocation /*defaults to true*/ );
native function Invalidate( Object InvokingObject );

native function bool IsVisibleByGoal( Object InvokingObject );
native function bool IsReachableByGoal( Object InvokingObject );

native function bool GetGoalParams( Object InvokingObject, out Vector GoalLocation, out float GoalRadius, out float GoalHalfHeight );
native function bool GetGoalLocation( Object InvokingObject, out Vector GoalLocation );
native function bool GetGoalExtents( Object InvokingObject, out float GoalRadius, out float GoalHalfHeight );
native function bool GetGoalActor( Object InvokingObject, out Actor CurrentGoalActor );

native function bool GetGoalDistance( Object InvokingObject, out float GoalDistance, Object OtherObject );
native function bool GetGoalDistanceToCylinder( Object InvokingObject, out float GoalDistance,
		Vector CylinderOrigin, optional float CylinderRadius, optional float CylinderHalfHeight );

native function bool IsGoalReached( Object InvokingObject );
native function bool IsGoalVisible( Object InvokingObject );
native function bool IsGoalReachable( Object InvokingObject );
native function bool IsGoalPathable( Object InvokingObject );
native function bool IsGoalNavigable( Object InvokingObject );

native function bool GetNavigationGoal( Object InvokingObject, GoalAbstracterInterf NavigationGoal );

native function bool GetAssociatedRotation( Object InvokingObject, out Rotator AssociatedGoalRotation );
native function SetAssociatedRotation( Object InvokingObject, Rotator AssociatedGoalRotation );
native function float GetGoalPriority( Object InvokingObject );
native function SetGoalPriority( Object InvokingObject, float NewGoalPriority );
native function SetGoalPriorityDistance( Object InvokingObject, EGoalPriorityDistanceUsage PriorityDistanceUsage, optional float PriorityDistance );
native function float GetSuggestedSpeed( Object InvokingObject );
native function SetSuggestedSpeed( Object InvokingObject, float NewSuggestedSpeed );

native function bool GetLastVisibleLocation( Object InvokingObject, out Vector LastVisibleLocation );

//=============================================================================
// debug interface
//=============================================================================

function DebugLog( Object InvokingObject, optional coerce string Prefix, optional Name DebugCategory );

defaultproperties
{
}
