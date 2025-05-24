//------------------------------------------------------------------------------
// AngrealInvShield.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 6 $
//
// Description:	Damage dealing attacks are blunted.  
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
class AngrealInvShield expands ReflectorInstaller;

#exec MESH    IMPORT     MESH=AngrealShieldPickup ANIVFILE=MODELS\AngrealShield_a.3D DATAFILE=MODELS\AngrealShield_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealShieldPickup X=0 Y=0 Z=0

#exec MESH    SEQUENCE   MESH=AngrealShieldPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JShield1 FILE=MODELS\AngrealShield.PCX		GROUP=Skins FLAGS=2 // SHIELD
#exec TEXTURE IMPORT NAME=JShield2 FILE=MODELS\AngrealShieldGlobe.PCX	GROUP=Skins PALETTE=JShield1 // SH

#exec MESHMAP NEW        MESHMAP=AngrealShieldPickup MESH=AngrealShieldPickup
#exec MESHMAP SCALE      MESHMAP=AngrealShieldPickup X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=AngrealShieldPickup NUM=1 TEXTURE=JShield1
#exec MESHMAP SETTEXTURE MESHMAP=AngrealShieldPickup NUM=2 TEXTURE=JShield2

#exec TEXTURE IMPORT FILE=Icons\I_Shield.pcx          GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Shield.pcx          GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Shield\ActivateSD.wav		GROUP=Shield

//------------------------------------------------------------------------------
function Cast()
{
	if( GetShieldHitPoints() == class'ShieldReflector'.default.MaxShieldHitPoints )
	{
		Failed();
	}
	else
	{
		Super.Cast();
	}
}

//------------------------------------------------------------------------------
function int GetShieldHitPoints()
{
	local int HitPoints;

	if( WOTPlayer(Owner) != None )
	{
		HitPoints = WOTPlayer(Owner).ShieldHitPoints;
	}
	else if( WOTPawn(Owner) != None )
	{
		HitPoints = WOTPawn(Owner).ShieldHitPoints;
	}

	return HitPoints;
}

//------------------------------------------------------------------------------
function float GetPriority()
{
	if( GetShieldHitPoints() > 0 )	return 0.0;
	else							return Priority;
}

defaultproperties
{
     ReflectorClasses(0)=Class'Angreal.ShieldReflector'
     DurationType=DT_Shield
     bElementAir=True
     bCommon=True
     bDefensive=True
     bCombat=True
     MaxInitialCharges=3
     MaxCharges=10
     Priority=1.000000
     ActivateSoundName="Angreal.ActivateSD"
     MinChargeGroupInterval=4.000000
     Title="Personal Shield"
     Description="Personal Shield surrounds you with a weave that blunts all damage-dealing attacks, internal or external. It is a permanent effect--although it can be worn away by said attacks. Subsequent activation replenishes the shield's strength."
     Quote="Rand seized saidin and channeled as the bolt flew toward him; it struck Air, a silvery blue mass hanging above the street, with a clang as of metal against metal."
     StatusIconFrame=Texture'Angreal.Icons.M_Shield'
     InventoryGroup=53
     PickupMessage="You got the Personal Shield ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealShieldPickup'
     PickupViewScale=0.800000
     StatusIcon=Texture'Angreal.Icons.I_Shield'
     Texture=None
     Mesh=Mesh'Angreal.AngrealShieldPickup'
     DrawScale=0.800000
     bMeshCurvy=True
}
