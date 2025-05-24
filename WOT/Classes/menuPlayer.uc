//=============================================================================
// menuPlayer.uc
//=============================================================================
class menuPlayer expands menuShort
	config(user);

// PLAYER CONFIG
//
// Name			<Text>
// Class		[ AesSedai | Forsaken | Hound | Whitecloak ]
// Color		[ any skin from corresponding .utx file ]
// NetSpeed		[ Modem | ISDN | T1 ]

const MenuOffsetLeftX	=   0;	// X offset of column 1 from center
const MenuOffsetRightX	= 120;	// X offset of column 2 from center
const MenuOffsetY		= -80;	// Y offset of top of list from center
const MenuSpacingY		=  20;	// space between rows

var() float AnimSequenceRate;			// rate at which AnimSequence loops
var() float DrawScaleBase;				// base DrawScale for drawing model

var localized string InternetOption;
var localized string FastInternetOption;
var localized string LANOption;

var localized string CitadelSkinStr;
var string ClassStrings[4];

var string PlayerNameStr;				// saved in DefaultPlayer Name property
var string PlayerClassStr; 				// saved in menuPlayer properties in user.ini
var string PlayerSkinStr;				// saved in menuPlayer properties in user.ini

var bool bSetup;
var bool bCitadelGame;
var bool bSavedBehindView;
var Actor RealOwner;
var class<PlayerPawn> PlayerClass;

//=============================================================================
// Match the current PlayerClassStr with the entries in ClassStrings (if possible)
// then select the class which is offset from that entry by Dir units (wrapped
// to 0..N-1). Then make sure that the current skin is valid for the current 
// class.

function FindClass( int Dir )
{
	local int i, n;
	local int NumClassStrings;

	NumClassStrings = ArrayCount(ClassStrings);

	// find the matching string (or default to 0)
	for( i=0; i<NumClassStrings; i++ )
	{
		if( PlayerClassStr == ClassStrings[i] )
		{
			n = i;
			break;
		}
	}

	// allow class selection to wrap to be consistent with skin selection
	n = n+Dir;
	if( n < 0 )
	{
		n = NumClassStrings - 1;
	}
	else if( n >= NumClassStrings )
	{
		n = 0;
	}
	
	// update the player class
	PlayerClassStr = ClassStrings[n];

	// update the current mesh
	PlayerClass = class<PlayerPawn>( DynamicLoadObject( PlayerClassStr, class'Class' ) );
	Mesh = PlayerClass.default.Mesh;

	// make sure the current skin is valid
	FindSkin( 0 );

	DrawScale = DrawScaleBase*PlayerClass.default.DrawScale;
	LoopAnim( AnimSequence, AnimSequenceRate );
}

//=============================================================================

function bool SetSkin( string SkinName )
{
	local int i;
	local texture NewSkin;

	NewSkin = texture( DynamicLoadObject(SkinName, class'Texture', true) );

	if ( NewSkin != None )
	{
		PlayerSkinStr = SkinName;
		Skin = NewSkin;
		for( i = 0; i < ArrayCount(MultiSkins); i++ )
		{
			MultiSkins[i] = NewSkin;
		}
		return true;
	}

	return false;
}

//=============================================================================

function SetDefaultSkinForMesh( string MeshName )
{
	if( !SetSkin( "WOTPawns."$Left(MeshName, 3)$"_Base" ) )
	{
		warn( Self$ "SetDefaultSkinForMesh: error setting default skin!" );
	}
}

//=============================================================================
// First make sure the current PlayerSkinStr is valid for the current class (mesh).
// If not (class changed), set the current skin to the default for the class,
// otherwise, pick the next/previous/current skin depending on the value of Dir.
//
// Assumes one skin per PC, possibly mapped to multiple texture maps (stored in
// MultiSkins[i]).

function FindSkin( int Dir )
{
	local string SkinName;
	local string MeshName;
	local int DotPos;
	local string SkinDesc;

	MeshName = GetItemName( String(Mesh) );
	SkinName = PlayerSkinStr;

	if ( !(Left(SkinName, Len(MeshName)) ~= MeshName) )
	{
		// Skin package is wrong so swap it. If this fails (e.g
		// because no such skin for that class) will end up
		// using the base skin below..

		// strip package name, if any
		SkinName = GetItemName( SkinName );

		// replace XXX_ prefix with XXX_ from MeshName
		SkinName = Left(MeshName, 3)$Mid(SkinName, 3);
	}
	else
	{
		// strip package name, if any
		SkinName = GetItemName( SkinName );
	}

	// GetNextSkin "magically" scans the .utx file for skins
	GetNextSkin( MeshName, MeshName$"Skins."$SkinName, Dir, SkinName, SkinDesc );

	if ( SkinName != "" )
	{
		if( !SetSkin( SkinName ) )
		{
			SetDefaultSkinForMesh( MeshName );
		}		
	}
	else
	{
		SetDefaultSkinForMesh( MeshName );
	}
}

//=============================================================================

function ProcessMenuInput( coerce string InputString )
{
	InputString = Left(InputString, 20);

	if( Selection == 1 )
	{
		if( InputString != "" && InputString != "_" )
		{
			PlayerNameStr = InputString;
			PlayerOwner.UpdateURL( "Name",  PlayerNameStr,  true );
		}
	}
}

//=============================================================================

function ProcessMenuEscape()
{
	PlayerNameStr = PlayerOwner.GetDefaultURL( "Name" );
}

//=============================================================================

function ProcessMenuUpdate( coerce string InputString )
{
	InputString = Left(InputString, 20);

	if( Selection == 1 )
	{
		PlayerNameStr = InputString$"_";
	}
}

//=============================================================================

function Menu ExitMenu()
{
	SetOwner( RealOwner );
	PlayerOwner.bBehindView = bSavedBehindView;
	Super.ExitMenu();
}

//=============================================================================

function bool ProcessLeft()
{
	local int NewSpeed;

	if( Selection == 1 )
	{
		PlayerNameStr = "_";
		PlayerOwner.Player.Console.GotoState( 'MenuTyping' );
	}
	else if( Selection == 2 && !ClassChangeDisabled() )
	{
		FindClass( -1 );
	}
	else if( Selection == 3 && !SkinChangeDisabled() )
	{
		FindSkin( -1 );
	}
	else if( Selection == 4 )
	{
		if( class'Player'.default.ConfiguredInternetSpeed <= 3000 )
			NewSpeed = 20000;
		else if( class'Player'.default.ConfiguredInternetSpeed < 12500 )
			NewSpeed = 2600;
		else
			NewSpeed = 5000;

		PlayerOwner.ConsoleCommand( "NETSPEED "$NewSpeed );
	}

	return true;
}

//=============================================================================

function bool ProcessRight()
{
	local int NewSpeed;

	if( Selection == 1 )
	{
		PlayerNameStr = "_";
		PlayerOwner.Player.Console.GotoState( 'MenuTyping' );
	}
	else if( Selection == 2 && !ClassChangeDisabled() )
	{
		FindClass( 1 );
	}
	else if( Selection == 3 && !SkinChangeDisabled() )
	{
		FindSkin( 1 );
	}
	else if( Selection == 4 )
	{
		if( class'Player'.default.ConfiguredInternetSpeed <= 3000 )
			NewSpeed = 5000;
		else if( class'Player'.default.ConfiguredInternetSpeed < 12500 )
			NewSpeed = 20000;
		else
			NewSpeed = 2600;

		PlayerOwner.ConsoleCommand( "NETSPEED "$NewSpeed );
	}

	return true;
}

//=============================================================================

function bool ProcessSelection()
{
	if( Selection == 1 )
	{
		PlayerNameStr = "_";
		PlayerOwner.Player.Console.GotoState( 'MenuTyping' );
	}

	return true;
}

//=============================================================================

function MenuProcessInput( byte KeyNum, byte ActionNum )
{
	Super.MenuProcessInput( KeyNum, ActionNum );
}

//=============================================================================

function bool ClassChangeDisabled()
{
	return (Level.Netmode != NM_Standalone);
}

//=============================================================================

function bool SkinChangeDisabled()
{
	return false;
}

//=============================================================================

function DrawOptions( Canvas C )
{
	local int PosX, PosY;
		
	PosX = C.SizeX/2 + LegendCanvas(C).ScaleValX(MenuOffsetLeftX);
	PosY = C.SizeY/2 + LegendCanvas(C).ScaleValY(MenuOffsetY);

	DrawMenuEntry( C, PosX, PosY+0*LegendCanvas(C).ScaleValY(MenuSpacingY), MenuList[1], 1 );
	DrawMenuEntry( C, PosX, PosY+1*LegendCanvas(C).ScaleValY(MenuSpacingY), MenuList[2], 2 );
	if( bCitadelGame )
	{
		DrawMenuEntry( C, PosX, PosY+2*LegendCanvas(C).ScaleValY(MenuSpacingY), CitadelSkinStr, 3 );
	}
	else
	{
		DrawMenuEntry( C, PosX, PosY+2*LegendCanvas(C).ScaleValY(MenuSpacingY), MenuList[3], 3 );
	}
	DrawMenuEntry( C, PosX, PosY+3*LegendCanvas(C).ScaleValY(MenuSpacingY), MenuList[4], 4 );
}

//=============================================================================

function DrawValues( Canvas C )
{
	local int PosX, PosY;
	local string DisplayedSkinName;
			
	PosX = C.SizeX/2 + LegendCanvas(C).ScaleValX(MenuOffsetRightX);
	PosY = C.SizeY/2 + LegendCanvas(C).ScaleValY(MenuOffsetY);

	DisplayedSkinName = GetItemName( PlayerSkinStr );
	if( DisplayedSkinName == "" )
	{
		// just in case...
		DisplayedSkinName = "?";
	}
		
	DrawMenuEntry( C, PosX, PosY+0*LegendCanvas(C).ScaleValY(MenuSpacingY), PlayerNameStr, 1 );
	DrawMenuEntry( C, PosX, PosY+1*LegendCanvas(C).ScaleValY(MenuSpacingY), PlayerClass.default.MenuName, 2, ClassChangeDisabled() );
	DrawMenuEntry( C, PosX, PosY+2*LegendCanvas(C).ScaleValY(MenuSpacingY), DisplayedSkinName, 3, SkinChangeDisabled() );
	if( class'Player'.default.ConfiguredInternetSpeed <= 3000 )
		DrawMenuEntry( C, PosX, PosY+3*LegendCanvas(C).ScaleValY(MenuSpacingY), InternetOption, 4 );
	else if( class'Player'.default.ConfiguredInternetSpeed < 12500 )
		DrawMenuEntry( C, PosX, PosY+3*LegendCanvas(C).ScaleValY(MenuSpacingY), FastInternetOption, 4 );
	else
		DrawMenuEntry( C, PosX, PosY+3*LegendCanvas(C).ScaleValY(MenuSpacingY), LANOption, 4 );
}

//=============================================================================

function SaveConfigs()
{
	PlayerOwner.UpdateURL( "Name",  PlayerNameStr,  true );

	// don't write class in a citadel game -- this isn't saved from game to game
	if( !bCitadelGame )
	{
		PlayerOwner.UpdateURL( "Class", PlayerClassStr, true );
		PlayerOwner.UpdateURL( "Skin",  PlayerSkinStr,  true );
	}
	else
	{
		// save citadel skin color preference (will try to use this when possible)
		PlayerOwner.UpdateURL( "CitadelSkin",  Mid(GetItemName(PlayerSkinStr), 4),  true );
	}

	if( Level.Netmode != NM_Standalone || !Level.Game.IsA( 'giMission' ) )
	{
		// not a singleplayer mission -- ok to update in-game settings

		// always OK to update in-game name
		PlayerOwner.ChangeName( PlayerNameStr );

		if( !bCitadelGame && PlayerOwner.IsA( 'WOTPlayer' ) )
		{
			// ok to update in-game class (not a citadel game)
			WOTPlayer( PlayerOwner ).ServerChangeClass( class<WOTPlayer>(PlayerClass) );
		}

		// set skin (doesn't write URL)
		PlayerOwner.ServerChangeSkin( PlayerSkinStr, "", 255 );
	}
}

//=============================================================================

function SetUpDisplay()
{
	local SealAltar A;

	bSetup = true;
	
	RealOwner = Owner;
	SetOwner( PlayerOwner );

	bSavedBehindView = PlayerOwner.bBehindView;
	PlayerOwner.bBehindView = false;

	bCitadelGame = false;
	if( PlayerOwner.myHUD != None && PlayerOwner.myHUD.IsA('BattleHUD') )
	{
		bCitadelGame = true;
	}

	PlayerNameStr = PlayerOwner.GetDefaultURL( "Name" );

	if( bCitadelGame )
	{
		// prime displayed class with forced class -- won't be able to change in ini nor in-game
		PlayerClassStr = ClassStrings[ PlayerOwner.PlayerReplicationInfo.PlayerType ];

		// load prefered citadel skin 
		PlayerSkinStr  = PlayerClassStr$"Skins."$Left(PlayerClassStr,3)$"_"$PlayerOwner.GetDefaultURL( "CitadelSkin" );

		// make sure we apply current skin
		bConfigChanged = true;
	}
	else
	{
    	// can change and save class
		PlayerClassStr = PlayerOwner.GetDefaultURL( "Class" );
		PlayerSkinStr  = PlayerOwner.GetDefaultURL( "Skin" );
	}

	FindClass( 0 );
}

//=============================================================================

function DrawMenu( Canvas C )
{
	local vector DrawOffset, DrawLoc;
	local rotator NewRot, DrawRot;

	if( !bSetup )
	{
		SetUpDisplay();
	}

	// Set menu location.
	if( PlayerOwner.ViewTarget == None )
	{
		PlayerOwner.ViewRotation.Pitch = 0;
		PlayerOwner.ViewRotation.Roll = 0;
		DrawRot = PlayerOwner.ViewRotation;
		DrawOffset = vect(10.0,-5.0,0.0) >> PlayerOwner.ViewRotation;
		DrawLoc = PlayerOwner.Location + PlayerOwner.EyeHeight * vect(0,0,1);
	}
	else
	{
		DrawLoc = PlayerOwner.ViewTarget.Location;
		DrawRot = PlayerOwner.ViewTarget.Rotation;
		if( Pawn(PlayerOwner.ViewTarget) != None )
		{
			if( (Level.NetMode == NM_StandAlone) && 
				(PlayerOwner.ViewTarget.IsA( 'PlayerPawn' ) || PlayerOwner.ViewTarget.IsA( 'Bot' ) ))
			{
				DrawRot = Pawn(PlayerOwner.ViewTarget).ViewRotation;
			}

			DrawLoc.Z += Pawn(PlayerOwner.ViewTarget).EyeHeight;
		}
	}
	
	DrawOffset = vect( 10.0,-5.0,0.0 ) >> DrawRot;
	SetLocation( DrawLoc + DrawOffset );
	NewRot = DrawRot;
	NewRot.Yaw = Rotation.Yaw;
	SetRotation( NewRot );
	C.DrawActor( Self, false );
		
	DrawTitle( C );
	DrawOptions( C );
	DrawValues( C );

	DrawHelpPanel( C );
}

//=============================================================================

defaultproperties
{
     AnimSequenceRate=0.500000
     DrawScaleBase=0.070000
     ClassStrings(0)="WOTPawns.AesSedai"
     ClassStrings(1)="WOTPawns.Forsaken"
     ClassStrings(2)="WOTPawns.Hound"
     ClassStrings(3)="WOTPawns.Whitecloak"
     bMenuHelp=True
     bLargeFont=False
     MenuLength=4
     Physics=PHYS_Rotating
     AnimSequence=Walk
     DrawType=DT_Mesh
     bUnlit=True
     bOnlyOwnerSee=True
     bFixedRotationDir=True
     RotationRate=(Yaw=8000)
     DesiredRotation=(Yaw=30000)
}
