//=============================================================================
// SunLight.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class SunLight expands Actor intrinsic;

#exec Texture Import File=Textures\S_Light.pcx  Name=S_Light Mips=Off Flags=2

// end of SunLight.uc

defaultproperties
{
     bStatic=True
     bHidden=True
     bNoDelete=True
     bMovable=False
     Texture=Texture'Engine.S_Light'
     CollisionRadius=24.000000
     CollisionHeight=24.000000
     LightType=LT_Steady
     LightBrightness=255
     LightSaturation=255
     LightRadius=64
     LightPeriod=32
     LightCone=128
     VolumeBrightness=64
}
