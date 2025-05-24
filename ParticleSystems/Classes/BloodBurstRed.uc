//------------------------------------------------------------------------------
// BloodBurstRed.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
//------------------------------------------------------------------------------

class BloodBurstRed expands BloodSpray02;

defaultproperties
{
     Spread=120.000000
     Templates(0)=(LifeSpan=0.500000,MaxInitialVelocity=140.000000,MinInitialVelocity=12.000000)
     Templates(1)=(LifeSpan=1.000000,MaxInitialVelocity=120.000000,MinInitialVelocity=11.000000,MinDrawScale=0.100000)
     Templates(2)=(LifeSpan=1.000000,MaxInitialVelocity=130.000000,MinInitialVelocity=10.000000,MinDrawScale=0.050000)
     Templates(3)=(LifeSpan=1.000000,MaxInitialVelocity=110.000000,MinInitialVelocity=10.000000,MinDrawScale=0.075000)
     DecalType=None
     DecalPercent=0.000000
     bStasis=True
     VisibilityRadius=800.000000
     VisibilityHeight=800.000000
}
