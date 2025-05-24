//=============================================================================
// AngrealInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 32 $
//=============================================================================

//------------------------------------------------------------------------------
// Description:	Provides the interface for WOTPlayer or WOTPawn to access the 
//				power within any given angreal artifact.  Also does all the 
//				bookkeeping necessary for managing icons, sounds, meshes, etc 
//				needed to represent this object to the WOTPlayer or WOTPawn.  
//				Since angreal artifacts are not allowed to directly modify a 
//				pawn, they will be primarily concerned with creating and 
//				installing effects.
//------------------------------------------------------------------------------
// How to use this class:
// 
// + Subclass and override the Using state.
// + Define a CeaseUsing state in your subclass if you need to handle
//   special cases when the angreal is not active.
// + When switching angreal, you should turn it off first.
//
//------------------------------------------------------------------------------

class AngrealInventory expands WOTInventory
	abstract;

////////////
// Assets //
////////////

#exec TEXTURE	IMPORT FILE=Icons\I_Tainted.pcx							GROUP=UI			MIPS=Off FLAGS=2
#exec TEXTURE	IMPORT FILE=Icons\I_NotifyPickup.pcx					GROUP=NotifyPickup	MIPS=Off FLAGS=2
#exec AUDIO		IMPORT FILE=Sounds\Notification\NotifyPickupSound.wav	GROUP=NotifyPickup
#exec AUDIO		IMPORT FILE=Sounds\Notification\AngrealFail.wav			GROUP=Effect
#exec AUDIO		IMPORT FILE=Sounds\Notification\Tainted.wav		    	GROUP=Effect

///////////////
// Constants //
///////////////

var() enum EDurationType					// Used for icon Timers
{
	DT_Charge,
	DT_Lifespan,
	DT_Shield,
	DT_None
} DurationType;

// These are not var()s because I don't want subclasses to be able to 
// override them using the default properties.  If they are changed, the
// changed should apply to all angreal.
/*const*/ var(AngrealTaint) int TAINT_COMMON_DAMAGE;	//= 2;
/*const*/ var(AngrealTaint) int TAINT_UNCOMMON_DAMAGE;	//= 5;
/*const*/ var(AngrealTaint) int TAINT_RARE_DAMAGE;		//= 10;

/////////////////////////////
// Configurable Properties //
/////////////////////////////

// Any combination of the following five elements.
var(AngrealElements) bool bElementFire;		// composed of fire.
var(AngrealElements) bool bElementWater;	// composed of water.
var(AngrealElements) bool bElementAir;		// composed of air.
var(AngrealElements) bool bElementEarth;	// composed of earth.
var(AngrealElements) bool bElementSpirit;	// composed of spirit.

// Exactly one of the following types.
var(AngrealRarity) bool bCommon;	// common angreal identifier.
var(AngrealRarity) bool bUncommon;	// uncommon angreal identifier.
var(AngrealRarity) bool bRare;		// rare angreal identifier.

// Textures for AppearEffect.
var(AngrealRarity) Texture CommonTop,   CommonBottom;
var(AngrealRarity) Texture UnCommonTop, UnCommonBottom;
var(AngrealRarity) Texture RareTop,     RareBottom;

// Any combination of the following types.
var(AngrealTypes) bool bOffensive;	// this angreal should go in your offensive hand.
var(AngrealTypes) bool bDefensive;	// this angreal should go in your defensive hand.
var(AngrealTypes) bool bCombat;		// this angreal should go in your combat hand.
var(AngrealTypes) bool bTraps;		// this angreal should go in your traps hand.
var(AngrealTypes) bool bInfo;		// this angreal should go in your info hand.
var(AngrealTypes) bool bMisc;		// this angreal should go in your misc hand.

var() float RoundsPerMinute;		// Maximum charge depletion rate.
var() bool bRestrictsUsage;			// Set to true if this artifact should restrict the user from using 
									// another artifact until (60.0/RoundsPerMinutes) seconds have passed.
									// (This is enforced in DefaultCastReflector.uc)

var() int MinInitialCharges;			// newly-placed angreal will have at least this many charges.
var() int MaxInitialCharges;			// newly-placed angreal will have no more than this many charges.

var() int SPInitialCharges[3];			// Initial charges for single player (by difficulty: 0=Easy, 1=Medium, 2=Hard).

var() bool bSPAppearEffect;				// Do we use an appear effect in single player?
var() bool bMPAppearEffect;				// Do we use an appear effect in multi player?

var() bool bPuzzleRespawn;				// Do we need to respawn to support puzzles?
var() class<ParticleSprayer> CueType;	// Type of particle sprayer to use to indicate puzzle respawn.
var() float PuzzleCueSecondaryVolume;	// Volume used by the particle system when the angreal is picked up.
var ParticleSprayer PuzzleCue;			// Visual cue that this is a puzzle item.
var AngrealInventory PuzzleRespawns[5];	// In case we pick up other PuzzleRespawn items along the way.

var() float NotifyNewPickupFadeTime;	// Set this to > 0.0 to take effect.
var() Texture NotifyNewPickupTexture;	// Texture to flash when the player picks up a new artifact for the first time. 
var() string NotifyNewPickupSoundName;	// Sound played when a new artifact is pickup up.

var() int MaxCharges;					// The most amount of charges this artifact can carry.

// This variable should only be modified by AddCharges() or UseCharge().
var() travel int ChargeCost;			// How many charges used per use.

var(AngrealAI) float Priority;					// Desire to be used relative to all other artifacts.

var() localized string FailMessage;

// Types of classes that we are not allowed to target.
var() name NonTargetableTypes[2];

var() bool bTargetsFriendlies;			// Are we allowed to target people/things on our own team?

/////////////
// Visuals //
/////////////

// (StatusIcon and PickupMesh are defined in Inventory)

// Should we diplay our status icon in the upper-right coner of the 
// screen while active?
var() bool bDisplayIcon;

////////////
// Sounds //
////////////  

// LazyLoaded assets.
var() string ActivateSoundName;
var() string DeActivateSoundName;
var() string TaintedSoundName;
var() string FailSoundName;

// (Pickup, Activate and Respawn are defined in Inventory)
var() Sound UseChargeSound;	// Sound played every time a charge is used.
var	Sound TaintedSound;		// Sound played when you use a tainted artifact (lazy loaded).
var Sound FailSound;		// Sound played when the angreal fails to work (lazy loaded).

//////////////////////
// Status Variables //
//////////////////////

var travel bool bTainted;	// Whether or not this angreal is tainted?
var /*travel?*/ Pawn TaintInstigator;

var travel int CurCharges;	// How many charges this angreal currently has.

// Owner refers to the Pawn who's inventory I am in.

var Actor LastOwner;		// The last Owner that we had.

//hack variables for ai
const PriorityUnusable = -1;
var(AngrealAI) float NPCRespawnTime;			// How long before we give the angreal back to the NPC once it uses up all our charges. Rest assured, this..is..a..hack.

//xxxrlo these should probably go in a reflector of some sort
var private float LastChargeUsedTime;			// the last time that the inventory item consumed a charge
var private int ChargesUsedInGroup;				// how many charges have been consumed i this group
var private int IntendedChargesInGroup;			//

//these properties are set by the angreal user in AddDefaultInventoryItems
var(AngrealAI) int MaxChargesInGroup;			// at most this many charges are cast in a charge group
var(AngrealAI) int MinChargesInGroup;			// at least this many charges must be cast in a charge group (unless the angreal becomes ineffective)
var(AngrealAI) float MaxChargeUsedInterval;		// at most this amount of time may elapse after an charge is used for a subsequent charge to be considered part of the current charge group
var(AngrealAI) float MinChargeGroupInterval;	// at least this amount of time must elapse between charge groups
var(AngrealAI) float MissOdds;					// 

var AppearEffect AE;

replication
{
    // Things the server should send to the client.
    reliable if( Role==ROLE_Authority && bNetOwner )
        CurCharges, bTainted;
}

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
// Releases the power within the ter'angreal artifact.
// Note: Make sure you call Cast() before UseCharge(), otherwise we will
// lose our pointer to our Owner when we use our last charge.
//------------------------------------------------------------------------------
function Cast()
{
	if( ActivateSound == None && ActivateSoundName != "" )
	{
		ActivateSound = Sound( DynamicLoadObject( ActivateSoundName, class'Sound' ) );
	}
	if( ActivateSound != None )
	{
		Owner.PlaySound( ActivateSound );
	}
	
	if( bDisplayIcon && WOTPlayer(Owner) != None && StatusIcon != None )
	{
		WOTPlayer(Owner).AddIconInfo( Self, true, Name );
	}
}

//------------------------------------------------------------------------------
// Stops the ter'angreal from releasing its effect.
//------------------------------------------------------------------------------
function UnCast()
{
	if( DeactivateSound == None && DeactivateSoundName != "" )
	{
		DeactivateSound = Sound( DynamicLoadObject( DeActivateSoundName, class'Sound' ) );
	}
	if( DeactivateSound != None )
	{
		Owner.PlaySound( DeactivateSound );
	}

	if( bDisplayIcon && WOTPlayer(Owner) != None && StatusIcon != None )
	{
		WOTPlayer(Owner).RemoveIconInfo( Name );
	}
}

//------------------------------------------------------------------------------
// Called for level transition, player death, etc.
// Override in subclass to clean up variables and stuff.
//------------------------------------------------------------------------------
function Reset()
{
	UnCast();
	/*AngrealAI*/ LastChargeUsedTime = 0;
	/*AngrealAI*/ ChargesUsedInGroup = 0;
}

//------------------------------------------------------------------------------
event TravelPreAccept()
{
	Super.TravelPreAccept();
	Reset();
}

//------------------------------------------------------------------------------
// Call this function to render an angreal on the given canvas.  
// Takes care of tainting.
// NOTE: C.X and C.Y will be undefined on return
//------------------------------------------------------------------------------
simulated function DrawStatusIconAt( Canvas C, int X, int Y, optional float Scale )
{
	Super.DrawStatusIconAt( C, X, Y, Scale );
	
	if( bTainted ) 
	{
		C.Style = ERenderStyle.STY_Masked;
		LegendCanvas( C ).DrawIconAt( texture'I_Tainted', X, Y, 1.0 );
		C.Style = ERenderStyle.STY_NORMAL;
	}
}

///////////////
// Accessors //
///////////////

//------------------------------------------------------------------------------
// Check to see if we have enough charges for one more usage.
//------------------------------------------------------------------------------
function bool HaveEnoughCharges()
{
	return (CurCharges - ChargeCost) >= 0;
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
// Decrement the current charge count by the amount of charges one usage costs.
//------------------------------------------------------------------------------
function UseCharge()
{
	local DamageEffect DE;
	local int Damage;

	// If it's tainted, hurt the castor accordingly.
	if( bTainted )
	{
		if		( bCommon	)	Damage = TAINT_COMMON_DAMAGE;
		else if	( bUncommon	)	Damage = TAINT_UNCOMMON_DAMAGE;
		else if	( bRare		)	Damage = TAINT_RARE_DAMAGE;

		if( Damage > 0 )
		{
			if( WOTPawn(Owner) != None )
			{
				//DE = Spawn( class'DamageEffect' );
				DE = DamageEffect( class'Invokable'.static.GetInstance( Self, class'DamageEffect' ) );
				DE.SetSourceAngreal( Self );
				DE.Initialize( Damage, TaintInstigator, Owner.Location, vect(0,0,0), /*class'AngrealInventory'.static.GetDamageType( Self )*/'SelfInflicted', None );
				DE.SetVictim( Pawn(Owner) );
				WOTPawn(Owner).ProcessEffect( DE );
			}
			else if( WOTPlayer(Owner) != None )
			{
				//DE = Spawn( class'DamageEffect' );
				DE = DamageEffect( class'Invokable'.static.GetInstance( Self, class'DamageEffect' ) );
				DE.SetSourceAngreal( Self );
				DE.Initialize( Damage, TaintInstigator, Owner.Location, vect(0,0,0), /*class'AngrealInventory'.static.GetDamageType( Self )*/'SelfInflicted', None );
				DE.SetVictim( Pawn(Owner) );
				WOTPlayer(Owner).ProcessEffect( DE );
			}
		}

		if( TaintedSound == None && TaintedSoundName != "" )
		{
			TaintedSound = Sound( DynamicLoadObject( TaintedSoundName, class'Sound' ) );
		}

		if( TaintedSound != None )
		{
			Owner.PlaySound( TaintedSound );
		}

	}

	CurCharges -= ChargeCost;

	// Give the player audio feedback that he/she is sucking up charges.
	if( UseChargeSound != None )
	{
		Owner.PlaySound( UseChargeSound );
	}

	// Notify the player that we just used a charge.
	if( WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).ChargeUsed( Self );
	}
	else if( WOTPawn(Owner) != None )
	{
		/*AngrealAI*/ LastChargeUsedTime = Level.TimeSeconds;
		/*AngrealAI*/ ChargesUsedInGroup++;
		WOTPawn(Owner).ChargeUsed( Self );
	}

	if( CurCharges <= 0 )
	{
		UnCast();
		GoEmpty();
	}
}

//------------------------------------------------------------------------------
// Allows you to add more charges to an artifact.
//------------------------------------------------------------------------------
function AddCharges( int NumCharges )
{
	// Add the charges.
	CurCharges += NumCharges;
	
	// Make sure there isn't too many charges now.
	if( CurCharges > MaxCharges )
	{
		CurCharges = MaxCharges;
	}
}

///////////////////
// Notifications //
///////////////////

//------------------------------------------------------------------------------
// Notification for when an attempt to use this angreal failed.
//------------------------------------------------------------------------------
function Failed()
{
	if( Pawn(Owner) != None )
	{
		Pawn(Owner).ClientMessage( Title $ " " $ FailMessage $ ".", 'FailedMessage' );
	}

	if( FailSound == None && FailSoundName != "" )
	{
		FailSound = Sound( DynamicLoadObject( FailSoundName, class'Sound' ) );
	}

	if( FailSound != None )
	{
		Owner.PlaySound( FailSound );
	}

	// Notify Owner of failure.
	if( WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).NotifyCastFailed( Self );
	}
	else if( WOTPawn(Owner) != None )
	{
		WOTPawn(Owner).NotifyCastFailed( Self );
	}
}

//------------------------------------------------------------------------------
function NotifyPutInBag( BagHolding Bag )
{
	// Do special handling here, since you won't be getting a DropFrom notification.
}

////////////////////
// Initialization //
////////////////////

//-----------------------------------------------------------------------------
// Overridden so we can set initial charges.  Slightly bogus, since a *copy*
// of an angreal is spawned into a pickerupper's inventory.  This means
// the charges that the player sees will not match the charges of the item
// on the ground.  But in gameplay terms, it makes no difference, since the
// player has no way of knowing what the charges on the ground are except
// by picking up the angreal.
//-----------------------------------------------------------------------------
function BeginPlay()
{
	Super.BeginPlay();
	SetCharges();
}

//-----------------------------------------------------------------------------
function ResetCharges()
{
	CurCharges = 0;
}

//-----------------------------------------------------------------------------
function SetCharges()
{
//	local int i;

	ResetCharges();

	if( Level.Netmode == NM_Standalone )
	{
/*
		// Error check (TBD?)
		for( i = 0; i < ArrayCount(SPInitialCharges); i++ )
		{
			if( SPInitialCharges[i] == 0 )
			{
				warn( "SPInitialCharges["$i$"] is not properly set." );
			}
		}
*/
		if( SPInitialCharges[Level.Game.Difficulty] <= 0 )
		{
			switch( Level.Game.Difficulty )
			{

			// Hard
			case 2:
				AddCharges( MinInitialCharges );
				break;

			// Medium
			case 1:
				AddCharges( (MinInitialCharges + MaxInitialCharges) / 2	);
				break;
			
			// Easy
			case 0:
			default:
				AddCharges( MaxInitialCharges );
				break;
			
			}
		}
		else
		{
			AddCharges( SPInitialCharges[Level.Game.Difficulty] );
		}
	}
	else
	{
		AddCharges( RandRange( MinInitialCharges, MaxInitialCharges ) );
	}
}

///////////////
// Overrides //
///////////////
/*
//-----------------------------------------------------------------------------
// Don't let the player pick us up if they are already at their max.
//-----------------------------------------------------------------------------
auto state Pickup
{
	function Touch( Actor Other )
	{
		local AngrealInventory Item;

		if( Pawn(Other) != None )
		{
			// See if the player already has one of us.
			Item = AngrealInventory(Pawn(Other).FindInventoryType( Class ));
			// Allow her to pick it up if she does not have one of us,
			// or she is not maxed out yet.
			if( Item == None || Item.CurCharges < MaxCharges )
			{
				Super.Touch( Other );
			}
		}
		else
		{
			Super.Touch( Other );
		}
	}
}
*/
//-----------------------------------------------------------------------------
// Steal charges if the player already has one of us.
// Become tainted if the angreal we are picking up is tainted.
//-----------------------------------------------------------------------------
function bool HandlePickupQuery( Inventory Item )
{
	if( Item.Class == Class )
	{
		AddCharges( AngrealInventory(Item).CurCharges );
		AngrealInventory(Item).SetCharges();	// re-randomize its charges for the next person that picks it up.
		if( !bTainted )
		{
			bTainted = AngrealInventory(Item).bTainted;
		}
		Pawn(Owner).ClientMessage(PickupMessage,'Pickup');
		if( NotifyNewPickupFadeTime == 0.0 )
		{
			Item.PlaySound(Item.PickupSound);		   
		}

		Item.SetRespawn();
		if( AngrealInventory(Item).bPuzzleRespawn )
		{
			AddPuzzleRespawn( AngrealInventory(Item) );
		}
		return true;
	}
	if( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

//-----------------------------------------------------------------------------
function InitializeCopy( Inventory Copy )
{
	Super.InitializeCopy( Copy );
	AngrealInventory(Copy).CurCharges = CurCharges;
	SetCharges();	// re-randomize our charges for the next person that picks us up.
}

//-----------------------------------------------------------------------------
function AddPuzzleRespawn( AngrealInventory Item )
{
	local int i;
	
	// Find first open slot.
	for( i = 0; i < ArrayCount(PuzzleRespawns) && PuzzleRespawns[i] != None; i++ );
	
	if( i < ArrayCount(PuzzleRespawns) )
	{
		PuzzleRespawns[i] = Item;
	}
	else
	{
		warn( "PuzzleRespawns capacity overflow." );
	}
}

//-----------------------------------------------------------------------------
function SetRespawn()
{
	if( bPuzzleRespawn )
	{
		BecomeItem();
		CurCharges = 0;
	}
	else
	{
		Super.SetRespawn();
	}
}

//-----------------------------------------------------------------------------
// Used to remember the last person we were given to, so we have a reference
// to him/her when they drop us, and set our Owner back to None.
//-----------------------------------------------------------------------------
function GiveTo( Pawn Other )
{
	Super.GiveTo( Other );
	LastOwner = Owner;

	// Note: Don't worry about this not working if the player already has an angreal
	// of this type since it's not supposed to work anyway.
	if
	(	NotifyNewPickupFadeTime > 0.0
	&&	Other == Owner && WOTPlayer(Other) != None
	&&	BaseHUD(WOTPlayer(Other).myHUD) != None
	)
	{
		//WOTPlayer(Other).DoInfoHint( NotifyNewPickupFadeTime );
		WOTPlayer(Other).ClientPlaySound( Sound( DynamicLoadObject( NotifyNewPickupSoundName, class'Sound' ) ) );
		BaseHUD(WOTPlayer(Other).myHUD).SetFlashTexture( NotifyNewPickupTexture, NotifyNewPickupFadeTime );
		NotifyNewPickupFadeTime = 0.0;	// Don't do this again.
	}
}

//-----------------------------------------------------------------------------
function DropFrom( vector StartLocation )
{
	UnCast();	// This should be always safe to call.
	Super.DropFrom( StartLocation );
}

//-----------------------------------------------------------------------------
function BecomePickup()
{
	Super.BecomePickup();

	if
	(	(Level.Netmode == NM_Standalone && bSPAppearEffect)
	||	(Level.Netmode != NM_Standalone && bMPAppearEffect)
	)
	{
		if( AE == None || AE.bDeleteMe )
		{
			AE = Spawn( class'AppearEffect' );
			if     ( bCommon   ){ AE.TopSprite = CommonTop;   AE.BottomSprite = CommonBottom;   }
			else if( bUnCommon ){ AE.TopSprite = UnCommonTop; AE.BottomSprite = UnCommonBottom; }
			else if( bRare     ){ AE.TopSprite = RareTop;     AE.BottomSprite = RareBottom;     }
			AE.SetAppearActor( Self );
		}
	}

	if( bPuzzleRespawn )
	{
		if( PuzzleCue == None )
		{
			PuzzleCue = Spawn( CueType,,, Location );
		}

		PuzzleCue.bOn = true;
		PuzzleCue.Volume = PuzzleCue.default.Volume;
		PuzzleCue.MinVolume = PuzzleCue.default.MinVolume;
	}
}

//-----------------------------------------------------------------------------
function BecomeItem()
{
	Super.BecomeItem();

	if( AE != None )
	{
		AE.Destroy();
		AE = None;
	}

	if( PuzzleCue != None )
	{
		//PuzzleCue.bOn = false;
		PuzzleCue.Volume = PuzzleCueSecondaryVolume;
		PuzzleCue.MinVolume = PuzzleCueSecondaryVolume;
	}
}

//////////////////////
// Helper functions //
//////////////////////

//-----------------------------------------------------------------------------
// Changes our behavior once we run out of charges.  
//-----------------------------------------------------------------------------
function GoEmpty()
{
	local LatentGiveToLeech RespawnLeech;
	local int i;

	// Respawn any PuzzleRespawns we might have picked up along the way.
	for( i = 0; i < ArrayCount(PuzzleRespawns); i++ )
	{
		if( PuzzleRespawns[i] != None )
		{
			PuzzleRespawns[i].PuzzleRespawn();
			PuzzleRespawns[i] = None;
		}
	}

	Pawn(Owner).DeleteInventory( Self );

	// If we were owned by an NPC, set up a timer to give us back.
	if( LegendPawn(LastOwner) != None && NPCRespawnTime > 0.0 )
	{
		CurCharges = RandRange( MinInitialCharges, MaxInitialCharges );
		RespawnLeech = Spawn( class'LatentGiveToLeech' );
		RespawnLeech.Item = Self;
		RespawnLeech.AffectResolution = NPCRespawnTime;
		RespawnLeech.AttachTo( LegendPawn(LastOwner) );
	}

	// Respawn if we are used in puzzles.
	else if( bPuzzleRespawn )
	{
		PuzzleRespawn();
	}

	// We aren't needed, clean up.
	else
	{
		//Destroy();
		LifeSpan = 90;		// Clean yourself up in 1.5 minutes (no projectiles, 
							// etc. that need us should be floating around by that time).
	}
}

//-----------------------------------------------------------------------------
function PuzzleRespawn()
{
	PlaySound( RespawnSound );	
	SetCharges();
	bHeldItem = false;
	GotoState('Pickup');
}

//-----------------------------------------------------------------------------
// This is for timer icon display - different Angreal will return:
// ChargeCount
// Lifespan
// Shield hit points
// etc.
//-----------------------------------------------------------------------------
function float GetDuration()
{
	local float EffectDuration;
	local bool bHandled;
	
	local Leech IterL;
	local Reflector IterR;
	
	switch( DurationType )
	{
	// Charge based.
	case DT_Charge:
		EffectDuration =  CurCharges;
		bHandled = true;
		break;

	// Hit-point based.
	case DT_Shield:
		if( WOTPlayer(LastOwner) != None )
		{
			EffectDuration = WOTPlayer(LastOwner).ShieldHitPoints;
			bHandled = true;
		}
		else if( WOTPawn(LastOwner) != None )
		{
			EffectDuration = WOTPawn(LastOwner).ShieldHitPoints;
			bHandled = true;
		}
		break;

	// Leech or Reflector LifeSpan based.
	case DT_Lifespan:
		warn( "DT_Lifespan is depricated... using Artifact's LifeSpan instead." );
		EffectDuration = Lifespan;
		bHandled = true;
		break;

	// Catch illegal duration types.
	default:
		warn( "Unrecognized DurationType... using Artifact's LifeSpan instead." );
		EffectDuration = Lifespan;
		bHandled = true;
		break;
	}

	// Double-check.
	if( !bHandled )
	{
		warn( "EffectDuration fell through the cracks... using Artifact's LifeSpan instead." );
		EffectDuration = Lifespan;
	}

	return EffectDuration;
}

//-----------------------------------------------------------------------------
simulated function bool IsNotTargetable( Actor Other )
{
	local int i;
	local byte Team;

	for( i = 0; i < ArrayCount(NonTargetableTypes); i++ )
	{
		if( NonTargetableTypes[i] != '' && Other.IsA( NonTargetableTypes[i] ) )
		{
			return true;
		}
	}

	// don't target friendlies for certain angreal in the Citadel Game
	if( !bTargetsFriendlies && Level.Game.IsA( 'giMPBattle' ) )
	{
		if( Pawn(Owner) != None && Pawn(Owner).PlayerReplicationInfo != None )	// Validation.
		{			
			Team = Pawn(Owner).PlayerReplicationInfo.Team;
			if
			(	(Pawn(Other) != None && Pawn(Other).PlayerReplicationInfo != None && Pawn(Other).PlayerReplicationInfo.Team == Team)	// Pawn on the same team as us.
			||	(AngrealIllusionProjectile(Other) != None && AngrealIllusionProjectile(Other).Team == Team)								// An illusion spawned by someone on our team.
//			||	(MashadarTrailer(Other) != None && MashadarTrailer(Other).Guide != None && MashadarTrailer(Other).Guide.Team == Team)	// Mashadar tendril on our team.	(We can't do this since Mashadar is declared in WOTPawns).
//			||	(NOTE[aleiby]: Others?)
			)
			{
				return true;
			}
		}
	}

	return false;
}

//-----------------------------------------------------------------------------
// Use this to create a dummy angreal -- one that can be used as a SourceAngreal
// but isn't being carried by anyone.
//-----------------------------------------------------------------------------
static function AngrealInventory CreateProxy( Actor Owner, class<AngrealInventory> Type )
{
	local AngrealInventory Proxy;

	Proxy = Owner.Spawn( Type, Owner,, Owner.Location );
	Proxy.BecomeItem();

	return Proxy;
}

//-----------------------------------------------------------------------------
// Used to test if a damage type is composed from the given element.
// DamageTypes are of the format: AEFWS, where 'x's are used as spacers.
// Example: A damage type is composed of Earth and Water would be formated
// as xExWx.  
// The Element names are in the format of Air, Earth, Fire, Water or Spirit.
//
// Author's note: There's got to be an easier way.
//
// (These are ordered for optimization, not for readability... please don't
// change the order on me.)
//-----------------------------------------------------------------------------
static function bool DamageTypeContains( name DamageType, name Element )
{
	local bool bContainsElement;

/* -- All 32 possible combinations.
		else if	( DamageType == xxxxx ) bContainsElement = true;
		else if	( DamageType == Axxxx ) bContainsElement = true;
		else if	( DamageType == xExxx ) bContainsElement = true;
		else if	( DamageType == xxFxx ) bContainsElement = true;
		else if	( DamageType == xxxWx ) bContainsElement = true;
		else if	( DamageType == xxxxS ) bContainsElement = true;
		else if	( DamageType == AExxx ) bContainsElement = true;
		else if	( DamageType == AxFxx ) bContainsElement = true;
		else if	( DamageType == AxxWx ) bContainsElement = true;
		else if	( DamageType == AxxxS ) bContainsElement = true;
		else if	( DamageType == xEFxx ) bContainsElement = true;
		else if	( DamageType == xExWx ) bContainsElement = true;
		else if	( DamageType == xExxS ) bContainsElement = true;
		else if	( DamageType == xxFWx ) bContainsElement = true;
		else if	( DamageType == xxFxS ) bContainsElement = true;
		else if	( DamageType == xxxWS ) bContainsElement = true;
		else if	( DamageType == AEFxx ) bContainsElement = true;
		else if	( DamageType == AExWx ) bContainsElement = true;
		else if	( DamageType == AExxS ) bContainsElement = true;
		else if	( DamageType == AxFWx ) bContainsElement = true;
		else if	( DamageType == AxFxS ) bContainsElement = true;
		else if	( DamageType == AxxWS ) bContainsElement = true;
		else if	( DamageType == xEFWx ) bContainsElement = true;
		else if	( DamageType == xEFxS ) bContainsElement = true;
		else if	( DamageType == xExWS ) bContainsElement = true;
		else if	( DamageType == xxFWS ) bContainsElement = true;
		else if	( DamageType == AxFWS ) bContainsElement = true;
		else if	( DamageType == AExWS ) bContainsElement = true;
		else if	( DamageType == AEFxS ) bContainsElement = true;
		else if	( DamageType == AEFWx ) bContainsElement = true;
		else if	( DamageType == xEFWS ) bContainsElement = true;
		else if	( DamageType == AEFWS ) bContainsElement = true;
*/
	switch( Element )
	{
	case 'Air':
		if		( DamageType == 'Axxxx' ) bContainsElement = true;
		else if	( DamageType == 'AExxx' ) bContainsElement = true;
		else if	( DamageType == 'AxFxx' ) bContainsElement = true;
		else if	( DamageType == 'AxxWx' ) bContainsElement = true;
		else if	( DamageType == 'AxxxS' ) bContainsElement = true;
		else if	( DamageType == 'AEFxx' ) bContainsElement = true;
		else if	( DamageType == 'AExWx' ) bContainsElement = true;
		else if	( DamageType == 'AExxS' ) bContainsElement = true;
		else if	( DamageType == 'AxFWx' ) bContainsElement = true;
		else if	( DamageType == 'AxFxS' ) bContainsElement = true;
		else if	( DamageType == 'AxxWS' ) bContainsElement = true;
		else if	( DamageType == 'AxFWS' ) bContainsElement = true;
		else if	( DamageType == 'AExWS' ) bContainsElement = true;
		else if	( DamageType == 'AEFxS' ) bContainsElement = true;
		else if	( DamageType == 'AEFWx' ) bContainsElement = true;
		else if	( DamageType == 'AEFWS' ) bContainsElement = true;
		else							  bContainsElement = false;
		break;

	case 'Earth':
		if		( DamageType == 'xExxx' ) bContainsElement = true;
		else if	( DamageType == 'AExxx' ) bContainsElement = true;
		else if	( DamageType == 'xEFxx' ) bContainsElement = true;
		else if	( DamageType == 'xExWx' ) bContainsElement = true;
		else if	( DamageType == 'xExxS' ) bContainsElement = true;
		else if	( DamageType == 'AEFxx' ) bContainsElement = true;
		else if	( DamageType == 'AExWx' ) bContainsElement = true;
		else if	( DamageType == 'AExxS' ) bContainsElement = true;
		else if	( DamageType == 'xEFWx' ) bContainsElement = true;
		else if	( DamageType == 'xEFxS' ) bContainsElement = true;
		else if	( DamageType == 'xExWS' ) bContainsElement = true;
		else if	( DamageType == 'AExWS' ) bContainsElement = true;
		else if	( DamageType == 'AEFxS' ) bContainsElement = true;
		else if	( DamageType == 'AEFWx' ) bContainsElement = true;
		else if	( DamageType == 'xEFWS' ) bContainsElement = true;
		else if	( DamageType == 'AEFWS' ) bContainsElement = true;
		else							  bContainsElement = false;
		break;

	case 'Fire':
		if		( DamageType == 'xxFxx' ) bContainsElement = true;
		else if	( DamageType == 'AxFxx' ) bContainsElement = true;
		else if	( DamageType == 'xEFxx' ) bContainsElement = true;
		else if	( DamageType == 'xxFWx' ) bContainsElement = true;
		else if	( DamageType == 'xxFxS' ) bContainsElement = true;
		else if	( DamageType == 'AEFxx' ) bContainsElement = true;
		else if	( DamageType == 'AxFWx' ) bContainsElement = true;
		else if	( DamageType == 'AxFxS' ) bContainsElement = true;
		else if	( DamageType == 'xEFWx' ) bContainsElement = true;
		else if	( DamageType == 'xEFxS' ) bContainsElement = true;
		else if	( DamageType == 'xxFWS' ) bContainsElement = true;
		else if	( DamageType == 'AxFWS' ) bContainsElement = true;
		else if	( DamageType == 'AEFxS' ) bContainsElement = true;
		else if	( DamageType == 'AEFWx' ) bContainsElement = true;
		else if	( DamageType == 'xEFWS' ) bContainsElement = true;
		else if	( DamageType == 'AEFWS' ) bContainsElement = true;
		else							  bContainsElement = false;
		break;

	case 'Water':
		if		( DamageType == 'xxxWx' ) bContainsElement = true;
		else if	( DamageType == 'AxxWx' ) bContainsElement = true;
		else if	( DamageType == 'xExWx' ) bContainsElement = true;
		else if	( DamageType == 'xxFWx' ) bContainsElement = true;
		else if	( DamageType == 'xxxWS' ) bContainsElement = true;
		else if	( DamageType == 'AExWx' ) bContainsElement = true;
		else if	( DamageType == 'AxFWx' ) bContainsElement = true;
		else if	( DamageType == 'AxxWS' ) bContainsElement = true;
		else if	( DamageType == 'xEFWx' ) bContainsElement = true;
		else if	( DamageType == 'xExWS' ) bContainsElement = true;
		else if	( DamageType == 'xxFWS' ) bContainsElement = true;
		else if	( DamageType == 'AxFWS' ) bContainsElement = true;
		else if	( DamageType == 'AExWS' ) bContainsElement = true;
		else if	( DamageType == 'AEFWx' ) bContainsElement = true;
		else if	( DamageType == 'xEFWS' ) bContainsElement = true;
		else if	( DamageType == 'AEFWS' ) bContainsElement = true;
		else							  bContainsElement = false;
		break;

	case 'Spirit':
		if		( DamageType == 'xxxxS' ) bContainsElement = true;
		else if	( DamageType == 'AxxxS' ) bContainsElement = true;
		else if	( DamageType == 'xExxS' ) bContainsElement = true;
		else if	( DamageType == 'xxFxS' ) bContainsElement = true;
		else if	( DamageType == 'xxxWS' ) bContainsElement = true;
		else if	( DamageType == 'AExxS' ) bContainsElement = true;
		else if	( DamageType == 'AxFxS' ) bContainsElement = true;
		else if	( DamageType == 'AxxWS' ) bContainsElement = true;
		else if	( DamageType == 'xEFxS' ) bContainsElement = true;
		else if	( DamageType == 'xExWS' ) bContainsElement = true;
		else if	( DamageType == 'xxFWS' ) bContainsElement = true;
		else if	( DamageType == 'AxFWS' ) bContainsElement = true;
		else if	( DamageType == 'AExWS' ) bContainsElement = true;
		else if	( DamageType == 'AEFxS' ) bContainsElement = true;
		else if	( DamageType == 'xEFWS' ) bContainsElement = true;
		else if	( DamageType == 'AEFWS' ) bContainsElement = true;
		else							  bContainsElement = false;
		break;

	default:
		//warn( "Element type "$Element$" not handled." );
		bContainsElement = false;
		break;
	}

	return bContainsElement;
}

//-----------------------------------------------------------------------------
static function name GetDamageType( AngrealInventory Item )
{
	local name DamageType;
	
	if( Item == None )
	{
		DamageType = 'xxxxx';
		return DamageType;
	}
	else
	{
		if		(  Item.bElementAir && !Item.bElementEarth && !Item.bElementFire && !Item.bElementWater && !Item.bElementSpirit ) DamageType = 'Axxxx';
		else if	( !Item.bElementAir &&  Item.bElementEarth && !Item.bElementFire && !Item.bElementWater && !Item.bElementSpirit ) DamageType = 'xExxx';
		else if	( !Item.bElementAir && !Item.bElementEarth &&  Item.bElementFire && !Item.bElementWater && !Item.bElementSpirit ) DamageType = 'xxFxx';
		else if	( !Item.bElementAir && !Item.bElementEarth && !Item.bElementFire &&  Item.bElementWater && !Item.bElementSpirit ) DamageType = 'xxxWx';
		else if	( !Item.bElementAir && !Item.bElementEarth && !Item.bElementFire && !Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'xxxxS';
		else if	(  Item.bElementAir &&  Item.bElementEarth && !Item.bElementFire && !Item.bElementWater && !Item.bElementSpirit ) DamageType = 'AExxx';
		else if	(  Item.bElementAir && !Item.bElementEarth &&  Item.bElementFire && !Item.bElementWater && !Item.bElementSpirit ) DamageType = 'AxFxx';
		else if	(  Item.bElementAir && !Item.bElementEarth && !Item.bElementFire &&  Item.bElementWater && !Item.bElementSpirit ) DamageType = 'AxxWx';
		else if	(  Item.bElementAir && !Item.bElementEarth && !Item.bElementFire && !Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'AxxxS';
		else if	( !Item.bElementAir &&  Item.bElementEarth &&  Item.bElementFire && !Item.bElementWater && !Item.bElementSpirit ) DamageType = 'xEFxx';
		else if	( !Item.bElementAir &&  Item.bElementEarth && !Item.bElementFire &&  Item.bElementWater && !Item.bElementSpirit ) DamageType = 'xExWx';
		else if	( !Item.bElementAir &&  Item.bElementEarth && !Item.bElementFire && !Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'xExxS';
		else if	( !Item.bElementAir && !Item.bElementEarth &&  Item.bElementFire &&  Item.bElementWater && !Item.bElementSpirit ) DamageType = 'xxFWx';
		else if	( !Item.bElementAir && !Item.bElementEarth &&  Item.bElementFire && !Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'xxFxS';
		else if	( !Item.bElementAir && !Item.bElementEarth && !Item.bElementFire &&  Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'xxxWS';
		else if	(  Item.bElementAir &&  Item.bElementEarth &&  Item.bElementFire && !Item.bElementWater && !Item.bElementSpirit ) DamageType = 'AEFxx';
		else if	(  Item.bElementAir &&  Item.bElementEarth && !Item.bElementFire &&  Item.bElementWater && !Item.bElementSpirit ) DamageType = 'AExWx';
		else if	(  Item.bElementAir &&  Item.bElementEarth && !Item.bElementFire && !Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'AExxS';
		else if	(  Item.bElementAir && !Item.bElementEarth &&  Item.bElementFire &&  Item.bElementWater && !Item.bElementSpirit ) DamageType = 'AxFWx';
		else if	(  Item.bElementAir && !Item.bElementEarth &&  Item.bElementFire && !Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'AxFxS';
		else if	(  Item.bElementAir && !Item.bElementEarth && !Item.bElementFire &&  Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'AxxWS';
		else if	( !Item.bElementAir &&  Item.bElementEarth &&  Item.bElementFire &&  Item.bElementWater && !Item.bElementSpirit ) DamageType = 'xEFWx';
		else if	( !Item.bElementAir &&  Item.bElementEarth &&  Item.bElementFire && !Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'xEFxS';
		else if	( !Item.bElementAir &&  Item.bElementEarth && !Item.bElementFire &&  Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'xExWS';
		else if	( !Item.bElementAir && !Item.bElementEarth &&  Item.bElementFire &&  Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'xxFWS';
		else if	(  Item.bElementAir && !Item.bElementEarth &&  Item.bElementFire &&  Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'AxFWS';
		else if	(  Item.bElementAir &&  Item.bElementEarth && !Item.bElementFire &&  Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'AExWS';
		else if	(  Item.bElementAir &&  Item.bElementEarth &&  Item.bElementFire && !Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'AEFxS';
		else if	(  Item.bElementAir &&  Item.bElementEarth &&  Item.bElementFire &&  Item.bElementWater && !Item.bElementSpirit ) DamageType = 'AEFWx';
		else if	( !Item.bElementAir &&  Item.bElementEarth &&  Item.bElementFire &&  Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'xEFWS';
		else if	(  Item.bElementAir &&  Item.bElementEarth &&  Item.bElementFire &&  Item.bElementWater &&  Item.bElementSpirit ) DamageType = 'AEFWS';
		else	   DamageType = 'xxxxx';

/*DEBUG
		if( true )
		{
			assert( Item.bElementAir	== class'AngrealInventory'.static.DamageTypeContains( DamageType, 'Air'    ) );
			assert( Item.bElementEarth	== class'AngrealInventory'.static.DamageTypeContains( DamageType, 'Earth'  ) );
			assert( Item.bElementFire	== class'AngrealInventory'.static.DamageTypeContains( DamageType, 'Fire'   ) );
			assert( Item.bElementWater	== class'AngrealInventory'.static.DamageTypeContains( DamageType, 'Water'  ) );
			assert( Item.bElementSpirit	== class'AngrealInventory'.static.DamageTypeContains( DamageType, 'Spirit' ) );
		}
*/
	}
	
	return DamageType;
}

////////////////
// AI Support //
////////////////

function bool ShouldCast()
{
	return HaveEnoughCharges() && ( ChargesUsedInGroup < IntendedChargesInGroup );
}

function InitChargeGroup()
{
	local float ChargeScale;
	if( ChargeCost > 0 )
	{
		ChargeScale = 1.0 / ChargeCost;
	}
	else
	{
		ChargeScale = 1;
	}
	IntendedChargesInGroup = FMin( CurCharges, RandRange( MinChargesInGroup, MaxChargesInGroup ) ) * ChargeScale;
}

//------------------------------------------------------------------------------
// What is the minimum and maximum distance within which the target must be for
// this artifact to be of any use.
//------------------------------------------------------------------------------
function GetEffectiveRange( out float MinRange, out float MaxRange )
{
	MinRange = GetMinRange();
	MaxRange = GetMaxRange();
}

//------------------------------------------------------------------------------
// Closest safe range to fire this artifact.
//------------------------------------------------------------------------------
function float GetMinRange()
{
	return 0;		// Override in subclasses.
}

//------------------------------------------------------------------------------
// Furthest effective range of artifact.
//------------------------------------------------------------------------------
function float GetMaxRange()
{
	return MaxInt;	// Override in subclasses.
}

function bool ShouldUncast()
{
	return ( MaxChargeUsedInterval != 0 ) || !ShouldCast();
}

//------------------------------------------------------------------------------
// Duration of cast.  (i.e. how long we should hold the button down for.)
// must call InitChargeGroup before calling thgis function
//------------------------------------------------------------------------------
function bool GetCastDuration( out float CastDuration )
{
	local float MinSecondsBetweenCharges;
	local bool bGetCastDuration;
	if( ShouldCast() )
	{
		assert( RoundsPerMinute != 0 );
		CastDuration = ( 60.0 / RoundsPerMinute ) + 0.05;
		if( MaxChargeUsedInterval == 0 )
		{
			//if the MaxChargeUsedInterval is 0 it is intended to be used as an automatic weapon
			CastDuration *= IntendedChargesInGroup - ChargesUsedInGroup;
		}
		bGetCastDuration = true;
	}
	return bGetCastDuration;
}

//------------------------------------------------------------------------------
// How badly does this artifact want to be used?  
// This will be relative to all other artifacts in the user's inventory.
//
// Default:		  PriorityUnusable (can not be used)
// Default:		  0.0 (could be used)
// Projectile:	  1.0
// Reflectors:	 20.0 (when usable)
// Leeches:		 20.0 (when usable)
// Balefire:	 10.0
// Health:		100.0 (when needed)
// Resouces:	 50.0 (when usable)
//------------------------------------------------------------------------------
function float GetPriority()
{
	local float ChargeUseTimeDelta, ReturnPriority;
	local float MinChargeUseTimeDelta;
	
	ReturnPriority = PriorityUnusable;
	ChargeUseTimeDelta = Level.TimeSeconds - LastChargeUsedTime;

	//all artifacts have a restriction of one cast per tick
	//a artifact with RoundsPerMinte set to zere means there is no restriction
	//of how charges may be used per minute (other than the global restriction
	//of one cast per tick)

	assert( RoundsPerMinute != 0 );
	if( RoundsPerMinute == 0 )
	{
		MinChargeUseTimeDelta = 1;
	}
	else
	{
		MinChargeUseTimeDelta = ( 60.0 / RoundsPerMinute );
	}
	
	if( ChargeUseTimeDelta >= MinChargeUseTimeDelta )
	{
		if( ShouldCast() )
		{
			//a subsequent cast should still be considered part of the current group
			ReturnPriority = Priority;
		}
		else if( HaveEnoughCharges() && ( ChargeUseTimeDelta >= MinChargeGroupInterval ) )
		{
			//a new charge group can be started
			ChargesUsedInGroup = 0;
			ReturnPriority = Priority;
		}
	}
	return ReturnPriority;
}

function bool GetEffectivePriority( out float EffectivePriority )
{
	local bool bGetPriority;
	local float MinRange, MaxRange, TargetDistance;
	if( Target != None )
	{
		TargetDistance = class'Util'.static.GetDistanceBetweenActors( Target, Owner );
		GetEffectiveRange( MinRange, MaxRange );

		if( ( TargetDistance >= MinRange ) && ( TargetDistance <= MaxRange ) )
		{
			if( Target.IsA( 'AngrealProjectile' ) )
			{
				bGetPriority = GetDefensivePriority( EffectivePriority, AngrealProjectile( Target ) );
			}
			else
			{
				bGetPriority = GetOffensivePriority( EffectivePriority, Target );
			}
		}
	}
	return bGetPriority;
}

function bool GetDefensivePriority( out float DefensivePriority, AngrealProjectile DefensiveTarget )
{
	local bool bEffective;

	if( bDefensive && DefensiveTarget.SourceAngreal != None )
	{
		if( DefensiveTarget.SourceAngreal.bElementFire && bElementFire )
		{
			bEffective = true;
		}
		else if( DefensiveTarget.SourceAngreal.bElementWater )
		{
			bEffective = true;
		}
		else if( DefensiveTarget.SourceAngreal.bElementAir )
		{
			bEffective = true;
		}
		else if( DefensiveTarget.SourceAngreal.bElementEarth )
		{
			bEffective = true;
		}
		else if( DefensiveTarget.SourceAngreal.bElementSpirit )
		{
			bEffective = true;
		}
		if( bEffective )
		{
			DefensivePriority = GetPriority();
			bEffective = ( DefensivePriority != PriorityUnusable );
		}
	}
	return bEffective;
}

function bool GetOffensivePriority( out float OffensivePriority, Actor Target )
{
	OffensivePriority = GetPriority();
	return bOffensive && ( OffensivePriority != PriorityUnusable );
}

//------------------------------------------------------------------------------
// Used to inform the artifact what it is intended to be used against.
//------------------------------------------------------------------------------
function SetVictim( Actor Victim )
{
	Target = Victim;
}

function Actor GetVictim()
{
	return Target;
}

//------------------------------------------------------------------------------
// Where the effect's trajectory being calculated from.
//
// Example: Location that the projectile is launched from.
//------------------------------------------------------------------------------
function vector GetTrajectorySource()
{
	local vector SourceLocation;

	if( Owner != None )
	{
		SourceLocation = Owner.Location;

		if( Pawn(Owner) != None )
		{
			SourceLocation.z += Pawn(Owner).BaseEyeHeight;
		}
	}

	return SourceLocation;
}

//------------------------------------------------------------------------------
// Check to see if this artifact should use leading when used.
// Example: NPCs using fireball will have to lead their target if it is moving.
//------------------------------------------------------------------------------
function float GetLeadSpeed()
{
	return -1;
}


function bool IsLeadable()
{
	return false;		// Override in subclasses.
}

//------------------------------------------------------------------------------
// If IsLeadable, calculates the Trajectory required to hit the given target
// from our owner's location.
// Set the owner's view rotation to this value before calling Cast().
// Return value is undefined if the artifact is not leadable.
//------------------------------------------------------------------------------
function rotator GetBestTrajectory()
{
	//xxxrlo use the actor initialized by set victim
	return rot(0,0,0);	// Override in subclasses.
}

defaultproperties
{
     DurationType=DT_None
     TAINT_COMMON_DAMAGE=5
     TAINT_UNCOMMON_DAMAGE=10
     TAINT_RARE_DAMAGE=20
     CommonTop=Texture'ParticleSystems.Appear.CyanCorona'
     CommonBottom=Texture'ParticleSystems.Appear.PurpleCorona'
     UnCommonTop=Texture'ParticleSystems.Appear.AOrangeCorona'
     UnCommonBottom=Texture'ParticleSystems.Appear.ABlueCorona'
     RareTop=Texture'ParticleSystems.Appear.APinkCorona'
     RareBottom=Texture'ParticleSystems.Appear.APurpleCorona'
     RoundsPerMinute=60.000000
     MinInitialCharges=1
     MaxInitialCharges=1
     bMPAppearEffect=True
     CueType=Class'ParticleSystems.RespawnFire'
     PuzzleCueSecondaryVolume=0.400000
     NotifyNewPickupTexture=Texture'WOT.NotifyPickup.I_NotifyPickup'
     NotifyNewPickupSoundName="WOT.NotifyPickup.NotifyPickupSound"
     MaxCharges=999
     ChargeCost=1
     FailMessage="failed"
     bTargetsFriendlies=True
     TaintedSoundName="WOT.Effect.Tainted"
     FailSoundName="WOT.Effect.AngrealFail"
     NPCRespawnTime=15.000000
     MaxChargesInGroup=1
     MinChargesInGroup=1
     MaxChargeUsedInterval=0.010000
     MinChargeGroupInterval=2.000000
     InventoryGroup=1
     PickupMessage="You found a Ter'angreal"
     PlayerViewOffset=(X=30.000000,Z=5.000000)
     MaxDesireability=0.500000
     PickupSound=Sound'WOT.Player.Pickup'
     bCanTeleport=True
     bNoSmooth=True
}
