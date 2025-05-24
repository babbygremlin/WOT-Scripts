//=============================================================================
// WOTBrowserServerPing: Query an Unreal server for its details
//=============================================================================
class WOTBrowserServerPing extends UBrowserServerPing;

var localized string	ArenaText;
var localized string	CitadelText;
var localized string	RemainingTimeText;
var localized string	ElapsedTimeText;
var localized string	PublicAccessText;
var localized string	NumCitadelsText;
var localized string	SealGoalText;
var localized string	HoldNewPlayersText;
var localized string	MaxTeamSizeText;
var localized string	RemainingEditTimeText;
var localized string	WinningTeamText;
var localized string	NoWinningTeamText;
var localized string	GameBegunText;
var localized string	GameBegunTrueText;
var localized string	GameBegunFalseText;

state GetStatus 
{
	event ReceivedText( IpAddr Addr, string Text )
	{
		local string Value;
		local string In;
		local string Out;
		local byte ID;
		local bool bOK;
		local UBrowserPlayerList PlayerEntry;

		ValidateServer();

		In = Text;
		do 
		{
			bOK = GetNextValue(In, Out, Value);
			In = Out;
			if(Left(Value, 7) == "player_")
			{
				ID = Int(Right(Value, Len(Value) - 7));

				PlayerEntry = Server.PlayerList.FindID(ID);
				if(PlayerEntry == None) 
					PlayerEntry = UBrowserPlayerList(Server.PlayerList.Append(class'UBrowserPlayerList'));
				PlayerEntry.PlayerID = ID;

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry.PlayerName = Value;
			} 
			else if(Left(Value, 6) == "frags_") 
			{
				ID = Int(Right(Value, Len(Value) - 6));

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry = Server.PlayerList.FindID(ID);
				PlayerEntry.PlayerFrags = Int(Value);
			}
			else if(Left(Value, 5) == "ping_")
			{
				ID = Int(Right(Value, Len(Value) - 5));

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry = Server.PlayerList.FindID(ID);
				PlayerEntry.PlayerPing = Int(Right(Value, len(Value) - 1));  // leading space
			}
			else if(Left(Value, 5) == "team_")
			{
				ID = Int(Right(Value, Len(Value) - 5));

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry = Server.PlayerList.FindID(ID);
				PlayerEntry.PlayerTeam = LocalizeTeam(Value);
			}
			else if(Left(Value, 5) == "skin_")
			{
				ID = Int(Right(Value, Len(Value) - 5));

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry = Server.PlayerList.FindID(ID);
				PlayerEntry.PlayerSkin = LocalizeSkin(Value);
			}
//#if 0 //NEW
//			else if(Left(Value, 5) == "face_")
//			{
//				ID = Int(Right(Value, Len(Value) - 5));
//
//				bOK = GetNextValue(In, Out, Value);
//				In = Out;
//				PlayerEntry = Server.PlayerList.FindID(ID);
//				PlayerEntry.PlayerFace = GetItemName(Value);
//			}
//#endif
			else if(Left(Value, 5) == "mesh_")
			{
				ID = Int(Right(Value, Len(Value) - 5));

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry = Server.PlayerList.FindID(ID);
				PlayerEntry.PlayerMesh = Value;
			}
			else if(Value == "final")
			{
				Server.StatusDone(True);
				return;
			}
			else if(Value ~= "gamever")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(GameVersionText, Value);
			}
//#if 0 //NEW
//			else if(Value ~= "minnetver")
//			{
//				bOK = GetNextValue(In, Out, Value);
//				AddRule(MinNetVersionText, Value);
//			}
//#endif
			else if(Value ~= "gametype")
			{
				bOK = GetNextValue(In, Out, Value);
				if( Value ~= "giMPArena" )
					Value = ArenaText;
				else if( Value ~= "giMPBattle" )
					Value = CitadelText;
				AddRule(GameTypeText, Value);
			}
/*			else if(Value ~= "gamemode") // "openplaying"
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(GameModeText, Value);
			}*/
			else if(Value ~= "timelimit") 
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(TimeLimitText, Value);
			}
			else if(Value ~= "remainingtime") 
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(RemainingTimeText, Value);
			}
			else if(Value ~= "elapsedtime") 
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(ElapsedTimeText, Value);
			}
			else if(Value ~= "fraglimit") 
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(FragLimitText, Value);
			}
			else if(Value ~= "publicaccess") 
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(PublicAccessText, LocalizeBoolValue(Value));
/* TBR
				if( WOTBrowserServerList(Server) != None )
				{
					WOTBrowserServerList(Server).SetPublicAccess( Value ~= LocalizeBoolValue("True") );
				}
*/
			}
//#if 0 //NEW
//			else if(Value ~= "MultiplayerBots") 
//			{
//				bOK = GetNextValue(In, Out, Value);
//				AddRule(MultiplayerBotsText, LocalizeBoolValue(Value));
//			}
//#endif
			else if(Value ~= "AdminName") 
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(AdminNameText, Value);
			}
			else if(Value ~= "AdminEMail")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(AdminEmailText, Value);
				// Log("#### "$Value$" unreal://"$Server.IP$":"$string(Server.GamePort)$" "$string(Server.NumPlayers)$" "$string(Server.MaxPlayers));
			}
//#if 0 //NEW
//			else if(Value ~= "WorldLog")
//			{
//				bOK = GetNextValue(In, Out, Value);
//				AddRule(WorldLogText, LocalizeBoolValue(Value));
//			}
//			else if(Value ~= "mutators")
//			{
//				bOK = GetNextValue(In, Out, Value);
//				AddRule(MutatorsText, Value);
//			}
//			else if(Value ~= "goalteamscore")
//			{
//				bOK = GetNextValue(In, Out, Value);
//				AddRule(GoalTeamScoreText, Value);		
//			}
//			else if(Value ~= "minplayers")
//			{
//				bOK = GetNextValue(In, Out, Value);
//				if(Value == "0")
//					AddRule(MultiplayerBotsText, FalseString);
//				else
//					AddRule(MinPlayersText, Value@PlayersText);		
//			}
//#endif
			else if(Value ~= "changelevels")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(ChangeLevelsText, LocalizeBoolValue(Value));		
			}
//#if 0 //NEW
//			else if(Value ~= "botskill")
//			{
//				bOK = GetNextValue(In, Out, Value);
//				AddRule(BotSkillText, Value);		
//			}
//#endif
			else if(Value ~= "maxteams")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(MaxTeamsText, Value);
			}
			else if(Value ~= "balanceteams")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(BalanceTeamsText, LocalizeBoolValue(Value));
			}
			else if(Value ~= "friendlyfire")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(FriendlyFireText, Value);
			}
			else if(Value ~= "numcitadels")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(NumCitadelsText, Value);
			}
			else if(Value ~= "sealgoal")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(SealGoalText, Value);
			}
			else if(Value ~= "holdnewplayers")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(HoldNewPlayersText, LocalizeBoolValue(Value));
			}
			else if(Value ~= "maxteamsize")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(MaxTeamSizeText, Value);
			}
//#if 0 //NEW
//			else if(Value ~= "remainingedittime")
//			{
//				bOK = GetNextValue(In, Out, Value);
//				AddRule(RemainingEditTimeText, Value);
//			}
//#endif
			else if(Value ~= "winningteam")
			{
				bOK = GetNextValue(In, Out, Value);
				if( LocalizeTeam(Value) != "" )
					AddRule(WinningTeamText, LocalizeTeam(Value));
				else
					AddRule(WinningTeamText, NoWinningTeamText);
			}
			else if(Value ~= "gamebegun")
			{
				bOK = GetNextValue(In, Out, Value);
				if( Value ~= "True" )
					AddRule(GameBegunText, GameBegunTrueText);
				else
					AddRule(GameBegunText, GameBegunFalseText);
			}

		} until(!bOK);
	}
}

/*
state GetInfo
{
	event ReceivedText(IpAddr Addr, string Text)
	{
		local string Temp;
		local int i;
		local int l;

		Disable('Tick');
	
		ValidateServer();
		Server.Ping = 1000*ElapsedTime;
		if(!Server.bKeepDescription)
			Server.HostName = Server.IP;
		Server.GamePort = 0;
		Server.MapName = "";
		Server.MapTitle = "";
		Server.MapDisplayName = "";
		Server.GameType = "";
		Server.GameMode = "";
		Server.NumPlayers = 0;
		Server.MaxPlayers = 0;
		Server.GameVer = 0;
		Server.MinNetVer = 0;

		l = Len(Text);

		i=InStr(Text, "\\hostname\\");
		if(i >= 0)
		{
			Temp = Right(Text, l - i - 10);
			if(!Server.bKeepDescription)
				Server.HostName = Left(Temp, InStr(Temp, "\\"));
		}
		else
		{
			// Invalid ping response
			Disable('Tick');

			Server.Ping = 9999;
			Server.SetInternalShown(False);
			Server.PingDone(bInitial, bJustThisServer, False, bNoSort);
			return;
		}

		i=InStr(Text, "\\hostport\\");
		if(i >= 0)
		{
			Temp = Right(Text, l - i - 10);
			Server.GamePort = Int(Left(Temp, InStr(Temp, "\\")));
		}

		i=InStr(Text, "\\mapname\\");
		if(i >= 0)
		{
			Temp = Right(Text, l - i - 9);
			Server.MapName = Left(Temp, InStr(Temp, "\\"));
		}
		
		i=InStr(Text, "\\maptitle\\");
		if(i >= 0)
		{
			Temp = Right(Text, l - i - 10);
			Server.MapTitle = Left(Temp, InStr(Temp, "\\"));
		}

		i=InStr(Text, "\\gametype\\");
		if(i >= 0)
		{
			Temp = Right(Text, l - i - 10);
			Server.GameType = Left(Temp, InStr(Temp, "\\"));
		}

		i=InStr(Text, "\\numplayers\\");
		if(i >= 0)
		{
			Temp = Right(Text, l - i - 12);
			Server.NumPlayers = Int(Left(Temp, InStr(Temp, "\\")));
		}

		i=InStr(Text, "\\maxplayers\\");
		if(i >= 0)
		{
			Temp = Right(Text, l - i - 12);
			Server.MaxPlayers = Int(Left(Temp, InStr(Temp, "\\")));
		}

		i=InStr(Text, "\\gamemode\\");
		if(i >= 0)
		{
			Temp = Right(Text, l - i - 10);
			Server.GameMode = Left(Temp, InStr(Temp, "\\"));
		}

		i=InStr(Text, "\\gamever\\");
		if(i >= 0)
		{
			Temp = Right(Text, l - i - 9);
			Server.GameVer = Int(Left(Temp, InStr(Temp, "\\")));
		}

		i=InStr(Text, "\\minnetver\\");
		if(i >= 0)
		{
			Temp = Right(Text, l - i - 11);
			Server.MinNetVer = Int(Left(Temp, InStr(Temp, "\\")));
		}
		
		Server.MapDisplayName = Server.MapTitle;
		if(Server.MapTitle == "" || Server.MapTitle ~= "Untitled")
			Server.MapDisplayName = Server.MapName;

		Server.DecodeCustomPingData(Text);

		Server.PingDone(bInitial, bJustThisServer, True, bNoSort);
	}
}
*/

defaultproperties
{
     ArenaText="Arena"
     CitadelText="Citadel"
     RemainingTimeText="Remaining Time"
     ElapsedTimeText="Elapsed Time"
     PublicAccessText="Public Access"
     NumCitadelsText="Num Citadels"
     SealGoalText="Seals to Win"
     HoldNewPlayersText="Hold New Players"
     MaxTeamSizeText="Maximum Team Size"
     RemainingEditTimeText="Remaining Edit Time"
     WinningTeamText="Winning Team"
     NoWinningTeamText="None"
     GameBegunText="Game Started"
     GameBegunTrueText="Yes"
     GameBegunFalseText="No"
}
