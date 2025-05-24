//=============================================================================
// BubbleSpawner.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class BubbleSpawner expands Effects;

//=============================================================================
// Spawns bubbles. Can spawn groups of 1 or more bubbles with a mechanism for
// controlling the number of bubbles to spawn and the time between groups of
// bubbles and between each bubble. Can be active initially, or as the result
// of a trigger.
//
// These are spawned using the BubbleSpawner's location and rotation by default.
// If the Owner is set, bubbles are spawned relative to the Owner's "mouth" and 
// using the Owner's rotation if the Owner is a Pawn, otherwise the Owner's 
// location and rotation are used as is.
//
// Defaults are set up so class spawns nice bubbles for pawn hit underwater.

var() int		MinBubbles;			// min # bubbles to spawn
var() int		MaxBubbles;			// max # bubbles to spawn
var() float     OffsetMinX;			// shift final X (along rotation axis) coordinate - this value
var() float     OffsetMaxX;			// shift final X (along rotation axis) coordinate + this value
var() float     OffsetMinY;			// shift final Y (perpendicular to rotation axis) coordinate - this value
var() float     OffsetMaxY;			// shift final Y (along rotation axis) coordinate + this value
var() float     OffsetMinZ;			// shift final Z coordinate - this value
var() float     OffsetMaxZ;			// shift final Z coordinate + this value
var() bool		bTrigger;			// if set, bubbles spawned on trigger, otherwise spawned on creation
var() bool		bContinuous;		// once started, keep spawning bubbles forever
var() float		TimeBetweenGroups;	// time delay between spawning groups of bubbles
var() float		TimeBetweenBubbles;	// time delay between spawning each bubble
var() bool 		bDestroy;			// whether to destroy BubbleSpawner when first group of bubbles spawned

var private vector BaseLocation;
var private Rotator BaseRotation;
var private float NextGroupTime;
var private float NextBubbleTime;
var private int BubbleIndex;
var private int	NumBubbles;

//=============================================================================

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if( bTrigger )
	{
		// trigger will enable tick
		Disable( 'Tick' );
	}
	
	// set up base location
	SetupSpawnBubbles();
}

//=============================================================================

function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( Level.TimeSeconds > NextGroupTime )
	{
		// currently spawning a group of bubbles
		if( Level.TimeSeconds > NextBubbleTime )
		{	
			if( BubbleIndex == 0 )
			{
				NumBubbles = MinBubbles + Rand( MaxBubbles-MinBubbles+1 );
			}
			
			// spawn a bubble
			SpawnBubble();
		
			// delay before spawning next bubble
			NextBubbleTime = Level.TimeSeconds + TimeBetweenBubbles;
		
			BubbleIndex++;
			if( BubbleIndex == NumBubbles )
			{
				// done spawning group of bubbles
				BubbleIndex = 0;
			
				NextGroupTime = Level.TimeSeconds + TimeBetweenGroups;
			
				if( !bContinuous )
				{
					Disable( 'Tick' );
				}
			
				if( bDestroy )
				{
					Destroy();
				}
			}
		}
	}
}

//=============================================================================

function SetupSpawnBubbles()
{
	if( Pawn(Owner) != None )
	{
		// spawn bubbles relative to Pawn's mouth (exact location is a guess)
		BaseLocation = Owner.Location + Owner.CollisionRadius*vector(Owner.Rotation) + Pawn(Owner).EyeHeight * vect(0,0,1);
		BaseRotation = Owner.Rotation;
	}
	else if( Owner != None )
	{
		// spawn bubbles relative to Owner's location, rotation
		BaseLocation = Owner.Location;
		BaseRotation = Owner.Rotation;
	}
	else
	{
		// spawn bubbles relative to location, rotation
		BaseLocation = Location;
		BaseRotation = Rotation;
	}
}

//=============================================================================

function SpawnBubble()
{
	local vector SpawnLocation;
	local vector XVector, YVector;
	local WOTBubble Bubble;

	// x "axis" is along rotation
	XVector = Normal(vector(BaseRotation));
	XVector.Z = 0;

	// y "axis" is perpendicular to x "axis"
	YVector = class'util'.static.PerpendicularXY( XVector );

	SpawnLocation = BaseLocation + RandRange(OffsetMinX, OffsetMaxX)*XVector + RandRange(OffsetMinY, OffsetMaxY)*YVector + RandRange(OffsetMinZ, OffsetMaxZ)*vect(0,0,1);
		
	Bubble = Spawn( class'WOTBubble',,, SpawnLocation );

	if( Bubble != None )
	{
		Bubble.DrawScale = FRand()*0.08+0.03; 
	}
}

//=============================================================================

function Trigger( actor Other, pawn EventInstigator )
{
	Enable( 'Tick' );
}

//=============================================================================

defaultproperties
{
     MinBubbles=1
     MaxBubbles=8
     OffsetMaxX=5.000000
     OffsetMinY=-5.000000
     OffsetMaxY=5.000000
     OffsetMinZ=-5.000000
     OffsetMaxZ=10.000000
     TimeBetweenGroups=5.000000
     TimeBetweenBubbles=0.100000
     bDestroy=True
     bHidden=True
     bDirectional=True
}
