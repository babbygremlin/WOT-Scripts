//------------------------------------------------------------------------------
// ProjLeechArtifact.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	Launches a CallbackProjectile.  When it reaches it's 
//				destination, we install a Leech on the destination.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Subclass.
// + Assign a ProjectileClass in the defaultproperties.
// + Assign a LeechClass in the defaultproperties.
//
// Note:	The Leech must properly call NotifyDestinationLost().
//			(See LightningLeech for an example.)
//------------------------------------------------------------------------------
class ProjLeechArtifact expands AngrealInventory;

///////////////////////////////////////////////////
// This class has been DEPRICATED by the author. //
///////////////////////////////////////////////////

var() string ProjectileClassName;					// Dynamically load classes from strings to reduce coupling.
var() string LeechClassName;
var class<CallbackProjectile> ProjectileClass;		// The type of projectile to launch.
var class<Leech> LeechClass;						// The type of leech to attach.

//var() float RoundsPerMinute;						// The amount of charges used per minute.

var bool bCasting;									// Are we casting?

var CallbackProjectile MyProj;						// Our CallBack projectile.
var Leech MyLeech;									// The leech we installed in our destination.

var LaunchProjectileEffect Launcher;				// Our persistant ProjectileLauncher.
var AttachLeechEffect Attacher;						// Our persistant LeechAttacher.

var float ChargeTimer;								// Used to track time for charge useage.

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
//	Launch a projectile.
//------------------------------------------------------------------------------
function Cast()
{
	local Actor BestTarget;

	LazyLoad();

	BestTarget = GetBestTarget();
/*
	// Create our persistant launcher if we need one.
	if( Launcher == None )
	{
		Launcher = Spawn( class'LaunchProjectileEffect' );
		Launcher.SetSourceAngreal( Self );
	}
*/
	Launcher = LaunchProjectileEffect( class'Invokable'.static.GetInstance( Self, class'LaunchProjectileEffect' ) );

	// Projectile will be launched from our current owner.
	Launcher.Initialize( Owner, BestTarget );
	
	// Create our projectile.
	MyProj = Spawn( ProjectileClass );

	// Give it to our Launcher.
	Launcher.SetActualProjectile( MyProj );

	// Hand our Launcher off to our Owner to process it.
	if( WOTPlayer(Owner) != None )
	{					
		WOTPlayer(Owner).ProcessEffect( Launcher );
	}
	else if( WOTPawn(Owner) != None )
	{
		WOTPawn(Owner).ProcessEffect( Launcher );
	}
	else
	{
		warn( "Owner is not a WOTPlayer or WOTPawn!" );
	}

	// Check for success.
	if( Launcher.LastLaunchSucceeded() )
	{
		bCasting = True;
		Super.Cast();
	}
	else
	{
		Failed();
	}
}

//------------------------------------------------------------------------------
// Stops the madness!!!
//------------------------------------------------------------------------------
singular function UnCast()
{
	if( bCasting )
	{
		if( MyProj != None )
		{
			MyProj.Destroy();
		}
		
		if( MyLeech != None )
		{
			MyLeech.Unattach();
			MyLeech.Destroy();
		}

		bCasting = False;
		
		Super.UnCast();
	}
}

///////////////////
// Notifications //
///////////////////

//------------------------------------------------------------------------------
// Called by our CallbackProjectile when it reaches its destination.
// Attaches a Leech to our victim.
//------------------------------------------------------------------------------
function NotifyReachedDestination( Actor Destination )
{
	LazyLoad();
/*
	if( Attacher == None )
	{
		Attacher = Spawn( class'AttachLeechEffect' );
		Attacher.SetSourceAngreal( Self );
	}
*/
	Attacher = AttachLeechEffect( class'Invokable'.static.GetInstance( Self, class'AttachLeechEffect' ) );
	Attacher.SetSourceAngreal( Self );

	MyLeech = Spawn( LeechClass );
	MyLeech.SetSourceAngreal( Self );

	Attacher.SetLeech( MyLeech );
	Attacher.SetVictim( Pawn(Destination) );
	
	if( WOTPlayer(Destination) != None )
	{
		WOTPlayer(Destination).ProcessEffect( Attacher );
	}
	else if( WOTPawn(Destination) != None )
	{
		WOTPawn(Destination).ProcessEffect( Attacher );
	}
}

//------------------------------------------------------------------------------
// Called by either our CallbackLeech or CallbackProjectile when we lose
// our Destination.  Usually because the destination died.
//------------------------------------------------------------------------------
function NotifyDestinationLost()
{
	UnCast();
}

//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	if( bCasting )
	{
		// Suck up charges while we are casting.
		ChargeTimer -= DeltaTime;
		if( ChargeTimer <= 0 )
		{
			ChargeTimer += (60.0 / RoundsPerMinute);
			UseCharge();
		}
	}
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
// Get the best target from our owner.
// You may override this function if you want to get the best target using
// some other method.
//------------------------------------------------------------------------------
function Actor GetBestTarget()
{
	local Actor A;

	LazyLoad();

	if( WOTPlayer(Owner) != None )
	{					
		A = WOTPlayer(Owner).FindBestTarget( GetTrajectorySource(), Pawn(Owner).ViewRotation, ProjectileClass.default.MaxTargetAngle );
	}
	else if( WOTPawn(Owner) != None )
	{
		A = WOTPawn(Owner).FindBestTarget( GetTrajectorySource(), Pawn(Owner).ViewRotation, ProjectileClass.default.MaxTargetAngle );
	}

	return A;
}

//------------------------------------------------------------------------------
function LazyLoad()
{
	//Super.PreBeginPlay();

	// ProjectileClass
	if( ProjectileClass == None && ProjectileClassName != "" )
	{
		ProjectileClass = class<CallbackProjectile>( DynamicLoadObject( ProjectileClassName, class'Class' ) );
	}
	if( ProjectileClass == None )
	{
		warn( "ProjectileClass not properly set." );
	}

	// LeechClass
	if( LeechClass == None && LeechClassName != "" )
	{
		LeechClass = class<Leech>( DynamicLoadObject( LeechClassName, class'Class' ) );
	}
	if( LeechClass == None )
	{
		warn( "LeechClass not properly set." );
	}
}

defaultproperties
{
    bRestrictsUsage=True
    MaxChargeUsedInterval=1.00
}
