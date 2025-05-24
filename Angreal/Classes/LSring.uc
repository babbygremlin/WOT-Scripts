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
     Textures(0)=Texture'Angreal.Skins.LB1'
     Textures(1)=Texture'Angreal.Skins.LB2'
     Textures(2)=Texture'Angreal.Skins.LB3'
     Textures(3)=Texture'Angreal.Skins.LB4'
     Textures(4)=Texture'Angreal.Skins.LB5'
     Textures(5)=Texture'Angreal.Skins.LB6'
     Textures(6)=Texture'Angreal.Skins.LB7'
     Textures(7)=Texture'Angreal.Skins.LB8'
     Textures(8)=Texture'Angreal.Skins.LB9'
     Textures(9)=Texture'Angreal.Skins.LB10'
     RemoteRole=ROLE_None
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=Texture'Angreal.Skins.LB10'
     Mesh=Mesh'Angreal.LSring'
     DrawScale=0.500000
     bUnlit=True
}
