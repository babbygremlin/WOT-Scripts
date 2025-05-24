//------------------------------------------------------------------------------
// Fader.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//------------------------------------------------------------------------------
//
// Description:	Makes the given Actor translucent and adjusts its ScaleGlow
//				from InitialScaleGlow to FinalScaleGlow in FadeTime seconds.
//				Once the ScaleGlow reaches FinalScaleGlow the Actor is 
//				destroyed. Note that in multiplayer games fading is not 
//              performed for now (for performance reasons), instead, after 
//				the DelayTime, the object is destroyed after FadeTime 
//				additional seconds.
//
//------------------------------------------------------------------------------
// How to use this class:
//
// + Call class'Util'.static.Fade( Actor, Time ); instead of Destroy();
//------------------------------------------------------------------------------
class Fader expands LegendActorComponent;

var() float FadeTime;			// How long it takes us to fade the given object out.

var() float InitialScaleGlow;	// ScaleGlow the object start out with.
var() float FinalScaleGlow;		// ScaleGlow the object ends with.  (Must be less than InitialScaleGlow.)

var() bool bDeleteActor;		// Should we delete the actor when we are finished?

var() float DelayTime;			// Time to wait before starting to fade.

var float FadeRate;				// How fast the object will fade out.  Calculated when Fade is called.
var Actor FadeActor;			// The Actor we are fading away.

var bool bInitialized;			// Have we finished with the delay?

var() int NumFlickers;			// Number of times to flicker in/out of translucent/normal before fading.
								// (Kind of "techno". Would be more flexible with an associated time.)

//------------------------------------------------------------------------------
// Sets the FadeActor and start the fading process.
//------------------------------------------------------------------------------
simulated function Fade( Actor Other )
{
	if( Other != None )
	{
		FadeActor = Other;
		DelayTime += Level.TimeSeconds;

		if( Level.Netmode != NM_Standalone )
		{
			// wait additional time in multiplayer games then destroy
			DelayTime += FadeTime;
		}

	}
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	if( Level.TimeSeconds >= DelayTime && FadeActor != None )
	{
		if( Level.Netmode != NM_Standalone )
		{
			// no fade for you
			if( bDeleteActor )
			{
				FadeActor.Destroy();
			}

			Destroy();
		}
		else if( !bInitialized )
		{
			// after DelayTime seconds do one time setup for fading
			if( InitialScaleGlow == 0.0 )
			{
				InitialScaleGlow = FadeActor.ScaleGlow;
			}

			FadeActor.ScaleGlow = InitialScaleGlow;

			FadeRate = (InitialScaleGlow - FinalScaleGlow) / FadeTime;

			bInitialized = true;
		}
		else
		{
			if( NumFlickers > 0 )
			{
				// flicker in and out of Translucent style -- might be useful in some cases
				if( FadeActor.Style == STY_Translucent )
				{
					FadeActor.Style = STY_Normal;
					NumFlickers--;
				}
				else 
				{
					FadeActor.Style = STY_Translucent;
				}
			}
			else
				{
				// smoothly fade actor from initial to final scaleglow
				FadeActor.Style = STY_Translucent;

				FadeActor.ScaleGlow -= FadeRate * DeltaTime;

				if( FadeActor.ScaleGlow <= FinalScaleGlow )
				{
					if( bDeleteActor )
					{
						FadeActor.Destroy();
					}

					Destroy();				// Our work here is finished.
				}
			}
		}
	}
}

defaultproperties
{
     FadeTime=0.500000
     bDeleteActor=True
     RemoteRole=ROLE_SimulatedProxy
}
