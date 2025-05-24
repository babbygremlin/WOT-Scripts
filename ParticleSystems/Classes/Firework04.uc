//------------------------------------------------------------------------------
// Firework04.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
// Description:	Green Proj Type
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class Firework04 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Volume=25.000000
     Gravity=(Z=15.000000)
     NumTemplates=3
     Templates(0)=(LifeSpan=1.500000,Weight=8.000000,MaxInitialVelocity=15.000000,MinInitialVelocity=15.000000,MinDrawScale=0.700000,GrowPhase=1,MaxGrowRate=-0.300000,MinGrowRate=-0.600000,FadePhase=1,MaxFadeRate=-0.300000,MinFadeRate=-0.700000)
     Templates(1)=(LifeSpan=3.000000,Weight=20.000000,MaxInitialVelocity=15.000000,MaxDrawScale=0.800000,MinDrawScale=0.500000,MaxScaleGlow=0.300000,MinScaleGlow=0.150000,GrowPhase=1,MaxGrowRate=-0.200000,MinGrowRate=-0.300000,FadePhase=2,MaxFadeRate=0.200000,MinFadeRate=0.100000)
     Templates(2)=(MaxInitialVelocity=50.000000,MinInitialVelocity=50.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=3,MaxGrowRate=3.000000,MinGrowRate=1.000000,FadePhase=5,MaxFadeRate=-0.300000,MinFadeRate=-0.500000)
     Particles(0)=Texture'ParticleSystems.Appear.AWhiteCorona'
     Particles(1)=Texture'ParticleSystems.Flares.PF11'
     Particles(2)=Texture'ParticleSystems.Appear.CyanCorona'
     bOn=True
     MinVolume=8.000000
     bInterpolate=True
     bStatic=False
     bDynamicLight=True
     Rotation=(Pitch=112072,Yaw=-208)
     bMustFace=False
     VisibilityRadius=8000.000000
     VisibilityHeight=8000.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=100
     LightSaturation=60
     LightRadius=10
     bFixedRotationDir=True
     RotationRate=(Yaw=50000)
}
