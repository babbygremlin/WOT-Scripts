//------------------------------------------------------------------------------
// LightningStreak.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LightningStreak expands Streak;

#exec MESH    IMPORT     MESH=LightningBolt ANIVFILE=MODELS\LightningStrike_a.3D DATAFILE=MODELS\LightningStrike_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=LightningBolt X=0 Y=-160 Z=0 YAW=-64 PITCH=32
#exec MESH    SEQUENCE   MESH=LightningBolt SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=LightningBoltTex FILE=MODELS\LightningStrike.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=LightningBolt MESH=LightningBolt
#exec MESHMAP SCALE      MESHMAP=LightningBolt X=0.2 Y=0.2 Z=0.4
#exec MESHMAP SETTEXTURE MESHMAP=LightningBolt NUM=0 TEXTURE=LightningBoltTex

#exec TEXTURE IMPORT     NAME=LB1 FILE=MODELS\lb01.PCX GROUP="Skins"
#exec TEXTURE IMPORT     NAME=LB2 FILE=MODELS\lb02.PCX GROUP="Skins"
#exec TEXTURE IMPORT     NAME=LB3 FILE=MODELS\lb03.PCX GROUP="Skins"
#exec TEXTURE IMPORT     NAME=LB4 FILE=MODELS\lb04.PCX GROUP="Skins"
#exec TEXTURE IMPORT     NAME=LB5 FILE=MODELS\lb05.PCX GROUP="Skins"
#exec TEXTURE IMPORT     NAME=LB6 FILE=MODELS\lb06.PCX GROUP="Skins"
#exec TEXTURE IMPORT     NAME=LB7 FILE=MODELS\lb07.PCX GROUP="Skins"
#exec TEXTURE IMPORT     NAME=LB8 FILE=MODELS\lb08.PCX GROUP="Skins"
#exec TEXTURE IMPORT     NAME=LB9 FILE=MODELS\lb09.PCX GROUP="Skins"
#exec TEXTURE IMPORT     NAME=LB10 FILE=MODELS\lb10.PCX GROUP="Skins"

// NOTE[aleiby]: Lighting (not to be confused with lightning) doesn't work well with Streaks.

defaultproperties
{
     SegmentLength=64.000000
     bRandomizeTextures=True
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
     NumTextures=10
     DrawType=DT_Mesh
     Skin=Texture'Angreal.Skins.LB10'
     Mesh=Mesh'Angreal.LightningBolt'
     bUnlit=True
     SoundVolume=255
}
