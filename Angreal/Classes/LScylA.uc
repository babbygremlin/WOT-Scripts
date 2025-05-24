//=============================================================================
// LScylA.
//=============================================================================
class LScylA expands Effects;

#exec MESH IMPORT MESH=LScylA ANIVFILE=MODELS\LScylA_a.3d DATAFILE=MODELS\LScylA_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LScylA X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=LScylA SEQ=All    STARTFRAME=0 NUMFRAMES=20
#exec MESH SEQUENCE MESH=LScylA SEQ=LSCYLA STARTFRAME=0 NUMFRAMES=20

#exec TEXTURE IMPORT FILE=MODELS\LScyl_A01.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LScyl_A02.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LScyl_A03.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LScyl_A04.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LScyl_A05.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LScyl_A06.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LScyl_A07.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LScyl_A08.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LScyl_A09.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LScyl_A10.pcx GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=LScylA MESH=LScylA
#exec MESHMAP SCALE MESHMAP=LScylA X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=LScylA NUM=0 TEXTURE=LScyl_A01

var() texture LSTextures[10];
var() float LSFrameRate;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	LoopAnim( 'All', 0.5 );
	SetTimer( 1.0 / LSFrameRate, true );
}

// Call this function to resize the effect to 
// correctly match the size of the given CollisionRadius.
simulated function MatchSize( float Radius )
{
	DrawScale = Radius / default.CollisionRadius;
}

// Randomly pick a new texture.
simulated function Timer()
{
	Skin = LSTextures[ Rand( ArrayCount(LSTextures) ) ];
}

defaultproperties
{
     LSTextures(0)=Texture'Angreal.Skins.LScyl_A01'
     LSTextures(1)=Texture'Angreal.Skins.LScyl_A02'
     LSTextures(2)=Texture'Angreal.Skins.LScyl_A03'
     LSTextures(3)=Texture'Angreal.Skins.LScyl_A04'
     LSTextures(4)=Texture'Angreal.Skins.LScyl_A05'
     LSTextures(5)=Texture'Angreal.Skins.LScyl_A06'
     LSTextures(6)=Texture'Angreal.Skins.LScyl_A07'
     LSTextures(7)=Texture'Angreal.Skins.LScyl_A08'
     LSTextures(8)=Texture'Angreal.Skins.LScyl_A09'
     LSTextures(9)=Texture'Angreal.Skins.LScyl_A10'
     LSFrameRate=20.000000
     RemoteRole=ROLE_None
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=Texture'Angreal.Skins.LScyl_A01'
     Mesh=Mesh'Angreal.LScylA'
     bUnlit=True
     CollisionRadius=6.000000
}
