//=============================================================================
// LSwingsA.
//=============================================================================
class LSwingsA expands Effects;

#exec MESH IMPORT MESH=LSwingsA ANIVFILE=MODELS\LSwingsA_a.3d DATAFILE=MODELS\LSwingsA_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LSwingsA X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=LSwingsA SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\LSwings01.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings02.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings03.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings04.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings05.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings06.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings07.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings08.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings09.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings10.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings11.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings12.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings13.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings14.pcx GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\LSwings15.pcx GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=LSwingsA MESH=LSwingsA
#exec MESHMAP SCALE MESHMAP=LSwingsA X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=LSwingsA NUM=0 TEXTURE=LSwings06

var() texture LSGrowTextures[5];
var() texture LSLoopTextures[10];
var() float LSFrameRate;
var int LSIndex;

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

auto simulated state LSGrowing
{
	simulated function BeginState()
	{
		LSIndex = 0;
	}

	simulated function Timer()
	{
		Skin = LSGrowTextures[ LSIndex++ ];
		if( LSIndex >= ArrayCount(LSGrowTextures) )
		{
			GotoState('LSLooping');
		}
	}
}

simulated state LSLooping
{
	simulated function BeginState()
	{
		LSIndex = Rand( ArrayCount(LSLoopTextures) );
	}

	simulated function Timer()
	{
		Skin = LSLoopTextures[ LSIndex++ % ArrayCount(LSLoopTextures) ];
	}
}

defaultproperties
{
     LSGrowTextures(0)=Texture'Angreal.Skins.LSwings01'
     LSGrowTextures(1)=Texture'Angreal.Skins.LSwings02'
     LSGrowTextures(2)=Texture'Angreal.Skins.LSwings03'
     LSGrowTextures(3)=Texture'Angreal.Skins.LSwings04'
     LSGrowTextures(4)=Texture'Angreal.Skins.LSwings05'
     LSLoopTextures(0)=Texture'Angreal.Skins.LSwings06'
     LSLoopTextures(1)=Texture'Angreal.Skins.LSwings07'
     LSLoopTextures(2)=Texture'Angreal.Skins.LSwings08'
     LSLoopTextures(3)=Texture'Angreal.Skins.LSwings09'
     LSLoopTextures(4)=Texture'Angreal.Skins.LSwings10'
     LSLoopTextures(5)=Texture'Angreal.Skins.LSwings11'
     LSLoopTextures(6)=Texture'Angreal.Skins.LSwings12'
     LSLoopTextures(7)=Texture'Angreal.Skins.LSwings13'
     LSLoopTextures(8)=Texture'Angreal.Skins.LSwings14'
     LSLoopTextures(9)=Texture'Angreal.Skins.LSwings15'
     LSFrameRate=30.000000
     RemoteRole=ROLE_None
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=Texture'Angreal.Skins.LSwings01'
     Mesh=Mesh'Angreal.LSwingsA'
     bUnlit=True
     CollisionRadius=5.000000
}
