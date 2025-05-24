//=============================================================================
// MovementManager.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 9 $
//=============================================================================

class MovementManager expands MovementManagerInterf;


var GoalAbstracterInterf MovementDestinationGoal;
var GoalAbstracterInterf MovementFocusGoal;

var float AccumulatedDist;
var float AccululatedDeltaTime;
var bool bForcedStationary;

var bool bHandleDefensive;

//var private float DodgeHeight;
var private Actor ActorToDodge;
var private Vector PendingHitLocation;
var private Name ResponsePreHint;
var private Name ResponsePostHint;

const MinMoveToEvaluationDuration = 0.33;
const MinimumActualSpeed = 0.5;



function SubjectDestroyed( Object Subject )
{
	if( MovementDestinationGoal == Subject )
	{
		MovementDestinationGoal = None;
	}
	if( MovementFocusGoal == Subject )
	{
		MovementFocusGoal = None;
	}
	if( ActorToDodge == Subject )
	{
		ActorToDodge = None;
	}
	Super.SubjectDestroyed( Subject );
}



function Destructed()
{
	if( MovementDestinationGoal != None )
	{
		MovementDestinationGoal.DetachDestroyObserver( Self );
		MovementDestinationGoal = None;
	}
	if( MovementFocusGoal != None )
	{
		MovementFocusGoal.DetachDestroyObserver( Self );
		MovementFocusGoal = None;
	}
	if( ActorToDodge != None )
	{
		ActorToDodge.DetachDestroyObserver( Self );
		ActorToDodge = None;
	}
	Super.Destructed();
}



function BindDestinationGoal( GoalAbstracterInterf NewDestinationGoal )
{
	if( NewDestinationGoal.AttachDestroyObserver( Self ) )
	{
		if( MovementDestinationGoal != None )
		{
			MovementDestinationGoal.DetachDestroyObserver( Self );
			MovementDestinationGoal = None;
		}
		MovementDestinationGoal = NewDestinationGoal;
	}
}



function BindFocusGoal( GoalAbstracterInterf NewFocusGoal )
{
	if( NewFocusGoal.AttachDestroyObserver( Self ) )
	{
		if( MovementFocusGoal != None )
		{
			MovementFocusGoal.DetachDestroyObserver( Self );
			MovementFocusGoal = None;
		}
		MovementFocusGoal = NewFocusGoal;
	}
}



function Vector ReturnDestinationLocation( Actor Invoker )
{
	local Vector Destination;
	MovementDestinationGoal.GetGoalLocation( Invoker, Destination );
	return Destination;
}



function Vector ReturnFocusLocation( Actor Invoker )
{
	local Vector Focus;
	MovementFocusGoal.GetGoalLocation( Invoker, Focus );
	return Focus;
}



function Actor ReturnDestinationActor( Actor Invoker )
{
	local Actor Focus;
	MovementDestinationGoal.GetGoalActor( Invoker, Focus );
	return Focus;
}


function Actor ReturnFocusActor( Actor Invoker )
{
	local Actor Focus;
	MovementFocusGoal.GetGoalActor( Invoker, Focus );
	return Focus;
}



function GoalAbstracterInterf ReturnDestination()
{
	return MovementDestinationGoal;
}



function GoalAbstracterInterf ReturnFocus()
{
	return MovementFocusGoal;
}



function InitMovement( Actor Invoker, RangeHandler Handler, BehaviorConstrainer Constrainer, GoalAbstracterInterf Goal )
{
/*
	class'Debug'.static.DebugLog( Invoker, "InitMovement", DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "InitMovement Invoker: " $ Invoker, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "InitMovement Invoker.Location: " $ Invoker.Location, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "InitMovement Invoker.Rotation: " $ Invoker.Rotation, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "InitMovement Constrainer: " $ Constrainer, DebugCategoryName );
	class'Debug'.static.DebugAssert( Invoker, ( WptSelector != none ), "InitMovement WptSelector == none ", DebugCategoryName );
	class'Debug'.static.DebugAssert( Invoker, ( FcsSelector != none ), "InitMovement FcsSelector == none", DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "InitMovement WptSelector: " $ WptSelector, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "InitMovement FcsSelector: " $ FcsSelector, DebugCategoryName );
	Goal.DebugLog( Invoker, "InitMovement Goal", DebugCategoryName );
*/
	//xxxrlo debug code
	if( Invoker == None )
	{
		Log( "InitMovement Invoker " $ Invoker );
		Log( "InitMovement Handler " $ Handler );
		Log( "InitMovement Constrainer " $ Constrainer );
		Log( "InitMovement Goal " $ Goal );
	}
	if( Handler == None )
	{
		Log( "InitMovement Invoker " $ Invoker );
		Log( "InitMovement Handler " $ Handler );
		Log( "InitMovement Constrainer " $ Constrainer );
		Log( "InitMovement Goal " $ Goal );
	}
	if( Constrainer == None )
	{
		Log( "InitMovement Invoker " $ Invoker );
		Log( "InitMovement Handler " $ Handler );
		Log( "InitMovement Constrainer " $ Constrainer );
		Log( "InitMovement Goal " $ Goal );
	}
	if( Goal == None )
	{
		Log( "InitMovement Invoker " $ Invoker );
		Log( "InitMovement Handler " $ Handler );
		Log( "InitMovement Constrainer " $ Constrainer );
		Log( "InitMovement Goal " $ Goal );
	}
	
	class'Debug'.static.DebugLog( Invoker, "InitMovement", DebugCategoryName );
	Handler.Template.HT_PreHint = '';
	Handler.Template.HT_PostHint = '';
	if ( bHandleDefensive && SelectDodgeWaypointGoal( Invoker, Constrainer, Goal ) )
	{
		class'Debug'.static.DebugLog( Invoker, "InitMovement HandleDefensive", DebugCategoryName );
		SelectDodgeFocusGoal( Invoker, Constrainer, Goal );
		Handler.Template.HT_PreHint = ResponsePreHint;
		Handler.Template.HT_PostHint = ResponsePostHint;
		MovementDestinationGoal.SetSuggestedSpeed( Invoker, Goal.GetSuggestedSpeed( Invoker ) );
		if( ActorToDodge != None )
		{
			ActorToDodge.DetachDestroyObserver( Self );
			ActorToDodge = None;
		}
		bHandleDefensive = false;
	}
	else if( IsForcedStationary( Invoker ) )
	{
		class'Debug'.static.DebugLog( Invoker, "InitMovement ForceStationary", DebugCategoryName );
		SelectForcedStationaryWaypointGoal( Invoker, Constrainer, Goal );
		SelectForcedStationaryFocusGoal( Invoker, Constrainer, Goal );
	}
	else
	{
		class'Debug'.static.DebugLog( Invoker, "InitMovement Handler.MovementPattern: " $ Handler.MovementPattern, DebugCategoryName );
		if( ( Handler.MovementPattern != None ) &&
				Handler.MovementPattern.EvaluatePrerequisiteGoalDistance( MovementDestinationGoal, Invoker, Goal ) &&
				Handler.MovementPattern.SelectPatternElement( Invoker, Goal, Handler.MovementPattern.PatternElementIter ) )
		{
			ApplyPatternElement( Invoker, Handler, Constrainer, Goal );
		}
		else
		{
			if( !Handler.Template.HT_SelectorClassWpt.static.SelectWaypoint( MovementDestinationGoal, Invoker, Constrainer, Goal ) )
			{
				class'WaypointSelectorHolding'.static.SelectWaypoint( MovementDestinationGoal, Invoker, Constrainer, Goal );
				MovementDestinationGoal.SetSuggestedSpeed( Invoker, Goal.GetSuggestedSpeed( Invoker ) );
			}
			if( !Handler.Template.HT_SelectorClassFcs.static.SelectFocus( MovementFocusGoal, MovementDestinationGoal, Invoker, Constrainer, Goal ) )
			{
				class'FocusSelectorOnActor'.static.SelectFocus( MovementFocusGoal, MovementDestinationGoal, Invoker, Constrainer, Goal );
			}
		}
	}
	//class'Util'.static.DrawQuickLine( Invoker, Invoker.Location, ReturnDestinationLocation( Invoker ) );
	//MovementDestinationGoal.DebugLog( Invoker, "InitMovement MovementDestinationGoal", DebugCategoryName );
	//MovementFocusGoal.DebugLog( Invoker, "InitMovement MovementFocusGoal", DebugCategoryName );
}



function ApplyPatternElement( Actor Invoker, RangeHandler Handler, BehaviorConstrainer Constrainer, GoalAbstracterInterf Goal )
{
	local bool bTransferHints;
	class'Debug'.static.DebugLog( Invoker, "InitMovement Selecting Waypoint From Pattern Element " $ Handler.MovementPattern, DebugCategoryName );
	if( Handler.MovementPattern.SelectWaypointFromPatternElement( MovementDestinationGoal, Invoker,
			Handler.Template.HT_SelectorClassWpt, Constrainer, Goal, Handler.MovementPattern.PatternElementIter ) )
	{
		bTransferHints = true;
	}
	else if( !Handler.Template.HT_SelectorClassWpt.static.SelectWaypoint( MovementDestinationGoal, Invoker, Constrainer, Goal ) )
	{
		class'WaypointSelectorHolding'.static.SelectWaypoint( MovementDestinationGoal, Invoker, Constrainer, Goal );
	}

	if( Handler.MovementPattern.SelectFocusFromPatternElement( MovementFocusGoal, Invoker,
			Handler.Template.HT_SelectorClassFcs, Constrainer, Goal, Handler.MovementPattern.PatternElementIter ) )
	{
		bTransferHints = true;
	}
	else if( !Handler.Template.HT_SelectorClassFcs.static.SelectFocus( MovementFocusGoal, MovementDestinationGoal, Invoker, Constrainer, Goal ) )
	{
		class'FocusSelectorOnActor'.static.SelectFocus( MovementFocusGoal, MovementDestinationGoal, Invoker, Constrainer, Goal );
	}

	if( bTransferHints )
	{
		Handler.Template.HT_PreHint = Handler.MovementPattern.GetMovmentPatternElement( Handler.MovementPattern.PatternElementIter ).MPE_PreHint;
		Handler.Template.HT_PostHint = Handler.MovementPattern.GetMovmentPatternElement( Handler.MovementPattern.PatternElementIter ).MPE_PostHint;
	}
	else
	{
		Handler.Template.HT_PreHint = '';
		Handler.Template.HT_PostHint = '';
	}
	Handler.MovementPattern.PatternElementIter.GetNextIndex();
}



//=============================================================================
// turning functions
//=============================================================================



function bool ShouldTurnTo( Actor Invoker )
{
	local bool bShouldTurnTo;
	local Rotator FocusRotation;
	if( MovementFocusGoal.GetAssociatedRotation( Invoker, FocusRotation ) )
	{
		class'Debug'.static.DebugLog( Invoker, "ShouldTurnTo FocusRotation: " $ FocusRotation, DebugCategoryName );
		class'Debug'.static.DebugLog( Invoker, Invoker $ "ShouldTurnTo Invoker.Rotation: " $ Invoker.Rotation, DebugCategoryName );
		bShouldTurnTo = FocusRotation.Yaw != Invoker.Rotation.Yaw; //xxx
	}
	class'Debug'.static.DebugLog( Invoker, "ShouldTurnTo returning: " $ bShouldTurnTo, DebugCategoryName );
	return bShouldTurnTo;
}



//=============================================================================
// moving functions
//=============================================================================



function bool ShouldMoveTo( Actor Invoker )
{
	local bool bShouldMoveTo;
	class'Debug'.static.DebugLog( Invoker, "ShouldMoveTo", DebugCategoryName );
	bShouldMoveTo = !MovementDestinationGoal.IsGoalReached( Invoker );
	class'Debug'.static.DebugLog( Invoker, "ShouldMoveTo returning: " $ bShouldMoveTo, DebugCategoryName );
	return bShouldMoveTo;
}



//=============================================================================
// functions
//=============================================================================



function bool IsForcedStationary( Actor Invoker ) { return bForcedStationary; }

function SetForcedStationary( bool bForcedStationary ) { Self.bForcedStationary = bForcedStationary; }



function SelectForcedStationaryWaypointGoal( Actor Invoker, BehaviorConstrainer Constrainer, GoalAbstracterInterf Goal )
{
	class'WaypointSelectorHolding'.static.SelectWaypoint( MovementDestinationGoal, Invoker, Constrainer, Goal );
}



function SelectForcedStationaryFocusGoal( Actor Invoker, BehaviorConstrainer Constrainer, GoalAbstracterInterf Goal )
{
	local DefensiveDetector DefensiveNotifier;
	local Actor DefensiveInstigator;
	DefensiveNotifier = DefensiveDetector( LegendPawn( Invoker ).GetDurationNotifier( DNI_Defensive ) );
	DefensiveInstigator = DefensiveNotifier.GetOffender();
	if( ( DefensiveInstigator != None ) &&
			!DefensiveNotifier.IsOffenderRejected( Invoker, DefensiveInstigator ) )
	{
		class'FocusSelectorOnActor'.static.SelectFocusFromGivenActor( MovementFocusGoal, Invoker, Constrainer, DefensiveInstigator );
	}
	else
	{
		class'FocusSelectorOnGoal'.static.SelectFocus( MovementFocusGoal, MovementDestinationGoal, Invoker, Constrainer, Goal );
	}
}



function bool SelectDodgeWaypointGoal( Actor Invoker, BehaviorConstrainer Constrainer, GoalAbstracterInterf Goal )
{
	local Vector DodgeDestination;
	local bool bSelectDodgeWaypointGoal;
	if( ( ActorToDodge != None ) && FindDodgeDestination( Invoker, DodgeDestination, ActorToDodge, PendingHitLocation ) )
	{
		MovementDestinationGoal.AssignVector( Invoker, DodgeDestination );
		bSelectDodgeWaypointGoal = true;
	}
	return bSelectDodgeWaypointGoal;
}



function SelectDodgeFocusGoal( Actor Invoker, BehaviorConstrainer Constrainer, GoalAbstracterInterf Goal )
{
	//xxxrlo class'FocusSelectorOnActor'.static.SelectFocus( MovementFocusGoal, MovementDestinationGoal, Invoker, Constrainer, Goal );
	class'FocusSelectorOnGoal'.static.SelectFocus( MovementFocusGoal, MovementDestinationGoal, Invoker, Constrainer, Goal );
}



function DefensiveDodge( Actor Invoker, Vector PendingHitLocation )
{
	local DefensiveDetector DefensiveNotifier;
	local Actor DefensiveInstigator;
	DefensiveNotifier = DefensiveDetector( LegendPawn( Invoker ).GetDurationNotifier( DNI_Defensive ) );
	DefensiveInstigator = DefensiveNotifier.GetOffender();
	class'Debug'.static.DebugLog( Invoker, "DefensiveDodge DefensiveNotifier " $ DefensiveNotifier, DebugCategoryName );
	if( ( DefensiveInstigator != None ) &&
			!DefensiveNotifier.IsOffenderRejected( Invoker, DefensiveInstigator ) )
	{
		Self.PendingHitLocation = PendingHitLocation;
		if( ActorToDodge != None )
		{
			ActorToDodge.DetachDestroyObserver( Self );
			ActorToDodge = None;
		}
		if( DefensiveInstigator.AttachDestroyObserver( Self ) )
		{
			ActorToDodge = DefensiveInstigator;
		}
		DefensiveNotifier.GetResponseHints( ActorToDodge, ResponsePreHint, ResponsePostHint );
		bHandleDefensive = true;
	}
	else
	{
		if( ActorToDodge != None )
		{
			ActorToDodge.DetachDestroyObserver( Self );
			ActorToDodge = None;
		}
		bHandleDefensive = false;
	}
	class'Debug'.static.DebugLog( Invoker, "DefensiveDodge ActorToDodge " $ ActorToDodge $ " bHandleDefensive " $ bHandleDefensive, DebugCategoryName );
}






//=============================================================================
// Tries to move to the left or right of the given trajectory, as long as
// there is no geometry preventing this. Randomly tries left or right, and if
// the first choice is blocked, tries the other way. Returns true whether the Actor
// was able to dodge (try to) or false.
//=============================================================================

static function bool FindDodgeDestination( Actor Inquirer,
		out Vector DodgeDestination,
		Actor ActorToDodge,
		Vector PendingHitLocation )
{
	local bool bUnobstructed;
	local Vector DodgeDirection;
	local Vector PursuerDirection;
	local float HorizontalDistance; //, VerticalDistance;
	
	//xxrlo HorizontalDistance = FMax( ( Inquirer.CollisionRadius + ActorToDodge.CollisionRadius ) * 2, 80 );
	//HorizontalDistance = ( Inquirer.CollisionRadius + ActorToDodge.CollisionRadius ) * 2;
	//HorizontalDistance = 80;
	HorizontalDistance = Inquirer.CollisionRadius + ActorToDodge.CollisionRadius;
/*
	VerticalDistance = Inquirer.CollisionHeight + ActorToDodge.CollisionHeight;
	if( ( PendingHitLocation.X + ActorToDodge.CollisionHeight ) >=
			( VerticalDistance + Inquirer.Location.Z - Inquirer.CollisionHeight ) )
	{
		VerticalDistance = 0; // jumping won't help
	}
	class'Debug'.static.DebugLog( Inquirer, "FindDodgeDestination VerticalDistance " $ VerticalDistance, default.DebugCategoryName );
*/
	class'Debug'.static.DebugLog( Inquirer, "FindDodgeDestination HorizontalDistance " $ HorizontalDistance, default.DebugCategoryName );
	PursuerDirection = Normal( ActorToDodge.Velocity );
	DodgeDirection.Z = 0;
	DodgeDirection.x = -PursuerDirection.y;
	DodgeDirection.y = PursuerDirection.x;
	DodgeDirection = Normal( DodgeDirection );
	
	if( FRand() < 0.5 )
	{
		//try left, then right
		if( IsActorDestinationUnobstructed( Inquirer, DodgeDirection, HorizontalDistance ) )
		{
			bUnobstructed = true;
		}
		else if( IsActorDestinationUnobstructed( Inquirer, DodgeDirection *= -1.0, HorizontalDistance ) )
		{
			bUnobstructed = true;
		}
	}
	else
	{
		//try right, then left
		if( IsActorDestinationUnobstructed( Inquirer, DodgeDirection *= -1.0, HorizontalDistance ) )
		{
			bUnobstructed = true;
		}
		else if( IsActorDestinationUnobstructed( Inquirer, DodgeDirection *= -1.0, HorizontalDistance ) )
		{
			bUnobstructed = true;
		}
	}
	
	if( bUnobstructed )
	{
		DodgeDestination = Inquirer.Location + ( DodgeDirection * HorizontalDistance );
	}
/*
	else if( ( Inquirer.Physics != PHYS_Falling ) && ( VerticalDistance != 0 ) )
	{
		if( IsActorDestinationUnobstructed( Inquirer, Vect( 0, 0, 1 ), VerticalDistance ) )
		{
			bUnobstructed = true;
			//try "jumping" if not already in the air
			DodgeDestination = Inquirer.Location + Vect( 0, 0, 1 ) * VerticalDistance;
		}
	}
*/	
	class'Debug'.static.DebugLog( Inquirer, "FindDodgeDestination Distance " $ VSize( DodgeDestination - Inquirer.Location ), default.DebugCategoryName );
	class'Debug'.static.DebugLog( Inquirer, "FindDodgeDestination DodgeDestination: " $ DodgeDestination, default.DebugCategoryName );
	class'Debug'.static.DebugLog( Inquirer, "FindDodgeDestination returning " $ bUnobstructed, default.DebugCategoryName );
	return bUnobstructed;
}	



//=============================================================================
// Returns true if the given actor can be moved ShiftDistance units along the 
// given ShiftDir. Makes sure that the collision cylinder will fit along the
// trace from the actor's current location to the new location.
//=============================================================================
static function bool IsActorDestinationUnobstructed( Actor Inquirer, Vector ShiftDir, float ShiftDistance )
{				
	local Vector TraceHitLocation, TraceHitNormal, TraceExtents;
	local Actor TraceHitActor;
	TraceExtents.X = Inquirer.CollisionRadius;
	TraceExtents.Y = Inquirer.CollisionRadius;
	TraceExtents.Z = Inquirer.CollisionHeight;
	//trace from actor's location ShiftDistance units along ShiftDir using extents	
	TraceHitActor = Inquirer.Trace( TraceHitLocation, TraceHitNormal, Inquirer.Location + ShiftDistance * ShiftDir, Inquirer.Location, false, TraceExtents );
	return ( ( TraceHitActor == None ) || ( VSize( TraceHitLocation - Inquirer.Location ) >= ShiftDistance ) );
}

defaultproperties
{
     DebugCategoryName=MovementManager
}
