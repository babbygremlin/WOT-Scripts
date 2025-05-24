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
    Volume=20.00
    Gravity=(X=0.00,Y=0.00,Z=-100.00),
    NumTemplates=4
    Templates(0)=(LifeSpan=1.00,Weight=3.00,MaxInitialVelocity=50.00,MinInitialVelocity=20.00,MaxDrawScale=0.60,MinDrawScale=0.20,MaxScaleGlow=0.70,MinScaleGlow=0.30,GrowPhase=1,MaxGrowRate=-0.30,MinGrowRate=-0.50,FadePhase=1,MaxFadeRate=0.00,MinFadeRate=0.00),
    Templates(1)=(LifeSpan=0.50,Weight=5.00,MaxInitialVelocity=20.00,MinInitialVelocity=10.00,MaxDrawScale=1.00,MinDrawScale=0.30,MaxScaleGlow=0.60,MinScaleGlow=0.40,GrowPhase=1,MaxGrowRate=-0.60,MinGrowRate=-0.90,FadePhase=1,MaxFadeRate=0.00,MinFadeRate=0.00),
    Templates(2)=(LifeSpan=1.60,Weight=2.00,MaxInitialVelocity=80.00,MinInitialVelocity=20.00,MaxDrawScale=0.00,MinDrawScale=0.00,MaxScaleGlow=0.60,MinScaleGlow=0.20,GrowPhase=2,MaxGrowRate=0.15,MinGrowRate=0.08,FadePhase=0,MaxFadeRate=0.00,MinFadeRate=0.00),
    Templates(3)=(LifeSpan=0.50,Weight=15.00,MaxInitialVelocity=10.00,MinInitialVelocity=5.00,MaxDrawScale=0.80,MinDrawScale=0.40,MaxScaleGlow=0.60,MinScaleGlow=0.40,GrowPhase=1,MaxGrowRate=-0.15,MinGrowRate=-0.25,FadePhase=0,MaxFadeRate=0.00,MinFadeRate=0.00),
    Particles(0)=Texture'ParticleSystems.Flares.PF16'
    Particles(1)=Texture'ParticleSystems.Flares.PF17'
    Particles(2)=Texture'ParticleSystems.Sparks.Sparks09'
    Particles(3)=Texture'ParticleSystems.Sparks.Sparks01'
    bOn=True
    MinVolume=20.00
    bStatic=False
    VisibilityRadius=2000.00
    VisibilityHeight=2000.00
    SoundRadius=8
    SoundVolume=90
    SoundPitch=99
    AmbientSound=Sound'LightGlobe.LoopLG'
    TransientSoundRadius=8.00
    LightType=1
    LightEffect=13
    LightBrightness=100
    LightHue=200
    LightSaturation=64
    LightRadius=25
}
