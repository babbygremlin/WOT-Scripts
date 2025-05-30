//=============================================================================
// BattleScoreBoard.uc
//=============================================================================
class BattleScoreBoard expands ScoreBoard;

var string PlayerNames[16];
var string TeamNames[16];
var float Scores[16];
var byte Teams[16];
var int Pings[16];

function Swap( int L, int R )
{
	local string TempPlayerName, TempTeamName;
	local float TempScore;
	local byte TempTeam;
	local int TempPing;

	TempPlayerName = PlayerNames[L];
	TempTeamName = TeamNames[L];
	TempScore = Scores[L];
	TempTeam = Teams[L];
	TempPing = Pings[L];
	
	PlayerNames[L] = PlayerNames[R];
	TeamNames[L] = TeamNames[R];
	Scores[L] = Scores[R];
	Teams[L] = Teams[R];
	Pings[L] = Pings[R];
	
	PlayerNames[R] = TempPlayerName;
	TeamNames[R] = TempTeamName;
	Scores[R] = TempScore;
	Teams[R] = TempTeam;
	Pings[R] = TempPing;
}

function SortScores(int N)
{
	local int I, J, Max;
	
	for( I=0; I<N-1; I++ )
	{
		Max = I;
		for( J=I+1; J<N; J++ )
			if(Scores[J] > Scores[Max])
				Max = J;
		Swap( Max, I );
	}
}

function DrawHeader( canvas Canvas )
{
	local GameReplicationInfo GRI;
	local float XL, YL;

	if( Canvas.ClipX > 500 )
	{
		foreach AllActors( class'GameReplicationInfo', GRI )
		{
			Canvas.bCenter = true;

			Canvas.SetPos( 0, 32 );
			Canvas.StrLen("TEST", XL, YL );
			if( Level.Netmode != NM_StandAlone )
				Canvas.DrawText( GRI.ServerName );
			Canvas.SetPos(0.0, 32 + YL );
			Canvas.DrawText( "Game Type: "$GRI.GameName, true );
			Canvas.SetPos(0.0, 32 + 2*YL );
			Canvas.DrawText( "Map Title: "$Level.Title, true );
			Canvas.SetPos(0.0, 32 + 3*YL );
			Canvas.DrawText( "Author: "$Level.Author, true );
			Canvas.SetPos( 0.0, 32 + 4*YL );
			if(Level.IdealPlayerCount != "" )
				Canvas.DrawText( "Ideal Player Load:"$Level.IdealPlayerCount, true );

			Canvas.SetPos( 0, 32 + 6*YL );
			Canvas.DrawText( Level.LevelEnterText, true );

			Canvas.bCenter = false;
		}
	}
}

function DrawTrailer( canvas Canvas )
{
	local int Hours, Minutes, Seconds;
	local string HourString, MinuteString, SecondString;
	local float XL, YL;

	if( Canvas.ClipX > 500 )
	{
		Seconds = int(Level.TimeSeconds);
		Minutes = Seconds / 60;
		Hours   = Minutes / 60;
		Minutes = Minutes - (Hours * 60);
		Seconds = Seconds - (Minutes * 60);

		if( Seconds < 10 )
			SecondString = "0"$Seconds;
		else
			SecondString = string(Seconds);

		if( Minutes < 10 )
			MinuteString = "0"$Minutes;
		else
			MinuteString = string(Minutes);

		if( Hours < 10 )
			HourString = "0"$Hours;
		else
			HourString = string(Hours);

		Canvas.bCenter = true;
		Canvas.StrLen( "Test", XL, YL );
		Canvas.SetPos(0, Canvas.ClipY - YL );
		Canvas.DrawText( "Elapsed Time: "$HourString$":"$MinuteString$":"$SecondString, true );
		Canvas.bCenter = false;
	}
}

function DrawPing( canvas Canvas, int I, float XOffset, int LoopCount )
{
	local float XL, YL;

	if(Level.Netmode == NM_Standalone)
		return;

	Canvas.StrLen( Pings[I], XL, YL );
	Canvas.SetPos( Canvas.ClipX/4 - XL - 8, Canvas.ClipY/4 + (LoopCount * 16) );
	Canvas.SetFont( Font( DynamicLoadObject( "WOT.F_WOTReg08", class'Font' ) ) );
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.DrawText( Pings[I], false );
	Canvas.DrawColor.R = 0;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 0;
}

function DrawPlayerName( canvas Canvas, int I, float XOffset, int LoopCount )
{
	Canvas.SetPos( Canvas.ClipX/4, Canvas.ClipY/4 + (LoopCount * 16) );
	Canvas.DrawText( PlayerNames[I], false );
}

function DrawTeam( canvas Canvas, int I, float XOffset, int LoopCount )
{
	Canvas.SetPos( Canvas.ClipX*2/4, Canvas.ClipY/4 + (LoopCount * 16) );
	Canvas.DrawText( "Team"$Teams[I], false );
}

function DrawScore( canvas Canvas, int I, float XOffset, int LoopCount )
{
	Canvas.SetPos(Canvas.ClipX*3/4, Canvas.ClipY/4 + (LoopCount * 16));
	if(Scores[I] >= 100.0)
		Canvas.CurX -= 6.0;
	if(Scores[I] >= 10.0)
		Canvas.CurX -= 6.0;
	if(Scores[I] < 0.0)
		Canvas.CurX -= 6.0;
	Canvas.DrawText( int(Scores[I]), false );
}

function ShowScores( canvas Canvas )
{
	local PlayerReplicationInfo PRI;
	local int PlayerCount, LoopCount, I;
	local float XL, YL;

	Canvas.SetFont( Font( DynamicLoadObject( "WOT.F_WOTReg08", class'Font' ) ) );

	// Header
	DrawHeader( Canvas );

	// Trailer
	DrawTrailer( Canvas );

	Canvas.DrawColor.R = 0;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 0;

	// Wipe everything.
	for( I = 0; I < 16; I++ )
	{
		Scores[I] = -500;
	}
	foreach AllActors( class'PlayerReplicationInfo', PRI )
	{
		PlayerNames[PlayerCount] = PRI.PlayerName;
		TeamNames[PlayerCount] = PRI.TeamName;
		Scores[PlayerCount] = PRI.Score + PRI.Kills - PRI.Suicides; //PRI.Deaths 
		Teams[PlayerCount] = PRI.Team;
		Pings[PlayerCount] = PRI.Ping;

		PlayerCount++;
	}
	SortScores( PlayerCount );
	
	LoopCount = 0;
	for( I = 0; I < PlayerCount; I++ )
	{
		DrawPing( Canvas, I, 0, LoopCount );
		DrawPlayerName( Canvas, I, 0, LoopCount );
		DrawTeam( Canvas, I, 0, LoopCount );
		DrawScore( Canvas, I, 0, LoopCount );
		LoopCount++;
	}

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

// end of WOTScoreBoard.uc

defaultproperties
{
}
