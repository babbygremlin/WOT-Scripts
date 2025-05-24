//=============================================================================
// FireworksFrag.
//=============================================================================
class FireworksFrag expands Fragment;

struct FireworkCombo
{
	var() class<ParticleSprayer> ProjType;
	var() class<ParticleSprayer> ExpType;
};

var() FireworkCombo Fireworks[5]; 
var() float MinExpTime, MaxExpTime;
var float ExpTime;	// When to explode.

var int SelectedFirework;
var ParticleSprayer Proj;
var bool bExploded;

simulated function CalcVelocity( vector Momentum, float ExplosionSize )
{
	Super.CalcVelocity( Momentum, ExplosionSize );
	Velocity.z += ExplosionSize*2;
	
	Velocity *= 6.0;
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	SelectedFirework = Rand( ArrayCount(Fireworks) );
	ExpTime = Level.TimeSeconds + RandRange( MinExpTime, MaxExpTime );
}

simulated function Tick( float DeltaTime )
{
	local rotator Rot;

	Super.Tick( DeltaTime );
	
	if( Level.TimeSeconds < ExpTime )
	{
		if( Proj == None )
		{
			Proj = Spawn( Fireworks[SelectedFirework].ProjType,,, Location, Rotation );
		}
		else if( Proj != None )
		{
			Proj.SetLocation( Location );
			Rot = rotator(Velocity);
			Rot.Roll = Proj.Rotation.Roll;
			Proj.SetRotation( Rot );
		}
	}
	else
	{
		if( Proj != None )
		{
			Proj.bOn = false;
			Proj.LifeSpan = 5.0;
			Proj = None;
			LightType = LT_None;
		}
		
		if( !bExploded )
		{
			Spawn( Fireworks[SelectedFirework].ExpType,,, Location );
			bExploded = true;
		}
	}
}

defaultproperties
{
     Fireworks(0)=(ProjType=Class'ParticleSystems.Firework01',ExpType=Class'ParticleSystems.Firework05')
     Fireworks(1)=(ProjType=Class'ParticleSystems.Firework06',ExpType=Class'ParticleSystems.Firework05')
     Fireworks(2)=(ProjType=Class'ParticleSystems.Firework03',ExpType=Class'ParticleSystems.Firework09')
     Fireworks(3)=(ProjType=Class'ParticleSystems.Firework04',ExpType=Class'ParticleSystems.Firework08')
     Fireworks(4)=(ProjType=Class'ParticleSystems.Firework02',ExpType=Class'ParticleSystems.Firework07')
     MinExpTime=2.000000
     MaxExpTime=6.000000
     Physics=PHYS_Projectile
     Mass=1.000000
}
