class WOTBrowserPasswordWindow expands UWindowFramedWindow;

var UWindowSmallCloseButton CloseButton;
var WOTBrowserPasswordOKButton OKButton;

function Created()
{
	Super.Created();

	OKButton = WOTBrowserPasswordOKButton(CreateWindow(class'WOTBrowserPasswordOKButton', WinWidth-108, WinHeight-24, 48, 16));
	OKButton.SetText("OK");
	CloseButton = UWindowSmallCloseButton(CreateWindow(class'UWindowSmallCloseButton', WinWidth-56, WinHeight-24, 48, 16));
	OKButton.Register(WOTBrowserPasswordCW(ClientArea));
	SetSizePos();
}

function ResolutionChanged(float W, float H)
{
	Super.ResolutionChanged(W, H);
	SetSizePos();
}

function SetSizePos()
{
	SetSize(FMin(Root.WinWidth-20, 400), 160);

	WinLeft = Int((Root.WinWidth - WinWidth) / 2);
	WinTop = Int((Root.WinHeight - WinHeight) / 2);
}

function Resized()
{
	Super.Resized();
	ClientArea.SetSize(ClientArea.WinWidth, ClientArea.WinHeight-24);
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);

	OKButton.WinLeft = ClientArea.WinLeft+ClientArea.WinWidth-104;
	OKButton.WinTop = ClientArea.WinTop+ClientArea.WinHeight+4;
	CloseButton.WinLeft = ClientArea.WinLeft+ClientArea.WinWidth-52;
	CloseButton.WinTop = ClientArea.WinTop+ClientArea.WinHeight+4;
}

function Paint(Canvas C, float X, float Y)
{
	local Texture T;

	T = GetLookAndFeelTexture();
	DrawUpBevel( C, ClientArea.WinLeft, ClientArea.WinTop + ClientArea.WinHeight, ClientArea.WinWidth, 24, T);

	Super.Paint(C, X, Y);
}

defaultproperties
{
     ClientClass=Class'WOTBrowser.WOTBrowserPasswordCW'
     WindowTitle="Password"
}
