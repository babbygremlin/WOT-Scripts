//------------------------------------------------------------------------------
// DestroyOnDestroyLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Destroys the given actor when it is destroyed itself.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class DestroyOnDestroyLeech expands Leech;

var Actor DestroyActor;

//------------------------------------------------------------------------------
function SetDestroyActor( Actor A )
{
	DestroyActor = A;
}

//------------------------------------------------------------------------------
function Destroyed()
{
	if( DestroyActor != None )
	{
		DestroyActor.Destroy();
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
// Make sure our destroy actor still exists.
//------------------------------------------------------------------------------
function AffectHost( optional int Iterations )
{
	if( DestroyActor == None )
	{
		Unattach();
		Destroy();
	}
}

defaultproperties
{
    AffectResolution=1.00
    bDeleterious=True
}
