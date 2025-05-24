//=============================================================================
// FlushTrigger.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================
class FlushTrigger expands Trigger;

var() bool bActiveForD3D;
var() bool bActiveForGlide;
var() bool bActiveForOpenGL;

// Called when something touches the trigger -- flush the engine cache.
// Complete override of Trigger.uc implementation (copy&paste + modifications)
function Touch( actor Other )
{
	local String DeviceStr;

	if( IsRelevant( Other ) )
	{
		if( ReTriggerDelay > 0 )
		{
			if( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
			{
				return;
			}
			TriggerTime = Level.TimeSeconds;
		}

		if( PlayerPawn(Other) != None )
		{
			// only flush the Glide Driver
			DeviceStr = PlayerPawn(Other).ConsoleCommand( "GetCurrentRenderDevice" );
			if(	DeviceStr == "D3DDrv.D3DRenderDevice"			&& bActiveForD3D
				|| DeviceStr == "GlideDrv.GlideRenderDevice"	&& bActiveForGlide
				|| DeviceStr == "OpenGLDrv.OpenGLRenderDevice"	&& bActiveForOpenGL	)
			{
				// Flush the engine cache
				ConsoleCommand( "FLUSH" );
			}
		}

		if( Message != "" )
		{
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage( Message );
		}

		if( bTriggerOnceOnly )
		{
			// Ignore future touches.
			SetCollision( false );
		}
		else if( RepeatTriggerTime > 0 )
		{
			SetTimer( RepeatTriggerTime, false );
		}
	}
}

//
// When something untouches the trigger.
// Complete override of Trigger.uc implementation -- do nothing
//
function UnTouch( actor Other )
{
}

defaultproperties
{
     bActiveForGlide=True
     CollisionRadius=80.000000
}
