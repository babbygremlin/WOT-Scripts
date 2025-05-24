//------------------------------------------------------------------------------
// AngrealDartProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealDartProjectile expands GenericProjectile
	abstract;

#exec MESH IMPORT MESH=xboxdart ANIVFILE=MODELS\xboxdart_a.3d DATAFILE=MODELS\xboxdart_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=xboxdart X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=xboxdart SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jxboxdart0 FILE=MODELS\xboxdart0.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=xboxdart MESH=xboxdart
#exec MESHMAP SCALE MESHMAP=xboxdart X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=xboxdart NUM=0 TEXTURE=Jxboxdart0

// Sounds
#exec AUDIO IMPORT FILE=Sounds\Dart\HitLevelDT.wav	GROUP=AngrealInventoryDart
#exec AUDIO IMPORT FILE=Sounds\Dart\HitPawnDT.wav	GROUP=AngrealInventoryDart
#exec AUDIO IMPORT FILE=Sounds\Dart\HitWaterDT.wav	GROUP=AngrealInventoryDart
#exec AUDIO IMPORT FILE=Sounds\Dart\LaunchDT.wav	GROUP=AngrealInventoryDart
#exec AUDIO IMPORT FILE=Sounds\Dart\LoopDT.wav		GROUP=AngrealInventoryDart

var FakeCorona CoronaLight;
var() Texture CoronaTexture;
var() Texture ExplosionTexture;

var() int SpinRate;

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local rotator Rot;

	Super.Tick( DeltaTime );
	
	Rot = rotator(Velocity);
	Rot.Roll = (Rotation.Roll + (SpinRate * DeltaTime)) & 0xFFFF;
	
	SetRotation( Rot );
/*
	if( CoronaLight == None )
	{
		CoronaLight = Spawn( class'FakeCorona' );
		CoronaLight.Texture = CoronaTexture;
	}

	CoronaLight.SetLocation( Location );
*/
}

//------------------------------------------------------------------------------
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( CoronaLight == None )
	{
		CoronaLight = Spawn( class'FakeCorona', Self,, Location );
		CoronaLight.Texture = CoronaTexture;
		CoronaLight.SetBase( Self );
	}
}

//------------------------------------------------------------------------------
simulated function Detach( Actor Other )
{
	if( Other == CoronaLight )
	{
		CoronaLight.SetLocation( Location );
		CoronaLight.SetBase( Self );
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( CoronaLight != None )
	{
		CoronaLight.Destroy();
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
	local DartExplosion Expl;

	Expl = Spawn( class'DartExplosion',,, HitLocation );
	Expl.Texture = ExplosionTexture;
	Expl.LightHue = LightHue;

	Super.Explode( HitLocation, HitNormal );
}

defaultproperties
{
    spinRate=200000
    HitPawnSound=Sound'AngrealInventoryDart.HitPawnDT'
    HitWaterSound=Sound'AngrealInventoryDart.HitWaterDT'
    HitWaterSoundPitch=1.20
    DamageType=AxFxx
    HitWaterClass=Class'ParticleSystems.WaterSplash'
    speed=2000.00
    Damage=10.00
    SpawnSound=Sound'AngrealInventoryDart.LaunchDT'
    ImpactSound=Sound'AngrealInventoryDart.HitLevelDT'
    AnimRate=5.00
    Style=3
    Texture=None
    Mesh=Mesh'xboxdart'
    DrawScale=3.00
    ScaleGlow=4.00
    AmbientGlow=211
    bUnlit=True
    SoundRadius=160
    SoundVolume=100
    AmbientSound=Sound'AngrealInventoryDart.LoopDT'
    CollisionRadius=6.00
    CollisionHeight=12.00
    LightType=1
    LightEffect=13
    LightBrightness=255
    LightHue=154
    LightSaturation=50
    LightRadius=2
}
