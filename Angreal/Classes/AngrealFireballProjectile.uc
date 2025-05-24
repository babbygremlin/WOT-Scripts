//------------------------------------------------------------------------------
// AngrealFireballProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealFireballProjectile expands GenericProjectile;

// Sounds
#exec AUDIO IMPORT FILE=Sounds\Fireball\HitLevelFB.wav	GROUP=AngrealInventoryFireball
#exec AUDIO IMPORT FILE=Sounds\Fireball\HitPawnFB.wav	GROUP=AngrealInventoryFireball
#exec AUDIO IMPORT FILE=Sounds\Fireball\HitWaterFB.wav	GROUP=AngrealInventoryFireball
#exec AUDIO IMPORT FILE=Sounds\Fireball\LaunchFB.wav	GROUP=AngrealInventoryFireball
#exec AUDIO IMPORT FILE=Sounds\Fireball\LoopFB.wav		GROUP=AngrealInventoryFireball
#exec AUDIO IMPORT FILE=Sounds\Fireball\Launch2FB.wav	GROUP=AngrealInventoryFireball

var ParticleSprayer Head, Cone, Smoke;

var() float SprayerDelay;
var() float RockDuration;
var() rotator RockRotationRate;

var() Sound BurstSound;		// Sound played when we burst into flames.  :)
var bool bBurstSoundPlayed;

var vector LastFBLocation;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	local rotator Rot;

	Super.PreBeginPlay();

	RockDuration += Level.TimeSeconds;
	SprayerDelay += Level.TimeSeconds;

	LightType = LT_None;

	Rot = Rotation;
	Rot.Roll = 0xFFFF * FRand();
	SetRotation( Rot );
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local rotator VeloDir;

	VeloDir = rotator(Velocity);

	// Update rock.
	if( Level.TimeSeconds > RockDuration )
	{
		DrawType = DT_None;
	}
	else
	{
		SetRotation( Rotation + RockRotationRate * DeltaTime );
	}

	// Create our particle systems once we know what direction we are heading.
	if( Level.TimeSeconds > SprayerDelay && Velocity != vect(0,0,0) )
	{
		LightType = default.LightType;

		if( !bBurstSoundPlayed )
		{
			PlaySound( BurstSound );
			bBurstSoundPlayed = true;
		}

		if( Head == None )
		{
			Head = Spawn( class'FireballSprayer2',,, Location, VeloDir );
			//Head.FollowActor = Self;
			Head.Disable('Tick');

			LastFBLocation = Location;
		}

		if( Cone == None )
		{
			Cone = Spawn( class'FireballFlame',,, Location, VeloDir );
			//Cone.FollowActor = Self;
			Cone.Disable('Tick');
		}

		if( Smoke == None )
		{
			Smoke = Spawn( class'FireballSmoke',,, Location, VeloDir );
			//Smoke.FollowActor = Self;
			Smoke.Disable('Tick');
		}
	}

	// Fix positions.
	if( Head != None )
	{
		Head.SetLocation( Location );
		Head.ShiftParticles( Location - LastFBLocation );
		LastFBLocation = Location;
		if( Head.Rotation != VeloDir )
		{
			Head.SetRotation( VeloDir );
		}
	}

	if( Cone != None ) 
	{
		Cone.SetLocation( Location );
		if( Cone.Rotation != VeloDir )
		{
			Cone.SetRotation( VeloDir );
		}
	}

	if( Smoke != None )
	{
		Smoke.SetLocation( Location );
		if( Smoke.Rotation != VeloDir )
		{
			Smoke.SetRotation( VeloDir );
		}
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
	local FireballFire Fire;
	local Decal BurnMark;

	Spawn( class'FireballExplode3',,, HitLocation );
	Spawn( class'BlastBits',,, HitLocation, rotator(HitNormal) );

	if( HitActor != None && !HitActor.IsA('Pawn') )
	{
		SpawnChunks( class'BurningChunk', HitLocation, HitNormal );

		if( HitActor.IsA('LevelInfo') )
		{
			//BurnMark = Spawn( class'BurnDecal',,, HitLocation );
			BurnMark = Spawn( class'ScorchMark',,, HitLocation );
			BurnMark.DrawScale = 2.0;
			BurnMark.Align( HitNormal );
		}
		else
		{
			Fire = Spawn( class'FireballFire',,, HitLocation, rotator(vect(0,0,1)) );
			Fire.SetFollowActor( HitActor );
		}
	}
	
	Super.Explode( HitLocation, HitNormal );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Head != None )
	{
		Head.LifeSpan = 5.0;
		Head.bOn = False;
	}

	if( Cone != None )
	{
		Cone.LifeSpan = 5.0;
		Cone.bOn = False;
	}

	if( Smoke != None )
	{
		Smoke.LifeSpan = 5.0;
		Smoke.bOn = False;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function HitWater()
{
	Super.HitWater();
	Destroy();
}

defaultproperties
{
     SprayerDelay=0.300000
     RockDuration=0.500000
     RockRotationRate=(Roll=65000)
     BurstSound=Sound'Angreal.AngrealInventoryFireball.LaunchFB'
     HitPawnSound=Sound'Angreal.AngrealInventoryFireball.HitPawnFB'
     HitWaterSound=Sound'Angreal.AngrealInventoryFireball.HitWaterFB'
     ImpactSoundPitch=0.500000
     HitWaterSoundPitch=1.200000
     DamageType=xxFxx
     DamageRadius=220.000000
     HitWaterClass=Class'Angreal.FireballFizzle'
     HitWaterOffset=(Z=56.000000)
     speed=1000.000000
     Damage=40.000000
     MomentumTransfer=3500
     SpawnSound=Sound'Angreal.AngrealInventoryFireball.Launch2FB'
     ImpactSound=Sound'Angreal.AngrealInventoryFireball.HitLevelFB'
     Mesh=Mesh'Angreal.LavaRock'
     DrawScale=0.900000
     ScaleGlow=5.000000
     AmbientGlow=60
     SoundRadius=160
     SoundVolume=255
     SoundPitch=96
     AmbientSound=Sound'Angreal.AngrealInventoryFireball.LoopFB'
     CollisionRadius=6.000000
     CollisionHeight=12.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=192
     LightHue=20
     LightSaturation=32
     LightRadius=8
}
