//------------------------------------------------------------------------------
// ArenaScoreBoard.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 13 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
class ArenaScoreBoard expands ScoreBoard;

// NOTE[aleiby]: Factor out code common to all WOTScoreBoards, and make all Scoreboards
// expand that (including ArenaScoreBoard).

// Colors.
#exec TEXTURE	IMPORT FILE=Icons\Heads\HeadsBase.pcx		GROUP=ScoreBoard MIPS=Off Flags=2
#exec TEXTURE	IMPORT FILE=Icons\Heads\HeadsBlack.pcx	GROUP=ScoreBoard MIPS=Off Flags=2
#exec TEXTURE	IMPORT FILE=Icons\Heads\HeadsBlue.pcx		GROUP=ScoreBoard MIPS=Off Flags=2
#exec TEXTURE	IMPORT FILE=Icons\Heads\HeadsRed.pcx		GROUP=ScoreBoard MIPS=Off Flags=2
#exec TEXTURE	IMPORT FILE=Icons\Heads\HeadsGreen.pcx	GROUP=ScoreBoard MIPS=Off Flags=2

// Players.
#exec TEXTURE	IMPORT FILE=Icons\Heads\HeadsAesSedai.pcx	GROUP=ScoreBoard MIPS=Off Flags=2
#exec TEXTURE	IMPORT FILE=Icons\Heads\HeadsForsaken.pcx	GROUP=ScoreBoard MIPS=Off Flags=2
#exec TEXTURE	IMPORT FILE=Icons\Heads\HeadsWC.pcx		GROUP=ScoreBoard MIPS=Off Flags=2
#exec TEXTURE	IMPORT FILE=Icons\Heads\HeadsHound.pcx	GROUP=ScoreBoard MIPS=Off Flags=2

var() Texture ColorTextures[5];
var() Texture PlayerTextures[4];

// Tim, it would be nice to be able to index arrays using enums.
const SORT_END				= 0;
const SORT_NAME				= 1;
const SORT_PING				= 2;
const SORT_PACKET_LOSS		= 3;
const SORT_KILLS			= 4;
const SORT_DEATHS			= 5;
const SORT_SUICIDES			= 6;
const SORT_SCORE			= 7;
const SORT_TIME_ON_SERVER	= 8;
const SORT_COLOR			= 9;
const SORT_PLAYER_TYPE		= 10;

var config int SortOrder[10];	// History of sorting peference (OLD->NEW).

struct TPlayerInfo	// This should be an inner class (or component object) so it's easier to add/remove variables, etc.
{
	var string		Name;
	var int			Ping;
	var byte		PacketLoss;	// percentage
	var int			Kills;
	var int			Deaths;
	var int			Suicides;
	var int			Score;
	var int			TimeOnServer;
	var byte		Color;		// 0=Base, 1=Black, 2=Blue, 3=Red, 4=Green
	var byte		PlayerType;	// 0=AesSedai, 1=Forsaken, 2=Hound, 3=Whitecloak

	// Citadel variables.
	var byte		Team;
	var int			TeamSealCount;
	var int			TeamScore;

	var bool bHightlight;
};

var TPlayerInfo Players[16];

var canvas Canvas;
var GameReplicationInfo GRI;
var BattleInfo BattleInfo;
var int PlayerCount;

var() localized string ElapseText;
var() localized string RemainText;

var string VictoryMessage;

enum EJustification
{
	JUSTIFY_Left,
	JUSTIFY_Right,
	JUSTIFY_Center,
	JUSTIFY_LeftQuarter,
	JUSTIFY_RightQuarter,
	JUSTIFY_LeftThird,
	JUSTIFY_RightThird
};

struct TDisplayInfo
{
	var() EJustification	Justification;	// X relation to screen.
	var() int				Offset;			// Offset from justification mark.
	var() bool				bEnabled;		// Use this info?
};

// Display indices.
const INDEX_TIME_ON_SERVER	= 0;
const INDEX_ICON			= 1;
const INDEX_NAME			= 2;
const INDEX_NET_STATS		= 3;
const INDEX_STATS			= 4;
const INDEX_SCORE			= 5;

// If you change the size of either of the following arrays, make sure you do a 
// search for 6 (including this one), and change the ones that affected.
// (Tim, what ever happened to using consts for array definitions?!?)
var() TDisplayInfo DisplayInfo[6];			// Positions of text on screen.
var() localized string Description[6];	// localizing fields in structs doesn't work?

var() int SlotSpacing;				// Vertical spacing between rows.

var() byte DisplayBrightness;
     
//////////////////////////
// Master Draw function //
//////////////////////////

//------------------------------------------------------------------------------
/*final*/function ShowScores( canvas C )
{
	local int SlotNum, i;
	local int YOffset;
	local int XOffsets[6];
				
	Canvas = C;
	Canvas.SetFont( Font'WOT.F_WOTReg14' );

	DrawHeader();	
	InitPlayers();
	Sort();
	
	YOffset = Canvas.ClipY/4;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

	CalcXOffsets( XOffsets );
	DrawLegend( XOffsets, YOffset );

	for( i = 0; i < PlayerCount; i++ )
	{
		if( Players[i].bHightlight )
		{
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
		}
		else
		{
			Canvas.DrawColor.R = DisplayBrightness;
			Canvas.DrawColor.G = DisplayBrightness;
			Canvas.DrawColor.B = DisplayBrightness;
		}
		
		YOffset += SlotSpacing;
		DrawPlayerElements( i, XOffsets, YOffset );
	}

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

//------------------------------------------------------------------------------
// Override to have new/different elements drawn per player.
//------------------------------------------------------------------------------
function DrawPlayerElements( int SlotNum, int XOffsets[6], out int YOffset )
{
	if( DisplayInfo[ INDEX_TIME_ON_SERVER	].bEnabled ) DrawTimeOnServer	( SlotNum, XOffsets[ INDEX_TIME_ON_SERVER	], YOffset );
	if( DisplayInfo[ INDEX_ICON				].bEnabled ) DrawIcon			( SlotNum, XOffsets[ INDEX_ICON				], YOffset );
	if( DisplayInfo[ INDEX_NAME				].bEnabled ) DrawName			( SlotNum, XOffsets[ INDEX_NAME				], YOffset );
	if( DisplayInfo[ INDEX_NET_STATS		].bEnabled ) DrawNetStats		( SlotNum, XOffsets[ INDEX_NET_STATS		], YOffset );
	if( DisplayInfo[ INDEX_STATS			].bEnabled ) DrawStats			( SlotNum, XOffsets[ INDEX_STATS			], YOffset );
	if( DisplayInfo[ INDEX_SCORE			].bEnabled ) DrawScore			( SlotNum, XOffsets[ INDEX_SCORE			], YOffset );	
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
function float CalcScore( PlayerReplicationInfo PRI )
{
	// NOTE[aleiby]: Make class configurable so people can change the way score is calculated.  (i.e. class'giWOT' -> GameInfoClass)
	return class'giWOT'.static.CalcScore( PRI );
}

//------------------------------------------------------------------------------
final function CalcXOffsets( out int XOffsets[6] )
{
	local int i;
	
	for( i = 0; i < ArrayCount(DisplayInfo); i++ )
	{
		if( DisplayInfo[i].bEnabled )
		{
			XOffsets[i] = GetXOffset( DisplayInfo[i] );
		}
	}
}

//------------------------------------------------------------------------------
final function int GetXOffset( TDisplayInfo DI )
{
	local int XOffset;

	switch( DI.Justification )
	{
	case JUSTIFY_Left:			XOffset = 0;					break;
	case JUSTIFY_Right:			XOffset = Canvas.ClipX;			break;
	case JUSTIFY_Center:		XOffset = Canvas.ClipX/2;		break;
	case JUSTIFY_LeftQuarter:	XOffset = Canvas.ClipX/4;		break;
	case JUSTIFY_RightQuarter:	XOffset = Canvas.ClipX/4 * 3;	break;
	case JUSTIFY_LeftThird:		XOffset = Canvas.ClipX/3;		break;
	case JUSTIFY_RightThird:	XOffset = Canvas.ClipX/3 * 2;	break;
	default:
		warn( "Unhandled justification type." );
		break;
	}

	XOffset += DI.Offset;

	return XOffset;
}

//------------------------------------------------------------------------------
// Fills in Players array data.
//------------------------------------------------------------------------------
function InitPlayers()
{
	local PlayerReplicationInfo PRI;
	
	PlayerCount = 0;
	foreach AllActors( class'PlayerReplicationInfo', PRI )
	{
		if( !PRI.bIsNPC )
		{
			InitializePlayer( PRI, PlayerCount );
			PlayerCount++;
			if( PlayerCount >= ArrayCount(Players) )
				break;
		}
	}
}

//------------------------------------------------------------------------------
// Override this function to change/add data that is filled in.
//------------------------------------------------------------------------------
function InitializePlayer( PlayerReplicationInfo PRI, int Index )
{
	Players[ Index ].Name			= PRI.PlayerName;
	Players[ Index ].Ping			= PRI.Ping;
	Players[ Index ].PacketLoss		= PRI.PacketLoss;
	Players[ Index ].Kills			= PRI.Kills;
	Players[ Index ].Deaths			= PRI.Deaths;
	Players[ Index ].Suicides		= PRI.Suicides;
	Players[ Index ].Score			= CalcScore( PRI );
	Players[ Index ].TimeOnServer	= PRI.TimeOnServer;
	Players[ Index ].Color			= PRI.Color;
	Players[ Index ].PlayerType		= PRI.PlayerType;
	Players[ Index ].bHightlight	= (PlayerPawn(PRI.Owner)!=None && PlayerPawn(PRI.Owner).Player!=None);
}

//------------------------------------------------------------------------------
function bool GetBattleInfo()
{
	// Ensure we have a valid BattleInfo.
	if( BattleInfo == None )
		foreach AllActors( class'BattleInfo', BattleInfo )
			break;

	return (BattleInfo != None);
}

//------------------------------------------------------------------------------
function bool GetGRI()
{
	// Ensure we have a valid GameReplicationInfo.
	if( GRI == None )
		foreach AllActors( class'GameReplicationInfo', GRI )
			break;

	return (GRI != None);
}

/////////////////////////////////
// Drawing component functions //
/////////////////////////////////

// Note: These assume Canvas is correctly set.

//------------------------------------------------------------------------------
function DrawHeader()
{
	local int YLimit, Y;
	local float XL, YL;
	local int Seconds;
	local string DescriptionText;
	local string URL;

	Canvas.bCenter = true;

	// Get font dimensions.
	Canvas.SetPos( 0.0, 32 );
	Canvas.StrLen( "TEST", XL, YL );

	YLimit = Canvas.ClipY/4 - YL;

	Y = YL * 4; //CenterMessage offset + two lines of CenterMessage() text + one line for "Select Team" in Citadel game

	// Map name.
	if( Level.Title != "" && Y < YLimit )
	{
		Canvas.SetPos( 0.0, Y );
		Canvas.DrawText( Level.Title );
		Y += YL;
	}

	// NOTE[aleiby]: Frag limit?

	// Other stuff.
	DrawAdditionalHeaderElements( Y, YL, YLimit );

	// Remaining/Elapsed time.
	if( Y < YLimit )
	{
		if( !GetGRI() )
		{
			Seconds = int(Level.TimeSeconds);
			DescriptionText = ElapseText;
		}
		else if( GRI.bDisplayRemaining )
		{
			Seconds = int(FMax( GRI.RemainingTime, 0.0 ));
			DescriptionText = RemainText;
		}
		else
		{
			Seconds = int(GRI.ElapsedTime);
			DescriptionText = ElapseText;
		}

		Canvas.SetPos( 0.0, Y );
		Canvas.DrawText( DescriptionText$class'Util'.static.SecondsToTime( Seconds ) );
		Y += YL;
	}

/*
	// Server name.
	if( GetGRI() && GRI.ServerName != "" && Y < YLimit )
	{
		Canvas.SetPos( 0.0, Y );
		Canvas.DrawText( GRI.ServerName );
		Y += YL;
	}

	// Server description.
	if( Level.LevelEnterText != "" && Y < YLimit )
	{
		Canvas.SetPos( 0.0, Y );
		Canvas.DrawText( Level.LevelEnterText );
		Y += YL;
	}
*/

/*
	// Server IP Address.
	URL = Level.GetAddressURL();
	if( URL != "" && Y < YLimit )
	{
		Canvas.SetPos( 0.0, Y );
		Canvas.DrawText( URL );
		Y += YL;
	}
*/

	// Victory message.
	if( VictoryMessage != "" && Y < YLimit )
	{
		Canvas.SetPos( 0.0, Y );
		Canvas.DrawText( VictoryMessage );
		Y += YL;
	}

	Canvas.bCenter = false;
}

//------------------------------------------------------------------------------
function DrawAdditionalHeaderElements( out int YOffset, int YSpacing, int YLimit )
{
	// Override in subclasses.
}

//------------------------------------------------------------------------------
function DrawLegend( int XOffsets[6], out int YOffset )
{
	local int i;
	
	for( i = 0; i < ArrayCount(DisplayInfo); i++ )
	{
		if( DisplayInfo[i].bEnabled )
		{
			Canvas.SetPos( XOffsets[i], YOffset );
			Canvas.DrawText( Description[i] );
		}
	}
}

//------------------------------------------------------------------------------
function DrawTimeOnServer( int SlotNum, int X, int Y )
{
	Canvas.SetPos( X, Y );
	Canvas.DrawText( class'Util'.static.SecondsToTime( Players[ SlotNum ].TimeOnServer, true ) );
}

//------------------------------------------------------------------------------
function DrawIcon( int SlotNum, int X, int Y )
{
	local float XL, YL, YOffset;

	// Get font dimensions.
	Canvas.StrLen( "TEST", XL, YL );
	YOffset = 16 /*Icon height*/ - YL;
	
	Canvas.SetPos( X, Y - YOffset );
	Canvas.DrawIcon( ColorTextures[ Players[ SlotNum ].Color ], 1.0 );
	
	Canvas.Style = ERenderStyle.STY_Masked;
	
	Canvas.SetPos( X, Y - YOffset );
	Canvas.DrawIcon( PlayerTextures[ Players[ SlotNum ].PlayerType ], 1.0 );
	
	Canvas.Style = ERenderStyle.STY_Normal;
}

//------------------------------------------------------------------------------
function DrawName( int SlotNum, int X, int Y )
{
	Canvas.SetPos( X, Y );
	Canvas.DrawText( Players[ SlotNum ].Name );
}

//------------------------------------------------------------------------------
function DrawNetStats( int SlotNum, int X, int Y )
{
	if( Level.Netmode == NM_Standalone )
		return;

	Canvas.SetPos( X, Y );
	Canvas.DrawText( "("$Players[ SlotNum ].Ping$"/"$Players[ SlotNum ].PacketLoss$")" );
}

//------------------------------------------------------------------------------
// Kills, Deaths, Suicides.
//------------------------------------------------------------------------------
function DrawStats( int SlotNum, int X, int Y )
{
	Canvas.SetPos( X, Y );
	Canvas.DrawText( Players[ SlotNum ].Kills$"/"$Players[ SlotNum ].Deaths$"/"$Players[ SlotNum ].Suicides );
}

//------------------------------------------------------------------------------
function DrawScore( int SlotNum, int X, int Y )
{
	local float XL, YL;

	// Get font dimensions.
	Canvas.StrLen( Players[ SlotNum ].Score, XL, YL );
	
	Canvas.SetPos( X - XL + 24, Y );
	Canvas.DrawText( Players[ SlotNum ].Score );
}

///////////////////////
// Sorting functions //
///////////////////////

//------------------------------------------------------------------------------
// Add a new sorting filter to the stack.
// Negate SortType to sort in reverse order (i.e. -1 means to sort by names in
// reverse alphabetical order).
//------------------------------------------------------------------------------
function SortBy( int SortType )
{
	local int i;
	local int n;

	// Remove occurances of SortType currently in SortOrder.
	i = 0;
	n = 0;
	while( n < ArrayCount(SortOrder) )
	{
		if( Abs(SortOrder[n]) == Abs(SortType) )
		{
			n++;
		}

		SortOrder[i] = SortOrder[n];

		i++;
		n++;
	}

	// If there is room left in the array.
	if( i < ArrayCount(SortOrder) )
	{
		// Use the next open slot.
		SortOrder[i] = SortType;
		i++;

		// Clear out remaining slots.
		while( i < ArrayCount(SortOrder) )
		{
			SortOrder[i] = SORT_END;
			i++;
		}
	}
	else	// Note: This should never happen as long as there are at least as many slots in the array as there are SortTypes.
	{
		// Make room by shifting all elements to the left...
		for( i = 1; i < ArrayCount(SortOrder); i++ )
		{
			SortOrder[i-1] = SortOrder[i];
		}

		// and adding it to the end.
		SortOrder[ ArrayCount(SortOrder) - 1 ] = SortType;
	}
}

//------------------------------------------------------------------------------
function Sort()
{
	local int i;

	for( i = 0; i < ArrayCount(SortOrder) && SortOrder[i] != SORT_END; i++ )
	{
		SortUsing( SortOrder[i] );
	}
}

//////////////////////////////
// Sorting helper functions //
//////////////////////////////

//------------------------------------------------------------------------------
// Note: This assumes PlayerCount has already been correctly set.
//------------------------------------------------------------------------------
function SortUsing( int SortType )
{
	local int i, j;
	
	for( i = 0; i < PlayerCount-1; i++ )
		for( j = PlayerCount-1; j > i; j-- )
			if( IsGreater( j, j-1, SortType ) )
				Swap( j, j-1 );
}

//------------------------------------------------------------------------------
// Returns true if Players[A] is greater than Players[B] 
// using SortType as the critera.
//------------------------------------------------------------------------------
function bool IsGreater( int A, int B, int SortType )
{
	local bool bIsGreater;

	// Idiot check.
	if( A == B )
		return false;

	// Note: This could be easily collapsed using Interfaces and InnerClasses to define
	// different comparison operators.
	switch( Abs(SortType) )
	{
	case SORT_NAME:				bIsGreater = NameIsGreater			( A, B, (SortType < 0) ); break;
	case SORT_PING:				bIsGreater = PingIsGreater			( A, B, (SortType < 0) ); break;
	case SORT_PACKET_LOSS:		bIsGreater = PacketLossIsGreater	( A, B, (SortType < 0) ); break;
	case SORT_KILLS:			bIsGreater = KillsAreGreater		( A, B, (SortType < 0) ); break;
	case SORT_DEATHS:			bIsGreater = DeathsAreGreater		( A, B, (SortType < 0) ); break;
	case SORT_SUICIDES:			bIsGreater = SuicidesAreGreater		( A, B, (SortType < 0) ); break;
	case SORT_SCORE:			bIsGreater = ScoreIsGreater			( A, B, (SortType < 0) ); break;
	case SORT_TIME_ON_SERVER:	bIsGreater = TimeOnServerIsGreater	( A, B, (SortType < 0) ); break;
	case SORT_COLOR:			bIsGreater = ColorIsGreater			( A, B, (SortType < 0) ); break;
	case SORT_PLAYER_TYPE:		bIsGreater = PlayerTypeIsGreater	( A, B, (SortType < 0) ); break;
	default:					bIsGreater = HandleSortTypeException( A, B,  SortType      ); break;
	}

	return bIsGreater;
}

//------------------------------------------------------------------------------
// Override in subclasses to handle exceptions.
//------------------------------------------------------------------------------
function bool HandleSortTypeException( int A, int B, int SortType )
{
	warn( "Unhandled SortType." );
	return false;
}

//------------------------------------------------------------------------------
function bool NameIsGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].Name < Players[B].Name);
	else
		return (Players[A].Name > Players[B].Name);
}

//------------------------------------------------------------------------------
function bool PingIsGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].Ping < Players[B].Ping);
	else
		return (Players[A].Ping > Players[B].Ping);
}

//------------------------------------------------------------------------------
function bool PacketLossIsGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].PacketLoss < Players[B].PacketLoss);
	else
		return (Players[A].PacketLoss > Players[B].PacketLoss);
}

//------------------------------------------------------------------------------
function bool KillsAreGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].Kills < Players[B].Kills);
	else
		return (Players[A].Kills > Players[B].Kills);
}

//------------------------------------------------------------------------------
function bool DeathsAreGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].Deaths < Players[B].Deaths);
	else
		return (Players[A].Deaths > Players[B].Deaths);
}

//------------------------------------------------------------------------------
function bool SuicidesAreGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].Suicides < Players[B].Suicides);
	else
		return (Players[A].Suicides > Players[B].Suicides);
}

//------------------------------------------------------------------------------
function bool ScoreIsGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].Score < Players[B].Score);
	else
		return (Players[A].Score > Players[B].Score);
}

//------------------------------------------------------------------------------
// Closest minute.
//------------------------------------------------------------------------------
function bool TimeOnServerIsGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].TimeOnServer/60 < Players[B].TimeOnServer/60);
	else
		return (Players[A].TimeOnServer/60 > Players[B].TimeOnServer/60);
}

//------------------------------------------------------------------------------
function bool ColorIsGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].Color < Players[B].Color);
	else
		return (Players[A].Color > Players[B].Color);
}

//------------------------------------------------------------------------------
function bool PlayerTypeIsGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].PlayerType < Players[B].PlayerType);
	else
		return (Players[A].PlayerType > Players[B].PlayerType);
}

//------------------------------------------------------------------------------
// Having an intrinsic struct copier function would be nice.
//
// NOTE[aleiby]: Is moving all this data around really necessary?  Why not just
// maintain a secondary list of indices, and rearrange those?
//------------------------------------------------------------------------------
function Swap( int A, int B )
{
	local TPlayerInfo Temp;

	// Idiot check.
	if( A == B )
		return;

	Temp.Name				= Players[A].Name;
	Temp.Ping				= Players[A].Ping;
	Temp.PacketLoss			= Players[A].PacketLoss;
	Temp.Kills				= Players[A].Kills;
	Temp.Deaths				= Players[A].Deaths;
	Temp.Suicides			= Players[A].Suicides;
	Temp.Score				= Players[A].Score;
	Temp.TimeOnServer		= Players[A].TimeOnServer;
	Temp.Color				= Players[A].Color;
	Temp.PlayerType			= Players[A].PlayerType;
	Temp.bHightlight		= Players[A].bHightlight;

	Players[A].Name			= Players[B].Name;
	Players[A].Ping			= Players[B].Ping;
	Players[A].PacketLoss	= Players[B].PacketLoss;
	Players[A].Kills		= Players[B].Kills;
	Players[A].Deaths		= Players[B].Deaths;
	Players[A].Suicides		= Players[B].Suicides;
	Players[A].Score		= Players[B].Score;
	Players[A].TimeOnServer	= Players[B].TimeOnServer;
	Players[A].Color		= Players[B].Color;
	Players[A].PlayerType	= Players[B].PlayerType;
	Players[A].bHightlight	= Players[B].bHightlight;

	Players[B].Name			= Temp.Name;
	Players[B].Ping			= Temp.Ping;
	Players[B].PacketLoss	= Temp.PacketLoss;
	Players[B].Kills		= Temp.Kills;
	Players[B].Deaths		= Temp.Deaths;
	Players[B].Suicides		= Temp.Suicides;
	Players[B].Score		= Temp.Score;
	Players[B].TimeOnServer	= Temp.TimeOnServer;
	Players[B].Color		= Temp.Color;
	Players[B].PlayerType	= Temp.PlayerType;
	Players[B].bHightlight	= Temp.bHightlight;
}

defaultproperties
{
     ColorTextures(0)=Texture'WOT.ScoreBoard.HeadsBase'
     ColorTextures(1)=Texture'WOT.ScoreBoard.HeadsBlack'
     ColorTextures(2)=Texture'WOT.ScoreBoard.HeadsBlue'
     ColorTextures(3)=Texture'WOT.ScoreBoard.HeadsRed'
     ColorTextures(4)=Texture'WOT.ScoreBoard.HeadsGreen'
     PlayerTextures(0)=Texture'WOT.ScoreBoard.HeadsAesSedai'
     PlayerTextures(1)=Texture'WOT.ScoreBoard.HeadsForsaken'
     PlayerTextures(2)=Texture'WOT.ScoreBoard.HeadsHound'
     PlayerTextures(3)=Texture'WOT.ScoreBoard.HeadsWC'
     SortOrder(0)=2
     SortOrder(1)=3
     SortOrder(2)=-8
     SortOrder(3)=7
     ElapseText="Elapsed Time: "
     RemainText="Remaining Time: "
     DisplayInfo(0)=(Justification=JUSTIFY_LeftThird,bEnabled=True)
     DisplayInfo(1)=(Justification=JUSTIFY_LeftQuarter,Offset=-72,bEnabled=True)
     DisplayInfo(2)=(Justification=JUSTIFY_LeftQuarter,Offset=-48,bEnabled=True)
     DisplayInfo(3)=(Justification=JUSTIFY_Center,Offset=-48,bEnabled=True)
     DisplayInfo(4)=(Justification=JUSTIFY_RightThird,Offset=-56,bEnabled=True)
     DisplayInfo(5)=(Justification=JUSTIFY_RightQuarter,Offset=32,bEnabled=True)
     SlotSpacing=20
     DisplayBrightness=120
}
