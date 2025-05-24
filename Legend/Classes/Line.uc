//=============================================================================
// Line.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

//------------------------------------------------------------------------------
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
// How this class works:
//------------------------------------------------------------------------------

class Line expands Actor
	intrinsic;

//////////////////////
// Member variables //
//////////////////////

// Note: Segments used to create this streak are composed of multiple 
// copies of this object as it would normally be drawn.

// The length of the segment.
var() float SegmentLength;

// Do we want the SegmentLength scaled by the particle density?
var() bool bParticleDensityScaled;

// Endpoints of streak.
var() vector Start;
var() vector End;

var() Actor StartActor;
var() Actor EndActor;

// Alternate Texture Methods?
//  + Cascading
//  + Random

// This is updated by the RenderIterator to represent the total
// length of the last streak drawn.
var float CurrentLength;

replication
{
	reliable if( Role==ROLE_Authority )
		Start, End;

	reliable if( Role==ROLE_Authority )
		StartActor, EndActor;
}

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
// Used to set the points to draw the streak to/from.
// This will also cause the streak to redraw itself.
//------------------------------------------------------------------------------
simulated function SetEndpoints( vector StartPoint, vector EndPoint )
{
	Start = StartPoint;
	End = EndPoint;
}

//------------------------------------------------------------------------------
// Use this to set the actors that the streak will continuously connect.
//------------------------------------------------------------------------------
simulated function SetFollowActors( Actor StartActor, Actor EndActor )
{
	Self.StartActor = StartActor;
	Self.EndActor = EndActor;
}

defaultproperties
{
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
     Style=STY_Translucent
     bMustFace=False
     bAlwaysRelevant=True
     RenderIteratorClass=Class'Legend.LineRI'
}
