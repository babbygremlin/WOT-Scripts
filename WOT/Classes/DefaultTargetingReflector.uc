//------------------------------------------------------------------------------
// DefaultTargetingReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 6 $
//
// Description:	Handles FindBestTarget() reflected calls.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Install in a WOTPlayer or WOTPawn at start-up using the Install() function.
// + Note: Strings are used to store the class names in the default properties
//   so we can dynamically load the classes at run-time.  This allows us to
//   specify classes from other packages without creating a dependancy on that
//   package at compile time.
//------------------------------------------------------------------------------
class DefaultTargetingReflector expands Reflector;

var AngrealInventory UsingArtifact;	// The artifact that is currently using.

var() name TargetableTypes[5];		// Types of classes we can target.

// NOTE[aleiby]: We really should move the TargetableTypes into AngrealInventory,
// so we don't have to worry about all this convoluted code to handle exceptions.

//------------------------------------------------------------------------------
function bool IsTargetable( Actor A )
{
	local int i;	// Your standard everday iterator.

	// Don't pick ignored types.
	if( UsingArtifact != None && UsingArtifact.IsNotTargetable( A ) )
	{
		return false;
	}

	// You can pick your friends...
	// and you can pick your nose...
	// but don't pick your Owner,
	// and don't pick a ghost. :)
	if( A == Owner || A.bHidden ) 
	{
		return false;
	}

	for( i = 0; i < ArrayCount(TargetableTypes); i++ )
	{
		if( A.IsA( TargetableTypes[i] ) )
		{
			return true;
		}
	}

	return false;
}
	
/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Returns the target that is in the player's FOV as defined by MaxAngleInDegrees
// that is also the closest to the center of view.
//------------------------------------------------------------------------------
// Loc:					Point of origin.
// ViewRot:				Direction of view.
// MaxAngleInDegrees:	Field of view.
//------------------------------------------------------------------------------
// REQUIRE: MaxAngleInDegrees < 90
//------------------------------------------------------------------------------
function Actor FindBestTarget( vector Loc, rotator ViewRot, float MaxAngleInDegrees, optional AngrealInventory UsingArtifact )
{
	local float		BestRatio;		//best found ratio
	local Actor		BestTarget;		//best target discovered so far
	local vector	Ignored;		//dummy arg
	local vector	ViewVec;		//vector showing LOS Loc/ViewRot
	local Actor		IterA;			//iterator tmp var
	local vector	DirVec;			//direction vector from Loc to current potential target
	local float		DistRatio;		//ratio of the ViewDist divided by the LocDist (Adjacent over the Hypotenuse) - closer to 1.0 means closer to the center.  (Will always be <= 1.0.)
	local int		i;				//Your standard iterator.
	local float		FOVCos;			//Cos of MaxAngleInDegrees
	local float		ViewDist;		//Distance IterA is down ViewRot.
	local float		LocDist;		//Distance IterA is from Loc.

	// Must set ignored type before calling IsTagetable().
	Self.UsingArtifact = UsingArtifact;
	
	// First try a direct trace to the first targetable actor.
	BestTarget = class'Util'.static.TraceRecursive( Self, Ignored, Ignored, Loc, true,, vector(ViewRot) );
	if( BestTarget == None || !IsTargetable( BestTarget ) )
	{
		BestTarget = None;

		FOVCos = class'Util'.static.DCos( MaxAngleInDegrees );

		//GetAxes( ViewRot, ViewVec, Ignored, Ignored );
		ViewVec = vector(ViewRot);

		// NOTE[aleiby]: Use VisibleActors?
		foreach AllActors( class'Actor', IterA )
		{
			if( IsTargetable( IterA ) && class'Util'.static.PawnCanSeeActor( Pawn(Owner), IterA, FOVCos ) )
			{
				// Find closest to center of screen.
				ViewDist = ((IterA.Location - Loc) << ViewRot).X;	// Distance down the ViewRot.
				LocDist = VSize( IterA.Location - Loc );			// Distance from Loc.
				DistRatio = ViewDist / LocDist;
				if( BestTarget == None || DistRatio > BestRatio ) 
				{
					BestTarget = IterA;
					BestRatio = DistRatio;
				}
			}
		}
    }

	return BestTarget;
}

defaultproperties
{
     TargetableTypes(0)=WOTPawn
     TargetableTypes(1)=WOTPlayer
     TargetableTypes(2)=AngrealIllusionProjectile
     TargetableTypes(3)=MashadarTrailer
     TargetableTypes(4)=LegionProjectile
     bRemovable=False
     bDisplayIcon=False
}
