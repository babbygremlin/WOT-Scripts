//=============================================================================
// WOTWindow.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 10 $
//=============================================================================
class WOTWindow expands uiWindow abstract;

#exec TEXTURE IMPORT FILE=Textures\Hud\InfoBoxC1.pcx GROUP=UI MIPS=FALSE FLAGS=2050 //PF_NoSmooth | PF_Masked
#exec TEXTURE IMPORT FILE=Textures\Hud\InfoBoxC2.pcx GROUP=UI MIPS=FALSE FLAGS=2050 //PF_NoSmooth | PF_Masked

var() bool bPauseGame;
var() bool bHideUI;
var() bool bBlank;
var() string MinimumResolution;

var string OldResolution;
var PlayerPawn PlayerOwner;

var string CornerTextureName;
var string OtherTextureName;
var Texture CornerTexture;
var Texture OtherTexture;

// window component coordinates
var Region TL,   Top,        TR;
var Region Left, Background, Right;
var Region BL,   Bottom,     BR;
var float LOffset, TOffset, ROffset, BOffset;

//=============================================================================

function PreBeginPlay()
{
	local PlayerPawn P;

	Super.PreBeginPlay();
	
	foreach AllActors( class'PlayerPawn', P )
	{
		PlayerOwner = P;
		
		P.bShowMenu = false;
 		if( bPauseGame && Level != None && giWOT(Level.Game) != None )
		{
			// pauses game but also stops sounds (e.g. MissionObjectives voiceover) from playing
			giWOT(Level.Game).InternalPause( true, false, P );
		}
		if( bBlank )
		{
			// blank the background
			P.Player.Console.bNoDrawWorld = true;
		}
		if( bHideUI )
		{
			WOTPlayer(P).HideUI( true );
		}
		else
		{
			WOTPlayer(P).HideUIExceptForHands( true );
		}
		if( MinimumResolution != "" )
		{
			OldResolution = P.ConsoleCommand( "GetCurrentRes" );
			
			if( OldResolution != "" )
			{
				WOTPlayer(P).SetResolution( MinimumResolution, true );
			}
		}
	}
}

//=============================================================================

function Destroyed()
{
	local PlayerPawn P;

	foreach AllActors( class'PlayerPawn', P )
	{
 		if( Level != None && giWOT(Level.Game) != None )
 		{
   			giWOT(Level.Game).InternalPause( false, false, P );
		}

		WOTPlayer(P).HideUI( false );
		WOTPlayer(P).HideUIExceptForHands( false );

		if( bBlank && P.Player != None && P.Player.Console != None )
		{
			P.Player.Console.bNoDrawWorld = false;
		}

		if( MinimumResolution != "" && OldResolution != "" )
		{
			WOTPlayer(P).SetResolution( OldResolution, false );
			OldResolution = "";
		}
	}

	Super.Destroyed();
}

//=============================================================================

function DrawSeparator( Canvas C, int PosX, int PosY, int Indent, region TexRegL, region TexRegC, region TexRegR, Texture Tex )
{
	C.SetPos( PosX, PosY );
	DrawRegion( C, Indent, C.CurY, TexRegL, Tex );
	TileRegion( C, C.CurX, C.CurY, WindowClipSizeX - 2*(Indent+TexRegL.W), TexRegC.H, TexRegC, Tex );
	DrawRegion( C, C.CurX, C.CurY, TexRegR, Tex );
}

//=============================================================================

function DrawWindow( canvas C )
{
	C.bNoSmooth = true;
	
	if( C.Style != ERenderStyle.STY_None )
	{
		C.Style = ERenderStyle.STY_Normal;
	}
	
	if( CornerTexture == None )
	{
		CornerTexture = Texture( DynamicLoadObject( CornerTextureName, class'Texture' ) );
	}

	FillRegion( C, WindowPosX+LOffset+8, WindowPosY+TOffset+8, WindowSizeX-LOffset-ROffset, WindowSizeY-TOffset-BOffset, Background, CornerTexture );

	if( C.Style != ERenderStyle.STY_None )
	{
		C.Style = ERenderStyle.STY_Masked;
	}
	
	if( OtherTexture == None )
	{
		OtherTexture = Texture( DynamicLoadObject( OtherTextureName, class'Texture' ) );
	}

	TileRegion( C, WindowPosX+LOffset,	WindowPosY+TL.H,					Left.W,				WindowSizeY-TL.H*2, Left,		OtherTexture );
	TileRegion( C, WindowPosX+WindowSizeX-ROffset, WindowPosY+TL.H,					Right.W,			WindowSizeY-TL.H*2, Right,	OtherTexture );
	TileRegion( C, WindowPosX+TL.W,      WindowPosY+TOffset,				WindowSizeX-TL.W*2, Top.H,    Top,		OtherTexture );
	TileRegion( C, WindowPosX+TL.W,      WindowPosY+WindowSizeY-BOffset,	WindowSizeX-TL.W*2, Bottom.H, Bottom,	OtherTexture );

	DrawRegion( C, WindowPosX,					WindowPosY,					TL, CornerTexture );
	DrawRegion( C, WindowPosX+WindowSizeX-TR.W,	WindowPosY,					TR, CornerTexture );
	DrawRegion( C, WindowPosX,					WindowPosY+WindowSizeY-BL.H, BL, CornerTexture );
	DrawRegion( C, WindowPosX+WindowSizeX-BR.W,	WindowPosY+WindowSizeY-BR.H, BR, CornerTexture );
}

//=============================================================================

function Draw( canvas C )
{
	WindowSizeX = WindowBaseSizeX;
	WindowSizeY = WindowBaseSizeY;
	
	WindowPosX = (Max(640, C.SizeX) - WindowSizeX) / 2 + WindowOffsetX;
	WindowPosY = (Max(480, C.SizeY) - WindowSizeY) / 2 + WindowOffsetY;

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	DrawWindow( C );
	
	WindowClipPosX	= LegendCanvas(C).ScaleValX( WindowPosX + WindowBorderX );
	WindowClipPosY	= LegendCanvas(C).ScaleValY( WindowPosY + WindowBorderY );
	WindowClipSizeX	= LegendCanvas(C).ScaleValX( WindowSizeX - 2*WindowBorderX );
	WindowClipSizeY	= LegendCanvas(C).ScaleValY( WindowSizeY - 2*WindowBorderY );

	C.SetOrigin( WindowClipPosX, WindowClipPosY );
	C.SetClip( WindowClipSizeX, WindowClipSizeY );
	C.SetPos( 0, 0 );
}

// end of WOTWindow.uc

defaultproperties
{
     CornerTextureName="WOT.UI.InfoBoxC1"
     OtherTextureName="WOT.UI.InfoBoxC2"
     TL=(W=64,H=64)
     Top=(X=96,Y=240,W=16,H=16)
     TR=(X=64,W=64,H=64)
     Left=(X=64,Y=240,W=16,H=16)
     Background=(X=64,Y=64,W=16,H=16)
     Right=(X=80,Y=240,W=16,H=16)
     BL=(Y=64,W=64,H=64)
     Bottom=(X=112,Y=240,W=16,H=16)
     BR=(X=64,Y=64,W=64,H=64)
     LOffset=16.000000
     TOffset=4.000000
     ROffset=31.000000
     BOffset=20.000000
}
