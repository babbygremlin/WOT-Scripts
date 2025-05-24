//=============================================================================
// WaypointSelectorApproaching.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 5 $
//=============================================================================

class WaypointSelectorApproaching expands WaypointSelector;

var () float AnticipatedTravelDistance;
var () float MinOffsetDistance;
var () float MaxOffsetDistance;


static function bool GetMovementDestination( GoalAbstracterInterf MovementGoal,
		Actor MovingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local bool bGotDestination;
	local Vector GoalLocation;
	class'Debug'.static.DebugLog( MovingActor, "GetMovementDestination", 'WaypointSelectorApproaching' );
	//return GetMovementDestination2( MovementGoal, MovingActor, Constrainer, Goal );
	if( Goal.GetGoalLocation( MovingActor, GoalLocation ) )
	{
		bGotDestination = SelectTraceWaypoint( MovementGoal, MovingActor, GoalLocation );
	}
	class'Debug'.static.DebugLog( MovingActor, "GetMovementDestination returing " $ bGotDestination, 'WaypointSelectorApproaching' );
	return bGotDestination;
}



static function bool SelectTraceWaypoint( GoalAbstracterInterf MovementGoal, Actor MovingActor, Vector GoalLocation )
{
	local bool bSelectTraceWaypoint;
	local Vector GoalDirection, GoalVector, IntendedDestination, OffsetAnchor;
	local float TraceDistance, TraceEndHeightAdjust, OffsetDistance, DeltaZ, ProjectedDistance;
	local int Iter;
	
	GoalVector = GoalLocation - MovingActor.Location;
	DeltaZ = GoalVector.Z;
	GoalVector.Z = 0;
	ProjectedDistance = VSize( GoalVector );
	
	if( DeltaZ >= ProjectedDistance )
	{
		//greater than a 45 degree angle
		//force to a max of 45 degrees
		GoalVector.Z = ProjectedDistance;
		TraceDistance = Sqrt( ( default.AnticipatedTravelDistance * default.AnticipatedTravelDistance ) +
				( default.AnticipatedTravelDistance* default.AnticipatedTravelDistance ) );
	}
	else
	{
		//less than a 45 degree angle (thats groovy)
		GoalVector.Z = DeltaZ;
		TraceDistance = default.AnticipatedTravelDistance / Cos( Atan( DeltaZ / ProjectedDistance ) );
	}
		
	GoalDirection = Normal( GoalVector );
	OffsetAnchor = ( GoalDirection Cross vect( 0, 0, 1 ) );
	assert( OffsetAnchor.Z == 0 );
	
	TraceEndHeightAdjust = ( Abs( GoalVector.Z ) + 2 * MovingActor.CollisionHeight );
	OffsetDistance = MovingActor.RandRange( default.MinOffsetDistance, default.MaxOffsetDistance );
	
	for( Iter = 0; Iter < 3; Iter++ )
	{
		switch( Iter )
		{
			case 0:
				//try to go straight towards the goal
				IntendedDestination = MovingActor.Location + GoalDirection * TraceDistance;
				break;
			case 1:
			case 2:
				IntendedDestination = MovingActor.Location + ( OffsetAnchor * OffsetDistance ) + ( GoalDirection * TraceDistance );
				OffsetDistance *= -1;
				break;
			default:
				assert( false );
				break;
		}
		
		//MovingActor.DM( MovingActor $ "SelectTraceWaypoint Iter " $ Iter );
		if( DoTraceStuff( MovementGoal, MovingActor, IntendedDestination, TraceEndHeightAdjust ) )
		{
			bSelectTraceWaypoint = true;
			break;
		}
	}
	
	return bSelectTraceWaypoint;
}



static function bool DoTraceStuff( GoalAbstracterInterf MovementGoal, Actor MovingActor, Vector IntendedDestination, float TraceEndHeightAdjust )
{
	local bool bGotDestination;
	local Vector TraceHitLocation, TraceHitNormal, TraceExtent, TraceEnd;
	local Actor TraceHitActor;
	
	TraceExtent.X = MovingActor.CollisionRadius;
	TraceExtent.Y = MovingActor.CollisionRadius;
	//TraceExtent.Z = FMax( 6, MovingActor.CollisionHeight - 18 );

	TraceEnd = IntendedDestination;
	TraceHitActor = MovingActor.Trace( TraceHitLocation, TraceHitNormal, TraceEnd, MovingActor.Location, false, TraceExtent );
	//TraceHitActor = class'Util'.static.VisibleTrace( MovingActor, TraceHitLocation, TraceHitNormal, TraceEnd, MovingActor.Location, false, TraceExtent );
	class'Debug'.static.DebugLog( MovingActor, "GetMovementDestination TraceHitActor0 " $ TraceHitActor, 'WaypointSelectorApproaching' );
	if( TraceHitActor == None )
	{
		TraceEnd.Z -= TraceEndHeightAdjust;
		TraceHitActor = MovingActor.Trace( TraceHitLocation, TraceHitNormal, TraceEnd, IntendedDestination, false, TraceExtent );
		//TraceHitActor = class'Util'.static.VisibleTrace( MovingActor, TraceHitLocation, TraceHitNormal, TraceEnd, IntendedDestination, false, TraceExtent );
		class'Debug'.static.DebugLog( MovingActor, "GetMovementDestination TraceHitActor1 " $ TraceHitActor, 'WaypointSelectorApproaching' );
		if( TraceHitActor != None )
		{
			MovementGoal.AssignVector( MovingActor, TraceHitLocation );
			if( MovementGoal.IsGoalNavigable( MovingActor ) )
			{
				class'Debug'.static.DebugLog( MovingActor, "GetMovementDestination returing " $ true, 'WaypointSelectorApproaching' );
				bGotDestination = true;
			}
		}
	}
	return bGotDestination;
}



static function bool GetMovementDestination2( GoalAbstracterInterf MovementGoal,
		Actor MovingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local bool bGotDestination;
	local ItemSorter NavigPointSorter;
	local Actor GoalActor, CurrentItem, NavigActor;
	local Pawn GoalPawn, MovingPawn;
	local int i, ItemCount;
	
	class'Debug'.static.DebugLog( MovingActor, "GetMovementDestination", 'WaypointSelectorApproaching' );
	if( MovingActor.IsA( 'Pawn' ) && Goal.GetGoalActor( MovingActor, GoalActor ) && GoalActor.IsA( 'Pawn' ) )
	{
		GoalPawn = Pawn( GoalActor );
		MovingPawn = Pawn( MovingActor );
		
		NavigPointSorter = ItemSorter( class'Singleton'.static.GetInstance( MovingActor.XLevel, class'ItemSorter' ) );
		NavigPointSorter.CollectRadiusItems( GoalActor, class'NavigationPoint', 320 );
		NavigPointSorter.InitSorter();
		NavigPointSorter.SortItems();
		
	class'Debug'.static.DebugLog( MovingActor, "GetMovementDestination GoalPawn " $ GoalPawn, 'WaypointSelectorApproaching' );
	class'Debug'.static.DebugLog( MovingActor, "GetMovementDestination MovingPawn " $ MovingPawn, 'WaypointSelectorApproaching' );

		if( NavigPointSorter.GetItemCount( ItemCount ) )
		{
			for( i = 0; i < ItemCount; i++ )
			{
				CurrentItem = NavigPointSorter.GetItem( i );
	class'Debug'.static.DebugLog( MovingActor, "GetMovementDestination CurrentItem " $ CurrentItem, 'WaypointSelectorApproaching' );
				if( GoalPawn.ActorReachable( CurrentItem ) )
				{
					MovementGoal.AssignObject( MovingPawn, CurrentItem );
					if( MovementGoal.IsGoalReachable( MovingPawn ) )
					{
						bGotDestination = true;
						break;
					}
					else
					{
						NavigActor = MovingPawn.FindPathToward( CurrentItem );
						if( NavigActor != None )
						{
							MovementGoal.AssignObject( MovingPawn, NavigActor );
							bGotDestination = true;
							break;
						}
						else
						{
			      			NavigPointSorter.RejectItem( i );
						}
					}
				}
				else
      			{
	      			NavigPointSorter.RejectItem( i );
	    	    }
			}
		}
	}
	
	class'Debug'.static.DebugLog( MovingActor, "GetMovementDestination returing " $ bGotDestination, 'WaypointSelectorApproaching' );
	return bGotDestination;
}

defaultproperties
{
     AnticipatedTravelDistance=160.000000
     MinOffsetDistance=128.000000
     MaxOffsetDistance=192.000000
}
