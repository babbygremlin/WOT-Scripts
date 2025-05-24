//------------------------------------------------------------------------------
// AngrealInvSwapPlaces.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 10 $
//
// Description:	Swaps the positions of you and your target.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvSwapPlaces expands ProjectileLauncher;

#exec MESH    IMPORT     MESH=AngrealSwapPlacesPickup ANIVFILE=MODELS\AngrealSwapPlaces_a.3D DATAFILE=MODELS\AngrealSwapPlaces_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealSwapPlacesPickup X=-37 Y=57 Z=0 YAW=0 ROLL=0

#exec MESH    SEQUENCE   MESH=AngrealSwapPlacesPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec TEXTURE IMPORT     NAME=AngrealSwapPlacesPickupTex FILE=MODELS\AngrealSwapPlaces1.PCX GROUP="Skins"

#exec MESHMAP NEW        MESHMAP=AngrealSwapPlacesPickup MESH=AngrealSwapPlacesPickup
#exec MESHMAP SCALE      MESHMAP=AngrealSwapPlacesPickup X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=AngrealSwapPlacesPickup NUM=1 TEXTURE=AngrealSwapPlacesPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_SwapPlaces.pcx GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_SwapPlaces.pcx GROUP=Icons MIPS=Off

defaultproperties
{
     ProjectileClassName="Angreal.AngrealSwapPlacesProjectile"
     bElementSpirit=True
     bUncommon=True
     bDefensive=True
     MinInitialCharges=2
     MaxInitialCharges=4
     MaxCharges=10
     FailMessage="requires a target"
     NonTargetableTypes(0)=MashadarTrailer
     NonTargetableTypes(1)=AngrealIllusionProjectile
     MaxChargesInGroup=3
     MinChargeGroupInterval=3.000000
     Title="Swap Places"
     Description="This ter’angreal switches your position with that of your target.  Swap Places tricks any weaves that currently track you into now tracking your target, and causes any weaves affecting you to now affect your target."
     Quote="The sense of shifting, of her skin trying to crawl, did not go away."
     StatusIconFrame=Texture'Angreal.Icons.M_SwapPlaces'
     InventoryGroup=99
     PickupMessage="You got the Swap Places ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealSwapPlacesPickup'
     PickupViewScale=0.800000
     StatusIcon=Texture'Angreal.Icons.I_SwapPlaces'
     Texture=None
     Mesh=Mesh'Angreal.AngrealSwapPlacesPickup'
     DrawScale=0.800000
}
