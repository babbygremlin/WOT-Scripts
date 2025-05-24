//------------------------------------------------------------------------------
// AngrealInvRemoveCurse.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 6 $
//
// Description:	Stops any current artifact effect in radius, even permanent 
//				effects.  Does not regain lost charges.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvRemoveCurse expands LeechAttacher;

#exec MESH IMPORT MESH=AngrealRemoveCursePickup ANIVFILE=models\remcurse_a.3D DATAFILE=models\remcurse_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AngrealRemoveCursePickup X=0 Y=0 Z=0
#exec MESH SEQUENCE MESH=AngrealRemoveCursePickup SEQ=All       STARTFRAME=0   NUMFRAMES=2
#exec TEXTURE IMPORT NAME=JAngrealRemoveCurse1 FILE=models\remv.PCX GROUP=Skins FLAGS=2
#exec MESHMAP NEW   MESHMAP=AngrealRemoveCursePickup MESH=AngrealRemoveCursePickup
#exec MESHMAP SCALE MESHMAP=AngrealRemoveCursePickup X=0.04 Y=0.04 Z=0.08
#exec MESHMAP SETTEXTURE MESHMAP=AngrealRemoveCursePickup NUM=1 TEXTURE=JAngrealRemoveCurse1

#exec TEXTURE IMPORT FILE=Icons\I_RemoveCurse.pcx			GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_RemoveCurse.pcx			GROUP=Icons MIPS=Off

defaultproperties
{
    LeechClasses=Class'RemoveCurseLeech'
    bElementFire=True
    bElementWater=True
    bElementAir=True
    bElementEarth=True
    bElementSpirit=True
    bRare=True
    bDefensive=True
    bCombat=True
    MinInitialCharges=3
    MaxInitialCharges=5
    MaxCharges=10
    Priority=4.00
    MinChargeGroupInterval=3.00
    Title="Unravel"
    Description="Unravel instantly destroys any weave currently affecting you or located within a small area around you.  All effects, woven traps, or projectiles within this radius simply disappear."
    Quote="Something severed his flows; they snapped back so hard that he grunted."
    StatusIconFrame=Texture'Icons.M_RemoveCurse'
    InventoryGroup=59
    PickupMessage="You got the Unravel ter'angreal"
    PickupViewMesh=Mesh'AngrealRemoveCursePickup'
    PickupViewScale=0.80
    StatusIcon=Texture'Icons.I_RemoveCurse'
    Mesh=Mesh'AngrealRemoveCursePickup'
    DrawScale=0.80
}
