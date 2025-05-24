//------------------------------------------------------------------------------
// AngrealInvIllusion.uc
// $Author: Mfox $
// $Date: 1/09/00 4:06p $
// $Revision: 6 $
//
// Description:	Creates a "holo-image" of caster.  
//				Images can be the legal target of spells.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvIllusion expands AngrealInventory;

#exec MESH    IMPORT     MESH=AngrealPersonalIllusionPickup ANIVFILE=MODELS\AngrealPersonalIllusion_a.3D DATAFILE=MODELS\AngrealPersonalIllusion_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealPersonalIllusionPickup X=0 Y=0 Z=0 YAW=64 ROLL=-64
#exec MESH    SEQUENCE   MESH=AngrealPersonalIllusionPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealPersonalIllusionPickupTex FILE=MODELS\AngrealPersonalIllusion.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealPersonalIllusionPickup MESH=AngrealPersonalIllusionPickup
#exec MESHMAP SCALE      MESHMAP=AngrealPersonalIllusionPickup X=0.04 Y=0.04 Z=0.08
#exec MESHMAP SETTEXTURE MESHMAP=AngrealPersonalIllusionPickup NUM=4 TEXTURE=AngrealPersonalIllusionPickupTex

#exec AUDIO IMPORT FILE=Sounds\PersonalIllusion\ActivatePI.wav GROUP=PersonalIllusion

#exec TEXTURE IMPORT FILE=Icons\I_PersonalIllusion.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_PersonalIllusion.pcx         GROUP=Icons MIPS=Off

var() vector SpawnOffset;

var AngrealIllusionProjectile Illusion;

//------------------------------------------------------------------------------
function Cast()
{
	local AngrealIllusionProjectile PrevIll;

	PrevIll = GetIllusion();

	if( PrevIll != None )
	{
		PrevIll.Destroy();
	}

	Illusion = Spawn( class'AngrealIllusionProjectile', Owner,, Owner.Location + (SpawnOffset >> Owner.Rotation), Owner.Rotation );
	Illusion.AcquireImage( Pawn(Owner) );
	Illusion.SetSourceAngreal( Self );

	Super.Cast();
	UseCharge();
}

//------------------------------------------------------------------------------
function bool HaveIllusion()
{
	return GetIllusion() != None;
}

//------------------------------------------------------------------------------
function AngrealIllusionProjectile GetIllusion()
{
	local AngrealIllusionProjectile IterI;
	
	foreach AllActors( class'AngrealIllusionProjectile', IterI )
	{
		if( IterI.Instigator == Owner )
		{
			return IterI;
		}
	}

	return None;
}

////////////////
// AI Support //
////////////////

//------------------------------------------------------------------------------
function float GetPriority()
{
	if( HaveIllusion() )	return 0.0;
	else					return Priority;
}

defaultproperties
{
    SpawnOffset=(X=48.00,Y=0.00,Z=0.00),
    DurationType=1
    bElementAir=True
    bElementSpirit=True
    bCommon=True
    bCombat=True
    MaxInitialCharges=3
    MaxCharges=5
    Priority=0.50
    ActivateSoundName="Angreal.ActivatePI"
    MinChargeGroupInterval=10.00
    Title="Personal Illusion"
    Description="Personal Illusion weaves your image before you, an ethereal copy of you, and leaves it there to fool others. Although not solid, this image can be targeted by other weaves. It dissipates after some time."
    Quote=" "
    StatusIconFrame=Texture'Icons.M_PersonalIllusion'
    InventoryGroup=65
    PickupMessage="You got the Personal Illusion ter'angreal"
    PickupViewMesh=Mesh'AngrealPersonalIllusionPickup'
    StatusIcon=Texture'Icons.I_PersonalIllusion'
    Mesh=Mesh'AngrealPersonalIllusionPickup'
}
