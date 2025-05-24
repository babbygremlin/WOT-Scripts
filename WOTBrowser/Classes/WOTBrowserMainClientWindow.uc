//=============================================================================
// WOTBrowserMainClientWindow - The main client area
//=============================================================================
class WOTBrowserMainClientWindow extends UBrowserMainClientWindow;

function Created() 
{
	local int i, f;
	local UWindowPageControlPage P;
	local UBrowserServerListWindow W;
	local class<UBrowserServerListWindow> C;
	local class<UBrowserFavoriteServers> FC;
//	local class<UBrowserUpdateServerWindow> MC;

	Super(UWindowClientWindow).Created();

	InfoWindow = UBrowserInfoWindow(Root.CreateWindow(class'UBrowserInfoWindow', 10, 40, 310, 170));
	InfoWindow.HideWindow();

	PageControl = UWindowPageControl(CreateWindow(class'UWindowPageControl', 0, 0, WinWidth, WinHeight));
	PageControl.SetMultiLine(True);

//	// Add MOTD
//	MC = class<UBrowserUpdateServerWindow>(DynamicLoadObject(UpdateServerClass, class'Class'));
//	MOTD = PageControl.AddPage(MOTDName, MC);
//
//	IRC = PageControl.AddPage(IRCName, class'UBrowserIRCWindow');

	// Add favorites
	FC = class<UBrowserFavoriteServers>(DynamicLoadObject(FavoriteServersClass, class'Class'));
	Favorites = PageControl.AddPage(FavoritesName, FC);

	C = class<UBrowserServerListWindow>(DynamicLoadObject(ServerListWindowClass, class'Class'));

	for(i=0; i<20; i++)
	{
		if(ServerListNames[i] == '')
			break;

		P = PageControl.AddPage("", C, ServerListNames[i]);
		if(string(ServerListNames[i]) ~= LANTabName)
			LANPage = P;

		W = UBrowserServerListWindow(P.Page);
		if(W.bHidden)
			PageControl.DeletePage(P);

		if(W.ServerListTitle != "")
			P.SetCaption(W.ServerListTitle);
		else
			P.SetCaption(Localize("ServerListTitles", string(ServerListNames[i]), "WOTBrowser"));

		FactoryWindows[i] = W;
	}
}

function NewMasterServer(string M)
{
	local int i;

	if(!bKeepMasterServer)
	{
		for(i=0; i<20; i++)
		{
			if(ServerListNames[i] == 'WOTBrowserAll')
			{
				if(FactoryWindows[i].ListFactories[0] != M)
				{
					Log("Received new master server from UpdateServer: "$M);
					FactoryWindows[i].ListFactories[0] = M;
					FactoryWindows[i].ListFactories[1] = "";
					if(FactoryWindows[i].bHadInitialRefresh)
						FactoryWindows[i].Refresh(False, True);
					FactoryWindows[i].SaveConfig();
				}
			}
		}
	}
}

defaultproperties
{
     ServerListWindowClass="WOTBrowser.WOTBrowserServerListWindow"
     FavoriteServersClass="WOTBrowser.WOTBrowserFavoriteServers"
}
