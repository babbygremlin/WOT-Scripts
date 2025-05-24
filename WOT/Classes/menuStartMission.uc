//=============================================================================
// menuStartGame.uc
//=============================================================================
class menuStartMission expands menuLong;

// Easy
// Medium
// Hard

var() string FirstMap;
var() string MovieName;

//=============================================================================

function PostBeginPlay()
{
	Super.PostBeginPlay();
	Selection = Clamp( Level.Game.Difficulty + 1, 1, 3 );
} 

//=============================================================================

function bool ProcessSelection()
{
	WOTPlayer(PlayerOwner).ConsoleCommand( "MP3 STOP" );

	WOTPlayer(PlayerOwner).SetTransitionType( TRT_NewGame );
	class'LevelTransitionManager'.static.HandleLevelTransition( PlayerOwner, MovieName );

	StartMap( FirstMap$"?Difficulty="$(Selection - 1) );

	return true;
}

//=============================================================================

function DrawMenu( Canvas C )
{
	Level.Game.Difficulty = Selection - 1;
	Level.Game.SaveConfig();

	DrawList( C ); 
	DrawHelpPanel( C );
}

//=============================================================================

defaultproperties
{
     FirstMap="Mission_01"
     MovieName="Mission_00.mov"
     MenuLength=3
}
