//------------------------------------------------------------------------------
// LaunchProjectileEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Reusable class for launching projectiles.
//------------------------------------------------------------------------------
// How to use this class:
// 
// + Spawn this effect.
// + Set the desired projectile class.
// + Initialize it with the source actor (in this case the Actor that the 
//   projectile will initiate from).
// + Set a destination if desired.  (Seeking projectiles generally need a 
//   destination in order for them to seek properly.  Generic projectiles,
//   on the other hand, work fine without a destination.)
// + Pass it off to a WOTPlayer or WOTPawn for processing.
//------------------------------------------------------------------------------
class LaunchProjectileEffect expands SourceDestinationEffect;

var class<GenericProjectile> ProjectileClass;	// Type of projectile to launch.

var GenericProjectile ActualProjectile;			// Actual projectile to launch.	(Must be preinitialized.)

// Indicates whether or not the last call to Invoke succeeded or failed.
var bool bSuccess;

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	ProjectileClass = None;
	ActualProjectile = None;
	bSuccess = false;
}

//------------------------------------------------------------------------------
// Use this function to assign what projectile you wish to launch.
//------------------------------------------------------------------------------
function SetProjectile( class<GenericProjectile> P )
{
	ProjectileClass = P;
}

//------------------------------------------------------------------------------
// Assignes the ActualProjectile to launch.  All you need to do is spawn it.
// All other normal initialization will be taken care.
//
// Warning: Make sure the LaunchOffset of the given projectile is such that 
// it will not be positioned someplace where SetLocation will end up 
// destroying it due to collision with another object.
//------------------------------------------------------------------------------
function SetActualProjectile( GenericProjectile P )
{
	ActualProjectile = P;
}

//------------------------------------------------------------------------------
// Creates the desired projectile relative to the assigned Object.
//------------------------------------------------------------------------------
function Invoke()
{
	local GenericProjectile Proj;
	local rotator Rot;
	local vector Loc;
	
	bSuccess = False;

	// Error checking.
	if( ProjectileClass == None && ActualProjectile == None )
	{
		class'Debug'.static.DebugWarn( Self, "No ProjectileClass or ActualProjectile specified.", 'DebugCategory_Angreal' );
	}
	else if( Source == None )
	{
		class'Debug'.static.DebugWarn( Self, "No source Actor specified.", 'DebugCategory_Angreal' );
	}
	else if( ProjectileClass != None && ProjectileClass.default.bRequiresDestination && Destination == None )
	{
		class'Debug'.static.DebugWarn( Self, ProjectileClass$" requires a destination.", 'DebugCategory_Angreal' );
	}
	else if( ActualProjectile != None && ActualProjectile.bRequiresDestination && Destination == None )
	{
		class'Debug'.static.DebugWarn( Self, ActualProjectile$" requires a destination.", 'DebugCategory_Angreal' );
	}
	else
	{
		// Get rotation.
		if( Pawn(Source) != None )
		{
			Rot = Pawn(Source).ViewRotation;
		}
		else
		{
			Rot = Source.Rotation;
		}

		// Get projectile.
		if( ActualProjectile == None )
		{
			Loc = Source.Location;
			
			if( ProjectileClass.default.LaunchOffset != vect(0,0,0) )
			{
				Loc += ProjectileClass.default.LaunchOffset >> Source.Rotation;
			}

			if( Pawn(Source) != None )
			{
				Loc += vect(0,0,1) * Pawn(Source).BaseEyeHeight;
			}

			Proj = Spawn( ProjectileClass,,, Loc, Rot );
		}
		else
		{
			Proj = ActualProjectile;
			Proj.SetLocation( Source.Location + (Proj.LaunchOffset >> Source.Rotation) );
			Proj.SetRotation( Rot );
		}
		
		if( Proj != None )
		{
			Proj.SetSourceAngreal( SourceAngreal );
			
			if( !Proj.bHurtsOwner )
			{
				Proj.SetIgnoredPawn( Instigator );
			}
		
			Proj.SetDestination( Destination );
		
			bSuccess = Proj.CreationSucceeded();
		}

		// Get rid of the projectile if we don't succeed.
		if( !bSuccess && Proj != None )
		{
			Proj.Destroy();
		}
	}

	// Make sure to get rid of any leftover projectiles.
	if( !bSuccess && ActualProjectile != None )
	{
		ActualProjectile.Destroy();
	}
}

//------------------------------------------------------------------------------
// Indicates whether or not the last call to Invoke succeeded or failed.
// Note: Resets to False when called.
//------------------------------------------------------------------------------
function bool LastLaunchSucceeded()
{
	local bool bLaunchSucceeded;

	bLaunchSucceeded = bSuccess;
	bSuccess = False;
	
	return bLaunchSucceeded;
}

//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local LaunchProjectileEffect NewInvokable;

	NewInvokable = LaunchProjectileEffect(Super.Duplicate());

	NewInvokable.ProjectileClass	= ProjectileClass;
	NewInvokable.ActualProjectile	= ActualProjectile;
	NewInvokable.bSuccess			= bSuccess;
	
	return NewInvokable;
}

defaultproperties
{
}
