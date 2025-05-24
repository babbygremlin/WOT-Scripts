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
    LightDuration=1.80
    RotGroupDelay=1.00
    GlobeScaleMax=4.00
    GlobeScaleMin=0.40
    GlobeScaleFactor=4.00
    Spread=210.00
    Volume=100.00
    NumTemplates=3
    Templates(0)=(LifeSpan=1.50,Weight=1.00,MaxInitialVelocity=100.00,MinInitialVelocity=-250.00,MaxDrawScale=0.00,MinDrawScale=0.00,MaxScaleGlow=0.00,MinScaleGlow=0.00,GrowPhase=2,MaxGrowRate=1.00,MinGrowRate=0.50,FadePhase=20,MaxFadeRate=250.00,MinFadeRate=5.00),
    Templates(1)=(LifeSpan=1.00,Weight=0.75,MaxInitialVelocity=200.00,MinInitialVelocity=100.00,MaxDrawScale=1.00,MinDrawScale=1.00,MaxScaleGlow=0.00,MinScaleGlow=0.00,GrowPhase=1,MaxGrowRate=-1.00,MinGrowRate=-1.00,FadePhase=2,MaxFadeRate=2.00,MinFadeRate=0.50),
    Templates(2)=(LifeSpan=1.00,Weight=0.75,MaxInitialVelocity=-100.00,MinInitialVelocity=-300.00,MaxDrawScale=2.00,MinDrawScale=1.00,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=1,MaxGrowRate=-1.00,MinGrowRate=-2.00,FadePhase=1,MaxFadeRate=-1.00,MinFadeRate=-1.00),
    Particles(0)=Texture'ParticleSystems.Appear.AWhiteCorona'
    Particles(1)=Texture'ParticleSystems.Flares.PF03'
    Particles(2)=Texture'ParticleSystems.Sparks.Sparks01'
    PrimeCount=10.00
    TimerDuration=0.30
    MinVolume=50.00
    bDisableTick=False
    bStatic=False
    bDynamicLight=True
    Physics=5
    bMustFace=False
    AmbientGlow=250
    LightType=1
    LightEffect=13
    LightBrightness=255
    LightSaturation=255
    LightRadius=12
    bFixedRotationDir=True
    RotationRate=(Pitch=150000,Yaw=100000,Roll=170000),
}
