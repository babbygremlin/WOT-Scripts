//=============================================================================
// A camera, used in UnrealEd.
//=============================================================================
class Camera extends PlayerPawn
	native;

// Sprite.
#exec Texture Import File=Textures\S_Camera.pcx Name=S_Camera Mips=Off Flags=2

defaultproperties
{
    Location=(X=-500.00,Y=-300.00,Z=300.00),
    Texture=Texture'S_Camera'
    CollisionRadius=16.00
    CollisionHeight=39.00
    LightBrightness=100
    LightRadius=16
}
