class WOTBrowserServerListWindow extends UBrowserServerListWindow
	PerObjectConfig;

function Created()
{
	local Class<UBrowserServerGrid> C;

	ServerListClass = class<UBrowserServerList>(DynamicLoadObject(ServerListClassName, class'Class'));
	C = class<UBrowserServerGrid>(DynamicLoadObject(GridClass, class'Class'));
	Grid = UBrowserServerGrid(CreateWindow(C, 0, 0, WinWidth, WinHeight));
	Grid.SetAcceptsFocus();

	SubsetList = new class'UBrowserSubsetList';
	SubsetList.SetupSentinel();

	SupersetList = new class'UBrowserSupersetList';
	SupersetList.SetupSentinel();

	VSplitter = UWindowVSplitter(CreateWindow(class'UWindowVSplitter', 0, 0, WinWidth, WinHeight));
	VSplitter.SetAcceptsFocus();
	VSplitter.MinWinHeight = 60;
	VSplitter.HideWindow();
	InfoWindow = UBrowserMainClientWindow(GetParent(class'WOTBrowserMainClientWindow')).InfoWindow;
	InfoClient = UBrowserInfoClientWindow(InfoWindow.ClientArea);

	if(Root.WinHeight >= MinHeightForSplitter)
		ShowInfoArea(True, False);
}

defaultproperties
{
     ServerListClassName="WOTBrowser.WOTBrowserServerList"
     GridClass="WOTBrowser.WOTBrowserServerGrid"
     RightClickMenuClass=Class'WOTBrowser.WOTBrowserRightClickMenu'
}
