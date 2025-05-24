//------------------------------------------------------------------------------
// BloodDamageBlack1.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
//------------------------------------------------------------------------------

class BloodDamageBlack1 expands BloodDamageRed1;

//------------------------------------------------------------------------------
// Scott's damage blood PS.
// Black.

defaultproperties
{
     Particles(0)=Texture'ParticleSystems.BlackBlood.BloodBlack07'
     Particles(1)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack02'
     Particles(2)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack01'
     Particles(3)=Texture'ParticleSystems.BlackBlood.BloodBlack07'
     DecalType=Class'ParticleSystems.BloodDecalBlack'
}
