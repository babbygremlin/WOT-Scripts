//=============================================================================
// Pit.uc
//=============================================================================
class Pit expands Trap;

#exec MESH IMPORT MESH=Pit ANIVFILE=MODELS\Pit\TrapPit_a.3D DATAFILE=MODELS\Pit\TrapPit_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Pit X=0 Y=-28 Z=0 YAW=64 ROLL=128
#exec MESH SEQUENCE MESH=Pit SEQ=Waiting  STARTFRAME=0   NUMFRAMES=1

#exec TEXTURE IMPORT NAME=TrapPit FILE=MODELS\Pit\TrapPit.PCX GROUP=Skins

#exec MESHMAP NEW   MESHMAP=Pit MESH=Pit
#exec MESHMAP SCALE MESHMAP=Pit X=0.2 Y=0.2 Z=0.4
#exec MESHMAP SETTEXTURE MESHMAP=Pit NUM=5 TEXTURE=TrapPit

var PitTrap ThePitTrap;

function PreBeginPlay()
{
	local PitOpening ThePitOpening;

	ThePitTrap = Spawn( class'PitTrap' );
	if( ThePitTrap != None )
	{
		ThePitTrap.SetOwner( Self ); 
		ThePitTrap.Hide(); 

		// find an unused PitOpening
		foreach AllActors( class 'PitOpening', ThePitOpening ) 
		{
			if( ThePitOpening.ThePitTrap == None ) 
			{
				ThePitOpening.ThePitTrap = ThePitTrap;
				ThePitTrap.ThePitOpening = ThePitOpening;

				ThePitOpening.SetOwner( Self );

				break;
			}
		}

		if( ThePitTrap.ThePitOpening == None ) 
		{
			ThePitTrap.Destroy();
			ThePitTrap = None;
			PlayerPawn(Owner).ClientMessage( "Error: No pits are available." );
		}
	}

	Super.PreBeginPlay();
}

function InitSinglePlayer()
{
	ThePitTrap.SetLocation( Location );	
	ThePitTrap.SetRotation( Rotation );
	SetCollision( false, false, false );
}

function Destroyed()
{
	if( ThePitTrap != None ) 
	{
		ThePitTrap.Destroy();
	}
	Super.Destroyed();
}

function bool ApproxEq(float f1, float f2)
{
	if( abs( f1 - f2 ) <= 0.03 ) 
	{
		return true;
	}
	else 
	{
		return false;
	}
}

function actor AnyActorsInArea( vector SearchLocation, int SearchDistance )
{
	local Mover M;
	local vector Delta;

	foreach RadiusActors( class'Mover', M, 512, SearchLocation ) //hacked to "far, but not too far"
	{
		Delta = SearchLocation - M.RealPosition;
		Delta.Z = 0;
		if( VSize( Delta ) < 120 ) //hacked to "about the right distance" for the maps
		{
			return M;
		}
	}

	return Super.AnyActorsInArea( SearchLocation, SearchDistance );
}

function bool CalcLocation( out vector HitLocation, out vector HitNormal )
{
	local float	PitRadius;
	local vector x, y, z,
				TestPoint,
				TraceHit,
				TraceNormal,
				TraceEnd;
	local actor Other;
	local int i, j;
	local bool Success;

	Success = false;
	Hide();

	if( HitNormal.Z < 0.95 ) 
	{
		goto ReturnLabel;
	}
	// Make sure the pit doesn't hang over an edge
	// Try corners, conter points of sides, and center of pit
	GetAxes( rotator( HitNormal ), x, y, z);

	PitRadius = class'PitTrap'.default.TrapRadius;

	// Now make sure you can go from center to edges
	for( i = -1; i <= 1; i++ ) 
	{
		for( j = -1; j <= 1; j++ ) 
		{
			TestPoint = HitLocation;
			TraceEnd  = HitLocation + PitRadius	* ( y * i + z * j );

			Other = Trace( TraceHit, TraceNormal, TraceEnd, TestPoint, true );
			if( ( Other == Level ) ) 
			{
				goto ReturnLabel;
			}
		}
	}

	Success = true;

ReturnLabel:
	Show();

	return Success;
}

function bool DeployResource( vector HitLocation, vector HitNormal )
{
	if( ThePitTrap == None ) 
	{
		return false;
	}

	if( !CalcLocation( HitLocation, HitNormal ) ) 
	{
		return false;
	}
	if( AnyActorsInArea( HitLocation, SeparationDistance ) != None ) 
	{
		return false;
	}

	ThePitTrap.SetLocation( HitLocation );	
	ThePitTrap.SetRotation( rotator( HitNormal ) );

	SetLocation( HitLocation );
	SetRotation( rotator( HitNormal ) );

	return ValidateTrap();
}

function BeginEditingResource( int PlacedByTeam )
{
	Super.BeginEditingResource( PlacedByTeam );
	SetCollision( true, false, false );
	ThePitTrap.Hide();
}

function EndEditingResource()
{
	Super.EndEditingResource();
	SetCollision( false, false, false );
	ThePitTrap.Show();
}

function bool IsInactive( actor Other )
{
	if( Other != None && Other.IsA( 'Seal' ) )
		return true;

	return Super.IsInactive( Other );
}

//end of Pit.uc

defaultproperties
{
     SeparationDistance=100
     TrapRadius=48
     DrawType=DT_Mesh
     Style=STY_Modulated
     Mesh=Mesh'WOTTraps.Pit'
     CollisionRadius=50.000000
     CollisionHeight=12.000000
}
