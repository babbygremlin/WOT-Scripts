//------------------------------------------------------------------------------
// LightningStrikeEffect4.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LightningStrikeEffect4 expands Effects;

#exec MESH IMPORT MESH=LightningStrikeEffect2 ANIVFILE=MODELS\LightningStrikeEffect2_a.3d DATAFILE=MODELS\LightningStrikeEffect2_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LightningStrikeEffect2 X=0 Y=0 Z=0 YAW=64

#exec MESH SEQUENCE MESH=LightningStrikeEffect2 SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=LightningStrikeEffect2 SEQ=LightningStrikeEffect2 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JLightningStrikeEffect20 FILE=MODELS\LightningStrikeEffect2.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=LightningStrikeEffect2 MESH=LightningStrikeEffect2
#exec MESHMAP SCALE MESHMAP=LightningStrikeEffect2 X=0.3 Y=0.3 Z=0.6

#exec MESHMAP SETTEXTURE MESHMAP=LightningStrikeEffect2 NUM=0 TEXTURE=JLightningStrikeEffect20

#exec TEXTURE IMPORT FILE=MODELS\LSE200.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE201.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE202.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE203.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE204.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE205.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE206.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE207.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE208.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE209.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE210.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE211.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE212.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE213.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE214.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE215.PCX GROUP=Effects

var() float FrameInterval;
var() Texture SkinAnim[15];
var	int	SkinAnimIndex;

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	FrameInterval -= DeltaTime;
	while( FrameInterval <= 0.0 ) 
	{
		FrameInterval += default.FrameInterval;
		Skin = SkinAnim[SkinAnimIndex++];
		if( SkinAnimIndex >= ArrayCount(SkinAnim) )
		{
			SkinAnimIndex = 4;
		}
	}
}
	
defaultproperties
{
    FrameInterval=0.05
    SkinAnim(0)=Texture'Effects.LSE201'
    SkinAnim(1)=Texture'Effects.LSE202'
    SkinAnim(2)=Texture'Effects.LSE203'
    SkinAnim(3)=Texture'Effects.LSE204'
    SkinAnim(4)=Texture'Effects.LSE205'
    SkinAnim(5)=Texture'Effects.LSE206'
    SkinAnim(6)=Texture'Effects.LSE207'
    SkinAnim(7)=Texture'Effects.LSE208'
    SkinAnim(8)=Texture'Effects.LSE209'
    SkinAnim(9)=Texture'Effects.LSE210'
    SkinAnim(10)=Texture'Effects.LSE211'
    SkinAnim(11)=Texture'Effects.LSE212'
    SkinAnim(12)=Texture'Effects.LSE213'
    SkinAnim(13)=Texture'Effects.LSE214'
    SkinAnim(14)=Texture'Effects.LSE215'
    RemoteRole=0
    DrawType=2
    Skin=Texture'Effects.LSE200'
    Mesh=Mesh'LightningStrikeEffect2'
    bUnlit=True
}
