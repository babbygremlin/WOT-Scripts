//=============================================================================
// MyrddraalSwordAngreal.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class MyrddraalSwordAngreal expands AngrealInventory;

// class for stubbing in icons for myrddraal's lingering damage effect

// never want this visible, pickupable
function BecomePickup();

//=============================================================================

defaultproperties
{
     bElementSpirit=True
     StatusIconFrame=Texture'WOTPawns.UI.M_SMyrddraal'
     bRotatingPickup=False
     PickupMessage="WARNING: You found a MyrddraalSwordAngreal!"
     bHidden=True
     bCanTeleport=False
     bIsItemGoal=False
     RemoteRole=ROLE_DumbProxy
     DrawType=DT_Sprite
     Texture=Texture'Engine.S_Actor'
     AmbientGlow=0
     bCollideActors=False
}
