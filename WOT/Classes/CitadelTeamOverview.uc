//------------------------------------------------------------------------------
// CitadelTeamOverview.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 7 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
class CitadelTeamOverview expands ArenaScoreBoard;

// Display indices.
const INDEX_TEAM_NUMBER			= 0;
const INDEX_TEAM_DESCRIPTION	= 1;
const INDEX_NUM_PLAYERS			= 2;
const INDEX_EDIT_STATUS			= 3;

var localized string BeginBattleStr;

//////////////////////////
// Overridden functions //
//////////////////////////

//------------------------------------------------------------------------------
function Sort()
{
	// Nothing to sort.
}

//------------------------------------------------------------------------------
function InitPlayers()
{
	local int i;

	if( GetBattleInfo() ) PlayerCount = BattleInfo.NumTeams;
	
	for( i = 0; i < PlayerCount; i++ )
	{
		Players[i].bHightlight = (Pawn(Owner) != None && Pawn(Owner).PlayerReplicationInfo != None && Pawn(Owner).PlayerReplicationInfo.Team == i);
	}
}

//------------------------------------------------------------------------------
function ShowScores( canvas C )
{
	local int i;
	local bool bReady;
	local float XL, YL;
				
	// don't draw team selection/status while editing
	if( WOTPlayer(Owner) != None && WOTPlayer(Owner).bEditing )
	{
		return;
	}

	Super.ShowScores( C );

	// wait for replication before displaying anything
	if( PlayerCount > 0 )
	{
		// assess that the battle is pending acknowledgement from the players
		bReady = true;
		for( i = 0; i < PlayerCount; i++ )
		{
			if( BattleInfo.GetTeamStatus( i ) != class'BattleInfo'.default.ReadyStr )
			{
				bReady = false;
				break;
			}
		}
		if( bReady )
		{
			C.StrLen( BeginBattleStr, XL, YL );
			C.SetPos( ( C.SizeX - XL ) / 2, C.CurY );
			C.DrawText( BeginBattleStr );
		}
	}
}

//------------------------------------------------------------------------------
function DrawPlayerElements( int SlotNum, int XOffsets[6], out int YOffset )
{
	if( DisplayInfo[ INDEX_TEAM_NUMBER		].bEnabled ) DrawTeamNumber			( SlotNum, XOffsets[ INDEX_TEAM_NUMBER		], YOffset );
	if( DisplayInfo[ INDEX_TEAM_DESCRIPTION	].bEnabled ) DrawTeamDescription	( SlotNum, XOffsets[ INDEX_TEAM_DESCRIPTION	], YOffset );
	if( DisplayInfo[ INDEX_NUM_PLAYERS		].bEnabled ) DrawNumPlayers			( SlotNum, XOffsets[ INDEX_NUM_PLAYERS		], YOffset );
	if( DisplayInfo[ INDEX_EDIT_STATUS		].bEnabled ) DrawEditStatus			( SlotNum, XOffsets[ INDEX_EDIT_STATUS		], YOffset );
}

/////////////////////////////////
// Drawing component functions //
/////////////////////////////////

// Note: These assume Canvas is correctly set.

//------------------------------------------------------------------------------
function DrawTeamNumber( int SlotNum, int X, int Y )
{
	Canvas.SetPos( X, Y );
	Canvas.DrawText( (SlotNum+1)$")" );
}

//------------------------------------------------------------------------------
function DrawTeamDescription( int SlotNum, int X, int Y )
{
	local string TeamDescription;

	Canvas.SetPos( X, Y );
	if( GetBattleInfo() )
	{
		TeamDescription = BattleInfo.GetTeamDescription( SlotNum );
	}
	if( TeamDescription == "" )
	{
		TeamDescription = "Team #"$(SlotNum+1);
	}
	Canvas.DrawText( TeamDescription );
}

//------------------------------------------------------------------------------
function DrawNumPlayers( int SlotNum, int X, int Y )
{
	Canvas.SetPos( X, Y );
	if( GetBattleInfo() )
	{
		Canvas.DrawText( BattleInfo.NumPlayers[ SlotNum ]$" ("$BattleInfo.MaxTeamSize$")" );
	}
}

//------------------------------------------------------------------------------
function DrawEditStatus( int SlotNum, int X, int Y )
{
	Canvas.SetPos( X, Y );
	if( GetBattleInfo() )
	{
		Canvas.DrawText( BattleInfo.GetTeamStatus( SlotNum ) );
	}
}

defaultproperties
{
     BeginBattleStr="Press @Fire@ to begin play"
     DisplayInfo(1)=(Justification=JUSTIFY_LeftThird,Offset=16)
     DisplayInfo(2)=(Justification=JUSTIFY_Center,Offset=8)
     DisplayInfo(3)=(Justification=JUSTIFY_RightThird,Offset=0)
     DisplayInfo(4)=(bEnabled=False)
     DisplayInfo(5)=(bEnabled=False)
}
