//------------------------------------------------------------------------------
// LightningStreak02.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LightningStreak02 expands Streak;

#exec MESH    IMPORT     MESH=LSbolt ANIVFILE=MODELS\LSbolt_a.3D DATAFILE=MODELS\LSbolt_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=LSbolt X=0 Y=0 Z=0 YAW=128 PITCH=0 ROLL=32
#exec MESH    SEQUENCE   MESH=LSbolt SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\LB_A01.pcx GROUP=Skins
#exec TEXTURE IMPORT FILE=MODELS\LB_A02.pcx GROUP=Skins
#exec TEXTURE IMPORT FILE=MODELS\LB_A03.pcx GROUP=Skins
#exec TEXTURE IMPORT FILE=MODELS\LB_A04.pcx GROUP=Skins
#exec TEXTURE IMPORT FILE=MODELS\LB_A05.pcx GROUP=Skins
#exec TEXTURE IMPORT FILE=MODELS\LB_A06.pcx GROUP=Skins
#exec TEXTURE IMPORT FILE=MODELS\LB_A07.pcx GROUP=Skins
#exec TEXTURE IMPORT FILE=MODELS\LB_A08.pcx GROUP=Skins
#exec TEXTURE IMPORT FILE=MODELS\LB_A09.pcx GROUP=Skins
#exec TEXTURE IMPORT FILE=MODELS\LB_A10.pcx GROUP=Skins

#exec MESHMAP NEW        MESHMAP=LSbolt MESH=LSbolt
#exec MESHMAP SCALE      MESHMAP=LSbolt X=0.2 Y=0.2 Z=0.4
#exec MESHMAP SETTEXTURE MESHMAP=LSbolt NUM=0 TEXTURE=LB_A01

defaultproperties
{
     SegmentLength=64.000000
     bRandomizeTextures=True
     Textures(0)=Texture'Angreal.Skins.LB_A01'
     Textures(1)=Texture'Angreal.Skins.LB_A02'
     Textures(2)=Texture'Angreal.Skins.LB_A03'
     Textures(3)=Texture'Angreal.Skins.LB_A04'
     Textures(4)=Texture'Angreal.Skins.LB_A05'
     Textures(5)=Texture'Angreal.Skins.LB_A06'
     Textures(6)=Texture'Angreal.Skins.LB_A07'
     Textures(7)=Texture'Angreal.Skins.LB_A08'
     Textures(8)=Texture'Angreal.Skins.LB_A09'
     Textures(9)=Texture'Angreal.Skins.LB_A10'
     NumTextures=10
     DrawType=DT_Mesh
     Skin=Texture'Angreal.Skins.LB_A01'
     Mesh=Mesh'Angreal.LSbolt'
     AmbientGlow=250
     bUnlit=True
}
