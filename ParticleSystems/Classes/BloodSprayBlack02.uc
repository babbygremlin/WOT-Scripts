//=============================================================================
// BloodSprayBlack02.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//=============================================================================

class BloodSprayBlack02 expands BloodSpray02;

#exec TEXTURE IMPORT FILE=MODELS\Blood\RoundBloodBlack01.pcx GROUP=BlackBlood
#exec TEXTURE IMPORT FILE=MODELS\Blood\RoundBloodBlack02.pcx GROUP=BlackBlood
#exec TEXTURE IMPORT FILE=MODELS\Blood\RoundBloodBlack03.pcx GROUP=BlackBlood
#exec TEXTURE IMPORT FILE=MODELS\Blood\RoundBloodBlack04.pcx GROUP=BlackBlood

defaultproperties
{
     Particles(0)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack01'
     Particles(1)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack02'
     Particles(2)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack03'
     Particles(3)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack04'
     DecalType=Class'ParticleSystems.BloodDecalBlack'
}
