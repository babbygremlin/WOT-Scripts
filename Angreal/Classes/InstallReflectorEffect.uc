//------------------------------------------------------------------------------
// InstallReflectorEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	Installs reflectors on pawns, duh!
//------------------------------------------------------------------------------
// How to use this class:
//
// + Create it.
// + Initialize it with a reflector class.
// + Set the Victim it is to be installed in.
// + Hand it off to the Victim for processing via ProcessEffect().
//------------------------------------------------------------------------------
class InstallReflectorEffect expands SingleVictimEffect;

var class<Reflector> ReflectorClass;

var float Duration;		// Used to set the lifespan of the reflector.

//------------------------------------------------------------------------------
// Sets the type of reflector that will be installed.
// and how long it will last.  Dur==0 means it won't remove itself.
//------------------------------------------------------------------------------
function Initialize( class<Reflector> RefClass, optional float Dur )
{
	ReflectorClass = RefClass;
	bDeleterious = RefClass.default.bDeleterious;
	Duration = Dur;
}

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	ReflectorClass = None;
	Duration = 0.0;
}

//------------------------------------------------------------------------------
// Installs a reflector in our victim.
//------------------------------------------------------------------------------
function Invoke()
{
	local Reflector Ref;

	if( Victim != None && ReflectorClass != None )
	{
		Ref = Spawn( ReflectorClass,, Tag );
		Ref.InitializeWithInvokable( Self );
		Ref.bFromProjectile = (SourceProjectile != None);
		Ref.LifeSpan = Duration;
		Ref.Install( Victim );
	}
}

//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local InstallReflectorEffect NewInvokable;

	NewInvokable = InstallReflectorEffect(Super.Duplicate());

	NewInvokable.ReflectorClass	= ReflectorClass;
	NewInvokable.bDeleterious	= bDeleterious;
	NewInvokable.Duration		= Duration;
	
	return NewInvokable;
}
	

defaultproperties
{
}
