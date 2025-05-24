//#if 1 //NEW (merge it all)
//=============================================================================
// GameReplicationInfo.
//=============================================================================
class GameReplicationInfo extends ReplicationInfo
	native nativereplication;

var string GameName;						// Assigned by GameInfo.
var bool bTeamGame;							// Assigned by GameInfo.
var bool bClassicDeathMessages;
var bool bStopCountDown;
var float RemainingTime, ElapsedTime;
var bool bDisplayRemaining;					// bDisplayElapsed implied if false.
var int RemainingMinute;
var float SecondCount;

var() globalconfig string ServerName;		// Name of the server, i.e.: Bob's Server.
var() globalconfig string ShortName;		// Abbreviated name of server, i.e.: B's Serv (stupid example)
var() globalconfig string AdminName;		// Name of the server admin.
var() globalconfig string AdminEmail;		// Email address of the server admin.
var() globalconfig int 		 Region;		// Region of the game server.

var() globalconfig bool ShowMOTD;			// Whether or not to display the MOTD.
var() globalconfig string MOTDLine1;		// Message
var() globalconfig string MOTDLine2;		// Of
var() globalconfig string MOTDLine3;		// The
var() globalconfig string MOTDLine4;		// Day

var string GameEndedComments;				// set by gameinfo when game ends

//#if 0 //NEW
//var PlayerReplicationInfo PRIArray[32];
//#endif

replication
{
	reliable if ( Role == ROLE_Authority )
		GameName, bTeamGame, ServerName, ShortName, AdminName,
		AdminEmail, Region, ShowMOTD, MOTDLine1, MOTDLine2, 
		MOTDLine3, MOTDLine4, bDisplayRemaining, RemainingMinute, bStopCountDown, GameEndedComments;

	reliable if ( bNetInitial && (Role==ROLE_Authority) )
		RemainingTime, ElapsedTime;
}

simulated function Tick( float DeltaTime )
{
	// No need to call Super.Tick( DeltaTime );
	if( !bStopCountDown )
	{
		RemainingTime -= DeltaTime;
		ElapsedTime += DeltaTime;
	}
}

//simulated function PostBeginPlay()
//{
//	SetTimer(0.2, true);
//}

/*
//#if 0 //NEW: Coder on crack version.
simulated function Timer()
{
	local PlayerReplicationInfo PRI;
	local int i;

	if ( Level.NetMode == NM_Client )
	{
		SecondCount += 0.2;
		if (SecondCount >= 1.0)
		{
			ElapsedTime++;
			if ( RemainingMinute != 0 )
			{
				RemainingTime = RemainingMinute;
				RemainingMinute = 0;
			}
			if ( (RemainingTime > 0) && !bStopCountDown )
				RemainingTime--;
			SecondCount = 0.0;
		}
	}

	for (i=0; i<32; i++)
		PRIArray[i] = None;
	i=0;
	foreach AllActors(class'PlayerReplicationInfo', PRI)
	{
		PRIArray[i++] = PRI;
	}
}
//#else // Cleaned up version.
*/
//simulated function Timer()
//{
//	local PlayerReplicationInfo PRI;
//	local int i;
//
//	if( Level.NetMode == NM_Client || Level.NetMode == NM_Standalone )
//	{
//		SecondCount += 0.2;
//		if( SecondCount >= 1.0 )
//		{
//			ElapsedTime++;
//			if( RemainingMinute != 0 )
//			{
//				RemainingTime = RemainingMinute;
//				RemainingMinute = 0;
//			}
//			if( RemainingTime > 0 && !bStopCountDown )
//			{
//				RemainingTime--;
//			}
//			SecondCount = 0.0;
//		}
//	}
//
/* Not needed for WOT.
	// Fill in array.
	i = 0;
	foreach AllActors( class'PlayerReplicationInfo', PRI )
	{
		PRIArray[i++] = PRI;
		if( i >= ArrayCount(PRIArray) )
		{
			break;
		}
	}

	// Clear out the rest.
	while( i < ArrayCount(PRIArray) )
	{
		PRIArray[i++] = None;
	}
*/
//}
//#endif

//#endif
defaultproperties
{
    ServerName="AD'sWOT-Patch"
    ShortName="WoT Server"
    RemoteRole=2
    NetUpdateFrequency=4.00
}
