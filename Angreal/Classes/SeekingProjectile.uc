//------------------------------------------------------------------------------
// SeekingProjectile.uc
// $Author: Mfox $
// $Date: 1/12/00 9:32p $
// $Revision: 11 $
//
// Description:	Launches Seeking projectiles.  If they don't have a destination,
//				they just go -- like generic projectils.  However, if they
//				have a destination, they will track down the destination 
//				using the path nodes within a level until it explodes.
//				Normally you don't want it to explode until it reaches its
//				destination.
//------------------------------------------------------------------------------
// How to use this class:
// 
// + Subclass and handle exceptions like overriding Explode() to draw 
//   visual effects and then call Super.Explode() to take care of damage.
// + Other exceptions would include changing to a water zone where you might
//   want to destroy the projectile and create a visual/audio effect.
// + Set InitalSpeed, MaxSpeed and Acceration.
//------------------------------------------------------------------------------
class SeekingProjectile expands GenericProjectile
	abstract;
    
var() float AccelPerSec;			// Seeking projectiles speed up while seeking 
									// to gaurantee they eventually catch up.
var float Acceleration;				// Keeps track of our current acceleration.  
									// Acceleration is increased using AccelPerSec.
									// This allows Speed to increase exponentially
									// instead of linearly.
									// Initialized to 1 unit per second per second.

var Actor Destination;				// Where do you want to go today?

var int PlayerID;					// Used to keep track of which instance of the
									// player we are going after so we don't 
									// continue to go after them when they die.

var PathNodeIteratorII PNI;			// Our roadmap.

var NavigationPoint NavPoint;		// Where we're going.
var NavigationPoint LastPoint;		// Last valid NavPoint used for navigation.
var NavigationPoint RestrictedPoint;// We're not allowed to use this path node.

var() float PathCheckResolution;	// When we are checking the path, how often
									// should we check?
var float PathCheckTimer;			// Timer used to restrict expensive checking.

var() bool bTakeShortcuts;			// Should this seeker take short cuts, or
									// follow the paths explicitly?

var() bool bDesperateSeeker;		// In the event that we cannot build a true,
									// unobstructed path to our destination, should
									// we try instead to simply get as close as possible?

var() float ReachTolerance;			// The distance we can be away from our
									// destination before we are considered to
									// have reached it.

var bool bServerReachedDest;		// Have we reached our destination?
									// (Replicated to clients because server is
									// authoritative on this subject.)

var() bool bNotifiesDestination;	// Do we notify our destination that we are seeking it?

var() bool bAlignToVelocity;		// Do we keep our rotation in sync with our velocity?

// Do we collide with the world while we are seeking?
var(Collision) bool bCollideWorldWhileSeeking;

// Server authoritative decisions to be replicated to clients.
var bool bSeeking;
var bool bDestExists;

// Sent to clients if their destination isn't valid/relevant.
var vector DestLoc;

// Used to disable calls to CalcNextDirection.
var bool bDisableCalcNextDirection;

var bool bWasSeeking;

// Used to keep clients and servers relatively in sync.
var() float BroadcastLocationTime;
var float LocationTimer;
var vector ServerLocation;
var vector LastServerLocation;
var() float DeltaTimeTolerance;	// Maximum amount of time a seeker is allowed to get out of sync with the server.
//var NavigationPoint ServerNavPoint;

replication
{
	// Send to clients when changes.
	reliable if( Role==ROLE_Authority )
		bSeeking, bDestExists, bServerReachedDest;

	// Send to clients if relevant.
	reliable if( Role==ROLE_Authority )//&& (Destination==None || Destination.bNetRelevant) )	// Fix ARL: Remove second check once Tim sends network fix.
		Destination;

	// Send to clients if their destination isn't valid/relevant.
	unreliable if( Role==ROLE_Authority && Destination!=None ) //&& !Destination.bNetRelevant )
		DestLoc;

	// Used in case client prediction gets messed up something fierce.
	unreliable if( Role==ROLE_Authority )
		ServerLocation/*, ServerNavPoint*/;

	reliable if( Role==ROLE_Authority && bNetInitial )
		Acceleration;
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Role < ROLE_Authority && bExplode )
	{
		Explode( Location, vect(0,0,1) );
	}

	if( Role == ROLE_Authority && bNotifiesDestination && WOTPlayer(Destination) != None )
	{
		WOTPlayer(Destination).DecrementSeekerCount();
	}

	if( PNI != None )
	{
		PNI.Destroy();
		PNI = None;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated singular function Tick( float DeltaTime )
{
	local Actor HitA;
	local vector HitLoc, HitNorm;
	local vector NewLoc;
/*
	// Manually update location if needed.
	if( Physics == PHYS_None )
	{
		NewLoc = Location + Velocity * DeltaTime;

		// See if we hit anything, and update location accordingly.
		HitA = Trace( HitLoc, HitNorm, NewLoc, Location, true );
		if( HitA != None && Destination == HitA )	// Only send notifications if we hit our destination.
		{
			SetLocation( HitLoc );
			ProcessTouch( HitA, HitLoc );
		}
		else
		{
			SetLocation( NewLoc );
		}
	}
*/
	// Server: Remember the destination's location in case we have to 
	//         send it to the client.
	// Client: Store the last known good location of our destination
	//         in case we lose our destination due to rules of relevancy.
	if( Destination != None )
	{
		DestLoc = Destination.Location;
	}

	if( Role < ROLE_Authority )		// ### Begin client code ###
	{
		// Make sure we get put into the seeking state if we should be since 
		// SetDestination will never be called on the client side.
		if( bSeeking && GetStateName() != 'Seeking' )
		{
			GotoState('Seeking');
		}
		else if( !bSeeking && GetStateName() == 'Seeking' )
		{
			GotoState('');
		}

		// Make sure we don't get really out of sync with the server.
		if( ServerLocation != LastServerLocation )
		{
			LastServerLocation = ServerLocation;
			if( VSize(ServerLocation - Location) > Speed * DeltaTimeTolerance )
			{
				SetLocation( ServerLocation );

				// Make sure we're heading the right direction.
/*
				if( NavPoint != ServerNavPoint && ServerNavPoint != None )
				{
					NavPoint = ServerNavPoint;
					SetVelocity( Speed * Normal( NavPoint.Location - Location ) );
				}
*/
				CalcNextDirection();
			}
		}
	}
	else							// ### Begin server code ###
	{
		// Occationally send location updates to the clients.
		LocationTimer += DeltaTime;
		if( LocationTimer >= BroadcastLocationTime )
		{
			LocationTimer = 0;
			ServerLocation = Location;
//			ServerNavPoint = NavPoint;
		}
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
// See seeking state.
//------------------------------------------------------------------------------
simulated function CalcNextDirection( optional bool bDesperate );

//------------------------------------------------------------------------------
// Can be used to set or change our current destination.
// When a destination is set, we go into our seeking state to track our
// destination down.
//------------------------------------------------------------------------------
simulated function SetDestination( Actor Dest )
{
	// Only work on client-side for bNetTemporary objects.
	if( Role < ROLE_Authority && !bNetTemporary )
	{
		return;
	}

	// Notify un-seeking previous destinaiton.
	if( bNotifiesDestination && WOTPlayer(Destination) != None )
	{
		WOTPlayer(Destination).DecrementSeekerCount();
	}
	
	// Set new destination.
	Destination = Dest;

	// Notify seeking new destination.
	if( bNotifiesDestination && WOTPlayer(Destination) != None )
	{
		WOTPlayer(Destination).IncrementSeekerCount();
	}

	if( Destination != None )
	{
		// Send the location to the client when the Destination is first set 
		// in case the Destination is None on the client-side.
		// (Due to relevancy.)
		DestLoc = Destination.Location;
		
		if( WOTPlayer(Destination) != None )
		{
			WOTPlayer(Destination).NotifyTargettedByAngrealProjectile( Self );
			PlayerID = WOTPlayer(Destination).NumDeaths;
		}
		else if( WOTPawn(Destination) != None )
		{
			WOTPawn(Destination).NotifyTargettedByAngrealProjectile( Self );
		}
		GotoState('Seeking');
	}
	else
	{
		GotoState('');
	}
}

///////////////////
// Notifications //
///////////////////

//------------------------------------------------------------------------------
// Notification when we cannot reach our destination using the current
// set of path nodes in the level.  If this happens, the level designers should
// probably fix the level so it has more path nodes.
//------------------------------------------------------------------------------
simulated function CannotReachDestination()
{
/*OBE
	// Just stop and wait until we can find our destination again.
	SetVelocity( vect(0,0,0) );
*/
/*OBE
	// Just keep going the same direction and pray we get back on the network.
*/
	local vector Loc;

	if( Destination != None )
	{
		Loc = Destination.Location;
	}
	else // should only happen on client-side (if ever).
	{
		Loc = DestLoc;
	}

	// Head directly toward our destination as a last resort.
	SetVelocity( Speed * Normal( Loc - Location ) );

	//class'BaseHUD'.static.ClientWarn( Self );
	//class'Debug'.static.DebugWarn( Self, "Cannot reach destination using current set of path nodes in level.", 'DebugCategory_Angreal' );
}

//------------------------------------------------------------------------------
// Notification for when we reach our destination in accordance with 
// ReachTolerance.
//------------------------------------------------------------------------------
simulated function NotifyReachedDestination()
{
	// Only work on client-side for bNetTemporary objects.
	if( Role == ROLE_SimulatedProxy && !bNetTemporary )
	{
		return;
	}

	if( Destination != None )
	{
		Explode( Location, Normal( Location - Destination.Location ) );
	}
	else
	{
		Explode( Location, Normal( Location - DestLoc ) );
	}
}

//------------------------------------------------------------------------------
// Notification for when we keep trying to use the same NavigationPoint to get
// to our destination.  
// (In game, this appears that the seeker is bouncing back and forth on a PathNode.)
//------------------------------------------------------------------------------
simulated function NotifySeekerBounced( NavigationPoint OnNode )
{
	// Only work on client-side for bNetTemporary objects.
	if( Role == ROLE_SimulatedProxy && !bNetTemporary )
	{
		return;
	}

	//class'BaseHUD'.static.ClientWarn( Self );
	//class'Debug'.static.DebugWarn( Self, "Started bouncing at location: "$Location$" on "$OnNode$" ... self-destructing.", 'DebugCategory_Angreal' );
	//warn( "Started bouncing at location: "$Location$" on "$OnNode$" ... self-destructing." );

	//Explode( Location, vect(0,0,1) );
	Destroy();	// Just in case.
}

//------------------------------------------------------------------------------
// Notification for when our Destination suddenly disappears.  Normally caused
// when the player the seeking projectile is after dies before we get there.
// This function should probably be overridden to handle specific cases.
// By default, it simply turns the seeking projectile back into a normal
// projectile.
//------------------------------------------------------------------------------
simulated function DestinationLost()
{
	SetDestination( None );
}

//------------------------------------------------------------------------------
// If we are not seeking, blow up like any normal GenericProjectile.
//------------------------------------------------------------------------------	
simulated function ProcessTouch( Actor Other, Vector HitLocation )
{
	// Seekers should only ever explode when they touch their Destination (if
	// seeking -- otherwise Destination will have been set to None) or, (if
	// not seeking) when they hit geometry or non-pawn actors. Have to check
	// for whether seeker was ever in the seeking state also -- if not, it
	// was spawned for the fork effect and should hit and damage Other.
	if( (Pawn(Other) == None) || (Destination != None) || !bWasSeeking )
	{
		Super.ProcessTouch( Other, HitLocation );
	}
}

//------------------------------------------------------------------------------
simulated state Seeking
{
	//------------------------------------------------------------------------------
	simulated function BeginState()
	{
//		SetPhysics( PHYS_None );
		bAllowClipping = true;
		bCollideWorld = bCollideWorldWhileSeeking;
		bSeeking = true;
		bWasSeeking = true;
	}

	//------------------------------------------------------------------------------
	simulated function EndState()
	{
//		SetPhysics( default.Physics );
		bAllowClipping = false;
		bCollideWorld = default.bCollideWorld;
		bSeeking = false;
	}

	//------------------------------------------------------------------------------
	// On every tick, we check to see if we can reach our destination by going
	// in a straight line without colliding with any of the geometry.  If we
	// cannot, then we build a path to our destination and head toward the
	// path node that is closest to our destination that we can move in a straight
	// to without hitting any geometry.  If such a path node does not exist then
	// we're screwed.
	//------------------------------------------------------------------------------
	simulated function Tick( float DeltaTime )
	{
		local rotator Rot;
		
		// Make sure our destination still exists.
		if( DestinationExists() )
		{
			// Make sure we haven't reached our destination without blowing up.
			// This will only happen if our destination's bCollideActors == False.
			// Example: AngrealIllusionProjectile.
			if( !ReachedDestination() )
			{
				// Increase speed and acceleration.
//				Acceleration += AccelPerSec * DeltaTime;
				Speed += Acceleration * DeltaTime;
				Speed = FMin( Speed, MaxSpeed );
				SetVelocity( Normal(Velocity) * Speed );

				///////////////////
				// Optimizations //
				///////////////////

				// NOTE[aleiby]: This logic seems convoluted.  See if you can find a more
				// intuitive layout that does the same thing.
				// (Why am I writing to myself in third person?)

				// If we passed our NavPoint, we better find another one.
				if( NavPoint != None && !class'Util'.static.VectorAproxEqual( Normal(Velocity), Normal(NavPoint.Location - Location) ) )
				{
					PathCheckTimer = 0;
					CalcNextDirection( true );
				}
				// Otherwise, only occasionally check to see if we need to change direction.
				else if( PathCheckTimer > 0 )
				{
					PathCheckTimer -= DeltaTime;
				}
				else
				{
					CalcNextDirection();
				}

				// Fix our rotation so we are always facing forward.
				// ...but don't throw away our roll.
				if( bAlignToVelocity )
				{
					Rot = rotator(Velocity);
					Rot.Roll = Rotation.Roll;
					SetRotation( Rot );
				}
			}
			else
			{
				NotifyReachedDestination();
			}
		}
		else	// Our destination has disappeared...probably died.
		{
			DestinationLost();
		}

		Global.Tick( DeltaTime );
	}

	//------------------------------------------------------------------------------
	// Figure out where to go next.
	//
	// bDesperate mean we need to use a NavigationPoint other than the one we
	// are currently using (possibly None).
	//------------------------------------------------------------------------------
	simulated function CalcNextDirection( optional bool bDesperate )
	{
		local vector Loc;
		local NavigationPoint NextPoint;

		if( bDisableCalcNextDirection )
		{
			return;
		}

		if( bDesperate )
		{
			RestrictedPoint = None;
		}
		
		if( Destination != None )
		{
			Loc = Destination.Location;
		}
		else // should only happen on client-side.
		{
			Loc = DestLoc;
		}
	
		if( CanDirectlyReachDestination( Loc ) )
		{
			// Head directly toward our destination.
			SetVelocity( Speed * Normal( Loc - Location ) );
		}
		else
		{
			// Only build a PathNodeIterator if we need one.
			if( PNI == None )
			{
				PNI = Spawn( class'PathNodeIteratorII' );
				//DM( Self$"::Created: "$PNI );
			}

			//DM( Self$"::Building path..." );
			// Build a path to the destination using the path nodes in the level.
			if( !PNI.BuildPath( Location, Loc, bDesperateSeeker ) )
			{
				//DM( Self$"::Failed to build path." );
				CannotReachDestination();	// Couldn't get on to path-network.
				return;
			}

			//DM( Self$"::Succeeded in building path." );

			if( Region.ZoneNumber == 0 )	// We are outside the world, therefore all calls to CanDirectlyReachDestination will always fail.
			{
				NavPoint = PNI.GetFirst();
				//DM( Self$"::Outside the world.  Using first path node: "$NavPoint );
			}
			else if( bTakeShortcuts )
			{
				//DM( Self$"::Taking shortcuts." );
				// Get the point closest to our destination in the path that
				// we can directly reach.
				NavPoint = PNI.GetLast();
				while( NavPoint != None && !CanDirectlyReachDestination( NavPoint.Location ) )
				{
					NavPoint = PNI.GetPrevious();
				}
				//DM( Self$"::Using(A): "$NavPoint );
				// Note: Guaranteed to be at least one directly reachable path-node in path.
				// (Otherwise, how were we able to successfully build the path?)
			}
			else
			{
				//DM( Self$"::Not taking shotcuts." );
				// Always try to go to the next node unless you can't directly get to it.
				// In such a case, go toward the first node.
				NavPoint = PNI.GetFirst();
				NextPoint = PNI.GetNext();
				if( NextPoint != None && CanDirectlyReachDestination( NextPoint.Location ) )
				{
					NavPoint = NextPoint;
				}
				//DM( Self$"::Using(B): "$NavPoint );
			}

			// Don't be messing with teleporters.
			if( NavPoint == None || !NavPoint.IsA('Teleporter') )
			{
				// Enforce restriction.
				if( NavPoint == RestrictedPoint )
				{
					//DM( Self$"::Enforcing restriction." );
					NavPoint = LastPoint;
					//DM( Self$"::Using(C): "$NavPoint );
				}

				// If we really need a different NavPoint.
				if( (NavPoint == LastPoint) && bDesperate )
				{
					//DM( Self$"::Desparate" );
					RestrictedPoint = LastPoint;

					PNI.GetFirst();
					NavPoint = PNI.GetNext();
					if( NavPoint == None )
					{
						NotifySeekerBounced( RestrictedPoint );
						return;
					}
				}
			}

			//DM( Self$"::Using(D): "$NavPoint );

			// NavPoint guaranteed to exist by this point.
			//assert(NavPoint!=None);
			
			// Head toward that point.
			SetVelocity( Speed * Normal( NavPoint.Location - Location ) );

			// Remember last valid navigation point used.
			LastPoint = NavPoint;

			// Don't check again for a while.
			PathCheckTimer += PathCheckResolution;
		}
	}

	//------------------------------------------------------------------------------
	// If we are seeking, only blow up if we hit our Destination.
	//------------------------------------------------------------------------------	
	simulated function ProcessTouch( Actor Other, Vector HitLocation )
	{
		// Only work on client-side for bNetTemporary objects.
		if( Role == ROLE_SimulatedProxy && !bNetTemporary )
		{
			return;
		}

		if( Other == Destination )
   		{
			Global.ProcessTouch( Other, HitLocation );
		}
	}

	//------------------------------------------------------------------------------	
	simulated function HitWall( vector HitNormal, Actor Wall )
	{
		// Don't you dare hit walls.
		// FWIW: BlockAlls are the spawn of Satan!
	}

	//-----------------------------------------------------------------------------
	event bool PreTeleport( Teleporter InTeleporter )
	{
		return !(InTeleporter == NavPoint);	// Only teleport if we are using it as a path guide (true=don't teleport,false=teleport).
	}
}

//////////////////////
// Helper Functions //
//////////////////////

//------------------------------------------------------------------------------
// Returns true if we can reach our destination without hitting any geometry.
//------------------------------------------------------------------------------
simulated function bool CanDirectlyReachDestination( vector Dest )
{
	local vector HitLocation, HitNormal;
	local Actor HitActor;

	HitActor = Trace(	HitLocation, 
						HitNormal, 
						Dest,
						Location, 
						false	// Don't trace Actors
					);

	return (HitActor == None);
}

//------------------------------------------------------------------------------
// Returns true if we can reach our destination using the path node network.
// (tries direct route first).
//------------------------------------------------------------------------------
simulated function bool CanReachDestination( vector Dest )
{
	local bool bIsReachable;

	bIsReachable = CanDirectlyReachDestination( Dest );

	if( !bIsReachable )
	{
		// Only build a PathNodeIterator if we need one.
		if( PNI == None )
		{
			PNI = Spawn( class'PathNodeIteratorII' );
		}

		// Build a path to the destination using the path nodes in the level.
		bIsReachable = PNI.BuildPath( Location, Dest, bDesperateSeeker );
	}

	return bIsReachable;
}

//------------------------------------------------------------------------------
// Make sure our destination didn't die or something.
//------------------------------------------------------------------------------
simulated function bool DestinationExists()
{
	// Only really check on the server.  Trust the information that the
	// server sends us if we are the client.
	if( Role == ROLE_Authority || bNetTemporary )
	{	
		// Check to make sure it didn't respawn.
		if( Destination != None && Destination.bDeleteMe )
		{
			bDestExists = false;
		}
		else if( WOTPlayer(Destination) != None )
		{
			bDestExists = (PlayerID == WOTPlayer(Destination).NumDeaths);
		}
		// Check to see if it is currently dead.
		else if( Pawn(Destination) != None )
		{
			bDestExists = (Pawn(Destination).Health > 0);
		}
		// See if it exists period.
		else
		{
			bDestExists = (Destination != None);
		}
	}

	return bDestExists;
}

//------------------------------------------------------------------------------
// Checks to see if we have reached our destination yet.
// Returns false if our destination does not exist.
//------------------------------------------------------------------------------
simulated function bool ReachedDestination()
{
	// Only really check on the server.  Trust the information that the
	// server sends us if we are the client.
	if( Role == ROLE_Authority || bNetTemporary )
	{
		bServerReachedDest = (Destination != None) && (VSize( Destination.Location - Location ) < ReachTolerance);
	}

	return bServerReachedDest;
}

////////////////
// AI Support //
////////////////

//------------------------------------------------------------------------------
// Max distance this projectile can travel.
//------------------------------------------------------------------------------
static function float GetMaxRange()
{
	return MaxInt;		// Assuming all Seekers have an infinite LifeSpan.
}

//------------------------------------------------------------------------------
simulated function Actor GetSeekingProjectileTarget()
{
	return Destination;
}

defaultproperties
{
     AccelPerSec=1.000000
     Acceleration=16.000000
     PathCheckResolution=1.000000
     bTakeShortcuts=True
     ReachTolerance=12.000000
     bNotifiesDestination=True
     bAlignToVelocity=True
     BroadcastLocationTime=1.000000
     DeltaTimeTolerance=0.500000
     bUsesDestination=True
     bRequiresDestination=True
     bRequiresLeading=False
     MaxTargetAngle=22.500000
     MaxSpeed=1200.000000
     bNetTemporary=False
     LifeSpan=300.000000
     bAlwaysRelevant=True
     NetPriority=10.000000
}
