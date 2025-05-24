//------------------------------------------------------------------------------
// ReflectorIterator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Used to safely iterate across a (WOTPlayer or WOTPawn)'s 
//				current set of reflectors.
//------------------------------------------------------------------------------
// How to use this class:
//
//	local Reflector R;
//	local ReflectorIterator IterR;
//
//	IterR = new()class'ReflectorIterator';
//  IterR.SetReflectorOwner( [Reflectors' Owner here] );
//	for( IterR.First(); !IterR.IsDone(); IterR.Next() )
//	{
//		R = IterR.GetCurrent();
//
//		[Access/Modification code here]
//	}
//  IterR.Reset();
//	IterR.Delete();
//	IterR = None;
//
//------------------------------------------------------------------------------
// Author's notes:
//
// I wish I could use a foreach loop like:
//
//	local Reflector R;
//
//	foreach AllReflectors( R, [Reflectors' Owner here] )
//	{
//		[Access/Modification code here]
//	}
//
// ...but unfortunately I cannot because Unreal's single inheritance class
// hierarchy would force too much coupling on the situation.
//------------------------------------------------------------------------------
class ReflectorIterator expands LegendObjectComponent;

var Reflector Reflectors[32];
var int Index;

var Pawn ReflectorOwner;

//------------------------------------------------------------------------------
// Alternate use of this class (faster):
//
//	local Reflector R;
//	local ReflectorIterator IterR;
//
//	IterR = class'ReflectorIterator'.static.GetIteratorFor( [Reflectors' Owner here] );
//	for( IterR.First(); !IterR.IsDone(); IterR.Next() )
//	{
//		R = IterR.GetCurrent();
//
//		[Access/Modification code here]
//	}
//  IterR.Reset();
//	IterR = None;
//
// Note: Because these are Singletons, it is not safe to re-enter this function.  
// IOW, don't call this function again (anywhere in the thread of exection) 
// until it returns.  If you need to, use the above implementation new()ing 
// it yourself.
//------------------------------------------------------------------------------
static function ReflectorIterator GetIteratorFor( Pawn RefOwner )
{
	local ReflectorIterator IterR;

	// Function requires a valid RefOwner.
	assert(RefOwner!=None);
	
	IterR = ReflectorIterator( class'Singleton'.static.GetInstance( RefOwner.XLevel, class'ReflectorIterator' ) );
	if( IterR != None )
	{
		IterR.Reset();
		IterR.SetReflectorOwner( RefOwner );
	}
	else
	{
		warn( "Could not retrieve an iterator." );
		assert(false);
	}

	return IterR;
}

//------------------------------------------------------------------------------
simulated function SetReflectorOwner( Pawn RefOwner )
{
	ReflectorOwner = RefOwner;
}

//------------------------------------------------------------------------------
// Throws all of our ReflectorOwner's Reflectors into an array so we can safely 
// iterate across them without having to worry about the NextReflector
// pointer getting screwed up in the process of iteration.
//
// By putting them into an array it imposes an artificial limit to the number
// of Reflectors that any pawn may have.  Most likely the only time this limit 
// will be breached is when the linked list of Reflector pointers accidently 
// creates an circular link.  Using an array, we should be able to capture this 
// exception.
//------------------------------------------------------------------------------
simulated function First()
{
	local int i;
	local Reflector R;

	if( WOTPlayer(ReflectorOwner) != None )
	{
		R = WOTPlayer(ReflectorOwner).CurrentReflector;
	}
	else if( WOTPawn(ReflectorOwner) != None )
	{
		R = WOTPawn(ReflectorOwner).CurrentReflector;
	}

	while( R != None )
	{
		if( i >= ArrayCount(Reflectors) )
		{
			warn( "Reflectors array overflow!!!  Please increase size." );
			break;
		}

		Reflectors[i++] = R;

		R = R.NextReflector;
	}

	Index = 0;
}

//------------------------------------------------------------------------------
simulated function bool IsDone()
{
	return (Index >= ArrayCount(Reflectors) || Reflectors[Index] == None);
}

//------------------------------------------------------------------------------
simulated function Next()
{
	Index++;
}

//------------------------------------------------------------------------------
simulated function Reflector GetCurrent()
{
	return Reflectors[Index];
}

//------------------------------------------------------------------------------
simulated function Destructed()
{
	CheckPointers();
	Super.Destructed();
}

//------------------------------------------------------------------------------
// Make sure we weren't abused.
// (IOW: Make sure the last thing to use us called Reset when they were done.)
//------------------------------------------------------------------------------
simulated function CheckPointers()
{
	local int i;

	for( i = 0; i < ArrayCount(Reflectors); i++ )
	{
		if( Reflectors[i] != None )
		{
			warn( "Not properly Reset." );
			assert(false);
		}
	}

	if( ReflectorOwner != None )
	{
		warn( "Not properly Reset." );
		assert(false);
	}
}

//------------------------------------------------------------------------------
// Must be called when user is done with us.
//------------------------------------------------------------------------------
simulated function Reset()
{
	local int i;

	for( i = 0; i < ArrayCount(Reflectors); i++ )
	{
		Reflectors[i] = None;
	}

	ReflectorOwner = None;
	
	Index = 0;
}

defaultproperties
{
}
