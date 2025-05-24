//=============================================================================
// Skull.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//=============================================================================
class SoulBarbSkull expands Effects;

#exec MESH IMPORT MESH=SoulSkull ANIVFILE=MODELS\SoulSkull_a.3d DATAFILE=MODELS\SoulSkull_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=SoulSkull X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=SoulSkull SEQ=All       STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\64SkMOD01.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\64SkMOD02.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\64SkMOD03.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\64SkMOD04.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\64SkMOD05.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\64SkMOD06.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\64SkMOD07.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=SoulSkull MESH=SoulSkull
#exec MESHMAP SCALE MESHMAP=SoulSkull X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=SoulSkull NUM=0 TEXTURE=64SkMOD01

// Yaw per second.
var() float MinSpinRate;
var() float MaxSpinRate;
var float SpinRate;
var float AccumYaw;

// Z units per second.
var() float MinRiseRate;
var() float MaxRiseRate;
var float RiseRate;	

// DrawScale per second.
var() float MinGrowRate;
var() float MaxGrowRate;
var float GrowRate;

// Textures.
var() Texture AnimTextures[7];
var() int NumTextures;

//=============================================================================
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	SpinRate = RandRange( MinSpinRate, MaxSpinRate );
	RiseRate = RandRange( MinRiseRate, MaxRiseRate );
	GrowRate = RandRange( MinGrowRate, MaxGrowRate );
}

//=============================================================================
simulated function Tick( float DeltaTime )
{
	local vector Loc;
	local rotator Rot;
	local float Scalar;

	Super.Tick( DeltaTime );

	DrawScale += GrowRate * DeltaTime;
	Loc = Location;
	Loc.z += RiseRate * DeltaTime;
	Rot = Rotation;
	AccumYaw += SpinRate * DeltaTime;
	Rot.Yaw = int(AccumYaw);
	SetLocation( Loc );
	SetRotation( Rot );

	// 0.0 to 1.0 in LifeSpan seconds...
	Scalar = (default.LifeSpan - LifeSpan) / default.LifeSpan;

	Skin = AnimTextures[ int(Scalar * NumTextures) ];
}

defaultproperties
{
    MinSpinRate=-32000.00
    MaxSpinRate=32000.00
    MinRiseRate=20.00
    MaxRiseRate=40.00
    MinGrowRate=0.80
    MaxGrowRate=1.00
    AnimTextures(0)=Texture'Skins.64SkMOD01'
    AnimTextures(1)=Texture'Skins.64SkMOD02'
    AnimTextures(2)=Texture'Skins.64SkMOD03'
    AnimTextures(3)=Texture'Skins.64SkMOD04'
    AnimTextures(4)=Texture'Skins.64SkMOD05'
    AnimTextures(5)=Texture'Skins.64SkMOD06'
    AnimTextures(6)=Texture'Skins.64SkMOD07'
    NumTextures=7
    LifeSpan=1.50
    DrawType=2
    Style=4
    Texture=None
    Skin=Texture'Skins.64SkMOD01'
    Mesh=Mesh'SoulSkull'
    DrawScale=0.10
}
