//=============================================================================
// WOTPlayer.uc
// $Author: Mfox $
// $Date: 1/10/00 1:53p $
// $Revision: 129 $
//=============================================================================

class WOTPlayer expands PlayerPawn
    intrinsic;

#exec AUDIO IMPORT FILE=Sounds\Pawn\Player\Generic\Pickup.wav			GROUP=Player

#exec AUDIO IMPORT FILE=Sounds\UI\CitadelEditor\EditSelect.wav			GROUP=Editor
#exec AUDIO IMPORT FILE=Sounds\UI\CitadelEditor\BeginEdit.wav			GROUP=Editor
#exec AUDIO IMPORT FILE=Sounds\UI\CitadelEditor\EndEdit.wav				GROUP=Editor

#exec AUDIO IMPORT FILE=Sounds\Notification\Expired.wav			    	GROUP=Effect
#exec AUDIO IMPORT FILE=Sounds\Notification\SelectNewItem.wav			GROUP=Effect

#exec AUDIO IMPORT FILE=Sounds\Notification\SeekerNotification.wav  	GROUP=Effect

#exec AUDIO IMPORT FILE=Sounds\UI\Angreal\SelectArtifact.wav			GROUP=UI
#exec AUDIO IMPORT FILE=Sounds\UI\Angreal\SelectHand.wav				GROUP=UI

enum EMotionDirection
{
    MD_None,
    MD_Forward,
    MD_Backward,
    MD_Left,
    MD_Right
};

enum ETransitionType
{
	TRT_None,
	TRT_EndOfLevel,
	TRT_RestartLevel,
	TRT_LoadLevel,
	TRT_NewGame
};

struct PlayerTroopMap
{
	var Name	Player;
	var Name	Troop;
	var String	TroopClassName;
};

enum ELoadSave
{
	LS_Load,
	LS_Save,
};

var private ETransitionType TransitionType;

const MAX_ZONE = 63;					// the last possible Zone ID
const TRACE_DISTANCE = 3200;			// 200 feet (sync with EditorHUD.uc -- used in AWOTPlayer.cpp)
const TELEPORT_FAIL_MESSAGE_DELAY = 4.0;

// Citadel Editor HandSet indices.
const CE_SEALS		= 0;
const CE_GRUNT		= 1;
const CE_CAPTAIN	= 2;
const CE_ALARM		= 3;
const CE_SPEAR		= 4;
const CE_FIREWALL	= 5;
const CE_WALL		= 6;
const CE_PIT		= 7;
const CE_STAIRCASE	= 8;
const CE_PORTCULLIS	= 9;

//=============================================================================
// Main UI control and state data
//-----------------------------------------------------------------------------
var IconInfo FirstIcon;				// the linked list of all angreal icons currently affecting the player

var int SeekerCount;				// How many seekers are currently tracking the player

var HandSet AngrealHandSet;			// Angreal Hands
var HandSet CitadelEditorHandSet;	// Citadel Editor Hands
var HandSet CurrentHandSet;			// the currently selected set of hands: AngrealHandSet or CitadelEditorHandSet

var HUD PrevHUD;					// variables used by Push/PopUserInterfaceState()
var bool bPrevShowMenu;				// 
var bool bSkipPaintProgress;		// set to true to disable showing LOADING/SAVING etc. 
var bool bSkipProgressFog;			// set to true to disable fogging display during load/save etc.

//=============================================================================
// Citadel Editor UI control and state data
//-----------------------------------------------------------------------------
var BudgetInfo Budget;				// set when player selects a team (arbitrates access to the Citadel Editor and resources)

var bool bEditing;					// player is in edit mode (show Citadel Editor interface)

var bool bTeleportingDisabled;		// don't allow players to teleport while editing (required by both Server and Client)
var float LastTeleportFailMessage;	// last time teleport disabled message was displayed

var vector EditStartLoc;			// location to return to when editing is terminated
var rotator EditStartRot;			// view to return to when editing is terminated

var int SelectedZone;				// current focus for editing -- an index to a WOTZoneInfo actor
var rotator ViewOffset;				// deviation from authored view into the the selected zone

var bool bShowOverview;				// pop up the overview scoreboard
var ScoreBoard Overview;			// the actual overview scoreboard (maintained in MenuHUD)
var class<ScoreBoard> OverviewType;	// type of overview scoreboard to use

//=============================================================================
// Misc. variables
//=============================================================================
var name NextAnim;						// next animation sequence to play and/or tween to (for hits)
var() float MinDamageToShake;
var() float RespawnDelaySecs;			// delay between dying and firing respawning you
var   float OKToFireTime;

// skins
var() int SkinSwitchLevel;
var() string AltSkinStr;
var() bool bTeleFragPawns;

var() float RestartLevelDelaySecs;

var private bool bShowHitActors;
var private bool bSpamHitActors;
var private bool bShowHiddenClasses;

var private name NPCNames[16];

//=============================================================================
// AdjustRotation overrides.

var bool bForceRotation;
var rotator ForcedRotationRate;

var EMotionDirection MotionDirection;

//=============================================================================
// player taunts

var private    float NextTauntTime;
var(WOTSounds) float MinTimeBetweenTaunts;

//=============================================================================
// asset handling 

var(WOTSounds) class<GenericTextureHelper>		TextureHelperClass;
var()		   class<GenericDamageHelper>		DamageHelperClass;
var GenericAssetsHelper							AssetsHelper;				// per-instance -- destroy as needed

var(WOTSounds) class<SoundTableWOT>				SoundTableClass;
var private SoundTableWOT						MySoundTable;				// shared singleton -- do not destroy

var(WOTSounds) class<SoundSlotTimerListInterf>	SoundSlotTimerListClass;
var private SoundSlotTimerListInterf			MySoundSlotTimerList;		// per-instance -- destroy as needed

var(WOTSounds) float							VolumeMultiplier;
var(WOTSounds) float							RadiusMultiplier;
var(WOTSounds) float							PitchMultiplier;
var(WOTSounds) float							TimeBetweenHitSoundsMin;
var(WOTSounds) float							TimeBetweenHitSoundsMax;

var(WOTAnims) class<AnimationTableWOT>			AnimationTableClass;
var bool										bTestAnimTable;
var float										NextPainSoundTime;

// wotplayer anims:
const AttackAnimSlot				= 'Attack';    
const AttackRunAnimSlot				= 'AttackRun'; 
const AttackRunLAnimSlot			= 'AttackRunL';
const AttackRunRAnimSlot			= 'AttackRunR';
const AttackWalkAnimSlot			= 'AttackWalk';
const BreathAnimSlot				= 'Breath';      
const DeathAnimSlot					= 'Death';    
const FallAnimSlot					= 'Fall';      
const HitAnimSlot					= 'Hit';      
const HitHardAnimSlot				= 'HitHard';  
const JumpAnimSlot					= 'Jump';      
const LandAnimSlot					= 'Land';    
const LookAnimSlot					= 'Look';      
const RunAnimSlot					= 'Run';       
const RunLAnimSlot					= 'RunL';      
const RunRAnimSlot					= 'RunR';      
const SwimAnimSlot					= 'Swim';      
const WalkAnimSlot					= 'Walk';      

var() float HitHardHealthRatio;
var() float ExceptionalDeathHealthRatio;
var() float WalkBackwardSpeedMultiplier;
var	bool bSetSpeedCheatOn;

//=============================================================================

const ThisClassName = 'WotPlayer';

//=============================================================================

var() float SpeedPlayAnimAfterLanding;		// landings at more than this speed play landed anim
var() float PlayLandHardMinVelocity;		// landings at more than this speed play land hard sound
var() float PlayLandSoftMinVelocity;		// landings at more than this speed play land soft sound (if < PlayLandHardMinVelocity)
var() float LadderLandingNoiseVelocity;		// landing on a ladder at more than this speed means player makes noise
var() float LadderLandedHitNormalZ;			// z-component below which landing is considered to be on a ladder

var() float GibForSureFinalHealth;			// if NPC dies with this much health (e.g. -40) will be gibbed for sure
var() float GibSometimesFinalHealth;		// if NPC dies with this much health (e.g. -30) will be gibbed sometimes
var() float GibSometimesOdds;				// odds of gibbing if final health is GibSometimesFinalHealth or less
var() float BaseGibDamage;					// min damage needed to gib at GibForSureFinalHealth (passed on to carcass)
var() bool  bNeverGib;						// like the name says -- passed on to carcass (not currently used -- if set, PC carcasses won't be gib-able)
var bool bCarcassSpawned;					// whether Pawn has been "converted" to a carcass

// The artifact this player starts out with.
var() class<AngrealInventory> DefaultAngrealInventory;

// A list of all the artifacts spawnable by the debug function SA.
var string ArtifactNames[55];

var() localized string SelectedStr;
var() localized string TerAngrealStr;
var() localized string InventoryInfoHitStr;

// subtitle support
var() Name SubTitlesPackageName;
var() globalconfig bool bSubtitles;					
var() string SubTitleLanguages[5];
var() float MessageDurationSecsPerChar;
var() float MinMessageDuration;

// sound debugging
var() globalconfig bool bShowSounds;				
var() globalconfig bool bShowOtherSounds;			
var() globalconfig bool bShowLocalizeSoundErrors;	

var() float InventoryInfoHintDuration;
var WOTHelpInfo WOTHelpItem;						// object containing help screen data (title + description strings)

var globalconfig name AngrealHandOrder[100];

var() name		IllusionAnimSequence;
var() float		IllusionAnimRate;

var() globalconfig float PlayerRestartGameDelay;	// delay before players can restart server by firing etc.
 
// Offset for SA function
var() vector SAOffset;

//-----------------------------------------------------------------------------
// Reflectors to be installed at startup.
//-----------------------------------------------------------------------------

var() class<Reflector> DefaultReflectorClasses[20];

//-----------------------------------------------------------------------------
// Reflected functions will be reflected into this class.
//-----------------------------------------------------------------------------

var Reflector CurrentReflector;

//-----------------------------------------------------------------------------
// Pointer to the First of a linked list of Leeches attached to this Pawn.
// Use FirstLeech.NextLeech to access the rest of the list.
//-----------------------------------------------------------------------------

var Leech FirstLeech;

// Disguise support vars.
var   class<Pawn>	ApparentClass;      // What this player looks like to other characters
var() travel int	ApparentTeam;       // What team this player is apparently on (access via GetApparentTeam())
var   Texture		ApparentIcon;       // What health icon is displayed for the player
var   Texture		HealthIcons[4];     // What health icon is displayed for the player
var   Texture		DisguiseIcon;       // What icon is displayed if another player looks like you

// Keeps track of how many times the player has died.
// (Used by Seekers so we don't continue to seek after a player after he/she dies.)
// Note: This is not the same as PlayerReplicationInfo.Deaths.  PlayerReplicationInfo.Deaths
// doesn't get incremented for suicides (for scoring reasons) whereas NumDeaths does.
var int NumDeaths;

// Player specific color - used for Darts, LightGlobe, AppearEffects, etc.
var() name PlayerColor;
/* -- use names instead so we can access this outside of this class.
var() enum EPlayerColor
{
	PC_Blue,
	PC_Red,
	PC_Green,
	PC_Gold,
	PC_Purple
} PlayerColor;
*/

// Shield support
var int ShieldHitPoints;			// shields absorb this much damage before going down

// Suicide instigator support.
var Pawn SuicideInstigator;			// The guy that gets points if you kill yourself.
var float SuicideInstigationTime;	// When the guy "touched" us last.  Scoreing only takes 
									// SuicideInstigation into accout if it happened recently.

var bool bAcceptedInventory;		// Only accept inventory on level transitions 
									// (not during the loading of saved levels).
									// [Maintained by giMission_NoInv]
									// Note: This is *not* "travel".

var class<WOTPlayer> PlayerClass;	// The class the player is emulating (modified in ServerChangeClass)
var PlayerTroopMap PlayerTroops[12];
var localized String TeamDescription;	// team name used in the Citadel game

var transient int JoinTeamTimeout;		// maintained in giMPBattle.uc

var bool bProhibitEditorExit;			// scripting support for the Tutorial

var localized String CantChangeTeamsStr;
var localized String TeleportProhibitedEditingStr;
var localized String TeleportProhibitedJoinStr;
var localized String WaitingForSealsStr;
var localized String WaitingForEditStr;
var localized String CantEditLevelStr;
var localized String CantEditZoneStr;
var localized String CantEditAreaStr;
var localized String CantEditNowStr;
var localized String CantEditBudgetStr;
var localized String CantEditLimitStr;
var localized String CantPlaceResourceStr;
var localized String CantLeaveEditorStr;

//=============================================================================
// Multiplayer replication support for the WOTPlayer and Citadel Editor
//-----------------------------------------------------------------------------
replication
{
    // Data the server should send to the client player only
    reliable if( Role==ROLE_Authority && bNetOwner )
		bEditing,
		bTeleportingDisabled,
		JoinTeamTimeout,
		bShowOverview,
        OverviewType,
		FirstIcon,
        ShieldHitPoints,
		bForceRotation, 
		ForcedRotationRate,
		ApparentIcon,
		HealthIcons,
		DisguiseIcon,
		AnimationTableClass,
		ApparentClass,
		SeekerCount;

	// Data the server should send the client player while he's editing
	reliable if( Role==ROLE_Authority && bNetOwner && bEditing )
		SelectedZone,
		EditStartLoc,
		EditStartRot;

    // Functions the server replicates to the client player only
	reliable if( Role==ROLE_Authority && bNetOwner )
		ClientSelectItem,
		ClientSelectItemMessage,
		ClientIncrementResource,
		ClientDecrementResource,
		CreateCitadelEditorHands,
		DestroyCitadelEditorHands;

    // Data the server replicates to the client
    reliable if( Role==ROLE_Authority )
		TeamDescription;

    // Functions the server replicates to the client
    reliable if( Role==ROLE_Authority )
		ShowCredits,

		ClientGotoState,
		ClientDynamicLoadObject,
		ClientSetNumTeams,

		ClientAddItem,
		ClientRemoveItem,

		ClientSelect,
		CreateAngrealHands,
		UseAngreal,
		
		HandMessage,
		LeftMessage,
		RightMessage,
		CenterMessage,
		SetFOV;

    // Functions client can call that will be replicated to the server
    reliable if( Role<ROLE_Authority )
		BroadcastLeftMessage,
		BroadcastRightMessage,
		BroadcastCenterMessage,

		SaveMenu,
		LoadMenu,

		NotifyAutoSwitch,

		ServerAssessBattlefield,
		UseSpecifiedAngreal,
		Select,
		SelectPlayerStart,
        Drop,
		DropTainted,
		DropSeals,
		ServerSelectItem,
		ServerDeleteInventory,

		ServerChangeTeam,

		ServerEditCitadel,

        SetZoneNumber,

		// functions needed by the EditorHUD
		ServerCreateResource,
		ServerRemoveResource,
		ServerToggleResource,
		ServerActivateResource,
		ServerDeactivateResource,
		ServerBeginSelect,
		ServerEndSelect,
		ServerChangeClass,

		ShowOverview,

		PlayTaunt,

		ServerLog,

		Vote,

		// debug/cheat execs
		CheatSeals,
		ServerExit,
		SetTeam,
		Teleport,
		UnTeleport,	
		GotoObject,
		JumpTo,
		Where,
		AllAngreal,
		Meteor,
		ShowTeams,
		SummonTeam,
		DebugAll,
		DebugToggleHitActor,
		NPCStats,
		DumpAll,
		ToggleShowClass,
		ShowNodes,
		DrawPaths,
		DrawPathTo,
		FactoryInfo,
		ToggleShowHitActors,
		EnableSpamHitActors,
		DynamicCrosshair,
		TraceToggleShowCylinder,
		ShowViewTrace,
		EditHitActor,
		PlayHitActorAnims,
		LoopHitActorAnims,
		DebugHitActorAnims,
		ForceClass,

		ServerUseAngreal, CeaseUsingAngreal,
		CheckReflectors, CheckInventory, CheckLeeches, SA, AllArtifacts,
		GiveItem, SelectItem;
}

//=============================================================================
// intrinsic function declations
//=============================================================================
intrinsic final static function ZoneInfo GetZoneInfo( int ZoneNum );

intrinsic final static function ZoneInfo GetLocationZoneInfo( vector Loc );

intrinsic final static function actor TraceVisible
(
	vector			TraceDirection,
	out vector      HitLocation,
	out vector      HitNormal,
	optional vector	TraceStart,
	optional bool   bTraceActors,
	optional int	Distance
);

//=============================================================================
// Editor interface to Trace() -- to simplify debugging
//-----------------------------------------------------------------------------
function actor EditorTrace( 
	    vector		TraceDirection,
	out vector      HitLocation,
	out vector      HitNormal,
	optional vector	TraceStart,
	optional bool   bTraceActors,
	optional int	Distance
)
{
	return TraceVisible( TraceDirection, HitLocation, HitNormal, TraceStart, bTraceActors, Distance );
}

//=============================================================================
// START OF NON-DEBUG/CHEAT EXEC FUNCTIONS -- ALWAYS ENABLED.
//=============================================================================

//=============================================================================
// hide the current HUD -- used for diagnostics (performance tuning)

function HideUI( bool bHide )
{
	if( uiHUD(myHUD) != None )
	{
		uiHUD(myHUD).bHide = bHide;
	}
}

//=============================================================================
exec function ToggleUI()
{
	if( uiHUD(myHUD) != None )
	{
		HideUI( !uiHUD(myHUD).bHide );
	}
}

//=============================================================================
function HideUIExceptForHands( bool bHide )
{
	if( BaseHUD(myHUD) != None )
	{
		BaseHUD(myHUD).bHideHealth			= bHide;
		BaseHUD(myHUD).bHideStatusIcons		= bHide;
		BaseHUD(myHUD).bHideKeys			= bHide;
		BaseHUD(myHUD).bHideMessages		= bHide;
	}
}

//=============================================================================
exec function ShowOverview()
{
	bShowOverview = !bShowOverview;
}

//=============================================================================
exec function Say( string Message )
{
	BroadcastLeftMessage( PlayerReplicationInfo.PlayerName$": "$Message );
}

//=============================================================================
event TeamMessage( PlayerReplicationInfo PRI, coerce string S, name Type )
{
	local string TeamName;
	local BattleInfo B;

	if( PRI.Team == 255 )
	{
		TeamName = "Spectator";
	}
	else
	{
		TeamName = "Team";
		foreach AllActors( class'BattleInfo', B )
		{
			TeamName = B.GetTeamDescription( PRI.Team );
			break;
		}
	}
	LeftMessage( "["$TeamName$"]"$PRI.PlayerName$": "$S );
}

//=============================================================================
// PlayTaunt -1 will play a random taunt, 1..N will play the corresponding
// Taunt (if found).
//=============================================================================
exec function PlayTaunt( int TauntIndex )
{
	local Name Taunt;

	if( Health > 0 )
	{
		if( TauntIndex >= 1 || TauntIndex == -1 )
		{
			// prevent spamming
			if( Level.TimeSeconds >= NextTauntTime )
			{
				Taunt = MySoundTable.GetTauntSlot( TauntIndex );
				if( Taunt != '' )
				{
					MySoundTable.PlaySlotSound( Self, Taunt, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );

					NextTauntTime = Level.TimeSeconds + MinTimeBetweenTaunts;
				}
				else
				{
					ClientMessage( "PlayTaunt: invalid taunt index!" );
				}
			}
		}
		else
		{
			ClientMessage( "PlayTaunt: invalid taunt index!" );
		}
	}
}

//=============================================================================
exec function SetWarning()
{
	if( myHUD != None && BaseHUD( myHUD ) != None ) 
	{
		BaseHUD( myHUD ).SetWarning();
	}
}

//=============================================================================
exec function EnableWarning()
{
	if( myHUD != None && BaseHUD( myHUD ) != None ) 
	{
		BaseHUD( myHUD ).WarningEnabled = true;
	}
}

//=============================================================================
exec function DisableWarning()
{
	if( myHUD != None && BaseHUD( myHUD ) != None ) 
	{
		BaseHUD( myHUD ).WarningEnabled = false;
	}
}
	
//=============================================================================

exec function Jump( optional float F )
{
	if( Level.Pauser != "" )
	{
		// paused -- unpause?
		if ( !bShowMenu && (Level.Pauser == PlayerReplicationInfo.PlayerName) )
		{
			// could fail if paused internally
			SetPause(False);
		}
	}
	else
	{
		bPressedJump = true;
	}
}

//=============================================================================
// If any WOTWindow is on the screen close it, otherwise Turn on the menu UI --
// overridden to avoid SetPause() behavior in PlayerPawn in the entry level.
//=============================================================================
exec function ShowMenu()
{
	local bool bActive;

	if( uiHUD(myHUD) != None )
	{
		bActive = uiHUD(myHUD).IsWindowActive( class'WOTWindow' );
		uiHUD(myHUD).RemoveWindows();
		HideUI( false );
	}	

	MenuHUD(myHUD).MainMenuType = class'MenuHUD'.default.MainMenuType;
	if( !bActive )
	{
		if( Level.Netmode == NM_Standalone && !Level.Game.IsA( 'giEntry' ) )
		{
			SetPause( true );
		}

		WalkBob = vect(0,0,0);
		bShowMenu = true; // menu is responsible for turning this off
		Player.Console.GotoState( 'Menuing' );
	}
}

//=============================================================================

function SaveLoadMenu( ELoadSave LSType )
{
	// block save/load in non-mission games
	if( !Level.Game.IsA( 'giCombatBase' ) )
	{
		// close any windows
		if( uiHUD(myHUD) != None )
		{
			uiHUD(myHUD).IsWindowActive( class'WOTWindow' );
			uiHUD(myHUD).RemoveWindows();
			HideUI( false );
		}	
	
		// put up the load/save menu	
		if( Level.Netmode == NM_Standalone && !Level.Game.IsA( 'giEntry' ) )
		{
			SetPause( true );
		}
	
		WalkBob = vect(0,0,0);
	
		bShowMenu = true; // menu is responsible for turning this off
		if( LSType == LS_Load )
		{
			MenuHUD(myHUD).MainMenuType = class'WOT.menuLoad';
		}
		else
		{
			MenuHUD(myHUD).MainMenuType = class'WOT.menuSave';
		}
		Player.Console.GotoState( 'Menuing' );
	}
}

//=============================================================================

exec function SaveMenu()
{
	SaveLoadMenu( LS_Save );
}

//=============================================================================

exec function LoadMenu()
{
	SaveLoadMenu( LS_Load );
}

//=============================================================================
// Put the "hit F2 for more info" message on screen.
//=============================================================================
function DoInfoHint( optional float Duration )
{
	if( Duration == 0.0 )
	{
		Duration = InventoryInfoHintDuration;
	}

	CenterMessage( InventoryInfoHitStr, Duration );
}

//=============================================================================
// toggle Angreal Info and Mission Objectives dialogs
// overridden to avoid SetPause() behavior in PlayerPawn in the entry level
//=============================================================================
function DoShowInventoryInfo( Actor WindowItem, bool bRemoveWindows )
{
	if( uiHUD(myHUD) != None )
	{
		if( bRemoveWindows )
		{
			uiHUD(myHUD).RemoveWindows();
		}

		if( WindowItem != None )
		{
			uiHUD(MyHUD).AddWindow( class'InventoryInfoWindow', WindowItem );
		}
	}
}

//=============================================================================
function UpdateInventoryInfo()
{
	uiHUD(myHUD).UpdateWindows( class'InventoryInfoWindow', CurrentHandSet.GetSelectedHand().GetSelectedItem() );
}
			
//=============================================================================
exec function ShowInventoryInfo()
{
	local bool bActive;

	if( uiHUD(myHUD) != None )
	{
		bActive = uiHUD(myHUD).IsWindowActive( class'InventoryInfoWindow' );
		uiHUD(myHUD).RemoveWindows();
		if( !bActive )
		{
			DoShowInventoryInfo( CurrentHandSet.GetSelectedHand().GetSelectedItem(), false );
		}
	}
}

/*
//=============================================================================

exec function ShowTransitionScreen()
{
	local bool bActive;
		
	if( uiHUD(myHUD) != None )
	{
		bActive = uiHUD(myHUD).IsWindowActive( class'WOTTransitionScreen' );
	
   		uiHUD(myHUD).RemoveWindows();
   		if( !bActive )
   		{
			uiHUD(MyHUD).AddWindow( class'WOTTransitionScreen', None );
   		}
	}
}
*/

//=============================================================================
exec function ShowMissionObjectives( optional MissionObjectives Objectives )
{
	local bool bActive;

	if( uiHUD(myHUD) != None )
	{
		bActive = uiHUD(myHUD).IsWindowActive( class'MissionObjectivesWindow' );

		uiHUD(myHUD).RemoveWindows();
		if( !bActive )
		{
			if( Objectives == None )
			{
				foreach AllActors( class'MissionObjectives', Objectives )
				{
					break;
				}
			}

			if( Objectives != None )
			{
				uiHUD(MyHUD).AddWindow( class'MissionObjectivesWindow', Objectives );
			}
		}
	}
}

//=============================================================================
// Helps console decide whether/how to draw the transition map. Might actually 
// be nice to put this in the levelinfo?

function SetTransitionType( ETransitionType TT )
{
	TransitionType = TT;
}

//=============================================================================
// Helps console decide whether/how to draw the transition map. Might actually 
// be nice to put this in the levelinfo?

function ETransitionType GetTransitionType()
{
	return TransitionType;
}

//=============================================================================

function SetResolution( string NewResolution, bool bIsMinimum )
{
	local string CurrentResolution;
	local string GetResolution;
	local int CurResX, CurResY, XPos;
	local int NewResX, NewResY;
	
	CurrentResolution = ConsoleCommand( "GetCurrentRes" );

	if( bIsMinimum )
	{
		XPos	= Instr( CurrentResolution, "x" );
		CurResX = int(Left( CurrentResolution, XPos ));
		CurResY = int(Right( CurrentResolution, Len(CurrentResolution) - XPos - 1));

		XPos	= Instr( NewResolution, "x" );
		NewResX = int(Left( NewResolution, XPos ));
		NewResY = int(Right( NewResolution, Len(NewResolution) - XPos - 1));

		GetResolution = ConsoleCommand( "GetRes" );
		if( (CurResX < NewResX || CurResY < NewResY) && (instr(GetResolution, NewResolution) >= 0) )
		{
			ConsoleCommand( "SetRes " $ NewResolution );
		}
	}
	else
	{
		if( (NewResolution != "") && ( CurrentResolution != NewResolution) && (instr( ConsoleCommand( "GetRes" ), NewResolution) >= 0) )
		{
			ConsoleCommand( "SetRes " $ NewResolution );
		}
	}
}

//=============================================================================

exec function ShowCredits( optional bool bEndGame )
{
	Level.Pauser = "";
	PushUserInterfaceState();
	ViewRotation.Pitch = -16384;
	myHUD = spawn( class'Credits', self );
	if( bEndGame )
	{
		Credits(myHUD).LinesPerSecond = class'Credits'.default.LinesPerSecond * 0.5;
	}
}

//=============================================================================

function EndCredits()
{
	ViewRotation.Pitch = 0;
	PopUserInterfaceState();
}

//=============================================================================

exec function ShowHelp()
{
	local bool bActive;
		
	if( uiHUD(myHUD) != None )
	{
		bActive = uiHUD(myHUD).IsWindowActive( class'WOTHelpWindow' );
	
   		uiHUD(myHUD).RemoveWindows();
   		if( !bActive )
   		{
   			if( WOTHelpItem == None )
   			{
   				WOTHelpItem = Spawn( class'WOTHelpInfo' );
   			}
   
	   		if( WOTHelpItem != None )
	   		{
   				uiHUD(MyHUD).AddWindow( class'WOTHelpWindow', WOTHelpItem );
			}
   		}
	}
}

//=============================================================================

exec function ShowMessageBox( WOTTextWindowInfo TextWindowInfo )
{
	if( uiHUD(myHUD) != None )
	{
		uiHUD(myHUD).RemoveWindows();
		uiHUD(MyHUD).AddWindow( class'WOTTextWindow', TextWindowInfo );
	}
}

//=============================================================================
exec function PrevInventory()
{
	local int Selected;

	Selected = CurrentHandSet.GetSelectedHand().Selected;
	CurrentHandSet.GetSelectedHand().SelectPrevious();
	if( CurrentHandSet.GetSelectedHand().Selected >= Selected )
	{
		PrevHand();
	}
	else
	{
		PerformSelection( false );
	}
}

//-----------------------------------------------------------------------------
exec function NextInventory()
{
	local int Selected;

	Selected = CurrentHandSet.GetSelectedHand().Selected;
	CurrentHandSet.GetSelectedHand().SelectNext();
	if( CurrentHandSet.GetSelectedHand().Selected <= Selected )
	{
		NextHand();
	}
	else
	{
		PerformSelection( false );
	}
}

//-----------------------------------------------------------------------------
exec function PrevHand()
{
	SelectHand( CurrentHandSet.GetPrevious() );
}

//-----------------------------------------------------------------------------
exec function NextHand()
{
	SelectHand( CurrentHandSet.GetNext() );
}

//-----------------------------------------------------------------------------
exec function SelectHand( int Index )
{
	local bool bNewHand;

	bNewHand = (Index != CurrentHandSet.Selected);

	CurrentHandSet.Select( Index );
	PerformSelection( bNewHand );
}

//-----------------------------------------------------------------------------
function PerformSelection( bool bNewHand )
{
	ServerSelectItem( CurrentHandSet.GetSelectedHand().GetSelectedClassName() );

	if( SelectedItem != None )
	{
		if( bNewHand )
		{
			ClientPlaySound( Sound( DynamicLoadObject( "WOT.UI.SelectHand", class'Sound' ) ) );
		}
		else
		{
			ClientPlaySound( Sound( DynamicLoadObject( "WOT.UI.SelectArtifact", class'Sound' ) ) );
		}
	}

	ClientSelectItem();
	ClientSelectItemMessage( CurrentHandSet.GetSelectedHand().GetSelectedClassName() );
}

//=============================================================================
// Select the specified object if found
//=============================================================================
exec function Select( name InvName )
{
	local inventory Inv;
	local inventory Item;
	local HandInfo Hand;

	Inv = FindInventoryName( InvName );
	if( Inv != None )
	{
		CeaseUsingAngreal();
		
		ClientSelect( InvName );
		SelectedItem = Inv;
	}	
}

//=============================================================================
// Try to use the specified angreal.
//=============================================================================
exec function UseSpecifiedAngreal( name InvName )
{
	local Inventory OldSelectedItem;

	// while the Citadel Game has not started, inhibit weapon use
	if( bTeleportingDisabled )
	{
		// if the player is on a team, assess the battlefield to start the Citadel Game
		if( PlayerReplicationInfo.Team != 255 )
		{
			ServerAssessBattlefield();
		}
		return;
	}
	
	if( Level.Pauser == "" )
	{
		OldSelectedItem = SelectedItem;

		CeaseUsingAngreal();
		SelectedItem = FindInventoryName( InvName );
		ServerUseAngreal();

	 	SelectedItem = OldSelectedItem;
	 }
}

//=============================================================================
// Turn the currently selected angreal on.
//=============================================================================
exec function UseAngreal()
{
	if( AngrealHandSet == None || CurrentHandSet != AngrealHandSet )
	{
		warn( Self$".UseAngreal() AngrealHandSet="$ AngrealHandSet $" CurrentHandSet="$ CurrentHandSet );
		return;
	}

	// while the Citadel Game has not started, inhibit weapon use
	if( bTeleportingDisabled )
	{
		// if the player is on a team, assess the battlefield to start the Citadel Game
		if( PlayerReplicationInfo.Team != 255 )
		{
			ServerAssessBattlefield();
		}
		return;
	}

	if( Level.Pauser == "" )
	{
		//if( SelectedItem != None )
		if( CurrentHandSet.GetSelectedHand().GetSelectedClassName() != '' )
		{
			ServerUseAngreal();
		}
		else
		{
			// Select next best artifact if nothing is currently selected.
			if( CurrentHandSet.GetSelectedHand().IsEmpty() )
			{
				SelectHand( CurrentHandSet.GetNext() );
			}
			else
			{
				CurrentHandSet.GetSelectedHand().SelectFirst();
			}
			ServerSelectItem( CurrentHandSet.GetSelectedHand().GetSelectedClassName() );
			ClientSelectItem();
			ClientSelectItemMessage( CurrentHandSet.GetSelectedHand().GetSelectedClassName() );

			if( CurrentHandSet.GetSelectedHand().GetSelectedClassName() != '' )
			{
				NotifyAutoSwitch();
			}
		}
	}
}

//-----------------------------------------------------------------------------
// Client request to select given item.
//-----------------------------------------------------------------------------
function ServerSelectItem( name ItemName )
{
	CeaseUsingAngreal();
	SelectedItem = FindInventoryName( ItemName );
}

//-----------------------------------------------------------------------------
simulated function ClientSelect( name InvName )
{
	if( CurrentHandSet != None )
	{
		CurrentHandSet.SelectItem( InvName );
	}
	ClientSelectItem();
	ClientSelectItemMessage( CurrentHandSet.GetSelectedHand().GetSelectedClassName() );
}

//-----------------------------------------------------------------------------
simulated function ClientSelectItem()
{
	// prior to the PostRender() -- during game startup -- myHUD will be none, but DefaultInventory will cause Select() to cascade here
	if( myHUD != None )
	{
		if( BaseHUD(myHUD) != None )
		{
			BaseHUD(myHUD).SelectItem();
		}

		if( uiHUD(myHUD) == None )
		{
			warn( Self$".ClientSelectItem() myHUD="$myHUD );
			return;
		}

		if( uiHUD(myHUD).IsWindowActive( class'InventoryInfoWindow' ) )
		{
			// "notify" the InventoryInfoWindow that the current object has been changed
			UpdateInventoryInfo();
		}
	}
}

//-----------------------------------------------------------------------------
simulated function ClientSelectItemMessage( name ItemName )
{
	local class<Inventory> InvClass;

	if( ItemName != '' )
	{
		InvClass = class<Inventory>( class'Util'.static.LoadClassFromName( ItemName ) );
		
		if( ClassIsChildOf( InvClass, class'AngrealInventory' ) ) 
		{
			//ClientMessage( "Selected the "$class<AngrealInventory>(InvClass).default.Title$" Ter'Angreal" );
			HandMessage( SelectedStr $ class<AngrealInventory>(InvClass).default.Title $ TerAngrealStr );
		} 
		else if( ClassIsChildOf( InvClass, class'WOTInventory' ) ) 
		{
			//ClientMessage( "Selected the "$class<AngrealInventory>(InvClass).default.Title$" Ter'Angreal" );
			HandMessage( SelectedStr $ class<WOTInventory>(InvClass).default.Title );
		} 
		else if( ClassIsChildOf( InvClass, class'WOTInventory' ) ) 
		{
			//ClientMessage( "Selected the "$class<AngrealInventory>(InvClass).default.Title$" Ter'Angreal" );
			HandMessage( SelectedStr $ class<WOTInventory>(InvClass).default.Title );
		} 
		else if( InvClass != None ) 
		{
			//ClientMessage( "Selected the "$InvClass );
			HandMessage( SelectedStr $ GetItemName(string(InvClass)) );
		}
		else
		{
			//ClientMessage( "Selected the "$ItemName );
			HandMessage( SelectedStr $ GetItemName(string(ItemName)) );
		}
	}
}

//=============================================================================
// Turn the currently selected angreal off.
//=============================================================================
exec function CeaseUsingAngreal()
{
	if( CurrentReflector != None )
	{
		CurrentReflector.CeaseUsingAngreal();
	}
}

//=============================================================================
// Gets rid of all the decals in the level.  (Local system only.)
//=============================================================================
exec function FlushDecals()
{
	local Decal D;

	foreach AllActors( class'Decal', D )
	{
		D.Destroy();
	}
}

//=============================================================================
exec function Drop()
{
    local int i;
    local Inventory Item;
    local vector Loc;
	local BagHolding Bag;
	local float Distance;
    
	// don't allow Citadel Editor inventory to be dropped
	if( CurrentHandSet != AngrealHandSet )
	{
		return;
	}

	// check for SelectedItems that can't be dropped
	if( SelectedItem == None || SelectedItem.Class == DefaultAngrealInventory || SelectedItem.IsA( 'AngrealInvSpecial' ) )
	{
        return;
    }

	Item = SelectedItem;

	// Special handling for angreal.
	if( AngrealInventory(Item) != None )
	{
		// Look for local bags.
		foreach RadiusActors( class'BagHolding', Bag, 160.0 ) break;

		// Make the bag only if we need it.
		if( Bag == None )
		{
			Bag = Spawn( class'BagHolding' );
		}

		DeleteInventory( Item );

		// Restrict charges.
		if( AngrealInventory(Item) != None && AngrealInventory(Item).CurCharges > AngrealInventory(Item).MaxInitialCharges )
		{
			AngrealInventory(Item).CurCharges = AngrealInventory(Item).MaxInitialCharges;
		}
		Bag.AddItem( Item );

		Item = Bag;
	}

	if( Item.IsA( 'Seal' ) && WOTZoneInfo(Region.Zone) != None && WOTZoneInfo(Region.Zone).bPitZone )
	{
		// if the player has died/dropped seals in a pit zone, move the seals to the top of the pit
		Loc = GetPitLocation() + vect(0,0,16);
	}
	else
	{
		// finish moving the item from the player to the world
		if( Item.IsA( 'Seal' ) )
		{
			Distance = CollisionRadius;
		}
		else
		{
			Distance = Item.CollisionRadius + CollisionRadius + 1;
		}
		Loc = Location + ( ( Distance * vect(1,0,0) ) >> Rotation );
	}

	Item.DropFrom( Loc );
}

//-----------------------------------------------------------------------------
exec function DropTainted()
{
	local Inventory Inv;
	
	for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
	{
		if( AngrealInventory(Inv) != None && AngrealInventory(Inv).bTainted )
		{
			SelectedItem = Inv;
			Drop();
		}
	}
}

//-----------------------------------------------------------------------------
exec function DropSeals()
{
	local Inventory Inv;
	
	for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
	{
		if( Inv.IsA( 'Seal' ) )
		{
			SelectedItem = Inv;
			Drop();
		}
	}
}

//=============================================================================
// Do not allow changes to FOV if player is disguised.

exec function SetDesiredFOV(float F)
{
	if( LooksLikeAWOTPlayer() )
	{
		Super.SetDesiredFOV( F );
	}
}

//=============================================================================
// END OF NON-DEBUG/CHEAT EXEC FUNCTIONS.
//=============================================================================

//=============================================================================
function string SlotToStr( ESoundSlot Slot )
{
	switch( Slot )
	{
		case SLOT_None:
			return "SLOT_None";
		case SLOT_Misc:
			return "SLOT_Misc";
		case SLOT_Pain:
			return "SLOT_Pain";
		case SLOT_Interact:
			return "SLOT_Interact";
		case SLOT_Ambient:
			return "SLOT_Ambient";
		case SLOT_Talk:
			return "SLOT_Talk";
		case SLOT_Interface:
			return "SLOT_Interface";
	}

	return "SLOT_Unknown";
}

//=============================================================================

function bool ActorHeadInWater( Actor SourceActor, vector Loc )
{
	local bool bRetVal;
	local ZoneInfo ZoneInfo;

	if( Pawn(SourceActor) != None )
	{
		Loc.Z += Pawn(SourceActor).BaseEyeHeight;
	}
	
	ZoneInfo = GetLocationZoneInfo( Loc );

	bRetVal = ZoneInfo.bWaterZone;

	return bRetVal;
}

//=============================================================================
// Modify non-ambient sounds when player is underwater. Ambient sounds aren't
// relayed through ClientHearSound and these are currently modified in an
// identical fashion in galaxy.cpp (UGalaxyAudioSubsystem::Update).
//
// Drowning and gasping sounds aren't modified since these are usually designed
// to sound as if they are underwater.
//=============================================================================

simulated event ClientHearSound( 
	actor Actor, 
	int Id, 
	sound S, 
	ESoundSlot Slot,
	vector SoundLocation, 
	vector Parameters 
)
{
	local string SoundStr;
	local Name PackageName;
	local string LocalizedStr;

	SoundStr = Caps(string(S));

	// what doesn't get pitched underwater:
	//	any sound played in SLOT_Interface or SLOT_Interact (voiceovers, UI sounds -- should always originate in player)
	//  drowning/gasping sounds (already appropriate for underwater)
	
	// what gets pitched underwater
	//  sounds not in the above which
	//    either originate underwater or are being heard underwater
	//  ambient sounds are pitched in UnGalaxy.cpp.

	if( Slot != SLOT_Interface && Slot != SLOT_Interact )
	{
		if( (instr(SoundStr, "DROWN") == -1) && (instr(SoundStr, "GASP") == -1) )
		{
			// not a drowning/gasping sound
			
			// modify the sound's pitch etc. in water?
			if( HeadRegion.Zone.bWaterZone || 
				((SoundLocation != Location) && ActorHeadInWater( Actor, SoundLocation )) )
			{
				// hearer underwater or sound source underwater 

				// the following seem to work well (if you change these, 
				// might want to change UnGalaxy.cpp as well)
				Parameters.x *= 0.90;	// volume
				Parameters.y *= 0.80;	// radius
				Parameters.z *= 0.85;	// pitch
			}
		}
	}

 	// if there is a subtitle associated with this sound, display it
	if( bSubtitles )
	{
		// tbd: only map slot talk, interact? LDs probably used other slots for tutorial etc. though.
		if( (SoundStr != "" ) && (Left( SoundStr, 4 ) != "WOT.") && (Left( SoundStr, 8 ) != "Angreal.") && S != None )
		{
			PackageName = S.Outer.Name;

			LocalizedStr = Localize( string(PackageName), string(S.Name), string(SubtitlesPackageName), true );
			if( LocalizedStr != "" )
			{
				SubtitleMessage( LocalizedStr, Max( MinMessageDuration, Len(LocalizedStr)*MessageDurationSecsPerChar), true );
			}										
			else if( bShowLocalizeSoundErrors )
			{
				warn( "ClientHearSound: couldn't localize: " $ S );
				ClientMessage( "ClientHearSound: couldn't localize: " $ S );
			}
		}
	}

	if( bShowSounds )
	{
		// testing: show any non-texture/ambient sounds
		if( (instr( SoundStr, "WOT.RUNNING" ) == -1) && 
			(instr( SoundStr, "WOT.LANDED" ) == -1)  && 
			(instr( SoundStr, "AMBIENT" ) == -1) )
		{
			// debugging: log all sounds passing through ClientHearSound
			log( Level.TimeSeconds $ ": " $ SoundStr $ " Slot: " $ SlotToStr(Slot) $ " Vol: " $ Parameters.x $ " Radius: " $ Parameters.y $ " Pitch: " $ Parameters.z );
			ClientMessage( Level.TimeSeconds $ ": " $ SoundStr $ " Slot: " $ SlotToStr(Slot) $ " Vol: " $ Parameters.x $ " Radius: " $ Parameters.y $ " Pitch: " $ Parameters.z );
		}
	}

	if( bShowOtherSounds )
	{
		// testing: show any texture/ambient sounds
		if( (instr( SoundStr, "WOT.RUNNING" ) != -1) || 
			(instr( SoundStr, "WOT.LANDED" ) != -1)  || 
			(instr( SoundStr, "AMBIENT" ) != -1) )
		{
			// debugging: log all sounds passing through ClientHearSound
			log( Level.TimeSeconds $ ": " $ SoundStr $ " Slot: " $ SlotToStr(Slot) $ " Vol: " $ Parameters.x $ " Radius: " $ Parameters.y $ " Pitch: " $ Parameters.z );
			ClientMessage( Level.TimeSeconds $ ": " $ SoundStr $ " Slot: " $ SlotToStr(Slot) $ " Vol: " $ Parameters.x $ " Radius: " $ Parameters.y $ " Pitch: " $ Parameters.z );
		}
	}

	Super.ClientHearSound ( Actor, Id, S, Slot, SoundLocation, Parameters );
}

/////////////////////////
// Reflected functions //
/////////////////////////

//-----------------------------------------------------------------------------
// This is the only function that is allowed to call Invokable::Invoke()
//-----------------------------------------------------------------------------
function ProcessEffect( Invokable I )
{
	if( CurrentReflector != None )
	{
		CurrentReflector.ProcessEffect( I );	// Reflect function call.
	}

}

//-----------------------------------------------------------------------------
// Returns the best target that it can find for a seeking projectile.
//-----------------------------------------------------------------------------
function Actor FindBestTarget( vector Loc, rotator ViewRot, float MaxAngleInDegrees, optional AngrealInventory UsingArtifact )
{
	if( CurrentReflector != None )
	{
		return CurrentReflector.FindBestTarget( Loc, ViewRot, MaxAngleInDegrees, UsingArtifact );
	}
	else
	{
		warn( "This function shouldn't be called on the client." );
		return None;
	}
}

//-----------------------------------------------------------------------------
// Increases the health of the pawn by the given amount.
//-----------------------------------------------------------------------------
function IncreaseHealth( int Amount )
{
	if( CurrentReflector != None )
	{
		CurrentReflector.IncreaseHealth( Amount );	// Reflect function call.
	}
}

//------------------------------------------------------------------------------
// Called by angreal projectiles to notify the victim what just hit them.
//------------------------------------------------------------------------------
simulated function NotifyHitByAngrealProjectile( AngrealProjectile HitProjectile )
{
	if( CurrentReflector != None )
	{
		CurrentReflector.NotifyHitByAngrealProjectile( HitProjectile );
	}
}

//------------------------------------------------------------------------------
// Called by seeker angreal to notify the victim that it has just targeted it.
//------------------------------------------------------------------------------
function NotifyTargettedByAngrealProjectile( AngrealProjectile Proj )
{
	if( CurrentReflector != None )
	{
		CurrentReflector.NotifyTargettedByAngrealProjectile( Proj );
	}
}

//===========================================================================
// Overridden so we can control when WOTPlayers gib.

function bool Gibbed( Name DamageType )
{
	return !bNeverGib && class'WOTUtil'.static.WOTGibbed( Self, DamageType, GibForSureFinalHealth, GibSometimesFinalHealth, GibSometimesOdds );
}

//===========================================================================
// Disable telefragging
//---------------------------------------------------------------------------
event EncroachedBy( actor Other );

//===========================================================================
// Reflect this function call.
// MAY override; if so, must call parent function 
//===========================================================================
function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, vector Momentum, name DamageType )
{
	//TBI -- call ReduceDamage first -- if Damage==0, then don't respond to attacks!

	if( DamageType == 'SkewRip' )
	{
		//Warder's thrust/lift attack
		GotoState( 'Impaled' );
	}
	else if( DamageType == 'Grabbed' )
	{
		//Minion's tentacle grab
		GotoState( 'Grabbed' );
	}
	if( Damage > MinDamageToShake )
	{
		DamageShake( Damage );
	}
	if( CurrentReflector != None )
	{
		CurrentReflector.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	}
}

//=============================================================================

function KilledBy( pawn EventInstigator )
{
	TakeDamage( Health-GibSometimesFinalHealth, EventInstigator, Location, vect(0,0,0), 'Suicided' );
}

//------------------------------------------------------------------------------
// This is a hack:  It is used by DefaultTakeDamageReflector.
//------------------------------------------------------------------------------
function SuperTakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, vector Momentum, name DamageType)
{
	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
}

//-----------------------------------------------------------------------------
function FootZoneChange( ZoneInfo newFootZone )
{
	if( CurrentReflector != None )
	{
		CurrentReflector.FootZoneChange( newFootZone );
	}
	else
	{
		Super.FootZoneChange( newFootZone );
	}
}

//------------------------------------------------------------------------------
// This is a hack:  It is used by WOTFootZoneChangeReflector.
//------------------------------------------------------------------------------
function SuperFootZoneChange( ZoneInfo newFootZone )
{
	Super.FootZoneChange( newFootZone );
}

//------------------------------------------------------------------------------
// View shaking caused by player receiving damage. 
//------------------------------------------------------------------------------
// Get rid of damage if we don't scale shaking by damage amount..
function DamageShake( int Damage )
{
	ShakeView( 0.2, 2500, -50 );
}

//------------------------------------------------------------------------------
// Notification for when a charge has been used.
//------------------------------------------------------------------------------
function ChargeUsed( AngrealInventory Ang )
{
	if( CurrentReflector != None )
	{
		CurrentReflector.ChargeUsed( Ang );
	}
}

//===========================================================================
function AddIconInfo( Actor DurationActor, bool bGoodIcon, name IconID )
{
    local IconInfo curII;
	local AngrealInventory Inv;
	local float Duration;
	local Texture Icon;
	
	if( Leech(DurationActor) != None )
	{
		Inv = Leech(DurationActor).SourceAngreal;
		if( Leech(DurationActor).StatusIconFrame != None )
		{
			Icon = Leech(DurationActor).StatusIconFrame;
		}
		else if( Inv != None )
		{
			Icon = Inv.StatusIconFrame;
		}
		else
		{
			warn( "Leech has neither a SourceAngreal nor a StatusIconFrame, therefore we cannot display an icon for it." );
			return;
		}
		Duration = Leech(DurationActor).GetInitialDuration();
	}
	else if( Reflector(DurationActor) != None )
	{
		Inv = Reflector(DurationActor).SourceAngreal;
		if( Reflector(DurationActor).StatusIconFrame != None )
		{
			Icon = Reflector(DurationActor).StatusIconFrame;
		}
		else if( Inv != None )
		{
			Icon = Inv.StatusIconFrame;
		}
		else
		{
			warn( "Reflector has neither a SourceAngreal nor a StatusIconFrame, therefore we cannot display an icon for it." );
			return;
		}
		Duration = Reflector(DurationActor).GetInitialDuration();
	} 
	else if( AngrealInventory(DurationActor) != None )
	{
		Inv = AngrealInventory(DurationActor);
		if( Inv.StatusIconFrame != None )
		{
			Icon = Inv.StatusIconFrame;
		}
		else
		{
			warn( "AddIconInfo called for AngrealInventory with no StatusIconFrame." );
		}
		Duration = AngrealInventory(DurationActor).GetDuration();
	}
	else 
	{
		warn( "Illegal IconInfo" );
		return;
	}

    if( IconID == '' )
	{
		warn( "IconID not set." );
		return;
	}
	
	curII = FindIconInfo( IconID );

    // Update texture if it's already in the list.  This handles cases where
    // player is disguised as one guy, and then changes his disguise to
    // something else.
    if( curII == None ) 
	{
        curII = Spawn( class 'IconInfo', self, IconID );
	    curII.Next = FirstIcon;
	    FirstIcon = curII;
	}
	curII.Inv = DurationActor;
    curII.Icon = Icon;
    curII.bGoodIcon = bGoodIcon;
	curII.InitialDuration = Duration;
	curII.RemainingDuration = curII.InitialDuration;
}

function NotifyAutoSwitch()
{
	PlaySound( Sound( DynamicLoadObject( "WOT.Effect.SelectNewItem", class'Sound' ) ) );
}

//-----------------------------------------------------------------------------
function ServerUseAngreal()
{
	if( CurrentReflector != None )
	{
		CurrentReflector.UseAngreal();
	}
}

//-----------------------------------------------------------------------------
function NotifyCastFailed( AngrealInventory FailedArtifact )
{
	if( CurrentReflector != None )
	{
		CurrentReflector.NotifyCastFailed( FailedArtifact );
	}
}

//-----------------------------------------------------------------------------
function SetSuicideInstigator( Pawn Other )
{
	SuicideInstigator = Other;
	SuicideInstigationTime = Level.TimeSeconds;
}


//-----------------------------------------------------------------------------
function HandMessage( string Message, optional float Duration )
{
	if( BaseHUD( myHUD ) != None )
	{
		BaseHUD( myHUD ).AddHandMessage( Message, Duration );
	}
}

//-----------------------------------------------------------------------------
function LeftMessage( string Message, optional float Duration )
{
	if( BaseHUD( myHUD ) != None )
	{
		BaseHUD( myHUD ).AddLeftMessage( Message, Duration );
	}
}

//-----------------------------------------------------------------------------
function RightMessage( string Message, optional float Duration )
{
	if( BaseHUD( myHUD ) != None )
	{
		BaseHUD( myHUD ).AddRightMessage( Message, Duration );
	}
}

//-----------------------------------------------------------------------------
function CenterMessage( string Message, optional float Duration, optional bool bEcho )
{
	if( BaseHUD( myHUD ) != None )
	{
		BaseHUD( myHUD ).AddCenterMessage( Message, Duration, bEcho );
	}
}

//-----------------------------------------------------------------------------
function SubtitleMessage( string Message, optional float Duration, optional bool bEcho )
{
	if( BaseHUD( myHUD ) != None )
	{
		BaseHUD( myHUD ).AddSubtitleMessage( Message, Duration, bEcho );
	}
}

//-----------------------------------------------------------------------------
function GenericMessage( string Message, int X, int Y, bool bCenter, byte Intensity, Font F, optional float Duration )
{
	if( BaseHUD( myHUD ) != None )
	{
		BaseHUD( myHUD ).AddGenericMessage( Message, X, Y, bCenter, Intensity, F, Duration );
	}
}

//-----------------------------------------------------------------------------
function BroadcastLeftMessage( string Message, optional float Duration )
{
	local Pawn P;
	if( Level.Game.AllowsBroadcast( Self, Len(Message) ) )
		for( P=Level.PawnList; P!=None; P=P.NextPawn )
			if( WOTPlayer(P) != None )
				WOTPlayer(P).LeftMessage( Message, Duration );
}

//-----------------------------------------------------------------------------
function BroadcastRightMessage( string Message, optional float Duration )
{
	local Pawn P;
	if( Level.Game.AllowsBroadcast( Self, Len(Message) ) )
		for( P=Level.PawnList; P!=None; P=P.NextPawn )
			if( WOTPlayer(P) != None )
				WOTPlayer(P).RightMessage( Message, Duration );
}

//-----------------------------------------------------------------------------
function BroadcastCenterMessage( string Message, optional float Duration, optional bool bEcho )
{
	local Pawn P;
	if( Level.Game.AllowsBroadcast( Self, Len(Message) ) )
		for( P=Level.PawnList; P!=None; P=P.NextPawn )
			if( WOTPlayer(P) != None )
				WOTPlayer(P).CenterMessage( Message, Duration, bEcho );
}

//-----------------------------------------------------------------------------
function ClientMessage( coerce string S, optional name Type, optional bool bBeep )
{
	if( S != "" )
	{
		if( Type == 'Pickup' )
		{
			HandMessage( S );
		}
		else if( Type == 'WOTDeathMessage' )
		{
			if( Level.NetMode != NM_Standalone )
			{
				RightMessage( S );
			}
		}
		else if( Type == 'DeathMessage' )
		{
			// Depricated.
		}
		else if( Type == 'FailedMessage' )
		{
			HandMessage( S );
		}
		else
		{
			Super.ClientMessage( S, Type, bBeep );
		}
	}
}



//=============================================================================
// Returns IconInfo corresponding to `IconTag' from FirstIcon list. 
// Might return None.
//-----------------------------------------------------------------------------

function IconInfo FindIconInfo( name IconTag )
{
    local IconInfo  curII;

    for( curII = FirstIcon; curII != None; curII = curII.Next )
        if( curII.Tag == IconTag )
            return curII;

    return None;
}

//=============================================================================

function byte GetApparentTeam() 
{
	if( ApparentTeam == -1 )
	{
		return PlayerReplicationInfo.Team;
	}
	else
	{
	    return ApparentTeam;
	}
}

//=============================================================================

function ScaleSpeedSettings( float Multiplier )
{
	GroundSpeed = Multiplier * ApparentClass.default.GroundSpeed;
	WaterSpeed	= Multiplier * ApparentClass.default.WaterSpeed;
	AirControl	= Multiplier * ApparentClass.default.AirControl;
	AccelRate	= Multiplier * ApparentClass.default.AccelRate;
}

//=============================================================================

function ScaleSpeedForDirection()
{
	// if SetSpeed cheat was used, leave current values alone
	if( !bSetSpeedCheatOn )
	{
		if( MotionDirection == MD_Backward )
		{
			// player is backing up -- reduce his GroundSpeed etc.
			ScaleSpeedSettings( WalkBackwardSpeedMultiplier );
		}
		else
		{
			// player isn't backing up -- restore his GroundSpeed etc.
			ScaleSpeedSettings( 1.0 );
		}
	}
}

//=============================================================================
// Sets MotionDirection (general direction of motion of the given the motion 
// vector). Logical values for MotionVec and Velocity and/or Acceleration.
//=============================================================================

function SetMotionDirection( vector MotionVec ) //RLO Pitch isn't working, so never get Down/Up
{
    local rotator RotDiff;
    local rotator VelocityAsRot;
	local EMotionDirection NewMotionDirection;

    if( VSize(MotionVec) ~= 0.0 )
	{
        NewMotionDirection = MD_None;
    }
	else
	{    
	    VelocityAsRot = rotator(MotionVec);
	    RotDiff = Normalize( ViewRotation - VelocityAsRot );
	
	    if( -8192 <= RotDiff.Yaw && RotDiff.Yaw <= 8192 )
		{
			// moving forward
	        NewMotionDirection = MD_Forward;
	    }
	    else if( 8192 <= RotDiff.Yaw && RotDiff.Yaw <= 24576 )
		{
			// strafing left
	        NewMotionDirection = MD_Left;
	    }
	    else if( -24576 <= RotDiff.Yaw && RotDiff.Yaw <= -8192 )
		{
			// strafing right
	        NewMotionDirection = MD_Right;
		}
		else
		{
			// moving backwards
			NewMotionDirection = MD_Backward;
		}
	}

	// disables changing GroundSpeed etc. in MP for now -- replication issues
	if( Level.Netmode == NM_Standalone )
	{
		if( MotionDirection != NewMotionDirection )
		{
		    MotionDirection = NewMotionDirection;
			ScaleSpeedForDirection();
		}
	}

	MotionDirection = NewMotionDirection;
}

//=============================================================================

function GoTakeHit( name HitAnimSequence )
{
    NextAnim = HitAnimSequence;
    NextState = GetStateName();
    GotoState( 'TakeHit' );
}

//=============================================================================
// Overridden to allow us to swap sequence if player is disguised. Ideally we
// would make GetAnimGroup non-final but apparently non-indexed functions have
// replication issues.

function Name GetAnimGroupSub( Name Sequence )
{
	local Name ReturnedSequence;

	// this function is called a lot -- don't add too much overhead
    if( bFire==0 || !LooksLikeAWOTPawn() )
	{
		return GetAnimGroup( Sequence );
	}
	else
	{
	    ReturnedSequence = class<WOTPawn>( ApparentClass ).static.SubstituteAnimName( Sequence );
	
		if( GetAnimFrames( ReturnedSequence ) == 0 )
		{
			// if replication hasn't caught up yet its possible for the mesh and
			// ApparentClass and Mesh to get out of sync, so use a 'safe' anim
			ReturnedSequence = 'Breath';
		}
	
		return GetAnimGroup( ReturnedSequence );
	}
}	

//=============================================================================
// Returns `true' if player currently looks like the given
// class, taking into account the player's disguise, if any.
//-----------------------------------------------------------------------------

final function bool LooksLikeA( class ClassName )
{
	return ClassIsChildOf( ApparentClass, ClassName );
}

//=============================================================================
// Returns `true' if player currently looks like any WOTPlayer-derived
// class, taking into account the player's disguise, if any.
//-----------------------------------------------------------------------------

final function bool LooksLikeAWOTPlayer()
{
	return LooksLikeA( class'WOTPlayer' );
}

//=============================================================================
// Returns `true' if player currently looks like any WOTPawn-derived
// class, taking into account the player's disguise, if any.
//-----------------------------------------------------------------------------

final function bool LooksLikeAWOTPawn()
{
	return LooksLikeA( class'WOTPawn' );
}

//=============================================================================
// Returns anim sequence name based on the input name.  The only time the
// return value doesn't match the input is when the player is disguised.
//-----------------------------------------------------------------------------

final function name LookupAnimSequence( name AnimSequenceName )
{
    if( LooksLikeAWOTPawn() )
	{
        return class<WOTPawn>( ApparentClass ).static.SubstituteAnimSlotName( AnimSequenceName );
	}

    return AnimSequenceName;
}



function bool IsExceptionalDeath()
{
	return ( Health < -ExceptionalDeathHealthRatio * default.Health );
}

//=============================================================================
// We play death anim in PlayDeathHit -- this function in Pawn does nothing useful.

function PlayDying(name DamageType, vector HitLoc);

//=============================================================================

function PlayDeathHit( float Damage, vector HitLocation, name DamageType )
{
	if( !LooksLikeA( PlayerClass ) )
	{
		// will be called again in Died, but we need to make sure player not
		// disguised etc. when picking death animation (could overrride
		// PlayDeathHit to do nothing and call this code from Died but pbly
		// not a good idea to mess with this at this point).
		CancelAngrealEffects();
	}

    BaseEyeHeight = Default.BaseEyeHeight;

	PlayerClass.default.AnimationTableClass.static.TweenPlaySlotAnim( Self, DeathAnimSlot );   

	if( !Gibbed( DamageType ) || ( Level.NetMode == NM_Standalone && GetGoreDetailLevel() <= 1 ) )
	{
	    if( IsExceptionalDeath() )
		{
			MySoundTable.PlaySlotSound( Self, MySoundTable.DieHardSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
		}
		else
		{
			MySoundTable.PlaySlotSound( Self, MySoundTable.DieSoftSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
		}
	}
}

//=============================================================================
// The player wants to fire.

function PlayFiring()
{
	// switch animation sequence mid-stream if needed
    if( AnimSequence == LookupAnimSequence( RunAnimSlot ) )
	{
        AnimSequence = LookupAnimSequence( AttackRunAnimSlot );
	}
    else if( AnimSequence == RunLAnimSlot )
	{
        AnimSequence = LookupAnimSequence( AttackRunLAnimSlot );
	}
    else if( AnimSequence == RunRAnimSlot )
	{
        AnimSequence = LookupAnimSequence( AttackRunRAnimSlot );
	}
    else if( AnimSequence == WalkAnimSlot )
	{
        AnimSequence = LookupAnimSequence( AttackWalkAnimSlot );
	}
    else
	{
		AnimationTableClass.static.TweenSlotAnim( Self, LookupAnimSequence(AttackAnimSlot) );   
	}
}



function bool IsHardHit( int Damage )
{
	return ( Damage >= HitHardHealthRatio * default.Health );
}



//=============================================================================

function PlayTakeHit( float tweentime, vector HitLoc, int Damage )
{
	if( IsHardHit(Damage) )	
	{
		AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence(HitHardAnimSlot) );
	}
	else
	{
		AnimationTableClass.static.TweenSlotAnim( Self, LookupAnimSequence(HitAnimSlot) );
	}
}



function Gasp()
{
	if ( Role == ROLE_Authority )
	{
		MySoundTable.PlaySlotSound( Self, MySoundTable.GaspSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
	}
}



// WOT override
function PlayTakeHitSound( int Damage, name damageType, int Mult )
{
	if( DamageType != 'fell' )
	{
	 	if ( Level.TimeSeconds >= NextPainSoundTime )
		{
			NextPainSoundTime = Level.TimeSeconds + RandRange( TimeBetweenHitSoundsMin, TimeBetweenHitSoundsMax );
	
			if ( damageType == 'drowned' )
			{
				MySoundTable.PlaySlotSound( Self, MySoundTable.DrownSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
			}
			else if( IsHardHit( Damage) )
			{
				MySoundTable.PlaySlotSound( Self, MySoundTable.HitHardSoundSlot, Mult*VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
			}
			else
			{
				MySoundTable.PlaySlotSound( Self, MySoundTable.HitSoftSoundSlot, Mult*VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
			}
		}
	}
}


//=============================================================================

function PlayHit( float Damage, vector HitLocation, name DamageType, float MomentumZ )
{
    local float rnd;

    if( damage <= 0 && ReducedDamageType != 'All' )
	{
		return;
	}

    // pain flashes
    rnd = FClamp(Damage, 20, 40);
	if( InStr( string(DamageType), "NoFlash" ) != -1 ) { /*do nothing*/ }
    else if( class'AngrealInventory'.static.DamageTypeContains( damageType, 'Fire' ) )	ClientFlash( -0.009375 * rnd, rnd * vect(16.41, 11.719, 4.6875) );	//yellow
    else if( class'AngrealInventory'.static.DamageTypeContains( damageType, 'Air' ) )	ClientFlash( -0.390, vect(312.5,468.75,468.75));					//light blue
    else if( class'AngrealInventory'.static.DamageTypeContains( damageType, 'Earth' ) )	ClientFlash( -0.01171875 * rnd, rnd * vect(9.375, 14.0625, 4.6875));//green
    else if( class'AngrealInventory'.static.DamageTypeContains( damageType, 'Water' ) )	ClientFlash( -0.390, vect(312.5,468.75,468.75));					//light blue
    else if( class'AngrealInventory'.static.DamageTypeContains( damageType, 'Spirit' ) )ClientFlash( -0.390, vect(312.5,468.75,468.75));					//light blue
    else 																				ClientFlash( -0.019 * rnd, rnd * vect(26.5, 4.5, 4.5));				//red

    ShakeView( 0.15 + 0.005 * Damage, Damage * 30, 0.3 * Damage );

    PlayTakeHitSound( Damage, DamageType, 1.0 );

    if( Damage > 0.25 * Default.Health || MomentumZ > 300 )
	{
        PlayTakeHit( 0.2, HitLocation, Damage );
    }
}

//=============================================================================

function PlayInAir()
{
	if( bMovable )
	{
		// regular jump
	    BaseEyeHeight = 0.7 * ApparentClass.default.BaseEyeHeight;

		AnimationTableClass.static.TweenSlotAnim( Self, LookupAnimSequence(JumpAnimSlot) );   
	}
}

//=============================================================================
// Bit different than the Unreal approach. We have actual falling animations (1
// frame currently) so in order to show these, we tween to them once the player
// starts to fall (if we called PlayInAir here, the falling animation would be
// stomped with the jump animation). We also update the BaseEyeHeight since if 
// you simply walk off a ledge, there is no jump and therefore (because of 
// these changes) no call to PlayInAir. Note that when a player jumps, his 
// physics are set to PHYS_FALLING (so he can "get some air") but no Falling
// event is generated. This means that if the player jumps into the air, he/she
// will stay in the jump animation until landing, whereas if the player walks
// off a ledge, he will use the falling animation since there will be no jump
// but Falling() will be called by the engine.

function Falling()
{
	// in case no jump
    BaseEyeHeight = 0.7 * ApparentClass.default.BaseEyeHeight;

	AnimationTableClass.static.TweenSlotAnim( Self, LookupAnimSequence(FallAnimSlot) );   
}

//=============================================================================

function DoJump( optional float F )
{
	if( CarriedDecoration == None )
	{
		if( !bIsCrouching && ( Physics == PHYS_Walking ) )
		{
			if( MySoundTable != None )
			{
				MySoundTable.PlaySlotSound( Self, MySoundTable.JumpSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
			}

			if( ( Level.Game != None ) && ( Level.Game.Difficulty > 0 ) )
			{
				// 0.1 is *way* to quiet -- can't hear from any distance
				// not difficulty dependent for now
				MakeNoise(1.0 /*0.1 * Level.Game.Difficulty*/ );
			}

			PlayInAir();

			Velocity.Z = JumpZ;

			if( Base != Level )
			{
				Velocity.Z += Base.Velocity.Z; 
			}

			SetPhysics(PHYS_Falling);

			if( bCountJumps && Inventory != None && ( Role == ROLE_Authority ) )
			{
				Inventory.OwnerJumped();
			}
		}
	}
}



//=============================================================================

function PlayLanded( float ImpactVelocity )
{
	if( ImpactVelocity <= -SpeedPlayAnimAfterLanding )
	{
		GotoState( 'PlayerLanded' );
	}
	else
	{
		// have to do this even for minor landings or models "never land"
		AnimationTableClass.static.TweenSlotAnim( Self, LookupAnimSequence(LandAnimSlot) );   
	}
}



//=============================================================================

function LandedOnLadder()
{
	if( VSize( Velocity ) < LadderLandingNoiseVelocity )
	{
		MakeNoise( 1.0 );
	}

	TweenToRunning( 0.1 );
}



//=============================================================================

function Landed( vector HitNormal )
{
	local float Damage;

	if( HitNormal.Z <= LadderLandedHitNormalZ )
	{
		LandedOnLadder();
	}
	else 
	{
		if( Velocity.Z < -1.4 * JumpZ )
		{
			MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
			
			if( Role == ROLE_Authority && Velocity.Z <= -1100 )
			{
				if( (Velocity.Z < -2000) && (ReducedDamageType != 'All') )
				{
					Damage = Health + 250; //make sure gibs (and spawns lotsa blood)
				}
				else
				{
					Damage = -0.15 * (Velocity.Z + 1050);
				}

				TakeDamage( Damage, None, Location, vect(0,0,0), 'fell' );
			}
		}
		else if( (Level.Game != None) && (Level.Game.Difficulty > 1) && (Velocity.Z > 0.5 * JumpZ) )
		{
			MakeNoise( 0.1 * Level.Game.Difficulty );				
		}

		if( Health > 0 )
		{
			// still alive: record landing for texture sound, play anim, appropriate sound

			// pawn is in the air so texture is None, but sound will be played with next walktexture
			if( AssetsHelper != None )
			{
				AssetsHelper.HandleLandedOnTexture( Velocity.Z );
			}

			PlayLanded( Velocity.Z );

			if( MySoundTable != None )
			{			
				if( Velocity.Z <= -PlayLandHardMinVelocity )
				{
					MySoundTable.PlaySlotSound( Self, MySoundTable.LandHardSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
				}
				else if( Velocity.Z <= -PlayLandSoftMinVelocity )
				{
					MySoundTable.PlaySlotSound( Self, MySoundTable.LandSoftSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
				}
			}
		}

		bJustLanded = true;
	}
}



//=============================================================================

function PlayMovementSound()
{
	if( AssetsHelper != None )
	{
		AssetsHelper.HandleMovingOnTexture();
	}
}



//=============================================================================

function PlayRunning()
{
    BaseEyeHeight = ApparentClass.default.BaseEyeHeight;

	SetMotionDirection( Acceleration );
    switch( MotionDirection ) 
	{
		case MD_None:         
			PlayWaiting();                               
			break;

		case MD_Forward:      
		case MD_Backward:     
			if( bFire != 0 )
			{
				AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(AttackRunAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed );   
			}
			else
			{
	 			AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(RunAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed );   
			}
			break;

		case MD_Left:         
			if( bFire != 0 )
			{
	 			AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(AttackRunLAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed );   
			}
			else
			{
	 			AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(RunLAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed );   
			}
			break;

		case MD_Right:        
			if( bFire != 0 )
			{
	 			AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(AttackRunRAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed );   
			}
			else
			{
	 			AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(RunRAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed );   
			}
			break;

	    default: 
			warn( "Class " $ Class $ "::PlayRunning() doesn't handle case " $ MotionDirection );

			if( bFire != 0 )
			{
	 			AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(AttackRunAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed );   
			}
			else
			{
	 			AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(RunAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed );   
			}
    }
}

//=============================================================================

function PlaySwimming()
{
    BaseEyeHeight = 0.5 * ApparentClass.default.BaseEyeHeight;

	AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(SwimAnimSlot) );   
}

//=============================================================================

function PlayBreathing()
{
    BaseEyeHeight = ApparentClass.default.BaseEyeHeight;

	if( FRand() < 0.90 )
	{
		AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(BreathAnimSlot) );   
	}
	else
	{
		AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(LookAnimSlot) );   
	}
}

//=============================================================================

function PlayWaiting()
{
    if( IsInState( 'PlayerSwimming' ) || Physics == PHYS_Swimming ) 
	{
		PlaySwimming();
	} 
	else 
	{
		PlayBreathing();
    }
}

//=============================================================================
// PlayWalking

function PlayWalking()
{
    BaseEyeHeight = ApparentClass.default.BaseEyeHeight;

	SetMotionDirection( Acceleration );
    switch( MotionDirection ) 
	{
	    case MD_None:         
	    case MD_Forward:      
	    case MD_Backward:     
		case MD_Left:         
		case MD_Right:        
			if( bFire != 0 )
			{
	 			AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(AttackWalkAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed );   
			}
			else
			{
	 			AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(WalkAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed );   
			}
			break;

		default: 
			warn( "Class " $ Class $ "::PlayWalking() doesn't handle case " $ MotionDirection );
 			AnimationTableClass.static.LoopSlotAnim( Self, LookupAnimSequence(WalkAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed );   
    }
}

//=============================================================================
// TweenToRunning

function TweenToRunning( float TweenTime )
{
    BaseEyeHeight = ApparentClass.default.BaseEyeHeight;
        
    if( bIsWalking ) 
	{
        TweenToWalking( 0.1 );
    }
    else 
	{
		SetMotionDirection( Acceleration );
        switch( MotionDirection ) 
		{
			case MD_None:
	        case MD_Forward:
		    case MD_Backward:     
				if( bFire != 0 )
				{
					AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence(AttackRunAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed, TweenTime );   
				}
				else
				{
					AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence(RunAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed, TweenTime );   
				}
				break;

			case MD_Left:         
				if( bFire != 0 )
				{
					AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence( AttackRunLAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed, TweenTime );   
				}
				else
				{
					AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence( RunLAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed, TweenTime );   
				}
				break;

	        case MD_Right:        
				if( bFire != 0 )
				{
					AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence( AttackRunRAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed, TweenTime );   
				}
				else
				{
					AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence( RunRAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed, TweenTime );   
				}
				break;

	        default: 
				warn( "Class " $ Class $ "::TweenToRunning() doesn't handle case " $ MotionDirection );

				if( bFire != 0 )
				{
					AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence( AttackRunRAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed, TweenTime );   
				}
				else
				{
					AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence( RunRAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed, TweenTime );   
				}
        }
    }
}

//=============================================================================

function TweenToSwimming( float TweenTime )
{
    BaseEyeHeight = 0.8 * ApparentClass.default.BaseEyeHeight;

	// no swimming+firing animation so just swim
	AnimationTableClass.static.TweenSlotAnim( Self, LookupAnimSequence(SwimAnimSlot) );   
}

//=============================================================================

function TweenToBreathing( float TweenTime )
{
	BaseEyeHeight = ApparentClass.default.BaseEyeHeight;

	if ( bFire != 0 && ApparentTeam == -1 )
	{
		// firing and not disguised (can't really fire while disguised)
		AnimationTableClass.static.TweenSlotAnim( Self, LookupAnimSequence(AttackAnimSlot), TweenTime );   
	}
	else
	{
		AnimationTableClass.static.TweenSlotAnim( Self, LookupAnimSequence(BreathAnimSlot), TweenTime );   
	}
}

//=============================================================================

function TweenToWaiting( float TweenTime )
{
    if( IsInState( 'PlayerSwimming' ) || Physics == PHYS_Swimming ) 
	{
        TweenToSwimming( TweenTime );
    } 
	else 
	{
        TweenToBreathing( TweenTime );
    }
}

//=============================================================================
// TweenToWalking

function TweenToWalking( float TweenTime )
{
    BaseEyeHeight = ApparentClass.default.BaseEyeHeight;

	SetMotionDirection( Acceleration );
    switch( MotionDirection ) 
		{
	    case MD_None:
		case MD_Forward:
	    case MD_Backward:
		case MD_Left:         
        case MD_Right:        
			if( bFire != 0 )
			{
				AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence(AttackWalkAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed, TweenTime );   
			}
			else
			{
				AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence(WalkAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed, TweenTime );   
			}
			break;

		default: 
			warn( "Class " $ Class $ "::TweenToWalking() doesn't handle case " $ MotionDirection );
			AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence(WalkAnimSlot), GroundSpeed/ApparentClass.default.GroundSpeed, TweenTime );   
    }
}

//---------------------------------------------------------------------------
function SetSoundTable( SoundTableWOT SoundTable )
{
	MySoundTable = SoundTable;
}

//---------------------------------------------------------------------------
function SetSoundSlotTimerList( SoundSlotTimerListInterf SoundSlotTimerList )
{
	MySoundSlotTimerList = SoundSlotTimerList;
}

//---------------------------------------------------------------------------
function SetupAssetClasses()
{
	if( CurrentReflector != None )
	{
		CurrentReflector.SetupAssetClasses();
	}
}

//===========================================================================
// Assumes players only have one skin, possibly with several maps (but then
// again, so does a lot of other code). Also assumes that MultiSkins[1] is 
// correctly set for all player classes.

function SetSkin( Texture NewSkin )
{
	local int i;
	local string SkinName;

	if( NewSkin == None )
	{
		NewSkin = PlayerClass.default.MultiSkins[1];
	}

    Skin = NewSkin;
	for( i=0; i<ArrayCount(MultiSkins); i++ )
	{
		MultiSkins[i]=NewSkin;
	}

	// make sure we go off of the correct skin since it may not be set to given SkinName above
	SkinName = string(NewSkin);
		
	// Update PlayerReplicationInfo.
	if		( InStr( SkinName, "Black"	)	!= -1 )	PlayerReplicationInfo.Color = 1;
	else if	( InStr( SkinName, "Blue"	)	!= -1 )	PlayerReplicationInfo.Color = 2;
	else if	( InStr( SkinName, "Red"	)	!= -1 )	PlayerReplicationInfo.Color = 3;
	else if	( InStr( SkinName, "Green"	)	!= -1 )	PlayerReplicationInfo.Color = 4;
	else                                            PlayerReplicationInfo.Color = 0;
}

//===========================================================================
simulated function PreBeginPlay()
{
	local int i;
	local AngrealInventory DefaultAngreal;
	local Reflector DefaultReflector;
	local string LevelName;
	local string SkinName;

    Super.PreBeginPlay();

	// initialize the player class with the concrete class (modified when the player changes classes)
	PlayerClass = Class;

	if( Role == ROLE_Authority )
	{
		CreateAngrealHands(); // build hands before accepting inventory during level load and SP level transition

		////////////////////////////////////
		// Default Reflector Installation //
		////////////////////////////////////
		for( i = 0; i < ArrayCount(DefaultReflectorClasses); i++ )
		{
			if( DefaultReflectorClasses[i] != None )
			{
				DefaultReflector = Spawn( DefaultReflectorClasses[i] );
				DefaultReflector.Install( self );
			}
		}

		bIsPlayer = true;
    
		// single-player specific code to change main
		// Player Character's skin from mission_xx on
		if( Level.Netmode == NM_Standalone )
		{
			// force base skin
			SetSkin( PlayerClass.default.MultiSkins[1] );
	
			if( AltSkinStr != "" )
			{
				LevelName = Level.GetLocalURL();

				LevelName = Caps(LevelName);
				i = InStr( LevelName, "MISSION_" );

				if( i != -1 )
				{
					LevelName = Mid( LevelName, i+8, 2 );
					i = int( LevelName );

					if( i >= SkinSwitchLevel )
					{
						// switch to alternate skin
						SetSkin( Texture( DynamicLoadObject( AltSkinStr, Class'Texture' ) ) );
					}
				}
			}
		}

		// Update PlayerType (PlayerReplicationInfo).
		if		( IsA('Forsaken') )		PlayerReplicationInfo.PlayerType = 1;
		else if	( IsA('Hound') )		PlayerReplicationInfo.PlayerType = 2;
		else if	( IsA('Whitecloak') )	PlayerReplicationInfo.PlayerType = 3;
		else							PlayerReplicationInfo.PlayerType = 0;

		// Update Color (PlayerReplicationInfo).
		SkinName = string(Skin.Name);
		if		( InStr( SkinName, "Black"	)	!= -1 )	PlayerReplicationInfo.Color = 1;
		else if	( InStr( SkinName, "Blue"	)	!= -1 )	PlayerReplicationInfo.Color = 2;
		else if	( InStr( SkinName, "Red"	)	!= -1 )	PlayerReplicationInfo.Color = 3;
		else if	( InStr( SkinName, "Green"	)	!= -1 )	PlayerReplicationInfo.Color = 4;
		else											PlayerReplicationInfo.Color = 0;
	}

	if( AnimationTableClass == None )
	{
		BroadcastMessage( Self $ "::AnimationTableClass not set!" );
		warn( Self $ "::AnimationTableClass not set!" );
		Destroy();
	}

	SetupAssetClasses();

	// enable subtitles (can also be enabled in user.ini with bSubtitles=true)?
	for( i=0; i<ArrayCount(SubTitleLanguages); i++ )
	{
		if( GetLanguage() == SubTitleLanguages[i] )
		{
			bSubtitles = true;
			break;
		}
	}
}

//---------------------------------------------------------------------------
event Possess()
{
	Super.Possess();

	if( Level.NetMode == NM_Standalone || Level.Netmode == NM_Client )
	{
		if( uiHUD(myHUD) == None )
		{
			myHUD = Spawn( HUDType, Self );
		}
	}

	if( Level.Netmode != NM_Client && Level.Game.IsA( 'giMPBattle' ) )
	{
		ClientPreLoadBudgets();
		ClientSetNumTeams( giMPBattle(Level.Game).Battle.NumTeams );
	}

	if( Level.NetMode == NM_Standalone )
	{
		NextState = GetStateName();
		GotoState( 'WaitToShowMissionObjectives' );
	}
}

//-----------------------------------------------------------------------------
// Wait until the rendering device is initialized because Mission Objectives
// currenlty require at least 640x480 resolution and this can't be forced if 
// necessary until we know that we can set the resolution.

state WaitToShowMissionObjectives
{
	function bool PopUpMissionObjectives()
	{
		local MissionObjectives MO;
		
		foreach AllActors( class'MissionObjectives', MO )
		{
			if( !MO.bDidAutoPopup )
			{
				MO.bDidAutoPopup = true;
				giWOT(Level.Game).InternalPause( true, true, Self );
				ShowMissionObjectives( MO );
				return true;
			}
			break;
		}

		return false;
	}

Begin:
	// wait until resolution can be changed if necessary
	if( ConsoleCommand( "GetRes" ) == "" )
	{
		Sleep( 0.1 );
		goto 'Begin';
	}
	
	if( !PopupMissionObjectives() && Level.MP3Filename != "" )
	{
		ConsoleCommand( "MP3 START "$ Level.MP3Filename );
	}

	GotoState( NextState );
}
	
//-----------------------------------------------------------------------------
function ClientSetNumTeams( int NumTeams )
{
	if( BattleHUD(myHUD) != None )
	{
		BattleHUD(myHUD).NumTeams = NumTeams;
	}
}

//---------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Level.NetMode != NM_Client ) // drop seals from server only
	{
		DropSeals();
	}

	CancelAngrealEffects();
	class'WOTUtil'.static.RemoveAllReflectorsFrom( Self );

	Super.Destroyed();

	CurrentHandSet = None;
	if( AngrealHandSet != None )
	{
		AngrealHandSet.Destroy();
		AngrealHandSet = None;
	}
	if( CitadelEditorHandSet != None )
	{
		CitadelEditorHandSet.Destroy();
		CitadelEditorHandSet = None;
	}
	if( MySoundSlotTimerList != None )
	{
		MySoundSlotTimerList.Destroy();
	}
	if( AssetsHelper != None )
	{
		AssetsHelper.Destroy();
	}
}

//===========================================================================
// UI / Health Code
//---------------------------------------------------------------------------
function Texture GetHealthIcon()
{
	local int Index;

	if( ApparentIcon != None ) 
	{
		return ApparentIcon;
	}

	// This ensures the value is between 0 and 3, inclusive.
	Index = ArrayCount( HealthIcons ) - 1 - min( max( ArrayCount( HealthIcons ) * Health / default.Health, 0 ), ArrayCount( HealthIcons ) - 1 );
	return HealthIcons[ Index ];
}

//---------------------------------------------------------------------------
function Texture GetDisguiseIcon()
{
	if( ApparentIcon != None ) 
	{
		return ApparentIcon;
	}
	return DisguiseIcon;
}

//=============================================================================
// How many seekers are targeting you
//---------------------------------------------------------------------------
function IncrementSeekerCount()
{
	// Only allow this to be called on the server.
	if( Role < ROLE_Authority )
		return;

	SeekerCount++;

	if( SeekerCount == 1 )
	{
		ClientPlaySound( Sound( DynamicLoadObject( "WOT.SeekerNotification", class'Sound' ) ) );
	}
}

//---------------------------------------------------------------------------
function DecrementSeekerCount()
{
	// Only allow this to be called on the server.
	if( Role < ROLE_Authority )
		return;

	SeekerCount--;

	if( SeekerCount < 0 )
	{
		SeekerCount = 0;
	}
}

//===========================================================================
// Called before getting any inventory items.
//---------------------------------------------------------------------------
function TravelPreAccept()
{
	Super.TravelPreAccept();

	// build hands before accepting inventory during level transitions
	CreateAngrealHands();
}

//===========================================================================
// Called after getting any inventory items.
//---------------------------------------------------------------------------
function TravelPostAccept()
{
	Super.TravelPostAccept();

	// update selected hand and selected item to match SelectedItem
	if( SelectedItem != None )
	{
		CurrentHandSet.SelectItem( SelectedItem.Class.Name );
	}
}

//===========================================================================
function RemoveIconInfo( name IconTag )
{
    local IconInfo  curII;
    local IconInfo  prevII;

	// Error check
	if( FirstIcon == None )
	{
		// No icons to remove
		return;
	}

    // removal of head is a special case...
    if( FirstIcon.Tag == IconTag ) 
	{
        curII = FirstIcon;
        FirstIcon = FirstIcon.Next;
        curII.Destroy();
    } 
	else 
	{
        prevII = FirstIcon;
        curII  = FirstIcon.Next;    // if() clause took care of curII == FirstIcon
        while( curII != None )
		{
            if( curII.Tag == IconTag )
			{
                prevII.Next = curII.Next;
                curII.Destroy();
                break;  // assume only one matching texture
            }

            prevII = curII;
            curII = curII.Next;
        }
    }
}

//-----------------------------------------------------------------------------
// same as WOTPawn.uc PainTimer()
event PainTimer()
{
	Super.PainTimer();

	if( Health > 0 && WOTZoneInfo(FootRegion.Zone) != None && WOTZoneInfo(FootRegion.Zone).bHealZone )
	{
		if( Health < 100 ) 
		{
			PlaySound( WOTZoneInfo(FootRegion.Zone).HealSound, SLOT_Interact, 1 );
			Health += WOTZoneInfo(FootRegion.Zone).HealPerSec;
			Health = min( Health, 100 );
		}
		PainTime = 1.0;
	}
}

//-----------------------------------------------------------------------------
event WalkTexture( texture Texture, vector StepLocation, vector StepNormal )
{
	if( AssetsHelper != None )
	{
		AssetsHelper.HandleTextureCallback( Texture );
	}
}

//-----------------------------------------------------------------------------
function HandleWalking()
{
	local bool bAlwaysRun;
	bAlwaysRun = true;

	Super.HandleWalking();

	bIsWalking = (bRun != 0) || (bDuck != 0);
	if( Region.Zone.bWaterZone )
	{
		bIsWalking = false; // always swim as fast as possible
	}
	else
	{
		bIsWalking = (!bAlwaysRun ^^ bRun != 0) || (bDuck != 0);
	}
}

//-----------------------------------------------------------------------------
function UpdateRotation(float DeltaTime, float maxPitch)
{
	local rotator newRotation;

	Super.UpdateRotation( DeltaTime, maxPitch );

	if( bForceRotation )
	{
		ViewRotation += DeltaTime * ForcedRotationRate;
	}

	newRotation = Rotation;
	newRotation.Yaw = ViewRotation.Yaw;
	newRotation.Pitch = ViewRotation.Pitch;
	if( !Region.Zone.bWaterZone )
		newRotation.Pitch = 0;
	setRotation( newRotation );
}

//-----------------------------------------------------------------------------
state PlayerWalking
{
	exec function FeignDeath();

	event PlayerTick( float DeltaTime )
	{
		// disable changing GroundSpeed etc. in MP for now -- replication issues
		if( Level.Netmode == NM_Standalone )
		{
			SetMotionDirection( Acceleration );
		}

		Super.PlayerTick( DeltaTime );
	}
}

//-----------------------------------------------------------------------------
state PlayerSwimming
{
	function AnimEnd()
	{
        PlaySwimming();
	}
	
	event PlayerTick( float DeltaTime )
	{
		// disable changing GroundSpeed etc. in MP for now -- replication issues
		if( Level.Netmode == NM_Standalone )
		{
			SetMotionDirection( Acceleration );
		}

		Super.PlayerTick( DeltaTime );
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)	
	{
		local vector X, Y, Z, Temp;

		GetAxes( ViewRotation, X, Y, Z );
		Acceleration = NewAccel;
		bUpAndOut = ( ( X Dot Acceleration ) > 0) && ( ( Acceleration.Z > 0 ) || ( ViewRotation.Pitch > 2048 ) );
		if( bUpAndOut && !Region.Zone.bWaterZone && CheckWaterJump( Temp ) ) //check for waterjump
		{
			Velocity.Z = 330 + 2 * CollisionRadius; //set here so physics uses this for remainder of tick
			PlayDuck();
			GotoState( 'PlayerWalking' );
		}				
	}
}

//=============================================================================
// Override so we can do a PlayAnim (and FinishAnim) instead of a TweenAnim for
// major impacts.

state PlayerLanded
{
ignores Fire, AltFire, UseAngreal;

	function AnimEnd()
	{
		GotoState('PlayerWalking');
	}

	event PlayerTick( float DeltaTime )
	{
		if( bUpdatePosition )
		{
			ClientUpdatePosition();
  		}

		PlayerMove(DeltaTime);
	}

	function PlayerMove( float DeltaTime )
	{
		local vector NewAccel;

		ViewFlash( DeltaTime );
		ViewShake( DeltaTime );

		NewAccel = vect(0,0,0);

		if( Role < ROLE_Authority ) // then save this move and replicate it
		{
			ReplicateMove(DeltaTime, NewAccel, DODGE_None, Rot(0,0,0));
		}
		else
		{
			Acceleration = NewAccel;
		}
	}

	function PlayTakeHit(float tweentime, vector HitLoc, int Damage)
	{
		if( IsAnimating() )
		{
			Enable('AnimEnd');
			Global.PlayTakeHit(tweentime, HitLoc, Damage);
		}
	}
	
	function PlayDying(name DamageType, vector HitLocation)
	{
		BaseEyeHeight = ApparentClass.default.BaseEyeHeight;
	}

	function BeginState()
	{
		bIsCrouching = false;
		bPressedJump = false;
		bRising = false;
		CeaseUsingAngreal();
	
	    BaseEyeHeight = 0.1 * ApparentClass.default.BaseEyeHeight;

		AnimationTableClass.static.TweenPlaySlotAnim( Self, LookupAnimSequence(LandAnimSlot) );   
	}
}

//=============================================================================
// xxxrlo: problem if minion grabs player in water -- zone change not tracked?

state Immobilized
{
ignores SeePlayer, HearNoise, Bump;

function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot);	

/*
	function AnimEnd()
	{
	    if( Region.Zone.bWaterZone ) 
		{
			BroadcastMessage( "Going to PlayerSwimming" );
			GotoState( 'PlayerSwimming' );
		}
		else
		{
			BroadcastMessage( "Going to PlayerWalking" );
			GotoState('PlayerWalking');
		}
	}
*/

		
	event PlayerTick( float DeltaTime )
	{
		local rotator OldRotation;
		
		if( bUpdatePosition )
		{
			ClientUpdatePosition();
		}
		
		// Update rotation.
		OldRotation = Rotation;
		UpdateRotation( DeltaTime, 1 );
	
		if ( Role < ROLE_Authority ) // then save this move and replicate it
		{
			ReplicateMove( DeltaTime, Acceleration, DODGE_None, OldRotation - Rotation );
		}
		//PlayerMove(DeltaTime);
	}

	function Landed( vector HitNormal )
	{
		GotoState( 'PlayerWalking' );
	}
	
	function PlayDying(name DamageType, vector HitLocation)
	{
		BaseEyeHeight = ApparentClass.default.BaseEyeHeight;
	}

	function BeginState()
	{
//		bIsCrouching = false;
//		bPressedJump = false;
//		bRising = false;
		Velocity = vect( 0, 0, 0 );
		Acceleration = vect( 0, 0, 0 );
	    BaseEyeHeight = 0.1 * ApparentClass.default.BaseEyeHeight;
		// tween to the falling anim
		Falling();
	    if( Region.Zone.bWaterZone && Health > 0 ) 
		{
//			BroadcastMessage( "Going to PlayerSwimming" );
			setPhysics(PHYS_Swimming);
			GotoState( 'PlayerSwimming' );
		}
	}

	function EndState()
	{
		GroundSpeed = ApparentClass.default.GroundSpeed;
	}
}

state Grabbed expands Immobilized
{
	function BeginState()
	{
		BaseEyeHeight = 0.1 * ApparentClass.default.BaseEyeHeight;
		Falling();
		if( Region.Zone.bWaterZone && Health > 0 )
		{
			SetPhysics( PHYS_Swimming );
			GotoState( 'PlayerSwimming' );
		}
	}
}

state Impaled expands Immobilized
{
	function UpdateRotation(float DeltaTime, float maxPitch)
	{
		local rotator newRotation;
		
		DesiredRotation = ViewRotation; //save old rotation
		ViewRotation.Pitch += 2.0 * DeltaTime * aLookUp;
		ViewRotation.Pitch = ViewRotation.Pitch & 65535;
		If ((ViewRotation.Pitch > 3000) && (ViewRotation.Pitch < 8000 ))
		{
			If (aLookUp > 0) 
				ViewRotation.Pitch = 3000;
			else
				ViewRotation.Pitch = 8000;
		}
		ViewRotation.Yaw += 1.0 * DeltaTime * aTurn;
		ViewShake(deltaTime);
		ViewFlash(deltaTime);
			
		newRotation = Rotation;
		newRotation.Pitch = ViewRotation.Pitch;
		If ( (newRotation.Pitch > maxPitch * RotationRate.Pitch) && (newRotation.Pitch < 65536 - maxPitch * RotationRate.Pitch) )
		{
			If (ViewRotation.Pitch < 32768) 
				newRotation.Pitch = maxPitch * RotationRate.Pitch;
			else
				newRotation.Pitch = 65536 - maxPitch * RotationRate.Pitch;
		}
		setRotation(newRotation);
	}
}

/*TBR
//-----------------------------------------------------------------------------
function int GetPitTeam()
{
	local PitOpening O, Opening;
	local vector Delta;
	local float Dist, MinDist;

	MinDist = 1600;
	foreach AllActors( class'PitOpening', O )
	{
//log( "  Considering Opening = "$ O );
		// find the pit opening cloesest to the player (X/Y only)
		Delta = O.Location - Location;
		Delta.Z = 0;
		Dist = VSize( Delta );
		if( Dist < MinDist )
		{
			MinDist = Dist;
			Opening = O;
//log( "    Opening.ThePitTrap = "$ Opening.ThePitTrap @ Dist );
		}
	}

	if( Opening.ThePitTrap == None )
	{
		warn( Opening$".ThePitTrap=None" );
	}
	else if( Pit(Opening.ThePitTrap.Owner) == None )
	{
		warn( Opening$"."$Opening.ThePitTrap$".Owner=None" );
	}
	else if( Pit(Opening.ThePitTrap.Owner).Team == 255 )
	{
		warn( Opening$"."$Opening.ThePitTrap$"."$Opening.ThePitTrap.Owner$".Team=255" );
	}
//log( "Pit Team = "$ Pit(Opening.ThePitTrap.Owner).Team );
	return Pit(Opening.ThePitTrap.Owner).Team;
}
*/
function Vector GetPitLocation()
{
	local PitOpening O, Opening;
	local vector Delta;
	local float Dist, MinDist;

	MinDist = 1600;
	foreach AllActors( class'PitOpening', O )
	{
//log( "  Considering Opening = "$ O );
		// find the pit opening cloesest to the player (X/Y only)
		Delta = O.Location - Location;
		Delta.Z = 0;
		Dist = VSize( Delta );
		if( Dist < MinDist )
		{
			MinDist = Dist;
			Opening = O;
//log( "    Opening.ThePitTrap = "$ Opening.ThePitTrap @ Dist );
		}
	}

	if( Opening.ThePitTrap == None )
	{
		warn( Opening$".ThePitTrap=None" );
	}
	else if( Pit(Opening.ThePitTrap.Owner) == None )
	{
		warn( Opening$"."$Opening.ThePitTrap$".Owner=None" );
	}

	return Pit(Opening.ThePitTrap.Owner).Location;
}

//-----------------------------------------------------------------------------
// override Pawn.Died() to handle destruction of HandInfo (and to ditch ALL
// inventory, not just the current Weapon).
function Died( Pawn Killer, name damageType, vector HitLocation )
{
	local Inventory Inv;
    local vector X,Y,Z;
	local int i;
	local BagHolding Bag;

	// cancel any angreal effects (like decay, soulbarb, etc.) so they aren't still active after
	// the player comes alive again.
	CancelAngrealEffects();

    GetAxes( Rotation, X, Y, Z );

    // ditch any seals
	DropSeals();

	// Reset all the seeker count - this should be zero anyway...
	SeekerCount = 0;

	if( Level.NetMode != NM_Standalone )	// Don't drop in singleplayer.
	{
		// Put artifacts into a bag.
		for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
		{
			// take the item away from the player before putting it in the bag (Inventory.DeleteInventory() sets Owner=None)
			DeleteInventory( Inv );

			if( Inv.Class != DefaultAngrealInventory && !Inv.IsA('AngrealInvSpecial') )
			{
				// Restrict charges.
				if( AngrealInventory(Inv) != None && AngrealInventory(Inv).CurCharges > AngrealInventory(Inv).MaxInitialCharges )
				{
					AngrealInventory(Inv).CurCharges = AngrealInventory(Inv).MaxInitialCharges;
				}
		
				// Make the bag only if we need it.
				if( Bag == None )
				{
					Bag = Spawn( class'BagHolding' );
				}
				Bag.AddItem( Inv );
			}
		}
		if( Bag != None )
		{
			Bag.DropFrom( Location + ( Bag.CollisionRadius + CollisionRadius ) * X );
		}
	}
	
	// don't let GameInfo.DiscardInventory() drop the weapon twice, and deselect the active item
    Weapon = None;
	SelectedItem = None;

	// Record death (includes suicides -- PlayerReplicationInfo.Deaths does not.)
	NumDeaths++;
	
    Super.Died( Killer, damageType, HitLocation );

	// inventory is destroyed in GameInfo.DiscardInventory() called by Pawn.Died()
	// clear hands to clear potential replication errors
	if( AngrealHandSet != None )
	{
		AngrealHandSet.Empty();
	}
	if( CitadelEditorHandSet != None )
	{
		CitadelEditorHandSet.Empty();
	}
}

//===========================================================================

function Carcass DoSpawnCarcass( bool bGibbed )
{
	local Carcass Carc;

	if( !bCarcassSpawned )
	{
		bHidden = true;
		bCarcassSpawned = true;

		Carc = Spawn( CarcassType );
		Carc.Initfor( Self );

		if( bGibbed )
		{
			Carc.ChunkUp( -1 * Health );
		}

		if (Player != None)
		{
			Carc.bPlayerCarcass = true;
		}

		// for Player 3rd person views
		MoveTarget = Carc; 
	}

	return Carc;
}

//===========================================================================

function SpawnGibbedCarcass()
{
	DoSpawnCarcass( true );
}

//===========================================================================

function Carcass SpawnCarcass()
{
	return DoSpawnCarcass( false );
}

//===========================================================================

function ReStartLevel()
{
	SetTransitionType( TRT_RestartLevel );
	Super.ReStartLevel();
}

//===========================================================================
// Dying state
//===========================================================================

state Dying
{
	//===========================================================================
	// Overridden to make it possible to automatically restart the player in
	// some cases. Also, don't restart the player in multiplayer games until
	// enough time has passed.
	
	exec function Fire( optional float F )
	{
		bJustFired = true;
		if ( Role < ROLE_Authority )
			return;

		if( Level.TimeSeconds >= OKToFireTime )
		{
			if( giWOT(Level.Game) == None || !giWOT(Level.Game).ShouldRestartLevel() )
			{
				Super.Fire( F );
			}

		// Increment NumDeaths so any seekers shot at player after died called (while
		// still a player and not yet a carcass) lose their target when he respawns.
		NumDeaths++;

		// Could player die then get tainted, e.g. and respawn with this?
		CancelAngrealEffects();

		// Need to do this to so because we may have had seekers after us while dead
		SeekerCount = 0;
		}
	}
	
	//===========================================================================

	exec function UseAngreal()
	{
		Fire( 0 );
	}

	//===========================================================================
	// Unreal behavior is to fire up timer 0.3 (hard-coded) seconds after Pawn
	// enters the dying state. WOT approach is to use notification functions to
	// tell us when the Pawn is on/near the ground and at this point we spawn the 
	// carcass. The dying Pawn continues to take damage while the death anim is
	// playing and, if enough damage is done, will gib. The carcass will inherit
	// the health of the Pawn when it is created.

	function PawnToCarcassTransition( bool bGibbed )
	{
		if( !bHidden )
		{
			DoSpawnCarcass( bGibbed );

			if( bIsPlayer )
			{
				HidePlayer();
			}
			else
			{
				Destroy();
			}

			bHidden = true;
		}

		// make sure balefired tag doesn't stick around
		Tag='';
	}

	//===========================================================================

	function TransitionToCarcassNotification()
	{
		PawnToCarcassTransition( false );
	}

	//===========================================================================

	function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, name DamageType )
	{
		if( bDeleteMe )
		{
			return;
		}

		Health = Health - Damage;
		Momentum = Momentum/Mass;
		AddVelocity( Momentum ); 

		if( !bHidden && !bCarcassSpawned )
		{
			if( Health < (BaseGibDamage/Damage * GibForSureFinalHealth) )
			{
				PawnToCarcassTransition( Tag != 'Balefired' );
			}
			else
			{
				// spawn damage effect
				AssetsHelper.HandleDamage( Damage, HitLocation, DamageType );
			}
		}
	}

	//===========================================================================

	function Timer()
	{
		bFrozen = false;
		bShowScores = true;
		bPressedJump = false;

		if( giWOT(Level.Game) != None && giWOT(Level.Game).ShouldRestartLevel() )
		{
			GotoState( 'RestartLevelAfterDelay' );
		}		
	}

	//===========================================================================

	event Landed( vector HitNormal )
	{
		// fix for sliding dying PCs/NPCs
		Acceleration = vect(0,0,0);
	}

	//===========================================================================

	function BeginState()
	{
		Super.BeginState();

		OKToFireTime = Level.TimeSeconds + RespawnDelaySecs;

		SetPhysics( Phys_Falling );

		if( Tag == 'Balefired' )
		{
			SetPhysics( PHYS_None );
			Acceleration = vect(0,0,0);

			// balefire works on carcasses and stops animation so create carcass right away	
			PawnToCarcassTransition( false );
		}

		SetTimer( 2.0, false );
	}

	//===========================================================================

	function EndState()
	{
		Super.EndState();

		bCarcassSpawned = false;
	}
}

//===========================================================================
// RestartLevelAfterDelay state
//===========================================================================

state RestartLevelAfterDelay expands Dying
{
Begin:
	Sleep( RestartLevelDelaySecs );
	RestartLevel();
}

//===========================================================================

function PlayerRestartLevel()
{
	GotoState( 'RestartLevelAfterDelay' );
}

//===========================================================================
// EndLevel state
//===========================================================================

state PlayerEndLevelImmediately
{
	ignores TakeDamage, UseAngreal, Fire;

	//===========================================================================
	function BeginState()
	{
		// For now we "kill" the player, make him 
		// hidden, put him in the dying state and "press" the fire key in order to 
		// restart the player / bring up the load menu.
			
		SetPhysics( Phys_None );
		Acceleration = vect(0,0,0);
		BaseEyeheight = Default.BaseEyeHeight;
		EyeHeight = BaseEyeHeight;
		Health = 0;
		bFrozen = false;
	    bHidden = true;
		bPressedJump = false;
	
		// code from PlayerPawn.Dying::Fire()	
		bJustFired = true;
		if ( Role < ROLE_Authority )
		{
			return;
		}
			
		if ( (Level.NetMode == NM_Standalone) && !Level.Game.bDeathMatch )
		{
			ShowLoadMenu();
		}
		else
		{
			ServerReStartPlayer();
		}
	}

	//===========================================================================
	function EndState()
	{
		bJustFired = false;
	}
}

//===========================================================================
function PlayerEndLevel()
{
	GotoState( 'PlayerEndLevelImmediately' );
}

//-----------------------------------------------------------------------------
state GameEnded
{
	exec function Fire( optional float F )
	{
		if ( Role < ROLE_Authority)
			return;
		if ( !bFrozen )
			ServerReStartGame();
		else if ( TimerRate <= 0 )
			SetTimer(PlayerRestartGameDelay, false);
	}

	exec function UseAngreal()
	{
		Fire( 0 );
	}

	function BeginState()
	{
		Super.BeginState();

		SetTimer(PlayerRestartGameDelay, false);
	}
}

//-----------------------------------------------------------------------------
// Removes all non default reflectors and leeches.
//-----------------------------------------------------------------------------
function CancelAngrealEffects()
{
	local Leech L;
	local Reflector R;
	local LeechIterator IterL;
	local ReflectorIterator IterR;

	local Inventory Inv;
	
	//AngrealInventory(SelectedItem).UnCast();
	for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
	{
		if( AngrealInventory(Inv) != None )
		{
			AngrealInventory(Inv).Reset();
		}
	}

	IterL = class'LeechIterator'.static.GetIteratorFor( Self );
	for( IterL.First(); !IterL.IsDone(); IterL.Next() )
	{
		L = IterL.GetCurrent();

		if( L.bRemovable )
		{
			L.UnAttach();
			L.Destroy();
		}
	}
	IterL.Reset();
	IterL = None;

	IterR = class'ReflectorIterator'.static.GetIteratorFor( Self );
	for( IterR.First(); !IterR.IsDone(); IterR.Next() )
	{
		R = IterR.GetCurrent();

		if( R.bRemovable )
		{
			R.UnInstall();
			R.Destroy();
		}
	}
	IterR.Reset();
	IterR = None;

	ShieldHitPoints = 0;	// Just to be safe.
}

//-----------------------------------------------------------------------------
// Add to our normal inventory and distribute item to our hands.
//-----------------------------------------------------------------------------
simulated function bool AddInventory( Inventory NewItem )
{
	local bool bSuccess;
//	local Inventory Inv;
//	local int InvCount;

	// Add this sucker to our normal inventory.
	bSuccess = Super(Pawn).AddInventory( NewItem );

	// If pawn added it to our inventory, we better distribute it to the hands.
	if( bSuccess )
	{
		ClientAddItem( NewItem.Class.Name );

		if( SelectedItem == None && ( AngrealInventory(NewItem) != None || Seal(NewItem) != None || SealInventory(NewItem) != None ) ) // avoid keys, and other non-selectable items
		{
			Select( NewItem.Class.Name );
		}

/*DEBUG
		for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
		{
			if( Inv.Class == NewItem.Class )
			{
				InvCount++;
			}
		}
		if( InvCount != 1 )
		{
			warn( Self$".AddInventory( "$ NewItem $" ) InvCount="$ InvCount );
		}
*/
	}
	return bSuccess;
}

//-----------------------------------------------------------------------------
function bool ServerDeleteInventory( inventory Item )
{
	return DeleteInventory( Item );
}

//-----------------------------------------------------------------------------
// override of Pawn.DeleteInventory() to handle WOT-specific "Hands", and current selection
function bool DeleteInventory( inventory Item )
{
	local int i;
	local int j;
	local HandInfo Hand;
	
    if( Item == None )
        return false;

	if( AngrealInventory(Item) != None )
	{
		if( Item == SelectedItem )
		{
			CeaseUsingAngreal();
		}

		AngrealInventory(Item).Reset();
	}

	Super.DeleteInventory( Item );

	ClientRemoveItem( Item.Class.Name );

	return true;
}

//-----------------------------------------------------------------------------
simulated function ClientAddItem( name ItemName )
{
	if( CurrentHandSet != None )
	{
		CurrentHandSet.AddItem( ItemName );
	}
}

//-----------------------------------------------------------------------------
simulated function ClientRemoveItem( name ItemName )
{
	if( CurrentHandSet != None )
	{
		CurrentHandSet.RemoveItem( ItemName );
	}
}

//=============================================================================
// UI utility routines
//-----------------------------------------------------------------------------
function PushUserInterfaceState()
{
	PrevHUD = myHUD;
	myHUD = None;

	bPrevShowMenu = bShowMenu;
	if( bShowMenu )
	{
		// leave menu mode while in Inventory UI
		bShowMenu = false;
		Player.Console.GotoState( '' );
	}
}

//-----------------------------------------------------------------------------
function PopUserInterfaceState()
{
	myHUD.Destroy();
	myHUD = PrevHUD;

	// return to menuing mode (or not) gracefully
	bShowMenu = bPrevShowMenu;
	if( bShowMenu )
	{
		Player.Console.GotoState( 'Menuing' );
	}
}

//=============================================================================
function ClientGotoState( name NewState )
{
	if( Level.NetMode == NM_Client )
	{
		GotoState( NewState );
	}
}

//=============================================================================
function ClientPreLoadBudgets()
{
	local BudgetInfo B;
	local int i;

	// access the budgets from the server, pass the strings to the client
	foreach AllActors( class'BudgetInfo', B )
	{
		for( i = 0; i < B.GetArrayCount(); i++ )
		{
			if( B.GetResourceAdapterName( i ) != '' )
			{
				ClientDynamicLoadObject( B.GetFullName( i ) );
			}
		}
	}
}

//-----------------------------------------------------------------------------
simulated function ClientDynamicLoadObject( string ClassName )
{
	if( Level.NetMode == NM_Client )
	{
		DynamicLoadObject( ClassName, class'Class' );
	}
}

//=============================================================================
// Support (used by AngrealInvMinion et. al) for determining "which troop to use?"
//-----------------------------------------------------------------------------
static function class<WOTPawn> GetTroop( Actor ParentPawn, name Troop )
{
	local Name PlayerClassName, TroopClassName;
	local int i;
	local class<WOTPawn> TroopClass;

	if( WOTPlayer(ParentPawn) != None )
	{
		PlayerClassName = WOTPlayer(ParentPawn).PlayerClass.Name;
	}
	else
	{
		warn( "GetTroop( "$ ParentPawn $", "$ Troop $" ) -- not implemented for non-players" );
		//PlayerClassName = static.GetParentPlayer( ParentPawn );
	}
	if( PlayerClassName != '' )
	{
		for( i = 0; i < ArrayCount(default.PlayerTroops); i++ )
		{
			if( default.PlayerTroops[i].Player == PlayerClassName && default.PlayerTroops[i].Troop == Troop )
			{
				TroopClass = class<WOTPawn>( DynamicLoadObject( default.PlayerTroops[i].TroopClassName, class'Class' ) );
				break;
			}
		}
	}

	return TroopClass;
}

//=============================================================================
// Multiplayer support for dynamically changing the player class
//-----------------------------------------------------------------------------
function ChangeClassModelStuff( class<WOTPlayer> NewClass )
{
	Mesh			= NewClass.default.Mesh;
	PlayerColor		= NewClass.default.PlayerColor;
	AnimSequence	= NewClass.default.AnimSequence;
	DrawScale		= NewClass.default.DrawScale;
	DisguiseIcon	= NewClass.default.DisguiseIcon;
	SetCollisionSize( NewClass.default.CollisionRadius, NewClass.default.CollisionHeight );

	// support swapping main character's skin after mission_xx
    AltSkinStr		= NewClass.default.AltSkinStr;
    SkinSwitchLevel = NewClass.default.SkinSwitchLevel;

	// reset skin to default for class
	SetSkin( NewClass.default.MultiSkins[1] );
}

//-----------------------------------------------------------------------------
function ChangeClassAssetsStuff( class<WOTPlayer> NewClass )
{
	TextureHelperClass		= NewClass.default.TextureHelperClass;
	DamageHelperClass		= NewClass.default.DamageHelperClass;
	SoundTableClass			= NewClass.default.SoundTableClass;
	SoundSlotTimerListClass = NewClass.default.SoundSlotTimerListClass;
	AnimationTableClass		= NewClass.default.AnimationTableClass;

	if( AssetsHelper != None )
	{
		// wipe out old assets helper
		AssetsHelper.Destroy();
	}

	// do NOT destroy MySoundTable (shared singleton)
	
	if( MySoundSlotTimerList != None )
	{
		// wipe out old slot timer list
		MySoundSlotTimerList.Destroy();
	}

	// resets assets helper, sound table etc.
	SetupAssetClasses();

	// the following may differ among player classes
	VolumeMultiplier	= NewClass.default.VolumeMultiplier;
	RadiusMultiplier	= NewClass.default.RadiusMultiplier;
	PitchMultiplier		= NewClass.default.PitchMultiplier;
}

//-----------------------------------------------------------------------------
// As new sounds/assets get added, this code needs to be expanded to include them.

function ServerChangeClass( class<WOTPlayer> NewClass )
{
	local Inventory Inv;

	PlayerClass = NewClass;

	MenuName = NewClass.default.MenuName;
	TeamDescription = NewClass.default.TeamDescription;

	// delete default angreal
    for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
	{
        if( Inv.Class == DefaultAngrealInventory ) 
		{
	    	Inv.Destroy();
		}
    }

	// add new default angreal
	DefaultAngrealInventory = NewClass.default.DefaultAngrealInventory;
	Level.Game.AddDefaultInventory( Self );

	HealthIcons[ 0 ] = NewClass.default.HealthIcons[ 0 ];
	HealthIcons[ 1 ] = NewClass.default.HealthIcons[ 1 ];
	HealthIcons[ 2 ] = NewClass.default.HealthIcons[ 2 ];
	HealthIcons[ 3 ] = NewClass.default.HealthIcons[ 3 ];

	bIsFemale = NewClass.default.bIsFemale;
	if( PlayerReplicationInfo != None )
	{
		PlayerReplicationInfo.bIsFemale = bIsFemale;
	}

	ChangeClassModelStuff( NewClass );
	ChangeClassAssetsStuff( NewClass );

	// Update PlayerReplicationInfo.
	if		( NewClass.Name == 'Forsaken' )		PlayerReplicationInfo.PlayerType = 1;
	else if	( NewClass.Name == 'Hound' )		PlayerReplicationInfo.PlayerType = 2;
	else if	( NewClass.Name == 'Whitecloak' )	PlayerReplicationInfo.PlayerType = 3;
	else										PlayerReplicationInfo.PlayerType = 0;
}

//=============================================================================
// WOT override -- need to initialize MultiSkins since all WOT PC models use 
// these (up to 4 slots at present).

static function SetMultiSkin( Actor SkinActor, string SkinName, string FaceName, byte TeamNum )
{
	local string MeshName;

	MeshName = SkinActor.GetItemName( string(SkinActor.Mesh) );

	// only accept Skin if it comes from a .utx package whose name 
	// matches the current Mesh and if not currently using pain skin
	if( !SkinActor.Level.Game.IsA( 'giMission') && SkinActor.Level.Game.bCanChangeSkin && (Left(SkinName, Len(MeshName)) ~= MeshName) )
	{
		WOTPlayer(SkinActor).SetSkin( Texture(SkinActor.DynamicLoadObject(SkinName, class'Texture') ) );
	}
}

//=============================================================================
// BattleHUD entry point for server-side invokation of ChangeTeam()
//-----------------------------------------------------------------------------
function ServerChangeTeam( int Team )
{
//log( "ServerChangeTeam( "$ Team $" )" );
	if( bEditing )
	{
		ClientMessage( CantChangeTeamsStr );
		return;
	}

	Level.Game.ChangeTeam( Self, Team );
}

//=============================================================================
// Citadel Game code
//-----------------------------------------------------------------------------
exec function UpdateSeal()
{
	local Inventory Inv;

	for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
	{
		if( Inv.IsA( 'Seal' ) )
		{
			Seal(Inv).SetControllingTeam( Self );
		}
	}
}

exec function CheatSeals()
{
	local SealAltar A;
	local BudgetInfo B;
	local int OriginalTeam;

	if( !OKToCheat() )
		return;

	// allow this player to force all seals onto their altars
	OriginalTeam = PlayerReplicationInfo.Team;
	foreach AllActors( class'BudgetInfo', B )
	{
		foreach AllActors( class'SealAltar', A )
		{
			if( B.Team == A.Team )
			{
				PlayerReplicationInfo.Team = A.Team;
				B.PlaceSeals( A, Self );
			}
		}
	}
	PlayerReplicationInfo.Team = OriginalTeam;

	ServerAssessBattlefield();
}

//-----------------------------------------------------------------------------
event bool PreTeleport( Teleporter InTeleporter )
{
	if( bEditing )
	{
		if( Level.NetMode != NM_Client ) // send message from server only (since server is authoritative re: player position)
		{
			if( Level.TimeSeconds > LastTeleportFailMessage + TELEPORT_FAIL_MESSAGE_DELAY )
			{
				LastTeleportFailMessage = Level.TimeSeconds;
				CenterMessage( TeleportProhibitedEditingStr );
			}
		}
		return true; // don't teleport
	}
	else if( bTeleportingDisabled )
	{
		if( Level.NetMode != NM_Client ) // send message from server only (since server is authoritative re: player position)
		{
			if( Level.TimeSeconds > LastTeleportFailMessage + TELEPORT_FAIL_MESSAGE_DELAY )
			{
				LastTeleportFailMessage = Level.TimeSeconds;
				CenterMessage( TeleportProhibitedJoinStr );
			}
		}
		return true; // don't teleport
	}

	return false;
}
	
//-----------------------------------------------------------------------------
function AutoPlaceSealsOnAltar()
{
	local Seal S;
	local SealAltar A;
	local int i, SealCount;

	if( Level.NetMode == NM_StandAlone && Level.Game.IsA( 'giTutorial' ) )
	{
		return;
	}

	// update controlling team for seals placed with the editor
	foreach AllActors( class'Seal', S )
	{
		// only update seals for the team that have not been updated
		if( S.Team == PlayerReplicationInfo.Team )
		{
			S.SetControllingTeam( Self );
		}
	}

//log( "AutoPlaceSealsOnAltar()" );
	foreach AllActors( class'SealAltar', A )
	{
		if( A.Team == PlayerReplicationInfo.Team )
		{
			// make sure that the number of seals placed on the altar is removed from the client's budget
			SealCount = Budget.PlaceSeals( A, Self );
			for( i = 0; i < SealCount; i++ )
			{
				ClientDecrementResource( class'SealInventory' );
			}
			return;
		}
	}
	assert( false ); // if all teams have an altar, this will never happen
}

/*TBR
//-----------------------------------------------------------------------------
function SealAltar GetTeamAltar( int Team )
{
	local SealAltar A;

	foreach AllActors( class'SealAltar', A )
	{
		if( Team == A.Team )
		{
			return A;
		}
	}

	assert( false ); // specified team altar must be found
}
*/

//-----------------------------------------------------------------------------
function ServerAssessBattlefield()
{
	local BudgetInfo B;
	local WOTPlayer P;
	local int NumSeals, MaxNumSeals;

//log( "ServerAssessBattlefield()" );
	// if any player's budget remains, abort assessment
	foreach AllActors( class'BudgetInfo', B )
	{
		NumSeals = B.GetItemCount( B.GetIndex( 'SealInventory' ) );
//log( Self$".AssessBattlefield() NumSeals="$ NumSeals $" in "$ B );
		MaxNumSeals = Max( MaxNumSeals, NumSeals );
	}
	if( MaxNumSeals > 0 )
	{
		CenterMessage( WaitingForSealsStr );
		return;
	}

	// if any player is still editing, abort assessment
	foreach AllActors( class'WOTPlayer', P )
	{
//log( Self$".AssessBattlefield() "$ P $".bEditing="$ P.bEditing );
		if( P.bEditing )
		{
			CenterMessage( WaitingForEditStr );
			return;
		}
	}

	// all seals have been placed, open the battlefield (re-enable teleporters)
	// not necessary for the giTutorial
	if( giMPBattle(Level.Game) != None )
	{
		giMPBattle(Level.Game).EnableTeleporters();
	}
}

//===========================================================================
function EnterCitadel()
{
	local BudgetInfo B;

	assert( Level.Game.IsA( 'giMPBattle' ) ); // the game *must* be a giMPBattle in order to enter the Citadel

	// locate the BudgetInfo for this team
	foreach AllActors( class'BudgetInfo', B )
	{
		if( B.Team == PlayerReplicationInfo.Team )
		{
			Budget = B;
			break;
		}
	}
//Log( Self$".EnterCitadel() Budget = "$ Budget );
	assert( Budget != None ); // the team *must* have a budget to begin play
}

//-----------------------------------------------------------------------------
function LeaveCitadel()
{
	local Inventory Inv;

	Budget = None;

	// eliminate Citadel Editor Inventory (used for testing only)
	for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
	{
		if( !Inv.IsA( 'Seal' ) )
		{
			Inv.Destroy();
		}
	}

	DestroyCitadelEditorHands();
}

//-----------------------------------------------------------------------------
exec function ServerEditCitadel( optional int Mode )
{
	assert( giWOT(Level.Game) != None ); // player *must* at least have giWOT
	if( !giWOT(Level.Game).CanEditCitadel() )
	{
		CenterMessage( CantEditLevelStr );
		return;
	}
	
	EditCitadel( Mode );
}

//-----------------------------------------------------------------------------
// this function serves as the common entry point for both SP and MP editing, 
// and for both RoamMode and OrbitMode editing.
//
// It is also a potential entry point for MP games that automatically start 
// the player in edit mode.
//-----------------------------------------------------------------------------
function EditCitadel( int Mode )
{
    local WOTZoneInfo Zone;

	assert( Level.NetMode != NM_Client ); // EditCitadel *must* not be called on the client

//log( Self$".EditCitadel()" );
    // if we're not in an edit zone, abort
    Zone = WOTZoneInfo(Region.Zone);
    if( Zone == None )
	{
        CenterMessage( CantEditZoneStr );
		return;
	}

    // if we're not on the required team for editing in this zone, abort
    if( Zone.Team != PlayerReplicationInfo.Team )
	{
        CenterMessage( CantEditAreaStr );
//log( "Zone.Team = " $ Zone.Team $ ", your Team = " $ PlayerReplicationInfo.Team );
        return;
    }

	// prohibit editing once gameplay has begun
	if( giMPBattle(Level.Game) != None && giMPBattle(Level.Game).CanTeleport() )
	{
		CenterMessage( CantEditNowStr );
		return;
	}

	// validate the player's Budget and request permission to edit
	if( Budget == None )
	{
		CenterMessage( CantEditBudgetStr );
		return;
	}
	if( !Budget.BeginEdit( Self ) )
	{
		CenterMessage( CantEditLimitStr );
		return;
	}

	// flag that we're editing now
	bEditing = true;
	if( giMPBattle(Level.Game) != None ) giMPBattle(Level.Game).SetEditing( PlayerReplicationInfo.Team, bEditing );

	UpdateEditBudget();

	if( Mode == 1 )
	{
        SetZoneNumber( GetIndex( Zone ) );
//Log( "Selected Zone = " $ SelectedZone );

//Log( "EditCitadel() changing state to CitadelOrbitMode" );
		// save the player's location and rotation
		EditStartLoc = Location;
		EditStartRot = ViewRotation;

		//TBI in AWOTPlayer::ClearDisplay() replace bEditing with check for IsInState( 'CitadelOrbitMode' )
		ClientGotoState( 'CitadelOrbitMode' );
		GotoState( 'CitadelOrbitMode' );
	}
	else
	{
//Log( "EditCitadel() changing state to CitadelRoamMode" );
		// flag the player's edit location and rotation as "invalid"
		EditStartLoc = vect(0,0,0);
		EditStartRot = rot(0,0,0);

		ClientGotoState( 'CitadelRoamMode' );
		GotoState( 'CitadelRoamMode' );
	}
}

//-----------------------------------------------------------------------------
/*DEBUG
exec function BreakInventory()
{
	local Inventory Inv;

	if( Level.NetMode == NM_Client )
	{
		CenterMessage( "BreakInventory" );
		for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
		{
			if( Inv.Inventory == None )
			{
				// force a Inventory loop! -- simulated replication failure
				Inv.Inventory = Inventory;
				break;
			}
		}
	}
}
*/

exec function FixInventory() //MWP
{
	local Inventory Inv;
	local int AbortCount;

	if( Level.NetMode == NM_Client && CurrentHandSet != None )
	{
		CenterMessage( "FixInventory" );

		CurrentHandSet.Empty();
		AbortCount = 999;
		foreach AllActors( class'Inventory', Inv )
		{
			if( Inv.Owner == Self )
			{
				CurrentHandSet.AddItem( Inv.Class.Name );
			}
			if( --AbortCount == 0 ) //hack to avoid crash due to circularly linked inventory
			{
				break;
			}
		}
	}
}

exec function DumpInventory()
{
	local Inventory Inv;
	local int Count, AbortCount;

	CenterMessage( "DumpInventory" );
	// show player inventory (unsorted)
	log( Self$".Inventory = "$ Inventory );
	foreach AllActors( class'Inventory', Inv )
	{
		if( Inv.Owner == Self )
		{
			log( "    "$ Inv$".Inventory = "$ Inv.Inventory );
			Count++;
		}
	}
	log( "Inventory Count:" $ Count );
	log( " " );

	// show player's inventory list
	AbortCount = 999;
	for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
	{
		log( "  "$ Inv$".Inventory = "$ Inv.Inventory );
		if( --AbortCount == 0 ) //hack to avoid crash due to circularly linked inventory
		{
			break;
		}
	}
	log( "STOP" );
}

simulated function SalvageInventoryLinks()
{
	local Inventory Inv, PrevInv;

	CenterMessage( "BAD PING" );
	warn( "Aborting infinite recursion" );

	if( Level.NetMode == NM_Client )
	{
		foreach AllActors( class'Inventory', Inv )
		{
			Inv.Inventory = None;
		}
	}
}

simulated function Inventory FindInventoryName( name ClassName )
{
	local Inventory Inv;
	local int AbortCount;

	if( ClassName == '' )
		return None;

	AbortCount = 999;
	for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
	{
		if( Inv.Class.Name == ClassName )
		{
			return Inv;
		}
		if( --AbortCount == 0 ) //hack to avoid crash due to circularly linked inventory
		{
			SalvageInventoryLinks();
			break;
		}
	}

	return None;
}

//-----------------------------------------------------------------------------
function UpdateEditBudget()
{
	local int i;
	local Inventory Inv;
	local class<WOTInventory> Grunt, Captain, Champion;
	local Name ItemName;

//Log( Self$".UpdateEditBudget()" );
	// create the citadel hands (determine Grunt, Captain, and Champion, then pass control to client)
	Grunt		= Budget.GetResourceType( 'Grunt' );
	Captain		= Budget.GetResourceType( 'Captain' );
	Champion	= Budget.GetResourceType( 'Champion' );
	CreateCitadelEditorHands( Grunt, Captain, Champion );
	CreateCitadelEditorInventory( Grunt, Captain, Champion );

	// assimilate the budget on the server
	assert( Budget != None ); // the Budget *must* be defined before the budget is assimilated
	for( i = 0; i < Budget.GetArrayCount(); i++ )
	{
		ItemName = Budget.GetResourceAdapterName( i );
		if( ItemName != '' ) 
		{
			Inv = FindInventoryName( ItemName );
			if( WOTInventory(Inv) != None )
			{
				WOTInventory(Inv).Count = Budget.GetItemCount( i );
			}
		}
	}
}

//===========================================================================
// Helper function for creating and intializing the hands.
//-----------------------------------------------------------------------------
simulated function CreateAngrealHands()
{
	local int i;
	local int j;
	local HandInfo Hand;
	local name ClassName;

	if( AngrealHandSet != None )
	{
		CurrentHandSet = AngrealHandSet;
		return;
	}
	
	AngrealHandSet = Spawn( class'HandSet', self );
	CurrentHandSet = AngrealHandSet;

	for( i = 0; i < AngrealHandSet.GetArrayCount(); i++ ) 
	{
		Hand = Spawn( class'HandInfo', Self );
		AngrealHandSet.SetHand( i, Hand );
	}

	// Default initialization
	for( i = 0; i < AngrealHandSet.GetArrayCount(); i++ ) 
	{
		Hand = AngrealHandSet.GetHand( i );
		for( j = 0; j < Hand.GetArrayCount(); j++ ) 
		{
			ClassName = AngrealHandOrder[ i * Hand.GetArrayCount() + j ];
			if( ClassName != '' ) 
			{
				Hand.AddClassName( ClassName, j );
			}
		}
	}
}

//-----------------------------------------------------------------------------
simulated function CreateCitadelEditorHands( class<WOTInventory> Grunt, class<WOTInventory> Captain, class<WOTInventory> Champion )
{
	local int i;
	local HandInfo Hand;

	if( CitadelEditorHandSet != None )
	{
		CurrentHandSet = CitadelEditorHandSet;
		return;
	}
		
	CitadelEditorHandSet = Spawn( class'HandSet', self );
	CurrentHandSet = CitadelEditorHandSet;

	for( i = 0; i < CitadelEditorHandSet.GetArrayCount(); i++ ) 
	{
		Hand = Spawn( class'HandInfo', Self );
		CitadelEditorHandSet.SetHand( i, Hand );

		switch( i ) 
		{
		case CE_SEALS:  
			Hand.AddClassName( 'SealInventory', 0 ); 
			break;
		case CE_GRUNT:	
			Hand.AddClassName( Grunt.Name, 0 );
			break;
		case CE_CAPTAIN:
			Hand.AddClassName( Captain.Name, 0 );
			Hand.AddClassName( Champion.Name, 1 );
			break;
		case CE_ALARM:
			Hand.AddClassName( 'AlarmInventory', 0 );
			break;
		case CE_SPEAR:
			Hand.AddClassName( 'SpearInventory', 0 );
			break;
		case CE_FIREWALL:
			Hand.AddClassName( 'FireWallInventory', 0 );
			break;
		case CE_WALL:
			Hand.AddClassName( 'WallInventory', 0 );
			break;
		case CE_PIT:
			Hand.AddClassName( 'PitInventory', 0 );
			break;
		case CE_STAIRCASE:
			Hand.AddClassName( 'StaircaseInventory', 0 );
			break;
		case CE_PORTCULLIS:
			Hand.AddClassName( 'PortcullisInventory', 0 );
			break;
		}
	}
}

//-----------------------------------------------------------------------------
function DestroyCitadelEditorHands()
{
	if( CitadelEditorHandSet != None )
	{
		CitadelEditorHandSet.Destroy();
		CitadelEditorHandSet = None;
	}
}

//-----------------------------------------------------------------------------
function CreateCitadelEditorInventory( class<WOTInventory> Grunt, class<WOTInventory> Captain, class<WOTInventory> Champion )
{
//log( "CreateCitadelEditorInventory()" );
	// don't allow the Citadel Editor Inventory to be duplicated
	if( FindInventoryName( 'SealInventory' ) != None )
	{
//log( "Citadel Editor Inventory already exists" );
		return;
	}

	CreateCitadelEditorInventoryItem( class<Inventory>( DynamicLoadObject( "WOT.SealInventory", class'Class' ) ) );
	CreateCitadelEditorInventoryItem( Grunt );
	CreateCitadelEditorInventoryItem( Champion );
	CreateCitadelEditorInventoryItem( Captain );
	CreateCitadelEditorInventoryItem( class<Inventory>( DynamicLoadObject( "WOTTraps.AlarmInventory", class'Class' ) ) );
	CreateCitadelEditorInventoryItem( class<Inventory>( DynamicLoadObject( "WOTTraps.SpearInventory", class'Class' ) ) );
	CreateCitadelEditorInventoryItem( class<Inventory>( DynamicLoadObject( "WOTTraps.FireWallInventory", class'Class' ) ) );
	CreateCitadelEditorInventoryItem( class<Inventory>( DynamicLoadObject( "WOTTraps.WallInventory", class'Class' ) ) );
	CreateCitadelEditorInventoryItem( class<Inventory>( DynamicLoadObject( "WOTTraps.PitInventory", class'Class' ) ) );
	CreateCitadelEditorInventoryItem( class<Inventory>( DynamicLoadObject( "WOTTraps.StaircaseInventory", class'Class' ) ) );
	CreateCitadelEditorInventoryItem( class<Inventory>( DynamicLoadObject( "WOTTraps.PortcullisInventory", class'Class' ) ) );
}

//-----------------------------------------------------------------------------
function CreateCitadelEditorInventoryItem( class<Inventory> NewClass )
{
	local Inventory Inv;

	// always give the CE objects to the player (don't call Game.PickupQuery -- it's set to inhibit pickups)
	Inv = Spawn( NewClass );
	if( Inv != None )
	{
		Inv.GiveTo( Self );
	}
}

//-----------------------------------------------------------------------------
function int GetIndex( WOTZoneInfo Zone )
{
    local int i;
    
    // select the next zone in the current section (wrap if necessary)
    for( i = 1; i < MAX_ZONE; i++ )
	{
        if( Zone == WOTZoneInfo( GetZoneInfo( i ) ) )
		{
			return i;
		}
    }

	return 0;
}

//=============================================================================
// Citadel Editor support functions
//-----------------------------------------------------------------------------
function class<WOTInventory> FindResourceAdapterClass( class ResourceClass )
{
	local Inventory Inv;
	local WOTInventory Item;

	for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
	{
		Item = WOTInventory(Inv);
		if( Item != None && Item.ResourceClass == ResourceClass )
		{
			return Item.Class;
		}
	}

	assert( false ); // couldn't find an adapter for the specified class -- this should never happen
}

//-----------------------------------------------------------------------------
simulated function ClientIncrementResource( class ItemClass )
{
	local Inventory Item;

	Item = FindInventoryType( ItemClass );
	assert( WOTInventory(Item) != None ); // the game *must* never update the count for a non-WOTInventory class
	WOTInventory(Item).Count++;
}

//-----------------------------------------------------------------------------
simulated function ClientDecrementResource( class ItemClass )
{
	local Inventory Item;

	Item = FindInventoryType( ItemClass );
	assert( WOTInventory(Item) != None ); // the game *must* never update the count for a non-WOTInventory class
	WOTInventory(Item).Count--;
}

//-----------------------------------------------------------------------------
// Uses components instead of vectors/rotators to avoid rounding problems.
//-----------------------------------------------------------------------------
function ServerCreateResource( class<actor> SpawnClass, float X, float Y, float Z, float NX, float NY, float NZ )
{
    local vector	Loc;
    local vector	Norm;
	local rotator	Rot;
	local actor		Resource;
	local class		AdapterClass;

    Loc.X = X;
    Loc.Y = Y;
    Loc.Z = Z;
    Norm.X = NX;
    Norm.Y = NY;
    Norm.Z = NZ;
	Rot = rotator( Norm );

	// allow the resource to adjust it's spawn location before being spawned (used by WOTPawn)
	SpawnClass.static.AdjustSpawnLocation( Self, Loc, Rot );

	// Owner is reset to None after the trap is successfully deployed (out of the player's possession)
	Resource = Spawn( SpawnClass, Self, '', Loc, Rot );
	if( Resource == None )
	{
		warn( "ServerSpawn() failed to spawn " $ SpawnClass );
		return;
	}

	if( !Resource.DeployResource( Loc, Norm ) )
	{
//		ClientMessage( CantPlaceResourceStr $ Resource );
		Resource.Destroy();
		return;
	}
	Resource.BeginEditingResource( PlayerReplicationInfo.Team );
	Resource.ActivateResource( true );
	Resource.Show();

	AdapterClass = FindResourceAdapterClass( Resource.class );
	Budget.Decrement( AdapterClass.Name );
	ClientDecrementResource( AdapterClass );
	
	ClientPlaySound( Resource.GetDeploySound() );
}

//-----------------------------------------------------------------------------
function ServerRemoveResource( actor Resource )
{
	local class AdapterClass;

	if( Resource == None )
	{
		warn( Self$".ServerRemoveResource( "$ Resource $" )" );
		return;
	}

//	ClientMessage( "ServerRemoveResource: "$ Resource );
	Resource = Resource.GetBaseResource();

//	ClientMessage( "  Base Resource: "$ Resource );
	if( Resource != None )
	{
		if( Resource.RemoveResource() ) 
		{
//			ClientMessage( "    Remove!" );
			AdapterClass = FindResourceAdapterClass( Resource.class );
			Budget.Increment( AdapterClass.Name );
			ClientIncrementResource( AdapterClass );

			ClientPlaySound( Resource.GetRemoveSound() );

			Resource.Destroy();
		}
	}
}

//-----------------------------------------------------------------------------
function ServerToggleResource( actor Resource )
{
	if( Resource == None )
	{
		warn( Self$".ServerToggleResource( "$ Resource $" )" );
		return;
	}

	if( Resource.IsResourceActive() )
	{
		ServerDeactivateResource( Resource, true );
	}
	else
	{
		ServerActivateResource( Resource, true );
	}
}

//-----------------------------------------------------------------------------
function ServerActivateResource( actor Resource, bool ChangeState )
{
	local class AdapterClass;

	if( Resource == None )
	{
		warn( Self$".ServerActivateResource( "$ Resource $", "$ ChangeState $" )" );
		return;
	}

	Resource = Resource.GetBaseResource();

	if( Resource != None )
	{
		if( Resource.ActivateResource( ChangeState ) )
		{
			if( ChangeState )
			{
				AdapterClass = FindResourceAdapterClass( Resource.class );
				Budget.Decrement( AdapterClass.Name );
				ClientDecrementResource( AdapterClass );

				ClientPlaySound( Resource.GetDeploySound() );
			}
		}
	}
}

//-----------------------------------------------------------------------------
function ServerDeactivateResource( actor Resource, bool ChangeState )
{
	local class AdapterClass;

	if( Resource == None )
	{
		warn( Self$".ServerDeactivateResource( "$ Resource $", "$ ChangeState $" )" );
		return;
	}

	Resource = Resource.GetBaseResource();

	if( Resource != None )
	{
		if( Resource.DeactivateResource( ChangeState ) )
		{
			if( ChangeState )
			{
				AdapterClass = FindResourceAdapterClass( Resource.class );
				Budget.Increment( AdapterClass.Name );
				ClientIncrementResource( AdapterClass );

				ClientPlaySound( Resource.GetRemoveSound() );
			}
		}
	}
}

//-----------------------------------------------------------------------------
function SetZoneNumber( int ZoneNum )
{
    SelectedZone = ZoneNum;
    ViewOffset = rot(0,0,0);

	ClientPlaySound( Sound( DynamicLoadObject( "WOT.Editor.EditSelect", class'Sound' ) ) );
}

//-----------------------------------------------------------------------------
function ServerBeginSelect( class<Actor> Resource )
{
	local int Team;
	local Actor A;
	local WOTZoneInfo Z;

	Team = PlayerReplicationInfo.Team;
	foreach AllActors( Resource, A ) 
	{
		Z = WOTZoneInfo(A.Region.Zone);
		if( Z != None && Z.Team == Team )
		{
			A.BeginSelectResource();
		}
	}
}

//-----------------------------------------------------------------------------
function ServerEndSelect( class<Actor> Resource )
{
	local int Team;
	local Actor A;
	local WOTZoneInfo Z;

	Team = PlayerReplicationInfo.Team;
	foreach AllActors( Resource, A ) 
	{
		Z = WOTZoneInfo(A.Region.Zone);
		if( Z != None && Z.Team == Team )
		{
			A.EndSelectResource();
		}
	}
}

function LocalSetEditPosition( vector NewLoc, rotator NewRot ); // not replicated

//=============================================================================
// Citadel Editor UI control -- base input handler 
// derived from PlayerWalking to gain access to PlayerWalking.PlayerTick()
//-----------------------------------------------------------------------------
state CitadelEditor expands PlayerWalking
{
ignores SeePlayer, HearNoise, Fire, UseAngreal;

    //-----------------------------------------------------------------------------
	exec function ShowMenu()
    {
		ServerEditCitadel();
	}

	//-----------------------------------------------------------------------------
    function BeginState()
    {
		local int Team;
		local Actor A;
		local WOTZoneInfo Z;

//Log( Self $".CitadelEditor.BeginState()" );
		Super.BeginState();

		if( myHUD != None )
		{
			PushUserInterfaceState();
			myHUD = spawn( class'EditorHUD', self );

			ClientPlaySound( Sound( DynamicLoadObject( "WOT.Editor.BeginEdit", class'Sound' ) ) );
		}

		if( Level.NetMode != NM_Client )
		{
			// BeginEditing Resource notifications
			Team = PlayerReplicationInfo.Team;
			foreach AllActors( class 'Actor', A ) 
			{
				Z = WOTZoneInfo(A.Region.Zone);
				if( Z != None && Z.Team == Team )
				{
					A.BeginEditingResource( Team );
				}
			}
		}

        ViewOffset = rot(0,0,0);
    }

    //-----------------------------------------------------------------------------
    exec function ServerEditCitadel( optional int Mode ) // leave edit mode
    {
		if( bProhibitEditorExit )
		{
			CenterMessage( CantLeaveEditorStr );
		}
		else
		{
			EndEdit();
		}
    }
    
    //-----------------------------------------------------------------------------
	function EndEdit()
	{
		ClientGotoState( 'PlayerWalking' );
		GotoState( 'PlayerWalking' );
	}

    //-----------------------------------------------------------------------------
	function EndState()
	{
		local int Team;
		local Actor A;
		local WOTZoneInfo Z;

//Log( Self $".CitadelEditor.EndState()" );
		Super.EndState();

		if( myHUD != None )
		{
			ClientPlaySound( Sound( DynamicLoadObject( "WOT.Editor.EndEdit", class'Sound' ) ) );

			PopUserInterfaceState();
			CurrentHandSet = AngrealHandSet;
		}

		// undo Citadel Editor settings
		bEditing = false;
		if( giMPBattle(Level.Game) != None ) giMPBattle(Level.Game).SetEditing( PlayerReplicationInfo.Team, bEditing );

		// put the player back at their start point
		if( EditStartLoc != vect(0,0,0) )
		{
			SetLocation( EditStartLoc );
			SetRotation( EditStartRot );
			ViewRotation = EditStartRot;
		}

		if( Level.NetMode != NM_Client )
		{
			// EndEditing Resource notifications
			Team = PlayerReplicationInfo.Team;
			foreach AllActors( class 'Actor', A ) 
			{
				Z = WOTZoneInfo(A.Region.Zone);
				if( Z != None && Z.Team == Team )
				{
					A.EndEditingResource();
				}
			}

			// finish end edit
			Budget.EndEdit( Self );
			AutoPlaceSealsOnAltar();
			giMPBattle(Level.Game).EnableTeamReady( Budget.Team );
		}

		// ClientReStart
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		BaseEyeHeight = Default.BaseEyeHeight;
		EyeHeight = BaseEyeHeight;
		PlayWaiting();
	}

    //-----------------------------------------------------------------------------
	function LocalSetEditPosition( vector NewLoc, rotator NewRot ) // not replicated
	{
		SetLocation( NewLoc );
		SetRotation( NewRot ); // sync the actor rotation with the camera view
		ViewRotation = NewRot; // set the camera view (actual rotation)
	}
}

//-----------------------------------------------------------------------------
// Citadel Editor UI control -- Roam Mode input handler 
//-----------------------------------------------------------------------------
state CitadelRoamMode expands CitadelEditor
{
    //-----------------------------------------------------------------------------
    function bool IsCursorFixed()
    {
        return true;
    }

    //-----------------------------------------------------------------------------
    function PlayerTick( float DeltaTime )
    {
        if( IsCursorFixed() )
		{
            // call PlayerPawn.PlayerTick() to move the player
            Super.PlayerTick( DeltaTime );

			// sync. editor position
			LocalSetEditPosition( Location, ViewRotation );
        }
    }
}

//-----------------------------------------------------------------------------
// Citadel Editor UI control -- Orbit Mode input handler 
//-----------------------------------------------------------------------------
state CitadelOrbitMode expands CitadelEditor
{
    //-----------------------------------------------------------------------------
    function BeginState()
    {
		Super.BeginState();

		// entry code for Ghost()
		UnderWaterTime = -1.0;  
		SetCollision( false, false, false );
		bCollideWorld = false;
		bHidden = true;
		SetPhysics( PHYS_None );
    }

    //-----------------------------------------------------------------------------
    function EndState()
    {
		Super.EndState();

		SelectedZone = 0;

		// entry code for Walk()
		UnderWaterTime = default.UnderWaterTime;	
		SetCollision( true, true , true );
		bCollideWorld = true;
		bHidden = false;
		SetPhysics( PHYS_Falling );
	}

    //-----------------------------------------------------------------------------
    exec function PrevView()
    {
        local WOTZoneInfo Zone;
        local int i;
        
        // select the previous zone in the current section (wrap if necessary)
        for( i = SelectedZone - 1; true; i-- )
		{
            if( i <= 0 ) i = MAX_ZONE;
            Zone = WOTZoneInfo( GetZoneInfo( i ) );
            if( Zone != None && Zone.IsZoneVisible( PlayerReplicationInfo.Team ) )
			{
                SetZoneNumber( i );
                return;
            }
        }
    }
    
    //-----------------------------------------------------------------------------
    exec function NextView()
    {
        local WOTZoneInfo Zone;
        local int i;
        
        // select the next zone in the current section (wrap if necessary)
        for( i = SelectedZone + 1; true; i++ )
		{
            if( i > MAX_ZONE ) i = 1;
            Zone = WOTZoneInfo( GetZoneInfo( i ) );
            if( Zone != None && Zone.IsZoneVisible( PlayerReplicationInfo.Team ) ) {
                SetZoneNumber( i );
                return;
            }
        }
    }
    
    //-----------------------------------------------------------------------------
    exec function SwitchView( int Index )
    {
        local int ZoneNum;
        local WOTZoneInfo Zone;
        
        for( ZoneNum = 1; ZoneNum <= MAX_ZONE; ZoneNum++ )
		{
            Zone = WOTZoneInfo( GetZoneInfo( ZoneNum ) );
            if( Zone != None && Zone.IsZoneVisible( PlayerReplicationInfo.Team ) && Index-- == 0 )
			{
                SetZoneNumber( ZoneNum );
                return;
            }
        }
    }
    
    //-----------------------------------------------------------------------------
    function PlayerTickEdit( float DeltaTime )
    {
        local WOTZoneInfo Zone;
        local vector Dest;
        local vector TestVector;
        
        //decellerate all inputs
        aForward *= 0.1;
        aStrafe  *= 0.1;
        aLookup  *= 0.3;
        aTurn    *= 0.3;
        aUp      *= 0.1;

        //find current WOTZoneInfo actor and look at it
        Zone = WOTZoneInfo( GetZoneInfo( SelectedZone ) );

        // Don't do anything if replication hasn't happened yet.
		if( Zone == None )
			return;

        // zoom the camera in and out
        Zone.EditViewDistance -= aForward * DeltaTime / 16;
        if( Zone.EditViewDistance < 5 )
            Zone.EditViewDistance = 5;
        else if( Zone.EditViewDistance > 100 )
            Zone.EditViewDistance = 100;

        // rotate the camera EditViewAngle around the zone actor
        Zone.EditViewAngle.Yaw -= 24.0 * aStrafe * DeltaTime;
        Zone.EditViewAngle = Normalize( Zone.EditViewAngle );
        
        // calc the new destination
        Dest = Zone.Location - vector(Zone.EditViewAngle) * Zone.EditViewDistance * 16;

        if( IsCursorFixed() )
		{
            // adjust the offset based on mouse input   
            ViewOffset.Pitch += 32.0 * DeltaTime * aLookUp;
            ViewOffset.Yaw += 32.0 * DeltaTime * aTurn;
            ViewOffset = Normalize( ViewOffset );
        }
        
        // rotate the camera to face the zone actor, offset by ViewOffset
        LocalSetEditPosition( Dest, Normalize( Zone.EditViewAngle + ViewOffset ) );
    }

    //-----------------------------------------------------------------------------
    function bool IsCursorFixed()
    {
		return true;
    }

    //-----------------------------------------------------------------------------
    function PlayerTick( float DeltaTime )
    {
        PlayerTickEdit( DeltaTime );
	}
}

//-----------------------------------------------------------------------------
exec function Vote( string Param )
{
	giWOT(Level.Game).VoteRequest( Self, Param );
}

//=============================================================================
// START OF DEBUG/CHEAT EXEC FUNCTIONS -- ONLY ENABLED ON CLIENTS WITH BADMIN.
//=============================================================================

function bool OKToCheat( optional bool bQuiet )
{
	local bool bRetVal;

	// can cheat any time in SP, only if bAdmin set in MP
	bRetVal = true;
	if( !bAdmin && (Level.Netmode != NM_Standalone) )
	{		
		bRetVal = false;
	}

	if( !bRetVal && !bQuiet )
	{
		CenterMessage( "Function is disabled on the server." );
	}

	return bRetVal;
}



// Used to remotely shut down the server.
exec function ServerExit()
{
	if( !OKToCheat() )
		return;

	ConsoleCommand( "EXIT" );
}

exec function SetTeam( int Team )
{
	if( !OKToCheat() )
		return;

	ServerChangeTeam( Team );
}

function ServerLog( string Msg )
{
	Log( Msg );
}

//=============================================================================
// Teleports player to where he is looking. 

simulated function DoTeleport()
{
	local vector HitLocation, HitNormal;
	local actor HitActor;

	HitActor = class'util'.static.GetHitActorInfo( Self, HitLocation, HitNormal, true );

	// note that SetLocation will not let you set an invalid location.
	// e.g. if you would be outside of the level, you won't be moved.
	
	// back off a bit so we aren't intersecting with what we hit
	if( Pawn(HitActor) == None || bTeleFragPawns )
	{
		SetLocation( HitLocation );
	}
	else
	{
		// it's still possible to telefrag a pawn if you aim at their feet etc.
		SetLocation( HitLocation - (CollisionRadius+Pawn(HitActor).default.CollisionRadius)*normal(vector(ViewRotation)) );
	}
	
	// stick to whatever was hit, unless a pawn
	if( Pawn(HitActor) == None )
	{
		bMovable = false;
	}

	AnimationTableClass.static.TweenSlotAnim( Self, LookupAnimSequence(JumpAnimSlot) );   
}

//=============================================================================

exec function Teleport()
{
	if( !OKToCheat() )
	{
		return;
	}

	DoTeleport();
}

//=============================================================================

simulated function DoUnTeleport()
{
	bMovable = true;

	if( AssetsHelper.GetCurrentTexture() == None )
	{
		// not on anything so tween to falling animation
		Falling();
	}
}

//=============================================================================

exec function UnTeleport()
{
	if( !OKToCheat( true ) )
	{
		return;
	}

	DoUnTeleport();
}

//=============================================================================

exec function GotoObject( name GotoObjectName )
{
	local Actor A;

	if( !OKToCheat() )
	{
		return;
	}

	foreach AllActors( class'Actor', A )
	{
		if( A.Name == GotoObjectName )
		{
			if( !SetLocation( A.Location ) )
			{
				ClientMessage( "Couldn't set location" );
			}

			return;
		}
	}

	ClientMessage( "Given Object " $ GotoObjectName $ " not found!" );
}

//=============================================================================
// Note: multiple float params don't seem to work...

exec function JumpTo( int x, int y, int z )
{
	local vector NewLocation;

	if( !OKToCheat() )
	{
		return;
	}

	NewLocation.x = x;
	NewLocation.y = y;
	NewLocation.z = z;

	if( !SetLocation( NewLocation ) )
	{
		ClientMessage( "Couldn't set location" );
	}
}

//=============================================================================

exec function Where()
{
	ClientMessage( Self $ ": Location: " $ Location.X $ ", " $ Location.Y $ ", " $ Location.Z );
}

//=============================================================================

function bool GetDebugActor( Name ActorNameToDebug, out Actor DebugActor )
{
	local bool bFoundActor;
	
	if( ActorNameToDebug == '' )
	{
		DebugActor = Self;
		bFoundActor = true;
	}
	else
	{
		bFoundActor = class'Util'.static.FindActorByName( Self, ActorNameToDebug, DebugActor );
	}
	
	Log( Self $ "::GetDebugActor returning " $ bFoundActor );
	Log( Self $ "::GetDebugActor DebugActor " $ DebugActor );
	
	return bFoundActor;
}	

//=============================================================================

function DebugToggleActor( Actor A, bool bMsg )
{
	if( A.DebugClass == class'Debug' )
	{
		A.DebugClass = class'LegendDebug';
	}
	else
	{
		A.DebugClass = class'Debug';
	}
}

//=============================================================================

exec function DebugEnable( class<Actor> TypeToDebug )
{
	local Actor CurrentDebugActor;

	if( !OKToCheat() )
	{
		return;
	}

	foreach AllActors( TypeToDebug, CurrentDebugActor )
	{
		CurrentDebugActor.DebugClass = class'LegendDebug';
	}
}

//=============================================================================

exec function DebugDisable( class<Actor> TypeToDebug )
{
	local Actor CurrentDebugActor;

	if( !OKToCheat() )
	{
		return;
	}

	foreach AllActors( TypeToDebug, CurrentDebugActor )
	{
		CurrentDebugActor.DebugClass = class'Debug';
	}
}

//=============================================================================

exec function DebugToggle( class<Actor> TypeToDebug )
{
	local Actor CurrentDebugActor;

	if( !OKToCheat() )
	{
		return;
	}

	if( TypeToDebug != None )
	{
		foreach AllActors( TypeToDebug, CurrentDebugActor )
		{
			DebugToggleActor( CurrentDebugActor, false );
		}
	}
	else
	{
		ClientMessage( "Invalid class!" );
	}
}

//=============================================================================

exec function Debug( Name ActorNameToDebug, string ExecCommand )
{
	local Actor DebugActor;

	if( !OKToCheat() )
	{
		return;
	}

	if( GetDebugActor( ActorNameToDebug, DebugActor ) )
	{
		class'Debug'.static.ExecDebugBehaviorInit( DebugActor, ExecCommand);
	}
}

//=============================================================================

exec function DebugAll( class<Actor> TypeToDebug, string ExecCommand )
{
	local Actor CurrentDebugActor;

	if( !OKToCheat() )
	{
		return;
	}

	foreach AllActors( TypeToDebug, CurrentDebugActor )
	{
		class'Debug'.static.ExecDebugBehaviorInit( CurrentDebugActor, ExecCommand );
	}
}

//=============================================================================

exec function DebugPatrols()
{
	local class<Debug> CurrentDebugClass;
	local PatrolController PatrolControllerIter;

	foreach AllActors( class'PatrolController', PatrolControllerIter )
	{
		CurrentDebugClass = PatrolControllerIter.DebugClass;
		PatrolControllerIter.DebugClass = class'LegendDebug';
		PatrolControllerIter.DebugLog( PatrolControllerIter );
		PatrolControllerIter.DebugClass = CurrentDebugClass;
	}
}

//=============================================================================

exec function DormantAll( class<LegendPawn> TypeToSetDormant )
{
	local Actor CurrentActor;

	if( !OKToCheat() )
	{
		return;
	}

	foreach AllActors( TypeToSetDormant, CurrentActor )
	{
		LegendPawn( CurrentActor ).ForceDormant();
	}
}

//=============================================================================

exec function UnDormantAll( class<LegendPawn> TypeToSetDormant )
{
	local Actor CurrentActor;

	if( !OKToCheat() )
	{
		return;
	}

	foreach AllActors( TypeToSetDormant, CurrentActor )
	{
		LegendPawn( CurrentActor ).UnForceDormant();
	}
}

//=============================================================================

exec function DebugToggleHitActor( string ExecCommand )
{
	local Actor DebugActor;
	local vector HitLocation, HitNormal;
	local actor HitActor;

	if( !OKToCheat() )
	{
		return;
	}

	HitActor = class'util'.static.GetHitActorInfo( Self, HitLocation, HitNormal, true );

	if( GetDebugActor( HitActor.Name, DebugActor ) )
	{
		DebugToggleActor( DebugActor, false );
	}
	
	ClientMessage( "HitActor: " $ HitActor.Name $ ": " $ HitActor.DebugClass );
}

//=============================================================================
// Plays the entire set of frames for all NPCs matching the given type.
// Useful for checking out animations/rates and to help check weapon 
// position/orientation wrt weapon triangle.

function DoPlayLoopAnims( Actor A, name AnimToPlay, float Rate, bool bLoop )
{
	if(A.Mesh == None )
	{
		ClientMessage( "DoPlayLoopAnimsA: " $ A $ " has no mesh!" );
	}

	if( AnimToPlay == '' )
	{
		AnimToPlay = 'All';
	}

	if( Rate == 0.0 )
	{
		Rate = 0.5;
	}

	A.Acceleration = vect(0,0,0);

	if( bLoop )
	{
		A.LoopAnim( AnimToPlay, Rate );

		// this pretty much disables the NPC but is necessary to keep the animation looping
		A.GotoState( '' );
	}
	else
	{
		A.PlayAnim( AnimToPlay, Rate );
	}
}

//=============================================================================

exec function PlayHitActorAnims( optional name AnimToPlay, optional float Rate )
{
	local actor HitActor;

	if( !OKToCheat() )
	{
		return;
	}

	HitActor = class'util'.static.GetHitActor( Self, true );

	DoPlayLoopAnims( HitActor, AnimToPlay, Rate, false );
}

//=============================================================================

exec function LoopHitActorAnims( optional name AnimToPlay, optional float Rate )
{
	local actor HitActor;

	if( !OKToCheat() )
	{
		return;
	}

	HitActor = class'util'.static.GetHitActor( Self, true );

	DoPlayLoopAnims( HitActor, AnimToPlay, Rate, true );
}



exec function DebugHitActorAnims()
{
	local actor HitActor;

	if( !OKToCheat() )
	{
		return;
	}

	HitActor = class'util'.static.GetHitActor( Self, true );

	if( WOTPlayer(HitActor) != None )
	{
		WOTPlayer(HitActor).bTestAnimTable = !WOTPlayer(HitActor).bTestAnimTable;

		if( WOTPlayer(HitActor).bTestAnimTable )
		{
			WOTPlayer(HitActor).AnimationTableClass.static.PerformSelfTest( HitActor );
		}
	}
	else if( WOTPawn(HitActor) != None )
	{
		WOTPawn(HitActor).bTestAnimTable = !WOTPawn(HitActor).bTestAnimTable;

		if( WOTPawn(HitActor).bTestAnimTable )
		{
			WOTPawn(HitActor).AnimationTableClass.static.PerformSelfTest( HitActor );
		}
	}
}



//=============================================================================
// testing

exec function ShowTeams()
{
	local Pawn P;
	
	if( !OKToCheat() )
	{
		return;
	}

	ClientMessage( " " );	// spacer
	foreach AllActors( class'Pawn', P )
	{
		ClientMessage( P.Name $ " Health: " $ P.Health $ ")" );

		if( P.PlayerReplicationInfo != None )
		{								   
			ClientMessage( "  Team: " $ P.PlayerReplicationInfo.Team );
			ClientMessage( "  TeamName: " $ P.PlayerReplicationInfo.TeamName ); // not available after startup?
		}
		else
		{
			ClientMessage( "  Team: no PlayerReplicationInfo!" );
			ClientMessage( "  TeamName: no PlayerReplicationInfo!" );
		}

		if( WotPlayer(P) != None )	
			ClientMessage( "  ApparentTeam: " $ WotPlayer(P).GetApparentTeam() $ " (" $ ApparentTeam $ ")" );
		else
			ClientMessage( "  ApparentTeam: NA" );
	}
}

//=============================================================================

exec function AllArtifacts()
{
	local int i;

	if( !OKToCheat() )
	{
		return;
	}

	for( i = 0; i < ArrayCount(ArtifactNames); i++ )
	{
		SA(i);
	}
}

//=============================================================================

exec function AllAngreal( optional bool bInfiniteCharges )
{
	local int i;
	local Inventory Inv;
	local class<AngrealInventory> AngrealClass;
	local AngrealInventory AngInv;

	if( !OKToCheat() )
	{
		return;
	}

	for( i = 0; i < ArrayCount(ArtifactNames); i++ )
	{	
		if( ArtifactNames[i] != "" )
		{
			AngrealClass = class<AngrealInventory>( DynamicLoadObject( ArtifactNames[i], class'Class' ) );

			if( AngrealClass != None )
			{
				AngInv = Spawn( AngrealClass );

				if( AngInv != None && Level.Game.PickupQuery( Self, AngInv ) )
				{
					AngInv.PickupSound = None;		// no pickup sound please
					AngInv.PickupMessage = "";		// no pickup message please
					AngInv.GiveTo( Self );
				}
			}
		}
	}

	// make sure we catch existing inventory items
	if( bInfiniteCharges )
		for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory ) 
			if(AngrealInventory(Inv)!=None) 
			{
				AngrealInventory(Inv).CurCharges = 999;			// indicate infinite ammo
				AngrealInventory(Inv).ChargeCost = 0;			// never runs out
			}
}

//=============================================================================

exec function AllAmmo()
{
	if( !OKToCheat() )
	{
		return;
	}

	AllAngreal( true );
}

//===========================================================================
// Easter Egg
//=============================================================================

exec function BB()
{
	local Pawn P;

	if( !OKToCheat() )
	{
		return;
	}

    foreach AllActors( class'Pawn', P )
	{
		if( P != Self )
		{
			P.Fatness = 164;
			P.SetCollisionSize( P.CollisionRadius * 0.3, P.CollisionHeight * 0.3 );
			P.DrawScale *= 0.3;
		}
    }
}

//=============================================================================

exec function Meteor()
{
	local Projectile Meteor;
	local vector HitLocation, SpawnLocation, HitNormal;
	
	if( !OKToCheat() )
	{
		return;
	}

	class'Util'.static.TraceRecursive( Self, SpawnLocation , HitNormal, Location, false,, vect(0,0,1) );
	class'Util'.static.TraceRecursive( Self, HitLocation, HitNormal, Location + vect(0,0,1) * BaseEyeHeight, false,, vector(ViewRotation) );
	Meteor = Spawn( class<Projectile>(DynamicLoadObject( "Angreal.AngrealFireballProjectile", class'Class' )),,, SpawnLocation, rotator(HitLocation - SpawnLocation) );
	Meteor.Instigator = Self;
}

//=============================================================================
// Section/Zone render testing
//=============================================================================

exec function SelectPlayerStart( int Team )
{
	local PlayerStart S;

	if( !OKToCheat() )
	{
		return;
	}

	foreach AllActors( class'PlayerStart', S )
	{
		if( S.TeamNumber == Team )
		{
			SetLocation( S.Location );
			SetPhysics( PHYS_Falling );
			break;
		}
	}
}

//=============================================================================
exec function SetZone( int Zone )
{
	if( !OKToCheat() )
	{
		return;
	}

	SetZoneNumber( SelectedZone );
}

//=============================================================================
// Sanity check to make sure my reflectors are installed in me.
//=============================================================================

exec function CheckReflectors()
{
	local Reflector ref;

	if( !OKToCheat() )
	{
		return;
	}

	ClientMessage( "Checking Reflectors:" );
	for( ref = CurrentReflector; ref != None; ref = ref.NextReflector )
	{
		if( ref.Owner == self )
		{
			ClientMessage( ref $" installed in self." );
		}
		else
		{
			ClientMessage( ref $ " not installed in self" );
		}
	}
}

//=============================================================================

exec function CheckLeeches()
{
	ClientCheckLeeches();
}

//=============================================================================

exec function ClientCheckLeeches()
{
	local Leech L;

	if( !OKToCheat() )
	{
		return;
	}

	ClientMessage( "Checking Leeches:" );
	for( L = FirstLeech; L != None; L = L.NextLeech )
	{
		if( L.Owner == Self )
		{
			ClientMessage( L $" attached to self." );
		}
		else
		{
			ClientMessage( L $ " not attached to self." );
		}
	}
}

//=============================================================================

exec function CheckInventory()
{
	local Inventory Inv;

	if( !OKToCheat() )
	{
		return;
	}

	ClientMessage( "Checking Inventory:" );
	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
	{
		if( Inv.Owner == self )
		{
			ClientMessage( Inv.class $ " installed in self." );
		}
		else
		{
			ClientMessage( Inv.class $ " not installed in self." );
		}
	}
}

//=============================================================================
// Debug function:
// Used to spawn your favorite angreal.
//=============================================================================

exec function SA( int i )
{
	local class<AngrealInventory> AngrealClass;
	
	if( !OKToCheat() )
	{
		return;
	}

	if( ArtifactNames[i] != "" )
	{
		AngrealClass = class<AngrealInventory>( DynamicLoadObject( ArtifactNames[i], class'Class' ) );
		if( AngrealClass != None )
		{
			Spawn( AngrealClass,,, Location + (SAOffset >> Rotation) );
		}
	}
}

//=============================================================================

exec function GiveItem( string ItemName )
{
	local class<Inventory> ItemClass;
	local Inventory Item;

	if( !OKToCheat() )
	{
		return;
	}

	ItemClass = class<Inventory>( DynamicLoadObject( ItemName, class'Class' ) );
	if( ItemClass != None )
	{
		Item = Spawn( ItemClass,,, Location + (SAOffset >> Rotation) );

		if( Item != None )
		{
			Item.Touch( Self );
		}
		else
		{
			ClientMessage( "Unable to Spawn "$ItemName );
		}
	}
	else
	{
		ClientMessage( ItemName$" is not an Inventory class." );
	}
}

//=============================================================================

exec function SelectItem( string ItemName )
{
	local class<Inventory> ItemClass;

	if( !OKToCheat() )
	{
		return;
	}

	ItemClass = class<Inventory>( DynamicLoadObject( ItemName, class'Class' ) );

	if( ItemClass != None )
	{
		CeaseUsingAngreal();
		SelectedItem = FindInventoryType( ItemClass );
	}
	else
	{
		ClientMessage( ItemName$" is not an Inventory class." );
	}
}

//=============================================================================
// testing

function DumpPawnsInventory( Pawn P, string Indent )
{
	local Inventory Inv;
	local int Count;
	
	// make sure we catch existing inventory items
	for( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory ) 
	{
		if( AngrealInventory(Inv) == None )
			ClientMessage( Indent $ Inv.Name $ ": " $ Inv.GetStateName() );
		else
			ClientMessage( Indent $ Inv.Name $ ": " $ Inv.GetStateName() $ " Charges:" $ AngrealInventory(Inv).CurCharges );
			
		Count++;
	}
	
	ClientMessage( Indent $ "    Inventory Count:" $ Count );
}

//=============================================================================

const NPCStats_Totals	= 0x01;
const NPCStats_PerNPC	= 0x02;
const NPCStats_PerNPCX	= 0x04;

const MaxNPCTypes		= 32;

// nWhich 1: totals only
// nWhich 2: per NPC only
// nWhich 3: per NPC info and totals (default)
// nWhich 6: per NCP info and detailed per NPC info (adds 2 flag) TBD
// nWhich 7: all info

exec function NPCStats( int WhichStat )
{
	local int PawnCount, TotalCount;
	local Pawn PawnIter;
	local int ClassNamesIter;

	if( !OKToCheat() )
	{
		return;
	}

	if( WhichStat == 0 )
	{
		// default:
		WhichStat = NPCStats_Totals | NPCStats_PerNPC;
	}

	if( ( WhichStat & NPCStats_PerNPCX ) != 0 )
	{
		// need PerNPC to do PerNPCX
		WhichStat = WhichStat | NPCStats_PerNPC;
	}

	ClientMessage( " " ); // one line spacer

	for( ClassNamesIter = 0; ClassNamesIter < ArrayCount( NPCNames ); ClassNamesIter++ )
	{
    	// count NPCs of this type
    	PawnCount = 0;
    	foreach AllActors( class'Pawn', PawnIter )
    	{
    		if( PawnIter.IsA( NPCNames[ ClassNamesIter ] ) )
    		{
    			PawnCount++;
    		}
    	}

    	if( PawnCount > 0 )
    	{
    		if( ( WhichStat & NPCStats_Totals ) != 0 )
    		{
    			// print out totals for this NPC
    			ClientMessage( NPCNames[ ClassNamesIter ] $ ": " $ PawnCount );
    		}

    		if( ( WhichStat & NPCStats_PerNPC ) != 0 )
    		{
    			// print out individual NPC info (2nd pass)
    			foreach AllActors( class'Pawn', PawnIter )
    			{	
    				if( PawnIter.IsA( NPCNames[ ClassNamesIter ] ) )
    				{
    					ClientMessage( "    " $ PawnIter.Name $ ": " $ PawnIter.GetStateName() $
    							" Hlth:" $ PawnIter.Health $ " Team:" $ PawnIter.PlayerReplicationInfo.Team $
    							" Event: " $ PawnIter.Event $ " Tag: " $ PawnIter.Tag $
    							" Distance: " $ VSize( Self.Location - PawnIter.Location ) );

    					if( ( WhichStat & NPCStats_PerNPCX ) != 0 )
    					{
    						// dump inventory and counts
    						DumpPawnsInventory( PawnIter, "        " );
    					}
    				}
    			}
    		}

	    	TotalCount += PawnCount;
    	}
    }			

	if( WhichStat != 1 )
	{
		ClientMessage( "Total NPCs: " $ TotalCount );
	}
}

//=============================================================================

exec function FactoryInfo( optional name FactoryName )
{
	local ActorFactory AF;

	if( !OKToCheat() )
	{
		return;
	}

	foreach AllActors( class'ActorFactory', AF )
	{
		if( FactoryName == '' || AF.Name == FactoryName )
		{
			AF.DumpInfo( Self );
		}
	}
}

//=============================================================================
// Enables on-screen information for actors which the player is looking at.

exec function ToggleShowHitActors()
{
	local HitActorInfoSpammer Spammer;

	if( !OKToCheat() )
	{
		return;
	}

	Spammer = HitActorInfoSpammer( class'HitActorInfoSpammer'.static.GetInstance( Self ) );

	bShowHitActors = !bShowHitActors;

	Spammer.EnableSpammer( bShowHitActors );
}

//=============================================================================
// Enables viewing LOS info for all visible actors, including those with
// collision disabled. The exact collision settings for actors might not be
// restored after this is done.

exec function EnableSpamHitActors()
{
	local HitActorInfoSpammer Spammer;

	if( !OKToCheat() )
	{
		return;
	}

	if( !bSpamHitActors )
	{
		// warn first time
		ClientMessage( "Warning: using this setting may affect collision values!" );
	}

	Spammer = HitActorInfoSpammer( class'HitActorInfoSpammer'.static.GetInstance( Self ) );

	Spammer.EnableSpamHitActors();

	bSpamHitActors = true;
}

//=============================================================================
// Use to see what you are looking at.
// + Identifies Actor / geometry your crosshair is pointing at.
// + Places a particle system at the HitLocation.

exec function DynamicCrosshair( optional bool bDebugMode )
{
	local bool bFoundExisting;
	local LeechIterator IterL;
	local Leech L;
	
	if( !OKToCheat() )
	{
		return;
	}

	// See if we have any on us, and remove them if we do.
	IterL = class'LeechIterator'.static.GetIteratorFor( Self );
	for( IterL.First(); !IterL.IsDone(); IterL.Next() )
	{
		L = IterL.GetCurrent();

		if( L.IsA('DynamicCrosshairLeech') )
		{
			L.UnAttach();
			L.Destroy();
			bFoundExisting = true;
		}
	}
	IterL.Reset();
	IterL = None;

	// If we didn't get rid of one, then put one on us.
	if( !bFoundExisting )
	{
		//L = Spawn( class<Leech>( DynamicLoadObject( "WOT.DynamicCrosshairLeech", class'Class' ) ) );
		L = Spawn( class'DynamicCrosshairLeech' );
		if( L != None )
		{
			DynamicCrosshairLeech(L).CrosshairType = class<ParticleSprayer>( DynamicLoadObject( "Angreal.SnowSprayer01", class'Class' ) );
			DynamicCrosshairLeech(L).bDebugMode = bDebugMode;
			L.AttachTo( Self );
		}
	}
}

//=============================================================================

exec function ShowViewTrace()
{
	if( !OKToCheat() )
	{
		return;
	}

	class'util'.static.DrawViewLine( Self );
}

//=============================================================================
// Do an "editactor class" for the object in view.

exec function EditHitActor()
{
	local vector OldLocation;
	local bool OldColActors, OldBlockActors, OldBlockPlayers;
	local actor HitActor;

	if( !OKToCheat() )
	{
		return;
	}

	HitActor = class'util'.static.GetHitActor( Self, !bSpamHitActors );

	OldLocation	= Location;
	OldColActors = bCollideActors;
	OldBlockActors = bBlockActors;
	OldBlockPlayers	= bBlockPlayers;

	SetCollision( false, false, false );
	SetLocation( HitActor.Location );

	ConsoleCommand( "editactor class=" $ HitActor.Class );
		
	SetLocation( OldLocation );
	SetCollision( OldColActors, OldBlockActors, OldBlockPlayers );
}

//=============================================================================
// testing

exec function DumpAll( class<Actor> DumpClass )
{
	local Actor A;
	local int CountMatchingActors;

	if( DumpClass != None )
	{
		foreach AllActors( DumpClass, A )
		{
			ClientMessage( A.Name $ " tag: " $ A.Tag $ " event: " $ A.Event );
			log( A.Name $ " tag: " $ A.Tag $ " event: " $ A.Event );
			CountMatchingActors++;
		}

		ClientMessage( "Matching Actors: " $ CountMatchingActors );
	}
	else
	{
		ClientMessage( "DumpAll: class is None!" );
	}
}

//=============================================================================

exec function NavPointList()
{
	if( !OKToCheat() )
	{
		return;
	}

	ClientMessage( "NavigationPointList: " $ Level.NavigationPointList );
}

//=============================================================================

exec function NumNodes()
{
	if( !OKToCheat() )
	{
		return;
	}

	DumpAll( Class'NavigationPoint' );
}

//=============================================================================
// Test the path node network, and tells you where it's broke.
//=============================================================================

exec function TestNodes()
{
	local NavigationPoint IterP, LastValid;
	local int TotalNodes, NodeCount;
	
	if( !OKToCheat() )
	{
		return;
	}

	foreach AllActors( class'NavigationPoint', IterP )
	{
		TotalNodes++;
	}

	for( IterP = Level.NavigationPointList; IterP != None; IterP = IterP.NextNavigationPoint )
	{
		LastValid = IterP;
		NodeCount++;
	}

	if( NodeCount == TotalNodes )
	{
		BroadcastMessage( "PathNodeNetwork("$NodeCount$"/"$TotalNodes$") is correct." );
	}
	else
	{
		BroadcastMessage( "PathNodeNetwork("$NodeCount$"/"$TotalNodes$") is broken at: "$LastValid );
	}
}

//=============================================================================
// Traverses all possible paths.
//=============================================================================

exec function TestPaths()
{
	local PathNodeIterator PNI;
	local NavigationPoint IterP;
	local int NumGoodPaths, NumBadPaths;

	if( !OKToCheat() )
	{
		return;
	}

	PNI = Spawn( class'PathNodeIterator' );
	
	foreach AllActors( class'NavigationPoint', IterP )
	{
		if( IterP != Level.NavigationPointList )
		{
			PNI.BuildPath( Level.NavigationPointList.Location, IterP.Location );
			if( PNI.NodeCount > 0 )
			{
				log( Level.NavigationPointList$" to "$IterP$" OK: "$PNI.NodeCount$" nodes." );
				NumGoodPaths++;
			}
			else
			{
				IterP.bHidden = false;
				IterP.DrawType = DT_Sprite;
				BroadcastMessage( Level.NavigationPointList$" to "$IterP$" FAILED: "$PNI.NodeCount$" nodes." );
				log( Level.NavigationPointList$" to "$IterP$" FAILED: "$PNI.NodeCount$" nodes." );
				NumBadPaths++;
			}
		}
	}

	BroadcastMessage( "GoodPaths: "$NumGoodPaths$" BadPaths: "$NumBadPaths );
}

exec function TestPathsII()
{
	local PathNodeIteratorII PNI;
	local NavigationPoint IterP;
	local int NumGoodPaths, NumBadPaths;

	if( !OKToCheat() )
	{
		return;
	}

	PNI = Spawn( class'PathNodeIteratorII' );
	
	foreach AllActors( class'NavigationPoint', IterP )
	{
		if( IterP != Level.NavigationPointList )
		{
			PNI.BuildPath( Level.NavigationPointList.Location, IterP.Location );
			if( PNI.NodeCount > 0 )
			{
				log( Level.NavigationPointList$" to "$IterP$" OK: "$PNI.NodeCount$" nodes." );
				NumGoodPaths++;
			}
			else
			{
				IterP.bHidden = false;
				IterP.DrawType = DT_Sprite;
				BroadcastMessage( Level.NavigationPointList$" to "$IterP$" FAILED: "$PNI.NodeCount$" nodes." );
				log( Level.NavigationPointList$" to "$IterP$" FAILED: "$PNI.NodeCount$" nodes." );
				NumBadPaths++;
			}
		}
	}

	BroadcastMessage( "GoodPaths: "$NumGoodPaths$" BadPaths: "$NumBadPaths );
}

exec function TestDrawQuickLine( optional float Length )
{
	local NavigationPoint IterP;

	if( Length > 0.0 )
		class'Util'.static.DrawQuickLine( Self, Location + (vect(0,0,1)*BaseEyeHeight), Location + (vect(0,0,1)*BaseEyeHeight) + ((vect(1,0,0)*Length) >> ViewRotation) );
	else
		foreach AllActors( class'NavigationPoint', IterP )
			class'Util'.static.DrawQuickLine( Self, Location,,, IterP );
}

//=============================================================================
// Draws a path from your current location to the target.
//=============================================================================

exec function DrawPathTo( name TargetClassName )
{
	local PathNodeIteratorII PNI;
	local NavigationPoint IterP, P;
	local vector LastLocation;
	local float DelayTime;
	local class<Actor> TargetClass;
	local Actor Target;
	local float FadeDuration;

	if( !OKToCheat() )
	{
		return;
	}

	ClearDrawnPaths();

	PNI = Spawn( class'PathNodeIteratorII' );
	TargetClass = class<Actor>( class'Util'.static.LoadClassFromName( TargetClassName ) );
	if( TargetClass == None )
	{
		ClientMessage( "Unable to identify package for "$ TargetClassName );
		return;
	}

	foreach AllActors( TargetClass, Target )
	{
		ClientMessage( "Drawing path to "$ Target $" @ "$ Target.Location );

		if( !PNI.BuildPath( Location, Target.Location ) )
		{
			ClientMessage( "FAILED!" );
		}
		LastLocation = Location;
		for( P = PNI.GetFirst(); P != None; P = PNI.GetNext() )
		{
			class'Util'.static.DrawLine3D( Self, LastLocation, P.Location, FadeDuration,,, DelayTime );
			DelayTime += 0.001;
			LastLocation = P.Location;
		}
		break;
	}
}

//=============================================================================
// Draws all paths from your current location to all other NavigationPoints
// in the level.
//
// Takes an optional fade duration.
//=============================================================================

exec function DrawPaths( optional float FadeDuration )
{
	local PathNodeIteratorII PNI;
	local NavigationPoint IterP, P;
	local vector LastLocation;
	local float DelayTime;

	if( !OKToCheat() )
	{
		return;
	}

	PNI = Spawn( class'PathNodeIteratorII' );
	
	foreach AllActors( class'NavigationPoint', IterP )
	{
		PNI.BuildPath( Location, IterP.Location );
		LastLocation = Location;
		for( P = PNI.GetFirst(); P != None; P = PNI.GetNext() )
		{
			class'Util'.static.DrawLine3D( Self, LastLocation, P.Location, FadeDuration,,, DelayTime );
			DelayTime += 0.001;
			LastLocation = P.Location;
		}
	}
}

//=============================================================================
// Clears the above created paths.
//
// Alternatively you can use >KILLALL LINE3D
//=============================================================================

exec function ClearDrawnPaths()
{
	local Line3D IterL;

	if( !OKToCheat() )
	{
		return;
	}

	foreach AllActors( class'Line3D', IterL )
	{
		IterL.Destroy();
	}
}

//=============================================================================
// Compares the two path node iterators against each other.
//=============================================================================

exec function ComparePNI( optional bool bShowAll )
{
	local PathNodeIterator PNI;
	local PathNodeIteratorII PNI2;
	local NavigationPoint IterP, P, P2;
	
	if( !OKToCheat() )
	{
		return;
	}

	PNI = Spawn( class'PathNodeIterator' );
	PNI2 = Spawn( class'PathNodeIteratorII' );

	foreach AllActors( class'NavigationPoint', IterP )
	{
		PNI.BuildPath( Location, IterP.Location );
		PNI2.BuildPath( Location, IterP.Location );

		log( "Path: "$IterP );

		P = PNI.GetFirst();
		P2 = PNI2.GetFirst();
		while( P != None && P2 != None )
		{
			if( P != P2 || bShowAll )
			{
				log( "	P: "$P$"	P2: "$P2 );
			}

			P = PNI.GetNext();
			P2 = PNI2.GetNext();
		}
	}
}


//=============================================================================
// Toggle bHidden flag for all actors which match the given class name that are
// bHidden by default (so actors which are normally visible won't be affected).

exec function ToggleShowClass( name ClassToShow )
{
	local Actor PN;

	if( !OKToCheat() )
	{
		return;
	}

	bShowHiddenClasses = !bShowHiddenClasses;

	foreach AllActors( class'Actor', PN )
	{
		if( PN.IsA( ClassToShow ) && PN.default.bHidden )
		{
			PN.bHidden = !bShowHiddenClasses;

			// use special sprite for shadow nodes
			if( WotPathNode( PN ) != None )
			{
				if( WotPathNode( PN ).GetDarkFlag() )
				{
					// show skull for shadow nodes
					PN.Texture = Texture'Engine.S_Corpse';
				}
			}
		}
	}

	if( bShowHiddenClasses )
	{
		ClientMessage( "Showing hidden " $ ClassToShow $ "s" );
	}
	else
	{
		ClientMessage( "Hiding hidden " $ ClassToShow $ "s" );
	}
}

//=============================================================================
// Traces to the Actor the crosshair is pointing at, and toggles their
// collision cylinder drawing on/off.
//
// Does not work for Actor which already have a RenderIterator other than
// CollisionCylinderRI.  (Example: ParticleSystems)

exec function TraceToggleShowCylinder()
{
	local vector HitLocation, HitNormal;
	local Actor HitActor;

	if( !OKToCheat() )
	{
		return;
	}

	HitActor = class'Util'.static.TraceRecursive( Self, HitLocation, HitNormal, Location + vect(0,0,1) * BaseEyeHeight, true,, vector(ViewRotation) );

	if( HitActor != None )
	{
		if( HitActor.RenderIteratorClass == None )
		{
			HitActor.RenderIteratorClass = class<RenderIterator>( DynamicLoadObject( "Legend.CollisionCylinderRI", class'Class' ) );
		}
		else if( HitActor.RenderIteratorClass.Name == 'CollisionCylinderRI' )
		{
			HitActor.RenderIteratorClass = None;
		}
		else
		{
			ClientMessage( HitActor$" already has a RenderIterator ("$HitActor.RenderIteratorClass.Name$")." );
		}
	}
}

//=============================================================================

exec function Summon( string ClassName )
{
	local string GivenClassName;
	local class<actor> NewClass;

	if( !OKToCheat() )
	{
		return;
	}

	GivenClassName = ClassName;
	
	if( instr( ClassName, "." ) >= 0 )
	{
		NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class' ) );
	}
	else
	{
		// no package given -- try various WOT packages
		ClassName = "WOT." $ GivenClassName;
		
		NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class', true ) );
		if( NewClass==None )
		{
			ClassName = "WOTPawns." $ GivenClassName;
		
			NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class', true ) );
			if( NewClass==None )
			{
				ClassName = "Angreal." $ GivenClassName;
		
				NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class', true ) );
				if( NewClass==None )
				{
					ClassName = "WOTDecorations." $ GivenClassName;
		
					NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class', true ) );
				}
			}
		}
	}

	if( NewClass!=None )
	{
		log( "Summon: fabricated a " $ ClassName );

		Spawn( NewClass,,,Location + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
	}
	else
	{
		log( "Summon: class " $ GivenClassName $ " not found!" );

		ClientMessage( "  Class " $ GivenClassName $ " not found!" );
	}
}

//=============================================================================

exec function SetSpeed( float F )
{
	if( !OKToCheat() )
	{
		return;
	}

	// restore default values before applying SetSpeed 
	ScaleSpeedSettings( 1.0 );

	GroundSpeed = default.GroundSpeed * F;
	WaterSpeed = default.WaterSpeed * F;

	bSetSpeedCheatOn = ( F != 1.0 );
}

//=============================================================================

exec function SummonTeam( byte ATeam, string ClassName )
{
	local WotPawn WP;
	local class<WotPawn> NewClass;

	if( !OKToCheat() )
	{
		return;
	}

	if( ClassName == "" )
	{
		ClientMessage( "SummonTeam: no classname given!" );
		return;
	}

	ClassName = "WOTPawns." $ ClassName;

	NewClass = class<WotPawn>( DynamicLoadObject( ClassName, class'Class' ) );

	if( NewClass != None )
	{
		if( ClassIsChildOf(NewClass, class'WOTPawn') )
		{
			WP = Spawn( NewClass,,,Location + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
	
			if( WP != None && WP.PlayerReplicationInfo != None )
			{
				WP.PlayerReplicationInfo.Team = ATeam;
			}
			else
			{
				ClientMessage( "SummonTeam: error spawning class!" );
			}
		}
		else
		{
			ClientMessage( "SummonTeam: class isn't a WOTPawn!" );
		}
	}
	else
	{
		ClientMessage( "SummonTeam: error loading class " $ ClassName $ "!" );
	}
}

//=============================================================================

exec function ShowNodes()
{
	if( !OKToCheat() )
	{
		return;
	}

	ToggleShowClass( 'PathNode' );
}

//=============================================================================

exec function SetFOV( float F )
{
	if( !OKToCheat() )
	{
		return;
	}

	if( LooksLikeAWOTPlayer() )
	{
		DefaultFOV = FClamp(F, 1, 170);
		DesiredFOV = DefaultFOV;
	}
}

//=============================================================================

exec function LogReverb( string ReverbComment )
{
	log( Region.Zone $" "$ ReverbComment );
	log( "  bReverbZone     = "$ Region.Zone.bReverbZone );
	log( "  bRaytraceReverb = "$ Region.Zone.bRaytraceReverb );
	log( "  SpeedOfSound    = "$ Region.Zone.SpeedOfSound );
	log( "  MasterGain      = "$ Region.Zone.MasterGain );
	log( "  CutoffHz        = "$ Region.Zone.CutoffHz );
	log( "  Delay[0]        = "$ Region.Zone.Delay[0] );
	log( "  Delay[1]        = "$ Region.Zone.Delay[1] );
	log( "  Delay[2]        = "$ Region.Zone.Delay[2] );
	log( "  Delay[3]        = "$ Region.Zone.Delay[3] );
	log( "  Delay[4]        = "$ Region.Zone.Delay[4] );
	log( "  Delay[5]        = "$ Region.Zone.Delay[5] );
	log( "  Gain[0]         = "$ Region.Zone.Gain[0] );
	log( "  Gain[1]         = "$ Region.Zone.Gain[1] );
	log( "  Gain[2]         = "$ Region.Zone.Gain[2] );
	log( "  Gain[3]         = "$ Region.Zone.Gain[3] );
	log( "  Gain[4]         = "$ Region.Zone.Gain[4] );
	log( "  Gain[5]         = "$ Region.Zone.Gain[5] );
}

//=============================================================================
// testing: show given missionobjectives

exec function SMO( class<Actor> MOC )
{
	local bool bActive;
	local Actor A;

	bActive = uiHUD(myHUD).IsWindowActive( class'MissionObjectivesWindow' );

	uiHUD(myHUD).RemoveWindows();
	if( !bActive )
	{
		foreach AllActors( MOC, A )
		{
			uiHUD(MyHUD).AddWindow( class'MissionObjectivesWindow', MissionObjectives(A) );
			break;
		}
	}
}

//=============================================================================

exec function ForceClass( string NewClass )
{
	local class<WOTPlayer> WPClass;

	if( OKToCheat() && NewClass != "" )
	{
		NewClass = "WOTPawns." $ NewClass;

		WPClass = class<WOTPlayer>( DynamicLoadObject( NewClass, class'Class') );
		if( WPClass != None )
		{
			ServerChangeClass( WPClass );
		}
		else
		{
			ClientMessage( "Error loading " $ NewClass );
		}
	}
}

// END OF DEBUG/CHEAT EXEC FUNCTIONS.
//=============================================================================

// end of WOTPlayer.uc

defaultproperties
{
     bSkipProgressFog=True
     MinDamageToShake=5.000000
     RespawnDelaySecs=1.000000
     bTeleFragPawns=True
     RestartLevelDelaySecs=2.000000
     NPCNames(0)=Trolloc
     NPCNames(1)=Myrddraal
     NPCNames(2)=BATrolloc
     NPCNames(3)=Minion
     NPCNames(4)=MashadarManager
     NPCNames(5)=Legion
     NPCNames(6)=Soldier
     NPCNames(7)=Archer
     NPCNames(8)=Questioner
     NPCNames(9)=Warder
     NPCNames(10)=Sister
     NPCNames(11)=Sitter
     NPCNames(12)=BlackAjah
     NPCNames(13)=BlackAjahBoss
     MinTimeBetweenTaunts=1.000000
     TextureHelperClass=Class'WOT.GenericTextureHelper'
     DamageHelperClass=Class'WOT.GenericDamageHelper'
     VolumeMultiplier=1.000000
     RadiusMultiplier=1.000000
     PitchMultiplier=1.000000
     TimeBetweenHitSoundsMin=1.000000
     TimeBetweenHitSoundsMax=3.000000
     HitHardHealthRatio=0.250000
     ExceptionalDeathHealthRatio=0.250000
     WalkBackwardSpeedMultiplier=0.700000
     SpeedPlayAnimAfterLanding=1100.000000
     PlayLandHardMinVelocity=1200.000000
     PlayLandSoftMinVelocity=600.000000
     LadderLandingNoiseVelocity=200.000000
     LadderLandedHitNormalZ=0.001000
     GibForSureFinalHealth=-40.000000
     GibSometimesFinalHealth=-30.000000
     GibSometimesOdds=0.500000
     BaseGibDamage=40.000000
     ArtifactNames(0)="Angreal.AngrealInvLightGlobe"
     ArtifactNames(1)="Angreal.AngrealInvDart"
     ArtifactNames(2)="Angreal.AngrealInvFireball"
     ArtifactNames(3)="Angreal.AngrealInvSeeker"
     ArtifactNames(4)="Angreal.AngrealInvTarget"
     ArtifactNames(5)="Angreal.AngrealInvHeal"
     ArtifactNames(6)="Angreal.AngrealInvFork"
     ArtifactNames(7)="Angreal.AngrealInvReflect"
     ArtifactNames(8)="Angreal.AngrealInvAbsorb"
     ArtifactNames(9)="Angreal.AngrealInvDecay"
     ArtifactNames(11)="Angreal.AngrealInvMinion"
     ArtifactNames(12)="Angreal.AngrealInvGuardian"
     ArtifactNames(13)="Angreal.AngrealInvChampion"
     ArtifactNames(14)="Angreal.AngrealInvEarthTremor"
     ArtifactNames(15)="Angreal.AngrealInvAirShield"
     ArtifactNames(16)="Angreal.AngrealInvEarthShield"
     ArtifactNames(17)="Angreal.AngrealInvFireShield"
     ArtifactNames(18)="Angreal.AngrealInvSpiritShield"
     ArtifactNames(19)="Angreal.AngrealInvWaterShield"
     ArtifactNames(20)="Angreal.AngrealInvShield"
     ArtifactNames(21)="Angreal.AngrealInvShift"
     ArtifactNames(22)="Angreal.AngrealInvTaint"
     ArtifactNames(23)="Angreal.AngrealInvSoulBarb"
     ArtifactNames(24)="Angreal.AngrealInvAMA"
     ArtifactNames(25)="Angreal.AngrealInvRemoveCurse"
     ArtifactNames(26)="Angreal.AngrealInvLightning"
     ArtifactNames(27)="Angreal.AngrealInvBalefire"
     ArtifactNames(28)="Angreal.AngrealInvWhirlwind"
     ArtifactNames(30)="Angreal.AngrealInvExpWard"
     ArtifactNames(31)="Angreal.AngrealInvTracer"
     ArtifactNames(32)="Angreal.AngrealInvWallOfAir"
     ArtifactNames(33)="Angreal.AngrealInvDistantEye"
     ArtifactNames(34)="Angreal.AngrealInvLevitate"
     ArtifactNames(35)="Angreal.AngrealInvSwapPlaces"
     ArtifactNames(36)="Angreal.AngrealInvTrapDetect"
     ArtifactNames(37)="Angreal.AngrealInvIllusion"
     ArtifactNames(38)="Angreal.AngrealInvDisguise"
     ArtifactNames(39)="Angreal.AngrealInvSpecial"
     ArtifactNames(40)="Angreal.AngrealInvIce"
     ArtifactNames(41)="Angreal.AngrealInvAirBurst"
     SubTitlesPackageName=WOTSubtitles
     SubTitleLanguages(0)="est"
     SubTitleLanguages(1)="itt"
     MessageDurationSecsPerChar=0.066000
     MinMessageDuration=3.000000
     InventoryInfoHintDuration=5.000000
     AngrealHandOrder(0)=AngrealInvBalefire
     AngrealHandOrder(1)=AngrealInvFireball
     AngrealHandOrder(2)=AngrealInvFireworks
     AngrealHandOrder(3)=AngrealInvEarthTremor
     AngrealHandOrder(4)=AngrealInvDart
     AngrealHandOrder(5)=AngrealInvAirBurst
     AngrealHandOrder(10)=AngrealInvSeeker
     AngrealHandOrder(11)=AngrealInvLightning
     AngrealHandOrder(12)=AngrealInvSoulBarb
     AngrealHandOrder(13)=AngrealInvDecay
     AngrealHandOrder(14)=AngrealInvTaint
     AngrealHandOrder(20)=AngrealInvShield
     AngrealHandOrder(21)=AngrealInvFireShield
     AngrealHandOrder(22)=AngrealInvAirShield
     AngrealHandOrder(23)=AngrealInvEarthShield
     AngrealHandOrder(24)=AngrealInvWaterShield
     AngrealHandOrder(25)=AngrealInvSpiritShield
     AngrealHandOrder(30)=AngrealInvAbsorb
     AngrealHandOrder(31)=AngrealInvReflect
     AngrealHandOrder(32)=AngrealInvSwapPlaces
     AngrealHandOrder(33)=AngrealInvShift
     AngrealHandOrder(34)=AngrealInvFork
     AngrealHandOrder(40)=AngrealInvAMA
     AngrealHandOrder(41)=AngrealInvRemoveCurse
     AngrealHandOrder(42)=AngrealInvWallOfAir
     AngrealHandOrder(50)=AngrealInvIce
     AngrealHandOrder(51)=AngrealInvExpWard
     AngrealHandOrder(52)=AngrealInvTarget
     AngrealHandOrder(53)=AngrealInvWhirlwind
     AngrealHandOrder(60)=AngrealInvChampion
     AngrealHandOrder(61)=AngrealInvGuardian
     AngrealHandOrder(62)=AngrealInvMinion
     AngrealHandOrder(63)=AngrealInvIllusion
     AngrealHandOrder(70)=AngrealInvHeal
     AngrealHandOrder(71)=AngrealInvLevitate
     AngrealHandOrder(72)=AngrealInvDisguise
     AngrealHandOrder(80)=AngrealInvTracer
     AngrealHandOrder(81)=AngrealInvTrapDetect
     AngrealHandOrder(82)=AngrealInvDistantEye
     AngrealHandOrder(83)=AngrealInvLightGlobe
     AngrealHandOrder(90)=Seal
     AngrealHandOrder(91)=AngrealInvSpecial
     PlayerRestartGameDelay=15.000000
     SAOffset=(X=64.000000)
     DefaultReflectorClasses(0)=Class'WOT.DefaultProcessEffectReflector'
     DefaultReflectorClasses(1)=Class'WOT.DefaultTargetingReflector'
     DefaultReflectorClasses(2)=Class'WOT.DefaultHealthReflector'
     DefaultReflectorClasses(3)=Class'WOT.DefaultCastReflector'
     DefaultReflectorClasses(4)=Class'WOT.DefaultTakeDamageReflector'
     DefaultReflectorClasses(5)=Class'WOT.DamageTakeDamageReflector'
     DefaultReflectorClasses(6)=Class'WOT.SetupAssetClassesReflector'
     DefaultReflectorClasses(7)=Class'WOT.WOTFootZoneChangeReflector'
     ApparentClass=Class'WOT.WOTPlayer'
     ApparentTeam=-1
     PlayerColor=PC_Blue
     PlayerTroops(0)=(Player=AesSedai,Troop=Grunt,TroopClassName="WOTPawns.Warder")
     PlayerTroops(1)=(Player=AesSedai,Troop=Captain,TroopClassName="WOTPawns.Sister")
     PlayerTroops(2)=(Player=AesSedai,Troop=Champion,TroopClassName="WOTPawns.Sitter")
     PlayerTroops(3)=(Player=Forsaken,Troop=Grunt,TroopClassName="WOTPawns.Trolloc")
     PlayerTroops(4)=(Player=Forsaken,Troop=Captain,TroopClassName="WOTPawns.Myrddraal")
     PlayerTroops(5)=(Player=Forsaken,Troop=Champion,TroopClassName="WOTPawns.BATrolloc")
     PlayerTroops(6)=(Player=Hound,Troop=Grunt,TroopClassName="WOTPawns.Minion")
     PlayerTroops(7)=(Player=Hound,Troop=Captain,TroopClassName="WOTPawns.MashadarFocusPawn")
     PlayerTroops(8)=(Player=Hound,Troop=Champion,TroopClassName="WOTPawns.Legion")
     PlayerTroops(9)=(Player=Whitecloak,Troop=Grunt,TroopClassName="WOTPawns.Soldier")
     PlayerTroops(10)=(Player=Whitecloak,Troop=Captain,TroopClassName="WOTPawns.Archer")
     PlayerTroops(11)=(Player=Whitecloak,Troop=Champion,TroopClassName="WOTPawns.Questioner")
     CarcassType=Class'WOT.WOTCarcassHumanoid'
     QuickSaveString=""
     GroundSpeed=400.000000
     AirSpeed=400.000000
     AccelRate=2048.000000
     AirControl=1.000000
     BaseEyeHeight=42.000000
     UnderWaterTime=30.000000
     Physics=PHYS_Walking
     DrawType=DT_Mesh
     CollisionRadius=17.000000
     CollisionHeight=46.000000
     bRotateToDesired=False
     Mass=175.000000
     Buoyancy=150.000000
     RotationRate=(Pitch=15000,Yaw=0,Roll=0)
}
