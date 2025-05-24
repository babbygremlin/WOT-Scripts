//=============================================================================
// Wall.uc
// $Author: Jcrable $
// $Date: 10/13/99 5:52p $
// $Revision: 6 $
//=============================================================================
class Wall expands Trap;

var class<WallSlab>	SlabClass;
var (Wall) int		MaxSlabs;		// max number of slabs allowed
var (Wall) bool		NorthSouth;		// Does the wall run NorthSouth
var (Wall) int		FloorTolerance; // How much can the floor vary in height?
var vector			Floor;			// coord of floor
var vector			WallStop;		// coord of far side of wall

function InitSinglePlayer()
{
	local rotator	StartRotation;
	local vector	StartLocation;
	local vector	StartNormal;
    local vector    HitLocation;
    local vector    HitNormal;
    local vector    EndTrace;
    local Actor     Other;

	if( NorthSouth ) 
	{
		StartNormal = Normal( vector( Rotation ) );
		StartNormal.Z = 0;
	} 
	else 
	{
		StartRotation = Rotation;
		StartRotation.Yaw += 16384;
		StartNormal = Normal( vector( StartRotation ) );
		StartNormal.Z = 0;
	}
	// Make sure this is really the level, not another wall
	EndTrace = Location + TraceDistance * StartNormal;
	Other = Trace( HitLocation, HitNormal, EndTrace, Location, true );

	SetLocation( HitLocation );
	DeployResource( Location, HitNormal );
}

function Hide()
{
	local WallSlab W;

	// Self.bHidden is always true
	foreach AllActors( class 'WallSlab', W ) 
	{
		if( W.Owner == Self )
		{
			W.Hide();
			W.SetCollision( false, false, false );
		}
	}
}

function Show()
{
	local WallSlab W;

	// Self.bHidden is always true
	foreach AllActors( class 'WallSlab', W ) 
	{
		if( W.Owner == Self )
		{
			W.Show();
			W.SetCollision( W.default.bCollideActors, W.default.bBlockActors, W.default.bBlockPlayers );
		}
	}
}

function bool CalcLocation( out vector StartLocation, out vector StartNormal )
{
    local vector    HitLocation;
    local vector    HitNormal;
    local vector    EndTrace;
    local Actor     Other;
	local vector	SlabLocation;
	local int		Width;
	local int		SlabWidth;
    local int       NumSlabs;
	local int		i;

	// make sure the normal vector is horizontal
	if( StartNormal.Z != 0.0 ) 
	{
		return false;
	}

	// Make sure this is really the level, not another wall
	EndTrace = StartLocation + TraceDistance * StartNormal;
	Other = Trace( HitLocation, HitNormal, EndTrace, StartLocation, true );

	if( Other != Level ) 
	{
		return false;
	}

	// first trace down to floor.  if we hit anything other than floor, wall is not allowed
	// (you don't want to cover another trap for instance)
	EndTrace = StartLocation + TraceDistance * vect(0, 0, -1);
	Other = Trace( HitLocation, HitNormal, EndTrace, StartLocation, true );

	if( Other != Level ) 
	{
		return false;
	}

	StartLocation = HitLocation;

	// trace across the room
	EndTrace = StartLocation + TraceDistance * StartNormal;
	Other = Trace( HitLocation, HitNormal, EndTrace, StartLocation, true );

	if( Other != Level ) 
	{
		return false;
	}

	Floor = StartLocation;
	WallStop = HitLocation;
	WallStop.z = Floor.z;

	Width = VSize( Floor - WallStop );

	// Now let's check the height for each of the slabs and find the lowest point
	SlabWidth = SlabClass.default.SlabWidth;
	NumSlabs = Width / SlabWidth + 1;
	if( NumSlabs > MaxSlabs ) 
	{
		return false;
	}

	SlabLocation = StartLocation + ( SlabWidth / 2 ) * StartNormal;

	for( i = 0; i < NumSlabs; i++ )
	{
		SlabLocation = SlabLocation + StartNormal * SlabWidth;

		EndTrace = SlabLocation + TraceDistance * vect(0, 0, -1);
		Other = Trace( HitLocation, HitNormal, EndTrace, SlabLocation, true );

		if( Other != Level && !SameLogicalActor( Other ) ) 
		{
			return false;
		}
		// If the floor doesn't match, doesn't use it.
		if( Other == Level ) 
		{ 
			if( HitLocation.z < Floor.z - FloorTolerance ) 
			{
				return false;
			}
		}

		WallStop.z = min( WallStop.z, HitLocation.z );
	}

	StartLocation.z = WallStop.z + SlabClass.default.CollisionHeight / 2;

	return true;
}


function bool DeployResource( vector StartLocation, vector StartNormal )
{
    local vector    HitLocation;
    local vector    HitNormal;
    local vector    EndTrace;
	local vector	SpawnLocation;
    local Actor     Other;
	local int		Width;
	local int		SlabWidth;
    local vector    X, Y, Z;
    local int       NumSlabs;
	local WallSlab  Slab;
	local int		i;

	Hide();

	// StartLocation Changes...
	if( !CalcLocation( StartLocation, StartNormal ) ) 
	{
		return false;
	}

	SlabWidth = SlabClass.default.SlabWidth;
	
	Width = VSize( Floor - WallStop );
	NumSlabs = Width / SlabWidth + 1;
	if( NumSlabs > MaxSlabs ) 
	{
		return false;
	}

	// Even though the Wall itself isn't seen, its coordinates are used by the
	// Citadel Editing code to store where the trap should be placed.
	SetLocation( StartLocation );

	for( i=0; i < NumSlabs; i++ ) {
		// Use the floor, not the center of the wall slab, to account for pits too..
		if( AnyActorsInArea( Floor + ( SlabWidth / 2 + i * SlabWidth ) * StartNormal, SlabWidth ) != None ) 
		{
			return false;
		}
	}

	if( !ValidateTrap() )
	{
		return false;
	}

	SlabWidth = SlabClass.default.SlabWidth;

	SpawnLocation = StartLocation + ( SlabWidth / 2 ) * StartNormal;
    i = 0;

	// First use existing slabs
	foreach AllActors( class 'WallSlab', Slab ) 
	{
		if( Slab.Owner == Self )
		{
			if( i < NumSlabs ) 
			{
				Slab.Show();
				Slab.Skin = Slab.Stage1Texture;
				Slab.MoveTrap( SpawnLocation );
				Slab.SetRotation( GetSlabRotation( i, StartNormal ) );
				Slab.AmbientGlow = 64;

				SpawnLocation = SpawnLocation + StartNormal * SlabWidth;

				i++;
			}
		}
	}

	// Next create new slabs
	while( i < NumSlabs )
	{
    	Slab = spawn( SlabClass, Self, , SpawnLocation );
    	if( Slab == None )
		{
			return true;
		}

		Slab.Skin = Slab.Stage1Texture;
		Slab.SetRotation( GetSlabRotation( i, StartNormal ) );
		Slab.AmbientGlow = 64;
	
		SpawnLocation = SpawnLocation + StartNormal * SlabWidth;

		i++;
	}

	return ValidateTrap();
}

function rotator GetSlabRotation( int i, vector StartNormal )
{
	local rotator Rot;

	Rot = rotator( StartNormal );

	switch( i % 4 )
	{
	case 0:
		// do nothing
		break;
	case 1:
		Rot.Yaw += 16384;
		break;
	case 2:
		Rot.Yaw -= 16384;
		break;			
	case 3:
		Rot.Yaw += ( 2 * 16384 );
		break;
	} 
	
	Rot = Normalize( Rot );

	return Rot;
}

function bool RemoveResource()
{
	local WallSlab W;

	if( bLocked )
	{
		return false;
	}

	foreach AllActors( class 'WallSlab', W ) 
	{
		if( W.Owner == Self )
		{
			W.Hide();
		}
	}

	return Super.RemoveResource();
}

function Destroyed()
{
	local WallSlab W;

	foreach AllActors( class 'WallSlab', W ) 
	{
		if( W.Owner == Self )
		{
			W.Destroy();
		}
	}
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name damageType)
{
}

// end of Wall.

defaultproperties
{
     SlabClass=Class'WOTTraps.WallSlab'
     MaxSlabs=32
     NorthSouth=True
     FloorTolerance=100
     bHidden=True
     RemoteRole=ROLE_None
     bCollideActors=False
}
