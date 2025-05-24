//------------------------------------------------------------------------------
// ScorchMark.uc
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
class ScorchMark expands BloodDecal;

#exec TEXTURE IMPORT FILE=MODELS\scorch5.PCX GROUP=Scorches
#exec TEXTURE IMPORT FILE=MODELS\scorch6.PCX GROUP=Scorches
#exec TEXTURE IMPORT FILE=MODELS\scorch7.PCX GROUP=Scorches
#exec TEXTURE IMPORT FILE=MODELS\scorch10.PCX GROUP=Scorches
#exec TEXTURE IMPORT FILE=MODELS\scorch11.PCX GROUP=Scorches
#exec TEXTURE IMPORT FILE=MODELS\scorch12.PCX GROUP=Scorches

defaultproperties
{
     BloodTextures(0)=Texture'ParticleSystems.Scorches.scorch5'
     BloodTextures(1)=Texture'ParticleSystems.Scorches.scorch5'
     BloodTextures(2)=Texture'ParticleSystems.Scorches.scorch5'
     BloodTextures(3)=Texture'ParticleSystems.Scorches.scorch6'
     BloodTextures(4)=Texture'ParticleSystems.Scorches.scorch6'
     BloodTextures(5)=Texture'ParticleSystems.Scorches.scorch6'
     BloodTextures(6)=Texture'ParticleSystems.Scorches.scorch7'
     BloodTextures(7)=Texture'ParticleSystems.Scorches.scorch7'
     BloodTextures(8)=Texture'ParticleSystems.Scorches.scorch7'
     BloodTextures(9)=Texture'ParticleSystems.Scorches.scorch10'
     BloodTextures(10)=Texture'ParticleSystems.Scorches.scorch10'
     BloodTextures(11)=Texture'ParticleSystems.Scorches.scorch11'
     BloodTextures(12)=Texture'ParticleSystems.Scorches.scorch11'
     BloodTextures(13)=Texture'ParticleSystems.Scorches.scorch12'
     BloodTextures(14)=Texture'ParticleSystems.Scorches.scorch12'
     GoreLevel=0
}
