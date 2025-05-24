//=============================================================================
// TracerSeg.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

//------------------------------------------------------------------------------
// Description:	Used by TracerStreak.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Subclass.
// + Set Mesh to use as segment.  
//   (Align down the x-axis with the origin at the leftmost end of the mesh.)
// + Set the SegmentLength to represent the length of your segment.
// + Set the subtype (SegmentType) to use, or leave None if you want this 
//   to be the segment that actually gets faded out.
// + Set the FadeTime for those segments whose SegmentType is None (the ones 
//   that will actually be faded out).
//------------------------------------------------------------------------------
// How this class works:
//
// + See TracerStreak
//------------------------------------------------------------------------------

class TracerSeg expands Effects
	abstract;

// NOTE[aleiby]: Collapse TracerStreak and TracerSeg into a single class.

//////////////////////
// Member variables //
//////////////////////

var() class<TracerSeg> SegmentType;
var TracerSeg CurrentSegment;		// Next TracerSet in linked list.
var Actor Parent;					// Parent actor in N-ary tree.
var bool bNotifiedParent;


var() Texture FadedTexture;	// Texture to use when we go Translucent.  (It None, then we use the normal texture.)

// Used by our parent to maintain a linked list.
var TracerSeg NextSegment;

var() float SegmentLength;	// Length of segment -- using CollisionRadius is problematic.
var() float FadeTime;		// How long it takes us to go from default.ScaleGlow to 0.0.
var() float FadeInterval;	// How long before triggering the next segment to fade.
							// (if zero, it waits until we are completely faded.)
							// (FadeInterval is clamped at FadeTime.)

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
simulated function Fade()
{
	if( SegmentType != None )
	{
		GotoState('Orchestrating');
	}
	else
	{
		GotoState('Fading');
	}
}

//------------------------------------------------------------------------------
simulated function FinishedFading();

////////////
// States //
////////////

//------------------------------------------------------------------------------
simulated state Orchestrating
{
	simulated function BeginState()
	{
		local vector Start, End;
		local vector i;
		local vector StreakDirection;
		local rotator StreakRotation;
		local TracerSeg FirstSegment, Seg;

		bHidden = True;

		StreakRotation = Rotation;
		StreakDirection = Normal(vector(StreakRotation));

		Start = Location;
		End = Start + StreakDirection * SegmentLength;

		FirstSegment = None;

		for( i = Start; class'Util'.static.VectorAproxEqual( StreakDirection, Normal(End - i) ); i += StreakDirection * SegmentType.default.SegmentLength )
		{
			if( FirstSegment == None )
			{
				FirstSegment = Spawn( SegmentType,,, i, StreakRotation );
				Seg = FirstSegment;
			}
			else
			{
				Seg.NextSegment = Spawn( SegmentType,,, i, StreakRotation );
				Seg = Seg.NextSegment;
			}

			Seg.Parent = Self;
		}

		Seg.NextSegment = None;

		CurrentSegment = FirstSegment;

		CurrentSegment.Fade();
	}

	// Notification for when our currently fading segment is finished.
	simulated function FinishedFading()
	{
		CurrentSegment = CurrentSegment.NextSegment;
		if( CurrentSegment != None )
		{
			CurrentSegment.Fade();
		}
		else
		{
			NotifyParent();
			Destroy();
		}
	}
}

//------------------------------------------------------------------------------
simulated state Fading
{
	simulated function BeginState()
	{
		Skin = FadedTexture;
		Style = STY_Translucent;
		LifeSpan = FadeTime;

		if( FadeInterval > 0.0 && FadeInterval < FadeTime ) SetTimer( FadeInterval, False );
	}

	simulated function Tick( float DeltaTime )
	{
		Super.Tick( DeltaTime );

		ScaleGlow = default.ScaleGlow * LifeSpan / FadeTime;
	}

	simulated function Destroyed()
	{
		NotifyParent();
		Super.Destroyed();
	}

	simulated function Timer()
	{
		NotifyParent();
	}
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
simulated function NotifyParent()
{
	if( !bNotifiedParent )
	{
		bNotifiedParent = True;

		if( TracerSeg(Parent) != None )
		{
			TracerSeg(Parent).FinishedFading();
		}
		else if( TracerStreak(Parent) != None )
		{
			TracerStreak(Parent).FinishedFading();
		}
	}
}

defaultproperties
{
     RemoteRole=ROLE_None
     bMustFace=False
}
