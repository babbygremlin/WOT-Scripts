//=============================================================================
// Key.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================
class Key expands Inventory;

#exec AUDIO IMPORT FILE=Sounds\Notification\KeyDrop.wav	    GROUP=Keys
#exec AUDIO IMPORT FILE=Sounds\Notification\KeyPickup.wav	GROUP=Keys

var() localized string KeyPickupMessage;
var() float KeyMessageDuration;

var() Sound DropSound;

var ELightType InitialLightType;

auto state Pickup
{
	// When touched by an actor.
	function Touch( actor Other )
	{
		// If touched by a player pawn, let him pick this up.
		if( ValidTouch(Other) )
		{
			if( WOTPlayer(Other) != None )
			{
				WOTPlayer(Other).HandMessage( KeyPickupMessage, KeyMessageDuration );
			}
		}

		Super.Touch( Other );
	}

	// Landed on ground.
	function Landed(Vector HitNormal)
	{
		local rotator newRot;
		newRot = Rotation;
		newRot.pitch = 0;
		SetRotation(newRot);
//begin:NEW
		if( bRotatingPickup )
		{
			SetPhysics( PHYS_Rotating );
		}
//end:NEW
		SetTimer(2.0, false);
	}
}

function PreBeginPlay()
{
	Super.PreBeginPlay();
	InitialLightType = LightType;

	// make sure won't get destroyed if hit by mover
	SetOwner( Level );
}

function BecomePickup()
{
	Super.BecomePickup();
	PlaySound( DropSound );
	LightType = InitialLightType;
}

function BecomeItem()
{
	Super.BecomeItem();
	LightType = LT_None;
}

defaultproperties
{
     KeyPickupMessage="You got the key"
     KeyMessageDuration=1.500000
     DropSound=Sound'WOT.Keys.KeyDrop'
     bDisplayableInv=True
     PickupMessage=""
     PickupSound=Sound'WOT.Keys.KeyPickup'
     bTravel=False
     DrawScale=1.500000
     CollisionRadius=28.000000
     CollisionHeight=16.000000
     LightType=LT_SubtlePulse
     LightEffect=LE_NonIncidence
     LightBrightness=128
     LightHue=144
     LightSaturation=64
     LightRadius=1
     LightPeriod=64
}
