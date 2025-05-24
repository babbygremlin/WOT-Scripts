//=============================================================================
// giMission_12e3.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================
class giMission_12e3 expands giWOT;

// force player to start the Mission 12 E3 demo as the AesSedai,
// with team 0 and Elayna as her name.
event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local class<WOTPlayer> PlayerClass;
	local PlayerPawn Player;

	// enforce player class, team, and name
	PlayerClass = class<WOTPlayer>( DynamicLoadObject( "WOTPawns.AesSedai", class'Class' ) );
	Player = Super.Login( Portal, Options, Error, PlayerClass );
	if( Player != None )
	{
		ChangeTeam( Player, 0 );
		ChangeName( Player, "Elayna Sedai", false );
	}

	return Player;
}

// end of giMission.uc

defaultproperties
{
}
