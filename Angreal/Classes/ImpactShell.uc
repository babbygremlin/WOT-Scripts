//------------------------------------------------------------------------------
// ImpactShell.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn at the desired location relative to the Actor you wish this object
//   to follow (Rotation is automatically corrected in Go()).
// + Set color using SetColor( 'Green', 'White', 'Red', 'Blue' or 'Gold' ).
//   - Alternatively set RefLightBrightness, RefLightHue, RefLightSaturation
//     to the values of your choice.
// + Call Go() with the Actor you wish this object to Follow, and an optional
//   Duration.
//------------------------------------------------------------------------------
class ImpactShell expands Effects;

#exec OBJ LOAD FILE=Textures\ImpactsT.utx PACKAGE=Angreal.Impacts

#exec MESH IMPORT MESH=ImpactShell ANIVFILE=MODELS\ImpactShell_a.3d DATAFILE=MODELS\ImpactShell_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=ImpactShell X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=ImpactShell SEQ=All         STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=ImpactShell MESH=ImpactShell
#exec MESHMAP SCALE MESHMAP=ImpactShell X=0.1 Y=0.1 Z=0.2

var() byte RefLightBrightness, RefLightHue, RefLightSaturation;
var() vector RefLightOffset;
var GenericSprite RefLight;	// Used for lighting purposes only.

var float HalfLife;
var float AccumLife;

var Actor FollowActor;
var vector RelativeOffset;

replication
{
	reliable if( Role==ROLE_Authority && bNetInitial )
		RefLightBrightness, RefLightHue, RefLightSaturation, RefLightOffset,
		FollowActor, RelativeOffset;
}

//------------------------------------------------------------------------------
simulated function BeginPlay()
{
	Super.BeginPlay();

	if( Role < ROLE_Authority )
	{
		Go( FollowActor );
	}
}

//------------------------------------------------------------------------------
simulated function SetColor( name Color )
{
	switch( Color )
	{
	case 'Green' : RefLightBrightness = 255; RefLightHue =  64; RefLightSaturation =   0; break;
	case 'White' : RefLightBrightness = 255; RefLightHue =   0; RefLightSaturation = 255; break;
	case 'Red'   : RefLightBrightness = 255; RefLightHue =   0; RefLightSaturation =   0; break;
	case 'Blue'  : RefLightBrightness = 255; RefLightHue = 160; RefLightSaturation =   0; break;
	case 'Gold'  : RefLightBrightness = 255; RefLightHue =  32; RefLightSaturation =   0; break;
	default: warn( Color$": Unsupported color type." );
	}
}

//------------------------------------------------------------------------------
simulated function Go( Actor FollowActor, optional float Duration )
{
	if( Duration > 0 )
	{
		LifeSpan = Duration;
	}

	HalfLife = LifeSpan / 2;

	if( FollowActor != None )
	{
		Self.FollowActor = FollowActor;
		RelativeOffset = (Location - Self.FollowActor.Location) << Self.FollowActor.Rotation;
		SetRotation( rotator(Location - Self.FollowActor.Location) );
	}

	GotoState('FadeIn');
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( FollowActor != None )
	{
		SetLocation( FollowActor.Location + (RelativeOffset >> FollowActor.Rotation) );
		SetRotation( rotator(Location - FollowActor.Location) );
	}

	if( RefLight != None )
	{
		RefLight.SetLocation( Location + (RefLightOffset >> Rotation) );
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( RefLight != None )
	{
		RefLight.Destroy();
		RefLight = None;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated state FadeIn
{
	simulated function BeginState()
	{
		AccumLife = 0.0;
		ScaleGlow = 0.0;
		RefLight = Spawn( class'GenericSprite',,, Location + (RefLightOffset >> Rotation) );
		RefLight.bHidden         = True;
		RefLight.LightBrightness = 0;
		RefLight.LightHue        = 0;
		RefLight.LightSaturation = 0;
		RefLight.LightRadius     = 1;
		RefLight.bSpecialLit     = True;
		RefLight.LightEffect     = LE_NonIncidence;
		RefLight.LightType       = LT_Steady;
	}

	simulated function Tick( float DeltaTime )
	{
		local float Scalar;

		Global.Tick( DeltaTime );

		// 0.0 to 1.0 in half our lifespan.
		AccumLife += DeltaTime;
		Scalar = AccumLife / HalfLife;

		ScaleGlow = default.ScaleGlow * Scalar;
		RefLight.LightBrightness = RefLightBrightness * Scalar;
		RefLight.LightHue        = RefLightHue        * Scalar;
		RefLight.LightSaturation = RefLightBrightness * Scalar;

		if( LifeSpan <= HalfLife )
		{
			GotoState('FadeOut');
		}
	}
}

//------------------------------------------------------------------------------
simulated state FadeOut
{
	simulated function Tick( float DeltaTime )
	{
		local float Scalar;

		Global.Tick( DeltaTime );

		// 1.0 to 0.0 in half our lifespan.
		Scalar = LifeSpan / HalfLife;

		ScaleGlow = default.ScaleGlow * Scalar;
		RefLight.LightBrightness = RefLightBrightness * Scalar;
		RefLight.LightHue        = RefLightHue        * Scalar;
		RefLight.LightSaturation = RefLightBrightness * Scalar;
	}
}

defaultproperties
{
    RefLightOffset=(X=5.00,Y=0.00,Z=0.00),
    RemoteRole=2
    LifeSpan=2.00
    DrawType=2
    Style=3
    Texture=None
    Skin=WetTexture'Impacts.ImpE'
    Mesh=Mesh'ImpactShell'
    bSpecialLit=True
}
