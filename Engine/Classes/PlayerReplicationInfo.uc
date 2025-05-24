//=============================================================================
// PlayerReplicationInfo.
//=============================================================================
class PlayerReplicationInfo expands ReplicationInfo
	native nativereplication;

var string				PlayerName;		// Player name, or blank if none.
var string				DisguiseName;   // Occupied if the player is disguised.
//var string				OldName;		// Temporary value.
var int					PlayerID;		// Unique id number.
var string				TeamName;		// Team name, or blank if none.
var byte				Team;			// Player Team, 255 = None for player.
var int					TeamID;			// Player position in team.
var float				Score;			// Player's current score.
//var float				Deaths;			// Number of player's deaths.
//var float				Spree;			// Player is on a killing spree.
var class<VoicePack>	VoiceType;
//var Decoration			HasFlag;
var int					Ping;
var bool				bIsFemale;
var	bool				bIsABot;
var bool				bFeigningDeath;
var bool				bIsSpectator;
var bool				bWaitingPlayer;
var bool				bAdmin;
//var Texture				TalkTexture;
var ZoneInfo			PlayerZone;
var LocationID			PlayerLocation;
var name				SuicideType;
//var int					Rank;
//var int					Lead;

//#if 1 //NEW
var int					PacketLoss;
var int					Kills;
var int					Deaths;
var int					Suicides;
var float				TimeOnServer;
var byte				Color;		// 1=Base, 2=Black, 3=Blue, 4=Red, 5=Green
var byte				PlayerType;	// 0=AesSedai, 1=Forsaken, 2=Hound, 3=Whitecloak
var bool				bIsNPC;
//#endif

replication
{
//#if 1 //NEW
	// Things the server should send to the client.
	reliable if ( Role == ROLE_Authority )
		PlayerName, DisguiseName, PlayerID, TeamName, Team, TeamID, Score, VoiceType,
		Ping, bIsFemale, bIsABot, bFeigningDeath, bIsSpectator, bWaitingPlayer,
		bAdmin, PlayerZone, PlayerLocation, SuicideType;
//#else
//	// Things the server should send to the client.
//	reliable if ( Role == ROLE_Authority )
//		PlayerName, OldName, PlayerID, TeamName, Team, TeamID, Score, Deaths, Spree, VoiceType,
//		HasFlag, Ping, bIsFemale, bIsABot, bFeigningDeath, bIsSpectator, bWaitingPlayer,
//		bAdmin, TalkTexture, PlayerZone, PlayerLocation, SuicideType, Rank, Lead;
//#endif

//#if 1 //NEW
	reliable if( Role==ROLE_Authority )
		PacketLoss, Kills, Deaths, Suicides, Color, PlayerType, bIsNPC;

	reliable if( Role==ROLE_Authority && bNetInitial )
		TimeOnServer;
//#endif
}

function PostBeginPlay()
{
	Timer();
	SetTimer(2.0, true);
	bIsFemale = Pawn(Owner).bIsFemale;
}
 					
function Timer()
{
	local float MinDist, Dist;
	local LocationID L;

	MinDist = 1000000;
	PlayerLocation = None;
	if ( PlayerZone != None )
		for ( L=PlayerZone.LocationID; L!=None; L=L.NextLocation )
		{
			Dist = VSize(Owner.Location - L.Location);
			if ( (Dist < L.Radius) && (Dist < MinDist) )
			{
				PlayerLocation = L;
				MinDist = Dist;
			}
		}

//#if 1 //NEW
	if( PlayerPawn(Owner) != None )
	{
		Ping = int(PlayerPawn(Owner).ConsoleCommand("GETPING"));
		PacketLoss = int(PlayerPawn(Owner).ConsoleCommand("GETLOSS"));
	}
//#else
//	if (PlayerPawn(Owner) != None)
//		Ping = int(PlayerPawn(Owner).ConsoleCommand("GETPING"));
//#endif
}

//#if 1 //NEW
simulated function Tick( float DeltaTime )
{
	// No need to call -- Super.Tick( DeltaTime );
	TimeOnServer += DeltaTime;
}
//#endif

defaultproperties
{
    Team=255
    RemoteRole=2
    NetUpdateFrequency=4.00
}
