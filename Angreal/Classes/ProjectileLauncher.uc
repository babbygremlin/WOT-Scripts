//------------------------------------------------------------------------------
// ProjectileLauncher.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 9 $
//
// Description:	Launches any subclass of GenericProjectile.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Subclass and #exec all your assets like StatusIcon and ActivateSound.
// + Assign a ProjectileClass in the Default Properties.
// + Configure bAutoFire and RoundsPerMinute for repeat fire weapons.
// + Assign all other relative AngrealInventory configurations.
//------------------------------------------------------------------------------
// How this class works:
//
// + On creation, a persistant Launcher object is created and setup
//   with the projectile defined in our default properties.
// + A WOTPlayer or WOTPawn calls our Cast() function.
// + We go into the Using state.
// + We launch a single projectile.
// + If we are a repeater, we go into an infinate loop launching another
//   projectile every 60/RoundsPerMinute seconds.
// + We break out of this loop when the WOTPlayer or WOTPawn calls our
//   UnCast() function again to toggle us off.
// + If we are not a repeater or we run out of charges, we automagically 
//   deactivate ourself.
//------------------------------------------------------------------------------
class ProjectileLauncher expands AngrealInventory;

var() bool	bAutoFire;					// keeps firing while fire key is depressed.
//var() float	RoundsPerMinute;		// Number of rounds fired per minute.

// Projectile to launch.
var() string ProjectileClassName;		// Dynamically load the class from a string to reduce coupling.
var class<GenericProjectile> ProjectileClass;

// Persistant Projectile Launcher.
var LaunchProjectileEffect Launcher;
		
// Is this angreal currently being used?
var bool bCasting;

// When we are allowed to cast next.
var float NextCastTime;

// Who we targetted last.
var Actor BestTarget;

/////////////
// Support //
/////////////

//------------------------------------------------------------------------------
function bool LoadProjectile()
{
	if( ProjectileClass == None && ProjectileClassName != "" )
	{
		ProjectileClass = class<GenericProjectile>( DynamicLoadObject( ProjectileClassName, class'Class' ) );
	}
	if( ProjectileClass == None )
	{
		warn( "ProjectileClass not properly set." );
	}
	return ProjectileClass != None;
}

//------------------------------------------------------------------------------
// Get the best target from our owner.
// You may override this function if you want to get the best target using
// some other method.
//------------------------------------------------------------------------------
function Actor GetBestTarget()
{
	local Actor A;

	// AI Support - Fix RLO: remove this requirement by updating the NPC's ViewRotation before casting.
	if( Target != None )
	{
		return Target;
	}

	if( WOTPlayer(LastOwner) != None )
	{					
		if( LoadProjectile() )
		{
			A = WOTPlayer(LastOwner).FindBestTarget( GetTrajectorySource(), Pawn(LastOwner).ViewRotation, ProjectileClass.default.MaxTargetAngle, Self );
		}
	}
	else if( WOTPawn(LastOwner) != None )
	{
		if( LoadProjectile() )
		{
			A = WOTPawn(LastOwner).FindBestTarget( GetTrajectorySource(), Pawn(LastOwner).ViewRotation, ProjectileClass.default.MaxTargetAngle, Self );
		}
	}

	return A;
}

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
// Releases the power within the ter'angreal artifact.
//------------------------------------------------------------------------------
function Cast()
{
	if( !bCasting )
	{
		Super.Cast();
		bCasting = True;
		AttemptCast();
	}
}

//------------------------------------------------------------------------------
function Failed()
{
	NextCastTime = Level.TimeSeconds;	// Allow user to refire on the next tick if we fail.
	Super.Failed();
}

//------------------------------------------------------------------------------
// Stops the ter'angreal from releasing its effect.
//------------------------------------------------------------------------------
function UnCast()
{
	if( bCasting )
	{
		Super.UnCast();
		bCasting = False;
	}
}

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	NextCastTime = 0.0;
}

//////////////////////
// Worker functions //
//////////////////////

//------------------------------------------------------------------------------
function AttemptCast()
{
	// Launch one projectile if we have enough charges.
	if( Level.TimeSeconds > NextCastTime && HaveEnoughCharges() )
	{
		LaunchProjectile();
	}
}

//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	// If we are a repeater, constantly try to fire as long as the castor 
	// wants us to continue casting.
	if( bAutoFire && bCasting )
	{
		AttemptCast();
	}
}

//------------------------------------------------------------------------------
function LaunchProjectile()
{
	if( !LoadProjectile() )
	{
		Failed();
		return;
	}

/*
	// Create our persistant projectile launcher if needed.
	if( Launcher == None )
	{
		Launcher = Spawn( ProjectileClass.default.LauncherClass );
		Launcher.SetProjectile( ProjectileClass );
		Launcher.SetSourceAngreal( Self );
	}
*/
	Launcher = LaunchProjectileEffect( class'Invokable'.static.GetInstance( Self, ProjectileClass.default.LauncherClass ) );
	Launcher.SetProjectile( ProjectileClass );
	Launcher.SetSourceAngreal( Self );

	// Get our target if needed.
	BestTarget = None;
	if( ProjectileClass.default.bUsesDestination )
	{
		BestTarget = GetBestTarget();
	}

	// Projectiles will be launched from our current owner.
	Launcher.Initialize( LastOwner, BestTarget );
			
	// Hand it off to our Owner to process it.
	if( WOTPlayer(LastOwner) != None )
	{					
		WOTPlayer(LastOwner).ProcessEffect( Launcher );
	}
	else if( WOTPawn(LastOwner) != None )
	{
		WOTPawn(LastOwner).ProcessEffect( Launcher );
	}
	else
	{
		warn( "Owner is not a WOTPlayer or WOTPawn!" );
	}

	if( Launcher.LastLaunchSucceeded() )
	{
		UseCharge();
		LastOwner.MakeNoise(1.0);
	
		// Calculate when next we are allowed to cast.
		NextCastTime = Level.TimeSeconds + (60.0 / RoundsPerMinute);
	}
	else
	{
		Failed();
	}
}

////////////////
// AI Support //
////////////////

//------------------------------------------------------------------------------
// Check to see if this artifact should use leading when used.
// Example: NPCs using fireball will have to lead their target if it is moving.
//------------------------------------------------------------------------------
function bool IsLeadable()
{
	if( LoadProjectile() )
	{
		return ProjectileClass.default.bRequiresLeading;
	}
	else
	{
		return false;
	}
}

//------------------------------------------------------------------------------
// Returns the speed of the projectile launched be this artifact.
// This only makes sense for projectiles with a constant velocity like 
// fireball and dart.
// Return value is undefined if the artifact is not leadable.
//------------------------------------------------------------------------------
function float GetLeadSpeed()
{
	if( IsLeadable() && LoadProjectile() )	return ProjectileClass.default.Speed;
	else									return 0;
}

//------------------------------------------------------------------------------
// If IsLeadable, calculates the Trajectory required to hit the given target
// from our owner's location.
// Set the owner's view rotation to this value before calling Cast().
// Return value is undefined if the artifact is not leadable.
//------------------------------------------------------------------------------
function rotator GetBestTrajectory()
{
	if( IsLeadable() && LoadProjectile() )	return ProjectileClass.static.CalculateTrajectory( LastOwner, Target );
	else									return rotator(Target.Location - LastOwner.Location);
}

//------------------------------------------------------------------------------
// How close should our target be for this artifact to be of any use.
//------------------------------------------------------------------------------
function float GetMaxRange()
{
	if( LoadProjectile() )
	{
		return ProjectileClass.static.GetMaxRange();
	}
	else
	{
		return 0.0;
	}
}

//------------------------------------------------------------------------------
// The closest safe range to use this artifact.
//------------------------------------------------------------------------------
function float GetMinRange()
{
	if( LoadProjectile() )
	{
		return ProjectileClass.static.GetMinRange();
	}
	else
	{
		return 0.0;
	}
}

defaultproperties
{
     bRestrictsUsage=True
     Priority=1.000000
     MaxChargeUsedInterval=1.000000
}
