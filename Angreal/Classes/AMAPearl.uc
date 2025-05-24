//------------------------------------------------------------------------------
// AMAPearl.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 9 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AMAPearl expands AngrealProjectile;

#exec OBJ LOAD FILE=Textures\AMAPearl.utx PACKAGE=Angreal.AMAPearl

#exec MESH IMPORT MESH=AMApearl ANIVFILE=MODELS\AMApearl_a.3d DATAFILE=MODELS\AMApearl_d.3d X=0 Y=0 Z=0 MLOD=0 
#exec MESH ORIGIN MESH=AMApearl X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=AMApearl SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=AMApearl MESH=AMApearl
#exec MESHMAP SCALE MESHMAP=AMApearl X=0.1 Y=0.1 Z=0.2

#exec AUDIO IMPORT FILE=Sounds\AntiMagicAura\ActivateAM.wav			GROUP=AMAPearl
#exec AUDIO IMPORT FILE=Sounds\AntiMagicAura\DeActivateAM.wav		GROUP=AMAPearl
#exec AUDIO IMPORT FILE=Sounds\AntiMagicAura\AntiMagicAuraLoop4.wav	GROUP=AMAPearl
#exec AUDIO IMPORT FILE=Sounds\AntiMagicAura\PawnWalksThruDome.wav	GROUP=AMAPearl
#exec AUDIO IMPORT FILE=Sounds\AntiMagicAura\DeActivateAM.wav		GROUP=AMAPearl
#exec AUDIO IMPORT FILE=Sounds\AntiMagicAura\UnravelAM.wav			GROUP=AMAPearl

var() enum EDecayType								// Do we fade or shrink on decay?
{
	DT_Fade,
	DT_Shrink,
} DecayType;

var() float InitialScale;							// DrawScale we start out with.
var() float FinalScale;								// DrawScale we end with.	(Must be bigger than InitialScale).

var() float InitialScaleRate;						// How fast we start out changing the DrawScale.
var() float ScaleAccel;								// How fast we change the ScaleRate.	(Negative to slow down, Positive to speed up.)
var float ScaleRate;

var() float WaitTime;								// How long we wait before expanding.
var float ExpandTime;

var() float Duration;								// How long we stay expanded.
var float EndTime;	

var() float InitialAlpha;							// Starting ScaleGlow
var() float FinalAlpha;								// Ending ScaleGlow
	
var() float FadeTime;								// The time (in seconds) it takes to go from InitialAlpha to FinalAlpha.
var float FadeRate;									// How fast we fade out.

var() vector ColorVect;								// Color vector for GlowFog.

var Pawn AffectedPawns[256];						// List of player's whose view has been affected by us.

var InstallReflectorEffect Installer;				// Persistant Reflector Installer.

var() Sound AffectSound;							// Sounds played when a player is affected by us.
var() Sound UnAffectSound;

var() Sound AbsorbSound;							// Sound played when a projectile is absorbed.

var() Sound ActivateSound;							// Sound played when the bubble starts to expand.
var() Sound DeActivateSound;						// Sound played when the bubble starts to fade away.

var() float FadingExpandRate;						// This is how fast it expands as it fades away.

var() byte EndLightRadius;							// The light radius when we are fully expanded.

var bool bAutoGo;									// For client's to know to call Go();

var() byte Priority;								// We may only destroy other AMAPearls of equal or lesser priority.

var() class<Reflector> ReflectorClasses[2];

var float SpawnTime;

var() name UnAffectedTypes[2];						// Types of projectiles we are not allowed to destroy.

replication
{
	// Most of these will probably never change from the class defaults, 
	// but just in case, make sure they get replicated.
	reliable if( Role==ROLE_Authority && bNetInitial )
		DecayType, 
		InitialScale, FinalScale, 
		InitialScaleRate, ScaleAccel,
		WaitTime, 
		Duration,
		InitialAlpha, FinalAlpha,
		FadeTime, 
		ColorVect,
		AffectSound, UnAffectSound, 
		AbsorbSound,
		ActivateSound, DeActivateSound,
		FadingExpandRate,
		EndLightRadius,
		bAutoGo,
		Priority;
}

////////////////////
// Initialization //
////////////////////

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( Role < ROLE_Authority && bAutoGo )
	{
		bAutoGo = false;
		Go();
	}
}

//------------------------------------------------------------------------------
simulated function Go()
{
	// Tell client to go.
	if( Role == ROLE_Authority )
	{
		bAutoGo = true;
	}

	SpawnTime = Level.TimeSeconds;
	
	SetSize( InitialScale );
	SetAlpha( 1.0 );

	FadeRate = (FinalAlpha - InitialAlpha) / FadeTime;

/* - just let them get destroyed.
	if( AngrealAMAProjectile(Owner) != None )
	{
		Owner.GotoState('Fading');
	}
*/

	GotoState( 'Expanding' );
}

/////////////
// Ignores //
/////////////

simulated function Explode(vector HitLocation, vector HitNormal);
simulated function HitWall (vector HitNormal, actor Wall);
simulated function ProcessTouch(Actor Other, Vector HitLocation);

///////////////////
// Notifications //
///////////////////

//------------------------------------------------------------------------------
simulated function ProjTouch( Actor Other )
{
	if( Pawn(Other) != None )
	{
		AffectPawn( Pawn(Other) );
		StorePawn( Pawn(Other) );
	}
	else if( AngrealProjectile(Other) != None )
	{
		if( AMAPearl(Other) != None && AMAPearl(Other).Priority > Priority )
		{
			// Do nothing.  We may only destroy AMAPearls of equal or lesser priority.
		}
		else if( AMAPearl(Other) != None && AMAPearl(Other).SpawnTime > SpawnTime )
		{
			// Do nothing.  Only newer AMAPearls may destroy other AMAPearls.
		}
		else if( IsAffectable( Other ) )
		{
			if( AbsorbSound != None )
			{
				Other.PlaySound( AbsorbSound );
			}

			Spawn( class'WOTSparks',,, Other.Location, rotator(Other.Location-Location) );

			if( GenericProjectile(Other) != None )
			{
				GenericProjectile(Other).bExplode = false;
			}

			Other.Destroy();
		}
	}

	if( Other.Tag == 'AntiMagicAura' )
	{
		Other.Trigger( Self, Instigator );
	}
}

//------------------------------------------------------------------------------
simulated function ProjUnTouch( Actor Other )
{
	if( Pawn(Other) != None )
	{
		UnAffectPawn( Pawn(Other) );
		RemovePawn( Pawn(Other) );
	}
}

//------------------------------------------------------------------------------
simulated function bool IsAffectable( Actor Other )
{
	local int i;

	for( i = 0; i < ArrayCount(UnAffectedTypes); i++ )
	{
		if( UnAffectedTypes[i] != '' )
		{
			if( Other.IsA( UnAffectedTypes[i] ) )
			{
				return false;
			}
		}
	}

	return true;
}

/*
//------------------------------------------------------------------------------
// Untints any player's view when we are destroyed.
//------------------------------------------------------------------------------
simulated function Destroyed()
{
	local int i;

	if( Role == ROLE_Authority )
	{
		for( i = 0; i < ArrayCount(AffectedPawns); i++ )
		{
			if( AffectedPawns[i] != None )
			{
				UnAffectPawn( AffectedPawns[i] );
				AffectedPawns[i] = None;
			}
		}
	}

	Super.Destroyed();
}
*/
////////////
// States //
////////////

//------------------------------------------------------------------------------
simulated state Waiting
{
	simulated function BeginState()
	{
		ExpandTime = Level.TimeSeconds + WaitTime;
	}

	simulated function Tick( float DeltaTime )
	{
		Super.Tick( DeltaTime );

		if( Level.TimeSeconds >= ExpandTime )
		{
			GotoState( 'Expanding' );
		}
	}
}

//------------------------------------------------------------------------------
simulated state Expanding
{
	simulated function BeginState()
	{
		if( ActivateSound != None )
		{
			PlaySound( ActivateSound );
		}

		ScaleRate = InitialScaleRate;
	}
	
	simulated function Tick( float DeltaTime )
	{
		Super.Tick( DeltaTime );

		ScaleRate += ScaleAccel * DeltaTime;

		// If we are slowing expansion down, make sure we don't start contracting.
		if( ScaleAccel < 0 )
		{
			ScaleRate = FMax( ScaleRate, 0.01 );
		}

		SetSize( DrawScale + ScaleRate * DeltaTime );
		
		if( DrawScale >= FinalScale )
		{
			SetSize( FinalScale );
			GotoState( 'Expanded' );
		}
	}
}

//------------------------------------------------------------------------------
simulated state Expanded
{
	simulated function BeginState()
	{
		EndTime = Level.TimeSeconds + Duration;
	}

	simulated function Tick( float DeltaTime )
	{
		Super.Tick( DeltaTime );

		if( Level.TimeSeconds >= EndTime )
		{
			PlaySound( DeActivateSound );

			switch( DecayType )
			{
			case DT_Fade:
				GotoState( 'Fading' );
				break;
			case DT_Shrink:
			default:
				GotoState( 'Shrinking' );
				break;
			}
		}
	}
}

//------------------------------------------------------------------------------
simulated state Fading
{
	simulated function BeginState()
	{
		Style=STY_Translucent;
		ScaleGlow = InitialAlpha;
	}

	simulated function Tick( float DeltaTime )
	{
		Super.Tick( DeltaTime );

		SetAlpha( ScaleGlow + FadeRate * DeltaTime );
		SetSize( DrawScale + FadingExpandRate * DeltaTime );

		if( ScaleGlow <= FinalAlpha )
		{
			ScaleGlow = FinalAlpha;
			Destroy();
		}
	}
}

//------------------------------------------------------------------------------
simulated state Shrinking
{
	simulated function BeginState()
	{
		ScaleRate = InitialScaleRate;
	}
	
	simulated function Tick( float DeltaTime )
	{
		Super.Tick( DeltaTime );

		ScaleRate += ScaleAccel * DeltaTime;

		// If we are slowing expansion down, make sure we don't start contracting.
		if( ScaleAccel < 0 )
		{
			ScaleRate = FMax( ScaleRate, 0.01 );
		}

		SetSize( DrawScale - ScaleRate * DeltaTime );

		if( DrawScale <= InitialScale )
		{
			SetSize( InitialScale );
			Destroy();
		}
	}
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
// Adjusts the DrawScale and CollisionHeight/Radius from the default values
// by the given Scalar.
//------------------------------------------------------------------------------
simulated function SetSize( float Scalar )
{
	DrawScale = default.DrawScale * Scalar;
	//SetCollisionSize( default.CollisionRadius * Scalar, default.CollisionHeight * Scalar );
	ProjCollisionRadius = default.ProjCollisionRadius * Scalar;
	LightRadius = byte( float(EndLightRadius) * (DrawScale - InitialScale) / (FinalScale - InitialScale) );
}

//------------------------------------------------------------------------------
// Adjusts the ScaleGlow from the default values by the given Scalar.
//------------------------------------------------------------------------------
simulated function SetAlpha( float Scalar )
{
	ScaleGlow = default.ScaleGlow * Scalar;
	LightBrightness = byte( float(default.Lightbrightness) * Scalar );
}

//------------------------------------------------------------------------------
// Adjusts the player's view fog.
// Installs a no cast reflector.
//------------------------------------------------------------------------------
function AffectPawn( Pawn AffectedPawn )
{
	local RemoveCurseEffect RCE;
	local int i;
	
	local ReflectorIterator IterR;
	local Reflector R;

	//log( Self$"::AffectPawn( "$AffectedPawn$" );" );

	// Remove latent effects.
	if( WOTPlayer(AffectedPawn) != None )
	{
		WOTPlayer(AffectedPawn).CeaseUsingAngreal();
		//RCE = Spawn( class'RemoveCurseEffect' );
		RCE = RemoveCurseEffect( class'Invokable'.static.GetInstance( Self, class'RemoveCurseEffect' ) );
		RCE.InitializeWithProjectile( Self );
		RCE.SetVictim( AffectedPawn );
		WOTPlayer(AffectedPawn).ProcessEffect( RCE );
	}
	else if( WOTPawn(AffectedPawn) != None )
	{
		WOTPawn(AffectedPawn).CeaseUsingAngreal();
		//RCE = Spawn( class'RemoveCurseEffect' );
		RCE = RemoveCurseEffect( class'Invokable'.static.GetInstance( Self, class'RemoveCurseEffect' ) );
		RCE.InitializeWithProjectile( Self );
		RCE.SetVictim( AffectedPawn );
		WOTPawn(AffectedPawn).ProcessEffect( RCE );
	}

	// Install our reflectors.
	for( i = 0; i < ArrayCount(ReflectorClasses); i++ )
	{
		if( ReflectorClasses[i] != None )
		{
			Installer = InstallReflectorEffect( class'Invokable'.static.GetInstance( Self, class'InstallReflectorEffect' ) );
			Installer.InitializeWithProjectile( Self );
			Installer.Tag = Name;

			Installer.Initialize( ReflectorClasses[i], Duration );

			// Install the reflector in this dude.
			Installer.SetVictim( AffectedPawn );
			
			if( WOTPlayer(AffectedPawn) != None )
			{
				WOTPlayer(AffectedPawn).ProcessEffect( Installer );
			}
			else if( WOTPawn(AffectedPawn) != None )
			{
				WOTPawn(AffectedPawn).ProcessEffect( Installer );
			}
		}
	}

	// Update durations of newly installed reflectors.
	IterR = class'ReflectorIterator'.static.GetIteratorFor( AffectedPawn );
	for( IterR.First(); !IterR.IsDone(); IterR.Next() )
	{
		R = IterR.GetCurrent();

		if( R.Tag == Name )
		{
			if( GetStateName() != 'Expanding' )
			{
				R.LifeSpan = EndTime - Level.TimeSeconds;
			}
		}
	}
	IterR.Reset();
	IterR = None;

	// Set the player's view fog.
	if( PlayerPawn(AffectedPawn) != None )
	{
		PlayerPawn(AffectedPawn).ClientAdjustGlow( 4.0, ColorVect );
	}

	// Play cool sound.
	if( AffectSound != None )
	{
		AffectedPawn.PlaySound( AffectSound );
	}
}

//------------------------------------------------------------------------------
// Undoes all the stuff AffectPawn did.
//------------------------------------------------------------------------------
function UnAffectPawn( Pawn AffectedPawn )
{
	local ReflectorIterator IterR;
	local Reflector R;

	//log( Self$"::UnAffectPawn( "$AffectedPawn$" );" );

	// Reset the player's view fog.
	if( PlayerPawn(AffectedPawn) != None )
	{
		PlayerPawn(AffectedPawn).ClientAdjustGlow( -4.0, -ColorVect );
	}

	// Remove our Reflectors from this guy.
	IterR = class'ReflectorIterator'.static.GetIteratorFor( AffectedPawn );
	for( IterR.First(); !IterR.IsDone(); IterR.Next() )
	{
		R = IterR.GetCurrent();

		if( R.Tag == Name )
		{
			R.UnInstall();
			R.Destroy();
		}
	}
	IterR.Reset();
	IterR = None;

	// Play cool sound.
	if( UnAffectSound != None )
	{
		AffectedPawn.PlaySound( UnAffectSound );
	}
}

//------------------------------------------------------------------------------
function StorePawn( Pawn Element )
{
	local int i;

	// Get next available slot.
	for( i = 0; i < ArrayCount(AffectedPawns); i++ )
		if( AffectedPawns[i] == None )
			break;

	if( i < ArrayCount(AffectedPawns) )
	{
		AffectedPawns[i] = Element;
	}
	else
	{
		warn( "Capacity exceeded." );
	}
}

//------------------------------------------------------------------------------
function RemovePawn( Pawn Element )
{
	local int i;

	// Find Pawn in array.
	for( i = 0; i < ArrayCount(AffectedPawns); i++ )
		if( AffectedPawns[i] != None && AffectedPawns[i] == Element )
			break;

	if( i < ArrayCount(AffectedPawns) )
	{
		AffectedPawns[i] = None;
	}
	else
	{
		warn( Element$" not found." );
	}
}

defaultproperties
{
     InitialScale=0.100000
     FinalScale=20.000000
     InitialScaleRate=40.000000
     ScaleAccel=-20.000000
     WaitTime=2.000000
     Duration=8.000000
     InitialAlpha=1.000000
     FadeTime=0.500000
     ColorVect=(X=150.000000,Y=100.000000,Z=200.000000)
     AffectSound=Sound'Angreal.AMAPearl.PawnWalksThruDome'
     UnAffectSound=Sound'Angreal.AMAPearl.PawnWalksThruDome'
     AbsorbSound=Sound'Angreal.AMAPearl.UnravelAM'
     ActivateSound=Sound'Angreal.AMAPearl.ActivateAM'
     DeActivateSound=Sound'Angreal.AMAPearl.DeActivateAM'
     FadingExpandRate=5.000000
     EndLightRadius=25
     Priority=1
     ReflectorClasses(0)=Class'Angreal.NoCastReflector'
     ReflectorClasses(1)=Class'Angreal.NoBadEffectsReflector'
     UnAffectedTypes(0)=MashadarGuide
     UnAffectedTypes(1)=MachinShin
     bGenProjTouch=True
     ProjTouchTime=0.200000
     ProjCollisionRadius=28.000000
     TouchableTypes(0)=Projectile
     TouchableTypes(1)=Pawn
     TouchableTypes(2)=Mover
     TouchableTypes(3)=Triggers
     bTouchPawnsAndProjectilesOnly=True
     Physics=PHYS_None
     RemoteRole=ROLE_SimulatedProxy
     bDirectional=False
     Style=STY_Modulated
     bMustFace=False
     Skin=IceTexture'Angreal.AMAPearl.AMApearl01'
     Mesh=Mesh'Angreal.AMAPearl'
     bMeshCurvy=True
     bAlwaysRelevant=True
     SoundRadius=128
     AmbientSound=Sound'Angreal.AMAPearl.AntiMagicAuraLoop4'
     bCollideWorld=False
     LightType=LT_Steady
     LightEffect=LE_Shell
     LightBrightness=255
     LightHue=214
     LightSaturation=128
}
