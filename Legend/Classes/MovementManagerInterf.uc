//=============================================================================
// MovementManagerInterf.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class MovementManagerInterf expands AiComponent abstract;



function BindDestinationGoal( GoalAbstracterInterf NewDestinationGoal );

function BindFocusGoal( GoalAbstracterInterf NewFocusGoal );

function Vector ReturnDestinationLocation( Actor Invoker );

function Actor ReturnDestinationActor( Actor Invoker );

function Vector ReturnFocusLocation( Actor Invoker );

function Actor ReturnFocusActor( Actor Invoker );

function GoalAbstracterInterf ReturnDestination();

function GoalAbstracterInterf ReturnFocus();

//=============================================================================
// initialization functions
//=============================================================================

function InitMovement( Actor Invoker, RangeHandler Handler,
		BehaviorConstrainer Constrainer, GoalAbstracterInterf Goal );

function bool IsForcedStationary( Actor Invoker );

function SetForcedStationary( bool bForcedStationary );

function DefensiveDodge( Actor Invoker, Vector PendingHitLocation );

function bool ShouldTurnTo( Actor Invoker );

function bool ShouldMoveTo( Actor Invoker );

defaultproperties
{
}
