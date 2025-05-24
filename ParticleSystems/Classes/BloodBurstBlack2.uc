//------------------------------------------------------------------------------
// BloodBurstBlack2.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
//------------------------------------------------------------------------------

class BloodBurstBlack2 expands BloodBurstRed2;

//------------------------------------------------------------------------------
// Scott's "explosion" of blood PS for gibbing. 
// Black blood.

defaultproperties
{
     Particles(0)=Texture'ParticleSystems.BlackBlood.BloodBlack11'
     Particles(1)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack02'
     Particles(2)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack04'
     Particles(3)=Texture'ParticleSystems.BlackBlood.BloodBlack16'
     Particles(4)=Texture'ParticleSystems.BlackBlood.BloodBlack17'
     Particles(5)=Texture'ParticleSystems.BlackBlood.BloodBlack08'
     Particles(6)=Texture'ParticleSystems.BlackBlood.BloodBlack07'
     DecalType=Class'ParticleSystems.BloodDecalBlack'
}
