//=============================================================================
// LevelInfo contains information about the current level. There should 
// be one per level and it should be actor 0. UnrealEd creates each level's 
// LevelInfo automatically so you should never have to place one
// manually.
//
// The ZoneInfo properties in the LevelInfo are used to define
// the properties of all zones which don't themselves have ZoneInfo.
//=============================================================================
class LevelInfo extends ZoneInfo
	native;

// Textures.
#exec Texture Import File=Textures\DefaultTexture.pcx //NEW

//-----------------------------------------------------------------------------
// Level time.

// Time passage.
var() float TimeDilation;          // Normally 1 - scales real time passage.

// Current time.
var           float	TimeSeconds;   // Time in seconds since level began play.
var transient int   Year;          // Year.
var transient int   Month;         // Month.
var transient int   Day;           // Day of month.
var transient int   DayOfWeek;     // Day of week.
var transient int   Hour;          // Hour.
var transient int   Minute;        // Minute.
var transient int   Second;        // Second.
var transient int   Millisecond;   // Millisecond.

//-----------------------------------------------------------------------------
// Text info about level.

var() localized string Title;
var()           string Author;		    // Who built it.
var() localized string IdealPlayerCount;// Ideal number of players for this level. I.E.: 6-8
var() int	RecommendedEnemies;			// number of enemy bots recommended (used by rated games)
var() int	RecommendedTeammates;		// number of friendly bots recommended (used by rated games)
var() localized string LevelEnterText;  // Message to tell players when they enter.
var()           string LocalizedPkg;    // Package to look in for localizations.
var             string Pauser;          // If paused, name of person pausing the game.

//#if 1 //NEW
var	bool bDisableAmbientSound;			// controls whether ambient sound plays
//#endif

var levelsummary Summary;

//-----------------------------------------------------------------------------
// Flags affecting the level.

var() bool           bLonePlayer;     // No multiplayer coordination, i.e. for entranceways.
var bool             bBegunPlay;      // Whether gameplay has begun.
var bool             bPlayersOnly;    // Only update players.
var bool             bHighDetailMode; // Client high-detail mode.
var bool			 bDropDetail;	  // frame rate is below DesiredFrameRate, so drop high detail actors
var bool             bStartup;        // Starting gameplay.
var() bool			 bHumansOnly;	  // Only allow "human" player pawns in this level
var bool			 bNoCheating;	  
var bool			 bAllowFOV;

//-----------------------------------------------------------------------------
// Audio properties.

var(Audio) const music  Song;          // Default song for level.
var(Audio) const byte   SongSection;   // Default song order for level.
var(Audio) const byte   CdTrack;       // Default CD track for level.
var(Audio) float        PlayerDoppler; // Player doppler shift, 0=none, 1=full.

//-----------------------------------------------------------------------------
// Miscellaneous information.

var() float Brightness;
var() texture Screenshot;
var texture DefaultTexture;
var int HubStackLevel;
var transient enum ELevelAction
{
	LEVACT_None,
	LEVACT_Loading,
	LEVACT_Saving,
	LEVACT_Connecting,
	LEVACT_Precaching
} LevelAction;

//-----------------------------------------------------------------------------
// Networking.

var enum ENetMode
{
	NM_Standalone,        // Standalone game.
	NM_DedicatedServer,   // Dedicated server, no local client.
	NM_ListenServer,      // Listen server.
	NM_Client             // Client only, no local server.
} NetMode;
var string ComputerName;  // Machine's name according to the OS.
var string EngineVersion; // Engine version.
var string MinNetVersion; // Min engine version that is net compatible.

//-----------------------------------------------------------------------------
// Gameplay rules

var() class<gameinfo> DefaultGameType;
var GameInfo Game;

//-----------------------------------------------------------------------------
// Navigation point and Pawn lists (chained using nextNavigationPoint and nextPawn).

var const NavigationPoint NavigationPointList;
var const Pawn PawnList;
//#if 1 //NEW
var const Projectile ProjectileList;
//#endif

//-----------------------------------------------------------------------------
// Server related.

var string NextURL;
var bool bNextItems;
var float NextSwitchCountdown;

//-----------------------------------------------------------------------------
// Actor Performance Management

var int AIProfile[8]; // TEMP statistics
var float AvgAITime;	//moving average of Actor time

//-----------------------------------------------------------------------------
// Physics control

var() bool bCheckWalkSurfaces; // enable texture-specific physics code for Pawns.

//#if 1 //NEW
//-----------------------------------------------------------------------------
// MP3 playback

var() string MP3Filename;

//-----------------------------------------------------------------------------
// Path validation

var bool bPathsRebuilt;

/* needs more debugging.
//-----------------------------------------------------------------------------
// Collection support

struct TClassType
{
	var() name ClassName;
	var() bool bIncludeSubclasses;
};

struct TCollection
{
	var() name CollectionName;
//	var() TClassType ClassTypes[10];	// Unreal's compiler apparently doesn't support array of structs within arrays of struct.  :(
	var transient ActorCollection Collection;
};

var() TClassType ClassTypes[160];	// 10x16

var() TCollection Collections[16];

simulated final function ActorCollection GetCollection( name CollectionName )
{
	local int i;

	for( i = 0; i < ArrayCount(Collections); i++ )
	{
		if( default.Collections[i].CollectionName == CollectionName )
		{
			if( Collections[i].Collection == None )
			{
				Collections[i].Collection = new(None) class'ActorCollection';
			}
			return Collections[i].Collection;
		}
	}

	warn( "Invalid CollectionName: "$CollectionName );
	return None;
}
*/
//#endif

//-----------------------------------------------------------------------------
// Functions.

//#if 1 //NEW
//
// Add and remove projectiles to the projectile list.
// (This is done on both the client and server.)
//
// Use: for( Proj = Level.ProjectileList; Proj != None; Proj = Proj.nextProjectile )
// to iterate across all projectiles in the level.
//
native(1070) final function AddProjectile( Projectile Proj );
native(1071) final function RemoveProjectile( Projectile Proj );
//#endif

//
// Return the URL of this level on the local machine.
//
native simulated function string GetLocalURL();

//
// Return the URL of this level, which may possibly
// exist on a remote machine.
//
native simulated function string GetAddressURL();

//
// Jump the server to a new level.
//
event ServerTravel( string URL, bool bItems )
{
	if( NextURL=="" )
	{
		bNextItems          = bItems;
		NextURL             = URL;
		if( Game!=None )
			Game.ProcessServerTravel( URL, bItems );
		else
			NextSwitchCountdown = 0;
	}
}

//-----------------------------------------------------------------------------
// Network replication.

replication
{
	reliable if( Role==ROLE_Authority )
		Pauser, TimeDilation, bNoCheating, bAllowFOV;
}

/*
	 Collections(0)=(CollectionName=DetectableTraps)
	 ClassTypes(0)=(ClassName=Trap,bIncludeSubclasses=True)
	 ClassTypes(1)=(ClassName=AngrealExpWardProjectile)
*/

defaultproperties
{
     TimeDilation=1.000000
     Title="Untitled"
     bHighDetailMode=True
     CdTrack=255
     Brightness=1.000000
     DefaultTexture=Texture'Engine.DefaultTexture'
     bCheckWalkSurfaces=True
     bHiddenEd=True
}
