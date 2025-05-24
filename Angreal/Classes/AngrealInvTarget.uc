//------------------------------------------------------------------------------
// AngrealInvTarget.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 6 $
//
// Description:	For a short time, any seeking artifacts will automatically 
//				target the nearest victim, regardless of line of sight.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvTarget expands ReflectorInstaller;

#exec MESH IMPORT MESH=AngrealTargetingPickup ANIVFILE=models\AngrealTargeting_a.3D DATAFILE=models\AngrealTargeting_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AngrealTargetingPickup X=0 Y=-50 Z=0 YAW=64 ROLL=-64
#exec MESH SEQUENCE MESH=AngrealTargetingPickup SEQ=All       STARTFRAME=0   NUMFRAMES=2
#exec TEXTURE IMPORT NAME=JAngrealTargeting1 FILE=models\AngrealTargeting.PCX GROUP=Skins FLAGS=2
#exec MESHMAP NEW   MESHMAP=AngrealTargetingPickup MESH=AngrealTargetingPickup
#exec MESHMAP SCALE MESHMAP=AngrealTargetingPickup X=0.04 Y=0.04 Z=0.08
#exec MESHMAP SETTEXTURE MESHMAP=AngrealTargetingPickup NUM=1 TEXTURE=JAngrealTargeting1

#exec AUDIO IMPORT FILE=Sounds\Targeting\ActivateTA.wav GROUP=Targeting

#exec TEXTURE IMPORT FILE=Icons\I_Targeting.pcx			GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Targeting.pcx			GROUP=Icons MIPS=Off

defaultproperties
{
    Duration=15.00
    ReflectorClasses=Class'AutoTargetReflector'
    DurationType=1
    bElementAir=True
    bElementSpirit=True
    bRare=True
    bOffensive=True
    bCombat=True
    MaxInitialCharges=2
    MaxCharges=5
    ActivateSoundName="Angreal.ActivateTA"
    MinChargeGroupInterval=5.00
    Title="Find Target"
    Description="For a short time, all seeking weaves automatically target the nearest victim, regardless of line of sight."
    Quote="With the Power you had to see something to affect it, or know exactly where it was in relation to you down to a hair.  Perhaps it was different here."
    StatusIconFrame=Texture'Icons.M_Targeting'
    InventoryGroup=66
    PickupMessage="You got the Find Target ter'angreal"
    PickupViewMesh=Mesh'AngrealTargetingPickup'
    PickupViewScale=0.80
    StatusIcon=Texture'Icons.I_Targeting'
    Texture=None
    Mesh=Mesh'AngrealTargetingPickup'
    DrawScale=0.80
}
