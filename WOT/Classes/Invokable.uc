//------------------------------------------------------------------------------
// Invokable.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//
// Description:	Provides an interface for all Invokable effects.  Invokable
//				effects are essentially algorithms that change the state of a 
//				player or a pawn.  
//------------------------------------------------------------------------------
// How to use this class:
//
// + Subclass this class for all effects.  
// + Fill in the invoke function as described below.  
// + Include any accessor functions needed.  
// + If you are actually going to fill in the Invoke command in an immediate
//   subclass of this class, you may want to check to make sure you 
//   shouldn't be subclassing another subclass of effect that defines the
//   initialization interface.
// + Don't forget to set the SourceAngreal after spawning one of these 
//   suckers (and SourceProjectile where applicable).
//------------------------------------------------------------------------------
class Invokable expands LegendActorComponent abstract;
//	native
//	abstract;

var AngrealInventory SourceAngreal;		// The angreal that caused this Invokable effect.
var AngrealProjectile SourceProjectile;	// The projectile that created us - if one indeed did.
var class<AngrealProjectile> SourceProjClass;

var bool bDeleterious;					// Is this effect good or bad?

replication
{
	// NOTE[aleiby]: Is all this really needed anymore?
	reliable if( Role==ROLE_Authority )
		SourceAngreal, SourceProjectile, SourceProjClass;
}

//------------------------------------------------------------------------------
// Retrieves the single instance of this class.
//
// + Helper is used to spawn the Instance if needed.
// (Self works in most cases - it just needs to have a valid level.)
//
// + Type is the type of Invokable we are looking for.
//------------------------------------------------------------------------------
//native(1050) static final function Invokable GetInstance( Actor Helper, class<Invokable> Type );
static function Invokable GetInstance( Actor Helper, class<Invokable> Type )
{
	local Invokable I;

	// Catch bad input.
	if( Helper == None || Helper.XLevel == None )
	{
		warn( "Invalid helper class: ("$Helper$")" );
		return None;
	}

	I = Invokable( class'Singleton'.static.GetInstance( Helper.XLevel, Type ) );

	if( I != None )
	{
		I.Reset();
	}
	else
	{
		warn( "Singleton::GetInstance() failed to return a valid Invokable." );
	}

	return I;
}

//------------------------------------------------------------------------------
// Make sure you override this in subclasses to reset added variables.
//------------------------------------------------------------------------------
//event Reset()
function Reset()
{
	SourceAngreal = None;
	SourceProjectile = None;
	bDeleterious = default.bDeleterious;
	Instigator = None;
}

//------------------------------------------------------------------------------
function Invoke()
{
	// This is the function that you will need to override in your
	// subclasses.  This provides a trigger for the effect.
	// The main idea is to set up an effect with whatever helper functions
	// you need, and then override this function so that the effect takes
	// place.  Essentially you can think of an effect like a gun.  You
	// load it with ammo and cock it using custom functions, and then you 
	// use this function to pull the trigger.  All the client needs to know
	// is that this is an effect, and that it has a trigger that it needs
	// to pull in order to have the effect take action.  If the effect
	// hasn't been properly configured, then it misfires, but the client
	// doesn't have to worry about any of that.
}

//------------------------------------------------------------------------------
// This function must be called when an Invokable effect is created.
//------------------------------------------------------------------------------
function SetSourceAngreal( AngrealInventory Source )
{
	SourceAngreal = Source;
	
	if( SourceAngreal != None )
	{
		Instigator = Pawn(SourceAngreal.Owner);
	}
}

//------------------------------------------------------------------------------
// This function must be called when an Invokable effect is created.
//------------------------------------------------------------------------------
function SetSourceProjectile( AngrealProjectile Source )
{
	SourceProjectile = Source;
	
	if( SourceProjectile != None )
	{
		SourceProjClass = SourceProjectile.Class;
	}
	else
	{
		SourceProjClass = None;
	}
}

//------------------------------------------------------------------------------
function InitializeWithLeech( Leech Source )
{
	SourceAngreal		= Source.SourceAngreal;
	SourceProjectile	= Source.SourceProjectile;
	SourceProjClass		= Source.SourceProjClass;
	Instigator			= Source.Instigator;
}
	
//------------------------------------------------------------------------------
function InitializeWithReflector( Reflector Source )
{
	SourceAngreal		= Source.SourceAngreal;
	SourceProjectile	= Source.SourceProjectile;
	SourceProjClass		= Source.SourceProjClass;
	Instigator			= Source.Instigator;
}
	
//------------------------------------------------------------------------------
function InitializeWithInvokable( Invokable Source )
{
	SourceAngreal		= Source.SourceAngreal;
	SourceProjectile	= Source.SourceProjectile;
	SourceProjClass		= Source.SourceProjClass;
	Instigator			= Source.Instigator;
}
	
//------------------------------------------------------------------------------
function InitializeWithProjectile( AngrealProjectile Source )
{
	SourceAngreal		= Source.SourceAngreal;
	SourceProjectile	= Source;
	SourceProjClass		= Source.Class;
	Instigator			= Source.Instigator;
}
	
//------------------------------------------------------------------------------
// Your basic copy constructor.
//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local Invokable NewInvokable;

	NewInvokable = Spawn( Class, Owner, Tag, Location, Rotation );

	NewInvokable.SourceAngreal		= SourceAngreal;
	NewInvokable.SourceProjectile	= SourceProjectile;
	NewInvokable.bDeleterious		= bDeleterious;

	return NewInvokable;
}

defaultproperties
{
}
