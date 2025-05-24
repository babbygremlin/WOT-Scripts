//------------------------------------------------------------------------------
// AngrealSeekerProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealSeekerProjectile expands SeekingProjectile;

#exec OBJ LOAD FILE=Textures\Seeker.utx PACKAGE=Angreal.Seeker

#exec AUDIO IMPORT FILE=Sounds\Seeker\HitSK.wav			GROUP=AngrealSeekerProjectile
#exec AUDIO IMPORT FILE=Sounds\Seeker\LaunchSK.wav		GROUP=AngrealSeekerProjectile
#exec AUDIO IMPORT FILE=Sounds\Seeker\LoopSK.wav		GROUP=AngrealSeekerProjectile

var AngrealSeekerGlobe Globe;
var SeekerSmoke Smoke;

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( Smoke == None && !bDeleteMe )
	{
		Smoke = Spawn( class'SeekerSmoke' );
	}

	if( Smoke != None )
	{
		Smoke.SetLocation( Location );
		Smoke.SetRotation( rotator(Velocity) );
	}
}

//------------------------------------------------------------------------------
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( Globe == None )
	{
		Globe = Spawn( class'AngrealSeekerGlobe', Self,, Location );
		Globe.SetBase( Self );
	}
}

//------------------------------------------------------------------------------
simulated function Detach( Actor Other )
{
	if( Other == Globe )
	{
		Globe.SetLocation( Location );
		Globe.SetBase( Self );
	}
}

//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
 	Spawn( class'GreenExplode',,, HitLocation );

	if( Smoke != None )
	{
		Smoke.bOn = false;
		Smoke.LifeSpan = 2.0;
		Smoke = None;
	}

	Super.Explode( HitLocation, HitNormal );
}

//------------------------------------------------------------------------------
// Engine notification for when this seeker has been destroyed.
//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Globe != None )
	{
		Globe.Destroy();
	}
	if( Smoke != None )
	{
		Smoke.bOn = false;
		Smoke.LifeSpan = 2.0;
		Smoke = None;
	}

	Super.Destroyed();
}

defaultproperties
{
    DamageRadius=240.00
    speed=150.00
    Damage=60.00
    MomentumTransfer=2000
    SpawnSound=Sound'AngrealSeekerProjectile.LaunchSK'
    ImpactSound=Sound'AngrealSeekerProjectile.HitSK'
    DrawType=1
    Style=3
    Texture=FireTexture'Seeker.SLightning01'
    SoundRadius=160
    SoundVolume=255
    AmbientSound=Sound'AngrealSeekerProjectile.LoopSK'
    CollisionRadius=6.00
    CollisionHeight=12.00
    LightType=1
    LightBrightness=64
    LightHue=96
    LightSaturation=128
}
