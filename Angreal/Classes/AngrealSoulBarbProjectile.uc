//------------------------------------------------------------------------------
// AngrealSoulBarbProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealSoulBarbProjectile expands SeekingProjectile;

#exec OBJ LOAD FILE=Textures\SpiritSmokeT.utx PACKAGE=Angreal.SoulBarb

#exec AUDIO IMPORT FILE=Sounds\SoulBarb\HitSB.wav			GROUP=SoulBarb
#exec AUDIO IMPORT FILE=Sounds\SoulBarb\LaunchSB.wav		GROUP=SoulBarb
#exec AUDIO IMPORT FILE=Sounds\SoulBarb\LoopSB.wav			GROUP=SoulBarb

// Our deamon smoke trail.
var() class<ParticleSprayer> SmokeType;
var ParticleSprayer Smoke;

// Our visual presence.
var GenericSprite Flare, Hole;
var() Texture FlareTexture;
var() Texture HoleTexture;
var() ERenderStyle FlareStyle;
var() ERenderStyle HoleStyle;
var() float FlareDrawScale;
var() float HoleDrawScale;

// How long the SoulBarb lasts.
var float Duration;

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( Smoke == None && !bDeleteMe )
	{
		Smoke = Spawn( SmokeType );
	}

	if( Flare == None && !bDeleteMe )
	{
		Flare = Spawn( class'GenericSprite' );
		Flare.Texture = FlareTexture;
		Flare.Style = FlareStyle;
		Flare.DrawScale = FlareDrawScale;
	}

	if( Hole == None && !bDeleteMe )
	{
		Hole = Spawn( class'GenericSprite' );
		Hole.Texture = HoleTexture;
		Hole.Style = HoleStyle;
		Hole.DrawScale = HoleDrawScale;
	}

	if( Smoke != None )
	{
		Smoke.SetLocation( Location );
		Smoke.SetRotation( rotator(Velocity * -1.0) );
	}

	if( Flare != None )
	{
		Flare.SetLocation( Location );
	}

	if( Hole != None )
	{
		Hole.SetLocation( Location );
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
    if( Smoke != None )
	{
		Smoke.bOn = False;
		Smoke.LifeSpan = 5.0;
	}

	if( Flare != None )
	{
		Flare.Destroy();
	}

	if( Hole != None )
	{
		Hole.Destroy();
	}

    Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
	local SoulBarbImpact	SBI;
	local InstallReflectorEffect Installer;

	if( DestinationExists() )
	{
		SBI = Spawn( class'SoulBarbImpact', Destination );
	}

	// Install a RarityBasedDamageReflector in our victim.
	if( Role == ROLE_Authority ) /* Game-logic -- server-side only */
	{
		//Installer = Spawn( class'InstallReflectorEffect' );
		Installer = InstallReflectorEffect( class'Invokable'.static.GetInstance( Self, class'InstallReflectorEffect' ) );
		Installer.SetVictim( Pawn(HitActor) );
		Installer.InitializeWithProjectile( Self );
		Installer.Initialize( class'RarityBasedDamageReflector', Duration );
		if( WOTPlayer(HitActor) != None )
		{
			WOTPlayer(HitActor).ProcessEffect( Installer );
		}
		else if( WOTPawn(HitActor) != None )
		{
			WOTPawn(HitActor).ProcessEffect( Installer );
		}	
	}

    Super.Explode( HitLocation, HitNormal );
}

defaultproperties
{
    SmokeType=Class'SoulBarbSmoke'
    FlareTexture=WetTexture'SoulBarb.NimbusAnim'
    HoleTexture=Texture'SoulBarb.MODdiskC'
    FlareStyle=3
    HoleStyle=4
    FlareDrawScale=0.80
    HoleDrawScale=0.60
    Duration=15.00
    speed=300.00
    MomentumTransfer=2000
    SpawnSound=Sound'SoulBarb.LaunchSB'
    ImpactSound=Sound'SoulBarb.HitSB'
    DrawType=0
    Style=0
    Texture=None
    SoundRadius=160
    SoundVolume=100
    AmbientSound=Sound'SoulBarb.LoopSB'
    CollisionRadius=6.00
    CollisionHeight=12.00
    LightType=1
    LightEffect=13
    LightBrightness=64
    LightHue=96
    LightSaturation=128
    LightRadius=8
}
