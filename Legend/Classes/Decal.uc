//------------------------------------------------------------------------------
// Decal.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 8 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
// + Make sure you add a DecalManager to your level.
//------------------------------------------------------------------------------
// How this class works:
//------------------------------------------------------------------------------
class Decal expands Actor;
//	native;

#exec MESH IMPORT MESH=DecalTRI ANIVFILE=MODELS\DecalTRI_a.3d DATAFILE=MODELS\DecalTRI_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=DecalTRI X=0 Y=0 Z=0 Pitch=0 Yaw=0 Roll=0

#exec MESH SEQUENCE MESH=DecalTRI SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JDecalTRI0 FILE=MODELS\DecalTRI.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=DecalTRI MESH=DecalTRI
#exec MESHMAP SCALE MESHMAP=DecalTRI X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=DecalTRI NUM=0 TEXTURE=JDecalTRI0

var() float MinLifeSpan, MaxLifeSpan;
var() float MinimumSize;	// Smallest size of decal.
var() int   MaxNumAttempts;	// Default number of times to try before failing to place.
var() float RetryScale;		// Must be a positive number less than one.
var   float TraceDist;		// How far are we allowed to be off the ground?
var   float EdgeRadius;		// Set this to the collision radius.
var() float SeperationDist;	// How far off the ground we are placed.

var() name ManagerTag;		// Tag of the manager to use.

////////////////////
// Initialization //
////////////////////

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	LifeSpan = RandRange( MinLifeSpan, MaxLifeSpan );
}

///////////////////
// Notifications //
///////////////////

//------------------------------------------------------------------------------
simulated function HitWall( vector HitNormal, Actor HitWall )
{
	Align( HitNormal );
}

//------------------------------------------------------------------------------
simulated function Landed( vector HitNormal )
{
	Align( HitNormal );
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
// Used to register a Decal (usually Self) with the DecalManager (stored 
// internally as a static pointer).
//
// If no DecalManager is currently assigned, we will search the level for one
// and use the first one we find whose tag matches 'DecalMan'.
//
// If no DecalManager is found, we will create one and use it.
//
// Returns true if successful.
//------------------------------------------------------------------------------
/* DEPRICATED
native(1002) final function bool Register( Actor Decal );
*/

//------------------------------------------------------------------------------
// Kept seperate in case you want to override and handle this differently.
//------------------------------------------------------------------------------
simulated function AttemptRegistration()
{
	local DecalManager Manager;

	Manager = DecalManager(class'Singleton'.static.GetInstance( XLevel, class'DecalManager', ManagerTag ));

	if( Manager != None )
	{
		if( !Manager.AddDecal( Self ) )
		{
			//warn( "Failed to register with "$Manager$"("$Manager.Tag$")" );	// This will always happen the first time due to the use of a RenderIterator.
			Destroy();
		}
	}
	else
	{
		//warn( "Couldn't find appropriate DecalManager." );
		Destroy();
	}

/* DEPRICATED
	if( !Register( Self ) )
	{
		Destroy();
	}
*/
}

//------------------------------------------------------------------------------
simulated function Align( vector Normal, optional int NumAttempts )
{
	local vector X, Y, Z;
	local vector XPos, YPos, ZPos;
	local float Width;
	local vector Start[4], Ignored, HitLocation;
	local Actor HitActor;
	local int i;
	local rotator Rot;

	//log( Self$"::Align()" );

	// Default to a virtually infinite number of tries.
	if( NumAttempts == 0 )
	{
		NumAttempts = MaxNumAttempts;
	}

	// Make sure we are flush and have the correct normal.
	if( Trace( HitLocation, Normal, Location - (Normal * 16.0), Location, false ) != None )
	{
		SetLocation( HitLocation + SeperationDist * Normal );
				
		// Adjust rotation.
		Rot = rotator(Normal);
		Rot.Roll = FRand() * 0x10000;	// 0 to 360 degrees.
		SetRotation( Rot );
		GetAxes( Rotation, X, Y, Z );
		XPos = TraceDist * X;

		// Try to fit.
		while( NumAttempts > 0 )
		{
			Width = default.EdgeRadius * DrawScale;
			if( Width < MinimumSize )
			{
				break;
			}

			ZPos = Width * Z;
			YPos = Width * Y;

			// Trace the four corners.
			Start[0] = Location + ZPos + YPos;
			Start[1] = Location + ZPos - YPos;
			Start[2] = Location - ZPos + YPos;
			Start[3] = Location - ZPos - YPos;

			for( i = 0; i < ArrayCount(Start); i++ )
			{
				HitActor = Trace( Ignored, Ignored, Start[i] - XPos, Start[i], false );
				if( HitActor == None || HitActor.IsA('Mover') || HitActor.IsA('BlockAll') )
				{
					// Can't touch the ground, or is touching a mover.
					//log( Self$"("$NumAttempts$") Trace("$i$") failed." );
					break;
				}
				//log( Self$"("$NumAttempts$") Trace("$i$") succeeded." );
			}

			// All four points hit ground... we are good to go.
			if( i == ArrayCount(Start) )
			{
				SetPhysics( PHYS_None );
				bHidden = false;
				AttemptRegistration();
				return;
			}

			// Try again.
			NumAttempts -= 1;
			DrawScale *= RetryScale;
		}
	}

	// If we get here, it means we didn't fit, and don't deserve to live.
	Destroy();
}

defaultproperties
{
     MinLifeSpan=180.000000
     MaxLifeSpan=300.000000
     MinimumSize=5.000000
     MaxNumAttempts=10
     RetryScale=0.850000
     TraceDist=5.000000
     EdgeRadius=30.000000
     SeperationDist=1.000000
     ManagerTag=DecalMan
     bHidden=True
     bNetTemporary=True
     Physics=PHYS_Falling
     RemoteRole=ROLE_None
     bDirectional=True
     DrawType=DT_Mesh
     Style=STY_Modulated
     Texture=None
     Mesh=Mesh'Legend.DecalTRI'
     bUnlit=True
     VisibilityRadius=2000.000000
     VisibilityHeight=2000.000000
     bGameRelevant=True
     CollisionRadius=0.100000
     CollisionHeight=0.100000
     bCollideWorld=True
}
