//=============================================================================
// IKTrailer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

// -- IKTrailer --
// Defines the characteristics of an object that examplifies inverse
// kinemetics.  Subclass this class to define the specific mesh to use.
// This class should _not_ be instantiated.  Instead create or use a subclass
// of this that inherits the IK charateristics.

class IKTrailer expands Actor 
//	abstract
	intrinsic;

var() float MaxAngleExt;	// How far the joints can bend. (in degrees)
var() float MinAngleExt;	// How far the joints can bend. (in degrees)
var   float AngleExt;

var() float dist;			// Distance between two joints.

var() bool bMaster;			// The first IKTrailer in the list should be the master.
var() name HeadTag;			// The tag of the Actor to follow (only applicable for the 
							// master IKTrailer).
var Actor HeadActor;		// Pointer to the Actor we are following.
var vector LastHALocation;	// Used to monitor changes.
var rotator LastHARotation;	// Used to monitor changes.

var() bool bAutoLink;		// Should we try to link up via tags at startup?

var() name ChildTag;		// The tag of the next IKTrailer in the list.  The last 
							// IKTrailer's ChildTag should be 'EOL' for End Of List.
var IKTrailer ChildTrailer;	// Pointer to the next IKTrailer in the list.

const UnrealDegreesFactor = 182.044444;

replication
{
	reliable if( Role==ROLE_Authority )
		AngleExt, Dist, ChildTrailer;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
    Super.PreBeginPlay();
	AngleExt = RandRange( MinAngleExt, MaxAngleExt );
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
    Super.Tick( DeltaTime );

	if( bAutoLink )
	{
		// Find the links and connect the chain (via tags).
		AutoLink();

		// Only auto-link once.
		bAutoLink = false;
	}

	// Only reposition if needed.
    if( HeadActor != None )
    {
		if( HeadActor.Location != LastHALocation || HeadActor.Rotation != LastHARotation )
		{
			LastHALocation = HeadActor.Location;
			LastHARotation = HeadActor.Rotation;

			Reposition( HeadActor );
		}
    }
	else if( bMaster )
	{
		// If we lost our head actor and we are the master, then 
		// something's very wrong.  We better notify someone
		// in case they want to handle this situation.
		NotifyLostHeadActor();
	}
}

//------------------------------------------------------------------------------
native(1020) final function Reposition( Actor Parent );
/* - Moved to C++
{
    AngleExtents2( Parent );
    
	if( ChildTrailer != None )	// To break infinite recursion.
	{
		ChildTrailer.Reposition( Self );
	}
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
simulated function AngleExtents2( Actor Parent )
{
    local rotator DeltaRotation, NormalRotation;
    local vector DeltaVector, NormalVector;
    
    /////////////////////
    // Adjust Location //
    /////////////////////
    DeltaRotation = rotator(Location - Parent.Location);
    
    // Get the inverse of the Parent's rotation.
    NormalVector = vector(Parent.Rotation);
    NormalVector *= -1.0;
    NormalRotation = rotator(NormalVector);
    
    AdjustAngle( DeltaRotation.Pitch, NormalRotation.Pitch );
    AdjustAngle( DeltaRotation.Yaw, NormalRotation.Yaw );
    // Don't worry about the Roll.  It doesn't effect position.
    
    SetLocation( Parent.Location + vector(DeltaRotation) * Dist );
    
    /////////////////////
    // Adjust Rotation //
    /////////////////////
    
	// Face our Parent.
    DeltaRotation = rotator(Parent.Location - Location);
    
    // Adjust the Roll.
    DeltaRotation.Roll = Rotation.Roll;
    AdjustAngle( DeltaRotation.Roll, Parent.Rotation.Roll );
       
    SetRotation( DeltaRotation );
}

//------------------------------------------------------------------------------
// Adjusts the given Angle either positivly or negativly or not at all 
// depending on the Difference between the normal Angle with respect to 
// the AngleExt variable.
//------------------------------------------------------------------------------
// Precondition: The Angle is already within the extents 0 to 65535.
//------------------------------------------------------------------------------
simulated function AdjustAngle( out int DeltaAngle, int NormalAngle );
{
    local int Diff, k;
    local int Ang;
    
    k = 1; 
    
    Diff = DeltaAngle - NormalAngle;

    if( Diff < -32768 )			// -180 degrees
    {
        Diff = 65536 + Diff;	// 360 degrees 
    }
    else if( Diff > 32768 )		// 180 degrees
    {
        Diff = 65536 - Diff;	// 360 degrees
        k = -1;
    }
    else if( Diff < 0 )
    {
        Diff *= -1;
        k = -1;
    }

    // This is where the _real_ check takes place.
    // All previous checks were simply to allow this check to work.
    Ang = AngleExt * UnrealDegreesFactor; // Converts the Angle into rotator units.
    if( Diff > Ang )
	{
        DeltaAngle = NormalAngle + Ang * k;
	}
    
    // Bring back into range. (0 to 360 degrees).
    DeltaAngle = DeltaAngle & 0xFFFF;
}
*/

//------------------------------------------------------------------------------
// Used to automatically link up the chain on start-up via tags.
//------------------------------------------------------------------------------
simulated function AutoLink()
{
	// Find your child;
	if( ChildTag == 'EOL' )
	{
		ChildTrailer = None;

	}
	else
	{ 
		foreach AllActors( class'IKTrailer', ChildTrailer, ChildTag )
		{
			break;	// Use first IKTrailer that has the correct ChildTag.
		}
		if( ChildTrailer == None )
		{
			warn( "No matching IKTrailer with tag: "$ChildTag );
		}
	}

	// Master initialization.
	if( bMaster )
	{
		// Find Parent.
		foreach AllActors( class'Actor', HeadActor, HeadTag )
		{
			break;	// Use the first Actor that matches the given Tag.
		}
		if( HeadActor == None )
		{
			warn( "No matching Actor with tag: "$HeadTag );
		}
	}
}

///////////////////
// Notifications //
///////////////////

//------------------------------------------------------------------------------
// Notification for when we lose our head.
//------------------------------------------------------------------------------
simulated function NotifyLostHeadActor()
{
	// Handle in subclass if desired.
}

defaultproperties
{
     RemoteRole=ROLE_None
     bAlwaysRelevant=True
}
