//=============================================================================
// WaterSplash.
//=============================================================================
class WaterSplash expands ParticleSprayer;

#exec TEXTURE IMPORT FILE=MODELS\DropMOD.pcx	GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\DropTRANS.pcx	GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Drop01.pcx		GROUP=Particles

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	SetRotation( rotator(vect(0,0,1)) );
	SetTimer( 0.2, False );
}

simulated function Timer()
{
	bOn = false;
	LifeSpan = 2.0;
}

defaultproperties
{
     Spread=125.000000
     Volume=200.000000
     Gravity=(Z=-280.000000)
     NumTemplates=2
     Templates(0)=(LifeSpan=0.600000,MaxInitialVelocity=210.000000,MinInitialVelocity=70.000000,MaxDrawScale=0.800000,MinDrawScale=0.500000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=0.250000,FadePhase=2,MaxFadeRate=3.000000,MinFadeRate=2.000000)
     Templates(1)=(LifeSpan=0.600000,MaxInitialVelocity=190.000000,MinInitialVelocity=50.000000,MaxDrawScale=0.750000,MinDrawScale=0.500000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=0.250000,FadePhase=2,MaxFadeRate=3.000000,MinFadeRate=2.000000)
     Particles(0)=Texture'ParticleSystems.Water.Splash02'
     Particles(1)=Texture'ParticleSystems.Water.Splash01'
     bOn=True
     VolumeScalePct=0.000000
     bStatic=False
     RemoteRole=ROLE_SimulatedProxy
     VisibilityRadius=500.000000
     VisibilityHeight=500.000000
}
