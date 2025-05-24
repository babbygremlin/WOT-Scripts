//=============================================================================
// WOTCarcassBase.
//=============================================================================

class WOTCarcassBase expands Carcass abstract;

var() string DamageCarcassBloodClassStr;	// blood effect for damaging carcass/parts
var() string GibbedBloodClassStr;			// blood effect for initial gibbing of Pawn/Carcass
var() string TrailChunksBloodClassStr;		// blood effect for trailing flying parts
var() Class<Decal> BloodDecalClass;			// class for decals used with above
var() float TimeBetweenZoneChecksSecs;		// time between checks for current zone
var() float PainZoneDamageScale;			// use to scale damage from pain zone (e.g. reduce for chunks)
var() bool  bPermanent;						// set to true so carcass/gib will never be cleaned up
var() bool  bTakesDamage;					// if false, carcass/chunk doesn't take damage (e.g. skulls, legion carcass etc.)

var float SourceCollisionHeight;			// used to save source Actor's collision height
var float SourceCollisionRadius;			// used to save source Actor's collision radius
var float NextZoneCheckTime;				// used to save next time to check zone

//=============================================================================

function InheritBloodClasses( WOTCarcassBase Other )
{
	DamageCarcassBloodClassStr	= Other.DamageCarcassBloodClassStr;
	GibbedBloodClassStr			= Other.GibbedBloodClassStr;
	TrailChunksBloodClassStr	= Other.TrailChunksBloodClassStr;
	BloodDecalClass				= Other.BloodDecalClass;
}

//=============================================================================

function Actor SpawnBlood( Vector Location, string BloodEffectClassStr )
{
	local class<Actor> EffectC;
	local Actor EffectA;

	if( BloodEffectClassStr != "" )
	{
		EffectC = class<Actor>( DynamicLoadObject( BloodEffectClassStr, class'Class' ) );
		EffectA = Spawn( EffectC,,,Location, Rotator(vect(0,0,1)) );
	}

	return EffectA;
}

//=============================================================================
// If in a destructive zone, apply lots of damage to carcass (chunks should be
// destroyed pretty much right away). If in a pain zone, apply DamagePerSec to 
// carcass so it should eventually gib (carcass) and chunks should eventually 
// be destroyed.

function CheckZone( ZoneInfo Zone, float DeltaTimeSecs )
{
	if( bTakesDamage )
	{
		if( Zone.bDestructive )
		{
			TakeDamage( 100, None, location, vect(0,0,0), Zone.DamageType );
		}
		else if( Zone.bPainZone && (Zone.DamagePerSec > 0) )
		{
			TakeDamage( PainZoneDamageScale*DeltaTimeSecs*Zone.DamagePerSec, None, Location, vect(0,0,0), 'PainZone' );
		}
	}
}

//=============================================================================
// Call CheckZone every TimeBetweenZoneChecksSecs secs.

function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( Level.TimeSeconds >= NextZoneCheckTime )
	{
		CheckZone( Region.Zone, TimeBetweenZoneChecksSecs );

		NextZoneCheckTime = Level.TimeSeconds + TimeBetweenZoneChecksSecs;
	}
}

//=============================================================================

function DoPlaySound( Sound Sound, ESoundSlot Slot, float Volume )
{
	PlaySound( Sound, Slot, Volume );
}

//=============================================================================
// Overridden primarly to be able to have pain zones do damage to carcasses and
// carcass-derived classes over time.

simulated function ZoneChange( ZoneInfo NewZone )
{
	local float SplashSize;
	local actor Splash;

	if( NewZone.bWaterZone )
	{
		if( Mass <= Buoyancy )
		{
			SetCollisionSize( 0, 0 );
		}

		if( bSplash && !Region.Zone.bWaterZone && (Abs(Velocity.Z) < 80) )
		{
			RotationRate *= 0.6;
		}
		else if( !Region.Zone.bWaterZone && (Velocity.Z < -200) )
		{
			// else play a splash
			SplashSize = FClamp( 0.0001 * Mass * (250 - 0.5 * FMax(-600,Velocity.Z)), 1.0, 3.0 );

			if( NewZone.EntrySound != None )
			{
				DoPlaySound( NewZone.EntrySound, SLOT_Interact, SplashSize );
			}

			if( NewZone.EntryActor != None )
			{
				Splash = Spawn( NewZone.EntryActor ); 

				if( Splash != None )
				{
					Splash.DrawScale = SplashSize;
				}
			}
		}
		bSplash = true;
	}

	CheckZone( NewZone, 1.0 );
}
	
//=============================================================================

defaultproperties
{
     DamageCarcassBloodClassStr="ParticleSystems.BloodSprayRed"
     GibbedBloodClassStr="ParticleSystems.BloodBurstRed2"
     BloodDecalClass=Class'ParticleSystems.BloodDecalRed'
     TimeBetweenZoneChecksSecs=1.000000
     PainZoneDamageScale=1.000000
     bTakesDamage=True
     bCanFallOutOfWorld=True
}
