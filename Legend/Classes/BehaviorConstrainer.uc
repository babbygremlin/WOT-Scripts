//=============================================================================
// BehaviorConstrainer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class BehaviorConstrainer expands AiComponent;

var () float MaxDistance;		//used by GetCurrentMaxDistance
var () float MinDistance;		//used by GetCurrentMinDistance
var () Rotator MinDeltaRotation;	//used by FindUnobstructedDestination and DetermineRotation

//if the moveto distance is less than this number the pawn will never reach its destination
const MagicMinDistance = 16;						//used by GetCurrentMinDistance
const FindUnobstructedDestinationMaxDeltaYaw = 16384;	//used by FindUnobstructedDestination (within 90 degrees)
const FindUnobstructedDestinationDeltaYaw = 500;	//used by FindUnobstructedDestination


function float GetCurrentMaxMeleeDistance( Actor ConstrainedActor )
{
	local Pawn ConstrainedPawn;
	local float MaxMeleeDistance;
	
	ConstrainedPawn = Pawn( ConstrainedActor );
	
	if( ConstrainedPawn != none )
	{
		MaxMeleeDistance = ConstrainedPawn.MeleeRange;
	}
	return MaxMeleeDistance;
}



function float GetCurrentMaxGuardDistance( Actor ConstrainedActor )
{
	local LegendPawn ConstrainedLegendPawn;
	local float MaxGuardDistance;
	
	ConstrainedLegendPawn = LegendPawn( ConstrainedActor );
	
	if( ConstrainedLegendPawn != none )
	{
		MaxGuardDistance = ConstrainedLegendPawn.GoalPriorityDistances[ ConstrainedLegendPawn.GoalIndex( GI_Guarding ) ];
	}
	return MaxGuardDistance;
}



function float GetCurrentMaxFindHelpDistance( Actor ConstrainedActor )
{
	return 0;
}



function float GetCurrentMinTravelDistance( Actor ConstrainedActor )
{
	return Max( MinDistance, MagicMinDistance );
}



function float GetCurrentMaxTravelDistance( Actor ConstrainedActor )
{
	return FMax( MaxDistance, GetCurrentMinTravelDistance( ConstrainedActor ) );
}



//This function determines the minimum distance that must be
//present between the constrained actor and the goal. 
function float GetMinimumGoalDistance( Actor ConstrainedActor, GoalAbstracterInterf Goal )
{
	local float MinimumGoalDistance;
	local Vector GoalLocation;
	local float GoalRadius, GoalHalfHeight;
	
	MinimumGoalDistance = ConstrainedActor.CollisionRadius;
	
	if( Goal.GetGoalParams( ConstrainedActor, GoalLocation, GoalRadius, GoalHalfHeight ) )
	{
		//Log( ConstrainedActor $ "::BehaviorConstrainer::GetMinimumGoalDistance" );
		//Log( ConstrainedActor $ "		goal radius " $ GoalRadius );
		//Log( ConstrainedActor $ "		actor radius " $ ConstrainedActor.CollisionRadius );
		MinimumGoalDistance += GoalRadius;
	}
	
	//Log( ConstrainedActor $ "::BehaviorConstrainer::GetMinimumGoalDistance returning " $ MinimumGoalDistance );
	return MinimumGoalDistance;
}



/*
AdjustTwoDimensionalDistance:

Adjust the two dimensional distance between the pawn's current location and the
PreferredDestination so that it is no less than DistanceReduction

if the distance between the pawn's current location and the preferred destination is
greater than the proposed distance reduction, the PreferredDestination is moved toward
the pawn's current location to accomodate the reduction.

if the distance between the pawn's current location and the preferred destination is
less than the proposed distance reduction, the PreferredDestination is moved away from
the pawn's current location in the opposite direction so that the distance is no less
than DistanceReduction.
*/

function Adjust2dDistance( out Vector PreferredDestination, Actor ConstrainedActor, optional float DistanceReduction )
{
	local Vector Offset, Difference;
	local float DistanceToDestination;
	local float DeltaMagnitude;
	
/*
	//get the two dimensional distance between the pawn's current loation and the PreferredDestination
	Offset = PreferredDestination - Location; //get the destination vector without concern for the Z

	//Log( ConstrainedActor $ "::Adjust2dDistance Offset " $ Offset );

	Offset.Z = 0; //ignore the change in z
	
	DistanceToDestination = VSize( Offset );
	
	if( DistanceToDestination > DistanceReduction )
	{
		//slide the destination toward the current location
		//Log( ConstrainedActor $ "::Adjust2dDistance just move less" );
		DeltaMagnitude = DistanceReduction;
	}
	else if( DistanceToDestination < DistanceReduction )
	{
		//slide the destination further away from the current location
		//Log( ConstrainedActor $ "::Adjust2dDistance slide away" );
		DeltaMagnitude = -( DistanceReduction - DistanceToDestination );
	}
	else
	{
		//Log( ConstrainedActor $ "::Adjust2dDistance just right" );
		DeltaMagnitude = 0;
	}
	
	//xxx THIS IS WRONG!!! the the distance on the xy plane is not sufficient to use as the reduction
	Offset = Normal( PreferredDestination - Location ) * DeltaMagnitude;

	//ajust the destination by the offset
	PreferredDestination = PreferredDestination - Offset;
*/
}



function float BoundMagnitude( Actor ConstrainedActor, float PreferredMagnitude )
{
	local float MinDistanceUsed, DeterminedMagnitude, AbsPreferredMagnitude;
	
	AbsPreferredMagnitude = Abs( PreferredMagnitude );
	
	if( AbsPreferredMagnitude > GetCurrentMaxTravelDistance( ConstrainedActor ) )
	{
		//clip the magnitude to the max distance
		DeterminedMagnitude = GetCurrentMaxTravelDistance( ConstrainedActor );
	}
	else
	{
		MinDistanceUsed = GetCurrentMinTravelDistance( ConstrainedActor );
		if( AbsPreferredMagnitude < MinDistanceUsed )
		{
			DeterminedMagnitude = -( MinDistanceUsed - DeterminedMagnitude );
		}
		else
		{
			DeterminedMagnitude = AbsPreferredMagnitude;
		}
	}
	
	if( PreferredMagnitude < 0 )
	{
		DeterminedMagnitude = -DeterminedMagnitude;
	}
	
	return DeterminedMagnitude;
}



/*
BoundDestinationDistance

Adjusts the preferred destination by bounding the magnitude of the vector between the
pawn's current location and the preferred destination.
*/
function BoundDestinationDistance( out Vector PreferredDestination, Actor ConstrainedActor )
{
	local float RawDistance, NewMagnitude;
	local Vector Difference;
	
	Difference = PreferredDestination - ConstrainedActor.Location;
	RawDistance = VSize( Difference );
	NewMagnitude = BoundMagnitude( ConstrainedActor, RawDistance );

	if( NewMagnitude != RawDistance )
	{
		//the magnitude needs to be reduced but the actor is still going to move
		PreferredDestination = ConstrainedActor.Location + Normal( Difference ) * NewMagnitude;
	}
}


function bool IsTravelDistanceToSmall( Actor ConstrainedActor, float PreferredDistance )
{
	return int( PreferredDistance ) < GetCurrentMinTravelDistance( ConstrainedActor );
}


function bool FindUnobstructedActorDestination( out Vector UnobstructedDestination,
		Vector PreferredDestination,
		Actor MovingActor )
{
	return FindUnobstructedDestination( UnobstructedDestination,
			PreferredDestination,
			MovingActor,
			GetCurrentMinTravelDistance( MovingActor ),
			MinDeltaRotation.Yaw,
			FindUnobstructedDestinationMaxDeltaYaw,
			FindUnobstructedDestinationDeltaYaw );
}



/*
FindUnobstructedDestination:

Attempts to find an unobstructed destination based on the preferred destination.
If the path between the pawn's current location and the preferred destination is
unobstructed then the preferred destination is returned unchanged. Otherwise, an
alternate destination is searched for based upon the distance between the pawn's
current location and the preferred destination. An acceptable alternate destination
is searched for by first reducing the distance traveled for the rotation attempted
and then varying the rotation.
*/
function bool FindUnobstructedDestination( out Vector UnobstructedDestination,
		Vector PreferredDestination,
		Actor MovingActor,
		optional float MinReducedDistance,
		optional float MinDeltaYaw,
		optional float MaxDeltaYaw,
		optional float DeltaYaw )
{
	local int PreferredYaw, CurrentDeltaYaw, CurrentPawnYaw;
	local float PreferredDistance, ReducedDistance, PawnStepHeight;
	local bool bPathFound;

	local Vector TraceHitLocation, TraceHitNormal, TraceExtent;
	local Actor TraceHitActor;
	local int DeltaYawFromCurrent;
	
	local Rotator CurrentRotationUsed;
	local Vector CurrentDestinationUsed;

	//Log( ConstrainedActor $ "::FindUnobstructedDestination" );
	//Log( ConstrainedActor $ "		PreferredDestination: " $ PreferredDestination );
	//Log( ConstrainedActor $ "		MinReducedDistance: " $ MinReducedDistance );
	//Log( ConstrainedActor $ "		MinDeltaYaw: " $ MinDeltaYaw );
	//Log( ConstrainedActor $ "		MaxDeltaYaw: " $ MaxDeltaYaw );
	//Log( ConstrainedActor $ "		DeltaYaw: " $ DeltaYaw );
	
	//xxx UnobstructedDestination = PreferredDestination;
	//xxx return true;

	TraceExtent.X = MovingActor.CollisionRadius;
	TraceExtent.Y = MovingActor.CollisionRadius;
	TraceExtent.Z = MovingActor.CollisionHeight;
	
	PreferredDistance = VSize( PreferredDestination - MovingActor.Location );
	CurrentRotationUsed = Rotator( PreferredDestination - MovingActor.Location );
	
	PreferredYaw = CurrentRotationUsed.Yaw;
	CurrentPawnYaw = MovingActor.Rotation.Yaw;
	
	PawnStepHeight = Pawn( MovingActor ).MaxStepHeight;

	for( CurrentDeltaYaw = 0;
			( ( abs( CurrentDeltaYaw ) < MaxDeltaYaw ) && !bPathFound );
			CurrentDeltaYaw = CurrentDeltaYaw )
	{
		CurrentRotationUsed.Yaw = PreferredYaw + CurrentDeltaYaw;
		DeltaYawFromCurrent = Abs( Normalize( CurrentRotationUsed -
				MovingActor.Rotation ).Yaw );
		
		if(  DeltaYawFromCurrent < MinDeltaYaw )
		{
			CurrentDestinationUsed = PreferredDestination;
		}
		else
		{
			CurrentDestinationUsed = MovingActor.Location +
					Vector( CurrentRotationUsed ) * PreferredDistance;
		}
		
		foreach MovingActor.TraceActors( class'Actor', TraceHitActor,
				TraceHitLocation, TraceHitNormal, CurrentDestinationUsed,
				MovingActor.Location, TraceExtent )
		{
			if( TraceHitActor.IsA( 'LevelInfo' ) || ( TraceHitActor.bBlockActors ) )
			{
				break;
			}
/*
			else if( MovingActor.IsA( 'Pawn' ) )
			{
				if( TraceHitActor.bBlockActors /* && ( VSize( TraceHitActor.Velocity ) ~= 0 )*/ )
				{
					//the trace hit actor blocks actor and is not moving
					if( ( TraceHitActor.CollisionHeight * 2 ) > PawnStepHeight )
					{
						//the pawn can not step over the obstruction
						break;
					}
				}
			}
*/
			//the actor hit by the trace was not the level or a blocking actor
			TraceHitActor = none;
		}
		
		if( TraceHitActor == none )
		{
			UnobstructedDestination = CurrentDestinationUsed;
			bPathFound = true;
		}
		else
		{
			//the trace hit something so try reducing the distance
			//something is blocking the direct path to the current destination
			ReducedDistance = VSize( TraceHitLocation - MovingActor.Location );
			
			//Log( ConstrainedActor $ "::FindUnobstructedDestination" );
			//Log( ConstrainedActor $ "		TraceHitActor " $ TraceHitActor );
			//Log( ConstrainedActor $ "		TraceHitLocation " $ TraceHitLocation );
			//Log( ConstrainedActor $ "		ReducedDistance " $ ReducedDistance );
			
			if( ReducedDistance >= MinReducedDistance )
			{
				UnobstructedDestination = MovingActor.Location +
						Vector( CurrentRotationUsed ) * ReducedDistance;
				bPathFound = true;
			}
		}
		
		CurrentDeltaYaw = -CurrentDeltaYaw;
		
		if( CurrentDeltaYaw >= 0 )
		{
			//rotating to the right and the left has already been checked
			//increment the change in yaw and check rotating to the right
			CurrentDeltaYaw += DeltaYaw;
		}
	}
	
	return bPathFound;
}



function bool ConstrainActorFocus( out Vector ConstrainedFocus,
		Vector PreferredFocus,
		Actor ConstrainedActor )
{
	local Rotator ConstrainedFocusRotation;
	return ConstrainActorFocusAndRotation( ConstrainedFocus, ConstrainedFocusRotation,
			PreferredFocus, ConstrainedActor );	
}



function bool ConstrainActorFocusAndRotation( out Vector ConstrainedFocus,
		out Rotator ConstrainedFocusRotation,
		Vector PreferredFocus,
		Actor ConstrainedActor )
{
	local Rotator PreferredRotation;
	local Vector VectorDifference;
	local bool bFocusRotationConstrained;
	
	//Log( ConstrainedActor $ "::BehaviorConstrainer::ConstrainFocus" );
	VectorDifference = PreferredFocus - ConstrainedActor.Location;
	PreferredRotation = Rotator( VectorDifference );
	
	bFocusRotationConstrained = ConstrainActorRotation( ConstrainedFocusRotation,
			PreferredRotation, ConstrainedActor );

	if( bFocusRotationConstrained )
	{
		ConstrainedFocus = ConstrainedActor.Location +
				( Vector( ConstrainedFocusRotation ) * VSize( VectorDifference ) );
	}
	else
	{
		ConstrainedFocus = PreferredFocus;
	}

	//Log( ConstrainedActor $ "::ConstrainActorFocusAndRotation ConstrainedActor.Location: " $ ConstrainedActor.Location );
	//Log( ConstrainedActor $ "::ConstrainActorFocusAndRotation ConstrainedActor.Rotation: " $ ConstrainedActor.Rotation );
	//Log( ConstrainedActor $ "::ConstrainActorFocusAndRotation VectorDifference: " $ VectorDifference );
	//Log( ConstrainedActor $ "::ConstrainActorFocusAndRotation PreferredRotation: " $ PreferredRotation );
	//Log( ConstrainedActor $ "::ConstrainActorFocusAndRotation ConstrainedFocusRotation: " $ ConstrainedFocusRotation );
	//Log( ConstrainedActor $ "::ConstrainActorFocusAndRotation ConstrainedFocus: " $ ConstrainedFocus );
	//Log( ConstrainedActor $ "::ConstrainActorFocusAndRotation PreferredFocus: " $ PreferredFocus );

	return bFocusRotationConstrained;
}



//Adjust the preferred rotation to accommodate the constraints of how this acor is allowed to move
//The constraint's MinimumDeltaRotation is used to adjust the sensitivity of the returned rotation.
//If any of the components of the propose new rotation are less than that of the corresponding
//component in MinimumDeltaRotation then the pawns current rotation component is retained.
function bool ConstrainActorRotation( out Rotator ConstraindeRotation,
		Rotator PreferredRotation,
		Actor ConstrainedActor )
{
	local Rotator RotationDifference, AbsRotationDifference;

	//Log( ConstrainedActor $ "::BehaviorConstrainer::ConstrainActorRotation" );
	RotationDifference = Normalize( PreferredRotation - ConstrainedActor.Rotation );
	AbsRotationDifference.Roll = abs( RotationDifference.Roll );
	AbsRotationDifference.Pitch = abs( RotationDifference.Pitch );
	AbsRotationDifference.Yaw = abs( RotationDifference.Yaw );
	ConstraindeRotation = PreferredRotation;

	//if the change in this component is less than the minimum allowable change
	//or there is no change in the value of this component

	//if any component of the RotationRate member is zero then
	//retain the corresponding value of the current rotation

	if( ( AbsRotationDifference.Roll == 0 ) ||
			( ConstrainedActor.RotationRate.Roll < AbsRotationDifference.Roll ) ||
			( ConstrainedActor.RotationRate.Roll == 0 ) )
	{
		ConstraindeRotation.Roll = ConstrainedActor.Rotation.Roll;
	}
	else if( AbsRotationDifference.Roll < MinDeltaRotation.Roll )
	{
		ConstraindeRotation.Roll = ConstrainedActor.Rotation.Roll;
	}
	else if( AbsRotationDifference.Roll < MinDeltaRotation.Roll )
	{
		ConstraindeRotation.Roll = ConstrainedActor.Rotation.Roll +
				AbsRotationDifference.Roll / RotationDifference.Roll *
				MinDeltaRotation.Roll;
	}

	if( ( AbsRotationDifference.Pitch == 0 ) ||
			( ConstrainedActor.RotationRate.Pitch < AbsRotationDifference.Pitch ) ||
			( ConstrainedActor.RotationRate.Pitch == 0 ) )
	{
		ConstraindeRotation.Pitch = ConstrainedActor.Rotation.Pitch;
	}
	else if( AbsRotationDifference.Pitch < MinDeltaRotation.Pitch )
	{
		ConstraindeRotation.Pitch = ConstrainedActor.Rotation.Pitch;
	}
	else if( AbsRotationDifference.Pitch < MinDeltaRotation.Pitch )
	{
		ConstraindeRotation.Pitch = ConstrainedActor.Rotation.Pitch +
				AbsRotationDifference.Pitch / RotationDifference.Pitch *
				MinDeltaRotation.Pitch;
	}

	if( ( AbsRotationDifference.Yaw == 0 ) ||
			( ConstrainedActor.RotationRate.Yaw < AbsRotationDifference.Yaw ) ||
			( ConstrainedActor.RotationRate.Yaw == 0 ) )
	{
		ConstraindeRotation.Yaw = ConstrainedActor.Rotation.Yaw;
	}
	else if( AbsRotationDifference.Yaw < MinDeltaRotation.Yaw )
	{
		ConstraindeRotation.Yaw = ConstrainedActor.Rotation.Yaw;
	}
	else if( AbsRotationDifference.Yaw < MinDeltaRotation.Yaw )
	{
		ConstraindeRotation.Yaw = ConstrainedActor.Rotation.Yaw +
				AbsRotationDifference.Yaw / RotationDifference.Yaw *
				MinDeltaRotation.Yaw;
	}

	//Log( ConstrainedActor $ "::ConstrainActorRotation ConstrainedActor.RotationRate: " $ ConstrainedActor.RotationRate );
	//Log( ConstrainedActor $ "::ConstrainActorRotation ConstrainedActor.Rotation: " $ ConstrainedActor.Rotation );
	//Log( ConstrainedActor $ "::ConstrainActorRotation RotationDifference: " $ RotationDifference );
	//Log( ConstrainedActor $ "::ConstrainActorRotation AbsRotationdifference: " $ AbsRotationDifference );
	//Log( ConstrainedActor $ "::ConstrainActorRotation PreferredRotation: " $ PreferredRotation );
	//Log( ConstrainedActor $ "::ConstrainActorRotation ConstrainedRotation: " $ ConstraindeRotation );

	return ( ConstraindeRotation != PreferredRotation );
}

defaultproperties
{
     MaxDistance=50.000000
     MinDistance=16.000000
     MinDeltaRotation=(Yaw=2000)
}
