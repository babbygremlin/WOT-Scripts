//=============================================================================
// WOTBrowserServerList
//		Stores a server entry in an Unreal Server List
//=============================================================================

class WOTBrowserServerList extends UBrowserServerList;

/*
enum EServerStatus	// Mirrored in WOTBrowserServerGrid.uc
{
	STAT_Unknown,
	STAT_Private,
	STAT_Public
};

var EServerStatus Status;	// Defaults to STAT_Unknown until set.

function SetPublicAccess( bool bPublic )
{
	if( bPublic )
		Status = STAT_Public;
	else
		Status = STAT_Private;
}
*/

// Functions for server list entries only.
function PingServer(bool bInitial, bool bJustThisServer, bool bNoSort)
{
	// Create the UdpLink to ping the server
	ServerPing = GetPlayerOwner().GetEntryLevel().Spawn(class'WOTBrowserServerPing');
	ServerPing.Server = Self;
	ServerPing.StartQuery('GetInfo', 2);
	ServerPing.bInitial = bInitial;
	ServerPing.bJustThisServer = bJustThisServer;
	ServerPing.bNoSort = bNoSort;
	bPinging = True;
}

function ServerStatus()
{
	// Create the UdpLink to ping the server
	ServerPing = GetPlayerOwner().GetEntryLevel().Spawn(class'WOTBrowserServerPing');
	ServerPing.Server = Self;
	ServerPing.StartQuery('GetStatus', 2);
	bPinging = True;
}

defaultproperties
{
}
