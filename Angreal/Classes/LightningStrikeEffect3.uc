//------------------------------------------------------------------------------
// LightningStrikeEffect3.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LightningStrikeEffect3 expands Effects;

#exec MESH IMPORT MESH=LightningStrikeEffect1 ANIVFILE=MODELS\LightningStrikeEffect1_a.3d DATAFILE=MODELS\LightningStrikeEffect1_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LightningStrikeEffect1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=LightningStrikeEffect1 SEQ=All   STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=LightningStrikeEffect1 SEQ=LightningStrikeEffect1 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JLightningStrikeEffect10 FILE=MODELS\LightningStrikeEffect1.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=LightningStrikeEffect1 MESH=LightningStrikeEffect1
#exec MESHMAP SCALE MESHMAP=LightningStrikeEffect1 X=0.3 Y=0.3 Z=0.6

#exec MESHMAP SETTEXTURE MESHMAP=LightningStrikeEffect1 NUM=0 TEXTURE=JLightningStrikeEffect10

#exec TEXTURE IMPORT FILE=MODELS\LSE101.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE102.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE103.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE104.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE105.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE106.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE107.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE108.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE109.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE110.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE111.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE112.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE113.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE114.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE115.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE116.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE117.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE118.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE119.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE120.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE121.PCX GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE122.PCX GROUP=Effects

var() 	float	FrameInterval;
var()	Texture	SkinAnim[22];
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
			SkinAnimIndex = 0;
		}
	}
}

defaultproperties
{
     FrameInterval=0.050000
     SkinAnim(0)=Texture'Angreal.Effects.LSE101'
     SkinAnim(1)=Texture'Angreal.Effects.LSE102'
     SkinAnim(2)=Texture'Angreal.Effects.LSE103'
     SkinAnim(3)=Texture'Angreal.Effects.LSE104'
     SkinAnim(4)=Texture'Angreal.Effects.LSE105'
     SkinAnim(5)=Texture'Angreal.Effects.LSE106'
     SkinAnim(6)=Texture'Angreal.Effects.LSE107'
     SkinAnim(7)=Texture'Angreal.Effects.LSE108'
     SkinAnim(8)=Texture'Angreal.Effects.LSE109'
     SkinAnim(9)=Texture'Angreal.Effects.LSE110'
     SkinAnim(10)=Texture'Angreal.Effects.LSE111'
     SkinAnim(11)=Texture'Angreal.Effects.LSE112'
     SkinAnim(12)=Texture'Angreal.Effects.LSE113'
     SkinAnim(13)=Texture'Angreal.Effects.LSE114'
     SkinAnim(14)=Texture'Angreal.Effects.LSE115'
     SkinAnim(15)=Texture'Angreal.Effects.LSE116'
     SkinAnim(16)=Texture'Angreal.Effects.LSE117'
     SkinAnim(17)=Texture'Angreal.Effects.LSE118'
     SkinAnim(18)=Texture'Angreal.Effects.LSE119'
     SkinAnim(19)=Texture'Angreal.Effects.LSE120'
     SkinAnim(20)=Texture'Angreal.Effects.LSE121'
     SkinAnim(21)=Texture'Angreal.Effects.LSE122'
     RemoteRole=ROLE_None
     DrawType=DT_Mesh
     Skin=Texture'Angreal.Effects.LSE122'
     Mesh=Mesh'Angreal.LightningStrikeEffect1'
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=190
     LightHue=204
     LightSaturation=204
     LightRadius=8
}
