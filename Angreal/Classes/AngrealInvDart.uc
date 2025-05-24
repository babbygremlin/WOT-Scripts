//------------------------------------------------------------------------------
// AngrealInvDart.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 7 $
//
// Description:	Simple projectile. Shoots a weak magical dart at the target.  
//				Default angreal.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvDart expands ProjectileLauncher;

#exec MESH IMPORT MESH=AngrealInventoryDart ANIVFILE=MODELS\Dart_a.3d DATAFILE=MODELS\Dart_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AngrealInventoryDart X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=AngrealInventoryDart SEQ=All  STARTFRAME=0 NUMFRAMES=1

// Skins.
#exec TEXTURE IMPORT NAME=DartAesSedai		FILE=MODELS\DartAesSedai.PCX GROUP=Skins FLAGS=2 // TWOSIDED
#exec TEXTURE IMPORT NAME=DartForsaken		FILE=MODELS\DartForsaken.PCX GROUP=Skins FLAGS=2 // TWOSIDED
#exec TEXTURE IMPORT NAME=DartHound			FILE=MODELS\DartHound.PCX GROUP=Skins FLAGS=2 // TWOSIDED
#exec TEXTURE IMPORT NAME=DartWhitecloak	FILE=MODELS\DartWhitecloak.PCX GROUP=Skins FLAGS=2 // TWOSIDED

#exec MESHMAP NEW   MESHMAP=AngrealInventoryDart MESH=AngrealInventoryDart
#exec MESHMAP SCALE MESHMAP=AngrealInventoryDart X=0.1 Y=0.1 Z=0.2

// Icons.
#exec TEXTURE IMPORT FILE=Icons\I_Dartwh.pcx	GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\I_Dartblck.pcx	GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\I_Dartgld.pcx	GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\I_Dartgr.pcx	GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Dartwh.pcx	GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Dartblck.pcx	GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Dartgld.pcx	GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Dartgr.pcx	GROUP=Icons MIPS=Off

//------------------------------------------------------------------------------
function GiveTo( Pawn Other )
{
	Super.GiveTo( Other );
	
	if( WOTPlayer(Other) != None )
	{
		SetColor( WOTPlayer(Other).PlayerColor );
	}
	else if( Other.Mesh.Name == 'AesSedai' )
	{
		SetColor( 'Blue' );
	}
	else if( Other.Mesh.Name == 'Forsaken' )
	{
		SetColor( 'Red' );
	}
	else if( Other.Mesh.Name == 'Whitecloak' )
	{
		SetColor( 'Gold' );
	}
	else if( Other.Mesh.Name == 'Hound' )
	{
		SetColor( 'Purple' );
	}
	else
	{
		SetColor( 'Green' );
	}
}

//------------------------------------------------------------------------------
function SetColor( name Color )
{
	switch( Color )
	{
	case 'PC_Red':
	case 'Red':
		ProjectileClassName="Angreal.RedDart";
		break;

	case 'PC_Gold':
	case 'Yellow':
	case 'Gold':
		ProjectileClassName="Angreal.YellowDart";
		break;

	case 'PC_Green':
	case 'Green':
		ProjectileClassName="Angreal.GreenDart";
		break;

	case 'PC_Purple':
	case 'Purple':
		ProjectileClassName = "Angreal.PurpleDart";
		break;

	case 'PC_Blue':
	case 'Blue':
	default:
		ProjectileClassName = "Angreal.BlueDart";
		break;
	}
}

defaultproperties
{
     bAutoFire=True
     ProjectileClassName="Angreal.BlueDart"
     bElementFire=True
     bElementAir=True
     bCommon=True
     bOffensive=True
     bCombat=True
     RoundsPerMinute=320.000000
     MinInitialCharges=20
     MaxInitialCharges=70
     MaxCharges=100
     MaxChargesInGroup=20
     MinChargesInGroup=5
     MaxChargeUsedInterval=0.000000
     Title="Dart"
     Description="The Dart ter’angreal focuses the One Power into a weak burst of energy.  Although a single charge may not necessarily inflict much damage, the artifact can spray multiple Darts at a victim in a very short time."
     Quote="His sudden roar made Egwene jump. Clapping a hand to his left buttock, he hobbled in a pained circle."
     StatusIconFrame=Texture'Angreal.Icons.M_Dartwh'
     PickupMessage="You got the Dart ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealInventoryDart'
     PickupViewScale=0.600000
     StatusIcon=Texture'Angreal.Icons.I_Dartwh'
     Style=STY_Masked
     Skin=Texture'Angreal.Skins.DartAesSedai'
     Mesh=Mesh'Angreal.AngrealInventoryDart'
     DrawScale=0.600000
}
