//=============================================================================
// WoodFragments.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================
class WoodFragments expands Fragment;

#exec MESH IMPORT MESH=wfrag1 ANIVFILE=MODELS\WoodPiece01_a.3D DATAFILE=MODELS\WoodPiece01_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=wfrag1 X=0 Y=0 Z=0 YAW=64 ROLL=64
#exec MESH SEQUENCE MESH=wfrag1 SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT NAME=WoodTex1 FILE=MODELS\barrel1.PCX GROUP=Skins
#exec MESHMAP SCALE MESHMAP=wfrag1 X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=wfrag1 NUM=1 TEXTURE=WoodTex1

#exec MESH IMPORT MESH=wfrag2 ANIVFILE=MODELS\WoodPiece02_a.3D DATAFILE=MODELS\WoodPiece02_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=wfrag2 X=0 Y=0 Z=0 YAW=64 ROLL=64
#exec MESH SEQUENCE MESH=wfrag2 SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=wfrag2 X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=wfrag2 NUM=1 TEXTURE=WoodTex1

#exec MESH IMPORT MESH=wfrag3 ANIVFILE=MODELS\WoodPiece03_a.3D DATAFILE=MODELS\WoodPiece03_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=wfrag3 X=0 Y=0 Z=0 YAW=64 ROLL=64
#exec MESH SEQUENCE MESH=wfrag3 SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=wfrag3 X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=wfrag3 NUM=1 TEXTURE=WoodTex1

#exec MESH IMPORT MESH=wfrag4 ANIVFILE=MODELS\WoodPiece04_a.3D DATAFILE=MODELS\WoodPiece04_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=wfrag4 X=0 Y=0 Z=0 YAW=64 ROLL=64
#exec MESH SEQUENCE MESH=wfrag4 SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=wfrag4 X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=wfrag4 NUM=1 TEXTURE=WoodTex1

#exec MESH IMPORT MESH=wfrag5 ANIVFILE=MODELS\WoodPiece05_a.3D DATAFILE=MODELS\WoodPiece05_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=wfrag5 X=0 Y=0 Z=0 YAW=64 ROLL=64
#exec MESH SEQUENCE MESH=wfrag5 SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=wfrag5 X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=wfrag5 NUM=1 TEXTURE=WoodTex1

#exec MESH IMPORT MESH=wfrag6 ANIVFILE=MODELS\WoodPiece06_a.3D DATAFILE=MODELS\WoodPiece06_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=wfrag6 X=0 Y=0 Z=0 YAW=64 ROLL=64
#exec MESH SEQUENCE MESH=wfrag6 SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=wfrag6 X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=wfrag6 NUM=1 TEXTURE=WoodTex1

#exec MESH IMPORT MESH=wfrag7 ANIVFILE=MODELS\WoodPiece07_a.3D DATAFILE=MODELS\WoodPiece07_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=wfrag7 X=0 Y=0 Z=0 YAW=64 ROLL=64
#exec MESH SEQUENCE MESH=wfrag7 SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=wfrag7 X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=wfrag7 NUM=1 TEXTURE=WoodTex1

#exec MESH IMPORT MESH=wfrag8 ANIVFILE=MODELS\WoodPiece08_a.3D DATAFILE=MODELS\WoodPiece08_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=wfrag8 X=0 Y=0 Z=0 YAW=64 ROLL=64
#exec MESH SEQUENCE MESH=wfrag8 SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=wfrag8 X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=wfrag8 NUM=1 TEXTURE=WoodTex1

#exec MESH IMPORT MESH=wfrag9 ANIVFILE=MODELS\WoodPiece09_a.3D DATAFILE=MODELS\WoodPiece09_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=wfrag9 X=0 Y=0 Z=0 YAW=64 ROLL=64
#exec MESH SEQUENCE MESH=wfrag9 SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=wfrag9 X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=wfrag9 NUM=1 TEXTURE=WoodTex1

#exec MESH IMPORT MESH=wfrag10 ANIVFILE=MODELS\WoodPiece10_a.3D DATAFILE=MODELS\WoodPiece10_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=wfrag10 X=0 Y=0 Z=0 YAW=64 ROLL=64
#exec MESH SEQUENCE MESH=wfrag10 SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=wfrag10 X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=wfrag10 NUM=0 TEXTURE=WoodTex1

#exec MESH IMPORT MESH=wfrag11 ANIVFILE=MODELS\WoodPiece11_a.3D DATAFILE=MODELS\WoodPiece11_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=wfrag11 X=0 Y=0 Z=0 YAW=64 ROLL=64
#exec MESH SEQUENCE MESH=wfrag11 SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=wfrag11 X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=wfrag11 NUM=1 TEXTURE=WoodTex1

#exec AUDIO IMPORT FILE="Sounds\Effect\WoodFragment1.WAV" NAME="WoodFragment1" GROUP="Effect"
#exec AUDIO IMPORT FILE="Sounds\Effect\WoodFragment2.WAV" NAME="WoodFragment2" GROUP="Effect"

simulated function CalcVelocity( vector Momentum, float ExplosionSize )
{
	Super.CalcVelocity( Momentum, ExplosionSize );
	Velocity.z += ExplosionSize/2;
}

defaultproperties
{
     Fragments(0)=Mesh'WOT.wfrag1'
     Fragments(1)=Mesh'WOT.wfrag2'
     Fragments(2)=Mesh'WOT.wfrag3'
     Fragments(3)=Mesh'WOT.wfrag4'
     Fragments(4)=Mesh'WOT.wfrag5'
     Fragments(5)=Mesh'WOT.wfrag6'
     Fragments(6)=Mesh'WOT.wfrag7'
     Fragments(7)=Mesh'WOT.wfrag8'
     Fragments(8)=Mesh'WOT.wfrag9'
     Fragments(9)=Mesh'WOT.wfrag10'
     Fragments(10)=Mesh'WOT.wfrag11'
     numFragmentTypes=11
     ImpactSound=Sound'WOT.Effect.WoodFragment1'
     MiscSound=Sound'WOT.Effect.WoodFragment2'
     Mesh=Mesh'WOT.wfrag1'
     CollisionRadius=12.000000
     CollisionHeight=2.000000
     Mass=5.000000
     Buoyancy=6.000000
}
