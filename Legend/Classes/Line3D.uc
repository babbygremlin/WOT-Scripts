//------------------------------------------------------------------------------
// Line3D.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
class Line3D expands Effects;

var() vector Start, End;		// Start and end points of the line.
var() float DotInterval;		// Spacing between dots in line.
var() class<LineDot> DotClass;	// Type of dot to use.
var() Texture LineTexture;		// Used to override normal dot texture.
var() float LineDuration;		// If set, fades line out over given duration.

var LineDot FirstDot;	// Linked list of dots composing this line.

var float DrawTime;		// When to draw next.

//------------------------------------------------------------------------------
simulated function SetStart( vector P )
{
	Start = P;
}

//------------------------------------------------------------------------------
simulated function SetEnd( vector P )
{
	End = P;
}

//------------------------------------------------------------------------------
simulated function SetEndpoints( vector S, vector E )
{
	Start = S;
	End = E;
}

//------------------------------------------------------------------------------
simulated function SetTexture( Texture T )
{
	LineTexture = T;
}

//------------------------------------------------------------------------------
simulated function ReDraw( optional float WaitTime )
{
	if( WaitTime > 0.0 )
	{
		DrawTime = Level.TimeSeconds + WaitTime;
	}
	else
	{
		DrawLine();
	}
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( DrawTime > 0.0 && Level.TimeSeconds >= DrawTime )
	{
		DrawLine();
	}
}

//------------------------------------------------------------------------------
simulated function DrawLine()
{
	local vector P;
	local vector Interval;
	local LineDot Dot, PrevDot;

	DrawTime = 0.0;

	HideAll();

	if( Start != End )
	{
		Dot = FirstDot;
		Interval = Normal(End - Start) * DotInterval;
		for( P = Start; class'Util'.static.VectorAproxEqual( Normal(End - P), Normal(Interval) ); P += Interval )
		{
			if( !IsOccupied( P ) )
			{
				if( Dot == None )
				{
					Dot = Spawn( DotClass );
					if( FirstDot == None )
					{
						FirstDot = Dot;
					}
					if( PrevDot != None )
					{
						PrevDot.NextDot = Dot;
					}
				}
				Dot.SetLocation( P );
				Dot.SetRotation( rotator(Interval) );
				Dot.SetDuration( LineDuration );
				if( LineTexture != None )
				{
					Dot.Texture = LineTexture;
				}
				PrevDot = Dot;
				Dot = Dot.NextDot;
			}
		}
	}
}

//------------------------------------------------------------------------------
simulated function bool IsOccupied( vector Location )
{
	local LineDot IterD;

	foreach RadiusActors( class'LineDot', IterD, 3.0, Location )
	{
		return true;
	}

	return false;
}

//------------------------------------------------------------------------------
simulated function Clear()
{
	if( FirstDot != None )
	{
		FirstDot.Destroy();	// recursively deletes all dots in linked list.
		FirstDot = None;
	}
}

//------------------------------------------------------------------------------
simulated function HideAll()
{
	local LineDot Dot;

	for( Dot = FirstDot; Dot != None; Dot = Dot.NextDot )
	{
		Dot.bHidden = true;
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	Clear();
	Super.Destroyed();
}

defaultproperties
{
     DotInterval=16.000000
     DotClass=Class'Legend.LineDot'
     LineDuration=60.000000
     RemoteRole=ROLE_None
}
