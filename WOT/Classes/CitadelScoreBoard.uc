//------------------------------------------------------------------------------
// CitadelScoreBoard.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 6 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
class CitadelScoreBoard expands ArenaScoreBoard;

const SORT_TEAM				= 11;
const SORT_TEAM_SEAL_COUNT	= 12;
const SORT_TEAM_SCORE		= 13;

var byte PrevTeam;	// Team of last player drawn via DrawPlayerElements.

var() localized string NumSealsText;
var() localized string VictoryText;

//------------------------------------------------------------------------------
function DrawPlayerElements( int SlotNum, int XOffsets[6], out int YOffset )
{
	local byte NextTeam;

	NextTeam = Players[ SlotNum ].Team;

	if( SlotNum == 0 && (GetGRI() && Players[ SlotNum ].TeamSealCount >= CitadelGameReplicationInfo(GRI).SealGoal) )
	{
		VictoryMessage = "[[ "$VictoryText$" "$GetTeamDescription( Players[ SlotNum ].Team )$" ]]";
	}
	else
	{
		VictoryMessage = "";
	}

	// Draw team seperator.
	if( NextTeam != PrevTeam )
	{
		DrawTeamHeader( NextTeam, XOffsets, YOffset );
	}

	PrevTeam = Players[ SlotNum ].Team;
	
	Super.DrawPlayerElements( SlotNum, XOffsets, YOffset );
}

//------------------------------------------------------------------------------
function DrawTeamHeader( byte Team, int XOffsets[6], out int YOffset )
{
	local byte R, G, B;
	local float XL, YL;
	
	R = Canvas.DrawColor.R;
	G = Canvas.DrawColor.G;
	B = Canvas.DrawColor.B;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

	Canvas.StrLen( " ", XL, YL );

	// Space.
	YOffset += YL;
		
	Canvas.bCenter = true;
	Canvas.SetPos( 0.0, YOffset );

	if( Team != 255 )
	{
		Canvas.DrawText( GetTeamDescription( Team )$"    Seals: "$GetTeamSealCount( Team )$"    Score: "$CalcTeamScore( Team ) );
	}
	YOffset += YL;
	Canvas.bCenter = false;

	// Space.
	YOffset += YL;

	Super.DrawLegend( XOffsets, YOffset );
	YOffset += YL;

	Canvas.DrawColor.R = R;
	Canvas.DrawColor.G = G;
	Canvas.DrawColor.B = B;
}

//------------------------------------------------------------------------------
function string GetTeamDescription( byte Team )
{
	local string TeamDescription;
	
	if( GetBattleInfo() )
	{
		TeamDescription = BattleInfo.GetTeamDescription( Team );
	}
	if( TeamDescription == "" )
	{
		TeamDescription = "Team #"$(Team+1);
	}
	
	return TeamDescription;
}

//------------------------------------------------------------------------------
function DrawLegend( int XOffsets[6], out int YOffset )
{
	// Don't draw legend yet.
	YOffset -= SlotSpacing*2;
}

//------------------------------------------------------------------------------
function InitPlayers()
{
	PrevTeam = 255;	// Reset to neutral.
	Super.InitPlayers();
}

//------------------------------------------------------------------------------
function InitializePlayer( PlayerReplicationInfo PRI, int Index )
{
	Super.InitializePlayer( PRI, Index );

	Players[ Index ].Team			= PRI.Team;
	Players[ Index ].TeamSealCount	= GetTeamSealCount( PRI.Team );
	Players[ Index ].TeamScore		= CalcTeamScore( PRI.Team );
}

//------------------------------------------------------------------------------
function int CalcTeamScore( byte Team )
{
	return GetTeamSealCount( Team ) * 10;
}

//------------------------------------------------------------------------------
function int GetTeamSealCount( byte Team )
{
	if( GetBattleInfo() )	return BattleInfo.GetTeamSealCount( Team );
	else					return -1;
}

//------------------------------------------------------------------------------
function bool HandleSortTypeException( int A, int B, int SortType )
{
	local bool bIsGreater;

	switch( Abs(SortType) )
	{
	case SORT_TEAM:				bIsGreater = TeamIsGreater					( A, B, (SortType < 0) ); break;
	case SORT_TEAM_SEAL_COUNT:	bIsGreater = TeamSealCountIsGreater			( A, B, (SortType < 0) ); break;
	case SORT_TEAM_SCORE:		bIsGreater = TeamScoreIsGreater				( A, B, (SortType < 0) ); break;
	default:					bIsGreater = Super.HandleSortTypeException	( A, B,  SortType      ); break;
	}

	return bIsGreater;
}

//------------------------------------------------------------------------------
function bool TeamIsGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].Team < Players[B].Team);
	else
		return (Players[A].Team > Players[B].Team);
}

//------------------------------------------------------------------------------
function bool TeamSealCountIsGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].TeamSealCount < Players[B].TeamSealCount);
	else
		return (Players[A].TeamSealCount > Players[B].TeamSealCount);
}

//------------------------------------------------------------------------------
function bool TeamScoreIsGreater( int A, int B, optional bool bLessThan )
{
	if( bLessThan )
		return (Players[A].TeamScore < Players[B].TeamScore);
	else
		return (Players[A].TeamScore > Players[B].TeamScore);
}

//------------------------------------------------------------------------------
function DrawAdditionalHeaderElements( out int YOffset, int YSpacing, int YLimit )
{
	local int NumSeals;

	// Draw number of seals to win.
	if( YOffset < YLimit )
	{
		Canvas.SetPos( 0.0, YOffset );
		if( CitadelGameReplicationInfo(GRI) != None )
		{
			NumSeals = CitadelGameReplicationInfo(GRI).SealGoal;
		}
		Canvas.DrawText( NumSealsText$": "$NumSeals );

		YOffset += YSpacing;
	}
}

//------------------------------------------------------------------------------
function Swap( int A, int B )
{
	local TPlayerInfo Temp;

	Super.Swap( A, B );

	Temp.Team					= Players[A].Team;
	Temp.TeamSealCount			= Players[A].TeamSealCount;
	Temp.TeamScore				= Players[A].TeamScore;
	
	Players[A].Team				= Players[B].Team;
	Players[A].TeamSealCount	= Players[B].TeamSealCount;
	Players[A].TeamScore		= Players[B].TeamScore;
	
	Players[B].Team				= Temp.Team;
	Players[B].TeamSealCount	= Temp.TeamSealCount;
	Players[B].TeamScore		= Temp.TeamScore;
}

defaultproperties
{
     SortOrder(4)=11
     SortOrder(5)=13
     SlotSpacing=14
}
