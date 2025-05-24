//=============================================================================
// MyrddraalTeleportSprayer2.
//=============================================================================
class MyrddraalTeleportSprayer2 expands ParticleSprayer;

defaultproperties
{
     Spread=180.000000
     Volume=30.000000
     Gravity=(Z=-17.000000)
     NumTemplates=1
     Templates(0)=(LifeSpan=1.650000,MaxInitialVelocity=35.000000,MinInitialVelocity=20.000000,MaxDrawScale=0.100000,MinDrawScale=0.000000,GrowPhase=2,MaxGrowRate=1.250000,MinGrowRate=0.800000)
     Frequencies(0)=1.000000
     CumulativeFreqs(0)=2.000000
     bLinearFrequenciesChanged=False
     Particles(0)=Texture'ParticleSystems.SmokeBlack64.Blk64_004'
     PrimeCount=5.000000
     TimerDuration=4.000000
     bInitiallyOn=False
     bOn=True
     MinVolume=0.250000
     bStatic=False
     bDynamicLight=True
     InitialState=TriggerTimed
     Rotation=(Pitch=10800,Yaw=16264,Roll=-88)
     bSelected=True
     Style=STY_Modulated
}
