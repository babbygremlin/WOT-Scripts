//=============================================================================
// WOTPawn.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 50 $
//=============================================================================

class WOTPawn expands LegendPawn abstract native config(WOTPawns);

#exec AUDIO IMPORT FILE=Sounds\UI\CitadelEditor\DeployPawn.wav    GROUP=Editor
#exec AUDIO IMPORT FILE=Sounds\UI\CitadelEditor\RemovePawn.wav    GROUP=Editor

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

//-----------------------------------------------------------------------------
// Keeps track of the number of hit points the pawn's shield has.
//-----------------------------------------------------------------------------
var int ShieldHitPoints;

// Suicide instigator support.
var Pawn SuicideInstigator;			// The guy that gets points if you kill yourself.
var float SuicideInstigationTime;	// When the guy "touched" us last.  Scoreing only takes 
									// SuicideInstigation into accout if it happened recently.

var name NextAnimSlot;			// next animation sequence to play and/or tween to (for hits)

var Texture DisguiseIcon;		// Used when the player Disguises as this pawn

const TeamNPC	= 255;
const TeamPC	= 254;
const TeamNone	= 253;
const TeamAny	= 252;

var() byte AssignedTeam;

var () float MinTimeBetweenWeaponSwitch;
var float LastWeaponSwitchTime;

var() float GroundSpeedMin;
var() float GroundSpeedMax;
var() config float HealthMPMin;
var() config float HealthMPMax;
var() config float HealthSPMin;
var() config float HealthSPMax;
var() float ChanceOfHitAnim;		// Odds that a hit anim is played

//=============================================================================
// asset handling 

var(WOTSounds) class<GenericTextureHelper>		TextureHelperClass;
var()		   class<GenericDamageHelper>		DamageHelperClass;
var GenericAssetsHelper							AssetsHelper;				// per-instance -- destroy as needed

var(WOTSounds) class<SoundTableWOT>				SoundTableClass;
var SoundTableWOT								MySoundTable;				// shared singleton -- do not destroy

var(WOTSounds) class<SoundSlotTimerListInterf>	SoundSlotTimerListClass;
var SoundSlotTimerListInterf					MySoundSlotTimerList;		// per-instance -- destroy as needed

var(WOTSounds) float							VolumeMultiplier;
var(WOTSounds) float							RadiusMultiplier;
var(WOTSounds) float							PitchMultiplier;
var(WOTSounds) float							TimeBetweenHitSoundsMin;
var(WOTSounds) float							TimeBetweenHitSoundsMax;

var(WOTAnims) class<AnimationTableWOT>			AnimationTableClass;
var bool										bTestAnimTable;
var float										NextPainSoundTime;

var(Pawn) class<carcass>						CarcassType;				// type of carcass to spawn

var() float HitHardHealthRatio;
var() float HitSoftHealthRatio;
var() float ExceptionalDeathHealthRatio;
var() float DestroyDelaySecs;

var() float SpeedPlayAnimAfterLanding;
var() float MinLandedDamageVelocity;
var() float FatalLandedDamageVelocity;
var() float PlayLandHardMinVelocity;
var() float PlayLandSoftMinVelocity;

var() float GibForSureFinalHealth;			// if NPC dies with this much health (e.g. -40) will be gibbed for sure
var() float GibSometimesFinalHealth;		// if NPC dies with this much health (e.g. -30) will be gibbed sometimes
var() float GibSometimesOdds;				// odds of gibbing if final health is GibSometimesFinalHealth or less
var() float BaseGibDamage;					// min damage needed to gib at GibForSureFinalHealth (passed on to carcass)
var() bool bNeverGib;						// like the name says -- passed on to carcass (could be set in pawns placed in level so they won't gib in some cases)

var bool bCarcassSpawned;					// whether Pawn has been "converted" to a carcass

var() float SpawnSeparation;				// the distance that pawns are spawned from the player while editing

var bool bEditing;							// set while Pawn is being edited

// wotpawn anims:
const BreathAnimSlot				= 'Breath';    
const DeathAnimSlot					= 'Death';    
const FallAnimSlot					= 'Fall';      
const HitAnimSlot					= 'Hit';      
const HitHardAnimSlot				= 'HitHard';  
const JumpAnimSlot					= 'Jump';      
const LandAnimSlot					= 'Land';    
const LookAnimSlot					= 'Look';    
const RunAnimSlot					= 'Run';       
const SwimAnimSlot					= 'Swim';
const WaitAnimSlot					= 'Wait';       
const WalkAnimSlot					= 'Walk';       



//=============================================================================
// Utility functions:
//=============================================================================



function WarnNoOverload( coerce string strFunction )
{
	class'Debug'.static.DebugWarn( Self, "didn't override " $ strFunction, 'WOTPawn' );
}



function WarnNoOverloadState( coerce string strFunction )
{
	class'Debug'.static.DebugWarn( Self, "didn't override " $ strFunction, 'WOTPawn' );
}



function bool PrepareInventoryItem( Inventory InventoryItem );



function bool ShouldPrepareInventoryItem( Inventory InventoryItem )
{
	local bool bPrepareItem;
	
	if( ( InventoryItem != None ) && InventoryItem.IsA( 'WotWeapon' ) )
	{
		bPrepareItem = WotWeapon( InventoryItem ).ShouldBePreparedBy( Self );
	}

	return bPrepareItem;
}



function bool SwitchToBestWeapon()
{
	local float rating;
	local int usealt;		// not used at present
	local bool bReturn;

	class'Debug'.static.DebugLog( Self, "WotPawn::SwitchToBestWeapon", 'WOTPawn' );
	class'Debug'.static.DebugLog( Self, "WotPawn::SwitchToBestWeapon Self.Weapon " $ Weapon, 'WOTPawn' );

	if( ( ( Level.TimeSeconds - LastWeaponSwitchTime ) >= MinTimeBetweenWeaponSwitch ) && GetPendingWeapon( PendingWeapon ) )
	{
		if( PendingWeapon != None )
		{
			class'Debug'.static.DebugLog( Self, "WotPawn::SwitchToBestWeapon PendingWeapon != None", 'WOTPawn' );
			bReturn = ( usealt > 0 );
			if( Weapon == None )
			{
				class'Debug'.static.DebugLog( Self, "WotPawn::SwitchToBestWeapon Weapon == None", 'WOTPawn' );
				//there is not a current weapon
				ChangedWeapon();
				LastWeaponSwitchTime = Level.TimeSeconds;
			}
			else if( Weapon != PendingWeapon )
			{
				class'Debug'.static.DebugLog( Self, "WotPawn::SwitchToBestWeapon Weapon != PendingWeapon", 'WOTPawn' );
				class'Debug'.static.DebugLog( Self, "WotPawn::SwitchToBestWeapon Self.Weapon.state " $ Weapon.GetStateName(), 'WOTPawn' );
		
				//there is a current weapon
				//the pending weapon is not the current weapon
				Weapon.PutDown();
				LastWeaponSwitchTime = Level.TimeSeconds;
			}
		}
		else if( Weapon != None )
		{
			class'Debug'.static.DebugLog( Self, "WotPawn::SwitchToBestWeapon PendingWeapon == None", 'WOTPawn' );
			class'Debug'.static.DebugLog( Self, "WotPawn::SwitchToBestWeapon Self.Weapon.state " $ Weapon.GetStateName(), 'WOTPawn' );

			//there is a current weapon
			//the pending weapon is none
			Weapon.PutDown();
			LastWeaponSwitchTime = Level.TimeSeconds;
			Weapon = None;
		}
	}
	class'Debug'.static.DebugLog( Self, "WotPawn::SwitchToBestWeapon Self.Weapon " $ Weapon, 'WOTPawn' );
	class'Debug'.static.DebugLog( Self, "WotPawn::SwitchToBestWeapon Self.PendingWeapon " $ PendingWeapon, 'WOTPawn' );
	return bReturn;
}



function bool GetPendingWeapon( out Weapon NewPendingWeapon )
{
	local float Rating;
	local int UseAlt;
	if( Inventory != None )
	{
		NewPendingWeapon = Inventory.RecommendWeapon( Rating, UseAlt );
	}
	else
	{
		NewPendingWeapon = None;
	}
	return ( NewPendingWeapon != None );
}



// Just changed to pendingWeapon
function ChangedWeapon()
{
	class'Debug'.static.DebugLog( Self, "WotPawn::ChangedWeapon", 'WOTPawn' );
	
	if( Weapon == PendingWeapon )
	{
		class'Debug'.static.DebugLog( Self, "WotPawn::ChangedWeapon Weapon == PendingWeapon", 'WOTPawn' );
		if( Weapon == None )
		{
			SwitchToBestWeapon();
		}
		else if( Weapon.GetStateName() == 'DownWeapon' )
		{
			Weapon.BringUp();
		}
		PendingWeapon = None;
	}
	else
	{
		class'Debug'.static.DebugLog( Self, "WotPawn::ChangedWeapon Weapon != PendingWeapon", 'WOTPawn' );
		if( PendingWeapon == None )
		{
			PendingWeapon = Weapon;
		}
		
		if( !ShouldPrepareInventoryItem( PendingWeapon ) )
		{
			//the pending weapon is not a wot weapon
			//or it is a wot weapon that shound not be prepared
			PlayWeaponSwitch( PendingWeapon );
		}
		
		if( ( PendingWeapon != None ) &&
				( PendingWeapon.Mass > 20 ) &&
				( CarriedDecoration != None ) )
		{
			DropDecoration();
		}
		
		if( ShouldPrepareInventoryItem( PendingWeapon ) )
		{
			class'Debug'.static.DebugLog( Self, "WotPawn::ChangedWeapon ShouldPrepareInventoryItem", 'WOTPawn' );
			//wot weapons set the pawns weapon
			PendingWeapon.BringUp();
			if( ( Level.Game != None ) && ( Level.Game.Difficulty > 1 ) )
			{
				MakeNoise(0.1 * Level.Game.Difficulty);
			}
		}
		else
		{
			Weapon = PendingWeapon;
			if( Weapon != None )
			{
				Weapon.BringUp();
				if( ( Level.Game != None ) && ( Level.Game.Difficulty > 1 ) )
				{
					MakeNoise(0.1 * Level.Game.Difficulty);
				}
			}
			PendingWeapon = None;
		}
	}
}



function SetSoundTable( SoundTableWOT SoundTable )
{
	MySoundTable = SoundTable;
}



function SetSoundSlotTimerList( SoundSlotTimerListInterf SoundSlotTimerList )
{
	MySoundSlotTimerList = SoundSlotTimerList;
}



function SetupAssetClasses()
{
	if( CurrentReflector != None )
	{
		CurrentReflector.SetupAssetClasses();
	}
}


//-----------------------------------------------------------------------------
function SetSuicideInstigator( Pawn Other )
{
	SuicideInstigator = Other;
	SuicideInstigationTime = Level.TimeSeconds;
}

simulated event SetInitialState()
{
	class'Debug'.static.DebugLog( Self, "SetInitialState", DebugCategoryName );
	SetMovementPhysics();
	Super.SetInitialState();
	if( !Level.bStartup )
	{
		class'Debug'.static.DebugLog( Self, "SetInitialState pawn factory fix", DebugCategoryName );
		// this is occuring some time after the game has started
		// fix for our PawnFactories -- default to auto
		// state if Pawn is being created after level loaded for now.
		GotoState( 'Auto' );
	}
}

//=============================================================================
// Install default reflectors on start up.
//-----------------------------------------------------------------------------

function PreBeginPlay()
{
	local int i;
	local Reflector DefaultReflector;

	class'Debug'.static.DebugLog( Self, "PreBeginPlay", 'WOTPawn' );
	Super.PreBeginPlay();

	if( ( PlayerReplicationInfoClass != None ) && ( PlayerReplicationInfo == None ) )
	{
		//there is a player replication info type to allocate
		//a player replication info has not been allocated
		PlayerReplicationInfo = Spawn( PlayerReplicationInfoClass, Self );
		InitPlayerReplicationInfo();
	}

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

	if( Level.Netmode == NM_Standalone )
	{
		Health = RandRange( HealthSPMin, HealthSPMax );
	}
	else
	{
		Health = RandRange( HealthMPMin, HealthMPMax );
	}

	GroundSpeed	= RandRange( GroundSpeedMin, GroundSpeedMax );

	if( AnimationTableClass == None )
	{
		warn( Self $ "::AnimationTableClass not set!" );
		Destroy();
	}	    
	else if( bTestAnimTable )
	{
		// call AnimationTableClass test function
		AnimationTableClass.static.PerformSelfTest( Self );
	}

	SetupAssetClasses();
}

//=============================================================================

simulated function Destroyed()
{
	CancelAngrealEffects();
	class'WOTUtil'.static.RemoveAllReflectorsFrom( Self );

	if( MySoundSlotTimerList != None )
	{
		MySoundSlotTimerList.Destroy();
	}
	if( AssetsHelper != None )
	{
		AssetsHelper.Destroy();
	}

	Super.Destroyed();
}

//=============================================================================

function InitPlayerReplicationInfo()
{
	class'Debug'.static.DebugLog( Self, "InitPlayerReplicationInfo PlayerReplicationInfo: " $ PlayerReplicationInfo, 'WOTPawn' );
	if( PlayerReplicationInfo != None )
	{
		Super.InitPlayerReplicationInfo();
		PlayerReplicationInfo.Team = AssignedTeam;
		PlayerReplicationInfo.bIsNPC = true;
		PlayerReplicationInfo.PlayerName = NameArticle $ string(Class.Name);
	}
}

//=============================================================================

function Died( Pawn Killer, name DamageType, vector HitLocation )
{
	CancelAngrealEffects();
	Super.Died( Killer, DamageType, HitLocation );
}

//-----------------------------------------------------------------------------
event bool PreTeleport( Teleporter InTeleporter )
{
	// troops ignore teleporters during the Citadel Game (ignore for all MP games to simplify code)
	if( Level.NetMode != NM_Standalone )
	{
		return true; // don't teleport
	}
	return false;
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

	if( AngrealInventory(SelectedItem) != None )
	{
		AngrealInventory(SelectedItem).UnCast();
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
// same as WOTPlayer.uc PainTimer()
event PainTimer()
{
	Super.PainTimer();

	if( Health > 0 && WOTZoneInfo(FootRegion.Zone) != None && WOTZoneInfo(FootRegion.Zone).bHealZone )
	{
		if( Health < 100 ) 
		{
			// playing sound removed for Pawns -- they won't know the difference
			Health += WOTZoneInfo(FootRegion.Zone).HealPerSec;
			Health = min( Health, 100 );
		}
		PainTime = 1.0;
	}
}




event WalkTexture( texture Texture, vector StepLocation, vector StepNormal )
{
	if( AssetsHelper != None )
	{
		AssetsHelper.HandleTextureCallback( Texture );
	}
}



//=============================================================================
// Citadel Editor support functions.
//-----------------------------------------------------------------------------

function sound GetDeploySound()
{
	return Sound( DynamicLoadObject( "WOT.Editor.DeployPawn", class'Sound' ) );
}



function sound GetRemoveSound()
{
	return Sound( DynamicLoadObject( "WOT.Editor.RemovePawn", class'Sound' ) );
}



function BeginEditingResource( int PlacedByTeam )
{
	Super.BeginEditingResource( PlacedByTeam );
	bEditing = true;
	AssignedTeam = PlacedByTeam;
	PlayerReplicationInfo.Team = PlacedByTeam;
	ForceDormant();
}



event EncroachedBy( actor Other )
{
}



function EndEditingResource()
{
	Super.EndEditingResource();
	bEditing = false;
	UnForceDormant();
}



simulated function Actor GetBaseResource()
{
	return Self;
}



function actor AnyActorsInArea( vector SearchLocation, int SearchDistance )
{
	local Actor A;

	foreach RadiusActors( class'Actor', A, SearchDistance, SearchLocation )
	{
		if( !SameLogicalActor( A ) && !A.bHidden /*&& !A.IsA( 'Brush' )*/ )
		{
			return A;
		}
	}

	return None;
}



function bool SameLogicalActor( Actor Other )
{
	if( Self == Other )
	{
		return true;
	}
	if( Self == Other.Owner )
	{
		return true;
	}
	return false;
}



static function CalcLocation( actor Other, out vector Loc, out rotator Rot )
{
	local vector Offset;

	Rot = Other.Rotation;
	Rot.Pitch = 0;
	Offset = vector(Rot) * ( Other.CollisionRadius + default.CollisionRadius + default.SpawnSeparation );
	Loc = Other.Location + Offset;
}



static function AdjustSpawnLocation( actor Other, out vector Loc, out rotator Rot )
{
	CalcLocation( Other, Loc, Rot );

	// move pawn a foot off the floor to avoid telefragging on geometry
	Loc.Z += 16;
}



function bool DeployResource( vector Loc, vector StartNormal )
{
	local rotator Rot;

	CalcLocation( Owner, Loc, Rot );
	SetPhysics( PHYS_Falling );
	SetWaitingGoal( Loc, Rot );

	return true;
}



function bool RemoveResource()
{
	Hide();
	return true;
}



function Hide()
{
	Super.Hide();
	SetCollision( false, false, false );
}



function Show()
{
	Super.Show();
	SetCollision( default.bCollideActors, default.bBlockActors, default.bBlockPlayers );
}



//=============================================================================
// Animation & AI Support
//-----------------------------------------------------------------------------



function AlarmSounded( Alarm NotifyingAlarm ) // Final.  Override in NPC classes
{
	// do nothing
}



//=============================================================================
// Called by Captain to send Grunt investigating.
//     Capt            = Captain doing the alerting
//     TargetPlayer    = who the captain saw
//     NewGoalLocation = where Capt last saw TargetPlayer 
//-----------------------------------------------------------------------------



function AlertedByCaptain( Captain AlertingCapt )
{
	// do nothing
}



//=============================================================================
// Returns `true' if the Pawn can currently be given new orders (by, say,
// a Captain with FindHelp orders).  Returns `false' if Pawn is already
// currently occupied.
//
// Default is true.
//---------------------------------------------------------------------------
function bool CanBeGivenNewOrders()
{
    return true;    
}



function bool FindLeader()
{
    class'Debug'.static.DebugWarn( Self, Class $ "FindLeader didn't override", 'WOTPawn' );
	return false;
}



//Are self and Other members of the same faction?
function bool IsFriendly( Actor Other )
{
	local bool bOnTeam, bOnApparentTeam, bFriendly;
	local Pawn OtherPawn;
	local WotPlayer OtherWotPlayer;
		
	class'Debug'.static.DebugLog( Self, "IsFriendly Other: " $ Other, 'WOTPawn' );
	OtherPawn = Pawn( Other );
   	if( OtherPawn != None )
   	{
		//the other actor is a pawn
   		if( PlayerReplicationInfo != None )
   		{
   		
   			switch( PlayerReplicationInfo.Team )
   			{
   				case TeamNPC:
					//friendly to other teamless NPCs and disguised players
					class'Debug'.static.DebugLog( Self, "IsFriendly TeamNPC", 'WOTPawn' );
					bFriendly = ( (WotPawn(Other) != None && WotPawn(Other).PlayerReplicationInfo.Team == TeamNPC) || ( WotPlayer(Other) != None && WotPlayer(Other).GetApparentTeam() == TeamNPC) );
   					break;
   				case TeamPC:
					//friendly to players
					class'Debug'.static.DebugLog( Self, "IsFriendly TeamPC", 'WOTPawn' );
					bFriendly = ( WotPlayer(Other) != None );
   					break;
   				case TeamNone:
					//friendly to none
					class'Debug'.static.DebugLog( Self, "IsFriendly TeamNone", 'WOTPawn' );
					bFriendly = false; 
   					break;
   				case TeamAny:
					//friendly to everyone
					class'Debug'.static.DebugLog( Self, "IsFriendly TeamAny", 'WOTPawn' );
					bFriendly = true; 
   					break;
   				default:
			  		//this pawn has a player replication info
					class'Debug'.static.DebugLog( Self, "IsFriendly Self.PlayerReplicationInfo.Team: " $ PlayerReplicationInfo.Team, 'WOTPawn' );
	
					//the other pawn has a player replication info
					//if it is on this team it is always friendly
   					bOnTeam = ( ( OtherPawn.PlayerReplicationInfo != None ) &&
   							( OtherPawn.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team ) );

					if( !bOnTeam )
					{
						//possibly-disguised player?
						OtherWotPlayer = WotPlayer( OtherPawn );
						bOnApparentTeam = ( ( OtherWotPlayer != None ) &&
								( OtherWotPlayer.GetApparentTeam() == PlayerReplicationInfo.Team ) );
					}
   					break;
   			}
		}
  	}
  	else
  	{
  		//the other actor is not a pawn
  		//if it is not a pawn, assume that it is friendly?
	 	bFriendly = true;
  	}

	class'Debug'.static.DebugLog( Self, "::IsFriendly bFriendly " $ bFriendly, 'WOTPawn' );	
	class'Debug'.static.DebugLog( Self, "::IsFriendly bOnTeam " $ bOnTeam, 'WOTPawn' );	
	class'Debug'.static.DebugLog( Self, "::IsFriendly bOnApparentTeam " $ bOnApparentTeam, 'WOTPawn' );	
	class'Debug'.static.DebugLog( Self, "::IsFriendly returning " $ ( bFriendly || bOnTeam || bOnApparentTeam ), 'WOTPawn' );	
	return ( bFriendly || bOnTeam || bOnApparentTeam );
}

//=============================================================================

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
	class'Debug'.static.DebugLog( Self, "PlayDeathHit", 'WOTPawn' );

	AnimationTableClass.static.TweenPlaySlotAnim( Self, DeathAnimSlot );   

	if( !Gibbed( DamageType ) || ( Level.NetMode == NM_Standalone && GetGoreDetailLevel() <= 1 ) )
	{
		// we are planning to have "exceptional" vs ordinary death cries though
		if( IsExceptionalDeath() )
		{
			MySoundTable.PlaySlotSound( Self, MySoundTable.DieHardSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
		}	
		else
		{
			MySoundTable.PlaySlotSound( Self, MySoundTable.DieSoftSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
		}
	}
}

//=============================================================================

function bool IsHardHit( int Damage )
{
	return ( Damage >= HitHardHealthRatio * default.health );
}

//=============================================================================

function bool IsSoftHit( int Damage )
{
	return ( Damage >= HitSoftHealthRatio * default.health );
}



//===========================================================================
//===========================================================================

state Dying
{
	//===========================================================================
	// Unreal behavior is to fire up timer 0.3 (hard-coded) seconds after Pawn
	// enters the dying state. WOT approach is to use notification functions to
	// tell us when the Pawn is on/near the ground and at this point we spawn the 
	// carcass. The dying Pawn continues to take damage while the death anim is
	// playing and, if enough damage is done, will gib. The carcass will inherit
	// the current health of the Pawn that creates it.

	// NPCs sometimes go falling after dying if we don't disable this
	function TransitionToFalling();

	function PawnToCarcassTransition( bool bGibbed )
	{
		if( !bHidden )
		{
			DoSpawnCarcass( bGibbed );

			if( bIsPlayer )
			{
				HidePlayer();
			}

			bCarcassSpawned = true;
			bHidden = true;
			SetCollision( false, false, false );
			bProjTarget=false;
			GotoState( 'Dying', 'LabelDestroy' );
		}
	}

	//===========================================================================

	function TransitionToCarcassNotification()
	{
		PawnToCarcassTransition( false );
	}

	//===========================================================================

	function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, name DamageType )
	{
		if( bDeleteMe || bHidden )
		{
			return;
		}

		Health = Health - Damage;
		Momentum = Momentum/Mass;
		AddVelocity( Momentum ); 

		if( !bHidden && !bCarcassSpawned )
		{
			if( !bNeverGib && Health < (BaseGibDamage/Damage * GibForSureFinalHealth) )
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

	event AnimEnd()
	{
		if( !bHidden )
		{
			// in case notification never arrives...
			warn( Level.TimeSeconds $ ": " $ Self $ ".Dying -- TransitionToCarcassNotification never received for " $ AnimSequence );
			PawnToCarcassTransition( false );
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
		// should no longer be able to control its movement
		SetPhysics( Phys_Falling );

		if( Tag == 'Balefired' )
		{
			SetPhysics( PHYS_None );
			Acceleration = vect(0,0,0);

			// balefire works on carcasses and stops animation so create carcass right away	
			PawnToCarcassTransition( false );
		}
	}

	function EndState()
	{
		bCarcassSpawned = false;
	}

LabelDestroy:
	// destroy after X secs so dying sound can be stopped if 
	// carcass gibbed (carcass keeps a reference to Pawn)
	Sleep( DestroyDelaySecs );
	Destroy();
}

//=============================================================================

function name GetHitAnimSeqName( vector HitLoc, int Damage )
{
	if( IsHardHit( Damage ) )
	{
		return HitHardAnimSlot;
	}
	else if( IsSoftHit( Damage ) )
	{
		return HitAnimSlot;
	}
	else
	{
		return '';
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
 	if ( Level.TimeSeconds >= NextPainSoundTime )
	{
		NextPainSoundTime = Level.TimeSeconds + RandRange( TimeBetweenHitSoundsMin, TimeBetweenHitSoundsMax );

		if ( damageType == 'drowned' )
		{
			MySoundTable.PlaySlotSound( Self, MySoundTable.DrownSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
		}
		else if( IsHardHit( Damage ) )
		{
			MySoundTable.PlaySlotSound( Self, MySoundTable.HitHardSoundSlot, Mult*VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
		}
		else
		{
			MySoundTable.PlaySlotSound( Self, MySoundTable.HitSoftSoundSlot, Mult*VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
		}
	}
}



function PlayHit( float Damage, vector HitLocation, name DamageType, float MomentumZ )
{
	PlayTakeHitSound( Damage, DamageType, 1.0 );

	if( FRand() < ChanceOfHitAnim )
	{
		TransitionToTakeHitState( Damage, HitLocation, DamageType, MomentumZ );
	} 
}


function TransitionToTakeHitState( float Damage, vector HitLocation, name DamageType, float MomentumZ )
{
	class'Debug'.static.DebugLog( Self, "TransitionToTakeHitState", class'Debug'.default.DC_BehaviorTransition );
	NextAnimSlot = GetHitAnimSeqName( HitLocation, Damage );
	if( NextAnimSlot != '' )
	{
		GetNextStateAndLabelForReturn( NextState, NextLabel );
		GotoState( 'TakeHitState' );
	}
}




function PlayInAir()
{
	// regular jump
    BaseEyeHeight = 0.7 * Default.BaseEyeHeight;

	MySoundTable.PlaySlotSound( Self, MySoundTable.JumpSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );

	AnimationTableClass.static.TweenSlotAnim( Self, JumpAnimSlot );   
}



function PlayLanded( float ImpactVelocity )
{
	if( Health > 0 )
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



function Landed( vector HitNormal ) 
{
	local float Damage;

	SetMovementPhysics();

	if( Velocity.Z < -1.4 * JumpZ )
	{
		MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));

		if( Role == ROLE_Authority && Velocity.Z <= MinLandedDamageVelocity -850)
		{
			if( (Velocity.Z < FatalLandedDamageVelocity) && (ReducedDamageType != 'All') )
			{
				Damage = Health + 250; //make sure gibs (and spawns lotsa blood)
			}
			else
			{
				Damage = -0.15 * (Velocity.Z + 1050);
			}

			TakeDamage( Damage, None, Location, vect(0,0,0), 'fell');
		}
	}

	if( Health > 0 )
	{
		// still alive: record landing for texture sound, play pain appropriate sound

		// pawn is in the air so texture is None, but sound will be played with next walktexture
		AssetsHelper.HandleLandedOnTexture( Velocity.Z );

		if ( !IsAnimating() )
		{
			PlayLanded( Velocity.Z );
		}
	}

	bJustLanded = true;
}



function PlayMovementSound()
{
    if( !FootRegion.Zone.bWaterZone ) 
	{
		if( AssetsHelper != None )
		{
			AssetsHelper.HandleMovingOnTexture();
		}
	}
}



function SetMovementPhysics() // Final. Copied from ScriptedPawn; override again for flyers/swimmers
{
	if( ( Physics != PHYS_Falling ) && ( Physics != PHYS_Walking ) )
	{
		SetPhysics( PHYS_Walking );
	}
}

//===========================================================================
// Overridden so we can control when WOTPawns will gib.

function bool Gibbed( Name DamageType )
{
	return !bNeverGib && class'WOTUtil'.static.WOTGibbed( Self, DamageType, GibForSureFinalHealth, GibSometimesFinalHealth, GibSometimesOdds );
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

//=============================================================================
// When a player is disguised, most, but not all animations from the PC mesh
// exist using the same name in the NPC mesh.
// 
// Use this function to map the desired PC animation slot to the best corresponding
// NPC animation slot. (Use SubstituteAnimName if the given name and returned names
// are actual animation names.)
//
// Note that the current design prevents players from attacking while disguised
// (disguise only remains in effect while the PC is "firing" the disguise 
// angreal). However, a PC can move, swim, idle, get hit, and die etc. while
// disguised, so all of these have to be handled here. And, because the fire
// button must be held down to activate disguise, most of
//
// IF WE ARE MISSING ANY OF THE ANIMATION NAMES WHICH ARE RETURNED BELOW FOR 
// SPECIFIC NPCS, THIS FUNCTION WILL EITHER NEED TO BE OVERRIDDEN FOR THESE
// NPCS, OR THE MISSING ANIMATIONS WILL HAVE TO BE "STUBBED" IN. This function
// has to remain static and it can therefore only call other static functions.
//=============================================================================

simulated static function name SubstituteAnimSlotName( name PlayerAnimSlot )
{
	local name ReturnedAnimSlot;

	ReturnedAnimSlot = '';
	switch( PlayerAnimSlot ) 
	{
		// NPCs will have no direct equivalent for these
		case 'Run':
		case 'RunL':
		case 'RunR':
			ReturnedAnimSlot = RunAnimSlot;
			break;
			
		case 'Walk':
		case 'WalkL':
		case 'WalkR':
			ReturnedAnimSlot = WalkAnimSlot;
			break;

		// all of these should exist as is, but use get functions for consistency
		case 'Breath':
		case 'Fall':
		case 'Land':
		case 'Jump':
		case 'Hit':
		case 'HitHard':
		case 'Look':
			ReturnedAnimSlot = PlayerAnimSlot;
			break;

		case 'Swim':
			ReturnedAnimSlot = WalkAnimSlot;
			break;
			
		case 'Death': 
			ReturnedAnimSlot = DeathAnimSlot;
			break;

		case 'Attack':
			ReturnedAnimSlot = BreathAnimSlot;
			break;

		case 'AttackRun':
		case 'AttackRunL':
		case 'AttackRunR':
			ReturnedAnimSlot = RunAnimSlot;
			break;

		case 'AttackWalk':
			ReturnedAnimSlot = WalkAnimSlot;
			break;
			
		default:
			warn( "WOTPawn::SubstituteAnimSlotName - sequence name " $ PlayerAnimSlot $ " isn't supported!" );
			ReturnedAnimSlot = WalkAnimSlot;
	}

	return ReturnedAnimSlot;
}



//=============================================================================
// Note: It shouldn't be possible to die while disguised so these aren't 
// handled here.

simulated static function name SubstituteAnimName( name PlayerAnim )
{
	local name ReturnedAnim;

	ReturnedAnim = '';
	switch( PlayerAnim ) 
	{
		// NPCs will have no direct equivalent for these
		case 'Run':
		case 'RunL':
		case 'RunR':
			ReturnedAnim = 'Run';
			break;
			
		case 'Walk':
		case 'WalkL':
		case 'WalkR':
			ReturnedAnim = 'Walk';
			break;		

		// all of these should exist as is, but use get functions for consistency
		case 'Breath':
		case 'Fall':
		case 'Landed':
		case 'Jump':
		case 'HitB':
		case 'HitBHard':
		case 'HitF':
		case 'HitFHard':
		case 'Look':
			ReturnedAnim = PlayerAnim;
			break;

		case 'Swim':
			ReturnedAnim = 'Walk';
			break;
			
		case 'Attack':
			ReturnedAnim = 'Breath';
			break;

		case 'AttackRun':
		case 'AttackRunL':
		case 'AttackRunR':
			ReturnedAnim = 'Run';
			break;

		case 'AttackWalk':
			ReturnedAnim = 'Walk';
			break;
			
		default:
			warn( "WOTPawn::SubstituteAnimName - sequence name " $ PlayerAnim $ " isn't supported!" );
			ReturnedAnim = 'Walk';
	}

	return ReturnedAnim;
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
		warn( "This function shouldn't be called on the Client." );
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



//------------------------------------------------------------------------------
// Called by other actors to decrease this pawn's health.
//------------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, vector Momentum, name DamageType) // MAY override; if so, must call parent function 
{
	if( CurrentReflector != None )
	{
		CurrentReflector.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	}
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
// Notification for when a charge has been used.
//------------------------------------------------------------------------------
function ChargeUsed( AngrealInventory Ang )
{
	if( CurrentReflector != None )
	{
		CurrentReflector.ChargeUsed( Ang );
	}
}



//------------------------------------------------------------------------------
// Call this function to start using the currently selected angreal.
//------------------------------------------------------------------------------
function UseAngreal()
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



//------------------------------------------------------------------------------
// Call this function to stop using the currently selected angreal.
//------------------------------------------------------------------------------
function CeaseUsingAngreal()
{
	if( CurrentReflector != None )
	{
		CurrentReflector.CeaseUsingAngreal();
	}
}



//-----------------------------------------------------------------------------
function bool DeleteInventory( inventory Item )
{
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

	return true;
}



// end of WOTPawn

defaultproperties
{
     DefaultReflectorClasses(0)=Class'WOT.DefaultProcessEffectReflector'
     DefaultReflectorClasses(1)=Class'WOT.DefaultTargetingReflector'
     DefaultReflectorClasses(2)=Class'WOT.DefaultHealthReflector'
     DefaultReflectorClasses(3)=Class'WOT.DefaultTakeDamageReflector'
     DefaultReflectorClasses(4)=Class'WOT.DefaultCastReflector'
     DefaultReflectorClasses(5)=Class'WOT.DamageTakeDamageReflector'
     DefaultReflectorClasses(6)=Class'WOT.SetupAssetClassesReflector'
     DefaultReflectorClasses(7)=Class'WOT.WOTFootZoneChangeReflector'
     AssignedTeam=255
     GroundSpeedMin=400.000000
     GroundSpeedMax=400.000000
     HealthMPMin=100.000000
     HealthMPMax=100.000000
     HealthSPMin=100.000000
     HealthSPMax=100.000000
     ChanceOfHitAnim=0.250000
     TextureHelperClass=Class'WOT.GenericTextureHelper'
     DamageHelperClass=Class'WOT.GenericDamageHelper'
     VolumeMultiplier=1.000000
     RadiusMultiplier=1.000000
     PitchMultiplier=1.000000
     TimeBetweenHitSoundsMin=1.000000
     TimeBetweenHitSoundsMax=3.000000
     CarcassType=Class'WOT.WOTCarcass'
     HitHardHealthRatio=0.250000
     HitSoftHealthRatio=0.050000
     ExceptionalDeathHealthRatio=0.250000
     DestroyDelaySecs=10.000000
     SpeedPlayAnimAfterLanding=800.000000
     MinLandedDamageVelocity=-850.000000
     FatalLandedDamageVelocity=-2000.000000
     PlayLandHardMinVelocity=1200.000000
     PlayLandSoftMinVelocity=600.000000
     GibForSureFinalHealth=-40.000000
     GibSometimesFinalHealth=-30.000000
     GibSometimesOdds=0.500000
     BaseGibDamage=40.000000
     SpawnSeparation=50.000000
     ConstrainerClass=Class'WOT.WotBehaviorConstrainer'
     GoalFactoryClass=Class'WOT.WotGoalFactory'
     GroundSpeed=600.000000
     WaterSpeed=400.000000
     AirSpeed=400.000000
     AccelRate=1024.000000
     BaseEyeHeight=42.000000
     UnderWaterTime=20.000000
     AnimSequence=Breath
     DrawType=DT_Mesh
     CollisionHeight=48.000000
}
