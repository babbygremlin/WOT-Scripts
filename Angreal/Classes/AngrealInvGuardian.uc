//------------------------------------------------------------------------------
// AngrealInvGuardian.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 12 $
//
// Description:	Gives you an additional captain to place inside of your citadel.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvGuardian expands ResourceSpawner;

#exec MESH IMPORT MESH=AngrealGuardianPickup ANIVFILE=MODELS\Guardian_a.3d DATAFILE=MODELS\Guardian_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AngrealGuardianPickup X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=AngrealGuardianPickup SEQ=All       STARTFRAME=0   NUMFRAMES=1 //389

#exec TEXTURE IMPORT NAME=JAngrealGuardian1 FILE=MODELS\Guardian1.PCX GROUP=Skins FLAGS=2 // TWOSIDED

#exec MESHMAP NEW   MESHMAP=AngrealGuardianPickup MESH=Guardian
#exec MESHMAP SCALE MESHMAP=AngrealGuardianPickup X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=AngrealGuardianPickup NUM=1 TEXTURE=JAngrealGuardian1

#exec TEXTURE IMPORT FILE=ICONS\I_Guardian.pcx GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=ICONS\M_Guardian.pcx GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Guardian\ActivateGN.wav GROUP=Guardian

//------------------------------------------------------------------------------
function class<WOTPawn> GetResourceClass()
{
	local class<WOTPawn> ResourceClass;
	
	ResourceClass = class'WOTPlayer'.static.GetTroop( Owner, 'Captain' );

	if( ResourceClass != None && ResourceClass.Name == 'MashadarFocusPawn' )
	{
		Spawn( class<Actor>(DynamicLoadObject( "WOTPawns.MashadarArenaSpawner", class'Class' )), Self );
		return None;
	}
	else
	{
		return ResourceClass;
	}
}

//------------------------------------------------------------------------------
function SuperCast()
{
	Super(AngrealInventory).Cast();
}

//------------------------------------------------------------------------------
function bool HaveHelper()
{
	local class<WOTPawn> ResourceClass;
	local Projectile iProj;
	
	ResourceClass = class'WOTPlayer'.static.GetTroop( Owner, 'Captain' );

	if( ResourceClass != None && ResourceClass.Name == 'MashadarFocusPawn' )
	{
		for( iProj = Level.ProjectileList; iProj != None; iProj = iProj.NextProjectile )
		{
			if( iProj.IsA('MashadarGuide') && !iProj.bDeleteMe && iProj.Tag == 'AngrealSpawned' && iProj.Owner == Owner )	// NOTE[aleiby]: Check team? (only needed if the person who spawned him, changes teams on us)
			{
				return true;
			}
		}

		return false;
	}
	else
	{
		return Super.HaveHelper();
	}
}

defaultproperties
{
     LimitWarning="You already have one Guardian under your control."
     TopSparkle=Texture'ParticleSystems.Appear.APurpleCorona'
     BottomSparkle=Texture'ParticleSystems.Appear.AWhiteCorona'
     bElementSpirit=True
     bRare=True
     MaxCharges=5
     ActivateSoundName="Angreal.ActivateGN"
     MinChargeGroupInterval=10.000000
     Title="Guardian"
     Description="The Guardian ter'angreal summons a captain of the type that you command."
     Quote="All around them dust rippled and shivered ever thicker, bunching and gathering.  Suddenly, right in front of them, a shape reared up in the basin of a dry fountain, a solid man shape, dark and featureless, with fingers like sharp claws"
     StatusIconFrame=Texture'Angreal.Icons.M_Guardian'
     PickupMessage="You got the Guardian ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealGuardianPickup'
     StatusIcon=Texture'Angreal.Icons.I_Guardian'
     Style=STY_Masked
     Mesh=Mesh'Angreal.AngrealGuardianPickup'
     DrawScale=0.400000
}
