//=============================================================================
// Streak.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

//------------------------------------------------------------------------------
// Description:	Base class for all continuous streams of segments connecting
//				two endpoints via pathnodes.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn it.
// + Set the type of segment to use (mesh and distance between consecutive origins).
// + Set the endpoints for where the streak will be drawn from/to (as needed).
// + Use bHidden to turn on and off.
//------------------------------------------------------------------------------
// How this class works:
//
// + An underlying RenderIterator lines up the given meshes to connect the start
//   and end points using the path node network as a guide to navigate around 
//   the world.
// + A straight line will be used to connect the two points when possible.
// + Segments are created as needed and reused.  This keeps us from constantly
//   allocating and deallocating excess memory.
//------------------------------------------------------------------------------

class Streak expands Actor
	intrinsic;

//////////////////////
// Member variables //
//////////////////////

// Note: Segments used to create this streak are composed of multiple 
// copies of this object as it would normally be drawn.

// The length of the segment.
var() float SegmentLength;

// Endpoints of streak.
var() vector Start;
var() vector End;

var() Actor StartActor;
var() Actor EndActor;

// If set, a texture will be randomly chosen from 
// the list and used as the skin.
var() bool bRandomizeTextures;
var() Texture Textures[32];
var() int NumTextures;

// This is updated by the RenderIterator to represent the total
// length of the last streak drawn.
var float CurrentLength;

// Set to true if you want the individual segments to act as though they have
// the AlwaysFaceRI on them.
var() bool bAlwaysFace;

/*
replication
{
	reliable if( Role==ROLE_Authority )
		StartActor, EndActor;
}
*/

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
// Used to set what type of segments to use.
//------------------------------------------------------------------------------
simulated function SetSegmentType( Mesh SegmentMesh, float SegmentLength )
{
	Mesh = SegmentMesh;
	self.SegmentLength = SegmentLength;
}

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
	self.StartActor = StartActor;
	self.EndActor = EndActor;
}

//------------------------------------------------------------------------------
// Draws segments between the two points, and returns the point it actually 
// stopped drawing at.
//
// Note: This is function is Depricated.
//------------------------------------------------------------------------------
simulated function vector ConnectPoints( vector P1, vector P2 )
{
	Start = P1;
	End = P2;
	return P2;
}

defaultproperties
{
     RemoteRole=ROLE_None
     bMustFace=False
     bAlwaysRelevant=True
     RenderIteratorClass=Class'Legend.StreakRI'
}
