//=============================================================================
// MissionObjectivesWindow.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

class MissionObjectivesWindow expands WOTTextWindow;

var bool bOKToStartMP3;

auto state Open
{
	function PlayDialogSound( string DialogSoundString )
	{
		local WOTPlayer W;
		local Sound DialogSound;

		DialogSound = Sound( DynamicLoadObject( DialogSoundString, class'Sound' ) );
		if( DialogSound != None )
		{
			foreach AllActors( class'WOTPlayer', W )
			{
				W.PlaySound( DialogSound,  SLOT_Interface );
				break;
			}
		}
	}

	function BeginState()
	{
		// game might be paused -- unpause it so script code executes below
		giWOT(Level.Game).InternalPause( false, false, PlayerOwner );
	}

	function EndState()
	{
		local WOTPlayer W;

		// kill voiceover
		foreach AllActors( class'WOTPlayer', W )
		{
			W.PlaySound( None, SLOT_Interface );
			break;
		}

		if( bOKToStartMP3 && Level.MP3Filename != "" )
		{
			PlayerOwner.ConsoleCommand( "MP3 START "$ Level.MP3Filename );
		}
	}

Begin:
	if( MissionObjectives(WindowItem) != None && 
		MissionObjectives(WindowItem).GetOKToPlaySound() &&
	    MissionObjectives(WindowItem).DialogSoundString != "" )
	{
		PlayDialogSound( MissionObjectives(WindowItem).DialogSoundString );
		MissionObjectives(WindowItem).SetOKToPlaySound( false );

		// pause game and turn ambient sounds off
		giWOT(Level.Game).InternalPause( true, true, PlayerOwner );

		bOKToStartMP3 = true;
	}
	else
	{
		// pause game but leave ambient sounds on
		giWOT(Level.Game).InternalPause( true, false, PlayerOwner );
	}
}

//end of MissionObjectivesWindow.uc

defaultproperties
{
     MinimumResolution="640x480"
     WindowSizeX=512
     WindowSizeY=128
}
