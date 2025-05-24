//=============================================================================
// menuShort.uc
//
// Short menus, like the player mesh/skin selection screen and the
// individual bot configuration screen. These menus do not have a background.
//=============================================================================
class menuShort expands menuWOT abstract;

//=============================================================================
// Short menus are used for displaying a mesh and some information
// about that mesh (for example, picking your class and skin before
// a game or setting up bots).  This rotates the displayed mesh.

function MenuTick( float DeltaTime )
{
	local rotator newRot;
	local float RemainingTime;

	if( Level.Pauser != "" )
	{
		// explicit rotation, since game is paused
		newRot = Rotation;
		newRot.Yaw = newRot.Yaw + RotationRate.Yaw * DeltaTime;
		SetRotation(newRot);
	
		//explicit animation
		RemainingTime = DeltaTime * 0.5;
		while( RemainingTime > 0 )
		{
			if( AnimFrame < 0 )
			{
				AnimFrame += TweenRate * RemainingTime;
				if( AnimFrame > 0 )
				{
					RemainingTime = AnimFrame/TweenRate;
				}
				else
				{
					RemainingTime = 0;
				}
			}
			else
			{
				AnimFrame += AnimRate * RemainingTime;
				if( AnimFrame > 1 )
				{
					RemainingTime = (AnimFrame - 1)/AnimRate;
					AnimFrame = 0;
				}
				else
				{
					RemainingTime = 0;
				}
			}
		}
	}
}

defaultproperties
{
}
