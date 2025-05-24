//------------------------------------------------------------------------------
// BloodSplatRed.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
//------------------------------------------------------------------------------

class BloodSplatRed expands BloodSpray02;

//------------------------------------------------------------------------------
// Blood PS for chunk landing on ground with "splat" of blood.
// Red.

defaultproperties
{
     Volume=500.000000
     Gravity=(Z=-4096.000000)
     Templates(0)=(LifeSpan=0.250000,MaxInitialVelocity=1.000000,MinInitialVelocity=1.000000,MaxDrawScale=0.010000,MinDrawScale=0.005000)
     Templates(1)=(LifeSpan=0.250000,MaxInitialVelocity=1.000000,MinInitialVelocity=1.000000,MaxDrawScale=0.020000,MinDrawScale=0.004000)
     Templates(2)=(LifeSpan=0.250000,MaxInitialVelocity=1.000000,MinInitialVelocity=1.000000,MaxDrawScale=0.010000,MinDrawScale=0.002000)
     Templates(3)=(LifeSpan=0.250000,MaxInitialVelocity=1.000000,MinInitialVelocity=1.000000,MaxDrawScale=0.015000,MinDrawScale=0.005000)
     DecalType=None
}
