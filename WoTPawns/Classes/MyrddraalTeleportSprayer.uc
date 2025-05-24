//=============================================================================
// MyrddraalTeleportSprayer.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class MyrddraalTeleportSprayer expands ParticleSprayer;



simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

simulated function Tick( float DeltaTime ) {}

defaultproperties
{
     Spread=180.000000
     Volume=50.000000
     Gravity=(Z=120.000000)
     NumTemplates=1
     Templates(0)=(LifeSpan=5.000000,MaxInitialVelocity=40.000000,MinInitialVelocity=20.000000,MaxDrawScale=2.500000,MinDrawScale=1.500000,GrowPhase=1,MaxGrowRate=-0.500000,MinGrowRate=-1.000000)
     Particles(0)=Texture'ParticleSystems.SmokeBlack32.Blk32_004'
     TimerDuration=3.000000
     bInitiallyOn=False
     bOn=True
     bRotationGrouped=True
     bDisableTick=False
     bStatic=False
     Physics=PHYS_Rotating
     InitialState=TriggerTimed
     Style=STY_Modulated
     bMustFace=False
     bFixedRotationDir=True
     RotationRate=(Yaw=32768)
}
