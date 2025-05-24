//------------------------------------------------------------------------------
// SpectatorCamera.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class SpectatorCamera expands Inventory;

var() bool bMaintainLocation;

var Actor Focus;
var PlayerPawn Viewer;
var bool bOn;

var bool bUseFollowCam;

var Pawn PlayerList[32];
var Pawn NPCList[96];

var int NumPlayers;
var int NumNPCs;

var int PlayerIndex;
var int NPCIndex;

var CameraPoint CurrentCamera;

// FollowCam stuff.
var vector LastCameraLocation;
var() float FollowCamSpeedFactor;
var() vector FollowCamOffset;

replication
{
	reliable if( Role<ROLE_Authority )
		SetViewTarget;
}

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
simulated function Posses( PlayerPawn InViewer, optional bool bMaintainLocation )
{
	bOn = True;
	Viewer = InViewer;
	self.bMaintainLocation = bMaintainLocation;
	SetViewTarget( Viewer, Self );
	LastCameraLocation = Viewer.Location + vect(0,0,1) * Viewer.BaseEyeHeight;
}

//------------------------------------------------------------------------------
simulated function UnPosses( PlayerPawn InViewer )
{
	bOn = False;
	Viewer = None;
	bMaintainLocation = default.bMaintainLocation;
	SetViewTarget( Viewer, None );
}

//------------------------------------------------------------------------------
simulated function Use( Pawn User )
{
	if( User == Owner )	// safe if User==None.
	{
		ToggleSpectatorCam();
	}
}

////////////////////
// exec functions //
////////////////////

//------------------------------------------------------------------------------
simulated exec function ToggleSpectatorCam()
{
	if( PlayerPawn(Owner) != None )
	{
		if( !bOn )
		{
			Posses( PlayerPawn(Owner) );
			Focus = Owner;
			SCRefresh();
		}
		else
		{
			UnPosses( PlayerPawn(Owner) );
		}
	}
}

//------------------------------------------------------------------------------
simulated exec function SCNextPlayer()
{
	if( NumPlayers > 0 )
	{
		if( ++PlayerIndex >= NumPlayers ) PlayerIndex = 0;
		Focus = PlayerList[PlayerIndex];
	}
}

//------------------------------------------------------------------------------
simulated exec function SCPrevPlayer()
{
	if( NumPlayers > 0 )
	{
		if( --PlayerIndex < 0 ) PlayerIndex = NumPlayers - 1;
		Focus = PlayerList[PlayerIndex];
	}
}

//------------------------------------------------------------------------------
simulated exec function SCNextNPC()
{
	if( NumNPCs > 0 )
	{
		if( ++NPCIndex >= NumNPCs ) NPCIndex = 0;
		Focus = NPCList[NPCIndex];
	}
}

//------------------------------------------------------------------------------
simulated exec function SCPrevNPC()
{
	if( NumNPCs > 0 )
	{
		if( --NPCIndex < 0 ) NPCIndex = NumNPCs - 1;
		Focus = NPCList[NPCIndex];
	}
}

//------------------------------------------------------------------------------
simulated exec function SCRefresh()
{
	InitPlayerList();
	InitNPCList();
}

//------------------------------------------------------------------------------
simulated exec function SCFollow()
{
	bUseFollowCam = !bUseFollowCam;
}

////////////////////
// Initialization //
////////////////////

//------------------------------------------------------------------------------
simulated function InitPlayerList()
{
	local Pawn IterP;
	local int i;

	foreach AllActors( class'Pawn', IterP )
		if( IterP.bIsPlayer && i < ArrayCount(PlayerList) )
			PlayerList[i++] = IterP;

	NumPlayers = i;
	
	while( i < ArrayCount(PlayerList) )
		PlayerList[i++] = None;

	PlayerIndex = 0;
}

//------------------------------------------------------------------------------
simulated function InitNPCList()
{
	local Pawn IterP;
	local int i;

	foreach AllActors( class'Pawn', IterP )
		if( !IterP.bIsPlayer && i < ArrayCount(NPCList) )
			NPCList[i++] = IterP;
	
	NumNPCs = i;

	while( i < ArrayCount(NPCList) )
		NPCList[i++] = None;

	NPCIndex = 0;
}

///////////
// Logic //
///////////

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local CameraPoint CP;
	local vector Ignored;

	// Can we say, blek?!!

	if( bOn )
	{
		if( Viewer.ViewTarget == Self )
		{
			if( Viewer.Health <= 0 )
			{
				UnPosses( Viewer );
			}

			if( Focus != None )
			{
				if( Viewer != None )
				{
					if( !bUseFollowCam )
					{
						CurrentCamera = GetBestCamera( Focus );
							
						if( CurrentCamera != None )
						{
							SetLocation( CurrentCamera.Location );
							SetRotation( rotator(Focus.Location - Location) );

							LastCameraLocation = Location;
						}
						else
						{
							// We can't see the player from any camera, follow him instead.
							CalcFollowPosition();
						}
					}
					else
					{
						CalcFollowPosition();
					}

					// Move view to our position so we can correctly hear sounds.
					if( !bMaintainLocation && !bCollideActors )
					{
						//Viewer.SetLocation( Location );
						//Viewer.SetRotation( Rotation );
					}
				}
				else
				{
					Destroy();
				}
			}
			else
			{
				UnPosses( Viewer );
				Destroy();
			}
		}
		else
		{
			bOn = false;
			Viewer = None;
			bMaintainLocation = default.bMaintainLocation;
		}
	}

	Super.Tick( DeltaTime );
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
// Returns the closest camera that can see aFocus, if any.
//------------------------------------------------------------------------------
simulated function CameraPoint GetBestCamera( Actor aFocus )
{
	local CameraPoint IterC, ClosestC;
	local float ClosestDist, Dist;

	// Throw out old camera if we can't see aFocus.
	if( CurrentCamera != None && !UnObstructed( CurrentCamera.Location, aFocus.Location ) )
	{
		CurrentCamera = None;
	}

	if( CurrentCamera != None )
	{
		ClosestC = CurrentCamera;
		ClosestDist = VSize(aFocus.Location - ClosestC.Location);
		foreach RadiusActors( class'CameraPoint', IterC, ClosestDist, ClosestC.Location )
		{
			Dist = VSize(aFocus.Location - IterC.Location);
			if( Dist < ClosestDist && UnObstructed( IterC.Location, aFocus.Location )  )
			{
				ClosestC = IterC;
				ClosestDist = Dist;
			}
		}
	}
	else
	{
		foreach AllActors( class'CameraPoint', IterC )
		{
			Dist = VSize(aFocus.Location - IterC.Location);
			if( ClosestC == None && UnObstructed( IterC.Location, aFocus.Location ) )
			{
				ClosestC = IterC;
				ClosestDist = VSize(aFocus.Location - ClosestC.Location);
			}
			else if( Dist < ClosestDist && UnObstructed( IterC.Location, aFocus.Location ) )
			{
				ClosestC = IterC;
				ClosestDist = Dist;
			}
		}
	}

	return ClosestC;
}

//------------------------------------------------------------------------------
// Checks to see if there is any geometry between Source and Dest.
// Note: This is excessivly slow.
//------------------------------------------------------------------------------
simulated function bool UnObstructed( vector Source, vector Dest )
{
	local vector Ignored;
	return (Trace( Ignored, Ignored, Dest, Source, false ) == None);
}

//------------------------------------------------------------------------------
// FollowCam code -- this needs to be rewritten.
//------------------------------------------------------------------------------
simulated function CalcFollowPosition()
{

	local vector View, HitLocation, HitNormal;
	local float DesiredDist;
	local Actor HitActor;
	local vector DesiredCameraLocation, diff;
	local rotator CameraRotation;
	local vector CameraLocation;
	local float EyeHeight;

	if( Pawn(Focus) != None )
	{
		CameraRotation = Pawn(Focus).ViewRotation;
		EyeHeight = Pawn(Focus).BaseEyeHeight;
	}
	else
	{
		CameraRotation = Focus.Rotation;
		EyeHeight = 0.0;
	}

	View = vect(1,0,0) >> CameraRotation;

	DesiredCameraLocation = Focus.Location + FollowCamOffset.x * View + FollowCamOffset.z * vect(0,0,1);
		
	diff = DesiredCameraLocation - LastCameraLocation;
	LastCameraLocation += diff/FollowCamSpeedFactor;
		
	CameraLocation = LastCameraLocation;
		
	CameraRotation = rotator( Focus.Location + 48 * View + EyeHeight * vect(0,0,1) - CameraLocation );
		
	// Don't go thru walls.
	HitActor = Trace( HitLocation, HitNormal, CameraLocation, Focus.Location, false );
	if( HitActor != None )
	{
		CameraLocation = HitLocation;
	}

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
     bMaintainLocation=True
     FollowCamSpeedFactor=2.500000
     FollowCamOffset=(X=-140.000000,Z=80.000000)
     bAmbientGlow=False
     PickupMessage="SpectatorCamera installed"
     ItemName="SpectatorCamera"
     bHidden=True
     bIsItemGoal=False
     AmbientGlow=0
     bGameRelevant=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bCollideActors=False
}
