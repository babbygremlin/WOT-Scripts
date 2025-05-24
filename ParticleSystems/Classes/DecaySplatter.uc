//=============================================================================
// DecaySplatter.
//=============================================================================
class DecaySplatter expands BloodDecal;

var() Texture DropTextures[2];
var() float DecalDrawScale;

//------------------------------------------------------------------------------
simulated function BeginPlay()
{
	Super.BeginPlay();

	Texture = DropTextures[ Rand(ArrayCount(DropTextures)) ];
}

//------------------------------------------------------------------------------
simulated function Align( vector Normal, optional int NumAttempts )
{
	DrawType = DT_Mesh;
	DrawScale = DecalDrawScale;

	Super.Align( Normal, NumAttempts );
}

defaultproperties
{
     DropTextures(0)=Texture'ParticleSystems.Decay.decaydrop'
     DropTextures(1)=Texture'ParticleSystems.Decay.decaydrop1'
     DecalDrawScale=0.600000
     BloodTextures(0)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(1)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(2)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(3)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(4)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(5)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(6)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(7)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(8)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(9)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(10)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(11)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(12)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(13)=Texture'ParticleSystems.Decay.decaysplat'
     BloodTextures(14)=Texture'ParticleSystems.Decay.decaysplat'
     bHidden=False
     DrawType=DT_Sprite
     DrawScale=0.300000
}
