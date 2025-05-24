//=============================================================================
// WaypointSelectorHolding.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

/*
Holding waypoints have their location set to the location of the moving actor
so that when these are "used" the moving actor won't actually move anywhere.
e.g. if we don't want an NPC to attack until the target meets some criteria
(e.g. distance to NPC, visibility of NPC to target), we can use a holding
waypoint to "hold" the moving actor at his current location.
*/

class WaypointSelectorHolding expands WaypointSelectorInterf;



static function bool SelectWaypoint( GoalAbstracterInterf Waypoint,
		Actor MovingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	return SelectHoldingWayPoint( Waypoint, MovingActor, Constrainer, Goal );
}


static function bool SelectHoldingWayPoint( GoalAbstracterInterf Waypoint,
		Actor MovingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	// set location of waypoint to moving actor's location (hold)
	Waypoint.AssignVector( MovingActor, MovingActor.Location );
	return true;
}

defaultproperties
{
}
