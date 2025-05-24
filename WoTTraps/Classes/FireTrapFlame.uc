//===============================================================================
// FireTrapFlame - Duplicates WOTFlame, but simplifies packaging and dependancies
//===============================================================================
class FireTrapFlame expands Effects;

#exec OBJ LOAD FILE=Textures\FireWall\FireWall.utx PACKAGE=WOTTraps.Flames06

/*TBR
var() Texture FireTextures[3];

function Hide()
{
	Super.Hide();
	SetCollision( false, false, false );
}

function Show()
{
	Super.Show();
	SetCollision( default.bCollideActors, default.bBlockActors, default.bBlockPlayers );
}

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Texture = FireTextures[ Rand( ArrayCount(FireTextures) ) ];
}
*/

defaultproperties
{
}
