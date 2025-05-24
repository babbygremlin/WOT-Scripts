//------------------------------------------------------------------------------
// Firework06.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
// Description:	Yellow Flare Proj Type
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class Firework06 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Volume=50.000000
     Gravity=(Z=-30.000000)
     NumTemplates=6
     Templates(0)=(LifeSpan=2.000000,Weight=5.000000,MaxInitialVelocity=30.000000,MinInitialVelocity=5.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.100000,MinGrowRate=-0.300000,FadePhase=10,MaxFadeRate=10.000000,MinFadeRate=5.000000)
     Templates(1)=(LifeSpan=1.500000,Weight=10.000000,MaxDrawScale=0.300000,MinDrawScale=0.150000,MaxScaleGlow=0.800000,MinScaleGlow=0.600000,GrowPhase=1,MaxGrowRate=-0.100000,MinGrowRate=-0.300000,FadePhase=1,MaxFadeRate=-0.300000,MinFadeRate=-0.700000)
     Templates(2)=(LifeSpan=2.500000,MaxInitialVelocity=40.000000,MinInitialVelocity=25.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=0.500000,MinGrowRate=0.300000,FadePhase=2,MaxFadeRate=1.000000,MinFadeRate=0.300000)
     Templates(3)=(Weight=10.000000,MaxDrawScale=0.500000,MinDrawScale=0.250000,FadePhase=1,MaxFadeRate=-1.000000,MinFadeRate=-1.100000)
     Templates(4)=(LifeSpan=3.000000,Weight=10.000000,MaxInitialVelocity=40.000000,MinInitialVelocity=-30.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=0.200000,MinGrowRate=0.100000,FadePhase=2,MaxFadeRate=0.400000,MinFadeRate=0.100000)
     Templates(5)=(LifeSpan=2.000000,Weight=8.000000,MaxInitialVelocity=6.000000,MinInitialVelocity=3.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=50,MaxGrowRate=2.000000,MinGrowRate=1.500000)
     Particles(0)=Texture'ParticleSystems.Appear.YellowCorona'
     Particles(1)=FireTexture'ParticleSystems.Fire.Fire_Torch_001'
     Particles(2)=FireTexture'ParticleSystems.Fire.Fire_Torch_003'
     Particles(3)=Texture'ParticleSystems.Appear.YellowCorona'
     Particles(4)=Texture'ParticleSystems.Appear.YellowCorona'
     Particles(5)=Texture'ParticleSystems.Appear.YellowCorona'
     bOn=True
     MinVolume=8.000000
     bInterpolate=True
     bStatic=False
     bDynamicLight=True
     Rotation=(Pitch=48956)
     bMustFace=False
     VisibilityRadius=8000.000000
     VisibilityHeight=8000.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=40
     LightSaturation=80
     LightRadius=10
}
