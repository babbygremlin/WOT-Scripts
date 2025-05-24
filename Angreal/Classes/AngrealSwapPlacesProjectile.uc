//------------------------------------------------------------------------------
// AngrealSwapPlacesProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealSwapPlacesProjectile expands SeekingProjectile;

#exec TEXTURE IMPORT FILE=MODELS\SPP_A00.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\SPP_A01.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\SPP_A02.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\SPP_A03.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\SPP_A04.pcx GROUP=Effects

#exec AUDIO IMPORT FILE=Sounds\SwapPlaces\LaunchSP.wav	GROUP=SwapPlaces
#exec AUDIO IMPORT FILE=Sounds\SwapPlaces\LoopSP.wav	GROUP=SwapPlaces
#exec AUDIO IMPORT FILE=Sounds\SwapPlaces\HitSP.wav		GROUP=SwapPlaces

var() class<ParticleSprayer> SprayerType;
var ParticleSprayer Visual;

// The pawn that actually created us.
var Pawn InitiatingPawn;

//------------------------------------------------------------------------------
// Store our Instigator in a place that we know won't be overwritten if we are 
// reflected.
//------------------------------------------------------------------------------
function SetSourceAngreal( AngrealInventory Source )
{
	//local int i;
	local Inventory Inv;

	Super.SetSourceAngreal( Source );

	if( InitiatingPawn == None )
	{
		InitiatingPawn = Instigator;
	}
/* -- OLD
	// Copy pawn's display properties.
	DrawType = DT_Mesh;
	Style = STY_Translucent;
	ScaleGlow = 0.1;
	Mesh = InitiatingPawn.Mesh;
	DrawScale = InitiatingPawn.DrawScale;
	Skin = InitiatingPawn.Skin;
	for( i = 0; i < ArrayCount(InitiatingPawn.MultiSkins); i++ )
	{
		MultiSkins[i] = InitiatingPawn.MultiSkins[i];
	}
	Texture = InitiatingPawn.Texture;
	for( Inv = InitiatingPawn.Inventory; Inv != None; Inv = Inv.Inventory )
	{
		if( Inv.IsA('AngrealInvDart') )
		{
			LightBrightness	= ProjectileLauncher(Inv).default.ProjectileClass.default.LightBrightness;
			LightHue		= ProjectileLauncher(Inv).default.ProjectileClass.default.LightHue;
			LightSaturation	= ProjectileLauncher(Inv).default.ProjectileClass.default.LightSaturation;
			break;
		}
	}
*/
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( Visual == None && !bDeleteMe )
	{
		Visual = Spawn( SprayerType,,, Location, rotator(Velocity) );
		Visual.LightRadius = 6;
		Visual.LightEffect = LE_NonIncidence;
	}
	
	if( Visual != None )
	{
		Visual.SetLocation( Location );
		Visual.SetRotation( rotator(Velocity) );
	}
}

//------------------------------------------------------------------------------
// When we reach our target, swap our initator's and target's positions.
//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
	local SwapPlacesEffect SPE;

	if( Role == ROLE_Authority )
	{
		// Just to be safe.
		if( Destination != None )
		{
			HitActor = Destination;
		}

		//SPE = Spawn( class'SwapPlacesEffect' );
		SPE = SwapPlacesEffect( class'Invokable'.static.GetInstance( Self, class'SwapPlacesEffect' ) );
		SPE.InitializeWithProjectile( Self );
		SPE.Initialize( InitiatingPawn, HitActor );
		if( WOTPlayer(HitActor) != None )
		{
			WOTPlayer(HitActor).ProcessEffect( SPE );
		}
		else if( WOTPawn(HitActor) != None )
		{
			WOTPawn(HitActor).ProcessEffect( SPE );
		}
		else	// If the other guy isn't a WOTPawn or WOTPlayer, then we will have to invoke it ourself.
		{		// This should always be safe since only WOTPawns and WOTPlayer would be able to block the call anyway.
			SPE.Invoke();
		}
	}

	if( Visual != None )
	{
		Visual.bOn = false;
		Visual.LifeSpan = 5.0;
		Visual.LightType = LT_None;
		Visual = None;
	}

	Super.Explode( HitLocation, HitNormal );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Visual != None )
	{
		Visual.bOn = false;
		Visual.LifeSpan = 5.0;
		Visual.LightType = LT_None;
		Visual = None;
	}

	Super.Destroyed();
}

defaultproperties
{
    SprayerType=Class'ParticleSystems.Firework04'
    speed=750.00
    MaxSpeed=1000.00
    SpawnSound=Sound'SwapPlaces.LaunchSP'
    ImpactSound=Sound'SwapPlaces.HitSP'
    DrawType=1
    Style=3
    Texture=Texture'Effects.SPP_A00'
    SoundRadius=160
    SoundVolume=100
    AmbientSound=Sound'SwapPlaces.LoopSP'
    CollisionRadius=6.00
    CollisionHeight=12.00
}
