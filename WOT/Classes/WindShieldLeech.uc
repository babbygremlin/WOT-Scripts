//------------------------------------------------------------------------------
// WindShieldLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	A screen that remains in front of the host and act as a 
//				wind shield of sort in that the player can see through it,
//				but you can still draw stuff on it for cool effects.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn (or subclass) it.
// + Set it's Skin.
// + Optionally set its lifespan.
// + Attach it to a WOTPlayer.
//------------------------------------------------------------------------------
class WindShieldLeech expands Leech;

#exec MESH IMPORT MESH=WindShield ANIVFILE=MODELS\WindShield_a.3d DATAFILE=MODELS\WindShield_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=WindShield X=0 Y=0 Z=0 Yaw=-64

#exec MESH SEQUENCE MESH=WindShield SEQ=All        STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=WindShield MESH=WindShield
#exec MESHMAP SCALE MESHMAP=WindShield X=0.1 Y=0.1 Z=0.2

var() vector ViewOffset;	// Draw offset for the windshield (from Z BaseEyeHeight units above the host's location).

var() rotator RotRate;

///////////////
// Overrides //
///////////////

//------------------------------------------------------------------------------
function AttachTo( Pawn NewHost )
{
	if( PlayerPawn(NewHost) != None )
	{
		Super.AttachTo( NewHost );

		AdjustLocation( PlayerPawn(Owner) );
	}
}

///////////////////
// Notifications //
///////////////////

//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	AdjustLocation( PlayerPawn(Owner) );
	//SetRotation( Rotation + RotRate * DeltaTime );
	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
function AffectHost( optional int Iterations )
{
	if( Pawn(Owner) == None || Pawn(Owner).Health <= 0 )
	{
		Destroy();
	}
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
function AdjustLocation( PlayerPawn Source )
{
	//SetLocation( Source.Location + (vect(0,0,1) * PlayerPawn(Owner).BaseEyeHeight) + (ViewOffset >> Source.ViewRotation) );
	//SetRotation( Source.ViewRotation );

	SetLocation( Source.Location + (vect(0,0,1) * PlayerPawn(Owner).BaseEyeHeight) );
	//SetRotation( Source.Rotation );
}

defaultproperties
{
     ViewOffset=(X=5.000000)
     RotRate=(Pitch=50000)
     AffectResolution=0.200000
     bHidden=False
     DrawType=DT_Mesh
     Style=STY_Modulated
     Mesh=Mesh'WOT.WindShield'
     DrawScale=0.300000
     ScaleGlow=0.200000
     bUnlit=True
     bOnlyOwnerSee=True
}
