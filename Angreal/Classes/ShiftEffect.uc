//------------------------------------------------------------------------------
// ShiftEffect.uc
// $Author: Mfox $
// $Date: 1/11/00 2:39p $
// $Revision: 4 $
//
// Description:	Randomly moves the victim to another location within the 
//				given constraints.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Create it.
// + Set the Victim.
// + Hand it off to the Victim for processing via ProcessEffect().
//------------------------------------------------------------------------------
class ShiftEffect expands SingleVictimEffect;

//------------------------------------------------------------------------------
// Regression Tests:
// 
// Setup: Any level that has walls thin enough to shift through.
//        Use ALLAMMO to get enough charges of shift for testing.
//
// Action: Walk up to wall.  Use shift to get to the other side.
// Result: You are on the other side.
//
// Setup: Spawn barrel on one side of wall.  Use GHOST to get to
//        other side.  Use WALK to get back to normal.
//
// Action: Walk up to wall and face the barrel.  Use shift to get
//         to the other side.
// Result: Shift fails because it won't let you telefrag the barrel.
//
// Setup: Two clients on a dedicated server.  Type ENABLEADMIN
//        and ALLANGREAL 1 to get enough charges to perform tests.
//
// Action: Player A fires a seeker at Player B.  Player B moves around to
//         make sure seeker is tracking him/her.  Player B then uses shift.
// Result: Seeker loses its target.  Player B moves around to make sure it 
//         is no longer tracking him/her.
//
// Action: Player A fires decay at Player B.  Let decay hit other Player B.  
//         Player B uses shift.
// Result: Player B should still be decaying.
//
// Action: Player A locks onto you with lightning.  Player B gets out of 
//         lightning's lock-on range (lightning is still hurting Player B).  
//         Player B uses shift.
// Result: Player B is free of the lightning.
//
// Action: Player A lifts Player B into the air with whirlwind.  Player B uses
//         shift.
// Result: Player B is free of whirlwind and falls from whatever height they are
//         at.  Player A stops casting because they've lost their victim.
//
// Action: Test at least some of the above with the player walking (shift key
//         held down). At one point shifting up while walking would leave the
//         player floating. Should test in water too.
//------------------------------------------------------------------------------

/* -- OLD
var() int MaxDistance;
var() int MinDistance;
var() int MaxTries;		// The maximum number of tries before we fail.
*/

var() float ActorFitsRadius;
var() float ShiftDistance;
var bool bSuccess;

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	ShiftDistance = default.ShiftDistance;
	bSuccess = false;
}

//------------------------------------------------------------------------------
// Move the Victim someplace else.
//------------------------------------------------------------------------------
function Invoke()
{
/* -- OLD
	local int Dist;			// Random distance to move.
	local vector Offset;	// An offset from our current position.
	local int i;			// Your standard, run-of-the-mill iterator.
*/

	local rotator Direction;
	local vector Destination;

	local SeekingProjectile SProj;	// An iterator for seeking projectiles.

	local LeechIterator IterL;
	local Leech L;

	local ReflectorIterator IterR;
	local Reflector R;

	local AppearEffect AE;

/* -- OLD
	// Create a nice random, normal, slightly restricted vector.
	Offset.x = (FRand() * 2.0) - 1;		// Random number (-1 ... +1)
    Offset.y = (FRand() * 2.0) - 1;		// Random number (-1 ... +1)
	Offset.z = (FRand() * 0.5);			// Restrict Z to +45 degrees above the XY plane.

	// Pick a random distance between MinDistance and MaxDistance.
	Dist = MinDistance + (FRand() * (MaxDistance - MinDistance));

	// Try a whole bunch of times until we succeed at finding an open spot.
	while( i++ < MaxTries && !Victim.SetLocation( Victim.Location + Offset * Dist ) )
	{
		// Create a nice random, normal, slightly restricted vector.
		Offset.x = (FRand() * 2.0) - 1;		// Random number (-1 ... +1)
		Offset.y = (FRand() * 2.0) - 1;		// Random number (-1 ... +1)
		Offset.z = (FRand() * 0.5);			// Restrict Z to +45 degrees above the XY plane.

		// Pick a random distance between MinDistance and MaxDistance.
		Dist = MinDistance + (FRand() * (MaxDistance - MinDistance));
	}
*/

	bSuccess = false;

	if( Victim != None )
	{
		Direction = Victim.ViewRotation;
	}
	else
	{
		Direction = Victim.Rotation;
	}

	Destination = Victim.Location + ((vect(1,0,0) * ShiftDistance) >> Direction);

	if( class'Util'.static.ActorFits( Victim, Destination, ActorFitsRadius ) )
	{
		bSuccess = Victim.SetLocation( Destination );
	}
	
	if( bSuccess )
	{
		// Lose any seeking projectiles.
		foreach AllActors( class'SeekingProjectile', SProj )
		{
			if( SProj.Destination == Victim )
			{
				SProj.SetDestination( None );
			}
		}

		class'WOTUtil'.static.ShiftOutOfLeechesAndReflectors( Victim );

		// Do cool visual effect.
		AE = Spawn( class'AppearEffect' );
		AE.bFadeIn = false;
		AE.SetColors( 'Blue', 'Gold' );
		AE.SetAppearActor( Victim );

		if( !Victim.Region.Zone.bWaterZone )
		{
			// for some reason if player is walking this doesn't happen automatically
			Victim.SetPhysics( PHYS_Falling );
		}
	}
}
	
//------------------------------------------------------------------------------
function bool LastShiftSucceeded()
{
	return bSuccess;
}

//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local ShiftEffect NewInvokable;

	NewInvokable = ShiftEffect(Super.Duplicate());

	NewInvokable.ShiftDistance	= ShiftDistance;
	NewInvokable.bSuccess		= bSuccess;
		
	return NewInvokable;
}	

defaultproperties
{
    ActorFitsRadius=1024.00
    ShiftDistance=160.00
}
