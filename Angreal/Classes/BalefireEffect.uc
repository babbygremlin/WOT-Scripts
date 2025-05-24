//------------------------------------------------------------------------------
// BalefireEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	The visual effect for when Actors are removed from the 
//				timeline.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BalefireEffect expands Effects;

// The actor we are currently removing from the timeline.
var Actor RemoveObject;

var float WaitTime;

var vector InitialLocation;

var bool bSpawnedExplosion;

var() float DestroyTime;

replication
{
	reliable if( Role==ROLE_Authority && bNetInitial )
		RemoveObject, InitialLocation;
}

//------------------------------------------------------------------------------
function RemoveFromTimeline( Actor Other )
{
	local int i;

	RemoveObject = Other;
		
	if( RemoveObject != None )
	{
		InitialLocation = RemoveObject.Location;
		RemoveObject.SetPhysics( PHYS_None );
		RemoveObject.SetCollision( false, false, false );
		RemoveObject.bCollideWorld = false;
		RemoveObject.AnimRate = 0.0;
		RemoveObject.Style = STY_Translucent;
		RemoveObject.ScaleGlow = 5.0;
		RemoveObject.AmbientGlow = 250;
	}
	else
	{
		InitialLocation = Location;
	}
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local vector RandOffset;
	local Explosion Exp; 

	if( !bSpawnedExplosion )
	{
		bSpawnedExplosion = true;
		Exp = Spawn( class'BFExplodeA',,, InitialLocation );
		WaitTime = Exp.LifeSpan;
	}

	DestroyTime -= DeltaTime;
	if( DestroyTime <= 0.0 )
	{
		if( RemoveObject != None )
		{
			RemoveObject.Destroy();
			RemoveObject = None;
		}
	}

	WaitTime -= DeltaTime;
	if( WaitTime <= 0.0 )
	{
		Spawn( class'BFExpSprayer',,, InitialLocation );
		Destroy();
	}
}


defaultproperties
{
    DestroyTime=0.50
    bHidden=True
    RemoteRole=2
    bAlwaysRelevant=True
}
