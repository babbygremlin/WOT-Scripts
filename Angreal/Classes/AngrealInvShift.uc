//------------------------------------------------------------------------------
// AngrealInvShift.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 6 $
//
// Description:	Teleports the caster about five feet in a random direction.  
//				Any tracking spells locked on to the caster lose their target.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvShift expands AngrealInventory;

#exec MESH    IMPORT     MESH=AngrealShiftPickup ANIVFILE=MODELS\AngrealShift_a.3D DATAFILE=MODELS\AngrealShift_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealShiftPickup X=0 Y=0 Z=0 YAW=64 ROLL=-64
#exec MESH    SEQUENCE   MESH=AngrealShiftPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealShiftPickupTex FILE=MODELS\AngrealShift.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealShiftPickup MESH=AngrealShiftPickup
#exec MESHMAP SCALE      MESHMAP=AngrealShiftPickup X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=AngrealShiftPickup NUM=2 TEXTURE=AngrealShiftPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_Shift.pcx           GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Shift.pcx           GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Shift\ActivateSF.wav			GROUP=Shift

//=============================================================================
function Cast()
{
	local ShiftEffect SEffect;

	SEffect = Spawn( class'ShiftEffect' );
	SEffect.SetVictim( Pawn(Owner) );
	SEffect.SetSourceAngreal( Self );
	if( WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).ProcessEffect( SEffect );
	}
	else if( WOTPawn(Owner) != None )
	{
		WOTPawn(Owner).ProcessEffect( SEffect );
	}

	if( SEffect.LastShiftSucceeded() )
	{
		Super.Cast();
		UseCharge();
	}
	else
	{
		Failed();
	}
}

defaultproperties
{
     bElementAir=True
     bElementSpirit=True
     bUncommon=True
     bDefensive=True
     bCombat=True
     MinInitialCharges=3
     MaxInitialCharges=5
     MaxCharges=10
     Priority=6.000000
     ActivateSoundName="Angreal.ActivateSF"
     MaxChargeUsedInterval=1.000000
     MinChargeGroupInterval=3.000000
     Title="Shift"
     Description="Shift instantly moves you a few paces ahead of your current location, through all obstacles, as long as the destination is clear.  Any weaves currently locked on to you lose their target."
     Quote="You did not need to know a place at all to Travel if you only intended to go a very short distance"
     StatusIconFrame=Texture'Angreal.Icons.M_Shift'
     InventoryGroup=54
     PickupMessage="You got the Shift ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealShiftPickup'
     PickupViewScale=0.800000
     StatusIcon=Texture'Angreal.Icons.I_Shift'
     Mesh=Mesh'Angreal.AngrealShiftPickup'
     DrawScale=0.800000
}
