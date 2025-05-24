//------------------------------------------------------------------------------
// CrackDecal.uc
// $Author: Aleiby $
// $Date: 10/09/99 3:34p $
// $Revision: 2 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
// How this class works:
//------------------------------------------------------------------------------
class CrackDecal expands BloodDecal;

#exec TEXTURE IMPORT FILE=MODELS\Crack01.PCX GROUP=Cracks
#exec TEXTURE IMPORT FILE=MODELS\Crack02.PCX GROUP=Cracks

defaultproperties
{
     BloodTextures(0)=Texture'ParticleSystems.Cracks.Crack01'
     BloodTextures(1)=Texture'ParticleSystems.Cracks.Crack01'
     BloodTextures(2)=Texture'ParticleSystems.Cracks.Crack01'
     BloodTextures(3)=Texture'ParticleSystems.Cracks.Crack01'
     BloodTextures(4)=Texture'ParticleSystems.Cracks.Crack01'
     BloodTextures(5)=Texture'ParticleSystems.Cracks.Crack01'
     BloodTextures(6)=Texture'ParticleSystems.Cracks.Crack01'
     BloodTextures(7)=Texture'ParticleSystems.Cracks.Crack02'
     BloodTextures(8)=Texture'ParticleSystems.Cracks.Crack02'
     BloodTextures(9)=Texture'ParticleSystems.Cracks.Crack02'
     BloodTextures(10)=Texture'ParticleSystems.Cracks.Crack02'
     BloodTextures(11)=Texture'ParticleSystems.Cracks.Crack02'
     BloodTextures(12)=Texture'ParticleSystems.Cracks.Crack02'
     BloodTextures(13)=Texture'ParticleSystems.Cracks.Crack02'
     BloodTextures(14)=Texture'ParticleSystems.Cracks.Crack02'
     GoreLevel=0
}
