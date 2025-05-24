//=============================================================================
// WOTFlame.
//=============================================================================
class WOTFlame expands Effects;

#exec OBJ LOAD FILE=Textures\Flames06.utx PACKAGE=WOT.Flames06

var() Texture FireTextures[3];	// a possible fire texture to pick from

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Texture = FireTextures[ Rand( ArrayCount(FireTextures) ) ];
}

defaultproperties
{
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=None
}
