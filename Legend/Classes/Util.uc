//=============================================================================
// Util.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 12 $
//=============================================================================

class Util expands LegendObjectComponent native abstract;

//Add package names to default properties as neeed.
var () string LoadClassFromNamePackages[4];

//------------------------------------------------------------------------------
// Use the syntax: class'Util'.static.Function(); for the following functions.
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// Converts time in seconds into a string representation.
// hh:mm:ss
//------------------------------------------------------------------------------
static final function string SecondsToTime( float TimeSeconds, optional bool bNoSeconds )
{
	local int Hours, Minutes, Seconds;
	local string HourString, MinuteString, SecondString;
	
	Seconds = int(TimeSeconds);
	Minutes = Seconds / 60;
	Hours   = Minutes / 60;
	Seconds = Seconds - (Minutes * 60);
	Minutes = Minutes - (Hours * 60);
	
	if( Seconds < 10 )
		SecondString = "0"$Seconds;
	else
		SecondString = string(Seconds);

	if( Minutes < 10 )
		MinuteString = "0"$Minutes;
	else
		MinuteString = string(Minutes);

	if( Hours < 10 )
		HourString = "0"$Hours;
	else
		HourString = string(Hours);

	if( bNoSeconds )
		return HourString$":"$MinuteString;
	else
		return HourString$":"$MinuteString$":"$SecondString;
}



//------------------------------------------------------------------------------
static function DrawQuickLine
(
	Actor				Helper,		// pass in self.
	optional vector		Start,
	optional vector		End,
	optional Actor		StartActor,
	optional Actor		EndActor,
	optional float		SpriteInterval,
	optional float		SpriteSize,
	optional Texture	SpriteTexture,
	optional float		Duration
)
{
	local Line Line;

	local vector A, B;
	local float Length;

	if( Helper == None ) return;
	
	// Stupidity check.
	if( (StartActor == None || EndActor == None) && Start == End )
	{
		Helper.warn( "DrawQuickLine: Invalid parameters." );
	}

	Line = Helper.Spawn( class'Line' );

	Line.SetEndpoints( Start, End );
	Line.SetFollowActors( StartActor, EndActor );
	
	if( StartActor != None )
		A = StartActor.Location;
	else
		A = Start;
	
	if( EndActor != None )
		B = EndActor.Location;
	else
		B = End;

	Length = VSize(A - B);
	
	if( SpriteInterval > 0.0 )
		Line.SegmentLength = SpriteInterval;
	else
		Line.SegmentLength = FClamp( Length / 50.0, 0.5, 16.0 );

	if( SpriteSize > 0.0 )
		Line.DrawScale = SpriteSize;
	else
		Line.DrawScale = FClamp( Length / 400.0, 0.01, 2.0 );
	
	if( SpriteTexture != None )
		Line.Texture = SpriteTexture;
	else
		Line.Texture = Texture(DynamicLoadObject( "ParticleSystems.Sparks01", class'Texture' ));	//!!hardcoded texture

	Line.LifeSpan = Duration;
}

//===========================================================================
// Copies display-related information from Source Actor to DestinationActor.

static function CopyDisplaySettings( Actor Source, Actor Destination )
{
	local int i;

	for( i = 0; i < ArrayCount( Destination.MultiSkins ); i++ )
	{
		Destination.MultiSkins[ i ] = Source.MultiSkins[ i ];
	}
	
	Destination.Mesh					= Source.Mesh;
	Destination.bMeshCurvy				= Source.bMeshCurvy;	
	Destination.bMeshEnviroMap			= Source.bMeshEnviroMap;	
	Destination.Mesh					= Source.Mesh;
	Destination.Skin					= Source.Skin;
	Destination.Texture					= Source.Texture;
	Destination.Fatness					= Source.Fatness;
	Destination.DrawScale				= Source.DrawScale;
	Destination.AnimSequence			= Source.AnimSequence;
	Destination.AnimFrame				= Source.AnimFrame;
	Destination.AnimRate				= Source.AnimRate;
	Destination.TweenRate				= Source.TweenRate;
	Destination.AnimMinRate				= Source.AnimMinRate;
	Destination.AnimLast				= Source.AnimLast;
	Destination.bAnimLoop				= Source.bAnimLoop;
	Destination.SimAnim.X				= Source.AnimFrame * 10000;
	Destination.SimAnim.Y				= Source.AnimRate  * 5000; 
	Destination.SimAnim.Z				= Source.TweenRate * 1000; 
	Destination.SimAnim.W				= Source.AnimLast  * 10000;
	Destination.bAnimFinished			= Source.bAnimFinished;
	Destination.bSpecialLit				= Source.bSpecialLit;
}


//------------------------------------------------------------------------------
// Returns vector perpendicular to given vector, ignoring z component.

static function vector PerpendicularXY( vector V )
{
	local vector VOut;

	VOut.x = -V.y;
	VOut.y =  V.x;

	return VOut;
}

//------------------------------------------------------------------------------
// Sets given rotation parameter (yaw, pitch, roll) to 0 or 32768 depending on
// which value is closer to the original value.

static function ZeroRotParam( out int Val )
{
	Val = Val & 0xFFFF;

	if( Val < 16384 || Val >= 49152 )
	{
		Val = 0;
	}
	else
	{
		Val = 32768;
	}
}

//------------------------------------------------------------------------------
// Sets given rotation parameter (yaw, pitch, roll) to given value or given value
// plus 32768 depending on which is closer to the original value.

static function SetLandedRotParam( out int Val, int DesiredVal )
{
	// normalize angle
	Val = Val & 0xFFFF;

	if( abs(Val - DesiredVal) < 16384 || abs(Val - DesiredVal) >= 49152 )
	{
		Val = DesiredVal;
	}
	else
	{
		Val = DesiredVal + 32768;
	}

	// normalize angle
	Val = Val & 0xFFFF;
}

//=============================================================================
// Shifts the given Actor's location by the given Offset and shifts the
// actor's mesh in the opposite direction (so the Actor doesn't appear to move).
// Useful with carcasses to line up CC with the mesh for example.

static function ShiftCollisionCylinder( Actor SourceActor, vector Offset )
{
	SourceActor.SetLocation( SourceActor.Location + Offset );
	SourceActor.PrePivot = SourceActor.PrePivot - Offset;
}

//------------------------------------------------------------------------------
// Calculated the closest point on the given Actor's collision cylinder
// to the given location.
//=============================================================================

static function vector CalcClosestCollisionPoint( Actor Other, vector Loc )
{
/* -- This is all wrong.
	local vector ClosestLocation;

	// Find the closest point on Other to us.
	ClosestLocation = Loc - Other.Location;								// Point from Other toward Loc...
	ClosestLocation.Z = 0.0;											// Straight out...
	ClosestLocation = Normal(ClosestLocation) * Other.CollisionRadius;	// The amount of its CollisionRadius...
	ClosestLocation += Other.Location;									// From its Location.

	if( Loc.Z < Other.Location.Z - Other.CollisionHeight )				// We are below.
	{
		ClosestLocation.Z = Other.Location.Z - Other.CollisionHeight;	// Use bottom of collision cylinder.
	}
	else if( Loc.Z > Other.Location.Z + Other.CollisionHeight )			// We are above
	{
		ClosestLocation.Z = Other.Location.Z + Other.CollisionHeight;	// Use top of collision cylinder.
	}
	else																// We are somewhere in-between.
	{
		ClosestLocation.Z = Loc.Z;										// Line up with Loc's elevation.
	}

	return ClosestLocation;
*/

	// ripped from UPrimitive::LineCheck.
	// I really should simply expose UPrimitive::LineCheck to UnrealScript instead.
	// This probably can be simplified more since we are assuming the end point is 
	// the colliding actor's location.

	local vector HitNormal;

	local vector Start, End;
	local vector Extent;

	local float TopZ, BotZ;

	local float T0, T1, T;

	local float Kx, Ky;

	local float Vx, Vy;
	local float A, B, C;
	local float Discrim;

	local float Dir;

	local float R2A;

	local float ResultTime;

	if( Other == None )
		return vect(0,0,0);

	HitNormal = vect(0,0,0);

	Start = Loc;
	End = Other.Location;

	Extent.X = Other.CollisionRadius;
	Extent.Y = Other.CollisionRadius;
	Extent.Z = Other.CollisionHeight;

	TopZ = End.Z + Extent.Z;
	BotZ = End.Z - Extent.Z;

	// Clip to top of cylinder.
	T0 = 0.0; 
	T1 = 1.0;
	if( Start.Z > TopZ && End.Z < TopZ )
	{
		T = (TopZ - Start.Z) / (End.Z - Start.Z);
		if( T > T0 )
		{
			T0 = FMax( T0, T );
			HitNormal = vect(0,0,1);
		}
	}
	else if( Start.Z < TopZ && End.Z > TopZ )
	{
		T1 = FMin( T1, (TopZ - Start.Z) / (End.Z - Start.Z) );
	}

	// Clip to bottom of cylinder.
	if( Start.Z < BotZ && End.Z > BotZ )
	{
		T = (BotZ - Start.Z) / (End.Z - Start.Z);
		if( T > T0 )
		{
			T0 = FMax( T0, T );
			HitNormal = vect(0,0,-1);
		}
	}
	else if( Start.Z > BotZ && End.Z < BotZ )
	{
		T1 = FMin( T1, (BotZ - Start.Z) / (End.Z - Start.Z) );
	}

	// Reject.
	if( T0 >= T1 )
		return vect(0,0,0);

	// Test setup.
	Kx = Start.X - End.X;
	Ky = Start.Y - End.Y;

	// 2D circle clip about origin.
	Vx        = End.X - Start.X;
	Vy        = End.Y - Start.Y;
	A         = Vx*Vx + Vy*Vy;
	B         = 2.0 * (Kx*Vx + Ky*Vy);
	C         = Kx*Kx + Ky*Ky - Square(Extent.X);
	Discrim   = B*B - 4.0*A*C;

	// If already inside sphere, oppose further movement inward.
	if( C < Square(1.0) && Start.Z > BotZ && Start.Z < TopZ )
	{
		Dir = ((End - Start) * vect(1,1,0)) dot (Start - End);
		if( Dir < -0.1 )
		{
			HitNormal = Normal((Start - End) * vect(1,1,0));
			return Start;
		}
		else
		{
			return vect(0,0,0);
		}
	}

	// No intersection if discriminant is negative.
	if( Discrim < 0 )
	{
		return vect(0,0,0);
	}

	// Unstable intersection if velocity is tiny.
	if( A < Square(0.0001) )
	{
		// Outside.
		if( C > 0 )
		{
			return vect(0,0,0);
		}
	}
	else
	{
		// Compute intersection times.
		Discrim	= Sqrt(Discrim);
		R2A		= 0.5/A;
		T1		= FMin( T1, (Discrim-B) * R2A );
		T		= -(Discrim+B) * R2A;
		if( T > T0 )
		{
			T0 = T;
			HitNormal	= (Start + (End-Start)*T0 - End);
			HitNormal.Z	= 0;
			HitNormal	= Normal(HitNormal);
		}
		if( T0 >= T1 )
		{
			return vect(0,0,0);
		}
	}
	ResultTime = FClamp( (T0 - 0.001), 0.0, 1.0 );
	return Start + (End-Start) * ResultTime;
}



//=============================================================================
// Determines whether or not the given actor will telefrag another Actor  if
// it is placed at the given location.
// (Note: This is not the fastest function in the world.)
//------------------------------------------------------------------------------
static function bool ActorFits( Actor MovingActor, vector DesiredLocation, float ActorFitsRadius )
{
	local Actor IterA;
	local float RadiusDiff, HeightDiff;
	local vector Diff;
	local bool bFits;

	// Filter out bogus data.
	if( MovingActor == None )
	{
		return false;	// Should this return true?  Since a non-existance Actor could theretically fit anywhere - if you could move it.
	}

	bFits = true;

	// Check all blocking actors for overlapping collision cylinders.
	if( MovingActor.bBlockActors || MovingActor.bBlockPlayers )
	{
		foreach MovingActor.RadiusActors(class'Actor', IterA, ActorFitsRadius, DesiredLocation )
		{
			if( IterA != MovingActor && !IterA.IsA( 'Mover' ) )
			{
				if( IterA.bBlockActors || IterA.bBlockPlayers )
				{
					Diff = IterA.Location - DesiredLocation;
					HeightDiff = Diff.z;
					Diff.z = 0;
					RadiusDiff = VSize( Diff );

					if
					(	IterA.CollisionRadius + MovingActor.CollisionRadius >= RadiusDiff	// Using >= to be safe.  > is probably sufficient.
					&&	IterA.CollisionHeight + MovingActor.CollisionHeight >= HeightDiff
					)
					{
						bFits = false;
						break;	// No need to go on.
					}
				}
			}
		}
	}

	return bFits;
}



//=============================================================================
// Returns true if the given actor can be moved MoveDistance units along the 
// given MoveDir. Makes sure that the collision cylinder will fit along the
// trace from the actor's current location to the new location and that the
// maximum step height is not exceeded.
//
// If bTraceActors is true, only considers *blocking* actors. Actors which
// collide with other actors but which don't have blocking on shouldn't affect
// whether the given Actor can move there.
//=============================================================================

static function bool CanActorMoveTo( Actor A, vector MoveDir, float MoveDistance, bool bTraceActors )
{				
	local vector HitLocation, HitNormal, Extent;
	local actor HitActor;
		
	Extent.X = A.CollisionRadius;
	Extent.Y = A.CollisionRadius;
	Extent.Z = A.CollisionHeight;

	//trace from actor's location MoveDistance units along MoveDir using extents	
	HitActor = TraceRecursiveBlocking( A, HitLocation, HitNormal, A.Location, bTraceActors,, MoveDir, MoveDistance, Extent );

	return ( ( HitActor == None ) || ( VSize( HitLocation - A.Location ) >= MoveDistance ) );
}

//------------------------------------------------------------------------------
static function class<Object> LoadClassFromName( name ClassName )
{
	local int i;
	local class<Object> LoadedClass;

	//Catch bad input.
	if( ClassName != '' )
	{
		for( i = 0; i < ArrayCount( default.LoadClassFromNamePackages ); i++ )
		{
			LoadedClass = class<Object>( DynamicLoadObject( default.LoadClassFromNamePackages[ i ] $ "." $ string(ClassName), class'Class', true ) );
			if( LoadedClass != None )
			{
				break;
			}
		}
	}

	return LoadedClass;
}



//=============================================================================
// Calculate a direction vector based on a general direction, and the amount of
// spread (in degrees) allowed.
//=============================================================================

static function vector CalcSprayDirection( rotator Direction, float Spread )
{
	local float Radius, ZDelta, YDelta;
	local vector X, Y, Z, Offset;

	Radius = Tan( Spread / 2.0 * PI / 180.0 );
	ZDelta = Radius - (2 * Radius * FRand());
	YDelta = Radius - (2 * Radius * FRand());
	
	GetAxes( Direction, X, Y, Z );
	
	Offset = (ZDelta * Z) + (YDelta * Y);
	
	return Normal(vector(Direction) + Offset);
}



//=============================================================================

static function ConformRot( out rotator Source, rotator Image, rotator Allowance )
{
	if( Abs(Source.Yaw   - Image.Yaw)   < Allowance.Yaw )   Source.Yaw   = Image.Yaw;
	if( Abs(Source.Pitch - Image.Pitch) < Allowance.Pitch ) Source.Pitch = Image.Pitch;
	if( Abs(Source.Roll  - Image.Roll)  < Allowance.Roll )  Source.Roll  = Image.Yaw;
}



//=============================================================================

static function bool VectAproxEqual( vector v1, vector v2, float Allowance )
{
	return (	Abs(v1.x-v2.x) < Allowance && 
				Abs(v1.y-v2.y) < Allowance &&
				Abs(v1.z-v2.z) < Allowance );
}



//=============================================================================
// Draws a line made of sprites (or dots) that can optionally fade out.
// Used primarily for debugging.
//=============================================================================

static function DrawLine3D
(
	Actor Helper, vector Start, vector End, 
	optional float FadeDuration,			// Amount of time to fade the line out over.
	optional float DotInterval,				// Space between consecutive dots in a line.
	optional Texture DotTexture,			// Texture to use to draw the dots in the line.
	optional float DelayTime				// How long to wait before actually drawing the line.
)
{
	local Line3D Line;

	Line = Helper.Spawn( class'Line3D' );
	Line.LineDuration = FadeDuration;
	if( DotTexture != None )
	{
		Line.LineTexture = DotTexture;
	}
	if( DotInterval > 0.0 )
	{
		Line.DotInterval = DotInterval;
	}
	Line.SetEndpoints( Start, End );
	Line.ReDraw( DelayTime );
}



//=============================================================================
// Draws a permanent, easily visible line from Start to End. Mainly useful for
// debugging calls to Trace etc.
//=============================================================================

static function DrawLine
(
	Actor			Owner,
	vector 			Start,
	vector          End
)
{
	local LineStreak LS;
	local LineStreakVert LSV;

	LS	= Owner.Spawn( class'LineStreak' );
	LSV	= Owner.Spawn( class'LineStreakVert' );

	LS.SetEndPoints( Start, End ); 
	LSV.SetEndPoints( Start, End ); 
}


//=============================================================================
// Draw a line from the given player's eyes along his line of sight.
//=============================================================================

static function DrawViewLine( PlayerPawn P )
{
	local vector StartTrace, EndTrace;

	StartTrace		= P.Location; 
	StartTrace.Z   += P.BaseEyeHeight;
	
	EndTrace = StartTrace + 32767 * normal( vector(P.ViewRotation) );

	DrawLine( P, StartTrace, EndTrace );
}


//=============================================================================
// Same as trace, but draws a line from the start location to the end location.
//=============================================================================

static function Actor VisibleTrace
(
	Actor			TraceFromActor,
	out vector      HitLocation,
	out vector      HitNormal,
	vector          TraceEnd,
	optional vector TraceStart,
	optional bool   bTraceActors,
	optional vector Extent
)
{
	DrawLine( TraceFromActor, TraceStart, TraceEnd );

	return TraceFromActor.Trace( HitLocation, HitNormal, TraceEnd, TraceStart, bTraceActors, Extent );
}



//=============================================================================
// Recursively traces until we hit something (BSP or Actor).
//------------------------------------------------------------------------------
// Instance:		We need an instance Actor to call trace from.	(Pass in any Actor - Self is usually a good choice.)
// HitLocation:     Location of hit BSP/Actor.
// HitNormal:		Hit normal.
// StartLoc:		Location to start tracing from.
// bTraceActors:	Should we stop tracing if we hit an Actor?		(Default - false.)
// TraceInverval:	How far to trace per iteration.					(Default - 500 units.)
// TraceDirection:	Direction to trace in.							(Default - straight down.)
// TraceLimit:		How far to trace before giving up.				(Default - infinite.)
// Extent:			extents (optional)
// 
//------------------------------------------------------------------------------
// Returns:			Hit BSP/Actor or None if reached limit.
//------------------------------------------------------------------------------

static function Actor TraceRecursive
(	Actor			Instance,
	out vector		HitLocation,
	out vector		HitNormal,
	vector			StartLoc,
	optional bool	bTraceActors,
	optional float	TraceInterval,
	optional vector	TraceDirection,
	optional float	TraceLimit,
	optional vector Extent

)
{
	local Actor HitActor;
	local vector EndLoc;

	if( TraceInterval ~= 0.0 )
	{
		TraceInterval = 500.0;
	}

	if( TraceLimit != 0 && TraceInterval > TraceLimit )
	{
		TraceInterval = TraceLimit;
	}

	if( TraceDirection == vect(0,0,0) )
	{
		TraceDirection = vect(0,0,-1);
	}
	else
	{
		TraceDirection = Normal(TraceDirection);
	}

	EndLoc		= StartLoc + TraceDirection * TraceInterval;
	HitActor	= Instance.Trace( HitLocation, HitNormal, EndLoc, StartLoc, bTraceActors, Extent );

	if( TraceLimit > 0.0 )
	{
		TraceLimit -= TraceInterval;
		if( TraceLimit <= 0.0 )
		{
			return HitActor;	// Stop whether we've found anything or not.
		}
	}

	if( HitActor == None )
	{
		// we didn't hit anything -- continue tracing from where we stopped.
		HitActor = TraceRecursive( Instance, HitLocation, HitNormal, EndLoc, bTraceActors, TraceInterval, TraceDirection, TraceLimit, Extent );
	}

	return HitActor;
}

//=============================================================================
// Same as TraceRecursiveBlocking but only considers blocking actors. Kept this
// as a separate function to not slow down TraceRecursive. In any case, this
// could go away if some way to control whether hit actors must be blocking 
// could be added to the Trace function.

static function Actor TraceRecursiveBlocking
(	Actor			Instance,
	out vector		HitLocation,
	out vector		HitNormal,
	vector			StartLoc,
	optional bool	bTraceActors,
	optional float	TraceInterval,
	optional vector	TraceDirection,
	optional float	TraceLimit,
	optional vector Extent
)
{
	local Actor HitActor;
	local vector EndLoc;

	if( TraceInterval ~= 0.0 )
	{
		TraceInterval = 500.0;
	}

	if( TraceLimit != 0 && TraceInterval > TraceLimit )
	{
		TraceInterval = TraceLimit;
	}

	if( TraceDirection == vect(0,0,0) )
	{
		TraceDirection = vect(0,0,-1);
	}
	else
	{
		TraceDirection = Normal(TraceDirection);
	}

	EndLoc		= StartLoc + TraceDirection * TraceInterval;
	HitActor	= Instance.Trace( HitLocation, HitNormal, EndLoc, StartLoc, bTraceActors, Extent );
	if( HitActor != None && !HitActor.IsA( 'LevelInfo' ) && !HitActor.bBlockActors )
	{
		HitActor = None;
	}

	if( TraceLimit > 0.0 )
	{
		TraceLimit -= TraceInterval;
		if( TraceLimit <= 0.0 )
		{
			return HitActor;	// Stop whether we've found anything or not.
		}
	}

	if( HitActor == None )
	{
		// we didn't hit anything -- continue tracing from where we stopped.
		HitActor = TraceRecursiveBlocking( Instance, HitLocation, HitNormal, EndLoc, bTraceActors, TraceInterval, TraceDirection, TraceLimit, Extent );
	}

	return HitActor;
}

//=============================================================================
// Traces from PlayerPawn's eyes 64K units along his ViewRotation and returns
// what was hit, and the HitLocation and HitNormal.
//=============================================================================

static function Actor GetHitActorInfo( PlayerPawn P, out vector HitLocation, out vector HitNormal, bool bSafe )
{					 
	local vector StartTrace;
	local Actor HitActor;
	local Actor A;

	StartTrace		= P.Location; 
	StartTrace.Z   += P.BaseEyeHeight;

	// let us hit any visible actor which might not have the correct collision settings
	if( !bSafe )
	{
		foreach P.AllActors( Class'Actor', A )
		{
			if( !A.bHidden )
			{
				// this spams the old collision settings
  				A.SetCollision( true, true, true );
			}
		}		
	}

	HitActor = TraceRecursive( P, HitLocation, HitNormal, StartTrace, true, 0.0, vector(P.ViewRotation) );

	// let us hit any visible actor which might not have the correct collision settings
	if( !bSafe )
	{
		foreach P.AllActors( Class'Actor', A )
		{
			if( !A.bHidden )
			{
				A.SetCollision( A.default.bCollideActors, A.default.bBlockActors, A.default.bBlockPlayers );
			}
		}		
	}

	return HitActor;		
}


//=============================================================================

static function Actor GetHitActor( PlayerPawn P, bool bSafe )
{					 
	local vector HitLocation, HitNormal;

	return GetHitActorInfo( P, HitLocation, HitNormal, bSafe );
}



//=============================================================================
// Use this to fade objects out instead of just Destroy()ing them. Note that
// in multiplayer games fading is not performed for now, instead, after the
// DelayTime, the object is destroyed after FadeTime additional seconds.
//=============================================================================
// Other:				The Actor to fade away.
// FadeTime:			How long it takes to fade the object away.					(Defaults to Fader's default FadeTime value.)
// bNoDeleteActor:		When we finish fading the object out, should we delete it?	(Deletes it by default.)
// InitialScaleGlow:	The ScaleGlow the Actor starts with.						(Defaults to the Actor's current ScaleGlow value.)
// FinalScaleGlow:		The ScaleGlow the Actor ends with.							(Defaults to Fader's default FinalScaleGlow value (0).) - Must be less than InitialScaleGlow.
// DelayTime:			Time to wait before starting to fade.						(Defaults to 0.0 seconds)
// NumFlickers:			Number of times to "flicker" before fading                  (Defaults to 0)
//=============================================================================

static simulated function Fade( Actor Other, optional float FadeTime, optional bool bNoDeleteActor, optional float InitialScaleGlow, optional float FinalScaleGlow, optional float DelayTime, optional int NumFlickers )
{
	local Fader F;

	if( Other != None )
	{
		F = Other.Spawn( class'Fader' );
		
		if( FadeTime > 0.0 )
		{
			F.FadeTime = FadeTime;
		}

		F.bDeleteActor = !bNoDeleteActor;

		if( InitialScaleGlow > 0.0 )
		{
			F.InitialScaleGlow = InitialScaleGlow;
		}

		if( FinalScaleGlow > 0.0 )
		{
			F.FinalScaleGlow = FinalScaleGlow;
		}

		F.DelayTime = DelayTime;
		
		F.NumFlickers = NumFlickers;

		F.Fade( Other );
	}
}



//=============================================================================
// Various helpful functions for printing messages to log file and screen,
// primarily used for debugging.
//=============================================================================

static function BMLogR( Actor A, coerce string str )
{
	A.log( str );
}



static function BMLog( Actor A, coerce string str )
{
	A.log( str );
	A.BroadcastMessage( str );
}



static function BMWarnR( Actor A, coerce string str )
{
	A.warn( str );
}



static function BMWarn( Actor A, coerce string str )
{
	A.warn( str );
	A.BroadcastMessage( str );
}



//=============================================================================
// Helper function for FindBestTarget.
// Returns the cosine of the angle between v1 and v2.
//=============================================================================

static function float FindCosAngle( vector v1, vector v2 )
{
    local float CosAngle;
    CosAngle = ( v1 dot v2 ) / ( VSize( v1 ) * VSize( v2 ) );
    return CosAngle;
}



//=============================================================================
// Returns the sin of the given angle.
// Angle is in degrees.
//=============================================================================

static function float DSin( float Angle )
{
	return Sin( Angle * PI / 180.0 );
}



//=============================================================================
// Returns the cos of the given angle.
// Angle is in degrees.
//=============================================================================

static function float DCos( float Angle )
{
	return Cos( Angle * PI / 180.0 );
}




//=============================================================================
// Returns true if the given vectors are aproximately equal.
// Fix MWP: This should probably be added to the engine.
//=============================================================================

static function bool VectorAproxEqual( vector FirstVector, vector SecondVector )
{
	return ( ( FirstVector.x ~= SecondVector.x ) &&
			( FirstVector.y ~= SecondVector.y ) &&
			( FirstVector.z ~= SecondVector.z ) );
}



//=============================================================================

static function SwapInt( out int Num1, out int Num2 )
{
	local int temp;

	temp = Num1;
	Num1 = Num2;
	Num2 = temp;
}



//=============================================================================

static function SwapFloat( out float Num1, out float Num2 )
{
	local float temp;

	temp = Num1;
	Num1 = Num2;
	Num2 = temp;
}



//=============================================================================
// Linearly scales odds between min/max odds given a distance and corresponding
// min/max distances. Odds can increase (MinOdds <= MaxOdds or decrease (MinOdds 
// > MaxOdds) with distance.
//=============================================================================
// Distance:		Distance to use.
// MinDistance:		Minimum distance.
// MaxDistance:		Maximum distance.
// MinOdds:			Odds to use at min distance.					(Default 0.0)
// MaxOdds:			Odds to use at max distance.					(Default 1.0)
//=============================================================================
// Returns:			Odds to use.
//=============================================================================

static function float RandDistance( float Distance, float MinDistance, float MaxDistance, optional float MinOdds, optional float MaxOdds )
{
	local float DistanceOdds;
	local float LinearScaleFactor;
	local float DeltaDistance;

	if( MaxOdds < MinOdds )
	{
		class'Util'.static.SwapFloat( MinOdds, MaxOdds );
		DeltaDistance = ( MaxDistance - Distance );
	}
	else
	{
		DeltaDistance = ( Distance - MinDistance );
	}

	// odds increase with distance	
	if( Distance >= MaxDistance )
	{
		DistanceOdds = MaxOdds;
	}
	else if( Distance <= MinDistance )
	{
		DistanceOdds = MinOdds;
	}
	else
	{
    	LinearScaleFactor	= ( MaxOdds - MinOdds ) / ( MaxDistance - MinDistance );
		DistanceOdds		= DeltaDistance*LinearScaleFactor + MinOdds;
	}

	return DistanceOdds;
}



//=============================================================================
// Randomly modifies the given float by +/- given %.
//
// e.g. PerturbFloatPercent( 100.0, 20.0) will return a value in 80.0..120.0
//=============================================================================

static function float PerturbFloatPercent( float Num, float PerturbPercent )
{
	local float Perturb;

	Perturb = 2.0*PerturbPercent / 100.0;

	return Num + Num * ( ( Perturb * FRand() - Perturb / 2.0 ) );
}


//=============================================================================
// Randomly modifies the given int by +/- given #.
//
// e.g. PerturbInt( 100, 20) will return a value in 80..120
//=============================================================================

static function int PerturbInt( int Num, int PerturbPlusMinus )
{
	return Num + Rand( 2*PerturbPlusMinus+1 ) - PerturbPlusMinus;
}


//=============================================================================
// Randomize given rotator param, wrapping if necessary.

static function RandomizeRotatorParam( out int Param, int PerturbRange )
{
	Param = (Param + Rand(2*PerturbRange+1) - PerturbRange) & 0xFFFF;
}

//=============================================================================
// Randomize a rotator's members +/- over the given range.

static function RandomizeRotator( out Rotator RandomizedRotator, int RollPerturbRange, int YawPerturbRange, int PitchPerturbRange )
{
	RandomizeRotatorParam( RandomizedRotator.Roll,  RollPerturbRange );
	RandomizeRotatorParam( RandomizedRotator.Yaw,   YawPerturbRange );
	RandomizeRotatorParam( RandomizedRotator.Pitch, PitchPerturbRange );
}

//=============================================================================

/*
these are not used anymore
static function bool HasReachedLocation( Actor ReachingActor,
		vector Destination,
		optional float ReachTolerance )
{
	local float DistanceBetween;
	DistanceBetween = GetDistanceBetweenCylinders( ReachingActor.Location,
			ReachingActor.CollisionRadius, ReachingActor.CollisionHeight,
 			Destination, 0, 0 );
 	return ( DistanceBetween <= ReachTolerance );
}



static function bool HasReachedActor( Actor ReachingActor,
		Actor DestinationActor,
		optional float ReachTolerance )
{
	local float DistanceBetween;
	local bool bReachedActor;
	
	if( DestinationActor != None )
	{
		DistanceBetween = GetDistanceBetweenCylinders( ReachingActor.Location,
				ReachingActor.CollisionRadius, ReachingActor.CollisionHeight,
	 			DestinationActor.Location, DestinationActor.CollisionRadius,
	 			DestinationActor.CollisionHeight );
	 	bReachedActor = ( DistanceBetween <= ReachTolerance );
	}

	class'Debug'.static.DebugLog( ReachingActor, "HasReachedActor", default.DebugCategoryName );
	class'Debug'.static.DebugLog( ReachingActor, "HasReachedActor DistanceBetween: " $ DistanceBetween, default.DebugCategoryName );
	class'Debug'.static.DebugLog( ReachingActor, "HasReachedActor ReachTolerance: " $ ReachTolerance, default.DebugCategoryName );
	return  bReachedActor;
}
*/


//-----------------------------------------------------------------------------
// Allows you to check if an object is in your view.
//-----------------------------------------------------------------------------
// ViewVec:	A vector facing "forward"						(relative to your location.)
// DirVec:	A vector pointing to the object in question.	(relative to your location.)
// FOVCos:	Cosine of how many degrees the target must be within to be seen.
//-----------------------------------------------------------------------------
// REQUIRE: FOVCos > 0
// NOTE: While normalization is not required for ViewVec or DirVec, it helps
// if both vectors are about the same size.
//-----------------------------------------------------------------------------
static function bool IsInViewCos( vector ViewVec, vector DirVec, float FOVCos )
{
	local float CosAngle;		//cosine of angle from object's LOS to WP
    
    CosAngle = FindCosAngle( ViewVec, DirVec );

	//The first test makes sure the target is within the firer's front 180o view.
	//The second test might look backwards, but it isn't.  Since cos(0) == 1,
	//as the angle gets smaller, CosAngle *increases*, so an angle less than
	//the max will have a larger cosine value.
	
	return (0 <= CosAngle && FOVCos < CosAngle);
}

//-----------------------------------------------------------------------------
// Allows you to check if an object is in your view.
//-----------------------------------------------------------------------------
// ViewVec:	A vector facing "forward"						(relative to your location.)
// DirVec:	A vector pointing to the object in question.	(relative to your location.)
// FOV:		How many degrees the target must be within to be seen.
//-----------------------------------------------------------------------------
// REQUIRE: FOV < 90
// NOTE: While normalization is not required for ViewVec or DirVec, it helps
// if both vectors are about the same size.
//-----------------------------------------------------------------------------
static function bool IsInView( vector ViewVec, vector DirVec, float FOV )
{
	return class'Util'.static.IsInViewCos( ViewVec, DirVec, cos( ( 2 * Pi ) / ( 360 / FOV ) ) );
}



//=============================================================================
// ActorIsInPawnFOV
// Returns true if A is in P's FOV.
// If FOVCos is not given (~= 0.0), uses the Pawn's PeripheralVision setting.
//=============================================================================

static event function bool ActorIsInPawnFOV( Pawn P, Actor A, optional float FOVCos )
{
	local rotator InViewRotation;

	if( FOVCos ~= 0.0 )
	{
		FOVCos = P.PeripheralVision;
	}

	if( PlayerPawn(P) != None )
	{
		InViewRotation = P.ViewRotation; // use ViewRotation for players only
	}
	else
	{
		InViewRotation = P.Rotation;	 // ViewRotation not really used for NPCs
	}

	return class'Util'.static.IsInViewCos( Vector(InViewRotation), 
										   A.Location - P.Location, 
										   FOVCos );
}

//=============================================================================
// PawnCanSeeActor:
//
// Returns true if Actor is not entirely occluded by geometry from the given
// pawn's point of view. If bTraceActors is true, other actors will block the
// pawn's view of the TraceToActor.
//
// Determines whether a Pawn can see an actor, i.e. whether any line from the
// Pawn's eyes (BaseEyeHeight) to the Actor exists which doesn't hit any 
// geometry or another actor (if bTraceActors is true) and is within the 
// Pawn's FOV relative to his ViewRotation.
//
//=============================================================================
// TraceFromPawn:	Pawn to trace from
// TraceToActor:	Actor to trace to
// FOVCos:			(optional) cos of FOV of Pawn (1/2 of the total FOV), 
//					defaults to Pawn's PeripheralVision.
//
//=============================================================================
// Notes:
// 
// There's got to be a better way to do this.  Tim has to do this when he 
// draws the actors on the screen.  Is there any way we can piggy-back off
// of that code?
//
// CanSee is fubar: reports true even if facing 180 degrees away, but close,
// could be related to the fact that CanSee also takes noises into account...
// LineOfSightTo is fubar: doesn't take actor's into account?
//
// Will return true if the pawn can see the bottom, center or top of the given
// actor's collision cylinder. Currently only traces to the horizontal center 
// of the actor, doesn't currently check left and right sides.
//
// TBD: do left-left and right-right checks as well to handle case where 
// actors can only see each other's left/right side.
//
// Seems this can fail for small (fast?) actors e.g. tracing from a Pawn to a 
// dart projectile which was maybe 200 units in front consistently fails to
// hit the dart.


static function bool PawnCanSeeActor( Pawn TraceFromPawn, Actor TraceToActor, optional float FOVCos, optional bool bTraceActors )
{
	local bool bCanSee;

	local vector StartPoint;
	local vector EndPoints[3];

	local int i;

	local Actor HitActor;
	local vector HitLocation, HitNormal;
	
	//
	// Is the Actor even in the Pawns FOV?
	//

	if( !class'Util'.static.ActorIsInPawnFOV( TraceFromPawn, 
											  TraceToActor,
											  FOVCos ) )
	{
	  	return false;
	}

	//
	// Can we trace a line from the Pawn's eyes to the actor without hitting geometry?
	//
	
	StartPoint = TraceFromPawn.Location + TraceFromPawn.BaseEyeHeight*vect(0,0,1);
	EndPoints[0] = TraceToActor.Location;												// pawn eyes->actor center
	EndPoints[1] = TraceToActor.Location + TraceToActor.CollisionHeight*vect(0,0,1);	// pawn eyes->actor top (head)
	EndPoints[2] = TraceToActor.Location - TraceToActor.CollisionHeight*vect(0,0,1);	// pawn eyes->actor bottom (feet)

	for( i = 0; i < ArrayCount(EndPoints); i++ )
	{
		HitActor = TraceRecursive
			(	TraceFromPawn,
				HitLocation,
				HitNormal,
				StartPoint,
				bTraceActors,,
				Normal(EndPoints[i] - StartPoint),		// direction.
				VSize(EndPoints[i] - StartPoint)		// limit.
			);

		// if bTraceActors is true, trace should hit TraceToActor if pawn can see TraceToActor
		// if bTraceActors is false, trace should hit nothing if pawn can see TraceToActor
		bCanSee = ( HitActor == None || HitActor == TraceToActor );

    	if( bCanSee )	
			break;		// No need to go on.
	}

	return bCanSee;
}



//=============================================================================
// ActorCanSeeActor:
//
// Returns true if the first Actor has an uninterrupted LOS to the second actor.
//
//=============================================================================
// TraceFromActor:	Actor to trace from
// TraceToActor:	Actor to trace to
//=============================================================================

static function bool ActorCanSeeActor( Actor TraceFromActor, Actor TraceToActor )
{
	local vector TraceHitLocation, TraceHitNormal;

	local bool bRetVal;
	
	// can we trace a line from the Pawn's eyes to the actor?
	bRetVal = (
		// pawn eyes->actor center
		TraceFromActor.Trace( 
			TraceHitLocation, 
			TraceHitNormal,		
			TraceToActor.Location, 
			TraceFromActor.Location, 
			true ) == TraceToActor );
			
	return bRetVal;
}



//=============================================================================
// ActorVisibleToAnyPawn:
//
// Returns true if the given actor is visible to any pawn in the game which 
// matches the given class (e.g. all WOTPlayers, WOTPawns, Trollocs...).
//
// Takes into account pawns' FOVs.
//
//=============================================================================
// A:			Target Actor
// pClass:		Class to iterate.
// FOVCos:		(optional) cos of FOV of Pawn (1/2 of the total FOV), 
//				defaults to Pawn's PeripheralVision.
//
//=============================================================================

static function bool ActorVisibleToAnyPawn( Actor A, class<Pawn> pClass, optional float FOVCos )
{
	local Actor Other;

	// iterate all players
	foreach A.AllActors( pClass, Other )
	{
		if( class'Util'.static.PawnCanSeeActor( Pawn(Other), A, FOVCos, true ) )
		{
			return true;
		}
	}
	
	// no player can see actor
	return false;
}



//=============================================================================
// Returns true if we can reach our destination without hitting any geometry.
//=============================================================================

static function bool IsLocationDirectlyReachable( Actor ReachingActor, vector Destination )
{
	local vector TraceHitLocation, TraceHitNormal;
	local Actor TraceHitActor;
	
	if( ReachingActor.IsA( 'Pawn' ) )
	{
		Pawn( ReachingActor ).PointReachable( Destination );
	}
	else
	{
		TraceHitActor = ReachingActor.Trace( TraceHitLocation, TraceHitNormal,
				Destination, ReachingActor.Location, false /*Don't trace Actors*/ );
	}

	return ( TraceHitActor == None );
}



static function bool IsActorDirectlyReachable( Actor ReachingActor, Actor Destination )
{
	local vector TraceHitLocation, TraceHitNormal;
	local Actor TraceHitActor;
	
	if( ReachingActor.IsA( 'Pawn' ) )
	{
		Pawn( ReachingActor ).ActorReachable( Destination );
	}
	else
	{
		TraceHitActor = ReachingActor.Trace( TraceHitLocation, TraceHitNormal,
				Destination.Location, ReachingActor.Location, false /*Don't trace Actors*/ );
	}

	return ( TraceHitActor == None );
}



static function TriggerAllInstances( Actor TriggeringActor,
		class<Pawn> InstanceType,
		Pawn EventInstigator,
		Name TriggerEvent )
{
	local Name LastEvent;
	local Actor CurrentActor;

	LastEvent = TriggeringActor.Event;
	TriggeringActor.Event = TriggerEvent;
		
	foreach TriggeringActor.AllActors( InstanceType, CurrentActor )
	{
		CurrentActor.Trigger( TriggeringActor, EventInstigator );
	}

	TriggeringActor.Event = LastEvent;
}



static function TriggerActor( Actor TriggeringActor,
		Actor TriggeredActor,
		Pawn EventInstigator,
		Name TriggerEvent )
{
	local Name LastEvent;
	local Pawn CurrentPawn;

	class'Debug'.static.DebugAssert( TriggeringActor, ( TriggeredActor != None ), "TriggerActor", default.DebugCategoryName );

	LastEvent = TriggeringActor.Event;
	TriggeringActor.Event = TriggerEvent;
		
	TriggeredActor.Trigger( TriggeringActor, EventInstigator );

	TriggeringActor.Event = LastEvent;
}



static function TriggerRadiusInstances( Actor TriggeringActor,
		class<Actor> InstanceType,
		Pawn EventInstigator,
		Name TriggerEvent,
		float TriggerRadius )
{
	local Name LastEvent;
	local Actor CurrentInstance;

	LastEvent = TriggeringActor.Event;
	TriggeringActor.Event = TriggerEvent;
		
	foreach TriggeringActor.RadiusActors( InstanceType, CurrentInstance, TriggerRadius )
	{
		CurrentInstance.Trigger( TriggeringActor, EventInstigator );
	}

	TriggeringActor.Event = LastEvent;
}




//=============================================================================
// GetDistanceBetweenCylinders:
//
// Return the distance between the 2 given cylinders (origin, radius and
// half-height for each). Can possibly return a negative value if the
//=============================================================================

static event float GetDistanceBetweenCylinders(
		Vector FirstOrigin, float FirstRadius, float FirstHalfHeight,
 		Vector SecondOrigin, float SecondRadius, float SecondHalfHeight )
{
	local float DistanceBetween, MinDistance;
	local Vector OriginDifference, OriginDifferenceNormal;
	local Vector FirstSurfaceLocation, SecondSurfaceLocation;
		
	//Log( "::Util::GetDistanceBetweenCylinders" );
	OriginDifference = SecondOrigin - FirstOrigin;
	OriginDifference.z = 0;
	OriginDifferenceNormal = Normal( OriginDifference );
		
	FirstSurfaceLocation = FirstOrigin + ( OriginDifferenceNormal * FirstRadius );
	SecondSurfaceLocation = SecondOrigin - ( OriginDifferenceNormal * SecondRadius );
	
	//Log( "::Util::GetDistanceBetweenCylinders: SecondOrigin.z - SecondHalfHeight: " $ SecondOrigin.z - SecondHalfHeight );
	//Log( "::Util::GetDistanceBetweenCylinders: FirstOrigin.z + FirstHalfHeight:   " $ FirstOrigin.z + FirstHalfHeight );
	//Log( "::Util::GetDistanceBetweenCylinders: FirstOrigin.z - FirstHalfHeight:   " $ FirstOrigin.z - FirstHalfHeight );
	//Log( "::Util::GetDistanceBetweenCylinders: SecondOrigin.z + SecondHalfHeight: " $ SecondOrigin.z + SecondHalfHeight );

	if( ( SecondOrigin.z - SecondHalfHeight ) > ( FirstOrigin.z + FirstHalfHeight ) )
	{
		//1st cylinder is above 2nd cylinder 
		//distance is taken from closest point on bottom of 1st cylinder to 
		//closest point on top of 2nd cylinder (within the connecting plane)
		SecondSurfaceLocation.z -= SecondHalfHeight;
		FirstSurfaceLocation.z += FirstHalfHeight;
		DistanceBetween = VSize( FirstSurfaceLocation - SecondSurfaceLocation );
		//Log( "::Util::GetDistanceBetweenCylinders Case 1" );
	}
	else if( ( FirstOrigin.z - FirstHalfHeight ) >	( SecondOrigin.z + SecondHalfHeight ) )
	{
		//1st cylinder is below 2nd cylinder 
		//distance is taken from closest point on top of 1st cylinder to 
		//closest point on bottom of 2nd cylinder (within the connecting plane)
		FirstSurfaceLocation.z -= FirstHalfHeight;
		SecondSurfaceLocation.z += SecondHalfHeight;
		DistanceBetween = VSize( FirstSurfaceLocation - SecondSurfaceLocation );
		//Log( "::Util::GetDistanceBetweenCylinders Case 2" );
	}
	else
	{
		//cylinders are at least partly on the same horizontal plane
		//distance is the distance between the surface locations
		//projected down to the z = 0 plane
		FirstSurfaceLocation.z = 0;
		SecondSurfaceLocation.z = 0;
		DistanceBetween = VSize( FirstSurfaceLocation - SecondSurfaceLocation );
		//Log( "::Util::GetDistanceBetweenCylinders: DistanceBetween: " $ DistanceBetween );

		//if the collision cylinders overlap, DistanceBetween is -ve
		if( VSize( OriginDifference ) < ( FirstRadius + SecondRadius ) )
		{
			DistanceBetween = -DistanceBetween;
		}
		//Log( "::Util::GetDistanceBetweenCylinders Case 3" );
	}
	
	//Log( "::Util::GetDistanceBetweenCylinders FirstOrigin: " $ FirstOrigin );
	//Log( "::Util::GetDistanceBetweenCylinders FirstRadius: " $ FirstRadius );
	//Log( "::Util::GetDistanceBetweenCylinders FirstHalfHeight: " $ FirstHalfHeight );
	//Log( "::Util::GetDistanceBetweenCylinders SecondOrigin: " $ SecondOrigin );
	//Log( "::Util::GetDistanceBetweenCylinders SecondRadius: " $ SecondRadius );
	//Log( "::Util::GetDistanceBetweenCylinders SecondHalfHeight: " $ SecondHalfHeight );
	//Log( "::Util::GetDistanceBetweenCylinders OriginDifference: " $ OriginDifference );
	//Log( "::Util::GetDistanceBetweenCylinders OriginDifferenceNormal: " $ OriginDifferenceNormal );
	//Log( "::Util::GetDistanceBetweenCylinders FirstSurfaceLocation : " $ FirstSurfaceLocation  );
	//Log( "::Util::GetDistanceBetweenCylinders SecondSurfaceLocation: " $ SecondSurfaceLocation );
	//Log( "::Util::GetDistanceBetweenCylinders returning " $ DistanceBetween );

	return DistanceBetween;
}



//=============================================================================
// GetDistanceBetweenActors:
// Wrapper for GetDistanceBetweenCylinders for 2 actors.
//=============================================================================

static event float GetDistanceBetweenActors( Actor A1, Actor A2 )
{
	return GetDistanceBetweenCylinders( A1.Location, A1.CollisionRadius, A1.CollisionHeight,
										A2.Location, A2.CollisionRadius, A2.CollisionHeight );
}
/*
GetSphereIntersection:

Gets the intersection of a sphere centered at SphereCenter with radius SphereRadius and a line
with endpoints at LinePointU and LinePointV. The function returns true if an intersection occurs.
Additionally, the out parameters IntersectionPoint1 and IntersectionPoint1 are set to the distance
of the intersection points from LinePointU. Otherwise, the function returns false and leaves
IntersectionPoint1 and IntersectionPoint1 unchanged.

Algorithm stolen from graphics gems I.
*/
static function bool GetSphereIntersection( out float IntersectionDistance1, out float IntersectionDistance2, vector SphereCenter, float SphereRadius, vector LinePosition, vector LineNormal )
{
	local Vector G;
	local float a, b, c, d;
	local bool bIntersect;
	
	G = LinePosition - SphereCenter;
	
	a = LineNormal Dot LineNormal;
	b = 2 * ( LineNormal Dot G );
	c = ( G Dot G ) - Square( SphereRadius );
	d = Square( b ) - 4 * a * c;

	bIntersect = ( d >= 0 );

	if( bIntersect )
	{
		//an intersection has occured
		IntersectionDistance1 = ( ( -b ) + Sqrt( d ) ) / ( 2 * a );
		IntersectionDistance2 = ( ( -b ) - Sqrt( d ) ) / ( 2 * a );
	}

	return bIntersect;
}



static function bool IsPointVisible( Actor SeeingActor, Vector DestinationPoint )
{
	local vector TraceHitLocation, TraceHitNormal;
	return ( none == SeeingActor.Trace( TraceHitLocation, TraceHitNormal,
			DestinationPoint, SeeingActor.Location, false ) );
}



static function bool TraceFromActor( Actor GivenActor,
		Vector DestinationPoint,
		optional bool bCollideActors,
		optional bool bUseExtents )
{
	local vector TraceHitLocation, TraceHitNormal, GivenActorExtents;
	local Actor TraceHitActor;
	//Log( "::Util::TraceFromActor" );
	
	if( bUseExtents )
	{
		GivenActorExtents.x = GivenActor.CollisionRadius;
		GivenActorExtents.y = GivenActor.CollisionRadius;
		GivenActorExtents.z = GivenActor.CollisionHeight;
	}

	TraceHitActor = GivenActor.Trace( TraceHitLocation, TraceHitNormal,
			DestinationPoint, GivenActor.Location,  bCollideActors, GivenActorExtents );
	
	if( TraceHitActor != none )
	{
		//Log( "::Util::TraceFromActor TraceHitActor: " $ TraceHitActor );
	}
	
	return TraceHitActor != None;
}



static function bool IsLocationInActorSphere( Actor OriginActor,
		Vector TestLocation,
		float SphereRadius )
{
	//Log( "::Util::IsLocationInActorSphere" );
	return IsLocationInSphere( OriginActor.Location, SphereRadius, TestLocation );
}



static function bool IsLocationInSphere( Vector SphereOrigin,
		float SphereRadius,
		Vector TestLocation	)
{
	local bool bLocationInActorSphere;
	local Vector Difference;
	local float ObjectDistance;
	
	//Log( "::Util::IsLocationInSphere" );
	Difference = TestLocation - SphereOrigin;
	ObjectDistance = VSize( Difference );
	
	//Log( "		ObjectDistance " $ ObjectDistance );
	//Log( "		SphereRadius " $ SphereRadius );
	//is the pawn close enough to the Item location
	bLocationInActorSphere = ( ObjectDistance <= SphereRadius );
	
	//Log( "::Util::IsLocationInSphere returning " $ bLocationInActorSphere );
	return bLocationInActorSphere;
}



static function bool IsLocationInActorCylinder( Actor OriginActor,
		Vector TestLocation,
		float CylinderRadius )
{
	//Log( "::Util::IsLocationInActorCylinder" );
	return IsLocationInCylinder( OriginActor.Location,
			OriginActor.CollisionHeight, CylinderRadius, TestLocation );
}



static function bool IsLocationInCylinder( Vector CylinderOrigin,
		float HalfCylinderHeight,
		float CylinderRadius,
		Vector TestLocation )
{
	local bool bLocationInCylinder;
	local Vector Difference;
	local float ObjectDistance;
	
	//Log( "::Util::IsLocationInCylinder" );
	if( ( TestLocation.Z >= ( CylinderOrigin.Z - HalfCylinderHeight ) ) &&
			( TestLocation.Z <= ( CylinderOrigin.Z + HalfCylinderHeight ) ) )
	{
		bLocationInCylinder = IsLocationInRadius( CylinderOrigin,
				CylinderRadius, TestLocation );
	}

	return bLocationInCylinder;
}



static function bool IsLocationInRadius( Vector Origin,	float Radius,
		Vector TestLocation )
{
	local bool bLocationInRadius;
	local Vector Difference;
	local float ObjectDistance;
	
	//Log( "::Util::IsLocationInRadius" );
	Difference = TestLocation - Origin;
	Difference .Z = 0;
	ObjectDistance = VSize( Difference );
	//Log( "		ObjectDistance " $ ObjectDistance );
	//Log( "		Radius " $ Radius );
	//is the pawn close enough to the Item location
	bLocationInRadius = ( ObjectDistance <= Radius );
	
	return bLocationInRadius;
}



/*
static function bool IsLocationInRadius( Actor OriginActor,
		Vector ItemLocation,
		Vector ItemExtents,
		float TestRange )
{
	local bool bLocationInRadius;
	local Vector  Difference;
	local float DeltaHeight;
	local float ObjectDistance, LocationDistance;
	
	//Log( "::Util::IsLocationInRadius" );
	DeltaHeight = ItemExtents.Z - OriginActor.CollisionHeight;
	
	//put the preferred location at the pawn's height off it's floor
	ItemLocation.Z -= DeltaHeight;
	
	Difference = ItemLocation - OriginActor.Location;
	LocationDistance = VSize( Difference );
	ObjectDistance = Sqrt( Square( LocationDistance ) - Square( DeltaHeight ) );
	
	//is the pawn close enough to the Item location
	bLocationInRadius = ( ObjectDistance  <= TestRange );
	
	//Log( "::Util::IsLocationInRadius" );
	//Log( "		ObjectDistance " $ ObjectDistance );
	//Log( "		TestRange " $ TestRange );
	//Log( "		bLocationInRadius " $ bLocationInRadius );
	return bLocationInRadius;
}
*/


/*
//IsFacing is the pawn currently facing the given point
function bool IsFacing( Vector FacingLocation, float MinFacingYawRange )
{
	local Vector Difference;
	Difference = FacingLocation - Location;

	return InRange( Rotator( Difference ), Rotation, MinFacingYawRange );
}
*/



static function bool RotationEquivalent( Rotator FirstRotation, Rotator SecondRotation, float RotationComponentTolerance, optional Actor DebugProxy )
{
	local bool bRotationEquivalent;
	local Rotator RotationDifference, AbsRotationDifference;

	RotationDifference = Normalize( SecondRotation - FirstRotation );
	AbsRotationDifference.Roll = abs( RotationDifference.Roll );
	AbsRotationDifference.Pitch = abs( RotationDifference.Pitch );
	AbsRotationDifference.Yaw = abs( RotationDifference.Yaw );
			
	if( ( AbsRotationDifference.Roll <= RotationComponentTolerance ) &&
		( AbsRotationDifference.Pitch <= RotationComponentTolerance ) &&
		( AbsRotationDifference.Yaw <= RotationComponentTolerance ) )
	{
		bRotationEquivalent = true;
	}

	if( DebugProxy != None )
	{
		class'Debug'.static.DebugLog( DebugProxy, "RotationEquivalent FirstRotation: " $ FirstRotation, default.DebugCategoryName );
		class'Debug'.static.DebugLog( DebugProxy, "RotationEquivalent SecondRotation: " $ SecondRotation, default.DebugCategoryName );
		class'Debug'.static.DebugLog( DebugProxy, "RotationEquivalent RotationDifference: " $ RotationDifference, default.DebugCategoryName );
		class'Debug'.static.DebugLog( DebugProxy, "RotationEquivalent AbsRotationDifference: " $ AbsRotationDifference, default.DebugCategoryName );
		class'Debug'.static.DebugLog( DebugProxy, "RotationEquivalent RotationComponentTolerance: " $ RotationComponentTolerance, default.DebugCategoryName );
		class'Debug'.static.DebugLog( DebugProxy, "RotationEquivalent returning " $ bRotationEquivalent, default.DebugCategoryName );
	}

	return bRotationEquivalent;
}



static function bool FindActorByName( Actor SearchingActor, Name ActorName, out Actor FoundActor )
{
	local Actor CurrentActor;
	local bool bFoundActor;
	
	foreach SearchingActor.AllActors( class'Actor', CurrentActor )
	{
		if( CurrentActor.Name == ActorName )
		{
			FoundActor = CurrentActor;
			bFoundActor = true;
			break;
		}
	}
	class'Debug'.static.DebugLog( SearchingActor, "FindActorByName FoundActor: " $ FoundActor, default.DebugCategoryName );
	class'Debug'.static.DebugLog( SearchingActor, "FindActorByName returning " $ bFoundActor, default.DebugCategoryName );
	return bFoundActor;
}



//=============================================================================
// Inventory accessor and mutator functions
//=============================================================================

static function DebugLogInventory( Actor InvokingActor, Inventory InventoryItems )
{
	local Inventory CurrentInventory;
	local int InventoryCount;
	local string InventoryLog;
	
	// make sure we catch existing inventory items
	for( CurrentInventory = InventoryItems;
			CurrentInventory != None;
			CurrentInventory = CurrentInventory.Inventory ) 
	{
		InventoryLog = "DebugLogInventory " $ CurrentInventory $ " InventoryIndex: " $ InventoryCount $ " State: " $ CurrentInventory.GetStateName();
/*
		if( CurrentInventory.IsA( 'AngrealInventory' ) )
		{
			InventoryLog = InventoryLog $ " Charges:" $ AngrealInventory( CurrentInventory ).CurCharges;
		}
*/
		class'Debug'.static.DebugLog( InvokingActor, InventoryLog, default.DebugCategoryName );
		InventoryCount++;
	}
	
	class'Debug'.static.DebugLog( InvokingActor, "DebugLogInventory InventoryCount: " $ InventoryCount, default.DebugCategoryName );
}



//=============================================================================
// SelectNextInventoryItem:
// Select an inventory item which matches the given InventoryType, either
// sequentially or randomly.
//=============================================================================

static function SelectNextInventoryItem( out Inventory SelectedInventoryItem,
		Pawn InventoryHolder,
		class<Inventory> InventoryType,
		optional bool bRandomSelection,
		optional Inventory InitalInventoryItem )
{
	local int InventoryItemSkipCount;
	local Inventory CurrentInventoryItem;
	local int InventoryTypeCount;

	class'Debug'.static.DebugLog( InventoryHolder, "SelectNextInventoryItem", default.DebugCategoryName );
	//xxxdb DebugLogInventory( InventoryHolder, InventoryHolder.Inventory );
	InventoryTypeCount = class'Util'.static.GetInventoryCount( InventoryHolder, InventoryType );
	
	if( InventoryTypeCount > 0 )
	{
		if( bRandomSelection )
		{
			// skip a random # inventory items, possibly none
			InventoryItemSkipCount = Rand( InventoryTypeCount );
		}
		else
		{
			// get the 'next' matching inventory item after the current or first one
			InventoryItemSkipCount = min( 1, InventoryTypeCount - 1 );
		}
		
		if( ( InitalInventoryItem != None ) &&
				InitalInventoryItem.IsA( InventoryType.Name ) )
		{
			//the passed initial inventory item is the of the specified type
			CurrentInventoryItem = InitalInventoryItem;
			class'Debug'.static.DebugLog( InventoryHolder, "SelectNextInventoryItem 0", default.DebugCategoryName );
		}
		else if( ( InventoryHolder.SelectedItem != None ) &&
				InventoryHolder.SelectedItem.IsA( InventoryType.Name ) )
		{
			//the inventory holder's selected item is the of the specified type
			CurrentInventoryItem = InventoryHolder.SelectedItem;
			class'Debug'.static.DebugLog( InventoryHolder, "SelectNextInventoryItem 1", default.DebugCategoryName );
		}
		else
		{
			//get the first inventory item of the specified type from the pawn's inventory
			CurrentInventoryItem = class'Util'.static.GetInventoryItem( InventoryHolder, InventoryType );
			class'Debug'.static.DebugLog( InventoryHolder, "SelectNextInventoryItem 2", default.DebugCategoryName );
		}
		
		class'Debug'.static.DebugLog( InventoryHolder, "SelectNextInventoryItem InventoryItemSkipCount: " $ InventoryItemSkipCount, default.DebugCategoryName );
		class'Debug'.static.DebugLog( InventoryHolder, "SelectNextInventoryItem InventoryTypeCount : " $ InventoryTypeCount, default.DebugCategoryName );
		class'Debug'.static.DebugLog( InventoryHolder, "SelectNextInventoryItem InitialInventoryItem: " $ CurrentInventoryItem, default.DebugCategoryName );
		
		// skip InventoryItemSkipCount matching inventory items
		while( InventoryItemSkipCount > 0 && CurrentInventoryItem.IsA( InventoryType.Name ) )
		{
			// skip over this matching inventory item
			InventoryItemSkipCount--;
			
			// find the next matching inventory item
			do
			{
				CurrentInventoryItem = CurrentInventoryItem.Inventory;
				
				if( CurrentInventoryItem == None )
				{
					//reached end of inventory -- go back to beginning
					CurrentInventoryItem = class'Util'.static.GetInventoryItem( InventoryHolder, InventoryType );
				}
			}
			until( CurrentInventoryItem.IsA( InventoryType.Name ) );
		}
		
		//xxxdb debug check:
		if( !CurrentInventoryItem.IsA( InventoryType.Name ) )
		{
			warn( "WARNING: SelectNextInventoryItem item is not a " $ InventoryType.Name );
		}
		else
		{
			SelectedInventoryItem = CurrentInventoryItem;
		}
	}
	
	class'Debug'.static.DebugLog( InventoryHolder, "SelectNextInventoryItem selected " $ SelectedInventoryItem, default.DebugCategoryName );
}



static function int GetInventoryCount( Pawn InventoryHolder, class<Inventory> InventoryType )
{
	local Inventory CurrentInventoryItem;
	local int InventoryCount;

	class'Debug'.static.DebugLog( InventoryHolder, "GetInventoryCount", default.DebugCategoryName );
	for( CurrentInventoryItem = InventoryHolder.Inventory;
			( CurrentInventoryItem != None );
			CurrentInventoryItem = CurrentInventoryItem.Inventory )
	{
		if( CurrentInventoryItem.IsA( InventoryType.Name ) )
		{
			InventoryCount++;
		}
	}
	
	return InventoryCount;
}



static function Inventory AddInventoryTypeToHolder( Pawn InventoryHolder, class<Inventory> InventoryType )
{
	local Inventory NewInventoryItem;
	local bool bLastNeverSwitchOnPickup;
	
	class'Debug'.static.DebugAssert( InventoryHolder, ( None != InventoryHolder ), "bogus inventory holder", default.DebugCategoryName );
	class'Debug'.static.DebugAssert( InventoryHolder, ( None != InventoryType ), "bogus inventory type", default.DebugCategoryName );
	
	class'Debug'.static.DebugLog( InventoryHolder, "AddInventoryTypeToHolder attempting to add a " $ InventoryType, default.DebugCategoryName );
	if( None == InventoryHolder.FindInventoryType( InventoryType ) )
	{
		class'Debug'.static.DebugLog( InventoryHolder, "AddInventoryTypeToHolder " $ InventoryType $ " not currently in inventory", default.DebugCategoryName );
		//a valid inventory type was passed
		//an item of the same inventory type does not exist in the pawn's inventory
		
		NewInventoryItem = InventoryHolder.Spawn( InventoryType, InventoryHolder, , InventoryHolder.Location );
		class'Debug'.static.DebugLog( InventoryHolder, "AddInventoryTypeToHolder spawned " $ NewInventoryItem, default.DebugCategoryName );
		class'Debug'.static.DebugLog( InventoryHolder, "AddInventoryTypeToHolder bHeldItem " $ NewInventoryItem.bHeldItem, default.DebugCategoryName );

		if( NewInventoryItem != None )
		{
			bLastNeverSwitchOnPickup = InventoryHolder.bNeverSwitchOnPickup;
			InventoryHolder.bNeverSwitchOnPickup = true;
	
			NewInventoryItem = NewInventoryItem.SpawnCopy( InventoryHolder );
			class'Debug'.static.DebugLog( InventoryHolder, "AddInventoryTypeToHolder spawned copy" $ NewInventoryItem, default.DebugCategoryName );
			
			class'Debug'.static.DebugLog( InventoryHolder, "AddInventoryTypeToHolder " $ NewInventoryItem $ " added to inventory", default.DebugCategoryName );
			class'Debug'.static.DebugLog( InventoryHolder, "AddInventoryTypeToHolder bHeldItem " $ NewInventoryItem.bHeldItem, default.DebugCategoryName );
			
			InventoryHolder.bNeverSwitchOnPickup = bLastNeverSwitchOnPickup;
			class'Debug'.static.DebugLog( InventoryHolder, "AddInventoryTypeToHolder " $ NewInventoryItem $ " added to inventory", default.DebugCategoryName );
		}
	}
	else
	{
		class'Debug'.static.DebugLog( InventoryHolder, "AddInventoryTypeToHolder item exists", default.DebugCategoryName );
	}
	return NewInventoryItem;
}



//Return inventory item from holder's inventory matching class 'InventoryType'
static final function Inventory GetInventoryItem( Pawn InventoryHolder, class<Inventory> InventoryType )
{
    local Inventory CurrentInventoryItem;
    local Inventory FoundInventoryItem;
    
    for( CurrentInventoryItem = InventoryHolder.Inventory;
    		( ( None != CurrentInventoryItem ) && ( None == FoundInventoryItem ) );
    		CurrentInventoryItem = CurrentInventoryItem.Inventory )
    {
        if( ClassIsChildOf( CurrentInventoryItem.Class, InventoryType ) )
        {
            FoundInventoryItem = CurrentInventoryItem;
        }
    }
    
    return FoundInventoryItem;
}



static function Inventory RemoveInventoryItem( Pawn InventoryHolder, class<Inventory> InventoryType )
{
	local Inventory RemovedInventoryItem;

	RemovedInventoryItem = class'Util'.static.GetInventoryItem( InventoryHolder, InventoryType );

	if( RemovedInventoryItem != None )
	{
		InventoryHolder.DeleteInventory( RemovedInventoryItem );
	}

	return RemovedInventoryItem;
}



//Return weapon from holder's inventory matching class 'WeaponType'
static function Weapon GetInventoryWeapon( Pawn InventoryHolder, class<Weapon> WeaponType )
{
	return Weapon( class'Util'.static.GetInventoryItem( InventoryHolder, WeaponType ) );
}



//Delete weapon matching given 'WeaponType' from holder's inventory if found & return weapon 
static final function Weapon RemoveInventoryWeapon( Pawn InventoryHolder, class<Weapon> WeaponType )
{
	return Weapon( class'Util'.static.RemoveInventoryItem( InventoryHolder, WeaponType ) );
}

defaultproperties
{
     LoadClassFromNamePackages(0)="Angreal"
     LoadClassFromNamePackages(1)="WOT"
     LoadClassFromNamePackages(2)="WOTTraps"
     LoadClassFromNamePackages(3)="WOTPawns"
     DebugCategoryName=Util
}
