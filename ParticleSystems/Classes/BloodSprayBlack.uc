//------------------------------------------------------------------------------
// BloodSprayBlack.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
//------------------------------------------------------------------------------

class BloodSprayBlack expands BloodSpray02;

defaultproperties
{
     Volume=500.000000
     Templates(0)=(LifeSpan=0.250000,MaxDrawScale=0.050000,MinDrawScale=0.025000)
     Templates(1)=(LifeSpan=0.375000,MaxDrawScale=0.100000,MinDrawScale=0.020000)
     Templates(2)=(LifeSpan=0.375000,MaxDrawScale=0.050000,MinDrawScale=0.010000)
     Templates(3)=(LifeSpan=0.375000,MaxDrawScale=0.075000,MinDrawScale=0.025000)
     Particles(0)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack01'
     Particles(1)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack02'
     Particles(2)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack03'
     Particles(3)=Texture'ParticleSystems.BlackBlood.RoundBloodBlack04'
     DecalType=Class'ParticleSystems.BloodDecalBlack'
     DecalPercent=0.010000
}
