//=============================================================================
// LevelTransitionManager.uc
// $Author: Mfox $
// $Date: 9/19/99 1:28p $
// $Revision: 3 $
//=============================================================================
class LevelTransitionManager expands Object abstract;

//=============================================================================

static function HandleMovie( PlayerPawn P, string MovieFileName )
{
	if( MovieFileName != "" )
	{
		// play Movie -- this might not return for a long time
		P.ConsoleCommand( "PlayMovie " $ MovieFilename );
	}
}

//=============================================================================

static function HandleLevelTransition( PlayerPawn P, string MovieFileName )
{
	// play cutscene, if found -- returns when done
	HandleMovie( P, MovieFileName );
}

defaultproperties
{
}
