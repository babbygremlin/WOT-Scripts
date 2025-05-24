///=============================================================================
// CutsceneTeleporter.uc
// $Author: Mpoesch $
// $Date: 10/06/99 6:16p $
// $Revision: 10 $
//=============================================================================
class CutsceneTeleporter expands Teleporter;

//#if 1 //NEW

var() string 	Filename;		// Does not include path
var() bool		PlayOnce;		// Can the cutscene be triggered only once?
var   bool		bPlayed;		// Has the cutscene been triggered?

//=============================================================================

function Touch( Actor Other )
{
	if( !bEnabled )
		return;

	if( PlayerPawn(Other) != None ) 
	{
		PlayerPawn(Other).ConsoleCommand( "MP3 STOP" );

		if( Level.NetMode == NM_StandAlone && FileName != "" && ( !bPlayed || !PlayOnce ) ) 
		{
			if( Other.Instigator != None )
			{
				if( PlayOnce ) 
				{
					bPlayed = true;
				}				
			}
			class'LevelTransitionManager'.static.HandleLevelTransition( PlayerPawn(Other), FileName );

			Super.Touch( Other );
		}
	}
}

//=============================================================================

function PlayTeleportEffect( Actor Incoming, bool bOut )
{
}

//#endif

defaultproperties
{
     PlayOnce=True
}
