//------------------------------------------------------------------------------
// LSring.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LSring expands Effects;

#exec MESH IMPORT MESH=LSring ANIVFILE=MODELS\LSring_a.3d DATAFILE=MODELS\LSring_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LSring X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=LSring SEQ=All    STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=LSring MESH=LSring
#exec MESHMAP SCALE MESHMAP=LSring X=0.1 Y=0.1 Z=0.2

var Texture Textures[10];

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	Skin = Textures[ Rand( ArrayCount(Textures) ) ];
}

defaultproperties
{
    Textures(0)=Texture'Skins.LB1'
    Textures(1)=Texture'Skins.LB2'
    Textures(2)=Texture'Skins.LB3'
    Textures(3)=Texture'Skins.LB4'
    Textures(4)=Texture'Skins.LB5'
    Textures(5)=Texture'Skins.LB6'
    Textures(6)=Texture'Skins.LB7'
    Textures(7)=Texture'Skins.LB8'
    Textures(8)=Texture'Skins.LB9'
    Textures(9)=Texture'Skins.LB10'
    RemoteRole=0
    DrawType=2
    Style=3
    Skin=Texture'Skins.LB10'
    Mesh=Mesh'LSring'
    DrawScale=0.50
    bUnlit=True
}
