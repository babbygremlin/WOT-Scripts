//=============================================================================
// menuKeyboard.uc
//=============================================================================
class menuKeyboard expands menuLong;

var string MenuValues1[24];
var string MenuValues2[24];
var string AliasNames[24];
var string PendingCommands[30];
var int Pending;
var localized string OrString;
var bool bSetUp;

//=============================================================================

function SaveConfigs()
{
	ProcessPending();
}

//=============================================================================

function ProcessPending()
{
	local int i;

	for( i = 0; i < Pending; i++ )
	{
		PlayerOwner.ConsoleCommand( PendingCommands[i] );
	}
		
	Pending = 0;
}

//=============================================================================

function AddPending(string newCommand)
{
	PendingCommands[Pending] = newCommand;
	Pending++;
	if( Pending == 30 )
	{
		ProcessPending();
	}
}
	
//=============================================================================

function SetUpMenu()
{
	local int i, j, pos;
	local string KeyName;
	local string Alias;

	bSetup = true;

	for( i = 0; i < 255; i++ )
	{
		KeyName = PlayerOwner.ConsoleCommand( "KEYNAME "$i );
		if( KeyName != "" )
		{	
			Alias = PlayerOwner.ConsoleCommand( "KEYBINDING "$KeyName );
			if( Alias != "" )
			{
				pos = InStr(Alias, " " );
				if( pos != -1 )
				{
					Alias = Left(Alias, pos);
				}
				for( j = 1; j < 20; j++ )
				{
					if( AliasNames[j] == Alias )
					{
						if( MenuValues1[j] == "" )
						{
							MenuValues1[j] = KeyName;
						}
						else if( MenuValues2[j] == "" )
						{
							MenuValues2[j] = KeyName;
						}
					}
				}
			}
		}
	}
}

//=============================================================================

function ProcessMenuKey( int KeyNo, string KeyName )
{
	local int i;

	if( (KeyName == "") || (KeyName == "Escape")  
		|| ((KeyNo >= 0x70 ) && (KeyNo <= 0x79)) ) //function keys
	{
		return;
	}

	// make sure no overlapping
	for( i=1; i<20; i++ )
	{
		if( MenuValues2[i] == KeyName )
		{
			MenuValues2[i] = "";
		}
		if( MenuValues1[i] == KeyName )
		{
			MenuValues1[i] = MenuValues2[i];
			MenuValues2[i] = "";
		}
	}
	if( MenuValues1[Selection] != "_" )
	{
		MenuValues2[Selection] = MenuValues1[Selection];
	}
	else if( MenuValues2[Selection] == "_" )
	{
		MenuValues2[Selection] = "";
	}

	MenuValues1[Selection] = KeyName;
	AddPending( "SET Input "$KeyName$" "$AliasNames[Selection] );
}

//=============================================================================

function ProcessMenuEscape();

//=============================================================================

function ProcessMenuUpdate( coerce string InputString );

//=============================================================================

function bool ProcessSelection()
{
	local int i;

	if( Selection == MenuLength )
	{
		Pending = 0;
		PlayerOwner.ResetKeyboard();
		for( i = 0; i < MenuLength; i++ )
		{
			MenuValues1[i] = "";
			MenuValues2[i] = "";
		}
		SetupMenu();
		return true;
	}
	if( MenuValues2[Selection] != "" )
	{
		AddPending( "SET Input "$MenuValues2[Selection]$" ");
		AddPending( "SET Input "$MenuValues1[Selection]$" ");
		MenuValues1[Selection] = "_";
		MenuValues2[Selection] = "";
	}
	else
	{
		MenuValues2[Selection] = "_";
	}
		
	PlayerOwner.Player.Console.GotoState( 'KeyMenuing' );
	return true;
}

//=============================================================================

function DrawOptions( Canvas C )
{
	local int i;

	for( i=1; i<=MenuLength; i++ )
	{
		MenuList[i] = default.MenuList[i];
	}

	DrawList( C, LC_Left );
}

//=============================================================================

function DrawValues( Canvas C )
{
	local int i;

	for( i=0; i<MenuLength; i++ )
	{
		MenuList[i+1] = "";

		if( MenuValues1[i+1] != "" )
		{
//			SetFontBrightness( C, i == Selection - 1 );
//			C.SetPos( StartX, StartY + Spacing * i );
			if( MenuValues2[i+1] == "" )
			{
//				C.DrawText( MenuValues1[i + 1], false );
				MenuList[i+1]	= MenuValues1[i + 1];
			}
			else
			{
//				C.DrawText( MenuValues1[i + 1]$OrString$MenuValues2[i+1], false );
				MenuList[i+1]	= MenuValues1[i + 1]$OrString$MenuValues2[i+1];
			}
		}
//		C.DrawColor = C.Default.DrawColor;

		if( MenuList[i+1] == "" )
		{
			MenuList[i+1] = " ";
		}
	}

	DrawList( C, LC_Right );
}

//=============================================================================

function DrawMenu( Canvas C )
{
	if( !bSetup )
	{
		SetupMenu();
	}

	DrawOptions( C );

	DrawValues( C );
}

//=============================================================================

defaultproperties
{
     AliasNames(1)="Fire"
     AliasNames(2)="Jump"
     AliasNames(3)="MoveForward"
     AliasNames(4)="MoveBackward"
     AliasNames(5)="StrafeLeft"
     AliasNames(6)="StrafeRight"
     AliasNames(7)="TurnLeft"
     AliasNames(8)="TurnRight"
     AliasNames(9)="NextHand"
     AliasNames(10)="PrevHand"
     AliasNames(11)="Drop"
     AliasNames(12)="Look"
     AliasNames(13)="LookUp"
     AliasNames(14)="LookDown"
     AliasNames(15)="CenterView"
     AliasNames(16)="Walking"
     AliasNames(17)="Strafe"
     MenuTitleOffsetY=0
     bLargeFont=False
     MenuLength=18
}
