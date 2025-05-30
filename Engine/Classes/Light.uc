//=============================================================================
// The light class.
//=============================================================================
class Light extends Actor
	native;

#exec Texture Import File=Textures\S_Light.pcx  Name=S_Light Mips=Off Flags=2

defaultproperties
{
    bStatic=True
    bHidden=True
    bNoDelete=True
    bMovable=False
    Texture=Texture'S_Light'
    CollisionRadius=24.00
    CollisionHeight=24.00
    LightType=1
    LightBrightness=64
    LightSaturation=255
    LightRadius=64
    LightPeriod=32
    LightCone=128
    VolumeBrightness=64
}
