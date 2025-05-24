//------------------------------------------------------------------------------
// Reflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 17 $
//
// Description:	Set of all reflectable functions used both by WOTPlayer and 
//				WOTPawn.  (Make your own freakin Reflector if you want to 
//				use	it for something else)  This class, though not necessarily 
//				highly coupled in the normal sense with WOTPlayer and WOTPawn, 
//				will be specifically tailored for WOTPlayer and WOTPawn and 
//				will not have much use outside of this application other than 
//				as a template for similar types of 'hacks'.  This is not, 
//				however, a hack.  It is simply a method a getting around the 
//				fact that we want to extend the functionality of Pawn, but 
//				cannot due to the limitations within UnrealScript.  This keeps 
//				us from duplicating code in both WOTPlayer and WOTPawn and 
//				allows us to decouple the Angreal from both classes.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Subclass this class and override the desired functions you wish to 
//   have reflected.  
// + When instantiating an instance of your subclass, make sure you set
//   its lifespan if you want your Reflector to uninstall itself after
//   a given time.  Alternatively, you can set the lifespan in the default
//   properties under Advanced.  You should set the lifespan before installing
//   your Reflector.  Otherwise, the expiring notification won't occur correctly.
// + Also make sure you set the priority for your unit especially if you
//   are planning on creating a null function.  In the case of a null function
//   where the objective is to make the reflected function not have any
//   effect (i.e. a null TakeDamage for GodMode) you will want to set the 
//   priority to the maximum value (255) so it gets called first.
// + When overriding functions, you have the responsibilty for calling the
//   next unit in the list.  The easiest way to do this is to call 
//   Super<Reflector>.MyFunction( MyParameters ) since this superclass takes 
//   care of calling the next unit in the list by default.  For functions that
//   return a value, you may not want to do this since it would override
//   whatever you want to return.  In these cases, you may want to call 
//   the functions lower in the list and compare what you receive to what
//   you want to return and make a decision accordingly.  It really depends
//   on the situation.  For the most part, you will just want to override the
//   previously reflected function.
// + If you find a function that you think you need to be reflectable in
//   WOTPlayer or WOTPawn or any of their subclasses, just add the function
//   here with the default implementation, and then create your Reflector
//   subclass and reflect your function to that.
// + You can safely change the priority of a Reflector even after it's been 
//   installed.
// + A default Reflector must be installed in the host on startup.  This
//   default Reflector may be overridden, but must never be removed. 
//   Other RefelctorSets installed later may be removed.
// + You should set the priority before installing a unit if you need to 
//   deviate from the default priority.  This way you avoid installing
//   the unit twice.
// + More to come...maybe.
//
//------------------------------------------------------------------------------
class Reflector expands LegendActorComponent
	abstract;

#exec AUDIO IMPORT FILE=Sounds\Notification\DefaultExpiring.wav	GROUP=Notification

//////////////////////
// Member variables //
//////////////////////

var() byte Priority;	// Used to determine the order of execution of 
						// reflector sets.
var() bool bRemovable;	// Is this unit uninstallable? (Default implementations 
						// should set this variable to false.) ??Needed??

// The Angreal responsible for installing me.
var AngrealInventory SourceAngreal;	
// Note: You can get the pawn responsible for installing this Reflector
// using Reflector.SourceAngreal.Owner.

// The projectile that created us - if one indeed did.
var AngrealProjectile SourceProjectile;
var class<AngrealProjectile> SourceProjClass;

// Actor.Owner refers to who this Reflector is installed in.

// Support for a doubley linked list of RefectorSets
var Reflector PrevReflector;	
var Reflector NextReflector;

// Do we have good intentions or bad?
var() bool bDeleterious;

// If true, Install first UnInstalls all Reflectors of the matching type.
var() bool bRemoveExisting;

// Do we want to display our source angreal's icon while we are active?
var() bool bDisplayIcon;

// How soon before we expire should we notify our owner?
var() float NotifyExpireTime;
var float NotifyExpireTimer;

// How often to we notify the owner once we expire. 
// (Time in seconds between notifications.)
var() float NotifyExpireResolution;

// How loud to initially play the notification.
// This will be halved every time it is played.
var() float NotifyExpireVolume;

// The sound to play to notify our owner.
var() string NotifyExpireSoundName;
var Sound NotifyExpireSound;

// True, if this Reflector comes from a projectile.
// Non-projectile reflectors can be shifted-out of and swapped-out of.
var bool bFromProjectile;

// If set, use this when displaying icons on the player's HUD instead of our SourceAngreal's.
var() Texture StatusIconFrame;

var bool bClientInstalled;

replication
{
	// NOTE[aleiby]: Is all this really needed anymore?
	reliable if( Role==ROLE_Authority )
		SourceAngreal, SourceProjectile, SourceProjClass;
}

//////////////////////////
// Engine notifications //
//////////////////////////

//------------------------------------------------------------------------------
// When we timeout, we simply uninstall ourself. -- ourself is the correct 
// tense since I am using the royal pronoun where 'our' is singular. -- and 
// then delete ourself.
//------------------------------------------------------------------------------
simulated function Expired()
{
	Uninstall();
	Super.Expired();
}

//------------------------------------------------------------------------------
// We need to keep track of how much time has passed so we can notify our
// owner when we are about to expire.
//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	if( Role == ROLE_Authority )
	{
		// Don't bother our owner if we are permanent.
		if( Lifespan > 0.0 )
		{
			NotifyExpireTimer -= DeltaTime;
			if( NotifyExpireTimer < 0.0 )
			{
				NotifyExpireTimer += NotifyExpireResolution;
				NotifyOwnerExpiring();
			}
		}
	}
	else
	{
		if( !bClientInstalled && Pawn(Owner) != None )
		{
			Install( Pawn(Owner) );
			bClientInstalled = true;
		}
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
// Called to notify our owner that we are about to expire.  
// Each time it is called, it will flash our icon, and play a sound.
// Each notification we get less and less noticable.
//------------------------------------------------------------------------------
function NotifyOwnerExpiring()
{
	// Only notify real players if we're supposed to.
	if( bDisplayIcon && WOTPlayer(Owner) != None )
	{
		if( NotifyExpireSound == None && NotifyExpireSoundName != "" )
		{
			NotifyExpireSound = Sound( DynamicLoadObject( NotifyExpireSoundName, class'Sound' ) );
		}
		
		if( NotifyExpireSound != None )
		{
			Owner.PlaySound( NotifyExpireSound,, NotifyExpireVolume );
			NotifyExpireVolume *= 0.5;
		}
	}
}

///////////////////////
// Support functions //
///////////////////////

//------------------------------------------------------------------------------
// Using the host's reference to it's current reflector set, it adds this 
// reflector set to the underlying linked list of reflector sets built into 
// Reflector class according to its priority.  High priority Reflectors 
// get added closer to the host's current reflector set so that it gets called 
// sooner.
// This may seem complicated, but basically, we're just inserting a Reflector
// into an ordered doubley linked list where the host.CurrentReflector
// points to the first Reflector in the list.
//------------------------------------------------------------------------------
simulated function Install( Pawn NewHost )
{
	local Reflector R;
	local ReflectorIterator IterR;

    local Reflector RefSet;	// Used as a cursor to iterate the list of 
							// Reflectors.

	SetOwner( NewHost );

	// Error check.
	if( WOTPlayer(Owner) == None && WOTPawn(Owner) == None )
	{
		warn( "Owner("$Owner$") is not a WOTPlayer or WOTPawn." );
		return;
	}
/*
	// The host must be "fer real".
	assert( WOTPlayer(Owner) != None || WOTPawn(Owner) != None );
*/
	// Remove current matching reflectors.
	if( bRemoveExisting )
	{
		IterR = class'ReflectorIterator'.static.GetIteratorFor( Pawn(Owner) );
		for( IterR.First(); !IterR.IsDone(); IterR.Next() )
		{
			R = IterR.GetCurrent();

			if( R.Class == Class )
			{
				R.UnInstall();
				R.Destroy();
			}
		}
		IterR.Reset();
		IterR = None;
	}
	
	// If you figure out an easier way to do this, fix it.
	// This type of expression permiates the entire codebase since
	// there is no such thing as multiple inheritance in UnrealScript.
	// The Reflector class tries to bridge this by allowing us to use
	// the same code in both WOTPlayer and WOTPawn.
	if( WOTPlayer(Owner) != None )
	{
		RefSet = WOTPlayer(Owner).CurrentReflector;
	}
	else // Must be a WOTPawn since the assert take care of all the other cases.
	{
		RefSet = WOTPawn(Owner).CurrentReflector;
	}

	// Find the place that this Reflector belongs according to priority.
	// Newer Reflectors get installed before older ones of the same priority.
	// Note: If I didn't have to do the messyness above with the if statements, 
	// I would make this into a for loop that did nothing.  - I don't like while
	// loops...don't ask me why because I don't know.
	while( RefSet != None && Self.Priority < RefSet.Priority )
	{
		RefSet = RefSet.NextReflector;
	}

	// Plug it in by updating the next and prev fields of all the affected 
	// Reflectors.
	if( RefSet != None )
	{
		PrevReflector = RefSet.PrevReflector;
	}
	if( PrevReflector != None )
	{
		PrevReflector.NextReflector = Self;
	}
	// If out pointer to our previous Reflector in the list is None,
	// then we must be the first Reflector in the list.
	// Update the host's reference so that it is always pointing to 
	// the first Reflector in the list.
	else
	{
		if( WOTPlayer(Owner) != None )
		{
			WOTPlayer(Owner).CurrentReflector = Self;
		}
		else // must be a WOTPawn.
		{
			WOTPawn(Owner).CurrentReflector = Self;
		}
	}
	// Don't overlook this line since no check was needed.
	NextReflector = RefSet;
	if( NextReflector != None )
	{
		NextReflector.PrevReflector = Self;
	}
	
	if( Role == ROLE_Authority )
	{
		// Add our icon to the player's screen.
		if( bDisplayIcon && WOTPlayer(Owner) != None )
		{
			WOTPlayer(Owner).AddIconInfo( Self, !bDeleterious, Name );
		}

		// Set up the notify timer.
		NotifyExpireTimer = Lifespan - NotifyExpireTime;
	}
}

//------------------------------------------------------------------------------
// Remove from the list.
//------------------------------------------------------------------------------
simulated function UnInstall()
{
	// Safety check.
	// NOTE[aleiby]: This is possibly bad since there are places UnInstall is called
	// conditionally when Owner == None.
	if( Owner == None )
		return;

	// Update our neighbor's pointers to point to each other.
	if( PrevReflector != None )
	{
		PrevReflector.NextReflector = NextReflector;
	}
	if( NextReflector != None )
	{
		NextReflector.PrevReflector = PrevReflector;
	}

	// Update our Owner's CurrentReflector pointer if needed.
	if( WOTPlayer(Owner) != None && WOTPlayer(Owner).CurrentReflector == Self )
	{
		WOTPlayer(Owner).CurrentReflector = NextReflector;
	}
	else if( WOTPawn(Owner) != None && WOTPawn(Owner).CurrentReflector == Self )
	{
		WOTPawn(Owner).CurrentReflector = NextReflector;
	}
	
	// Clear our pointers.
/*	- Leave intact since in the process of doing our business (i.e. Sending a 
	- NotifyDamagedBy notification via TakeDamage) we may get UnInstalled.  
	- Clearing the NextReflector variable would break the TakeDamage
	- function propagation chain prematurely.  Ideally, this should be cleared
	- once we stop propogating the function in question.
	NextReflector = None;
	PrevReflector = None;
*/

	if( Role == ROLE_Authority )
	{
		// Remove our icon from the player's screen.
		if( bDisplayIcon && WOTPlayer(Owner) != None )
		{
			WOTPlayer(Owner).RemoveIconInfo( Name );
		}
	}
	
	// Clear Owner.
	SetOwner( None );
}

//------------------------------------------------------------------------------
// Used for IconInfo display
//------------------------------------------------------------------------------
function float GetInitialDuration()
{
	return GetDuration();
}

//------------------------------------------------------------------------------
// Used for IconInfo display
//------------------------------------------------------------------------------
function float GetDuration()
{
	return Lifespan;
}

//------------------------------------------------------------------------------
// Use this function if you need to adjust the order that reflector sets 
// are invoked.  An example of this would be a null implementation where
// you don't want anything to happen.  However, if this is not called first
// then some things may happen before you can stop them with the null 
// implemented refector set.  (I would like to set priorities to the individual 
// reflected functions within a reflector set, but I don't think it is going to 
// happen.)
//------------------------------------------------------------------------------
simulated function SetPriority( byte NewPriority )
{
	Priority = NewPriority;
	if( Owner != None )			// Must be already installed.
	{
		Uninstall(); // NOTE[aleiby]: Take permanent Reflectors into account.
		Install( Pawn(Owner) );	// Reinserts it into the list with the new 
								// priority level.
	}
}

//------------------------------------------------------------------------------
// This function must be called when we are created.
//------------------------------------------------------------------------------
function SetSourceAngreal( AngrealInventory Source )
{
	SourceAngreal = Source;
	
	if( SourceAngreal != None )
	{
		Instigator = Pawn(SourceAngreal.Owner);
	}
}

//------------------------------------------------------------------------------
// This function must be called when we are created.
//------------------------------------------------------------------------------
function SetSourceProjectile( AngrealProjectile Source )
{
	SourceProjectile = Source;
	
	if( SourceProjectile != None )
	{
		SourceProjClass = SourceProjectile.Class;
	}
	else
	{
		SourceProjClass = None;
	}
}
	
//------------------------------------------------------------------------------
function InitializeWithLeech( Leech Source )
{
	SourceAngreal		= Source.SourceAngreal;
	SourceProjectile	= Source.SourceProjectile;
	SourceProjClass		= Source.SourceProjClass;
	Instigator			= Source.Instigator;
}
	
//------------------------------------------------------------------------------
function InitializeWithReflector( Reflector Source )
{
	SourceAngreal		= Source.SourceAngreal;
	SourceProjectile	= Source.SourceProjectile;
	SourceProjClass		= Source.SourceProjClass;
	Instigator			= Source.Instigator;
}
	
//------------------------------------------------------------------------------
function InitializeWithInvokable( Invokable Source )
{
	SourceAngreal		= Source.SourceAngreal;
	SourceProjectile	= Source.SourceProjectile;
	SourceProjClass		= Source.SourceProjClass;
	Instigator			= Source.Instigator;
}
	
//------------------------------------------------------------------------------
function InitializeWithProjectile( AngrealProjectile Source )
{
	SourceAngreal		= Source.SourceAngreal;
	SourceProjectile	= Source;
	SourceProjClass		= Source.Class;
	Instigator			= Source.Instigator;
}
	
//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Owner != None )
	{
		UnInstall();
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
// Removes the given number of reflectors of this type from the given Pawn.
//------------------------------------------------------------------------------
static function RemoveReflectorFrom( Pawn Other, optional int Num )
{
	local Reflector IterR;
	
	// Default to one.
	if( Num == 0 )
	{
		Num = 1;
	}

	// Get pointer to beginning of Reflector list.
	if( WOTPlayer(Other) != None )
	{
		IterR = WOTPlayer(Other).CurrentReflector;
	}
	else if( WOTPawn(Other) != None )
	{
		IterR = WOTPawn(Other).CurrentReflector;
	}
	else
	{
		warn( Other$" is neither a WOTPlayer nor a WOTPawn." );
		return;
	}

	// Iterate through reflectors.
	while( Num > 0 && IterR != None )
	{
		// Remove reflectors of this type.
		if( IterR.IsA( default.Class.Name ) )
		{
			IterR.UnInstall();
			IterR.Destroy();
			Num -= 1;
		}

		IterR = IterR.NextReflector;
	}
}

//------------------------------------------------------------------------------
// Returns the first reflector of this type in the given Pawn, None if no match.
//------------------------------------------------------------------------------
static function Reflector GetReflector( Pawn Other )
{
	local Reflector IterR;

	// Get pointer to beginning of Reflector list.
	if( WOTPlayer(Other) != None )
	{
		IterR = WOTPlayer(Other).CurrentReflector;
	}
	else if( WOTPawn(Other) != None )
	{
		IterR = WOTPawn(Other).CurrentReflector;
	}
	else
	{
		warn( Other$" is neither a WOTPlayer nor a WOTPawn." );
		return None;
	}

	// Iterate through reflectors.
	while( IterR != None )
	{
		// Remove reflectors of this type.
		if( IterR.IsA( default.Class.Name ) )
		{
			break;
		}

		IterR = IterR.NextReflector;
	}

	return IterR;
}

//------------------------------------------------------------------------------
// Creates a copy, and installs in owner.
//------------------------------------------------------------------------------
function InstallCopy()
{
	local Reflector R;

	R = Spawn( Class );
	R.LifeSpan = LifeSpan;
	R.Priority = Priority;
	R.bRemovable = bRemovable;
	R.bDeleterious = bDeleterious;
	R.bDisplayIcon = false;				// We already have one installed, no need to display another icon.
	R.InitializeWithReflector( Self );
	R.Install( Pawn(Owner) );
}

/////////////////////////
// Reflected Functions //
/////////////////////////

//------------------------------------------------------------------------------
// These are the functions you will override in subclasses.
// You can add more functions on an as needed basis.
// The default implementation is to simply call the next reflected function
// in the next RefectorSet in the built in ordered list.
// When overriding any of these functions, the last thing you should do is
// call Super.MyFunction(...) so that this chain of reflections continues. 
// The exception to this would be if you would like to stop the chain of
// reflections.  An example of this would be for a null implementation where 
// you don't want anything to happen when this function is called.
// Also, if a function returns something, your function will have to make a 
// decision whether or not it wants to return its own value or pass the 
// responsibility onto a class lower in the list.  IOW: you're pretty much
// on your own when deciding whether or not to call the next function in the
// list.  By default the next Reflector's function is called - if you don't
// override the function.  If you do override the function, you can call the
// superclass's function to make it easier for you, or you can deal with it 
// yourself.
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Used for selecting targets for angreal, etc.
//------------------------------------------------------------------------------
function Actor FindBestTarget( vector Loc, rotator ViewRot, float MaxAngleInDegrees, optional AngrealInventory UsingArtifact )
{
	local Actor Target;

	if( NextReflector != None )
	{
		Target = NextReflector.FindBestTarget( Loc, ViewRot, MaxAngleInDegrees, UsingArtifact );
	}

	return Target;
}

//------------------------------------------------------------------------------
// Called by exec functions like Fire() or whatever.
// (This function name may need to be changed to match whatever currently is 
// in place).
//------------------------------------------------------------------------------
function UseInventoryItem( Inventory Item )
{
	if( NextReflector != None )
	{
		NextReflector.UseInventoryItem( Item );
	}
}

//-----------------------------------------------------------------------------
// Turn the currently selected angreal on.
//-----------------------------------------------------------------------------
function UseAngreal()
{
	if( NextReflector != None )
	{
		NextReflector.UseAngreal();
	}
}

//-----------------------------------------------------------------------------
function NotifyCastFailed( AngrealInventory FailedArtifact )
{
	if( NextReflector != None )
	{
		NextReflector.NotifyCastFailed( FailedArtifact );
	}
}

//-----------------------------------------------------------------------------
// Turn the currently selected angreal off.
//-----------------------------------------------------------------------------
function CeaseUsingAngreal()
{
	if( NextReflector != None )
	{
		NextReflector.CeaseUsingAngreal();
	}
}

//------------------------------------------------------------------------------
// Notification for when a charge has been used.
//------------------------------------------------------------------------------
function ChargeUsed( AngrealInventory Ang )
{
	if( NextReflector != None )
	{
		NextReflector.ChargeUsed( Ang );
	}
}

//------------------------------------------------------------------------------
// Called by angreal projectiles to notify the victim what just hit them.
//------------------------------------------------------------------------------
simulated function NotifyHitByAngrealProjectile( AngrealProjectile HitProjectile )
{
	if( NextReflector != None )
	{
		NextReflector.NotifyHitByAngrealProjectile( HitProjectile );
	}
}

//------------------------------------------------------------------------------
// Called by seeker angreal to notify the victim that it has just targeted it.
//
// Originally, it only took a SeekingProjectile as a parameter, but
// becuase WOTPlayer and WOTPawn don't have a clue what a SeekingProjectile
// is, it has been loosened to just taking a plain vanilla angreal projectile.
//------------------------------------------------------------------------------
function NotifyTargettedByAngrealProjectile( AngrealProjectile Proj )
{
	if( NextReflector != None )
	{
		NextReflector.NotifyTargettedByAngrealProjectile( Proj );
	}
}

//------------------------------------------------------------------------------
// This is called everywhere.
//------------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn InstigatedBy, vector Hitlocation, vector Momentum, name DamageType )
{
	if( NextReflector != None )
	{
		NextReflector.TakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, DamageType );
	}
}

//------------------------------------------------------------------------------
function FootZoneChange( ZoneInfo newFootZone )
{
	if( NextReflector != None )
	{
		NextReflector.FootZoneChange( newFootZone );
	}
}

//-----------------------------------------------------------------------------
// Increases the health of the pawn by the given amount.
//-----------------------------------------------------------------------------
function IncreaseHealth( int Amount )
{
	if( NextReflector != None )
	{
		NextReflector.IncreaseHealth( Amount );
	}
}

//------------------------------------------------------------------------------
// When an angreal wants to effect another player, the effect must be 
// transfered in the form of a projectile.  That projectile must then 
// interface the collided player or pawn through this function in order 
// use the effect on that player or pawn.
//------------------------------------------------------------------------------
function ProcessEffect( Invokable I )
{
	if( NextReflector != None )
	{
		NextReflector.ProcessEffect( I );
	}
}

//------------------------------------------------------------------------------
// The following functions prototypes are provided to simulate the ignores
// in the state that these will be translated from.  They will simply be 
// overridden so that they don't continue the reflection chain and the
// RefectorSet itself will be given a maximum priority so that it gets 
// called first. -- these originate from Grunt.
//------------------------------------------------------------------------------

function AlarmSounded( Alarm NotifyingAlarm )
{
	if( NextReflector != None )
	{
		NextReflector.AlarmSounded( NotifyingAlarm );
	}
}

function AlertedByCaptain( Actor Capt, Actor TargetPlayer, vector NewGoalLocation )
{
	if( NextReflector != None )
	{
		NextReflector.AlertedByCaptain( Capt, TargetPlayer, NewGoalLocation );
	}
}

function SeeEnemyPlayer( PlayerPawn SeenPlayer )
{
	if( NextReflector != None )
	{
		NextReflector.SeeEnemyPlayer( SeenPlayer );
	}
}

function SetupAssetClasses()
{
	if( NextReflector != None )
	{
		NextReflector.SetupAssetClasses();
	}
}

defaultproperties
{
     bRemovable=True
     bDisplayIcon=True
     NotifyExpireTime=2.000000
     NotifyExpireResolution=1.000000
     NotifyExpireVolume=1.000000
     NotifyExpireSoundName="WOT.Notification.DefaultExpiring"
     bAlwaysRelevant=True
}
