//=============================================================================
// Keypoint, the base class of invisible actors which mark things.
//=============================================================================
class Keypoint extends Actor
	abstract
	native;

// Sprite.
#exec Texture Import File=Textures\Keypoint.pcx Name=S_Keypoint Mips=Off Flags=2

defaultproperties
{
    bStatic=True
    bHidden=True
    Texture=Texture'S_Keypoint'
    SoundVolume=0
    CollisionRadius=10.00
    CollisionHeight=10.00
}
