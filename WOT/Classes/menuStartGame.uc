//=============================================================================
// menuStartGame.uc
// base class for "menuStartXXX" classes
//=============================================================================
class menuStartGame expands menuLong abstract;

var() localized string AccessNoneStr;
var() localized string AccessMasterStr;
var() localized string AccessUnrealSpyStr;

var() class<giWOT> GameClass;
var giWOT GameType;

//=============================================================================

function Destroyed()
{
	Super.Destroyed();
	if( GameType != Level.Game )
	{
		GameType.Destroy();
	}
}

//=============================================================================

function PostBeginPlay()
{
	Super.PostBeginPlay();
	if( Level.Game.Class == GameClass )
	{
		GameType = giWOT(Level.Game);
	}
	else
	{
		// create GameInfo object to enable editing of options
		GameType = Spawn( GameClass );
		// disable Timer() to avoid side effects due to the giEntry menu code
		GameType.Disable( 'Timer' );
	}
}

//=============================================================================

function SaveConfigs()
{
	SaveConfig();
	if( GameType != None )
		GameType.SaveConfig();
		if( GameType.GameReplicationInfo != None )
			GameType.GameReplicationInfo.SaveConfig();
	PlayerOwner.SaveConfig();
}

//=============================================================================

function DrawOptions( Canvas C )
{
	local int i;

	for( i=1; i<=MenuLength; i++ )
	{
		MenuList[i] = Default.MenuList[i];
	}

	DrawList( C, LC_Left );
}

//=============================================================================

function UpdateValues()
{
	// update MenuList[] values in subclass
}

//=============================================================================

function DrawValues( Canvas C )
{
	DrawList( C, LC_Right );
}

//=============================================================================

function DrawMenu( Canvas C )
{
	DrawOptions( C );
	
	UpdateValues();
	DrawValues( C );

	DrawHelpPanel( C );
}

// end of menuStartGame.uc

defaultproperties
{
     bLargeFont=False
}
