//------------------------------------------------------------------------------
// LightGlobe.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LightGlobe expands Effects;

var() vector FollowOffset;	// Where we should be in relation to our FollowActor.
var() float MagicNumber;	// Affects stiffness to following movement.
var() name Color;			// Our color. (Blue, Green, Purple, Red or Yellow)
var() int LGLightRadius;	// LightRadius to use. (0 to 255)

var Actor FollowActor;		// Actor we are following.
var Actor LastClientFollowActor;
var vector FollowActorLocation;
var rotator FollowActorRotation;

var ActorRotator PixieJarRotator;

replication
{
	reliable if( Role==ROLE_Authority )
		FollowActor, Color;

	reliable if( Role==ROLE_Authority && FollowActor != None && !FollowActor.bNetRelevant )
		FollowActorLocation,
		FollowActorRotation;
}

//------------------------------------------------------------------------------
simulated function Trigger( Actor Other, Pawn EventInstigator )
{
	if( EventInstigator != None )
	{
		Follow( EventInstigator );
	}
	else if( Other != None )
	{
		Follow( Other );
	}
}

//------------------------------------------------------------------------------
simulated function Follow( Actor Other )
{
	local PixieJar Jar;

	FollowActor = Other;

	if( FollowActor != None )
	{
		SetLocation( FollowActor.Location );
		
		PixieJarRotator = Spawn( class'PixieJarRotator',,, Location );
		    	
		Jar = Spawn( class'PixieJar' );
		Jar.SetColor( Color );
		if( LGLightRadius >= 0 )
		{
			Jar.SetLightRadius( LGLightRadius );
		}
		PixieJarRotator.MyActor = Jar;

		PixieJarRotator.Initialize();
	}
	else if( Role==ROLE_Authority )
	{
		Destroy();
	}
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local vector DesiredLocation;

	if( Role==ROLE_Authority )	//###Server###
	{
		if( FollowActor == None )
		{
			Destroy();
			return;
		}
	}
	else						//###Client###
	{
		if( FollowActor != LastClientFollowActor )
		{
			Follow( FollowActor );
			LastClientFollowActor = FollowActor;
		}
	}

	if( FollowActor != None )
	{
		FollowActorLocation = FollowActor.Location;
		FollowActorRotation = FollowActor.Rotation;
	}

	if( PixieJarRotator != None )
	{
		DesiredLocation = FollowActorLocation + (FollowOffset >> FollowActorRotation);
		SetLocation( Location + ( (DesiredLocation - Location) / MagicNumber ) );
		PixieJarRotator.SetLocation( Location );
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( PixieJarRotator != None )
	{
		if( PixieJarRotator.MyActor != None )
		{
			PixieJarRotator.MyActor.Destroy();
		}

		PixieJarRotator.Destroy();
	}
}

defaultproperties
{
    FollowOffset=(X=30.00,Y=15.00,Z=70.00),
    MagicNumber=4.00
    Color=Blue
    LGLightRadius=-1
    bHidden=True
    bNetTemporary=False
    RemoteRole=2
    DrawType=1
    bAlwaysRelevant=True
}
