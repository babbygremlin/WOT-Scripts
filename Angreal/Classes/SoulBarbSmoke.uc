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
    Spread=125.00
    Volume=15.00
    Gravity=(X=5.00,Y=0.00,Z=3.00),
    NumTemplates=2
    Templates(0)=(LifeSpan=2.00,Weight=2.00,MaxInitialVelocity=30.00,MinInitialVelocity=-5.00,MaxDrawScale=0.50,MinDrawScale=1.00,MaxScaleGlow=0.00,MinScaleGlow=-0.10,GrowPhase=1,MaxGrowRate=0.50,MinGrowRate=0.30,FadePhase=2,MaxFadeRate=1.00,MinFadeRate=0.00),
    Templates(1)=(LifeSpan=2.00,Weight=1.00,MaxInitialVelocity=30.00,MinInitialVelocity=-5.00,MaxDrawScale=0.25,MinDrawScale=0.50,MaxScaleGlow=0.00,MinScaleGlow=-0.10,GrowPhase=1,MaxGrowRate=0.50,MinGrowRate=0.30,FadePhase=2,MaxFadeRate=1.00,MinFadeRate=0.00),
    Particles(0)=Texture'SoulBarb.Spirits03'
    Particles(1)=Texture'SoulBarb.Spirits04'
    bOn=True
    bStatic=False
    VisibilityRadius=1000.00
    VisibilityHeight=1000.00
}
