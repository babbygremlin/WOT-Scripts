//------------------------------------------------------------------------------
// BloodSplatBlack.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
//------------------------------------------------------------------------------

class BloodSplatBlack expands BloodSplatRed;

//------------------------------------------------------------------------------
// Blood PS for chunk landing on ground with "splat" of blood.
// Black.

defaultproperties
{
     Particles(0)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack01'
     Particles(1)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack02'
     Particles(2)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack03'
     Particles(3)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack04'
}
