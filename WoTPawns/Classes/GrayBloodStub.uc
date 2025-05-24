//=============================================================================
// GrayBloodStub.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class GrayBloodStub expands GenericDamageEffect;

// fix for mission_03 (and others?) -- keep this texture (in .utx?) or remove?

#exec TEXTURE IMPORT FILE=TEXTURES\GRAYBLOOD\001.pcx	GROUP=GrayBlood
#exec TEXTURE IMPORT FILE=TEXTURES\GRAYBLOOD\002.pcx	GROUPGrayBlood

defaultproperties
{
     Particles(0)=Texture'WOTPawns.GrayBlood.001'
     Particles(1)=Texture'WOTPawns.002'
}
