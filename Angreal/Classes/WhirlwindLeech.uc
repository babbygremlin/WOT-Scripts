//------------------------------------------------------------------------------
// WhirlwindLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class WhirlwindLeech expands Leech;

#exec AUDIO IMPORT FILE=Sounds\Whirlwind\LoopWW.wav			GROUP=Whirlwind

// Where the castor wants the victim to be.
var vector DesiredLocation;

// How many seconds does it take to get from where we are to where we want to be?
var() float ActorFitsRadius;
var() float AlignmentSpeed;

// What physics our victim was using before we changed it.
var EPhysics OldPhysics;

// How fast we rotate our victim.
var() int RotationPerSecond;

// Tweek these values to make the twistyness of the whirlwind look right.
var() rotator WWRotationRate;
var() vector WWRotationOffset;
var rotator WWRotation;
var WhirlwindSprayer Sprayer;
var WhirlwindDust Dust;

var vector LastTraceLocation;

// How quickly our base moves to reach the ground.
var() float TouchDownSpeed;

var() float MaxHeight;

replication
{
	unreliable if( Role==ROLE_Authority )
		DesiredLocation;
}

//------------------------------------------------------------------------------
function AttachTo( Pawn NewHost )
{
	Super.AttachTo( NewHost );

	if( Owner == NewHost && Owner != None )	// Success.
	{
		DisableLevitate( Pawn(Owner) );

		SetLocation( Owner.Location );

		DesiredLocation = Owner.Location;

		OldPhysics = Owner.Physics;
		Owner.SetPhysics( PHYS_None );

		if( WOTPlayer(Owner) != None )
		{
			WOTPlayer(Owner).bForceRotation = true;
			WOTPlayer(Owner).ForcedRotationRate += rot(0,1,0) * RotationPerSecond;
		}
		else if( WOTPawn(Owner) != None )
		{
			WOTPawn(Owner).StopMovement();
		}
	}
	else
	{
		UnAttach();
		Destroy();
	}
}

//------------------------------------------------------------------------------
function UnAttach()
{
	if( Owner != None )
	{
		Owner.SetPhysics( OldPhysics );
	}

	if( WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).bForceRotation = false;
		WOTPlayer(Owner).ForcedRotationRate -= rot(0,1,0) * RotationPerSecond;
	}	

	Super.UnAttach();
}

//------------------------------------------------------------------------------
function AffectHost( optional int Iterations )
{
	if( Pawn(Owner) == None || Pawn(Owner).Health <= 0 )
	{
		UnAttach();
		Destroy();
	}
}

//------------------------------------------------------------------------------
function SetDesiredLocation( vector NewLoc )
{
	DesiredLocation = NewLoc;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local vector NewVelocity;
	local vector NewLocation;
	local rotator NewRotation;
	local vector TraceLocation;
	local vector HitNormal;
	local vector DesiredBaseLocation;

	if( Owner != None )	// Don't do anything unless we are attached to someone.
	{
		NewVelocity = (DesiredLocation - Owner.Location) / AlignmentSpeed;
	
		NewLocation = Owner.Location + (NewVelocity * DeltaTime);
	
		Owner.SetPhysics( PHYS_None );

		// Don't allow telefragging.
		if( class'Util'.static.ActorFits( Owner, NewLocation, ActorFitsRadius ) )
		{
			SetLocation( NewLocation );
			Owner.SetLocation( NewLocation );
		}
		
		NewRotation = Owner.Rotation;
		NewRotation.Yaw += int(RotationPerSecond * DeltaTime)+1;
		Owner.SetRotation( NewRotation );
	
		// Update twistyness of whirlwind sprayer.
		if( Sprayer == None )
		{
			class'Util'.static.TraceRecursive( Self, TraceLocation, HitNormal, Owner.Location, false );
			Sprayer = Spawn( class'WhirlwindSprayer',,, TraceLocation, rotator(vect(0,0,1)) );
		}
		if( Sprayer != None )
		{
			WWRotation += WWRotationRate * DeltaTime;
			class'Util'.static.TraceRecursive( Self, TraceLocation, HitNormal, Location, false );
			DesiredBaseLocation = TraceLocation + (WWRotationOffset >> WWRotation);
			if( DesiredBaseLocation.Z < Sprayer.Location.Z )
			{
				DesiredBaseLocation.Z = FMin( Sprayer.Location.Z - TouchDownSpeed * DeltaTime, Location.Z - Owner.CollisionHeight );
			}
			if( Location.Z - DesiredBaseLocation.Z > MaxHeight )
			{
				DesiredBaseLocation.Z = Location.Z - MaxHeight;
			}
			Sprayer.SetLocation( DesiredBaseLocation );
			Sprayer.SetHeight( VSize(DesiredLocation - Sprayer.Location) + 250 );
			DesiredBaseLocation.X = TraceLocation.X;
			DesiredBaseLocation.Y = TraceLocation.Y;
			if( LastTraceLocation != vect(0,0,0) )
			{
				Sprayer.ShiftParticles( DesiredBaseLocation - LastTraceLocation );
			}
			LastTraceLocation = DesiredBaseLocation;

			if( Dust == None )
			{
				Dust = Spawn( class'WhirlwindDust',,, Sprayer.Location, rotator(vect(0,0,1)) );
			}
			Dust.SetLocation( Sprayer.Location );
			Dust.bOn = Abs(Sprayer.Location.Z - TraceLocation.Z) < 10.0;
		}

		// Set instigator in case we kill the guy.
		if( WOTPlayer(Owner) != None )
		{
			WOTPlayer(Owner).SetSuicideInstigator( Instigator );
		}
		else if( WOTPawn(Owner) != None )
		{
			WOTPawn(Owner).SetSuicideInstigator( Instigator );
		}
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Sprayer != None )
	{
		Sprayer.Destroy();
	}
	
	if( Dust != None )
	{
		Dust.Destroy();
	}

	Tag = '';	// Clear our tag.

	// Make sure our source knows we are going away.
	if( AngrealInvWhirlwind(SourceAngreal) != None )
	{
		AngrealInvWhirlwind(SourceAngreal).NotifyLeechLost();
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
static function DisableLevitate( Pawn Other )
{
	local Inventory Inv;

	for( Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory )
	{
		if( AngrealInvLevitate(Inv) != None )
		{
			AngrealInvLevitate(Inv).UnCast();
		}
	}
}

defaultproperties
{
    ActorFitsRadius=1024.00
    AlignmentSpeed=2.00
    RotationPerSecond=120000
    WWRotationRate=(Pitch=0,Yaw=64000,Roll=0),
    WWRotationOffset=(X=10.00,Y=0.00,Z=0.00),
    TouchDownSpeed=60.00
    MaxHeight=500.00
    AffectResolution=0.20
    bDeleterious=True
    bDisplayIcon=True
    bSingular=True
    RemoteRole=2
    SoundRadius=255
    SoundVolume=255
    AmbientSound=Sound'Whirlwind.LoopWW'
    LightType=1
    LightEffect=13
    LightBrightness=88
    LightHue=204
    LightSaturation=204
    LightRadius=8
}
