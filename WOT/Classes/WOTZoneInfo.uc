//=============================================================================
// WOTZoneInfo.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 9 $
//=============================================================================
class WOTZoneInfo expands ZoneInfo
	intrinsic;

var(CitadelEditor) byte Team;				// =255 don't care, otherwise limit Citadel Editor (CE) access
var(CitadelEditor) byte MinEditDistance;	// =0 can't edit from this zone (feet)
var(CitadelEditor) rotator EditViewAngle;	// Optimum CE view angle for this room
var(CitadelEditor) float EditViewDistance;	// Optimum CE view distance for this room (feet)
var(CitadelEditor) bool bAllowEditing;		// enable the editor in this zone

var() bool bPitZone;					// help AI know when they're stuck in a pit (does not affect physics code)

var() bool bHealZone;					// if true, add "HealPerSec" to pawn/player's health each second
var() int HealPerSec;					// amount to heal a pawn or player each second when bHealZone is true
var() sound HealSound;					// play this sound for player's when healing is applied

var() bool bFOVZone;					// Sets Player's FOV to ZoneFOV while in this zone.
var() float ZoneFOV;

var(TrigWater) bool bTrigWaterZone;		// "bWaterZone" is triggerable
var(TrigWater) name ReferenceZone;		// Zone to use attributes of when we are not water.

var(TrigVelocity) bool bTrigZoneVelocity;	// "ZoneVelocity" is triggerable
var(TrigVelocity) bool bUseSteps;			// The new velocity will be "stepped" up to.
var(TrigVelocity) int NumSteps;
var(TrigVelocity) float PauseBetweenSteps;
var(TrigVelocity) vector StepVelocity;
var(TrigVelocity) vector NewZoneVelocity;
var(TrigVelocity) float Duration;			// How long to stay triggered during a TriggerToggle

var(TrigPain) bool bTrigPainZone;			// "bPainZone" is triggerable

var vector SaveViewFog;						// Used to store original ViewFog
var vector SaveZoneVelocity;				// Used to store original Velocity
var bool bZoneVelocityOn;
var Actor LastTriggerer;
var int VZCurrentStep;
var name PrevStateName;

var() bool bLeechZone;					// Attaches the given leeches to players while in this zone.
var() Class<Leech> LeechClasses[16];

// local variable used in latent state code below
var int x;

//TrigVelo2:begin
var(TrigVelo2) bool		bTrigZoneVelo2;				// Aaron's triggerable velocity zone.
var(TrigVelo2) bool		bTrigZoneVelo2InitiallyOn;	// Aaron's triggerable velocity zone.
var(TrigVelo2) vector	MaxZoneVelocity2;			// Max zone velocity. (when on)
var(TrigVelo2) vector	MinZoneVelocity2;			// Min zone velocity. (when off)
var(TrigVelo2) float	TransitionTime2;			// Amount of time to reach desired zone velocity. (greater than zero)
var vector VeloPerSec2;
var bool bTrigZoneVeloOn;
//TrigVelo2:end

var() float TriggerDuration;	// Used for TriggerTimed.

// TimerLeech support.
var(ZoneTimer) float TimerLeechDuration[3];	// by difficulty.
var(ZoneTimer) Texture TimerLeechIcon;
var(ZoneTimer) bool bPersistentTimer;
var(ZoneTimer) bool bRemoveTimerOnExit;
var(ZoneTimer) bool bTimerOnRight;
var(ZoneTimer) bool bOnlyTimeOnce;
var bool bAttachedTimer;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if( Role == ROLE_Authority )
	{
		//TrigVelo2:begin
		if( bTrigZoneVelo2 )
		{
			VeloPerSec2 = (MaxZoneVelocity2 - MinZoneVelocity2) / TransitionTime2;
			bTrigZoneVeloOn = bTrigZoneVelo2InitiallyOn;
			if( bTrigZoneVeloOn )
			{
				ZoneVelocity = MaxZoneVelocity2;
			}
			else
			{
				ZoneVelocity = MinZoneVelocity2;
			}
		}
		//TrigVelo2:end

		// save variables so they can be recovered when using triggerable zones.
		SaveViewFog = ViewFog;
		SaveZoneVelocity = ZoneVelocity;
		
		bZoneVelocityOn = false;
		
		//SetTimer( 1, false );
	}
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	//TrigVelo2:begin
	if( bTrigZoneVelo2 && Role == ROLE_Authority )
	{
		if( bTrigZoneVeloOn && ZoneVelocity != MaxZoneVelocity2 )
		{
			ZoneVelocity += VeloPerSec2;	
			if( !class'Util'.static.VectorAproxEqual( Normal(VeloPerSec2), Normal(MaxZoneVelocity2 - ZoneVelocity) ) )
			{
				ZoneVelocity = MaxZoneVelocity2;
			}
		}
		else if( ZoneVelocity != MinZoneVelocity2 )
		{
			ZoneVelocity -= VeloPerSec2;
			if( !class'Util'.static.VectorAproxEqual( Normal(-VeloPerSec2), Normal(MinZoneVelocity2 - ZoneVelocity) ) )
			{
				ZoneVelocity = MinZoneVelocity2;
			}
		}
	}
	//TrigVelo2:end
}

simulated function LinkToSkybox()
{
	local skyzoneinfo S;

	Super.LinkToSkybox();

	// set the skyzone to a SkyZone actor with a Tag that matches our event
	foreach AllActors( class 'SkyZoneInfo', S, Event )
	{
		SkyZone = S;
	}
}

// Finds the first WOTZoneInfo in the level with the specified Tag.
function WOTZoneInfo GetReferenceZone( name ZoneTag )
{
	local WOTZoneInfo Z;
	
	foreach AllActors( class 'WOTZoneInfo', Z )
	{
		if( Z != Self && Z.Tag == ZoneTag )
		{
			return Z;
		}
	}
	
	return Self;
}

state() TriggerToggle
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		if( bTrigWaterZone )
		{
			TriggerWaterZone( Other, !bWaterZone );
		}
		if( bTrigZoneVelocity )
		{
			TriggerZoneVelocity( Other, !bZoneVelocityOn );
		}
		if( bTrigPainZone )
		{
			TriggerPainZone( Other, !bPainZone );
		}
		//TrigVelo2:begin
		if( bTrigZoneVelo2 )
		{
			bTrigZoneVeloOn = !bTrigZoneVeloOn;
		}
		//TrigVelo2:end
	}
}

//TrigVelo2:begin
state() TriggerControl
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		if( bTrigZoneVelo2 )
		{
			bTrigZoneVeloOn = !bTrigZoneVelo2InitiallyOn;
		}
	}
	function UnTrigger( Actor Other, Pawn EventInstigator )
	{
		if( bTrigZoneVelo2 )
		{
			bTrigZoneVeloOn = bTrigZoneVelo2InitiallyOn;
		}
	}
}

state() TriggerTimed
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		if( bTrigZoneVelo2 )
		{
			bTrigZoneVeloOn = !bTrigZoneVelo2InitiallyOn;
			SetTimer( TriggerDuration, false );
		}
	}
	function Timer()
	{
		if( bTrigZoneVelo2 )
		{
			bTrigZoneVeloOn = bTrigZoneVelo2InitiallyOn;
		}
	}
}
//TrigVelo2:end

function TriggerZoneVelocity( actor Other, BOOL OnOff )
{
	bZoneVelocityOn = OnOff;

	PrevStateName = GetStateName();	
	
	Disable( PrevStateName );
	
	if( OnOff )
	{
		GotoState( 'VelocityOn' );
	}
	else
	{
		GotoState( 'VelocityOff' );
	}
}

state VelocityOn
{
Begin:
	if( bUseSteps )
	{
		for( x = 0; x < NumSteps; x++ )
		{
			ZoneVelocity += StepVelocity;
			Sleep( PauseBetweenSteps );
		}
	}

	ZoneVelocity = NewZoneVelocity;
	
	Enable( PrevStateName );
	GotoState( PrevStateName );
}

state VelocityOff
{
Begin:
	if( bUseSteps )
	{
		for( x = 0; x < NumSteps; x++ )
		{
			ZoneVelocity -= StepVelocity;
			Sleep( PauseBetweenSteps );
		}
	}

	ZoneVelocity = SaveZoneVelocity;
	
	Enable( PrevStateName );
	GotoState( PrevStateName );
}

function TriggerWaterZone( actor Other, BOOL OnOff )
{
	// If players head is inside this zone, make sure the zone attribs are turned off.
	if( PlayerPawn(Other).HeadRegion.Zone == Self )
	{
		ActorLeaving( PlayerPawn(Other) );
	}

	bWaterZone = OnOff;

	// We need to mess with the players physics here or things act strangely.
	//
	// NOTE : This is the only way I know of to check if the player is inside of the
	// water zone.  If there is a better way, please replace this.
	if( PlayerPawn(Other).HeadRegion.Zone == self
		|| PlayerPawn(Other).FootRegion.Zone == self )
	{
		if( PlayerPawn(Other).Health > 0 )
		{
			if( bWaterZone )
			{
				PlayerPawn(Other).setPhysics( PHYS_Swimming );
				PlayerPawn(Other).GotoState( 'PlayerSwimming' );
			}
			else 
			{
				PlayerPawn(Other).setPhysics( PHYS_Walking );
				PlayerPawn(Other).GotoState( 'PlayerWalking' );
			}
		}
	}
		
	// If players head is inside this zone, make sure the new zone attribs are turned on.
	if( PlayerPawn(Other).HeadRegion.Zone == self )
	{
		ActorEntered( PlayerPawn(Other) );
	}
}

function TriggerPainZone( actor Other, BOOL OnOff )
{
	if( PlayerPawn(Other).HeadRegion.Zone == self
		|| PlayerPawn(Other).FootRegion.Zone == self )
	{
		ActorLeaving( PlayerPawn(Other) );
	}
	
	bPainZone = OnOff;

	if( PlayerPawn(Other).HeadRegion.Zone == self
		|| PlayerPawn(Other).FootRegion.Zone == self )
	{
		ActorEntered( PlayerPawn(Other) );

		// If this zone has become a pain zone, we need to kick start the pain timer.
		if( bPainZone )
		{
			PlayerPawn(Other).PainTime = 0.01;
		}
	}
}

simulated event ActorEntered( actor Other )
{
	local PlayerPawn Player;
	local WOTZoneInfo ZoneRef;
	local Leech L;
	local int i;

	Player = PlayerPawn(Other);
	if( Player != None ) 
	{
		// If there is a reference zone being used and we are not currently a waterzone, 
		// go get it and use it for the rest of this function.
		if( bTrigWaterZone && ReferenceZone != '' && !bWaterZone )
		{
			ZoneRef = GetReferenceZone( ReferenceZone );
			ViewFog = ZoneRef.ViewFog;
		}
		else
		{
			// default to this zone.
			ZoneRef = Self;
			ViewFog = SaveViewFog;
		}
				
		// Update the player's FOV.
		if( ZoneRef.bFOVZone )
		{
			Player.SetDesiredFOV( ZoneRef.ZoneFOV );
		}
		
		// Attach leeches.
		if( ZoneRef.bLeechZone && WOTPlayer(Player) != None )
		{
			for( i = 0; i < ArrayCount(ZoneRef.LeechClasses); i++ )
			{
				if( ZoneRef.LeechClasses[i] != None )
				{
					L = Spawn( ZoneRef.LeechClasses[i],, Name );
					L.AttachTo( Player );
				}
			}
		}

		// TimerLeech support.
		if( Role == ROLE_Authority )
		{
			if( ZoneRef.TimerLeechDuration[Level.Game.Difficulty] > 0.0 && ( !ZoneRef.bAttachedTimer || !ZoneRef.bOnlyTimeOnce ) )
			{
				L = Spawn( class'TimerLeech',, Name );
				TimerLeech(L).LifeSpan = ZoneRef.TimerLeechDuration[Level.Game.Difficulty];
				TimerLeech(L).StatusIconFrame = ZoneRef.TimerLeechIcon;
				L.bSingular = ZoneRef.bPersistentTimer;
				L.bDeleterious = ZoneRef.bTimerOnRight;
				L.AttachTo( Player );
				ZoneRef.bAttachedTimer = true;
			}
		}
	}

	Super.ActorEntered( Other );
}

// Undo stuff in reverse order.
simulated event ActorLeaving( actor Other )
{
	local PlayerPawn Player;
	local LeechIterator IterL;
	local Leech L;

	Player = PlayerPawn(Other);
	if( Player != None ) 
	{
		// Detach our leeches.
		if( (bLeechZone || (Role == ROLE_Authority && TimerLeechDuration[Level.Game.Difficulty] > 0.0)) && WOTPlayer(Player) != None )
		{
			IterL = class'LeechIterator'.static.GetIteratorFor( Player );
			for( IterL.First(); !IterL.IsDone(); IterL.Next() )
			{
				L = IterL.GetCurrent();

				if( L.Tag == Name && !(TimerLeech(L) != None && !bRemoveTimerOnExit) )
				{
					L.UnAttach();
					L.Destroy();
				}
			}
			IterL.Reset();
			IterL = None;
		}
		
		// Reset the player's FOV to the default value.
		if( bFOVZone )
		{
			Player.SetDesiredFOV( Player.default.DesiredFOV );
		}
	}
}

simulated function bool IsZoneVisible( int iPlayerTeam )
{
	return Team == 255 || Team == iPlayerTeam;
}

// end of WOTZoneInfo.uc

defaultproperties
{
     Team=255
     EditViewAngle=(Pitch=-8192)
     EditViewDistance=32.000000
     bAllowEditing=True
}
