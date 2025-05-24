//=============================================================================
// BattleHUD.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 12 $
//=============================================================================
class BattleHUD expands MainHUD;

var int NumTeams;

var localized String SelectTeamStr;
var localized String TimeLimitStr;
var localized String SecondsStr;

simulated function PostRender( Canvas C )
{
	local WOTPlayer Player;
	local String SelectMessage;
	local float XL, YL;

	Super.PostRender( C );

	// render the header to show edit status
	Player = WOTPlayer(Owner);
	if( Player != None && !Player.bShowMenu && !IsWindowActive() && Player.PlayerReplicationInfo != None && Player.PlayerReplicationInfo.Team == 255 )
	{
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
		SelectMessage = SelectTeamStr $ " (1-" $ NumTeams $ ")";
		if( Player.JoinTeamTimeout > 0 )
		{
			SelectMessage = SelectMessage $ TimeLimitStr $ Player.JoinTeamTimeout $ SecondsStr;
		}
		C.StrLen( SelectMessage, XL, YL );
		LegendCanvas(C).DrawTextAt( ( C.SizeX - XL ) / 2, YL * 3, SelectMessage, font'WOT.F_WOTReg14', false ); // draw two lines above the Scoreboard header
	}
}

simulated function bool KeyEvent( int Key, int Action, FLOAT Delta )
{
	local WOTPlayer Player;
	local Console Console;
	local int Team;
	
	Player = WOTPlayer(Owner);
	if( Player != None )
	{
		Console = Player.Player.Console;
		if( Action == EInputAction.IST_Press && !Console.IsInState( 'Typing' ) && !Console.IsInState( 'MenuTyping' ) )
		{
			switch( Key )
			{
			case EInputKey.IK_1:
			case EInputKey.IK_2:
			case EInputKey.IK_3:
			case EInputKey.IK_4:
				if( Player.PlayerReplicationInfo.Team == 255 ) 
				{
					Team = Key - EInputKey.IK_1;
					if( Team < NumTeams )
					{
						Player.ServerChangeTeam( Team );
						Player.ServerRestartPlayer();
						return true;
					}
				}
			}
		}
	}

	return false;
}

defaultproperties
{
}
