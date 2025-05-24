//------------------------------------------------------------------------------
// AngrealInvChampion.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 9 $
//
// Description:	Give you a special monster to place inside of your citadel.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvChampion expands ResourceSpawner;

#exec MESH IMPORT MESH=AngrealChampionPickup ANIVFILE=MODELS\champion_a.3d DATAFILE=MODELS\champion_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AngrealChampionPickup X=0 Y=-50 Z=0

#exec MESH SEQUENCE MESH=AngrealChampionPickup SEQ=All       STARTFRAME=0   NUMFRAMES=1 //389

#exec TEXTURE IMPORT NAME=JAngrealChampion1 FILE=MODELS\champion1.PCX GROUP=Skins FLAGS=2 // TWOSIDED

#exec MESHMAP NEW   MESHMAP=AngrealChampionPickup MESH=AngrealChampionPickup
#exec MESHMAP SCALE MESHMAP=AngrealChampionPickup X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=AngrealChampionPickup NUM=1 TEXTURE=JAngrealChampion1

#exec TEXTURE IMPORT FILE=ICONS\I_Champion.pcx GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=ICONS\M_Champion.pcx GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Champion\ActivateCH.wav GROUP=Champion

//=============================================================================
function class<WOTPawn> GetResourceClass()
{
	return class'WOTPlayer'.static.GetTroop( Owner, 'Champion' );
}

defaultproperties
{
     LimitWarning="You already have one Champion under your control."
     TopSparkle=Texture'ParticleSystems.Appear.ZGreenCorona'
     BottomSparkle=Texture'ParticleSystems.Appear.AYellowCorona'
     bElementSpirit=True
     bRare=True
     MaxCharges=5
     ActivateSoundName="Angreal.ActivateCH"
     MinChargeGroupInterval=10.000000
     Title="Champion"
     Description="The Champion ter'angreal summons the strongest creature under your command--extremely powerful, but also very headstrong."
     Quote="It was Thom Merrilin who answered her hoarsely. @In the war that ended the Age of Legends, worse than Trollocs and Halfmen were created.@"
     StatusIconFrame=Texture'Angreal.Icons.M_Champion'
     PickupMessage="You got the Champion ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealChampionPickup'
     StatusIcon=Texture'Angreal.Icons.I_Champion'
     Style=STY_Masked
     Mesh=Mesh'Angreal.AngrealChampionPickup'
     DrawScale=0.500000
}
