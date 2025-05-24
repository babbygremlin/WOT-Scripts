//------------------------------------------------------------------------------
// LeechIterator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Used to safely iterate across the Leeches attached to the
//				specified WOTPlayer or WOTPawn. 
//------------------------------------------------------------------------------
// How to use this class:
//
//	local Leech L;
//	local LeechIterator IterL;
//
//	IterL = new()class'LeechIterator';
//  IterL.SetReflectorOwner( [Leeches' Owner here] );
//	for( IterL.First(); !IterL.IsDone(); IterL.Next() )
//	{
//		L = IterL.GetCurrent();
//
//		[Access/Modification code here]
//	}
//  IterL.Reset();
//	IterL.Delete();
//	IterL = None;
//
//------------------------------------------------------------------------------
// Author's notes:
//
// I wish I could use a foreach loop like:
//
//	local Leech L;
//
//	foreach AllLeeches( L, [Leeches' Owner here] )
//	{
//		[Access/Modification code here]
//	}
//
// ...but unfortunately I cannot because Unreal's single inheritance class
// hierarchy would force too much coupling on the situation.
//------------------------------------------------------------------------------
class LeechIterator expands LegendObjectComponent;

var Leech Leeches[32];
var int Index;

var Pawn LeechOwner;

//------------------------------------------------------------------------------
// Alternate use of this class (faster):
//
//	local Leech L;
//	local LeechIterator IterL;
//
//	IterL = class'LeechIterator'.static.GetIteratorFor( [Leeches' Owner here] );
//	for( IterL.First(); !IterL.IsDone(); IterL.Next() )
//	{
//		L = IterL.GetCurrent();
//
//		[Access/Modification code here]
//	}
//  IterL.Reset();
//	IterL = None;
//
// Note: Because these are Singletons, it is not safe to re-enter this function.  
// IOW, don't call this function again (anywhere in the thread of exection) 
// until it returns.  If you need to, use the above implementation new()ing 
// it yourself.
//------------------------------------------------------------------------------
static function LeechIterator GetIteratorFor( Pawn LOwner )
{
	local LeechIterator IterL;

	// Function requires a valid LOwner.
	assert(LOwner!=None);
	
	IterL = LeechIterator( class'Singleton'.static.GetInstance( LOwner.XLevel, class'LeechIterator' ) );
	if( IterL != None )
	{
		IterL.Reset();
		IterL.SetLeechOwner( LOwner );
	}
	else
	{
		warn( "Could not retrieve an iterator." );
		assert(false);
	}

	return IterL;
}

//------------------------------------------------------------------------------
simulated function SetLeechOwner( Pawn LOwner )
{
	LeechOwner = LOwner;
}

//------------------------------------------------------------------------------
// Throws all of our LeechOwner's Leechs into an array so we can safely 
// iterate across them without having to worry about the NextLeech
// pointer getting screwed up in the process of iteration.
//
// By putting them into an array it imposes an artificial limit to the number
// of Leechs that any pawn may have.  Most likely the only time this limit 
// will be breached is when the linked list of Leech pointers accidently 
// creates an circular link.  Using an array, we should be able to capture this 
// exception.
//------------------------------------------------------------------------------
simulated function First()
{
	local int i;
	local Leech L;

	if( WOTPlayer(LeechOwner) != None )
	{
		L = WOTPlayer(LeechOwner).FirstLeech;
	}
	else if( WOTPawn(LeechOwner) != None )
	{
		L = WOTPawn(LeechOwner).FirstLeech;
	}

	while( L != None )
	{
		if( i >= ArrayCount(Leeches) )
		{
			warn( "Leeches array overflow!!!  Please increase size." );
			break;
		}

		Leeches[i++] = L;

		L = L.NextLeech;
	}

	Index = 0;
}

//------------------------------------------------------------------------------
simulated function bool IsDone()
{
	return (Index >= ArrayCount(Leeches) || Leeches[Index] == None);
}

//------------------------------------------------------------------------------
simulated function Next()
{
	Index++;
}

//------------------------------------------------------------------------------
simulated function Leech GetCurrent()
{
	return Leeches[Index];
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

	for( i = 0; i < ArrayCount(Leeches); i++ )
	{
		if( Leeches[i] != None )
		{
			warn( "Not properly Reset." );
			assert(false);
		}
	}

	if( LeechOwner != None )
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

	for( i = 0; i < ArrayCount(Leeches); i++ )
	{
		Leeches[i] = None;
	}

	LeechOwner = None;
	
	Index = 0;
}

defaultproperties
{
}
