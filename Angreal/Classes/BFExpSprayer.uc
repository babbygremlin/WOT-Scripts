//------------------------------------------------------------------------------
// BFExpSprayer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BFExpSprayer expands ParticleSprayer;

var() float LightDuration;
var() float RotGroupDelay;
var float RotGroupTime;

var float OffTime;

var GenericSprite Globe;
var() float GlobeScaleMax, GlobeScaleMin;
var() float GlobeScaleFactor;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = LightDuration;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
	RotGroupTime = Level.TimeSeconds + RotGroupDelay;
	OffTime = Level.TimeSeconds + TimerDuration;

	Globe = Spawn( class'GenericSprite',,, Location );
	Globe.DrawType = DT_Mesh;
	Globe.Style = STY_Translucent;
	Globe.Mesh = Mesh'Angreal.AMAPearl';
	Globe.Skin = Texture'Angreal.Effects.Glass';
	Globe.DrawScale = GlobeScaleMin;
	Globe.bUnlit = true;
	Globe.bMeshCurvy = true;
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Globe != None )
	{
		Globe.Destroy();
		Globe = None;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	// Super.Tick( DeltaTime );  -- don't call super.

	// Fade light out.
	LightBrightness = 255.0 * (LifeSpan / LightDuration);

	// Start rotating particles on cue.
	if( !bRotationGrouped && Level.TimeSeconds >= RotGroupTime )
	{
		bRotationGrouped = true;
	}

	// Turn off particles on cue.
	if( bOn && Level.TimeSeconds >= OffTime )
	{
		bOn = false;
	}

	// Scale Globe.
	if( Globe != None )
	{
		Globe.DrawScale += (GlobeScaleMax - Globe.DrawScale) / GlobeScaleFactor;
		Globe.ScaleGlow = 1.0 - (Globe.DrawScale / GlobeScaleMax);
	}
}

defaultproperties
{
     LightDuration=1.800000
     RotGroupDelay=1.000000
     GlobeScaleMax=4.000000
     GlobeScaleMin=0.400000
     GlobeScaleFactor=4.000000
     Spread=210.000000
     Volume=100.000000
     NumTemplates=3
     Templates(0)=(LifeSpan=1.500000,MaxInitialVelocity=100.000000,MinInitialVelocity=-250.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=1.000000,MinGrowRate=0.500000,FadePhase=20,MaxFadeRate=250.000000,MinFadeRate=5.000000)
     Templates(1)=(Weight=0.750000,MaxInitialVelocity=200.000000,MinInitialVelocity=100.000000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-1.000000,MinGrowRate=-1.000000,FadePhase=2,MaxFadeRate=2.000000,MinFadeRate=0.500000)
     Templates(2)=(Weight=0.750000,MaxInitialVelocity=-100.000000,MinInitialVelocity=-300.000000,MaxDrawScale=2.000000,GrowPhase=1,MaxGrowRate=-1.000000,MinGrowRate=-2.000000,FadePhase=1,MaxFadeRate=-1.000000,MinFadeRate=-1.000000)
     Particles(0)=Texture'ParticleSystems.Appear.AWhiteCorona'
     Particles(1)=Texture'ParticleSystems.Flares.PF03'
     Particles(2)=Texture'ParticleSystems.Sparks.Sparks01'
     PrimeCount=10.000000
     TimerDuration=0.300000
     MinVolume=50.000000
     bDisableTick=False
     bStatic=False
     bDynamicLight=True
     Physics=PHYS_Rotating
     bMustFace=False
     AmbientGlow=250
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightSaturation=255
     LightRadius=12
     bFixedRotationDir=True
     RotationRate=(Pitch=150000,Yaw=100000,Roll=170000)
}
