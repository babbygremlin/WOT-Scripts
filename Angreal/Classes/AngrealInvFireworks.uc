//------------------------------------------------------------------------------
// AngrealInvFireworks.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	Fires fireworks.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvFireworks expands ProjectileLauncher;

defaultproperties
{
    ProjectileClassName="Angreal.AngrealFireworksProjectile"
    bElementFire=True
    bCommon=True
    bOffensive=True
    bCombat=True
    MinInitialCharges=10
    MaxInitialCharges=20
    Title="Fireball"
    Description="None"
    Quote="None"
    StatusIconFrame=Texture'Icons.M_Fireball'
    InventoryGroup=51
    PickupMessage="You got the Fireworks Ter'angreal"
    PickupViewMesh=Mesh'AngrealFireballPickup'
    StatusIcon=Texture'Icons.I_Fireball'
    Mesh=Mesh'AngrealFireballPickup'
    DrawScale=1.30
}
