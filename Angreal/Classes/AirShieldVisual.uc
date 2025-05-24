//------------------------------------------------------------------------------
// AirShieldVisual.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AirShieldVisual expands ShieldParticleMesh;

defaultproperties
{
    TextureSet(0)=Texture'Elemental.Air_A01'
    TextureSet(1)=Texture'Elemental.Air_A02'
    TextureSet(2)=Texture'Elemental.Air_A03'
    TextureSet(3)=Texture'Elemental.Air_A04'
    TextureSet(4)=Texture'Elemental.Air_A05'
    Texture=Texture'Elemental.Air_A01'
    LightHue=0
    LightSaturation=255
}
