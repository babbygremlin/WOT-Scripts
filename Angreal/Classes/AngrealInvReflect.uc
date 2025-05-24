//------------------------------------------------------------------------------
// AngrealInvReflect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 8 $
//
// Description:	For a short time, any spell that hits or targets the caster is 
//				recast at the originator. Caster is not affected by attack.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvReflect expands ReflectorInstaller;

#exec MESH    IMPORT     MESH=AngrealReflectPickup ANIVFILE=MODELS\Reflection_a.3d DATAFILE=MODELS\Reflection_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealReflectPickup X=0 Y=0 Z=0
#exec MESH    SEQUENCE   MESH=AngrealReflectPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealReflectPickupTex FILE=MODELS\Reflect.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealReflectPickup MESH=AngrealReflectPickup
#exec MESHMAP SCALE      MESHMAP=AngrealReflectPickup X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=AngrealReflectPickup NUM=1 TEXTURE=AngrealReflectPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_Reflect.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Reflect.pcx         GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Reflect\ActivateRF.wav			GROUP=Reflect
/* - OBE
function Cast()
{
	local SeekingProjectile Proj;

	// Install our reflectors.
	Super.Cast();

	// Notify the player of which seekers are already targetting it
	// since it missed the first notification from when the seeker
	// was created.
	foreach AllActors( class'SeekingProjectile', Proj )
	{
		if( Proj.Destination == Owner )
		{
			if( WOTPlayer(Owner) != None )
			{
				WOTPlayer(Owner).NotifyTargettedByAngrealProjectile( Proj );
			}
			else if( WOTPawn(Owner) != None )
			{
				WOTPawn(Owner).NotifyTargettedByAngrealProjectile( Proj );
			}
		}
	}
}

//------------------------------------------------------------------------------
function Cast()
{
	Super.Cast();
	//ReflectDeleteriousEffects();
	//!! Fix ARL: Make work correctly.
}

//------------------------------------------------------------------------------
function ReflectDeleteriousEffects()
{
	local Leech L;
	local Reflector R;

	local LeechIterator IterL;
	local ReflectorIterator IterR;

	IterL = class'LeechIterator'.static.GetIteratorFor( Pawn(LastOwner) );
	for( IterL.First(); !IterL.IsDone(); IterL.Next() )
	{
		L = IterL.GetCurrent();

		if( L.bDeleterious && L.bRemovable )
		{
			L.UnAttach();
			L.Attach( L.Instigator );
			L.Instigator = Pawn(Owner);
		}
	}
	IterL.Reset();
	IterL = None;

	IterR = class'ReflectorIterator'.static.GetIteratorFor( Pawn(LastOwner) );
	for( IterR.First(); !IterR.IsDone(); IterR.Next() )
	{
		R = IterR.GetCurrent();

		if( R.bDeleterious && R.bRemovable )
		{
			R.UnInstall();
			R.Install( R.Instigator );
			R.Instigator = Pawn(Owner);
		}
	}
	IterR.Reset();
	IterR = None;
}
*/

defaultproperties
{
    Duration=5.00
    ReflectorClasses=Class'ReturnToSenderReflector'
    DurationType=1
    bElementFire=True
    bElementWater=True
    bElementAir=True
    bElementEarth=True
    bElementSpirit=True
    bRare=True
    bDefensive=True
    bCombat=True
    MaxInitialCharges=3
    MaxCharges=5
    ActivateSoundName="Angreal.ActivateRF"
    MaxChargesInGroup=2
    MinChargeGroupInterval=3.00
    Title="Reflect"
    Description="For a short time, Reflect surrounds you with a shield that causes any weave that strikes it to bounce back at the originator. You are not affected by the attack."
    Quote="As her hand grasped it, the Power surged within her, into the half-figure then back into her, into the figure and back, in and back."
    StatusIconFrame=Texture'Icons.M_Reflect'
    PickupMessage="You got the Reflect ter'angreal"
    PickupViewMesh=Mesh'AngrealReflectPickup'
    PickupViewScale=1.20
    StatusIcon=Texture'Icons.I_Reflect'
    Texture=None
    Mesh=Mesh'AngrealReflectPickup'
    DrawScale=1.20
}
