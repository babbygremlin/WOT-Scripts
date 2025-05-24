//=============================================================================
// FireWallSprayer3.
// $Author: Jcrable $
// $Date: 10/19/99 9:53a $
// $Revision: 4 $
//=============================================================================

class FireWallSprayer3 expands ParticleSprayer;

defaultproperties
{
     Spread=95.000000
     Volume=8.000000
     Gravity=(Z=110.000000)
     NumTemplates=2
     Templates(0)=(LifeSpan=0.700000,Weight=0.600000,MaxInitialVelocity=-40.000000,MinInitialVelocity=-60.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MaxScaleGlow=0.640000,MinScaleGlow=0.640000,GrowPhase=2,MaxGrowRate=5.000000,MinGrowRate=7.000000,FadePhase=2,MaxFadeRate=-0.500000,MinFadeRate=-0.500000)
     Templates(1)=(LifeSpan=0.200000,MaxInitialVelocity=-20.000000,MinInitialVelocity=-30.000000,MaxDrawScale=1.750000,MinDrawScale=1.250000,MinScaleGlow=0.850000,GrowPhase=2,MaxGrowRate=1.000000,MinGrowRate=1.000000,MaxFadeRate=-0.200000,MinFadeRate=-0.200000)
     Particles(0)=WetTexture'WOTTraps.FireWall.FireWallFlameWet2'
     Particles(1)=FireTexture'WOTTraps.FireWall.FWFlamesSprite'
     bOn=True
     VolumeScalePct=0.750000
     bStatic=False
     VisibilityRadius=700.000000
     VisibilityHeight=700.000000
}
