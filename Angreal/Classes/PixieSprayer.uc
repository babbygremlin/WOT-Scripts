//------------------------------------------------------------------------------
// PixieSprayer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class PixieSprayer expands ParticleSprayer;

#exec AUDIO IMPORT FILE=Sounds\LightGlobe\LoopLG.wav			GROUP=LightGlobe

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Volume=20.000000
     Gravity=(Z=-100.000000)
     NumTemplates=4
     Templates(0)=(Weight=3.000000,MaxInitialVelocity=50.000000,MinInitialVelocity=20.000000,MaxDrawScale=0.600000,MinDrawScale=0.200000,MaxScaleGlow=0.700000,MinScaleGlow=0.300000,GrowPhase=1,MaxGrowRate=-0.300000,MinGrowRate=-0.500000,FadePhase=1)
     Templates(1)=(LifeSpan=0.500000,Weight=5.000000,MaxInitialVelocity=20.000000,MinInitialVelocity=10.000000,MinDrawScale=0.300000,MaxScaleGlow=0.600000,MinScaleGlow=0.400000,GrowPhase=1,MaxGrowRate=-0.600000,MinGrowRate=-0.900000,FadePhase=1)
     Templates(2)=(LifeSpan=1.600000,Weight=2.000000,MaxInitialVelocity=80.000000,MinInitialVelocity=20.000000,MaxDrawScale=0.001000,MinDrawScale=0.001000,MaxScaleGlow=0.600000,MinScaleGlow=0.200000,GrowPhase=2,MaxGrowRate=0.150000,MinGrowRate=0.080000)
     Templates(3)=(LifeSpan=0.500000,Weight=15.000000,MaxInitialVelocity=10.000000,MinInitialVelocity=5.000000,MaxDrawScale=0.800000,MinDrawScale=0.400000,MaxScaleGlow=0.600000,MinScaleGlow=0.400000,GrowPhase=1,MaxGrowRate=-0.150000,MinGrowRate=-0.250000)
     Particles(0)=Texture'ParticleSystems.Flares.PF16'
     Particles(1)=Texture'ParticleSystems.Flares.PF17'
     Particles(2)=Texture'ParticleSystems.Sparks.Sparks09'
     Particles(3)=Texture'ParticleSystems.Sparks.Sparks01'
     bOn=True
     MinVolume=20.000000
     bStatic=False
     VisibilityRadius=2000.000000
     VisibilityHeight=2000.000000
     SoundRadius=8
     SoundVolume=90
     SoundPitch=99
     AmbientSound=Sound'Angreal.LightGlobe.LoopLG'
     TransientSoundRadius=8.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=100
     LightHue=200
     LightSaturation=64
     LightRadius=25
}
