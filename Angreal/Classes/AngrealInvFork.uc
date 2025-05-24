//------------------------------------------------------------------------------
// AngrealInvFork.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 9 $
//
// Description:	Shoots an identical attack back at the originator--target still 
//				takes damage/effect from attack.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvFork expands ReflectorInstaller;

#exec MESH    IMPORT     MESH=AngrealForkPickup ANIVFILE=MODELS\AngrealFork_a.3D DATAFILE=MODELS\AngrealFork_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealForkPickup X=0 Y=0 Z=0 ROLL=0
#exec MESH    SEQUENCE   MESH=AngrealForkPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealForkPickupTex FILE=MODELS\AngrealFork.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealForkPickup MESH=AngrealForkPickup
#exec MESHMAP SCALE      MESHMAP=AngrealForkPickup X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=AngrealForkPickup NUM=1 TEXTURE=AngrealForkPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_Fork.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Fork.pcx         GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Fork\ActivateFK.wav			GROUP=Fork

/*OBE
//------------------------------------------------------------------------------
function Cast()
{
	Super.Cast();
	//ReflectDeleteriousEffects();
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
     Duration=20.000000
     ReflectorClasses(0)=Class'Angreal.ForkRTSReflector'
     DurationType=DT_Lifespan
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
     ActivateSoundName="Angreal.ActivateFK"
     MaxChargesInGroup=3
     MinChargeGroupInterval=3.000000
     Title="Fork"
     Description="For a short time, Fork erects a shield. Although artifact weaves that penetrate this shield still affect you, a duplicate attack is launched back at the originator."
     Quote="Balling her fist tightly, Egwene hit the woman as hard as she could, right in her eye-and staggered and fell to her knees herself, head ringing. It felt as if a large man had struck her in the face."
     StatusIconFrame=Texture'Angreal.Icons.M_Fork'
     PickupMessage="You got the Fork ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealForkPickup'
     StatusIcon=Texture'Angreal.Icons.I_Fork'
     Texture=None
     Mesh=Mesh'Angreal.AngrealForkPickup'
}
