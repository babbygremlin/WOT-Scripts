//=============================================================================
// FireWallSprayer2.
// $Author: Jcrable $
// $Date: 10/19/99 9:52a $
// $Revision: 4 $
//=============================================================================

class FireWallSprayer2 expands ParticleSprayer;

defaultproperties
{
     Spread=20.000000
     Volume=1.250000
     Gravity=(Z=-20.000000)
     NumTemplates=1
     Templates(0)=(LifeSpan=1.600000,MaxInitialVelocity=100.000000,MinInitialVelocity=50.000000,MaxDrawScale=0.000000,MinDrawScale=0.500000,MaxScaleGlow=0.640000,MinScaleGlow=0.640000,GrowPhase=2,MaxGrowRate=1.250000,MinGrowRate=1.000000,FadePhase=2,MaxFadeRate=-0.500000,MinFadeRate=2.000000)
     Particles(0)=Texture'ParticleSystems.SmokeBlack64.Blk64_005'
     bOn=True
     VolumeScalePct=0.750000
     bStatic=False
     Style=STY_Modulated
     SpriteProjForward=16.000000
     VisibilityRadius=600.000000
     VisibilityHeight=600.000000
}
