//------------------------------------------------------------------------------
// AngrealFireworksProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealFireworksProjectile expands GenericProjectile;

// Sounds
#exec AUDIO IMPORT FILE=Sounds\Fireworks\Launch1FW.wav	GROUP=Fireworks
#exec AUDIO IMPORT FILE=Sounds\Fireworks\Explode1FW.wav	GROUP=Fireworks
#exec AUDIO IMPORT FILE=Sounds\Fireworks\Explode2FW.wav	GROUP=Fireworks
#exec AUDIO IMPORT FILE=Sounds\Fireworks\Explode3FW.wav	GROUP=Fireworks

struct FireworkSet
{
	var() class<ParticleSprayer> ProjType;
	var() class<ParticleSprayer> ExpType;
	var() Sound LaunchSound;
	var() Sound ExplodeSound;
};

var() FireworkSet Fireworks[5];
var() float MinExpTime, MaxExpTime;	// Amount of time before detonating.

var int SelectedFirework;
var ParticleSprayer Proj;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	SelectedFirework = Rand( ArrayCount(Fireworks) );
	SetTimer( RandRange( MinExpTime, MaxExpTime ), false );

	Proj = Spawn( Fireworks[SelectedFirework].ProjType,,, Location, Rotation );
	PlaySound( Fireworks[SelectedFirework].LaunchSound,, 100.0,, 3200.0 );
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local rotator Rot;

	Super.Tick( DeltaTime );

	if( Proj != None )
	{
		Proj.SetLocation( Location );
		Rot = rotator(Velocity);
		Rot.Roll = Proj.Rotation.Roll;
		Proj.SetRotation( Rot );
	}
}	

//------------------------------------------------------------------------------
simulated function Timer()
{
	Explode( Location, Normal(Velocity) );
}

//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
	if( Proj != None )
	{
		Proj.bOn = false;
		Proj.LifeSpan = 5.0;
		Proj.LightType = LT_None;
		Proj = None;
	}

	Spawn( Fireworks[SelectedFirework].ExpType,,, Location, Fireworks[SelectedFirework].ExpType.default.Rotation );
	PlaySound( Fireworks[SelectedFirework].ExplodeSound,, 100.0,, 12000.0 );
	
	Super.Explode( HitLocation, HitNormal );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Proj != None )
	{
		Proj.bOn = false;
		Proj.LifeSpan = 5.0;
		Proj.LightType = LT_None;
		Proj = None;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function HitWater()
{
	Super.HitWater();
	Destroy();
}

//------------------------------------------------------------------------------
simulated function HitWall( vector HitNormal, Actor Wall )
{
	Velocity = 0.6*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);
}

defaultproperties
{
     Fireworks(0)=(ProjType=Class'ParticleSystems.Firework01',ExpType=Class'ParticleSystems.Firework05',LaunchSound=Sound'Angreal.Fireworks.Launch1FW',ExplodeSound=Sound'Angreal.Fireworks.Explode1FW')
     Fireworks(1)=(ProjType=Class'ParticleSystems.Firework06',ExpType=Class'ParticleSystems.Firework05',LaunchSound=Sound'Angreal.Fireworks.Launch1FW',ExplodeSound=Sound'Angreal.Fireworks.Explode1FW')
     Fireworks(2)=(ProjType=Class'ParticleSystems.Firework03',ExpType=Class'ParticleSystems.Firework09',LaunchSound=Sound'Angreal.Fireworks.Launch1FW',ExplodeSound=Sound'Angreal.Fireworks.Explode3FW')
     Fireworks(3)=(ProjType=Class'ParticleSystems.Firework04',ExpType=Class'ParticleSystems.Firework08',LaunchSound=Sound'Angreal.Fireworks.Launch1FW',ExplodeSound=Sound'Angreal.Fireworks.Explode2FW')
     Fireworks(4)=(ProjType=Class'ParticleSystems.Firework02',ExpType=Class'ParticleSystems.Firework07',LaunchSound=Sound'Angreal.Fireworks.Launch1FW',ExplodeSound=Sound'Angreal.Fireworks.Explode2FW')
     MinExpTime=2.000000
     MaxExpTime=6.000000
     HitWaterSound=Sound'Angreal.AngrealInventoryFireball.HitWaterFB'
     ImpactSoundPitch=0.500000
     HitWaterSoundPitch=1.200000
     DamageType=xxFxx
     DamageRadius=320.000000
     HitWaterClass=Class'Angreal.FireballFizzle'
     HitWaterOffset=(Z=56.000000)
     speed=2000.000000
     Damage=50.000000
     MomentumTransfer=1500
     Physics=PHYS_Falling
     DrawType=DT_None
     CollisionRadius=6.000000
     CollisionHeight=12.000000
     bBounce=True
     Mass=0.100000
}
