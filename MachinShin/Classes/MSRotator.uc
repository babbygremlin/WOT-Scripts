//------------------------------------------------------------------------------
// MSRotator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class MSRotator expands ActorRotator;

var Actor Subject;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	Subject = Owner;
	Subject.AttachDestroyObserver( Self );
}

//------------------------------------------------------------------------------
simulated function SubjectDestroyed( Object Subject )
{
	if( Subject == Self.Subject )
	{
		Destroy();
	}

	Super.SubjectDestroyed( Subject );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	Subject.DetachDestroyObserver( Self );
	Super.Destroyed();
}

defaultproperties
{
     ActorRotatorClass=Class'MachinShin.MSRotator'
     Physics=PHYS_Trailer
     RemoteRole=ROLE_None
}
