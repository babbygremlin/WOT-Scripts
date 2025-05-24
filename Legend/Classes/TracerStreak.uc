//=============================================================================
// TracerStreak.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

//------------------------------------------------------------------------------
// Description:	Effect for simulating a tracer bullet.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn it.
// + Set the endpoints for where the streak will be drawn from/to in the same tick.
// + The fading process is automatically started on the next tick.
//------------------------------------------------------------------------------
// How this class works:
//
// + Connects the two endpoints with large segments. 
// + Starting with the first segment, it is broken into two parts.
// + Then of those two new segments, the first one is broken into two parts.
// + Then of those two new segments, the first one is faded out. 
//   (Using ScaleGlow/Translucency).
// + Once the first segment is completely faded away, the second is faded out.
// + Then the second (next larger) segment is broken in two and those are 
//   faded out.
// + This continues until all the segments are faded out.
// + If bUseLifeSpan is set to true, streaks aren't faded out -- their LifeSpan
//   will determine how long they last (e.g. 0.0 ==> forever).
//------------------------------------------------------------------------------

class TracerStreak expands Effects;

//////////////////////
// Member variables //
//////////////////////

// Endpoints of streak.
var() vector Start;
var() vector End;

var() class<TracerSeg> SegmentType;
var bool bUseLifeSpan;				// if true don't fade out streaks

var TracerSeg CurrentSegment;

replication
{
	reliable if( Role==ROLE_Authority )
		Start, End;
}

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
// This function must be called on the server in the same tick within which it
// was spawned.  The fading process will begin automatically on the next tick.
//------------------------------------------------------------------------------
function SetEndpoints( vector StartPoint, vector EndPoint )
{
	Start = StartPoint;
	End = EndPoint;
}

//------------------------------------------------------------------------------
simulated function FinishedFading();

///////////
// Logic //
///////////

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	if( Start != End )
	{
		GotoState('Fading');
	}
	else
	{
		Destroy();
	}
}

//------------------------------------------------------------------------------
simulated state Fading
{
	simulated function BeginState()
	{
		local vector i;
		local vector StreakDirection;
		local rotator StreakRotation;
		local TracerSeg FirstSegment, Seg;

		StreakDirection = Normal(End - Start);
		StreakRotation = rotator(StreakDirection);
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

		if( bUseLifeSpan )
		{
			Destroy();
		}
		else
		{
			Seg.NextSegment = None;

			CurrentSegment = FirstSegment;

			CurrentSegment.Fade();
		}
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
			Destroy();
		}
	}
}

defaultproperties
{
     bHidden=True
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Sprite
     bAlwaysRelevant=True
}
