//=============================================================================
// TrapBlocker.uc
// $Author: Mpoesch $
// $Date: 10/06/99 7:04p $
// $Revision: 4 $
//=============================================================================
class TrapBlocker expands Keypoint;

// Called after PostBeginPlay.
//
simulated event SetInitialState()
{
	//do nothing -- Actor handling disrupts PostBeginPlay state change
}

function bool RemoveResource()
{
    assert( false );
}

function SetBlocking( bool bCollide, bool bBlock, bool bDamage, float MyCollisionRadius, float MyCollisionHeight )
{
	if( MyCollisionRadius >= 0.0 && MyCollisionHeight >= 0.0 ) // pass in -1 to prevent call
		SetCollisionSize( MyCollisionRadius, MyCollisionHeight );

	SetCollision( bCollide, bBlock, bBlock );

	if( bDamage )
	{
		GotoState( 'CanDamage' );
	}
	else
	{
		GotoState( 'NoDamage' );
	}
}

state NoDamage
{
	function Touch( actor Other )
	{
		if( Owner != None )
		{
			Owner.Touch( Other );
		}
	}

	function Bump( actor Other )
	{
		Touch( Other );
	}
}

state CanDamage
{
	function Touch( actor Other )
	{
		if( Trap(Owner) != None )
		{
			Trap(Owner).DamageActor( Other );
		}
	}

	function Bump( actor Other )
	{
		Touch( Other );
	}
}

defaultproperties
{
     bStatic=False
     bCollideActors=True
}
