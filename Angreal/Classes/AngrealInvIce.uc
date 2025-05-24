//------------------------------------------------------------------------------
// AngrealInvIce.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 8 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvIce expands ProjectileLauncher;

#exec MESH IMPORT MESH=Freeze ANIVFILE=MODELS\Freeze_a.3d DATAFILE=MODELS\Freeze_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Freeze X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Freeze SEQ=All    STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JFreeze1 FILE=MODELS\Freeze1.PCX GROUP=Skins FLAGS=2 // MOTH
#exec TEXTURE IMPORT NAME=JFreeze2 FILE=MODELS\Freeze2.PCX GROUP=Skins PALETTE=JFreeze1 // F

#exec MESHMAP NEW   MESHMAP=Freeze MESH=Freeze
#exec MESHMAP SCALE MESHMAP=Freeze X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Freeze NUM=1 TEXTURE=JFreeze1
#exec MESHMAP SETTEXTURE MESHMAP=Freeze NUM=2 TEXTURE=JFreeze2

#exec TEXTURE IMPORT FILE=Icons\I_Freeze.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Freeze.pcx         GROUP=Icons MIPS=Off

defaultproperties
{
     ProjectileClassName="Angreal.AngrealIceProjectile"
     DurationType=DT_Lifespan
     bElementWater=True
     bUncommon=True
     bDefensive=True
     bCombat=True
     MinInitialCharges=3
     MaxInitialCharges=5
     MaxCharges=10
     FailMessage="requires a target"
     bTargetsFriendlies=False
     MinChargeGroupInterval=4.000000
     Title="Freeze"
     Description="The ter'angreal wraps its target with a frozen weave of water, making movement impossible during the short time that the ice is melting."
     Quote="Men and Myrddraal stiffened where they stood. White frost grew thick on them, frost that smoked. The Myrddraal's upraised arm broke off with a loud crack. When it hit the floortiles, arm and sword shattered."
     StatusIconFrame=Texture'Angreal.Icons.M_Freeze'
     PickupMessage="You got the Freeze ter'angreal"
     PickupViewMesh=Mesh'Angreal.Freeze'
     PickupViewScale=0.300000
     StatusIcon=Texture'Angreal.Icons.I_Freeze'
     Mesh=Mesh'Angreal.Freeze'
     DrawScale=0.300000
}
