//------------------------------------------------------------------------------
// AttachLeechEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	Attaches Leeches to pawns, duh!
//------------------------------------------------------------------------------
// How to use this class:
//
// + Create it.
// + Initialize it with a leech class.
// + Set the Victim it is to be attached to.
// + Hand it off to the Victim for processing via ProcessEffect().
//------------------------------------------------------------------------------
class AttachLeechEffect expands SingleVictimEffect;

// Type of leech to attach.
var class<Leech> LeechClass;

// Leech to attach if set.
var Leech PreInitializedLeech;

// The tag to give our leeches.
var name LeechTag;

// Used to set the lifespan of the Leech.
var float Duration;

//------------------------------------------------------------------------------
// Sets the type of leech that will be attached.
// and how long it will last.  Dur==0 means it won't detach itself.
//------------------------------------------------------------------------------
function Initialize( class<Leech> LClass, optional float Dur )
{
	LeechClass = LClass;
	bDeleterious = LClass.default.bDeleterious;
	Duration = Dur;
}

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	LeechClass = default.LeechClass;
	PreInitializedLeech = default.PreInitializedLeech;
	LeechTag = '';
	Duration = 0.0;
}

//------------------------------------------------------------------------------
// Used to assign what tags to assign to new leeches.
//------------------------------------------------------------------------------
function SetLeechTag( name NewTag )
{
	LeechTag = NewTag;
}

//------------------------------------------------------------------------------
// If you want to use a preinitialized leech, set it with this function.
//------------------------------------------------------------------------------
function SetLeech( Leech L )
{
	PreInitializedLeech = L;
	bDeleterious = L.bDeleterious;
}

//------------------------------------------------------------------------------
// Attaches a leech to our victim.
//------------------------------------------------------------------------------
function Invoke()
{
	local Leech L;

	if( Victim != None )
	{
		if( PreInitializedLeech != None )
		{
			L = PreInitializedLeech;
		}
		else if( LeechClass != None )
		{
			L = Spawn( LeechClass,, LeechTag );
			if( Duration > 0.0 )
			{
				L.Lifespan = Duration;
			}
			L.InitializeWithInvokable( Self );
		}
		else
		{
			warn( "Failed because neither PreInitializedLeech nor LeechClass were set." );
		}
		L.bFromProjectile = (SourceProjectile != None);
		L.AttachTo( Victim );
	}
	else
	{
		warn( "Failed because Victim was not set." );
	}
}
	
//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local AttachLeechEffect NewInvokable;

	NewInvokable = AttachLeechEffect(Super.Duplicate());

	NewInvokable.LeechClass				= LeechClass;
	NewInvokable.PreInitializedLeech	= PreInitializedLeech;
	NewInvokable.bDeleterious			= bDeleterious;
	NewInvokable.LeechTag				= LeechTag;
	NewInvokable.Duration				= Duration;
	
	return NewInvokable;
}

defaultproperties
{
}
