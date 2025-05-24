//------------------------------------------------------------------------------
// LSImpact.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LSImpact expands Effects;

#exec MESH IMPORT MESH=LSimpact ANIVFILE=MODELS\LSimpact_a.3d DATAFILE=MODELS\LSimpact_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LSimpact X=0 Y=0 Z=0 YAW=64 PITCH=0 ROLL=0

#exec MESH SEQUENCE MESH=LSimpact SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\Limpact_A01.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A02.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A03.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A04.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A05.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A06.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A07.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A08.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A09.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A10.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A11.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A12.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A13.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A14.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A15.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A16.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A17.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A18.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Limpact_A19.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=LSimpact MESH=LSimpact
#exec MESHMAP SCALE MESHMAP=LSimpact X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=LSimpact NUM=0 TEXTURE=Limpact_A01

var() 	float	FrameInterval;
var()	Texture	SkinAnim[19];
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
    FrameInterval=0.05
    SkinAnim(0)=Texture'Skins.Limpact_A01'
    SkinAnim(1)=Texture'Skins.Limpact_A02'
    SkinAnim(2)=Texture'Skins.Limpact_A03'
    SkinAnim(3)=Texture'Skins.Limpact_A04'
    SkinAnim(4)=Texture'Skins.Limpact_A05'
    SkinAnim(5)=Texture'Skins.Limpact_A06'
    SkinAnim(6)=Texture'Skins.Limpact_A07'
    SkinAnim(7)=Texture'Skins.Limpact_A08'
    SkinAnim(8)=Texture'Skins.Limpact_A09'
    SkinAnim(9)=Texture'Skins.Limpact_A10'
    SkinAnim(10)=Texture'Skins.Limpact_A11'
    SkinAnim(11)=Texture'Skins.Limpact_A12'
    SkinAnim(12)=Texture'Skins.Limpact_A13'
    SkinAnim(13)=Texture'Skins.Limpact_A14'
    SkinAnim(14)=Texture'Skins.Limpact_A15'
    SkinAnim(15)=Texture'Skins.Limpact_A16'
    SkinAnim(16)=Texture'Skins.Limpact_A17'
    SkinAnim(17)=Texture'Skins.Limpact_A18'
    SkinAnim(18)=Texture'Skins.Limpact_A19'
    RemoteRole=0
    DrawType=2
    Style=3
    Skin=Texture'Skins.Limpact_A01'
    Mesh=Mesh'LSImpact'
    DrawScale=4.00
    AmbientGlow=200
    bUnlit=True
    LightType=1
    LightEffect=13
    LightBrightness=190
    LightHue=204
    LightSaturation=204
    LightRadius=8
}
