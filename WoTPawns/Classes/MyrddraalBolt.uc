//=============================================================================
// MyrddraalBolt.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class MyrddraalBolt expands WotWeaponProjectile;

#exec MESH IMPORT MESH=MMyrddraalBolt ANIVFILE=MODELS\MyrddraalBolt_a.3D DATAFILE=MODELS\MyrddraalBolt_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MMyrddraalBolt X=0 Y=0 Z=0 YAW=-64 ROLL=0 PITCH=0

#exec MESH SEQUENCE MESH=MMyrddraalBolt SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MMyrddraalBolt MESH=MMyrddraalBolt
#exec MESHMAP SCALE MESHMAP=MMyrddraalBolt X=0.1 Y=0.1 Z=0.2

#exec AUDIO IMPORT FILE=Sounds\Weapon\Crossbow\Crossbow_Switch1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Crossbow\Crossbow_Shoot1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Crossbow\Crossbow_HitPawn1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Crossbow\Crossbow_HitWall1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Crossbow\Crossbow_Flight1.wav

#exec AUDIO IMPORT FILE=Sounds\Weapon\Myrddraal\Myrddraal_HitWall1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Myrddraal\Myrddraal_Flight1.wav

var() class<ParticleSprayer> SprayerTypes[2];
var ParticleSprayer Sprayers[2];

var() class<ParticleSprayer> ExplosionType;

var bool bDestroyedSprayers;
var bool bSpawnedCrack;

simulated function PreBeginPlay()
{
	local int i;

	Super.PreBeginPlay();

	for( i = 0; i < ArrayCount(SprayerTypes); i++ )
	{
		if( SprayerTypes[i] != None )
		{
			Sprayers[i] = Spawn( SprayerTypes[i],,, Location, rotator(vect(0,0,1)) );
			Sprayers[i].FollowActor = Self;
		}
	}
}
/*
simulated function Tick( float DeltaTime )
{
	local int i;

	Super.Tick( DeltaTime );

	for( i = 0; i < ArrayCount(Sprayers); i++ )
	{
		if( Sprayers[i] != None )
		{
			Sprayers[i].SetLocation( Location );
		}
	}
}
*/
simulated function DestroySprayers( vector HitLocation )
{
	local int i;

	if( !bDestroyedSprayers )
	{
		for( i = 0; i < ArrayCount(Sprayers); i++ )
		{
			if( Sprayers[i] != None )
			{
//				Sprayers[i].GotoState('FadeAway');
				Sprayers[i].bOn = false;
			}
		}

		Spawn( ExplosionType,,, HitLocation, rotator(-Velocity) );
		Spawn( class'MyrddraalElectric',,, HitLocation );

		bDestroyedSprayers = true;
	}
}

auto simulated state Flying
{
	simulated function HitWall( vector HitNormal, actor Wall )
    {
		local CrackDecal Crack;
		
		DestroySprayers( Location );

		if( !bSpawnedCrack )
		{
			Crack = Spawn( class'CrackDecal',,, Location + HitNormal );
			Crack.Align( HitNormal );
			bSpawnedCrack = true;
		}
		
		Super.HitWall( HitNormal, Wall );
	}
}

simulated function Explode( vector HitLocation, Vector HitNormal )
{
	DestroySprayers( HitLocation );
	Super.Explode( HitLocation, HitNormal );
}

simulated function Destroyed()
{
	DestroySprayers( Location );
	Super.Destroyed();
}

defaultproperties
{
     SprayerTypes(0)=Class'ParticleSystems.MyrdSprayerA'
     SprayerTypes(1)=Class'ParticleSystems.MyrdSprayerB'
     ExplosionType=Class'ParticleSystems.MyrdSprayerExp'
     SoundHitPawn=Sound'WOTPawns.Crossbow_HitPawn1'
     SoundHitWall=Sound'WOTPawns.Myrddraal_HitWall1'
     StayStuckTime=30.000000
     FadeAwayTime=2.000000
     RollSpinRate=200000
     speed=2000.000000
     MaxSpeed=2000.000000
     SpawnSound=Sound'WOTPawns.Crossbow_Shoot1'
     Mesh=Mesh'WOTPawns.MMyrddraalBolt'
     MultiSkins(1)=Texture'WOTPawns.MMyrddraalWeapons'
     MultiSkins(2)=Texture'WOTPawns.MMyrddraalWeapons'
     AmbientSound=Sound'WOTPawns.Myrddraal_Flight1'
}
