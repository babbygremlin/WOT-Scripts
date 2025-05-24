//=============================================================================
// WOTSparks.
//=============================================================================
class WOTSparks expands ParticleSprayer;

// Old assets.
#exec TEXTURE IMPORT NAME=WOTSpark00 FILE=MODELS\SP_A01.pcx NAME=SP_A01 GROUP=Effects
#exec TEXTURE IMPORT NAME=WOTSpark01 FILE=MODELS\SP_A02.pcx NAME=SP_A02 GROUP=Effects
#exec TEXTURE IMPORT NAME=WOTSpark02 FILE=MODELS\SP_A03.pcx NAME=SP_A03 GROUP=Effects
#exec TEXTURE IMPORT NAME=WOTSpark03 FILE=MODELS\SP_A04.pcx NAME=SP_A04 GROUP=Effects
#exec TEXTURE IMPORT NAME=WOTSpark04 FILE=MODELS\SP_A05.pcx NAME=SP_A05 GROUP=Effects
#exec TEXTURE IMPORT NAME=WOTSpark05 FILE=MODELS\SP_A06.pcx NAME=SP_A06 GROUP=Effects
#exec TEXTURE IMPORT NAME=WOTSpark06 FILE=MODELS\SP_A07.pcx NAME=SP_A07 GROUP=Effects
#exec TEXTURE IMPORT NAME=WOTSpark07 FILE=MODELS\SP_A08.pcx NAME=SP_A08 GROUP=Effects
#exec TEXTURE IMPORT NAME=WOTSpark08 FILE=MODELS\SP_A09.pcx NAME=SP_A09 GROUP=Effects

#exec TEXTURE IMPORT FILE=MODELS\PixieStar.pcx GROUP=Pixie

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 1.5;
	Super.PreBeginPlay();
}

//------------------------------------------------------------------------------
simulated function SetInitialState()
{
	Super.SetInitialState();
	Trigger( Self, None );
}

defaultproperties
{
     Spread=140.000000
     Volume=400.000000
     Gravity=(X=-100.000000,Z=5.000000)
     NumTemplates=4
     Templates(0)=(LifeSpan=0.850000,Weight=3.500000,MaxInitialVelocity=160.000000,MinInitialVelocity=60.000000,MaxDrawScale=0.600000,MinDrawScale=0.200000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.100000,MinGrowRate=-0.250000,FadePhase=2,MaxFadeRate=4.000000,MinFadeRate=8.000000)
     Templates(1)=(LifeSpan=0.750000,Weight=1.500000,MaxInitialVelocity=15.000000,MinInitialVelocity=-14.000000,MaxDrawScale=1.250000,MinDrawScale=0.400000,MaxScaleGlow=0.500000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=0.550000,MinGrowRate=0.450000,FadePhase=2,MaxFadeRate=0.200000,MinFadeRate=0.500000)
     Templates(2)=(LifeSpan=0.750000,Weight=3.500000,MaxInitialVelocity=180.000000,MinInitialVelocity=260.000000,MaxDrawScale=0.350000,MinDrawScale=0.150000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.250000,MinGrowRate=-0.150000,FadePhase=2,MaxFadeRate=4.000000,MinFadeRate=6.000000)
     Templates(3)=(LifeSpan=0.850000,Weight=1.500000,MaxInitialVelocity=120.000000,MinInitialVelocity=60.000000,MaxDrawScale=0.600000,MinDrawScale=0.200000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.100000,MinGrowRate=-0.250000,FadePhase=2,MaxFadeRate=4.000000,MinFadeRate=6.000000)
     Particles(0)=Texture'ParticleSystems.Appear.APurpleCorona'
     Particles(1)=Texture'WOT.Pixie.PixieStar'
     Particles(2)=Texture'WOT.Pixie.PixieStar'
     Particles(3)=Texture'WOT.Pixie.PixieStar'
     TimerDuration=0.250000
     bInitiallyOn=False
     bOn=True
     bInterpolate=True
     bStatic=False
     InitialState=TriggerTimed
     VisibilityRadius=1500.000000
     VisibilityHeight=1500.000000
}
