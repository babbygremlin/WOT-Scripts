//------------------------------------------------------------------------------
// TrapDetectLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 7 $
//
// Description:	Notifies Owner of nearby traps.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class TrapDetectLeech expands Leech;

// NOTE[aleiby]: Replication -- client-side only?

#exec OBJ	LOAD	FILE=Textures\TrapDetectT.utx		PACKAGE=Angreal.TrapDetect //FIXME missing
#exec AUDIO	IMPORT	FILE=Sounds\TrapDetect\ActiveTD.wav	GROUP=TrapDetect

struct TrapIconInfo
{
	var() name		TrapType;		// Name of trap this info is used for.
	var() Texture	TrapIcon;		// Sprite to indicate what this trap is.
	var() float		IconScale;		// Size of above said sprite.
	
	// ParticleSystem properties for sparkles.
	//
	var() Texture	SparkleSprite;
	var() float		Weight;
	var() float		MaxInitialVelocity;
	var() float		MinInitialVelocity;
	var() float		MaxDrawScale;
	var() float		MinDrawScale;
	var() float		MaxScaleGlow;
	var() float		MinScaleGlow;
	var() byte		GrowPhase;
	var() float		MaxGrowRate;
	var() float		MinGrowRate;
	var() byte		FadePhase;
	var() float		MaxFadeRate;
	var() float		MinFadeRate;
};

var() TrapIconInfo TrapIconInfos[6];	// Settings to use for various traps.

var() Sound DetectSound;
var() float DetectRadius;

var() float MinBeatTime, MaxBeatTime;	// Seconds between beats.
var() float MinBeatVolume, MaxBeatVolume;

var float Scalar;		// Percent closeness to trap.  (0.0 = right on top, 1.0 = furthest away)
var Actor ClosestTrap;	// Last found trap in Detect radius... if any.
var Actor LastClosestTrap;

// Visuals.
var ParticleSprayer	Indicator;
var GenericSprite	TrapIcon;

//------------------------------------------------------------------------------
simulated function AffectHost( optional int Iterations )
{
	if
	(	(Level.NetMode == NM_Standalone || Role < ROLE_Authority)	// Execute in singleplayer, or on the client-only in multiplayer.
	&&	ClosestTrap != None
	&&	PlayerPawn(Owner) != None
	)
	{
		PlayerPawn(Owner).ClientPlaySound( DetectSound );
	}
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local float TrapDistance;
	local vector ClosestPoint;
	local vector Loc;

	if( Level.NetMode == NM_Standalone || Role < ROLE_Authority )	// Execute in singleplayer, or on the client-only in multiplayer.
	{
		ClosestTrap = GetClosestTrap( TrapDistance, ClosestPoint );

		if( ClosestTrap != None && InitializeVisualsFor( ClosestTrap ) )
		{
			Loc = Owner.Location + (vect(0,0,1) * Pawn(Owner).BaseEyeHeight);

			TrapIcon.SetLocation( ClosestPoint );
			TrapIcon.SetRotation( rotator(Loc - Indicator.Location) );
			Indicator.SetLocation( TrapIcon.Location );
			Indicator.SetRotation( TrapIcon.Rotation );

			Scalar = FClamp( TrapDistance / DetectRadius, 0.0, 1.0 );
			AffectResolution = MinBeatTime + (MaxBeatTime - MinBeatTime) * Scalar;
		}
		else
		{
			ClosestTrap = None;	// To stop heart-beat.

			if( TrapIcon != None )
			{
				TrapIcon.bHidden = true;
			}
			if( Indicator != None )
			{
				Indicator.bOn = false;
			}
		}
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	Super.Destroyed();

	if( TrapIcon != None )
	{
		TrapIcon.Destroy();
		TrapIcon = None;
	}
	if( Indicator != None )
	{
		Indicator.bOn = false;
		Indicator.LifeSpan = 60.0;
		Indicator = None;
	}
}

//------------------------------------------------------------------------------
// Finds and returns the closest trap.
// If new traps are added to the game, update this function to check for them. 
//------------------------------------------------------------------------------
simulated function Actor GetClosestTrap( out float TrapDistance, out vector ClosestPoint )
{
	local Actor IterA;
	
	local float		FOVCos;
	local vector	Loc;
	local rotator	ViewRot;
	local vector	ViewVec;
	local vector	IterClosestPoint;
	local float		ViewDist;
	local float		LocDist;
	local float		DistRatio;
	local float		BestRatio;
	local Actor		BestTarget;
	local vector	HitLocation, HitNormal;
//	local ActorCollection DetectableTraps;

	if( Owner == None )
	{
		return None;
	}

	Loc		= Owner.Location + (vect(0,0,1) * Pawn(Owner).BaseEyeHeight);
	ViewRot	= Pawn(Owner).ViewRotation;
	ViewVec	= vector(ViewRot);

	// First try a direct trace to the first targetable actor.
	BestTarget = class'Util'.static.TraceRecursive( Self, HitLocation, HitNormal, Loc, true,, ViewVec, DetectRadius );
	if( BestTarget != None && IsTrapRelevant( BestTarget ) )
	{
		//ClosestPoint = class'Util'.static.CalcClosestCollisionPoint( BestTarget, Loc );
		ClosestPoint = class'Util'.static.CalcClosestCollisionPoint( BestTarget, Owner.Location );
		TrapDistance = VSize( ClosestPoint - Loc );
	}
	else
	{
		FOVCos = class'Util'.static.DCos( 90.0 );

		foreach RadiusActors( class'Actor', IterA, DetectRadius, Loc )
//		DetectableTraps = Level.GetCollection('DetectableTraps');
//		for( IterA = DetectableTraps.GetFirst(); !DetectableTraps.IsDone(); IterA = DetectableTraps.GetNext() )
		{
//			if( VSize(IterA.Location - Loc) <= DetectRadius )
//			{
				if( IsTrapRelevant( IterA ) /*&& class'Util'.static.PawnCanSeeActor( Pawn(Owner), IterA, FOVCos )*/ )
				{
					// Find closest to center of screen.
					//IterClosestPoint = class'Util'.static.CalcClosestCollisionPoint( IterA, Loc );
					IterClosestPoint = class'Util'.static.CalcClosestCollisionPoint( IterA, Owner.Location );
					ViewDist = ((IterClosestPoint - Loc) << ViewRot).X;	// Distance down the ViewRot.
					LocDist = VSize( IterClosestPoint - Loc );			// Distance from Loc.
					DistRatio = ViewDist / LocDist;
					if( BestTarget == None || DistRatio > BestRatio ) 
					{
						BestTarget		= IterA;
						BestRatio		= DistRatio;
						TrapDistance	= LocDist;
						ClosestPoint	= IterClosestPoint;
					}
				}
//			}
		}
	}

	return BestTarget;
}

//------------------------------------------------------------------------------
simulated function bool IsTrapRelevant( Actor Trap )
{
	local int i;

	if
	(	(Trap(Trap) != None && Trap(Trap).IsTrapDeployed())								// If it's a deployed Trap,
	||	(AngrealExpWardProjectile(Trap) != None && Trap.GetStateName() != 'Waiting')	// or a non-waiting ExplosiveWard...
	)
	{
		for( i = 0; i < ArrayCount(TrapIconInfos); i++ )
		{
			if( TrapIconInfos[i].TrapType == GetTrapID( Trap ) )
			{
				return true;
			}
		}
	}

	return false;
}

//------------------------------------------------------------------------------
simulated function name GetTrapID( Actor Trap )
{
	if( Trap(Trap) != None && Trap(Trap).TrapType != '' )
	{
		return Trap(Trap).TrapType;
	}
	else
	{
		return Trap.Class.Name;
	}
}

//------------------------------------------------------------------------------
simulated function bool InitializeVisualsFor( Actor Trap )
{
	local int i;
	
	for( i = 0; i < ArrayCount(TrapIconInfos); i++ )
	{
		if( TrapIconInfos[i].TrapType == GetTrapID( Trap ) )
		{
			if( TrapIcon == None )
			{
				TrapIcon = Spawn( class'DefaultTrapIcon', Owner );		// Contains settings common to most trap icons.
			}
			if( Indicator == None )
			{
				Indicator = Spawn( class'DefaultTrapSprayer', Owner );	// Contains settings common to most trap sprayers.
			}

			TrapIcon.bHidden = false;
			Indicator.bOn = true;
			
			// Fill in exceptions.
			TrapIcon.Texture						= TrapIconInfos[i].TrapIcon;
			TrapIcon.DrawScale						= TrapIconInfos[i].IconScale;
			Indicator.Particles[0]					= TrapIconInfos[i].TrapIcon;
			Indicator.Particles[1]					= TrapIconInfos[i].SparkleSprite;
			Indicator.SetParticleWeight				( TrapIconInfos[i].Weight,				1 );
			Indicator.SetParticleMaxInitialVelocity	( TrapIconInfos[i].MaxInitialVelocity,	1 );
			Indicator.SetParticleMinInitialVelocity	( TrapIconInfos[i].MinInitialVelocity,	1 );
			Indicator.SetParticleMaxDrawScale		( TrapIconInfos[i].MaxDrawScale,		1 );
			Indicator.SetParticleMinDrawScale		( TrapIconInfos[i].MinDrawScale,		1 );
			Indicator.SetParticleMaxScaleGlow		( TrapIconInfos[i].MaxScaleGlow,		1 );
			Indicator.SetParticleMinScaleGlow		( TrapIconInfos[i].MinScaleGlow,		1 );
			Indicator.SetParticleGrowPhase			( TrapIconInfos[i].GrowPhase,			1 );
			Indicator.SetParticleMaxGrowRate		( TrapIconInfos[i].MaxGrowRate,			1 );
			Indicator.SetParticleMinGrowRate		( TrapIconInfos[i].MinGrowRate,			1 );
			Indicator.SetParticleFadePhase			( TrapIconInfos[i].FadePhase,			1 );
			Indicator.SetParticleMaxFadeRate		( TrapIconInfos[i].MaxFadeRate,			1 );
			Indicator.SetParticleMinFadeRate		( TrapIconInfos[i].MinFadeRate,			1 );

			return true;
		}
	}

	return false;
}

defaultproperties
{
     TrapIconInfos(0)=(TrapType=WallSlab,TrapIcon=Texture'Angreal.TrapDetect.TrapWallParts',IconScale=0.300000,SparkleSprite=Texture'ParticleSystems.Appear.PurpleCorona',Weight=3.000000,MaxInitialVelocity=17.000000,MinInitialVelocity=12.000000,MaxDrawScale=0.200000,MinDrawScale=0.075000,MaxScaleGlow=-0.010000,MinScaleGlow=-0.020000,GrowPhase=2,MaxGrowRate=0.200000,FadePhase=2,MaxFadeRate=0.400000,MinFadeRate=0.750000)
     TrapIconInfos(1)=(TrapType=Pit,TrapIcon=Texture'Angreal.TrapDetect.TrapPitParts',IconScale=0.300000,SparkleSprite=Texture'ParticleSystems.Appear.AOrangeCorona',Weight=3.000000,MaxInitialVelocity=17.000000,MinInitialVelocity=12.000000,MaxDrawScale=0.200000,MinDrawScale=0.075000,MaxScaleGlow=-0.010000,MinScaleGlow=-0.020000,GrowPhase=2,MaxGrowRate=0.200000,FadePhase=2,MaxFadeRate=0.400000,MinFadeRate=0.750000)
     TrapIconInfos(2)=(TrapType=Portcullis,TrapIcon=Texture'Angreal.TrapDetect.TrapPortculParts',IconScale=0.300000,SparkleSprite=Texture'ParticleSystems.Appear.APinkCorona',Weight=3.000000,MaxInitialVelocity=17.000000,MinInitialVelocity=12.000000,MaxDrawScale=0.200000,MinDrawScale=0.075000,MaxScaleGlow=-0.010000,MinScaleGlow=-0.020000,GrowPhase=2,MaxGrowRate=0.200000,FadePhase=2,MaxFadeRate=0.400000,MinFadeRate=0.750000)
     TrapIconInfos(3)=(TrapType=Spear,TrapIcon=Texture'Angreal.TrapDetect.TrapSpearParts',IconScale=0.400000,SparkleSprite=Texture'ParticleSystems.Fire.Flame06',Weight=1.000000,MaxInitialVelocity=11.000000,MaxDrawScale=0.350000,MinDrawScale=0.150000,MaxScaleGlow=0.250000,MinScaleGlow=0.500000,GrowPhase=2,MaxGrowRate=0.200000,FadePhase=1,MaxFadeRate=-0.400000,MinFadeRate=-0.750000)
     TrapIconInfos(4)=(TrapType=Staircase,TrapIcon=Texture'Angreal.TrapDetect.TrapStairParts',IconScale=0.300000,SparkleSprite=Texture'ParticleSystems.Appear.AYellowCorona',Weight=3.000000,MaxInitialVelocity=17.000000,MinInitialVelocity=12.000000,MaxDrawScale=0.200000,MinDrawScale=0.075000,MaxScaleGlow=-0.010000,MinScaleGlow=-0.020000,GrowPhase=2,MaxGrowRate=0.200000,FadePhase=2,MaxFadeRate=0.400000,MinFadeRate=0.750000)
     TrapIconInfos(5)=(TrapType=AngrealExpWardProjectile,TrapIcon=Texture'Angreal.TrapDetect.TrapExpWardPartsX',IconScale=0.300000,SparkleSprite=Texture'ParticleSystems.Appear.AYellowCorona',Weight=3.000000,MaxInitialVelocity=17.000000,MinInitialVelocity=12.000000,MaxDrawScale=0.200000,MinDrawScale=0.075000,MaxScaleGlow=-0.010000,MinScaleGlow=-0.020000,GrowPhase=2,MaxGrowRate=0.200000,FadePhase=2,MaxFadeRate=0.400000,MinFadeRate=0.750000)
     DetectSound=Sound'Angreal.TrapDetect.ActiveTD'
     DetectRadius=1000.000000
     MinBeatTime=0.300000
     MaxBeatTime=3.000000
     MinBeatVolume=1.000000
     MaxBeatVolume=5000.000000
     AffectResolution=1.000000
     bDisplayIcon=True
     bRemoveExisting=True
     RemoteRole=ROLE_SimulatedProxy
}
