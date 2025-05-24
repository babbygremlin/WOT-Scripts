class WOTBrowserPasswordOKButton extends UWindowSmallButton;

function Notify(byte E)
{
	Super.Notify(E);

	if(E == DE_Click)
		WOTBrowserPasswordCW(WOTBrowserPasswordWindow(GetParent(class'WOTBrowserPasswordWindow')).ClientArea).OKPressed();
}

defaultproperties
{
}
