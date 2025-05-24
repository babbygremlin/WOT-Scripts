//=============================================================================
// giSPArena.uc
//
//=============================================================================
class giSPArena expands giCombatBase;

function PlayerPawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<PlayerPawn> SpawnClass
)
{
	local PlayerPawn NewPlayer;

	NewPlayer = Super.Login( Portal, Options, Error, SpawnClass );
	if( NewPlayer == None )
		return None;

	if( !ChangeTeam( NewPlayer, -1 ) )
	{
		Error = "Could not find team for player";
		return None;
	}
		
	return NewPlayer;
}

//end of giSPArena.uc

defaultproperties
{
     ScoreBoardType=Class'WOT.ArenaScoreBoard'
     MapPrefix="Arena_"
}
