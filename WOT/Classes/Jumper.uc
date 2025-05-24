//=============================================================================
// Jumper.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================
class Jumper expands Triggers;

// Creatures will jump on hitting this trigger in direction specified

var() bool bOnceOnly;
var() class<Pawn> LimitedToClass;
var Pawn Pending;
var() float JumpZ;

function Timer()
{
	Pending.SetPhysics( PHYS_Falling );
	Pending.Velocity = Pending.GroundSpeed * Vector(Rotation);
	if( JumpZ != 0 )
		Pending.Velocity.Z = JumpZ;
	else
		Pending.Velocity.Z = FMax( 100, Pending.JumpZ );
	Pending.DesiredRotation = Rotation;
	Pending.bJumpOffPawn = true;
}

function Touch( Actor Other )
{
	if( Other.IsA( 'Pawn' ) &&
			( ( LimitedToClass == None ) ||
			ClassIsChildOf( Other.Class, LimitedToClass ) ) )
	{
		Pending = Pawn( Other );
		SetTimer( 0.01, false );
		if( bOnceOnly )
		{
			Disable( 'Touch' );
		}
	}
}

defaultproperties
{
     bDirectional=True
}
