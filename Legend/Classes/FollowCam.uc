//------------------------------------------------------------------------------
// FollowCam.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class FollowCam expands Inventory;

var() float FollowCamSpeedFactor;
var() vector FollowCamOffset;
var() float SnapDist; // -- Deprecated.

var() float RetractAccel;
var float RetractSpeed;

var bool bRetract;
var vector LastCameraLocation;
var Pawn SelectedPawn;
var bool bFreezeCameraPosition;

var bool bOn;
var PlayerPawn Viewer;

replication
{
	reliable if( Role<ROLE_Authority )
		SetViewTarget;
}

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
simulated function Posses( PlayerPawn InViewer )
{
	bOn = True;
	Viewer = InViewer;
	SetViewTarget( Viewer, Self );
	LastCameraLocation = Viewer.Location + vect(0,0,1) * Viewer.BaseEyeHeight;
}

//------------------------------------------------------------------------------
simulated function UnPosses( PlayerPawn InViewer )
{
	bOn = False;
	Viewer = None;
	SetViewTarget( InViewer, None );
}

//------------------------------------------------------------------------------
simulated function Use( Pawn User )
{
	if( User == Owner )	// safe when User==None.
	{
		FollowCam();
	}
}

////////////////////
// exec functions //
////////////////////

//------------------------------------------------------------------------------
simulated exec function FollowCam()
{
	if( PlayerPawn(Owner) != None )
	{
		if( !bOn )
		{
			bRetract = false;
			if( Viewer == None )
			{
				Posses( PlayerPawn(Owner) );
			}
		}
		else
		{
			bRetract = !bRetract;
			if( bRetract )
			{
				RetractSpeed = 0.0;
				bFreezeCameraPosition = false;
			}
		}
	}
}	

//------------------------------------------------------------------------------
simulated exec function HoldCamera()
{
    bFreezeCameraPosition = !bFreezeCameraPosition;
}

//------------------------------------------------------------------------------
simulated exec function SelectClosestPawn()
{
    local Pawn p;
   
    // Unselect and return if one is already selected.
    if( SelectedPawn != None )
    {
        SelectedPawn = None;
        return;
    }
    
    // Iterate through all the Visible Pawns, and select the closest one.
    foreach VisibleActors( class'Pawn', p )
    {
        if( p != self ) // Don't use yourself stupid.
		{
            if( SelectedPawn == None || VSize( p.Location - Location ) < VSize( SelectedPawn.Location - Location ) )
			{
                SelectedPawn = p;
			}
		}
    } 
}

///////////
// Logic //
///////////

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	if( bOn && Viewer != None )
	{
		if( Viewer.ViewTarget == Self )
		{
			if( Viewer.Health > 0 )
			{
				CalcFollowPosition( DeltaTime );
			}
			else
			{
				UnPosses( Viewer );
			}
		}
		else
		{
			bOn = false;
			Viewer = None;
			bRetract = false;
		}
	}

	Super.Tick( DeltaTime );
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
simulated function CalcFollowPosition( float DeltaTime )
{
	local vector View, HitLocation, HitNormal;
	local float DesiredDist;
	local Actor HitActor;
	local vector DesiredCameraLocation, diff;
	local vector CameraLocation;
	local rotator CameraRotation;
	local vector PrevPos;

	CameraRotation = Viewer.ViewRotation;
		
	View = vect(1,0,0) >> CameraRotation;

	if( bRetract )
	{
		DesiredCameraLocation = Viewer.Location;
		DesiredCameraLocation.z += Viewer.BaseEyeHeight;
	}
	else
	{
		// This is the wrong way to do this.
		DesiredCameraLocation = Viewer.Location + FollowCamOffset.x * View + FollowCamOffset.z * vect(0,0,1);
	}
	
	if( !bFreezeCameraPosition )
	{
		diff = DesiredCameraLocation - LastCameraLocation;

		if( bRetract )
		{	
			PrevPos = LastCameraLocation;
			RetractSpeed += (RetractAccel * DeltaTime);
			LastCameraLocation = LastCameraLocation + (diff/FollowCamSpeedFactor) + (Normal(DesiredCameraLocation-LastCameraLocation)*(RetractSpeed*DeltaTime));
			
			// Check if we passed our desired location.
			if( !class'Util'.static.VectorAproxEqual( Normal(DesiredCameraLocation-PrevPos), Normal(DesiredCameraLocation-LastCameraLocation) ) )
			{
				UnPosses( Viewer );
			}
		}
		else
		{
			LastCameraLocation += diff/FollowCamSpeedFactor;
		}
	}
	
	CameraLocation = LastCameraLocation;
	
	if( SelectedPawn != None )
	{
		CameraRotation = rotator( SelectedPawn.Location - CameraLocation );
		// Cheat by auto-aiming on the selected pawn.
		Viewer.ViewRotation = rotator( SelectedPawn.Location - Location );
	}
	else
	{
		CameraRotation = rotator( Viewer.Location + 48 * View + Viewer.BaseEyeHeight * vect(0,0,1) - CameraLocation );
	}
	
	// Don't go thru walls.
	HitActor = Trace( HitLocation, HitNormal, CameraLocation, Viewer.Location, false );
	if( HitActor != None )
	{
		CameraLocation = HitLocation;
		bFreezeCameraPosition = false;
	}

	// -- Deprecated.
	// If we catch back up to ourself, go back to normal render mode.
	//if( bRetract && class'Util'.static.VectAproxEqual( CameraLocation, DesiredCameraLocation, SnapDist ) )
	//{
	//	UnPosses( Viewer );
	//}

	SetLocation( CameraLocation );
	SetRotation( CameraRotation );
}

//------------------------------------------------------------------------------
// This function is replicated to the server if called from the client.
//------------------------------------------------------------------------------
simulated function SetViewTarget( PlayerPawn InViewer, Actor InTarget )
{
	InViewer.ViewTarget = InTarget;
	RemoteRole = ROLE_SimulatedProxy;
}

///////////////
// Overrides //
///////////////

//------------------------------------------------------------------------------
function BecomePickup()
{
	Super.BecomePickup();
	
	bHidden = true;
	SetCollision( false, false, false );
}

defaultproperties
{
     FollowCamSpeedFactor=2.500000
     FollowCamOffset=(X=-140.000000,Z=80.000000)
     SnapDist=1.000000
     RetractAccel=250.000000
     bAmbientGlow=False
     PickupMessage="FollowCam installed"
     ItemName="FollowCam"
     bHidden=True
     bIsItemGoal=False
     AmbientGlow=0
     bGameRelevant=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bCollideActors=False
}
