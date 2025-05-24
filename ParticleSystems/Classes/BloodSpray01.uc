//------------------------------------------------------------------------------
// BloodSpray01.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
// Description:	
//------------------------------------------------------------------------------

class BloodSpray01 expands BloodBase;

//------------------------------------------------------------------------------
// Small spray of blood used for damage to big chunks. No decals.

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=10.000000
     Volume=90.000000
     Gravity=(Z=-400.000000)
     NumTemplates=4
     Templates(0)=(LifeSpan=2.000000,MaxInitialVelocity=140.000000,MinInitialVelocity=125.000000,MaxDrawScale=0.100000,MinDrawScale=0.050000)
     Templates(1)=(LifeSpan=3.000000,MaxInitialVelocity=125.000000,MinInitialVelocity=110.000000,MaxDrawScale=0.200000,MinDrawScale=0.040000)
     Templates(2)=(LifeSpan=3.000000,MaxInitialVelocity=130.000000,MinInitialVelocity=100.000000,MaxDrawScale=0.100000,MinDrawScale=0.020000)
     Templates(3)=(LifeSpan=3.000000,MaxInitialVelocity=110.000000,MinInitialVelocity=100.000000,MaxDrawScale=0.150000,MinDrawScale=0.050000)
     Particles(0)=Texture'ParticleSystems.ModulatedBlood.RoundBlood01'
     Particles(1)=Texture'ParticleSystems.ModulatedBlood.RoundBlood02'
     Particles(2)=Texture'ParticleSystems.ModulatedBlood.RoundBlood03'
     Particles(3)=Texture'ParticleSystems.ModulatedBlood.RoundBlood04'
     bOn=True
     bStatic=False
     DetailLevel=1
     Style=STY_Modulated
     VisibilityRadius=500.000000
     VisibilityHeight=500.000000
}
