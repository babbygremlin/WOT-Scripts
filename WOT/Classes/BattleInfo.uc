//=============================================================================
// BattleInfo.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 9 $
//=============================================================================
class BattleInfo expands Info;

var() int NumTeams;

// Indexed by team number.
var() class<WOTPlayer> TeamClass[4];	// Class of characters on this team.

var int		NumPlayers		[4];		// Current number of players on this team.
var int		NumSeals		[4];		// Current number of seals in this team's possesion.
var byte	bEditing		[4];		// Shadow of WOTPlayer.bEditing.
var byte	bEditingComplete[4];		// This player (and their team) have edited and are ready to begin play.

var int MaxTeamSize;
var bool bTeleportersDisabled;

var localized string EditingStr;
var localized string PlayingStr;
var localized string ReadyStr;
var localized string WaitingStr;

replication
{
	// Data the server should send to all clients
	reliable if( Role==ROLE_Authority )
		NumTeams,
		TeamClass,
		NumPlayers,
		NumSeals,
		bEditing,
		bEditingComplete,
		MaxTeamSize,
		bTeleportersDisabled;
}

function PreBeginPlay()
{
	local int i;

	Super.PreBeginPlay();

	// validate Self to ensure invalid map data doesn't interfere with testing 
	assert( NumTeams > 1 && NumTeams <= ArrayCount(TeamClass) );
	for( i = 0; i < NumTeams; i++ )
	{
		assert( TeamClass[i] != None );
		assert( NumPlayers[i] == 0 );
		assert( NumSeals[i] == 0 );
		assert( bEditing[i] == 0 );
		assert( bEditingComplete[i] == 0 );
	}
}

function ResetTeamSealCount( byte Team )
{
	NumSeals[ Team ] = 0;
}

function IncrementTeamSealCount( byte Team )
{
	NumSeals[ Team ]++;
}

function DecrementTeamSealCount( byte Team )
{
	NumSeals[ Team ]--;
}

simulated function int GetTeamSealCount( byte Team )
{
	if( Team == 255 )
		return 0;

	return NumSeals[ Team ];
}

simulated function string GetTeamDescription( byte Team )
{
	if( Team == 255 )
		return "Spectator";

	return TeamClass[ Team ].default.TeamDescription;
}

simulated function string GetTeamStatus( int Team )
{
	if		( bEditing				[ Team ]==1	)	return EditingStr;
	else if	(!bTeleportersDisabled				)	return PlayingStr;
	else if	( bEditingComplete		[ Team ]==1	)	return ReadyStr;
	else											return WaitingStr;
}

defaultproperties
{
     EditingStr="Editing"
     PlayingStr="Playing"
     ReadyStr="Ready"
     WaitingStr="Waiting"
     bAlwaysRelevant=True
}
