//=============================================================================
// SoulBarbImpact.
//=============================================================================
class SoulBarbImpact expands Effects;

#exec MESH IMPORT MESH=SoulBarbImpact ANIVFILE=MODELS\SoulBarbImpact_a.3d DATAFILE=MODELS\SoulBarbImpact_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=SoulBarbImpact X=0 Y=0 Z=0 PITCH=0 YAW=-64 ROLL=64

#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=All   STARTFRAME=0 NUMFRAMES=18
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame0 STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame1   STARTFRAME=1 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame2   STARTFRAME=2 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame3   STARTFRAME=3 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame4   STARTFRAME=4 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame5   STARTFRAME=5 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame6   STARTFRAME=6 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame7   STARTFRAME=7 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame8   STARTFRAME=8 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame9   STARTFRAME=9 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame10   STARTFRAME=10 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame11   STARTFRAME=11 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame12   STARTFRAME=12 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame13   STARTFRAME=13 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame14   STARTFRAME=14 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame15   STARTFRAME=15 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame16   STARTFRAME=16 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SoulBarbImpact SEQ=Frame17  STARTFRAME=17 NUMFRAMES=1

//#exec TEXTURE IMPORT NAME=JSoulBarbImpact01 FILE=MODELS\SoulBarbImpact01.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=SoulBarbImpact MESH=SoulBarbImpact
#exec MESHMAP SCALE MESHMAP=SoulBarbImpact X=0.6 Y=0.6 Z=1.2

#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact01.PCX GROUP=Effects NAME=DSoulBarbImpact01
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact02.PCX GROUP=Effects NAME=DSoulBarbImpact02
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact03.PCX GROUP=Effects NAME=DSoulBarbImpact03
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact04.PCX GROUP=Effects NAME=DSoulBarbImpact04
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact05.PCX GROUP=Effects NAME=DSoulBarbImpact05
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact06.PCX GROUP=Effects NAME=DSoulBarbImpact06
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact07.PCX GROUP=Effects NAME=DSoulBarbImpact07
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact08.PCX GROUP=Effects NAME=DSoulBarbImpact08
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact09.PCX GROUP=Effects NAME=DSoulBarbImpact09
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact10.PCX GROUP=Effects NAME=DSoulBarbImpact10
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact11.PCX GROUP=Effects NAME=DSoulBarbImpact11
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact12.PCX GROUP=Effects NAME=DSoulBarbImpact12
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact13.PCX GROUP=Effects NAME=DSoulBarbImpact13
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact14.PCX GROUP=Effects NAME=DSoulBarbImpact14
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact15.PCX GROUP=Effects NAME=DSoulBarbImpact15
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact16.PCX GROUP=Effects NAME=DSoulBarbImpact16
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact17.PCX GROUP=Effects NAME=DSoulBarbImpact17
#exec TEXTURE IMPORT FILE=MODELS\SoulBarbImpact18.PCX GROUP=Effects NAME=DSoulBarbImpact18

#exec MESHMAP SETTEXTURE MESHMAP=SoulBarbImpact NUM=0 TEXTURE=DSoulBarbImpact01

var() 	float	FrameInterval;
var()	Texture	SkinAnim[18];
var	int	SkinAnimIndex;

var vector OwnerLocation;

replication
{
	reliable if( Role==ROLE_Authority && Owner!=None && !Owner.bNetRelevant )
		OwnerLocation;
}

//-----------------------------------------------------------------
simulated function name GetSequenceName( int Index )
{
	// Is there a better way to do this?
	
	switch( Index )
	{
	case 0:		return 'Frame0';	break;
	case 1:		return 'Frame1';	break;
	case 2:		return 'Frame2';	break;
	case 3:		return 'Frame3';	break;
	case 4:		return 'Frame4';	break;
	case 5:		return 'Frame5';	break;
	case 6:		return 'Frame6';	break;
	case 7:		return 'Frame7';	break;
	case 8:		return 'Frame8';	break;
	case 9:		return 'Frame9';	break;
	case 10:	return 'Frame10';	break;
	case 11:	return 'Frame11';	break;
	case 12:	return 'Frame12';	break;
	case 13:	return 'Frame13';	break;
	case 14:	return 'Frame14';	break;
	case 15:	return 'Frame15';	break;
	case 16:	return 'Frame16';	break;
	case 17:	return 'Frame17';	break;
	default:
		log( "*** SoulBarbImpact: Asked for invalid frame index " $Index );
		break;
	}
}

//-----------------------------------------------------------------
auto simulated state Glowing
{
	simulated function BeginState()
	{
		SkinAnimIndex = 0;
	}

	simulated function Tick( float DeltaTime )
	{
		
		if( Owner != None )
		{
			OwnerLocation = Owner.Location;
		}

		SetLocation( OwnerLocation );

		FrameInterval -= DeltaTime;
		if( FrameInterval <= 0.0 ) {
			FrameInterval = Default.FrameInterval;
			Skin = SkinAnim[SkinAnimIndex];
			PlayAnim( GetSequenceName( SkinAnimIndex ), 0.5 );
			SkinAnimIndex++;
			if( SkinAnimIndex >= ArrayCount(SkinAnim) ) {
				SkinAnimIndex = 0;
				Destroy();
			}
		}
	}
	
begin:
	PlayAnim( 'Frame0', 0.5 );
	SkinAnimIndex++;
}

defaultproperties
{
     FrameInterval=0.050000
     SkinAnim(0)=Texture'WOT.Effects.DSoulBarbImpact01'
     SkinAnim(1)=Texture'WOT.Effects.DSoulBarbImpact02'
     SkinAnim(2)=Texture'WOT.Effects.DSoulBarbImpact03'
     SkinAnim(3)=Texture'WOT.Effects.DSoulBarbImpact04'
     SkinAnim(4)=Texture'WOT.Effects.DSoulBarbImpact05'
     SkinAnim(5)=Texture'WOT.Effects.DSoulBarbImpact06'
     SkinAnim(6)=Texture'WOT.Effects.DSoulBarbImpact07'
     SkinAnim(7)=Texture'WOT.Effects.DSoulBarbImpact08'
     SkinAnim(8)=Texture'WOT.Effects.DSoulBarbImpact09'
     SkinAnim(9)=Texture'WOT.Effects.DSoulBarbImpact10'
     SkinAnim(10)=Texture'WOT.Effects.DSoulBarbImpact11'
     SkinAnim(11)=Texture'WOT.Effects.DSoulBarbImpact12'
     SkinAnim(12)=Texture'WOT.Effects.DSoulBarbImpact13'
     SkinAnim(13)=Texture'WOT.Effects.DSoulBarbImpact14'
     SkinAnim(14)=Texture'WOT.Effects.DSoulBarbImpact15'
     SkinAnim(15)=Texture'WOT.Effects.DSoulBarbImpact16'
     SkinAnim(16)=Texture'WOT.Effects.DSoulBarbImpact17'
     SkinAnim(17)=Texture'WOT.Effects.DSoulBarbImpact18'
     RemoteRole=ROLE_None
     DrawType=DT_Mesh
     Skin=Texture'WOT.Effects.DSoulBarbImpact01'
     Mesh=Mesh'WOT.SoulBarbImpact'
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=64
     LightHue=96
     LightSaturation=128
     LightRadius=8
}
