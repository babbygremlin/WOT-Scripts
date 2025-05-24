//------------------------------------------------------------------------------
// AngrealInvDistantEye.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 10 $
//
// Description:	Drop it.  When activated, caster can see through it.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvDistantEye expands AngrealInventory;

#exec MESH IMPORT MESH=AngrealDistantEyePickup ANIVFILE=models\AngrealDistantEye_a.3D DATAFILE=models\AngrealDistantEye_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AngrealDistantEyePickup X=0 Y=0 Z=0 ROLL=32 
#exec MESH SEQUENCE MESH=AngrealDistantEyePickup SEQ=All       STARTFRAME=0   NUMFRAMES=2
#exec TEXTURE IMPORT NAME=JAngrealDistantEye1 FILE=models\AngrealDistantEye.PCX GROUP=Skins FLAGS=2
#exec MESHMAP NEW   MESHMAP=AngrealDistantEyePickup MESH=AngrealDistantEyePickup
#exec MESHMAP SCALE MESHMAP=AngrealDistantEyePickup X=0.04 Y=0.04 Z=0.08
#exec MESHMAP SETTEXTURE MESHMAP=AngrealDistantEyePickup NUM=4 TEXTURE=JAngrealDistantEye1

#exec AUDIO IMPORT FILE=Sounds\DistantEye\DropDE.wav		GROUP=DistantEye
#exec AUDIO IMPORT FILE=Sounds\DistantEye\ActivateDE.wav	GROUP=DistantEye
#exec AUDIO IMPORT FILE=Sounds\DistantEye\DeactivateDE.wav	GROUP=DistantEye

#exec TEXTURE IMPORT FILE=Icons\I_DistantEye.pcx        GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_DistantEye.pcx        GROUP=Icons MIPS=Off

// reference to the dropped eye
var	AngrealDistantEyeProjectile Eye;

// Where the eye is placed relative to the castor.
var() vector SpawnOffset;

// Sound played when the holder drops us.
var(Inventory) Sound DropSound;	// NOTE[aleiby]: Maybe move this to a superclass.

var vector InitialOwnerLocation;
var() float MovementTolerance;
var bool bActive;

//-----------------------------------------------------------------------------
function Cast()
{
	// if we haven't yet placed the eye, place it.
	if( Eye == None )
	{
		// Play sound, but don't display icon.
		ActivateSound = DropSound;
		Super.Cast();
		ActivateSound = default.ActivateSound;
		ActivateSoundName = default.ActivateSoundName;

		// Don't play deactivate sound or remove icon on release of mouse button.
		DeactivateSound = None; 

		Eye = Spawn( class'AngrealDistantEyeProjectile',,, Owner.Location + (SpawnOffset >> Pawn(Owner).ViewRotation), Pawn(Owner).ViewRotation );
		Eye.SetSourceAngreal( Self );
	}
	// Otherwise toggle between the player view and the distant eye view.
	else 
	{
		if( PlayerPawn(Owner).ViewTarget == None )
		{
			// Play acivation sound and add icon.
			ActivateSound = default.ActivateSound;
			ActivateSoundName = default.ActivateSoundName;
			Super.Cast();

			// Don't play deactivate sound or remove icon on release of mouse button.
			DeactivateSound = None;
			
			PlayerPawn(Owner).ViewTarget = Eye;
			PlayerPawn(Owner).ViewRotation = Eye.Rotation;	// NOTE[aleiby]: Use function call to set on client-side (like SwapPlaces, Whirlwind, etc).
			Eye.Open();

			InitialOwnerLocation = Owner.Location;
			bActive = true;
		}
/* -- Move to OnOwnerMove();
		else
		{
			// Play deactivate sound and remove icon.
			DeactivateSound = default.DeactivateSound;
			DeactivateSoundName = default.DeactivateSoundName;
			Super.UnCast();

			// Don't play deactivate sound or remove icon on release of mouse button.
			DeactivateSound = None;

			PlayerPawn(Owner).ViewTarget = None;
			Eye.Close();
			UseCharge();

			bActive = false;
		}
*/
	}
}

//-----------------------------------------------------------------------------
function UnCast();	// Don't call super.

//------------------------------------------------------------------------------
function Reset()
{
	// Don't call Super.Reset();

	OnOwnerMove();
	
	if( Eye != None )
	{
		Eye.Destroy();
		Eye = None;
	}
}

//-----------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if(	bActive && Owner != None && VSize(InitialOwnerLocation -  Owner.Location) > MovementTolerance )
	{
		OnOwnerMove();
	}
}

//-----------------------------------------------------------------------------
// Called when our Owner moves more than MovementTolerance units 
// while we are active.
//-----------------------------------------------------------------------------
function OnOwnerMove()
{
	if( bActive )
	{
		// Play deactivate sound and remove icon.
		DeactivateSound = default.DeactivateSound;
		DeactivateSoundName = default.DeactivateSoundName;
		Super.UnCast();

		// Don't play deactivate sound or remove icon on release of mouse button.
		DeactivateSound = None;

		PlayerPawn(LastOwner).ViewTarget = None;
		Eye.Close();
//		UseCharge();	-- moved to eye's destruction.

		bActive = false;
	}
}

//-----------------------------------------------------------------------------
function NotifyEyeDestroyed()
{
	OnOwnerMove();
	Eye = None;
}

/*
//-----------------------------------------------------------------------------
// Called when we run out of charges.  
//-----------------------------------------------------------------------------
function GoEmpty()
{
	if( Eye != None )
	{
		PlayerPawn(Owner).ViewTarget = None;
		Eye.Destroy();
		Eye = None;		// Just in case.
	}

	Super.GoEmpty();
}
*/
//-----------------------------------------------------------------------------
// Called when our Owner drops us.
//-----------------------------------------------------------------------------
function DropFrom( vector StartLocation )
{
	Dropped();
	Super.DropFrom( StartLocation );
}

//-----------------------------------------------------------------------------
function NotifyPutInBag( BagHolding Bag )
{
	Dropped();
	Super.NotifyPutInBag( Bag );
}

//-----------------------------------------------------------------------------
function Dropped()
{
	OnOwnerMove();

	if( Eye != None )
	{
		PlayerPawn(LastOwner).ViewTarget = None;	// Just in case.
		Eye.Destroy();
		Eye = None;								// Just in case.
	}

//	PlaySound( DropSound );
}

//-----------------------------------------------------------------------------
function float GetDuration()
{
	return 1.0;
}

defaultproperties
{
    SpawnOffset=(X=48.00,Y=0.00,Z=96.00),
    DropSound=Sound'DistantEye.DropDE'
    MovementTolerance=10.00
    bElementAir=True
    bElementEarth=True
    bCommon=True
    bCombat=True
    bInfo=True
    MinInitialCharges=3
    MaxInitialCharges=7
    MaxCharges=10
    ActivateSoundName="Angreal.ActivateDE"
    DeActivateSoundName="Angreal.DeactivateDE"
    MinChargeGroupInterval=10.00
    Title="Distant Eye"
    Description="Activating Distant Eye fixes its location. Dropping the ter'angreal causes it to @forget@ its initial location. After placement, a subsequent activation allows you to look through the Eye¾to see whatever it sees¾as long as you remain still.  Invoking the Eye while using it fires a stream of Darts at whatever the eye is trained on."
    Quote="As though thinking of the oddities triggered one of them, a patch of sky against the mountains darkened suddenly, became a window to somewhere else."
    StatusIconFrame=Texture'Icons.M_DistantEye'
    InventoryGroup=58
    PickupMessage="You got the Distant Eye ter'angreal"
    PickupViewMesh=Mesh'AngrealDistantEyePickup'
    PickupViewScale=0.70
    StatusIcon=Texture'Icons.I_DistantEye'
    Mesh=Mesh'AngrealDistantEyePickup'
    DrawScale=0.70
}
