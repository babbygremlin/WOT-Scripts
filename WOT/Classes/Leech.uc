//------------------------------------------------------------------------------
// Leech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 13 $
//
// Description:	Provides a base class for all attachable latent effects.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Subclass and put all latent effect code in the AffectHost function.
// + When creating an instance of this class, remember to set its Lifespan
//   if you want it to uninstall itself.
// + Also you should set the AffectResolution to control how often your 
//   AffectHost() function is called.
// + Both Lifespan and AffectResolution can be modified in the Default
//   Properties.
// + If AffectResolutionScale != 1.0, AffectResolution will be scaled
//   (multiplied) by this after each AffectHost. If AffectResolutionScale
//   is greater than 1.0, the rate at which AffectHost is called will
//   decrease, if AffectResolutionScale is less than 1.0, the rate at which
//   AffectHost is called will increase. This can be used to have the rate
//   at which damage is done to the host deccelerate or accelerate, for
//   example.
//------------------------------------------------------------------------------
class Leech expands LegendActorComponent
	abstract;

#exec AUDIO IMPORT FILE=Sounds\Notification\DefaultExpiring.wav	GROUP=Notification

//////////////////////
// Member variables //
//////////////////////

// Angreal object responsible for our existance.
var AngrealInventory SourceAngreal;

// The projectile that created us - if one indeed did.
var AngrealProjectile SourceProjectile;
var class<AngrealProjectile> SourceProjClass;

// Owner - Who this Leech is attached to.

// Lifespan - how long this leech lasts for.

// Timer support.
var() float AffectResolution;			// How often AffectHost gets called.
var float AffectTimer;					// Used to keep track of timing for AfftectHost calls.

var() float AffectResolutionScale;		// AffectResolution scaled by this once each second (if not 1.0)

// Singly linked list support.
var Leech NextLeech;

// Do we have good intentions or bad?
var() bool bDeleterious;

// Should we display our SourceAngreal's icon on the player's screen?
var() bool bDisplayIcon;

// Are we allowed to be Unattached().	-- Clients should check this before removing us.
var() bool bRemovable;

// If true, calls to AttachTo( Pawn NewHost ) will fail if the given host
// already has leech of the same type attached to him/her.
var() bool bSingular;

// If true, Attach first UnAttaches all Leeches of similar type.
var() bool bRemoveExisting;

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

// True, if this Leech comes from a projectile.
// Non-projectile leeches can be shifted-out of and swapped-out of.
var bool bFromProjectile;

// If set, use this when displaying icons on the player's HUD instead of our SourceAngreal's.
var() Texture StatusIconFrame;

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
// Called when our lifespan is up.
//------------------------------------------------------------------------------
function Expired()
{
	Unattach();
	Super.Expired();
}

//------------------------------------------------------------------------------
// Called after every frame is drawn.
//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local int Iterations;

	// Affect Timer stuff.
	if( AffectResolution > 0.0 )
	{
		AffectTimer += DeltaTime;
		if( AffectTimer >= AffectResolution )
		{
			while( AffectTimer >= AffectResolution )
			{
				if( AffectResolutionScale != 1.0 )
				{
					// scale resolution
					AffectResolution *= AffectResolutionScale;
				}

				AffectTimer -= AffectResolution;	// Reset timer (with possibly new AffectResolution).

				Iterations++;
			}
			AffectHost( Iterations );
		}
	}

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

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
// Called to notify our owner that we are about to expire.  
// Each time it is called, it will flash our icon, and play a sound.
// Each notification we get less and less noticable.
//------------------------------------------------------------------------------
function NotifyOwnerExpiring()
{
	// Only notify real players if we are supposed to.
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
// Attaches itself to the given WOTPlayer or WOTPawn.
// Manages the underlying linked list of Leeches in WOTPlayer and WOTPawn.
//------------------------------------------------------------------------------
function AttachTo( Pawn NewHost )
{
	local Leech L;
	local LeechIterator IterL;
		
	// The host must be "fer real".
	//assert( WOTPlayer(Owner) != None ||	WOTPawn(Owner) != None );

	// Don't attach if we are singular and our host already has a leech of the
	// same type attached to him/her.
	if( bSingular )
	{
		IterL = class'LeechIterator'.static.GetIteratorFor( NewHost );
		for( IterL.First(); !IterL.IsDone(); IterL.Next() )
		{
			L = IterL.GetCurrent();

			if( L.Class == Class )
			{
				IterL.Reset();
				IterL = None;
				Destroy();	// NOTE[aleiby]: This may cause problems.
				return;
			}

		}
		IterL.Reset();
		IterL = None;
	}

	// Remove existing of similar type.
	if( bRemoveExisting )
	{
		IterL = class'LeechIterator'.static.GetIteratorFor( NewHost );
		for( IterL.First(); !IterL.IsDone(); IterL.Next() )
		{
			L = IterL.GetCurrent();

			if( L.Class == Class )
			{
				L.UnAttach();
				L.Destroy();
			}

		}
		IterL.Reset();
		IterL = None;
	}

	SetOwner( NewHost );

	// If you figure out an easier way to do this, fix it.
	if( WOTPlayer(Owner) != None )
	{
		NextLeech = WOTPlayer(Owner).FirstLeech;
		WOTPlayer(Owner).FirstLeech = self;
	}
	else if( WOTPawn(Owner) != None )
	{
		NextLeech = WOTPawn(Owner).FirstLeech;
		WOTPawn(Owner).FirstLeech = self;
	}

	// Add our icon to the player's screen.
	if( bDisplayIcon && WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).AddIconInfo( Self, !bDeleterious, Name );
	}

	// Set up the notify timer.
	NotifyExpireTimer = Lifespan - NotifyExpireTime;
}

//------------------------------------------------------------------------------
// Removes this Leech from the linked list of leeches within our Owner.
//------------------------------------------------------------------------------
function Unattach()
{
	local Leech CurrentLeech;	// Used as a cursor to search the list.

	if( Owner == None )
	{
		return;	// We aren't attached to anything.
	}
	
	// If you figure out an easier way to do this, fix it.
	if( WOTPlayer(Owner) != None )
	{
		if( WOTPlayer(Owner).FirstLeech == Self )
		{
			WOTPlayer(Owner).FirstLeech = NextLeech;	// Removes us from the list.
			NextLeech = None;	// For garbage collection sake.
		}
		else
		{
			CurrentLeech = WOTPlayer(Owner).FirstLeech;
		}
	}
	else if( WOTPawn(Owner) != None )
	{
		if( WOTPawn(Owner).FirstLeech == Self )
		{
			WOTPawn(Owner).FirstLeech = NextLeech;	// Removes us from the list.
			NextLeech = None;	// For garbage collection sake.
		}
		else
		{
			CurrentLeech = WOTPawn(Owner).FirstLeech;
		}
	}

	// Search through the list to find our PreviousLeech.
	while( CurrentLeech != None )
	{
		if( CurrentLeech.NextLeech == self )
		{
			CurrentLeech.NextLeech = NextLeech;	// Removes us from the list.
			NextLeech = None;	// For garbage collection sake.
			break;	// No need to continue.
		}

		// Iterate
		CurrentLeech = CurrentLeech.NextLeech;
	}

	// Remove our icon from the player's screen.
	if( bDisplayIcon && WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).RemoveIconInfo( Name );
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
// This function must be called when Leech is created.
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
// This function must be called when Leech is created.
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
	
//////////////////
// Overridables //
//////////////////

//------------------------------------------------------------------------------
simulated function AffectHost( optional int Iterations )
{
	// This function will get called every 'AffectResolution' seconds.
	// Put code to affect the host here.
}

defaultproperties
{
     AffectResolutionScale=1.000000
     bRemovable=True
     NotifyExpireTime=2.000000
     NotifyExpireResolution=1.000000
     NotifyExpireVolume=1.000000
     NotifyExpireSoundName="WOT.Notification.DefaultExpiring"
}
