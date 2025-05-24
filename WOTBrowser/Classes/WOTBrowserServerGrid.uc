//=============================================================================
// WOTBrowserServerGrid.
//=============================================================================
class WOTBrowserServerGrid extends UBrowserServerGrid;

enum EServerStatus	// Mirrored in WOTBrowserServerList.uc
{
	STAT_Unknown,
	STAT_Private,
	STAT_Public
};

var UBrowserServerList LastRequestedServer;	// Stored for latent function call usage.

//------------------------------------------------------------------------------
// Filter function call based on server's public access status.
//------------------------------------------------------------------------------
function JoinServer( UBrowserServerList Server )
{
//!!TEMP
	// NOTE[aleiby]: Waiting for Jack Porter's method of passwording.
	ConnectToServer( Server );
	return;
//!!TEMP
/*
	LastRequestedServer = Server;

	switch( WOTBrowserServerList(Server).Status )
	{
	case STAT_Private:
		RequestPassword();
		break;

	case STAT_Public:
	case STAT_Unknown:
	default:
		ConnectToServer( Server );
		break;
	}
*/
/* -- DEPRICATED
	switch( ServerAccess( Server ) )
	{
	case STAT_Public:
		ConnectToServer( Server );
		break;

	case STAT_Private:
		RequestPassword();
		break;

	case STAT_Unknown:
		QueryServerAccess( Server );
		break;
	}
*/
}

//------------------------------------------------------------------------------
// Replaces the normal JoinServer function.
//------------------------------------------------------------------------------
/*private*/ function ConnectToServer( optional UBrowserServerList Server, optional string Password )
{
	local string URL;

	// Get defaults for optional parameters.
	if( Server == None )
	{
		Server = LastRequestedServer;
	}

	if( Server != None && Server.GamePort != 0 ) 
	{
		URL = 
			(/*	"unreal://"
			$*/	Server.IP
			$	":"$Server.GamePort
			$	UBrowserServerListWindow(GetParent(class'UBrowserServerListWindow')).URLAppend
			$	WOTConsole(GetPlayerOwner().Player.Console).GetJoinOptions()
			);

		if( Password != "" )
			URL = URL $ "?Password=" $ Password;
			
		GetPlayerOwner().ClientTravel( URL, TRAVEL_Absolute, false );
		GetParent(class'UWindowFramedWindow').Close();
		Root.Console.CloseUWindow();
	}
}

//------------------------------------------------------------------------------
// Create a modal dialog to ask the player what password to use to join this
// server.
//------------------------------------------------------------------------------
function RequestPassword( optional UBrowserServerList Server )
{
	if( Server != None )
	{
		LastRequestedServer = Server;
	}

	GetParent(class'UWindowFramedWindow').ShowModal(Root.CreateWindow(class'WOTBrowserPasswordWindow', 300, 80, 100, 100, Self, True));
}

/**DEPRICATED**/
//------------------------------------------------------------------------------
function QueryServerAccess( UBrowserServerList Server )
{
	// Send password query to server.
}

/**DEPRICATED**/
//------------------------------------------------------------------------------
function RecieveServerAccessQuery( /*DATA*/ )
{
	local bool bPrivate;

	bPrivate = true;	// NOTE[aleiby]: Set bPrivate based on given query data.

	if( bPrivate )
	{
		RequestPassword();
	}
	else
	{
		ConnectToServer( LastRequestedServer );
	}
}

/**DEPRICATED**/
//------------------------------------------------------------------------------
// Check the server's rules to see if we already know whether it requires a
// password or not.
//
// Returns: Public, Private or Unknown.
//------------------------------------------------------------------------------
function EServerStatus ServerAccess( UBrowserServerList Server )
{
//	local UBrowserRulesList RulesList;
	local EServerStatus Status;

	Status = STAT_Unknown;

/* -- Can't use because Server.ServerPing is usually None.
	// Find public access rule.
	for( RulesList = UBrowserRulesList(Server.RulesList.Next); RulesList != None; RulesList = UBrowserRulesList(RulesList.Next) )
	{
		if( RulesList.Rule ~= WOTBrowserServerPing(Server.ServerPing).PublicAccessText )
		{
			if( RulesList.Value ~= Server.ServerPing.LocalizeBoolValue("True") )
			{
				Status = STAT_Public;
			}
			else
			{
				Status = STAT_Private;
			}

			break;	// We found what we were looking for.
		}
	}
*/
	return Status;
}	

defaultproperties
{
}
