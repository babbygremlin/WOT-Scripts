//------------------------------------------------------------------------------
// Firework02.uc
// $Author: Aleiby $
// $Date: 8/26/99 8:24p $
// $Revision: 2 $
//
// Description:	Purple Swirly Proj Type
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class Firework02 expands ParticleSprayer;

var() float RotRollRate;
var float RotRoll;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local rotator Rot;

	//Super.Tick( DeltaTime ); -- don't call Super.

	RotRoll += RotRollRate * DeltaTime;
	Rot = Rotation;
	Rot.Roll = RotRoll;
	SetRotation( Rot );
}

defaultproperties
{
     RotRollRate=50000.000000
     Spread=90.000000
     Volume=30.000000
     NumTemplates=2
     Templates(0)=(LifeSpan=1.500000,Weight=8.000000,MaxInitialVelocity=-50.000000,MinInitialVelocity=-50.000000,MinDrawScale=0.700000,GrowPhase=1,MaxGrowRate=-0.300000,MinGrowRate=-0.600000,FadePhase=1,MaxFadeRate=-0.300000,MinFadeRate=-0.700000)
     Templates(1)=(LifeSpan=1.500000,MaxInitialVelocity=-15.000000,MinInitialVelocity=-15.000000,MaxDrawScale=0.200000,MinDrawScale=0.150000,GrowPhase=1,MaxGrowRate=-0.100000,MinGrowRate=-0.150000)
     Particles(0)=Texture'ParticleSystems.Sparks.Sparks01'
     Particles(1)=Texture'ParticleSystems.General.Prtcl18'
     bOn=True
     MinVolume=8.000000
     bInterpolate=True
     bGrouped=True
     bRotationGrouped=True
     bDisableTick=False
     bStatic=False
     bDynamicLight=True
     bMustFace=False
     VisibilityRadius=8000.000000
     VisibilityHeight=8000.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=180
     LightRadius=10
}
