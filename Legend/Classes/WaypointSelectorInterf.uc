//=============================================================================
// WaypointSelectorInterf.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

/*
Interface for WaypointSelector components. These are used to find  
intermediate destination goals (waypoints) between a moving actor (e.g. an
NPC) and its goal (e.g. its enemy). Note that waypoints are generalized
to allow for a waypoint to be located at the moving actor's location (a 
"holding" waypoint) which will prevent the moving actor from actually
moving (see WaypointSelectorHolding).
*/

class WaypointSelectorInterf expands AiComponent abstract;



static function bool SelectWaypoint( GoalAbstracterInterf Waypoint,
		Actor MovingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal );

defaultproperties
{
     DebugCategoryName=WaypointSelectorInterf
}
