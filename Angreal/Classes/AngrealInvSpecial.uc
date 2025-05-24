//------------------------------------------------------------------------------
// AngrealInvSpecial.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvSpecial expands AngrealInventory;

#exec MESH IMPORT MESH=AngrealSpecial ANIVFILE=MODELS\AngrealSpecial_a.3d DATAFILE=MODELS\AngrealSpecial_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AngrealSpecial X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=AngrealSpecial SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JAngrealSpecial1 FILE=MODELS\AngrealSpecial.PCX GROUP=Skins FLAGS=2 // Special

#exec MESHMAP NEW   MESHMAP=AngrealSpecial MESH=AngrealSpecial
#exec MESHMAP SCALE MESHMAP=AngrealSpecial X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=AngrealSpecial NUM=1 TEXTURE=JAngrealSpecial1

#exec TEXTURE IMPORT FILE=Icons\I_Special.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Special.pcx         GROUP=Icons MIPS=Off

//------------------------------------------------------------------------------
// Don't let the player drop this artifact.
//------------------------------------------------------------------------------
function DropFrom( vector StartLocation );

defaultproperties
{
    bElementFire=True
    bElementWater=True
    bElementAir=True
    bElementEarth=True
    bElementSpirit=True
    bRare=True
    ChargeCost=0
    Title="Unknown"
    Description="It's not clear how to use this artifact, nor what it does.  Quick research reveals nothing."
    Quote="Such things need study."
    StatusIconFrame=Texture'Icons.M_Special'
    InventoryGroup=65
    PickupMessage="You got an unknown ter'angreal"
    PickupViewMesh=Mesh'AngrealSpecial'
    PickupViewScale=0.70
    StatusIcon=Texture'Icons.I_Special'
    Mesh=Mesh'AngrealSpecial'
    DrawScale=0.70
}
