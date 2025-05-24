//------------------------------------------------------------------------------
// SoulBarbSmoke.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class SoulBarbSmoke expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
	AlignGravity();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );
	AlignGravity();
}

//------------------------------------------------------------------------------
simulated function AlignGravity()
{
	Gravity = default.Gravity >> Rotation;
}

defaultproperties
{
     Spread=125.000000
     Volume=15.000000
     Gravity=(X=5.000000,Z=3.000000)
     NumTemplates=2
     Templates(0)=(LifeSpan=2.000000,Weight=2.000000,MaxInitialVelocity=30.000000,MinInitialVelocity=-5.000000,MaxDrawScale=0.500000,MaxScaleGlow=-0.001000,MinScaleGlow=-0.100000,GrowPhase=1,MaxGrowRate=0.500000,MinGrowRate=0.300000,FadePhase=2,MaxFadeRate=1.000000)
     Templates(1)=(LifeSpan=2.000000,MaxInitialVelocity=30.000000,MinInitialVelocity=-5.000000,MaxDrawScale=0.250000,MinDrawScale=0.500000,MaxScaleGlow=-0.001000,MinScaleGlow=-0.100000,GrowPhase=1,MaxGrowRate=0.500000,MinGrowRate=0.300000,FadePhase=2,MaxFadeRate=1.000000)
     Particles(0)=Texture'Angreal.SoulBarb.Spirits03'
     Particles(1)=Texture'Angreal.SoulBarb.Spirits04'
     bOn=True
     bStatic=False
     VisibilityRadius=1000.000000
     VisibilityHeight=1000.000000
}
