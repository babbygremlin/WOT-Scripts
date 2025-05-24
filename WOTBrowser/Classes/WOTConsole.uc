//=============================================================================
// WOTConsole - console replacer to implement UWindow UI System
//=============================================================================
class WOTConsole extends UBrowserConsole;

var config string SavedPasswords[10];

var string JoinPassword;

function string GetJoinOptions()
{
	local string JoinOptions;

	JoinOptions =
		(	"?Class="		$ Viewport.Actor.GetDefaultURL( "Class" )
		$	"?Skin="		$ Viewport.Actor.GetDefaultURL( "Skin" )
		$	"?Name="		$ Viewport.Actor.GetDefaultURL( "Name" )
		);

	if( Viewport.Actor.Player.CurrentNetSpeed > 0 )
		JoinOptions = JoinOptions$"?Rate="$Viewport.Actor.Player.CurrentNetSpeed;
		
	if( JoinPassword != "" )
		JoinOptions = JoinOptions$"?Password="$JoinPassword;
	
	return JoinOptions;
}

event ConnectFailure( string FailCode, string URL )
{
	local int i, j;
	local string Server;
	local WOTBrowserPasswordWindow W;

	if(FailCode == "NEEDPW")
	{
		Server = Left(URL, InStr(URL, "/"));
		for(i=0; i<10; i++)
		{
			j = InStr(SavedPasswords[i], "=");
			if(Left(SavedPasswords[i], j) == Server)
			{
				Viewport.Actor.ClearProgressMessages();
				Viewport.Actor.ClientTravel(URL$"?password="$Mid(SavedPasswords[i], j+1), TRAVEL_Absolute, false);
//				GetParent(class'UWindowFramedWindow').Close();
				CloseUWindow();
				return;
			}
		}
	}

	if(FailCode == "NEEDPW" || FailCode == "WRONGPW")
	{
		Viewport.Actor.ClearProgressMessages();
		CloseUWindow();
		//bQuickKeyEnable = True;
		LaunchUWindow();
		//W = WOTBrowserPasswordWindow(Root.CreateWindow(class'WOTBrowserPasswordWindow', 100, 100, 100, 100));
		W = WOTBrowserPasswordWindow(Root.CreateWindow(class'WOTBrowserPasswordWindow', 300, 80, 100, 100));
		WOTBrowserPasswordCW(W.ClientArea).URL = URL;
		//Root.ShowModal(W);
	}
	else
	{
		log( FailCode );
		Message( None, FailCode, 'Message' );
	}
}

function ConnectWithPassword(string URL, string Password)
{
	local int i;
	local string Server;
	local bool bFound;

	bFound = False;
	Server = Left(URL, InStr(URL, "/"));
	for(i=0; i<10; i++)
	{
		if(Left(SavedPasswords[i], InStr(SavedPasswords[i], "=")) == Server)
		{
			SavedPasswords[i] = Server$"="$Password;
			bFound = True;
			break;
		}
	}
	if(!bFound)
	{
		for(i=9; i>0; i--)
			SavedPasswords[i] = SavedPasswords[i-1];
		SavedPasswords[0] = Server$"="$Password;	
	}
	SaveConfig();
	Viewport.Actor.ClientTravel(URL$"?password="$Password, TRAVEL_Absolute, false);
//	GetParent(class'UWindowFramedWindow').Close();
	CloseUWindow();
}

defaultproperties
{
     RootWindow="WOTBrowser.WOTBrowserRootWindow"
}
