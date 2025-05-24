//------------------------------------------------------------------------------
// Explosion.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
// Description:	Animated sprite whose ExplosionAnim is played from start to 
//				finish over the lifespan of the object.
//				The LightBrightness is also scaled from default to zero over
//				the lifespan of the object.
//				It can also be triggered.
//------------------------------------------------------------------------------
// How to use this class:
//
// =Normal=
//  + Set the desired textures in ExplosionAnim for your animation.
//  + Set the lifespan to how long the Explosion lasts for. (may not be zero)
//  + Set the lighting settings with initial values.
//
// =TickAnim=
//  + If bTickAnim is true, then the LifeSpan is set to zero (infinite), and
//    the textures are changed on every tick.  When all the textures have been
//    iterated through, we are destroyed.
//
// =Triggered=
//  + Set up as described above.
//  + Set (Object)InitialState to Triggered.
//  + Link to a trigger.
//------------------------------------------------------------------------------
class Explosion expands Effects
	abstract;

var() Texture ExplosionAnim[32];	// Frames of animation.
var int NumFrames;
var() bool bTickAnim;				// Switch frames every tick.
var int FrameIndex;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// Get the number of frames of animation.
	for( NumFrames = 0; NumFrames < ArrayCount(ExplosionAnim) && ExplosionAnim[NumFrames] != None; NumFrames++ );

	// Get initial texture.
	if( NumFrames > 0 )	Texture = ExplosionAnim[0];
	else				Destroy();

	if( bTickAnim )	LifeSpan = 0.0;
}

//------------------------------------------------------------------------------
auto simulated state Exploding
{
	simulated function Tick( float DeltaTime )
	{
		local float Scalar;	// Percent of life remaining.

		Global.Tick( DeltaTime );

		if( !bTickAnim )
		{
			Scalar = LifeSpan / default.LifeSpan;

			LightBrightness = default.LightBrightness * Scalar;

			Texture = ExplosionAnim[ NumFrames - int(NumFrames * Scalar) ];
		}
		else
		{
			if( FrameIndex < NumFrames )
			{
				Texture = ExplosionAnim[FrameIndex];
				LightBrightness = default.LightBrightness * (1.0 - (FrameIndex / NumFrames));
				FrameIndex++;
			}
			else
			{
				Destroy();
			}
		}
	}
}

//------------------------------------------------------------------------------
simulated state Triggered
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		GotoState('Exploding');
	}
}

defaultproperties
{
     RemoteRole=ROLE_None
     LifeSpan=1.500000
     DrawType=DT_Sprite
     Style=STY_Translucent
     AmbientGlow=255
     bUnlit=True
     SoundRadius=255
     SoundVolume=255
     LightType=LT_Steady
     LightBrightness=255
     LightHue=24
     LightSaturation=32
     LightRadius=50
}
