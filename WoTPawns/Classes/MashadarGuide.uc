//------------------------------------------------------------------------------
// MashadarGuide.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 13 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
// 
// + Place it in a crack, window, or whatever in your level.
// + Make sure it is facing out, and place a MashadarPathNode within view it
//   and the path node network if it cannot see the network.
// + Set RetractSpeed to the speed you want Mashadar to retract.
// + Set the team you want this Mashadar to be on.  It will automatically 
//   look for a MashadarManager with the same team on startup and use that
//   manager.  If it cannot find a manager with the same team, it will
//   create a new one and use it.
// + Set SearchRadius to limit the Mashadar's range.
// + Set the SearchResolution to limit how often we check to see if someone
//   is in our range.
//
// + ReachTolerance is the Distance Mashadar has to be from its target
//   before it starts coiling around him.
//------------------------------------------------------------------------------
// How this class works (design):
//
// + By default none of the MashadarGuides will be active when placed in a level.
// + Using the CitadelEditor, when you place a MashadarFocusPawn the nearest
//   MashadarGuide will become Deployed and follow that MashadarFocusPawn around.
// + Once you exit the Citadel Editor and begin playing, that MashadarGuide
//   will retract.
// + A player must then go into the range of that specific MashadarGuide before
//   that MashadarGuide is allowed to come out of any crack.
// + MashadarGuides will only react to people not on their team.
//------------------------------------------------------------------------------
// How this class works (technical):
//
// + It just does, trust me.
// + Warning: Viewing this code tends to induce insanity!!
//------------------------------------------------------------------------------
class MashadarGuide expands SeekingProjectile;

#exec OBJ LOAD FILE=Textures\MashSmoke.utx PACKAGE=WOTPawns.Mashadar

// Classes to use to make up tentacle.
var() class<MashadarTrailer> HeadType;
var() class<MashadarTrailer> SegmentType;

var MashadarTrailer MasterSegment;
var MashadarTrailer LastSegment;

var RestPoint HidingPlace;		// Out anchor.

var RestPoint ReferencePoint;	// Persistant local var for AddNewSegment().

var MashadarFocusPawn FocusPawn;

var bool bRetracting;			// Are we retracting?
var bool bFullRetract;			// Do we have to fully retract before going 
								// after someone else?

var() float SearchRadius;		// How far away from our hiding place (where we were 
								// placed in the level) our destination can get before 
								// we stop following him.

var() float SearchResolution;	// How often to check who's closest. (in seconds)
var float SearchTimer;

var() float RetractSpeed;		// How fast we retract.

var() float CitadelEditingSpeed;// How fast we move while being place in the citadel editor.

var(Movement) float MPSpeed;	// Speed to use in MP.
var(Movement) float MPMaxSpeed;	// MaxSpeed to use in MP.
var(Movement) float MPAccel;	// Acceleration to use in MP.

var() byte Team;				// What team we are on.

var MashadarManager Manager;	// Our manager.

var bool bActive;				// Are we active.

var int Index;					// Our index into our manager.

var int GuardID;				// The ID used by our manager if we are guarding something. (-1 if we aren't guarding anything.)

var int GuardSealID;			// Identifier used for guarding seals (this is const).

var() bool bDeployed;			// Have we been placed in the Citadel Editor?
var bool bAssimilated;			// Have we been added to the manager's collective?

var() float TriggerRadius;		// How close the player needs to get to us before becoming active.
								// (Only valid if bDeployed.)

var bool bResting;				// Are we currently at are resting point simply waiting for 
								// someone to come into range?

var() float RestTimeAfterDeath;	// How long this 'hole' remains inactive after a tendril has been
								// killed here.
var float RestTimer;			// Used to enforce the above.

var int NumSegsAdded;			// Number of segments added (this tick).

var() int MaxNumSegments;		// Total number of segments this tendril may have before retracting.
var int NumSegments;			// Current number of segments this tendril is composed of.

var() int ClientMaxNumSegments;	// Enforced on clients.
var int ClientNumSegments;		// Enforced on clients.

var bool bAlreadyHurtThisTick;	// To keep splash damage from damaging us multiple times.

var bool bShocked;				// Have we been recently shocked?
var Pawn ShockInstigator;		// Who shocked us?

								// How often we respond to SeePlayer notification from an individual object.
var() float SeePlayerResolutionMin;
var() float SeePlayerResolutionMax;
struct TSeePlayerTimerInfo
{
	var Actor Seen;				// Actor that was seen by SeePlayer.
	var float NextNotifyTime;	// When we are next allowed to respond to SeePlayer notifications from the above actor.
};
var TSeePlayerTimerInfo SeePlayerTimerInfos[16];
var int SeePlayerTimerInfoIndex;

//var() float RetractResolution;// How often we check to see if we should be retracting.
//var float RetractTimer;

// Initial variables (to remember what the LDs set them to).
var float InitialSpeed;
var float InitialMaxSpeed;
var float InitialAcceleration;
var vector InitialLocation;

var float InitialX;
var float InitialY;
var float InitialZ;
var int InitialPitch;
var int InitialYaw;
var int InitialRoll;

var bool bInitialized;

// Variables used to fake a remote function call.
var int ClientDeactivateFID;
var int LastDeactivateFID;

var int ClientUnRetractFID;
var int LastUnRetractFID;

var int ClientSetDestinationFID;
var int LastClientSetDestinationFID;

var int ClientSetFocusPawnAFID;
var int LastClientSetFocusPawnAFID;

var int ClientSetFocusPawnBFID;
var int LastClientSetFocusPawnBFID;

var int ClientBreakOffMashadarAtFID;
var int LastClientBreakOffMashadarAtFID;
var int ClientBreakOffMashadarAtIndex;

var bool bLatentDeactivate;

///////////////////
// Sound support //
///////////////////

var(WOTSounds) class<SoundTableWOT>				SoundTableClass;
var SoundTableWOT								SoundTable;

var(WOTSounds) class<SoundSlotTimerListInterf>	SoundSlotTimerListClass;
var SoundSlotTimerListInterf					SoundSlotTimerList;

var(WOTSounds) float							VolumeMultiplier;
var(WOTSounds) float							RadiusMultiplier;
var(WOTSounds) float							PitchMultiplier;
var(WOTSounds) float							TimeBetweenHitSounds;

// Debug stuff.
var int BufferLength;

replication
{
	// Server is authoritative on these.
	reliable if( Role==ROLE_Authority )
		bFullRetract,
		bActive;

	// Standard variables (possible modified by LDs).
	reliable if( Role==ROLE_Authority )
		HeadType,
		SegmentType,
		SearchRadius,
		TriggerRadius,
		SearchResolution,
		RetractSpeed,
		CitadelEditingSpeed,
		Team;

	// Function identifiers (for faking RPCs).
	reliable if( Role==ROLE_Authority )
		ClientDeactivateFID,
		ClientUnRetractFID,
		ClientSetDestinationFID,
		ClientSetFocusPawnAFID,
		ClientSetFocusPawnBFID,
		ClientBreakOffMashadarAtFID,
		ClientBreakOffMashadarAtIndex;

	// Initial positioning.
	reliable if( Role==ROLE_Authority && bNetInitial )
		InitialX,
		InitialY,
		InitialZ,
		InitialPitch,
		InitialYaw,
		InitialRoll;

	// In case LDs change Speed, or MaxSpeed, replicate
	// these to the clients since Speed and MaxSpeed are
	// not replicated.
	reliable if( Role==ROLE_Authority )
		InitialSpeed,
		InitialMaxSpeed,
		InitialAcceleration;

	reliable if( Role==ROLE_Authority /*&& (FocusPawn == None || FocusPawn.bNetRelevant)*/ )
		FocusPawn;
}

//////////////////////
// Master functions //
//////////////////////

//------------------------------------------------------------------------------
simulated function PostBeginPlay()
{
//GuardX( "PostBeginPlay()" );
	Super.PostBeginPlay();
	
	// Override velocity just to be safe.
	SetVelocity( vect(0,0,0) );

	if( bDeployed )
	{
		SeePlayerRadius = TriggerRadius;
		SeePlayerHeight = TriggerRadius;
	}
	else
	{
		SeePlayerRadius = SearchRadius;
		SeePlayerHeight = SearchRadius;
	}

//UnGuardX();
}

//------------------------------------------------------------------------------
simulated function Initialize()
{
	local vector X, Y, Z;
	
	local vector Loc;
	local rotator Rot;
//GuardX( "Initialize()" );

	// Send initial variables to clients.
	if( Role == ROLE_Authority )
	{
		InitialX = Location.X;
		InitialY = Location.Y;
		InitialZ = Location.Z;
		InitialPitch = Rotation.Pitch;
		InitialYaw = Rotation.Yaw;
		InitialRoll = Rotation.Roll;
	}
	// Get initial variables from server.
	else
	{
		Loc.X = InitialX;
		Loc.Y = InitialY;
		Loc.Z = InitialZ;
		SetLocation( Loc );

		Rot.Pitch = InitialPitch;
		Rot.Yaw = InitialYaw;
		Rot.Roll = InitialRoll;
		SetRotation( Rot );
	}

	CreateSoundTable();

	// This will also set our manager.
	SetTeam( Team );

	GetAxes( Rotation, X, Y, Z );
	HidingPlace = Spawn( class'RestPoint',,, Location, OrthoRotation( -X, -Y, Z ) );

	// Offset MasterSegment.Dist units from our hiding place so our MasterSegment
	// will be nicely aligned with the hiding place.
	SetLocation( Location + ((vect(1,0,0) * HeadType.default.Dist) >> Rotation) );

	if( Level.NetMode != NM_Standalone )
	{
		Speed = MPSpeed;
		MaxSpeed = MPMaxSpeed;
		Acceleration = MPAccel;
	}

	// Remember initial setting.
	InitialSpeed = Speed;
	InitialMaxSpeed = MaxSpeed;
	InitialLocation = Location;
	InitialAcceleration = Acceleration;
//DM( Self$"::Initialize() - InitialLocation = "$InitialLocation );

	// Setup.
	SetMasterSegment( Spawn( HeadType ), Self );
	MasterSegment.Guide = Self;
	LastSegment = MasterSegment;
	MasterSegment.bHidden = true;
	bResting = true;

	// Randomly Distribute timers.
	SearchTimer = SearchResolution * FRand();
//	RetractTimer = Level.TimeSeconds + (RetractResolution * FRand());

	bInitialized = true;

//UnGuardX();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local MashadarTrailer Seg;
//GuardX( "Tick()" );

	if( !bInitialized )
	{
		Initialize();
	}

	// NOTE[aleiby]: Might be able to clean up using more states.

	// Don't do any of this if we are simply waiting at our resting point for 
	// someone to come into our range.
	if( !bResting )
	{
		if( !bRetracting )
		{
			// Keep adding segments until we link back up with our HidingPlace.
			while
			(	VSize( LastSegment.Location - HidingPlace.Location ) > LastSegment.Dist
			&&	AddNewSegment()
			);
		}
		else if( VSize( Location - HidingPlace.Location ) > LastSegment.Dist ) //ReachedHidingPlace() )
		{
			// Don't delete the last segment, if it is the *very* last segment (head).
			if( LastSegment.ChildTrailer == None )
			{
				Reset();
			}
			else
			{
				// Delete the last segment.
				DisableMasterSegment();
				Seg = LastSegment;
				LastSegment = MashadarTrailer(Seg.ChildTrailer);
				Seg.ChildTrailer = None;
				Seg.FadeAway();

				// Now lead the new last segment back to the hiding place.
				GuideToHidingPlace();
			}
		}
	}

	if( Role == ROLE_Authority )	// ### Begin Server code ###
	{
/* Moved to SeePlayer() -- this is the old polling method.
		if( Level.TimeSeconds > RestTimer )
		{
			if( bShocked )
			{
				// If we were shocked, wait until the person who shocked us
				// stops using lightning before coming back out of our hole.
				if
				(	AngrealInvLightning(ShockInstigator.SelectedItem) == None
				||	!AngrealInvLightning(ShockInstigator.SelectedItem).bCasting
				)
				{
					bShocked = false;
					Search();
					//Speed = FMin( InitialSpeed * 4.0, MaxSpeed );	// Because we are pissed.  :)
				}
			}
			else
			{
				// Occasionally check to see who the closest pawn is.
				// If there is no pawn in range, retract back into our hiding place.
				SearchTimer -= DeltaTime;
				if( SearchTimer <= 0 )
				{
					SearchTimer += SearchResolution;
					Search();
				}
			}
		}
*/

/*OBE: Orders are automatic now, so Mashadar doesn't need to obey orders.
		if( Level.TimeSeconds > RetractTimer )
		{
			RetractTimer = Level.TimeSeconds + RetractResolution;
			if( ShouldRetract() )
			{
				Deactivate( true );
				ClientDeactivateFID++;	// Tell the clients to Deactivate.
				//log( Self$"::ClientDeactivateFID = "$ClientDeactivateFID );
			}
		}
*/

		// Check for jerkiness.
		if( NumSegsAdded > 2 )
		{
			PlaySlotSound( SoundTable.BreathSoundSlot );
		}
		NumSegsAdded = 0;
	}
	else							// ### Begin Client code ###
	{
		if( ClientBreakOffMashadarAtFID != LastClientBreakOffMashadarAtFID )
		{
			ClientBreakOffMashadarAt();
			LastClientBreakOffMashadarAtFID = ClientBreakOffMashadarAtFID;
			//log( Self$"::LastClientBreakOffMashadarAtFID = "$LastClientBreakOffMashadarAtFID );
		}

		if( ClientUnRetractFID != LastUnRetractFID )
		{
			UnRetract();
			LastUnRetractFID = ClientUnRetractFID;
			//log( Self$"::LastUnRetractFID = "$LastUnRetractFID );
		}

		if( ClientDeactivateFID != LastDeactivateFID )
		{
			Deactivate( true );
			LastDeactivateFID = ClientDeactivateFID;
			//log( Self$"::LastDeactivateFID = "$LastDeactivateFID );
		}

		if( ClientSetDestinationFID != LastClientSetDestinationFID )
		{
			ClientSetDestination();
			LastClientSetDestinationFID = ClientSetDestinationFID;
			//log( Self$"::LastClientSetDestinationFID = "$LastClientSetDestinationFID );
		}

		if( ClientSetFocusPawnAFID != LastClientSetFocusPawnAFID )
		{
			ClientSetFocusPawnA();
			LastClientSetFocusPawnAFID = ClientSetFocusPawnAFID;
			//log( Self$"::LastClientSetFocusPawnAFID = "$LastClientSetFocusPawnAFID );
		}

		if( ClientSetFocusPawnBFID != LastClientSetFocusPawnBFID )
		{
			ClientSetFocusPawnB();
			LastClientSetFocusPawnBFID = ClientSetFocusPawnBFID;
			//log( Self$"::LastClientSetFocusPawnBFID = "$LastClientSetFocusPawnBFID );
		}

	}

	if( bLatentDeactivate )
	{
		bLatentDeactivate = false;
		Deactivate( true );
	}

	Super.Tick( DeltaTime );

/* - TBD: moved to superclass.
	// Since our physics is PHYS_None, we'll have to update our position manually.
	SetLocation( Location + Velocity * DeltaTime );
*/
	// Only allow someone to set our velocity to read only for the duration
	// of one tick.
	bVelocityReadOnly = false;

	bAlreadyHurtThisTick = false;

//UnGuardX();
}

//------------------------------------------------------------------------------
function SeePlayer( Actor Seen )
{
	local int i;
//GuardX( "SeePlayer( "$Seen$" )" );

	if( Role == ROLE_Authority && Seen != None )
	{
//		DM( Self$"::SeePlayer: "$Seen );

		if( Level.TimeSeconds > RestTimer )
		{
			for( i = 0; i < ArrayCount(SeePlayerTimerInfos); i++ )
			{
				if( Seen == SeePlayerTimerInfos[i].Seen )
				{
					if( Level.TimeSeconds < SeePlayerTimerInfos[i].NextNotifyTime )
					{
						goto Finish;
					}
					break;
				}
			}
			if( i == ArrayCount(SeePlayerTimerInfos) )	// Not in list.
			{
				SeePlayerTimerInfos[ SeePlayerTimerInfoIndex ].Seen = Seen;
				SeePlayerTimerInfos[ SeePlayerTimerInfoIndex ].NextNotifyTime = Level.TimeSeconds + RandRange( SeePlayerResolutionMin, SeePlayerResolutionMax );
				SeePlayerTimerInfoIndex = (SeePlayerTimerInfoIndex + 1) % ArrayCount(SeePlayerTimerInfos);
			}
			else
			{
				SeePlayerTimerInfos[i].NextNotifyTime = Level.TimeSeconds + RandRange( SeePlayerResolutionMin, SeePlayerResolutionMax );
			}

			if( bShocked )
			{
				// If we were shocked, wait until the person who shocked us
				// stops using lightning before coming back out of our hole.
				if( !class'AngrealInvLightning'.static.IsUsingLightning( Pawn(Seen) ) )
				{
					bShocked = false;
					Chase( Seen );
					//Speed = FMin( InitialSpeed * 4.0, MaxSpeed );	// Because we are pissed.  :)
				}
			}
			else
			{
				Chase( Seen );
			}
		}
	}

Finish:
//UnGuardX();
	return;
}

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
simulated function Activate()
{
//GuardX( "Activate()" );
	bActive = true;
//UnGuardX();
}

//------------------------------------------------------------------------------
simulated function Deactivate( optional bool bNonLatent )
{
//GuardX( "Deactivate()" );

	if( bNonLatent )
	{
		if( bActive )
		{
			bActive = false;
			if( Manager != None )
			{
				Manager.MashadarDeactivated( Self );
			}
		}

		Retract();
	}
	else
	{
		bLatentDeactivate = true;
	}

//UnGuardX();
}

//------------------------------------------------------------------------------
function SetTeam( byte NewTeam )
{
	local MashadarManager IterManager;
//GuardX( "SetTeam()" );

	Team = NewTeam;
	Manager = None;

	// Find our manager.
	foreach AllActors( class'MashadarManager', IterManager )
	{
		if( IterManager.Team == Team )
		{
			Manager = IterManager;
			break;	// Only use the first one.  There shouldn't be any more.
		}
	}
	
	// Create one if one doesn't exist.
	if( Manager == None )
	{
		Manager = Spawn( class'MashadarManager' );
		Manager.Team = Team;
		//log( "Creating "$Manager$" Team: "$Manager.Team );
	}

	//DM( Self$" using "$Manager$" as its manager." );
//UnGuardX();
}

//------------------------------------------------------------------------------
// Breaks off the mashadar at the given segment.
//------------------------------------------------------------------------------
simulated function BreakOffMashadarAt( MashadarTrailer Segment )
{
	local MashadarTrailer FirstSegment;
//GuardX( "BreakOffMashadarAt()" );

	// Make sure we don't break off the head.
	if( Segment != MasterSegment )
	{
		// Store for safe keeping.  We will use this to start the chain fading away.
		FirstSegment = MashadarTrailer(MasterSegment.ChildTrailer);

		// Move our master segement to the place we broke off.
		MasterSegment.ChildTrailer = Segment.ChildTrailer;
		SetLocation( Segment.Location );
//DM( Self$"::BreakOffMashadarAt() -- "$Location );

		// Break off the chain.
		Segment.ChildTrailer = None;

		// Fade the broken half away.
		FirstSegment.FadeAway();
	}

//UnGuardX();
}

//------------------------------------------------------------------------------
simulated function ClientBreakOffMashadarAt()
{
	local MashadarTrailer Seg;
//GuardX( "ClientBreakOffMashadarAt()" );

	Seg = MashadarTrailer( GetTrailerAt( ClientBreakOffMashadarAtIndex ) );
	if( Seg == None )
	{
		Seg = MasterSegment;
	}
	BreakOffMashadarAt( Seg );

	bFullRetract = true;
	Deactivate();

//UnGuardX();
}		

//------------------------------------------------------------------------------
simulated function Retract()
{
//GuardX( "Retract()" );
	if( !bRetracting )
	{
		bRetracting = true;

		ReverseLinks();

		GuideToHidingPlace();
	}
//UnGuardX();
}

//------------------------------------------------------------------------------
simulated function UnRetract()
{
	local IKTrailer EndSegment;
	local vector X, Y, Z;
////GuardX( "UnRetract()" );

	bRetracting = false;

	if( LastSegment != None )
	{
		EndSegment = GetLastSegmentInChain( LastSegment );

		ReverseLinks();

		SetLocation( EndSegment.Location - ((vect(1,0,0) * EndSegment.Dist) >> EndSegment.Rotation) );
//DM( Self$"::UnRetract() -- "$Location );
		
		GetAxes( EndSegment.Rotation, X, Y, Z );
		SetRotation( OrthoRotation( -X, -Y, Z ) );

		SetMasterSegment( MashadarTrailer(EndSegment), Self );
	}
////UnGuardX();
}

//------------------------------------------------------------------------------
function Shock( Pawn Other )
{
//GuardX( "Shocked()" );
	bShocked = true;
	ShockInstigator = Other;
	Deactivate();
	ClientDeactivateFID++;	// Tell the clients to Deactivate.
	//log( Self$"::ClientDeactivateFID = "$ClientDeactivateFID );
	//bFullRetract = true;
//UnGuardX();
}

//------------------------------------------------------------------------------
function Trigger( Actor Other, Pawn EventInstigator )
{
//GuardX( "Trigger()" );
	Deploy();
	Chase( EventInstigator );
//UnGuardX();
}

//------------------------------------------------------------------------------
simulated state() Waiting
{
	simulated function Tick( float DeltaTime )
	{
	//GuardX( "Waiting::Tick()" );
		// do nothing.
	//UnGuardX();
	}

	simulated function SeePlayer( Actor Seen )
	{
	//GuardX( "Waiting::SeePlayer()" );
		// do nothing.
	//UnGuardX();
	}

	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
	//GuardX( "Waiting::Trigger()" );
		GotoState('');
	//UnGuardX();
	}
}

///////////////
// Overrides //
///////////////

//------------------------------------------------------------------------------
simulated state Seeking
{
	simulated function EndState()
	{
	//GuardX( "Seeking::EndState()" );
		Super.EndState();
		bAllowClipping = true;
	//UnGuardX();
	}
}
	
//------------------------------------------------------------------------------
// If we are going to chase after someone, make sure we unhide our MasterSegment.
//------------------------------------------------------------------------------
function SetDestination( Actor Dest )
{
//GuardX( "SetDestination( "$Dest$" )" );
	if( Dest != None )
	{
		ClientSetDestination();
		ClientSetDestinationFID++;	// Tell client to call ClientSetDestination.
		//log( Self$"::ClientSetDestinationFID = "$ClientSetDestinationFID );

		PlaySlotSound( SoundTable.SeeEnemySoundSlot );
	}

	Super.SetDestination( Dest );
//UnGuardX();
}

//------------------------------------------------------------------------------
simulated function ClientSetDestination()
{
//GuardX( "ClientSetDestination()" );
	// Catch up with the server.
	if( Level.NetMode == NM_Client && bRetracting )
	{
		if( MashadarTrailer(LastSegment.ChildTrailer) != None )
		{
			MashadarTrailer(LastSegment.ChildTrailer).FadeAway();
		}
		LastSegment.ChildTrailer = None;
		Reset();
	}

	MasterSegment.bHidden = false;
	MasterSegment.FadeIn();

	bResting = false;
//UnGuardX();
}

//------------------------------------------------------------------------------
simulated function bool DestinationExists()
{
	local vector Loc;
	local float Dist;
//GuardX( "DestinationExists()" );

	if( Level.NetMode == NM_Client )
	{
		bDestExists = Super.DestinationExists();
	}
	else if( Level.NetMode != NM_Client && Destination != None && Destination.bDeleteMe )
	{
		Destination = None;
		bDestExists = false;
	}
	else if( FollowingFocusPawn() )
	{
		bDestExists = Super.DestinationExists();
	}
	else
	{
		if( Destination != None )
		{
			Loc = Destination.Location;
		}
		else // should only happen on client-side (if ever).
		{
			Loc = DestLoc;
		}

		Dist = VSize(Loc - HidingPlace.Location);

		if( Dist > SeePlayerRadius )
		{
			bDestExists = false;
		}
		else
		{
			bDestExists = Super.DestinationExists();
		}
	}

//UnGuardX();
	return bDestExists;
}

/*
//------------------------------------------------------------------------------
// Take MashadarPathNodes into consideration.
//------------------------------------------------------------------------------
simulated function CanReachDestination( vector Dest )
{
	local bool bReachable;

	bReachable = Super.CanReachDestination( Dest );

	if( !bReachable )
	{
		// Take MashadarPathNodes into consideration.
	}

	return bReachable;
}
*/
///////////////////
// Notifications //
///////////////////

//------------------------------------------------------------------------------
// Propogate our damage up to our manager.
//------------------------------------------------------------------------------
function HurtMashadar( int Damage, MashadarTrailer HitSegment, Pawn DamageInstigator, name DamageType )
{
//GuardX( "HurtMashadar()" );
	// Only active Mashadar may be hurt.
	if( bActive && !bAlreadyHurtThisTick && Manager != None )
	{
		Spawn( class'MashadarPainSprayer',,, HitSegment.Location, rotator(vect(0,0,1)) );
	
		// If that was the killing blow, break him off at that segment.
		if( Manager.GetMashadarHealth( Index ) - Damage <= 0 )
		{
			ClientBreakOffMashadarAtFID++;
			//log( Self$"::ClientBreakOffMashadarAtFID = "$ClientBreakOffMashadarAtFID );
			ClientBreakOffMashadarAtIndex = GetTrailerIndex( HitSegment );
			BreakOffMashadarAt( HitSegment );
			RestTimer = Level.TimeSeconds + RestTimeAfterDeath;
		}
		else
		{
			HitSegment.FadeIn();
		}

		Manager.HurtMashadar( Self, Damage, DamageInstigator, DamageType );

		bAlreadyHurtThisTick = true;
	}
//UnGuardX();
}

//------------------------------------------------------------------------------
// Propogate health up to our manager.
//------------------------------------------------------------------------------
function GiveHealth( int Health )
{
//GuardX( "GiveHealth()" );
	Manager.GiveHealth( Self, Health );
//UnGuardX();
}

//------------------------------------------------------------------------------
// Are we within LastSegment.Dist units from our HidingPlace?
//------------------------------------------------------------------------------
simulated function bool ReachedHidingPlace()
{
//GuardX( "ReachedHidingPlace()" );
//UnGuardX();
	return VSize( HidingPlace.Location - Location ) <= LastSegment.Dist;
}

/* NOTE[aleiby]: This doesn't work correctly.
//------------------------------------------------------------------------------
// Slide along walls.
//------------------------------------------------------------------------------
simulated function HitWall( vector HitNormal, Actor HitWall )
{
	local rotator Rot;
//GuardX( "HitWall()" );

	Rot = rotator( HitNormal );
	if( (Rotation - Rot).Yaw < 32768 )
	{
		Rot.Yaw += 16000;
	}
	else
	{
		Rot.Yaw -= 16000;
	}
	Rot.Pitch = Rotation.Pitch;
	Rot.Roll = Rotation.Roll;
	SetVelocity( (vect(1,0,0) * Speed) >> Rot );
	// Set our velocity to be read only for the rest of this tick.
	bVelocityReadOnly = true;
	SetRotation( Rot );
//UnGuardX();
}
*/

//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
//GuardX( "Explode()" );
	NotifyReachedDestination();

	// Don't call Super.Explode();
//UnGuardX();
}

//------------------------------------------------------------------------------
simulated function NotifyReachedDestination()
{
	local rotator Rot;
	local vector Loc;
//GuardX( "NotifyReachedDestination()" );

	if( AngrealIllusionProjectile(Destination) != None )
	{
		// Stop.
		SetVelocity( vect(0,0,0) );
		Destination.LifeSpan = FMin( Destination.LifeSpan, Destination.default.LifeSpan * AngrealIllusionProjectile(Destination).FadePercent );
	}
	else if( FollowingFocusPawn() )
	{
		// Stop.
		SetVelocity( vect(0,0,0) );
	}
	else
	{
		if( Destination != None )
		{
			Loc = Destination.Location;
		}
		else
		{
			Loc = DestLoc;
		}
		// Coil around our player.
		Rot = rotator( Loc - Location );
		Rot.Yaw += 16000;	// Less than 90 degrees.
		Rot.Pitch = 0;
		Rot.Roll = Rotation.Roll;
		SetVelocity( (vect(1,0,0) * Speed) >> Rot );
		SetRotation( Rot );
	}
//UnGuardX();
}

//------------------------------------------------------------------------------
simulated function DestinationLost()
{
//GuardX( "DestinationLost()" );
	if( Role == ROLE_Authority )
	{
		Deactivate();
		ClientDeactivateFID++;	// Tell the clients to Deactivate.
		//log( Self$"::ClientDeactivateFID = "$ClientDeactivateFID );
	}
//UnGuardX();
}

/*OBE
//------------------------------------------------------------------------------
simulated function CannotReachDestination()
{
	local MashadarPathNode BestMPN, IterMPN;
	local float BestDist, IterDist;
	local vector Loc;

BEGIN: Old.
	if( Destination != None )
	{
		// Find the MashadarPathNode in our view that is closest to our destination.
		foreach AllActors( class'MashadarPathNode', IterMPN )
		{
			if( CanDirectlyReachDestination( IterMPN.Location ) )
			{
				IterDist = VSize( IterMPN.Location - Destination.Location );
				if( BestMPN == None || IterDist < BestDist )
				{
					BestMPN = IterMPN;
					BestDist = IterDist;
				}
			}
		}
	}
	else
	{
		// Find the MashadarPathNode in our view that is furthest from us.
		foreach AllActors( class'MashadarPathNode', IterMPN )
		{
			if( CanDirectlyReachDestination( IterMPN.Location ) )
			{
				IterDist = VSize( IterMPN.Location - Location );
				if( BestMPN == None || IterDist > BestDist )
				{
					BestMPN = IterMPN;
					BestDist = IterDist;
				}
			}
		}
	}
END: Old.

BEGIN: Stage II attempt.
	if( Destination != None )
	{
		Loc = Destination.Location;
	}
	else
	{
		Loc = DestLoc;
	}

	// Find the MashadarPathNode in our view that is closest to our destination.
	foreach AllActors( class'MashadarPathNode', IterMPN )
	{
		if( CanDirectlyReachDestination( IterMPN.Location ) )
		{
			IterDist = VSize( IterMPN.Location - Loc );
			if( BestMPN == None || IterDist < BestDist )
			{
				BestMPN = IterMPN;
				BestDist = IterDist;
			}
		}
	}

	// Head toward it.
	if( BestMPN != None )
	{
		SetVelocity( Normal( BestMPN.Location - Location ) * Speed );
		SetRotation( rotator(Velocity) );
	}
	else
	{
		// If we can't reach our destination using line-of-sight, 
		// level PathNodes or MashadarPathNodes, just give up
		// and retract.
		warn( "Help!! ... I need more path nodes, please." );
		Super.CannotReachDestination();
		Deactivate();
		bFullRetract = true;
	}
END: Stage II attempt.

	// MashadarPathNodes are part of the path node network,
	// so there's no need to examine them seperately.
	warn( "Help!! ... I need more path nodes, please." );
//DM( Location );
	Super.CannotReachDestination();
	Deactivate();
	bFullRetract = true;
}
*/

//------------------------------------------------------------------------------
simulated function CannotReachDestination()
{
//#define MAX_CANDIDATES 7	// Maximum number of closest path nodes collected for visibility checks.
	
	local NavigationPoint FurthestVisibleNode;
	local float FurthestVisibleDist;
	
	local NavigationPoint iNode;
	local float iDist;
	
	local NavigationPoint Candidates[/*MAX_CANDIDATES*/7];
	local float CandidateDistances[/*MAX_CANDIDATES*/7];
	
	local int i;

//	local int NumCandidates;	//!!DEBUG
//	local int NumTraces;		//!!DEBUG
//	local int NumVisible;		//!!DEBUG
	
//GuardX( "CannotReachDestination()" );
	
	// Collect the MAX_CANDIDATES closest MashadarPathNodes.
	for( iNode = Level.NavigationPointList; iNode != None; iNode = iNode.nextNavigationPoint )
	{
		if( MashadarPathNode(iNode) != None )
		{
			iDist = VSize( Location - iNode.Location );
			for( i = 0; i < /*MAX_CANDIDATES*/7; i++ )
			{
				if( Candidates[i] == None || iDist < CandidateDistances[i] )
				{
//					NumCandidates = Max( NumCandidates, i );	//!!DEBUG
					Candidates[i] = iNode;
					CandidateDistances[i] = iDist;
				}
			}
		}
	}

	// Find the furthest visible MashadarPathNode.
	for( i = 0; i < /*MAX_CANDIDATES*/7 && Candidates[i] != None; i++ )
	{
//		NumTraces++;	//!!DEBUG
		if( CanDirectlyReachDestination( Candidates[i].Location ) )
		{
//			NumVisible++;	//!!DEBUG
			if( FurthestVisibleNode == None || CandidateDistances[i] > FurthestVisibleDist )
			{
				FurthestVisibleNode = Candidates[i];
				FurthestVisibleDist = CandidateDistances[i];
			}
		}
	}

//	DM( Self$"::NumCandidates="$NumCandidates+1$" NumTraces="$NumTraces$" NumVisible="$NumVisible );	//!!DEBUG

	// Head toward it.
	if( FurthestVisibleNode != None )
	{
		//DM( Self$"::CannotReachDestination() -- Using "$FurthestVisibleNode$" for guidance." );
		SetVelocity( Speed * Normal( FurthestVisibleNode.Location - Location ) );
	}
	else
	{
/*DEBUG
		warn( "Help!! ... I need more path nodes, please." );
*/
		Super.CannotReachDestination();
	}

//UnGuardX();
}

//------------------------------------------------------------------------------
simulated function NotifySeekerBounced( NavigationPoint OnNode )
{
//GuardX( "NotifySeekerBounced()" );
	// allow bouncing.
//UnGuardX();
}

//------------------------------------------------------------------------------
// Engine notification for when this seeker has been destroyed.
//------------------------------------------------------------------------------
simulated function Destroyed()
{
//GuardX( "Destroyed()" );
	if( MasterSegment != None )
	{
		// This will trickle down through the entire chain.
		MasterSegment.Destroy();
	}

	Super.Destroyed();
//UnGuardX();
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
function Chase( Actor Tresspassor )
{
//GuardX( "Chase( "$Tresspassor$" ) -- Manager: "$Manager$" Team: "$Team );

	if( IsChasable( Tresspassor ) )
	{	
		if( !bFullRetract )
		{
			// If we are deployed, notify our manager that we were activated.
			if( bDeployed )
			{
				if( Manager.AddMashadar() )
				{
					bDeployed = false;
					bAssimilated = true;
					SeePlayerRadius = SearchRadius;
					SeePlayerHeight = SearchRadius;
				}
			}
		
			if( !bActive )
			{
				Manager.RequestActivation( Self, Tresspassor );
			}

			if( bActive )
			{
				if( bRetracting )
				{
					UnRetract();
					ClientUnRetractFID++;	// Tell the clients to UnRetract.
					//log( Self$"::ClientUnRetractFID = "$ClientUnRetractFID );
				}
				SetDestination( Tresspassor );
			}
		}
	}
//	else
//	{
//		DM( Self$"::"$Tresspassor$" is not chasable." );
//	}

//UnGuardX();
}

//------------------------------------------------------------------------------
// Decides if we should chase after the given actor based on our current target.
//------------------------------------------------------------------------------
simulated function bool IsChasable( Actor Tresspassor )
{
//GuardX( "IsChasable( "$Tresspassor$" )" );

	if( Tresspassor == None )								goto UnChasable;

	if( AngrealIllusionProjectile(Destination) != None )	goto UnChasable;	// Don't chase anything while we are sucking on a personal illusion.

	if( Tresspassor == Destination )						goto UnChasable;	// We're already chasing after it.

	if
	(	AngrealIllusionProjectile(Destination) == None
	&&	AngrealIllusionProjectile(Tresspassor) != None
	&&	AngrealIllusionProjectile(Tresspassor).Team != Team
	&&	CanReachDestination( Tresspassor.Location )
	)														goto Chasable;		// Favor personal illusions over other actors.

	if
	(	Pawn(Tresspassor) != None
	&&	Pawn(Tresspassor).Health > 0
	&&	Pawn(Tresspassor).PlayerReplicationInfo != None
	&&	Pawn(Tresspassor).PlayerReplicationInfo.Team < 255
	&&	Pawn(Tresspassor).PlayerReplicationInfo.Team != Team
//	&&	(Destination == None || VSize(Tresspassor.Location - HidingPlace.Location) < VSize(Destination.Location - HidingPlace.Location))	// Only if it is closer than our current destination.
	&&	(Destination == None || VSize(Tresspassor.Location - Location) < VSize(Destination.Location - Location))							// Only if it is closer than our current destination.
	&&	CanReachDestination( Tresspassor.Location )
	)														goto Chasable;

	goto UnChasable;

Chasable:
//UnGuardX();
//DM( "TRUE" );
	return true;

UnChasable:
//UnGuardX();
//DM( "FALSE" );
	return false;
}

//------------------------------------------------------------------------------
function bool ShouldRetract()
{
	local bool bShouldRetract;
//GuardX( "ShouldRetract()" );

	bShouldRetract = 
		(	!bResting
		&&	!bRetracting
		&&	!FollowingFocusPawn() 
/* wrong
		&&	(	Destination == None
			||	VSize(Destination.Location - HidingPlace.Location) > SeePlayerRadius
			||	Manager.ShouldStopGuarding( Self )
			)
*/
		&&	Manager.ShouldStopGuarding( Self )
		);

//UnGuardX();
	return bShouldRetract;
}

/* Polling method.
//------------------------------------------------------------------------------
function Search()
{
	local Actor ClosestPawn;
//GuardX( "Search()" );

	ClosestPawn = GetClosestPawn();
	
	// If we are not currently doing a full retract, go after the closest victim.
	// Check with our manager to make sure we're not supposed to stop guarding 
	// (if we are currently guarding).
	if( !bFullRetract && ClosestPawn != None && !Manager.ShouldStopGuarding( Self ) )
	{
		// If we are deployed, notify our manager that we were activated.
		if( bDeployed )
		{
			Manager.AddMashadar();
			bDeployed = false;
		}
	
		if( !bActive )
		{
			Manager.RequestActivation( Self, ClosestPawn );
		}

		// Only set it if it changes and we are active.
		if( bActive && ClosestPawn != Destination )
		{
			if( bRetracting )
			{
				UnRetract();
				ClientUnRetractFID++;	// Tell the clients to UnRetract.
				//log( Self$"::ClientUnRetractFID = "$ClientUnRetractFID );
			}
			SetDestination( ClosestPawn );
		}
	}
	else if( !bResting && !bRetracting && !FollowingFocusPawn() )
	{
//DM( Self$"::Search() -- deactivating..." );
		Deactivate();
		ClientDeactivateFID++;	// Tell the clients to Deactivate.
		//log( Self$"::ClientDeactivateFID = "$ClientDeactivateFID );
	}
//UnGuardX();
}
*/

//------------------------------------------------------------------------------
simulated function Reset()
{
//GuardX( "Reset()" );
	SetVelocity( vect(0,0,0) );
	SetLocation( InitialLocation );
	Speed = InitialSpeed;
	MaxSpeed = InitialMaxSpeed;
	Acceleration = InitialAcceleration;
	bFullRetract = false;
	MasterSegment.bHidden = true;
	bResting = true;
	UnRetract();
//UnGuardX();
}

//------------------------------------------------------------------------------
// Returns the last segment in the given chain.
//------------------------------------------------------------------------------
simulated function IKTrailer GetLastSegmentInChain( IKTrailer Chain )
{
	local IKTrailer Seg;
//GuardX( "GetLastSegmentInChain()" );

	Seg = Chain;

	if( Chain.ChildTrailer != None )
	{
		Seg = GetLastSegmentInChain( Chain.ChildTrailer );
	}

//UnGuardX();
	return Seg;
}

//------------------------------------------------------------------------------
// Adds a new segment at the HidingPlace.
//------------------------------------------------------------------------------
simulated function bool AddNewSegment()
{
	local MashadarTrailer NewSegment, FirstSegment;
	local bool bSafeToContinue;
//GuardX( "AddNewSegment()" );

	bSafeToContinue = true;

	// You're going to have to trust me on this one.  
	// I'll be happy to explain it to you, but I'll need a piece of paper to do it.
	NewSegment = Spawn( SegmentType,,, HidingPlace.Location - ((vect(1,0,0) * (VSize( HidingPlace.Location - LastSegment.Location ) - SegmentType.default.Dist)) >> HidingPlace.Rotation), HidingPlace.Rotation );
	NewSegment.Guide = Self;
	NewSegment.Instigator = Instigator;

	FirstSegment = MasterSegment;
	ReverseLinks();

	NewSegment.ChildTrailer = LastSegment;
	if( ReferencePoint == None )
	{
		ReferencePoint = Spawn( class'RestPoint' );
	}
	ReferencePoint.SetLocation( NewSegment.Location + ((vect(1,0,0) * NewSegment.Dist) >> NewSegment.Rotation) );
	ReferencePoint.SetRotation( NewSegment.Rotation );
	SetMasterSegment( NewSegment, ReferencePoint );
	
	ReverseLinks();
	SetMasterSegment( FirstSegment, Self );
	
	LastSegment = NewSegment;

	NumSegsAdded++;

	// Limit length (so we don't get Unreal's inifinite recursion assertion - among other things).
	if( Level.NetMode != NM_Client )	// Server-side only to keep clients in sync with server.
	{
		NumSegments++;
		//DM( Self$"::NumSegments = "$NumSegments );
		if( NumSegments > MaxNumSegments )
		{
			Deactivate();
			ClientDeactivateFID++;	// Tell the clients to Deactivate.
			//log( Self$"::ClientDeactivateFID = "$ClientDeactivateFID );
			bFullRetract = true;
			bSafeToContinue = false;
		}
	}
	else	// Enforced on clients in-case we somehow get out of sync with the server.
	{
		ClientNumSegments++;
		if( ClientNumSegments > ClientMaxNumSegments )
		{
			Deactivate();
			bFullRetract = true;
			bSafeToContinue = false;
		}
	}
//UnGuardX();

	return bSafeToContinue;
}

//------------------------------------------------------------------------------
// Positions and initalizes us to lead the last segment back to the hiding place.
//------------------------------------------------------------------------------
simulated function GuideToHidingPlace()
{
//GuardX( "GuideToHidingPlace()" );
	// Trust me.
	SetLocation( HidingPlace.Location - ((vect(1,0,0) * (LastSegment.Dist - VSize( HidingPlace.Location - LastSegment.Location ))) >> HidingPlace.Rotation) );
	SetRotation( HidingPlace.Rotation );
//DM( Self$"::GuideToHidingPlace() -- "$Location );

	// Set it up so we can guide our Segments in one at a time.
	SetMasterSegment( LastSegment, Self );

	// Guide them back to our hiding place.
	if( Destination != None )
	{
		SetDestination( None );
	}

	SetVelocity( (vect(1,0,0) * RetractSpeed) >> Rotation );
//UnGuardX();
}

//------------------------------------------------------------------------------
// Disables the current MasterSegment.
// Initializes the new MasterSegment.
// Sets its head actor with the given actor.
// Repositions it relative to its head actor.
//------------------------------------------------------------------------------
simulated function SetMasterSegment( MashadarTrailer NewMaster, Actor HeadActor )
{
//GuardX( "SetMasterSegment()" );
	DisableMasterSegment();
	MasterSegment = NewMaster;
	MasterSegment.bMaster = true;
	MasterSegment.HeadActor = HeadActor;
//	MasterSegment.Enable('Tick');

	MasterSegment.Reposition( HeadActor );
//UnGuardX();
}

//------------------------------------------------------------------------------
simulated function DisableMasterSegment()
{
//GuardX( "DisableMasterSegment()" );
	if( MasterSegment != None )
	{
		MasterSegment.bMaster = false;
		MasterSegment.HeadActor = None;
//		MasterSegment.Disable('Tick');
		MasterSegment = None;
	}
//UnGuardX();
}

//------------------------------------------------------------------------------
// Relinks the chain from LastSegment to MasterSegment.
// Disables the MasterSegment.  
// A new MasterSegment must be set after calling this function.
//------------------------------------------------------------------------------
simulated function ReverseLinks()
{
//GuardX( "ReverseLinks()" );
	ReverseLink( MasterSegment );
	MasterSegment.ChildTrailer = None;
	DisableMasterSegment();
//UnGuardX();
}

//------------------------------------------------------------------------------
// Recursively iterates through the chain, and reverses the links.
//------------------------------------------------------------------------------
simulated function ReverseLink( IKTrailer Seg )
{
////GuardX( "ReverseLink()" );
	if( Seg.ChildTrailer != None )
	{
		ReverseLink( Seg.ChildTrailer );
		Seg.ChildTrailer.ChildTrailer = Seg;
	}
////UnGuardX();
}

//------------------------------------------------------------------------------
// One-based (0 means not in list).
//------------------------------------------------------------------------------
simulated function int GetTrailerIndex( IKTrailer Segment )
{
	local int i, Index;
	local IKTrailer iSeg;
//GuardX( "GetTrailerIndex()" );

	if( MasterSegment != None && Segment != None )	// Error check.
	{
		for( iSeg = MasterSegment; iSeg != None; iSeg = iSeg.ChildTrailer )
		{
			i++;
			if( iSeg == Segment )
			{
				Index = i;
				break;
			}
		}
	}

//UnGuardX();
	return Index;
}

//------------------------------------------------------------------------------
// One-based.
//------------------------------------------------------------------------------
simulated function IKTrailer GetTrailerAt( int Index )
{
	local IKTrailer iSeg, Segment;
//GuardX( "GetTrailerAt()" );

	if( Index > 0 )	// Error check.
	{
		for( iSeg = MasterSegment; iSeg != None; iSeg = iSeg.ChildTrailer )
		{
			Index--;
			if( Index == 0 )
			{
				Segment = iSeg;
				break;
			}
		}
	}

//UnGuardX();
	return Segment;
}

//------------------------------------------------------------------------------
// Returns the closest pawn within SearchRadius units of our hiding place 
// or None.
//------------------------------------------------------------------------------
simulated function Actor GetClosestPawn()
{
	local Actor IterPawn, ClosestPawn;
	local float IterDist, ClosestDist;

	local float SearchDist;
//GuardX( "GetClosestPawn()" );

	if( bDeployed )
	{
		SearchDist = TriggerRadius;
	}
	else
	{
		SearchDist = SearchRadius;
	}

	foreach RadiusActors( class'Actor', IterPawn, SearchDist, HidingPlace.Location )
//	for( IterPawn = Level.PawnList; IterPawn != None; IterPawn = IterPawn.NextPawn )
	{
//		if( VSize( IterPawn.Location - HidingPlace.Location ) <= SearchDist )
//		{
			if
			(	(	AngrealIllusionProjectile(ClosestPawn) == None	 // favor PersonalIllusions
				&&	Pawn(IterPawn) != None
				&&	Pawn(IterPawn).Health > 0
				&&	Pawn(IterPawn).PlayerReplicationInfo != None
				&&	Pawn(IterPawn).PlayerReplicationInfo.Team < 255
				&&	Pawn(IterPawn).PlayerReplicationInfo.Team != Team
				)
			||	(AngrealIllusionProjectile(IterPawn) != None && AngrealIllusionProjectile(IterPawn).Team != Team)
			)
			{
				// Make sure we can reach him.
				if( CanReachDestination( IterPawn.Location ) )
				{
					IterDist = VSize( IterPawn.Location - Location );
					if( ClosestPawn == None || IterDist <= ClosestDist )
					{
						ClosestPawn = IterPawn;
						ClosestDist = IterDist;
					}
				}
			}
//		}
	}
	
//UnGuardX();
	return ClosestPawn;
}

//------------------------------------------------------------------------------
function CreateSoundTable()
{
//GuardX( "CreateSoundTable()" );
	if( SoundTable == None && SoundTableClass != None )
	{
		SoundTable = SoundTableWOT( SoundTableClass.static.GetInstance( Self ) );
	}
	
	if( SoundTable == None )
	{
		warn( "SetupSoundTables: error assigning sound table for: " $ Self );
	}
	
	if( SoundSlotTimerList == None && SoundSlotTimerListClass != None )
	{
		SoundSlotTimerList = Spawn( SoundSlotTimerListClass );
	}
	// not an error for SlotTimer to be None
//UnGuardX();
}

//------------------------------------------------------------------------------
function PlaySlotSound( name Slot )
{
//GuardX( "PlaySlotSound()" );
	SoundTable.PlaySlotSound( Self, Slot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, SoundSlotTimerList );
//UnGuardX();
}

//////////////////////////////
// Citadel Editor Interface //
//////////////////////////////

//------------------------------------------------------------------------------
function Deploy()
{
//GuardX( "Deploy()" );
	bDeployed = true;
	SeePlayerRadius = TriggerRadius;
	SeePlayerHeight = TriggerRadius;
//UnGuardX();
}

//------------------------------------------------------------------------------
function UnDeploy()
{
//GuardX( "UnDeploy()" );
	bDeployed = false;
	SeePlayerRadius = SearchRadius;
	SeePlayerHeight = SearchRadius;
	
	if( bAssimilated )
	{
		Manager.RemoveMashadar( Self );
		bAssimilated = false;
	}
//UnGuardX();
}

//------------------------------------------------------------------------------
function SetFocusPawn( MashadarFocusPawn MFP )
{
//GuardX( "SetFocusPawn()" );
/* -- let FocusPawn.Tendril act as a "last assigned MashadarGuide".
	// Invalidate ourself with our old FocusPawn.
	if( FocusPawn != None )
	{
		FocusPawn.Tendril = None;
	}
*/
	FocusPawn = MFP;

	if( FocusPawn != None )
	{
		ClientSetFocusPawnA();
		ClientSetFocusPawnAFID++;	// Tell the clients to update.
		//log( Self$"::ClientSetFocusPawnAFID = "$ClientSetFocusPawnAFID );
		
		SetDestination( FocusPawn );
		FocusPawn.Tendril = Self;
	}
	else
	{
		ClientSetFocusPawnB();
		ClientSetFocusPawnBFID++;	// Tell the clients to update.
		//log( Self$"::ClientSetFocusPawnBFID = "$ClientSetFocusPawnBFID );
	}
//UnGuardX();
}
simulated function ClientSetFocusPawnA()
{
//GuardX( "ClientSetFocusPawnA()" );
	if( bRetracting )
	{
		UnRetract();
	}
	Speed = CitadelEditingSpeed;
	MaxSpeed = CitadelEditingSpeed;
//UnGuardX();
}
simulated function ClientSetFocusPawnB()
{
//GuardX( "ClientSetFocusPawnB()" );
	Speed = InitialSpeed;
	MaxSpeed = InitialMaxSpeed;
	Retract();
//UnGuardX();
}

//------------------------------------------------------------------------------
simulated function bool FollowingFocusPawn()
{
//GuardX( "FollowingFocusPawn()" );
//UnGuardX();
	return FocusPawn != None;
}

////////////
// Orders //
////////////

//------------------------------------------------------------------------------
// Returns an identifier for this order.
//------------------------------------------------------------------------------
function int GuardLocation( vector Loc )
{
//GuardX( "GuardLocation()" );
	UnDeploy();
//UnGuardX();
	return Manager.AddGuardPoint( Loc );
}

//------------------------------------------------------------------------------
// Returns an identifier for this order.
//------------------------------------------------------------------------------
function int GuardActor( Actor Victim )
{
//GuardX( "GuardActor()" );
	UnDeploy();
//UnGuardX();
	return Manager.AddGuardActor( Victim );
}

//------------------------------------------------------------------------------
// Returns an identifier for this order.
//------------------------------------------------------------------------------
function int GuardSeal()
{
//GuardX( "GuardSeal()" );
	UnDeploy();
	Manager.IncrementSealGuardCount();
//UnGuardX();
	return class'MashadarGuide'.default.GuardSealID;
}

//------------------------------------------------------------------------------
function UnGuard( int GuardID )
{
//GuardX( "UnGuard()" );
/* -- doesn't differentiate between duplicate GuardPoints or GuardActors in the GuardData array.
	local Actor GuardActor;
	local vector GuardPoint;
	local byte Claimed;

	if( Manager.GetGuardData( GuardID, GuardActor, GuardPoint, Claimed ) )
	{
		if( GuardActor != None )
		{
			Manager.RemoveGuardActor( GuardActor );
		}
		else
		{
			Manager.RemoveGuardPoint( GuardPoint );
		}
	}
	else
	{
		warn( "Invalid GuardID" );
	}
*/
	if( GuardID == class'MashadarGuide'.default.GuardSealID )
	{
		Manager.DecrementSealGuardCount();
	}
	else
	{
		Manager.ResetGuardData( GuardID );
	}
	Deploy();
//UnGuardX();
}

/////////////////
// Debug stuff //
/////////////////

//------------------------------------------------------------------------------
simulated function GuardX( coerce string Message )
{
	local int i;
	local string Buffer;

	BufferLength++;

	for( i = 0; i < BufferLength; i++ )
	{
		Buffer = Buffer$"::";
	}

	//DM( Self$Buffer$Message );
	log( Self$Buffer$Message );
}

//------------------------------------------------------------------------------
simulated function UnGuardX()
{
	BufferLength--;
}

defaultproperties
{
     HeadType=Class'WOTPawns.MashadarTip'
     SegmentType=Class'WOTPawns.MashadarSegment'
     SearchRadius=600.000000
     SearchResolution=2.000000
     RetractSpeed=700.000000
     CitadelEditingSpeed=400.000000
     MPSpeed=200.000000
     MPMaxSpeed=400.000000
     MPAccel=25.000000
     Team=255
     GuardID=-1
     GuardSealID=-999
     TriggerRadius=200.000000
     MaxNumSegments=100
     ClientMaxNumSegments=150
     SeePlayerResolutionMin=3.000000
     SeePlayerResolutionMax=6.000000
     SoundTableClass=Class'WOTPawns.SoundTableMashadar2'
     VolumeMultiplier=1.000000
     RadiusMultiplier=1.000000
     PitchMultiplier=1.000000
     TimeBetweenHitSounds=1.000000
     Acceleration=2.500000
     bTakeShortcuts=False
     ReachTolerance=50.000000
     bNotifiesDestination=False
     speed=150.000000
     MaxSpeed=500.000000
     MomentumTransfer=2000
     bNotifySeePlayer=True
     bHidden=True
     bCanTeleport=False
     LifeSpan=0.000000
     DrawType=DT_Sprite
     Texture=Texture'Engine.S_Actor'
     bGameRelevant=False
     bCollideActors=False
     bCollideWorld=False
     bAllowClipping=True
}
