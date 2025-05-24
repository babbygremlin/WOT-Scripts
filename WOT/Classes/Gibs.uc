//------------------------------------------------------------------------------
// Gibs.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class Gibs expands Fragment;

// Sounds
#exec AUDIO IMPORT FILE=Sounds\Gibs\GibBounce1.wav
#exec AUDIO IMPORT FILE=Sounds\Gibs\GibBounce2.wav
#exec AUDIO IMPORT FILE=Sounds\Gibs\GibBounce3.wav
#exec AUDIO IMPORT FILE=Sounds\Gibs\GibBounce4.wav
#exec AUDIO IMPORT FILE=Sounds\Gibs\GibBounce5.wav
#exec AUDIO IMPORT FILE=Sounds\Gibs\GibBounceBone1.wav
#exec AUDIO IMPORT FILE=Sounds\Gibs\GibExplode1.wav
#exec AUDIO IMPORT FILE=Sounds\Gibs\GibExplode2.wav

// Textures
#exec TEXTURE IMPORT FILE=MODELS\Gibs\GIBpartA.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Gibs\GIBpartABlack.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Gibs\Bones.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Gibs\BonesBloody.PCX GROUP=Skins FLAGS=2

// Spine
#exec MESH IMPORT MESH=Spine ANIVFILE=MODELS\Gibs\Spine_a.3d DATAFILE=MODELS\Gibs\Spine_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Spine X=-10 Y=0 Z=0 Pitch=64 Yaw=128
#exec MESH SEQUENCE MESH=Spine SEQ=All      STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=Spine MESH=Spine
#exec MESHMAP SCALE MESHMAP=Spine X=0.15 Y=0.15 Z=0.4
#exec MESHMAP SETTEXTURE MESHMAP=Spine NUM=1 TEXTURE=GIBpartA

// Chest
#exec MESH IMPORT MESH=Chest ANIVFILE=MODELS\Gibs\Chest_a.3d DATAFILE=MODELS\Gibs\Chest_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Chest X=-20 Y=50 Z=-10 Pitch=0 Yaw=-64 Roll=0
#exec MESH SEQUENCE MESH=Chest SEQ=All      STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=Chest MESH=Chest
#exec MESHMAP SCALE MESHMAP=Chest X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=Chest NUM=1 TEXTURE=GIBpartA

// ChunkA
#exec MESH IMPORT MESH=ChunkA ANIVFILE=MODELS\Gibs\ChunkA_a.3d DATAFILE=MODELS\Gibs\ChunkA_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=ChunkA X=0 Y=0 Z=0 Pitch=0 Yaw=0 Roll=0
#exec MESH SEQUENCE MESH=ChunkA SEQ=All      STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=ChunkA MESH=ChunkA
#exec MESHMAP SCALE MESHMAP=ChunkA X=0.025 Y=0.025 Z=0.050
#exec MESHMAP SETTEXTURE MESHMAP=ChunkA NUM=1 TEXTURE=GIBpartA

// ChunkB
#exec MESH IMPORT MESH=ChunkB ANIVFILE=MODELS\Gibs\ChunkB_a.3d DATAFILE=MODELS\Gibs\ChunkB_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=ChunkB X=0 Y=-50 Z=-100 Pitch=-64 Yaw=-10 Roll=0
#exec MESH SEQUENCE MESH=ChunkB SEQ=All      STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=ChunkB MESH=ChunkB
#exec MESHMAP SCALE MESHMAP=ChunkB X=0.025 Y=0.025 Z=0.050
#exec MESHMAP SETTEXTURE MESHMAP=ChunkB NUM=1 TEXTURE=GIBpartA

// OrganA
#exec MESH IMPORT MESH=OrganA ANIVFILE=MODELS\Gibs\OrganA_a.3d DATAFILE=MODELS\Gibs\OrganA_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=OrganA X=0 Y=100 Z=50 Pitch=64 Yaw=30 Roll=0
#exec MESH SEQUENCE MESH=OrganA SEQ=All      STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=OrganA MESH=OrganA
#exec MESHMAP SCALE MESHMAP=OrganA X=0.025 Y=0.025 Z=0.05
#exec MESHMAP SETTEXTURE MESHMAP=OrganA NUM=1 TEXTURE=GIBpartA

// ArmBone
#exec MESH IMPORT MESH=ArmBone ANIVFILE=MODELS\Gibs\ArmBone_a.3d DATAFILE=MODELS\Gibs\ArmBone_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=ArmBone X=0 Y=0 Z=0 Pitch=64 Yaw=0 Roll=0
#exec MESH SEQUENCE MESH=ArmBone SEQ=All      STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=ArmBone MESH=ArmBone
#exec MESHMAP SCALE MESHMAP=ArmBone X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=ArmBone NUM=0 TEXTURE=Bones

// ThighBone
#exec MESH IMPORT MESH=ThighBone ANIVFILE=MODELS\Gibs\ThighBone_a.3d DATAFILE=MODELS\Gibs\ThighBone_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=ThighBone X=0 Y=0 Z=0 Pitch=64 Yaw=-3 Roll=0
#exec MESH SEQUENCE MESH=ThighBone SEQ=All      STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=ThighBone MESH=ThighBone
#exec MESHMAP SCALE MESHMAP=ThighBone X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=ThighBone NUM=0 TEXTURE=Bones

var() class<ParticleSprayer> BloodType;
var ParticleSprayer Blood;

var() float MaxBleedTime;
var() float MinBleedTime;
var float BleedRate;

var() bool bUseOffset;
var() vector BloodOffset;

//------------------------------------------------------------------------------
simulated function CalcVelocity( vector Momentum, float ExplosionSize )
{
	Super.CalcVelocity( Momentum, ExplosionSize );
	Velocity.z += ExplosionSize/2;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( Blood != None )
	{
		Blood.Volume -= BleedRate * DeltaTime;
		if( Blood.Volume <= 0.0 )
		{
			Blood.bOn = False;
		}
	}
	else
	{
		Blood = Spawn( BloodType );
		if( MaxBleedTime > 0.0 )
		{
			BleedRate = Blood.Volume / RandRange( MinBleedTime, MaxBleedTime );
		}
	}

	if( !bUseOffset ) 
	{
		BloodOffset = vect(-1,0,0)*CollisionRadius;
	}

	Blood.SetLocation( Location + (BloodOffset >> Rotation) );
	Blood.SetRotation( rotator(Velocity * -1.0) );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Blood != None )
	{
		Blood.Destroy();
	}
	
	Super.Destroyed();
}

defaultproperties
{
     BloodType=Class'ParticleSystems.BloodSpray01'
     MaxBleedTime=5.000000
     MinBleedTime=2.000000
     Fragments(0)=Mesh'WOT.Spine'
     Fragments(1)=Mesh'WOT.Chest'
     Fragments(2)=Mesh'WOT.ChunkA'
     Fragments(3)=Mesh'WOT.ChunkB'
     Fragments(4)=Mesh'WOT.OrganA'
     Fragments(5)=Mesh'WOT.ArmBone'
     Fragments(6)=Mesh'WOT.ThighBone'
     numFragmentTypes=7
     GoreLevel=2
     LifeSpan=30.000000
     Mesh=Mesh'WOT.Spine'
     CollisionRadius=20.000000
     CollisionHeight=12.000000
     Mass=5.000000
     Buoyancy=6.000000
}
