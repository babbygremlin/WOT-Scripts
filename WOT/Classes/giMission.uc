//=============================================================================
// giMission.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================
class giMission expands giWOT;

// Level.Game.IsA( 'giMission' ) is used to specify single player levels.
// Currently, this enables the menus to be senstive to SP context.

// Place a bag in a level and set its tag to 'AdditionalInitialInventory' if you
// want other artifacts to be added to the player's inventory on startup.

// set team and team name
function bool ChangeTeam( Pawn Other, int Team )
{
	log( Self $ ".ChangeTeam( " $ Other $ ", " $ Team $ " )" );
	Other.PlayerReplicationInfo.Team = Team;
	Other.PlayerReplicationInfo.Teamname = String( Other.Class.Name );
	return true;
}

// force player to start single player Missions as the AesSedai
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
		Player.Tag = Player.Class.Name;
	}

	return Player;
}

// Look for bags of additional inventory to give to the player at startup.
function AddDefaultInventory( Pawn PlayerPawn )
{
	local AngrealInventory A;
	local BagHolding Bag;

	Super.AddDefaultInventory( PlayerPawn );

	foreach AllActors( class'BagHolding', Bag, 'AdditionalInitialInventory' ) 
		Bag.GiveTo( PlayerPawn );
}

// end of giMission.uc

defaultproperties
{
}
