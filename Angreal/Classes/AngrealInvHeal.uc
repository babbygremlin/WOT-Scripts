//------------------------------------------------------------------------------
// AngrealInvHeal.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 7 $
//
// Description:	10 points of healing--very rare in multiplayer.  
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvHeal expands AngrealInventory;

#exec MESH    IMPORT     MESH=AngrealHealPickup ANIVFILE=MODELS\AngrealHeal_a.3D DATAFILE=MODELS\AngrealHeal_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealHealPickup X=0 Y=0 Z=0 YAW=64 ROLL=-64
#exec MESH    SEQUENCE   MESH=AngrealHealPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealHealPickupTex FILE=MODELS\AngrealHeal.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealHealPickup MESH=AngrealHealPickup
#exec MESHMAP SCALE      MESHMAP=AngrealHealPickup X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=AngrealHealPickup NUM=7 TEXTURE=AngrealHealPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_Healing.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Healing.pcx         GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Heal\ActivateHL.wav		GROUP=Heal

var() int HealingAmount;		// how much healing to you want to occur?

//=============================================================================
function Cast()
{
	local IncreaseHealthEffect Healer;

	// Don't use if we're already at a max.
	if( Pawn(Owner).Health == 100 )
	{
		return;
	}

	//Healer = Spawn( class'IncreaseHealthEffect' );
	Healer = IncreaseHealthEffect( class'Invokable'.static.GetInstance( Self, class'IncreaseHealthEffect' ) );
	Healer.Initialize( HealingAmount );
	Healer.SetVictim( Pawn(Owner) );
	Healer.SetSourceAngreal( Self );
	if( WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).ProcessEffect( Healer );
		Super.Cast();
		UseCharge();
	}
	else if( WOTPawn(Owner) != None )
	{
		WOTPawn(Owner).ProcessEffect( Healer );
		Super.Cast();
		UseCharge();
	}
}

//------------------------------------------------------------------------------
function float GetPriority()
{
	// Priority should be 0 unless Health is at least HealingAmount below default?
	if( Pawn(Owner) != None && Pawn(Owner).Health < (Pawn(Owner).default.Health-HealingAmount) )	
	{
		return Priority;
	}
	else																				
	{
		return 0.0;
	}
}

defaultproperties
{
     HealingAmount=10
     bElementWater=True
     bElementAir=True
     bElementSpirit=True
     bRare=True
     bDefensive=True
     MinInitialCharges=3
     MaxInitialCharges=7
     MaxCharges=10
     Priority=100.000000
     ActivateSoundName="Angreal.ActivateHL"
     MaxChargesInGroup=4
     MinChargesInGroup=3
     MinChargeGroupInterval=6.000000
     Title="Heal"
     Description="With each activation, the Heal ter'angreal raises your health slightly."
     Quote="A chill rippled through him, not the blasting cold of full Healing, but a chill that pushed weariness out as it passed."
     StatusIconFrame=Texture'Angreal.Icons.M_Healing'
     InventoryGroup=61
     PickupMessage="You got the Heal ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealHealPickup'
     StatusIcon=Texture'Angreal.Icons.I_Healing'
     Texture=None
     Mesh=Mesh'Angreal.AngrealHealPickup'
}
