//=============================================================================
// MainHUD.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 13 $
//=============================================================================
class MainHUD expands BaseHUD;

#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair1.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair1
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair2.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair2
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair3.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair3
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair4.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair4
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair5.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair5
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair6.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair6
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair7.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair7
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair8.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair8
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair9.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair9
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair10.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair10
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair11.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair11
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair12.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair12
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair13.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair13
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair14.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair14
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair15.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair15
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair16.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair16
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair17.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair17
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair18.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair18
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair19.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair19
#exec TEXTURE IMPORT FILE=Textures\Hud\CrossHairs\chair20.PCX GROUP=Icons MIPS=OFF FLAGS=2 NAME=Crosshair20

// Crosshair21 == No crosshair
const NumCrossHairs	= 21;

#exec TEXTURE IMPORT FILE=Icons\SeekerFrame.pcx GROUP=UI MIPS=Off FLAGS=2

#exec TEXTURE IMPORT FILE=Icons\T32_01.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_02.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_03.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_04.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_05.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_06.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_07.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_08.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_09.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_10.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_11.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_12.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_13.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_14.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_15.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_16.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_17.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_18.PCX Group=UI MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\T32_19.PCX Group=UI MIPS=Off FLAGS=2

var TEXTURE Timers[ 19 ];

const IconSpacing	= 8;
const IconWidth 	= 32;
const HealthHeight 	= 64;
const HealthOffsetX	= 24;
const HealthOffsetY = 54;

simulated function ChangeCrosshair( int d )
{
	Crosshair += d;
	if( Crosshair >= NumCrossHairs ) 
	{
		Crosshair = 0;
	}
	else if( Crosshair < 0 ) 
	{
		Crosshair = NumCrossHairs - 1;
	}
}


simulated function DrawCrossHair( Canvas C, int StartX, int StartY )
{
	C.Style = ERenderStyle.STY_Masked;
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
	C.SetPos( StartX, StartY );
	switch( Crosshair )
	{
	case 0:	 C.DrawIcon( texture'Crosshair1',  1.0 ); break;
	case 1:  C.DrawIcon( texture'Crosshair2',  1.0 ); break;
	case 2:  C.DrawIcon( texture'Crosshair3',  1.0 ); break;
	case 3:  C.DrawIcon( texture'Crosshair4',  1.0 ); break;
	case 4:  C.DrawIcon( texture'Crosshair5',  1.0 ); break;
	case 5:  C.DrawIcon( texture'Crosshair6',  1.0 ); break;
	case 6:  C.DrawIcon( texture'Crosshair7',  1.0 ); break;
	case 7:  C.DrawIcon( texture'Crosshair8',  1.0 ); break;
	case 8:  C.DrawIcon( texture'Crosshair9',  1.0 ); break;
	case 9:  C.DrawIcon( texture'Crosshair10', 1.0 ); break;
	case 10: C.DrawIcon( texture'Crosshair11', 1.0 ); break;
	case 11: C.DrawIcon( texture'Crosshair12', 1.0 ); break;
	case 12: C.DrawIcon( texture'Crosshair13', 1.0 ); break;
	case 13: C.DrawIcon( texture'Crosshair14', 1.0 ); break;
	case 14: C.DrawIcon( texture'Crosshair15', 1.0 ); break;
	case 15: C.DrawIcon( texture'Crosshair16', 1.0 ); break;
	case 16: C.DrawIcon( texture'Crosshair17', 1.0 ); break;
	case 17: C.DrawIcon( texture'Crosshair18', 1.0 ); break;
	case 18: C.DrawIcon( texture'Crosshair19', 1.0 ); break;
	case 19: C.DrawIcon( texture'Crosshair20', 1.0 ); break;
	// Crosshair21 == no crosshair
	}
	C.Style = ERenderStyle.STY_Normal;	
}


simulated function DrawCursor( Canvas C )
{
	local int StartX, StartY;

	StartX = 0.5 * C.ClipX - 8;
	StartY = 0.5 * C.ClipY - 8;
	DrawCrossHair( C, StartX, StartY );
}


simulated function DrawStatusIcons( Canvas C )
{
    local IconInfo I;
    local int GoodX;
    local int BadX;
	local int X;
	local int Y;
	local int GoodCount;
	local int BadCount;
	local int Index;

    GoodX = IconSpacing + IconWidth + IconSpacing;
    BadX = ScaledSizeX - IconWidth - IconSpacing;
	Y = IconSpacing;
    for( I = WOTPlayer(Owner).FirstIcon; I != None; I = I.Next )
	{
		if( I.bGoodIcon ) 
		{
			X = GoodX;
			GoodX += IconWidth + IconSpacing;
		} 
		else 
		{
			X = BadX;
			BadX -= IconWidth + IconSpacing;
		}
		if( I.InitialDuration == 0 ) 
		{
			Index = 0;
		} 
		else 
		{
			Index = max( min( ( ArrayCount( Timers ) - 1 ) * ( 1 - I.RemainingDuration / I.InitialDuration ), ArrayCount( Timers ) -1 ), 0 );
		}

		LegendCanvas( C ).DrawIconAt( I.Icon, X, Y, 0.5 );

		C.Style=ERenderStyle.STY_Masked;

		LegendCanvas( C ).DrawIconAt( Timers[ Index ], X, Y );
		C.Style=ERenderStyle.STY_Normal;
    }
}


simulated function DrawKeys( Canvas C )
{
	local int X;
	local int Y;
	local Inventory Inv;
	local int AbortCount;

	X = IconSpacing;
	Y = IconSpacing + HealthHeight + IconSpacing;

	C.Style = ERenderStyle.STY_Masked;

	AbortCount = 999;
	for( Inv = WOTPlayer(Owner).Inventory; Inv != None; Inv = Inv.Inventory )
	{
		if( Inv.IsA( 'Key' ) )
		{
			LegendCanvas( C ).DrawIconAt( Inv.StatusIcon, X, Y );
			Y += IconWidth + IconSpacing;
			if( Y > SizeY )
			{
				break;
			}
		}
		if( --AbortCount == 0 ) //hack to avoid crash due to circularly linked inventory
		{
			WOTPlayer(Owner).SalvageInventoryLinks();
			break;
		}
	}

	C.Style = ERenderStyle.STY_Normal;
}


simulated function DrawHealth( Canvas C )
{
	local WOTPlayer Player;
    local HandSet	CurrentHandSet;
    local HandInfo	Hand;
	local Inventory Inv;

	if( WOTPlayer( Owner ) == None )
		return;

	if( WOTPlayer( Owner ).GetHealthIcon() != None ) 
	{
		LegendCanvas( C ).DrawIconAt( WOTPlayer( Owner ).GetHealthIcon(), IconSpacing, IconSpacing );
		if( WOTPlayer( Owner ).SeekerCount != 0 )
		{
			C.Style = ERenderStyle.STY_Masked;
			LegendCanvas( C ).DrawIconAt( texture'SeekerFrame', IconSpacing, IconSpacing );
			C.Style = ERenderStyle.STY_Normal;
		}
		
		// health # should be centered under tile as value changes
		LegendCanvas( C ).DrawScaledTextAt( HealthOffsetX, HealthOffsetY, Max( 0, WOTPlayer( Owner ).Health ), font'F_Charge', false, false, true );
	}
}

simulated function PostRender( Canvas C )
{
	if( !bHide && !PlayerPawn( Owner ).bShowMenu && Level.LevelAction == LEVACT_None )
	{
		DrawCursor( C );
	}
    Super.PostRender( C );
}

defaultproperties
{
     Timers(0)=Texture'WOT.UI.T32_01'
     Timers(1)=Texture'WOT.UI.T32_02'
     Timers(2)=Texture'WOT.UI.T32_03'
     Timers(3)=Texture'WOT.UI.T32_04'
     Timers(4)=Texture'WOT.UI.T32_05'
     Timers(5)=Texture'WOT.UI.T32_06'
     Timers(6)=Texture'WOT.UI.T32_07'
     Timers(7)=Texture'WOT.UI.T32_08'
     Timers(8)=Texture'WOT.UI.T32_09'
     Timers(9)=Texture'WOT.UI.T32_10'
     Timers(10)=Texture'WOT.UI.T32_11'
     Timers(11)=Texture'WOT.UI.T32_12'
     Timers(12)=Texture'WOT.UI.T32_13'
     Timers(13)=Texture'WOT.UI.T32_14'
     Timers(14)=Texture'WOT.UI.T32_15'
     Timers(15)=Texture'WOT.UI.T32_16'
     Timers(16)=Texture'WOT.UI.T32_17'
     Timers(17)=Texture'WOT.UI.T32_18'
     Timers(18)=Texture'WOT.UI.T32_19'
     AllowMinimizedInterface=True
}
