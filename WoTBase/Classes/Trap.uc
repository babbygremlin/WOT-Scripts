//=============================================================================
// Trap.uc
//=============================================================================
class Trap expands Actor abstract;

#exec AUDIO IMPORT FILE=Sounds\DeployTrap.wav    GROUP=Editor
#exec AUDIO IMPORT FILE=Sounds\RemoveTrap.wav    GROUP=Editor

var() int 	 DamageAmount;			// how much damage to inflict
var() int	 HeightAboveFloor;
var() int	 SeparationDistance;	// distance between traps
var() int	 TrapRadius;			// how big is this thing? (collision size can't be used)
var() string ActivatingSoundName;   // sound of trap when activated
var() string ResetingSoundName; 	// sound of trap when reseting
var() string DamageSoundName;		// sound of trap when it takes damage
var() int	 TraceDistance;			// default tracedistance
var() name	 TrapType;				// Trap identifier -- used by TrapDetect.
var() bool	 bForceSinglePlayerInit;
var() name	 DestroyedEvent;		// event to be triggered when the trap is "destroyed"

var bool bEditing;	// Is the player editing?
var int Team;

var bool bLocked;	// set True by TutorialTrapTrigger to inhibit removal

function PreBeginPlay() 
{
	Super.PreBeginPlay();

	if( Level.NetMode == NM_Standalone )
	{
		assert( Level.Game != None );
		if( !bStatic && Level.Game.IsA( 'giMission' ) && ( !Level.Game.IsA( 'giTutorial' ) || bForceSinglePlayerInit ) )
		{
			InitSinglePlayer();
		}
	}
}

function DestroyedTrigger( actor Other, pawn EventInstigator )
{
	local Actor A;

	if( DestroyedEvent != '' )
	{
		foreach AllActors( class 'Actor', A, DestroyedEvent )
		{
			A.Trigger( Self, EventInstigator );
		}
	}
}

function InitSinglePlayer()
{
}

function Sound GetDeploySound()
{
	return Sound( DynamicLoadObject( "WOTBase.Editor.DeployTrap", class'Sound' ) );
}

function Sound GetRemoveSound()
{
	return Sound( DynamicLoadObject( "WOTBase.Editor.RemoveTrap", class'Sound' ) );
}

function BeginEditingResource( int PlacedByTeam )
{
	bEditing = true;
	Team = PlacedByTeam;
	AmbientGlow = 64;
}

function EndEditingResource()
{
	AmbientGlow = 0;
	bEditing = false;
}

function Actor GetBaseResource()
{
	return Self;
}

function actor AnyActorsInArea( vector SearchLocation, int SearchDistance )
{
	local Actor A;

	foreach RadiusActors( class'Actor', A, SearchDistance, SearchLocation ) 
	{
		if( !SameLogicalActor( A ) && !A.bHidden && A.bCollideActors ) //NEW 9/7/1999 fixed Tutorial trap placement by adding bCollideActors
		{
			return A;
		}
	}

	return None;
}

function bool CalcLocation( out vector StartLocation, out vector StartNormal )
{
	local vector 	StartTrace;
	local vector 	EndTrace;
	local vector 	x, y, z;
	local vector 	RightSide;
	local vector 	LeftSide;
	local vector 	TestPoint;
	local vector 	HitLocation;
	local vector 	HitNormal;
	local vector 	TempLocation;
	local Actor 	Other;
	local Trap 		SearchTrap;
	local rotator	TrapRotation;
	local bool      Success;

	Success = false;

	Hide();

	TrapRotation = rotator( StartNormal );	

	// trace down to the ground.
	StartTrace = StartLocation;
	EndTrace = StartTrace + TraceDistance * vect(0, 0, -1);
	Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, True);

	if( Other != Level )
	{
		goto ReturnLabel;
	}
	StartLocation = HitLocation;
	
	// update location to be off the floor
	GetAxes( TrapRotation, x, y, z );
	if( z.Z > 0.5) // if not on a floor, make sure it's high enough
	{
		StartLocation.Z += HeightAboveFloor;
	}

	// make sure trap isn't hanging in space
	StartTrace = StartLocation;
	EndTrace = StartTrace + TraceDistance * (-StartNormal);
	Other = Trace( HitLocation, HitNormal, EndTrace, StartTrace, True );
	if( Other == None )
	{
		goto ReturnLabel;
	}
	if( ( HitLocation.X != StartLocation.X ) || ( HitLocation.Y != StartLocation.Y ) )
	{
		goto ReturnLabel;
	}

	TempLocation  = StartLocation + 32 * (-StartNormal); // into the wall

	// make sure trap sides fit on wall
	RightSide = TempLocation + ( StartNormal cross vect( 0, 0,  1 ) ) * TrapRadius;
	LeftSide  = TempLocation + ( StartNormal cross vect( 0, 0, -1 ) ) * TrapRadius;
	
	TestPoint = TempLocation + 64 * StartNormal;
	Other = Trace( HitLocation, HitNormal, RightSide, TestPoint, True );
	if(Other == None || HitNormal != StartNormal )
	{
		goto ReturnLabel;
	}

	Other = Trace( HitLocation, HitNormal, LeftSide, TestPoint, True );
	if(Other == None || HitNormal != StartNormal )
	{
		goto ReturnLabel;
	}

	Success = true;

ReturnLabel:
	Show();

	return Success;
}

function bool ValidateTrap()
{
	local vector UpdatedLocation;
	local TutorialTrapTrigger T;

	// if this is the final placement of a trap (bOnlyOwnerSee == false)
	if( !bOnlyOwnerSee )
	{
		// in the tutorial, validate placement by polling all TutorialTrapTriggers
		if( Level.NetMode == NM_Standalone && Level.Game.IsA( 'giTutorial' ) )
		{
			foreach AllActors( class'TutorialTrapTrigger', T )
			{
				// only an active trigger can invalidate the placement (inactive triggers will always respond "OK")
				if( !T.Validate( Self, PlayerPawn(Owner) ) )
				{
					return false;
				}
			}
		}

		SetOwner( None );
	}

	return true;
}

function bool DeployResource( vector HitLocation, vector HitNormal )
{
	assert( true ); // implemented in sub-class -- return ValidateTraps() for tutorial traps
}

function bool RemoveResource()
{
	// check bLocked in sub-class implementation -- return false for bLocked tutorial traps

	Hide();
	return true;
}

/*
function Reset()
{
	// Do nothing - wall will override
}
*/

/*
// WallSlab, PortcullisMover, PitOpening, etc will override
function Actor GetBase()
{
	return Self;
}
*/

function bool SameLogicalActor( Actor Other )
{
	if( Self == Other ) 
	{
		return true;
	}

	if( Self == Other.Owner ) 
	{
		return true;
	}

	return Other.GetBaseResource() == GetBaseResource();
}

simulated function bool IsTrapDeployed()
{
	return true; // portcullis and stairs will override
}

function MoveTrap( vector NewLocation ) 
{
	SetLocation( NewLocation );
}

function DamageActor( actor Other ) 
{
	// Not implemented in the base class
}

function bool IsInactive( actor Other )
{
	if( bEditing )
	{
		return true;
	}

	// don't activate for players on the same team
	if( Pawn(Other) != None )
	{
		// to make this test based on server configuration, WOT, WOTTraps, and WOTBase must be collapsed
		return Team == Pawn(Other).PlayerReplicationInfo.Team;
	}

	return false;
}

function Hide()
{
	Super.Hide();
	SetCollision( false, false, false );
}

function Show()
{
	Super.Show();
	SetCollision( default.bCollideActors, default.bBlockActors, default.bBlockPlayers );
}

// end of Trap.

defaultproperties
{
     TraceDistance=1600
     Team=255
     bCollideActors=True
}
