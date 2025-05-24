//------------------------------------------------------------------------------
// Coal.uc
// $Author: Mfox $
// $Date: 10/02/99 4:47p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class Coal expands BounceableDecoration;

#exec MESH IMPORT MESH=LavaRock ANIVFILE=MODELS\LavaRock_a.3d DATAFILE=MODELS\LavaRock_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LavaRock X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=LavaRock SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\LavaRock3D.PCX GROUP=Skins FLAGS=2 // LavaRock3D

#exec MESHMAP NEW   MESHMAP=LavaRock MESH=LavaRock
#exec MESHMAP SCALE MESHMAP=LavaRock X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=LavaRock NUM=1 TEXTURE=LavaRock3D

//------------------------------------------------------------------------------
function ZoneChange( ZoneInfo NewZone )
{
	local FireballFizzle FF;

	if( NewZone.bWaterZone )
	{		
		FF = Spawn( class'FireballFizzle',,, Location + vect(0,0,56) );
		FF.DrawScale = 0.7;
		
		LightBrightness = 0;
	}
}

defaultproperties
{
     Damage=1.000000
     DamageType=burned
     Mesh=Mesh'WOTDecorations.LavaRock'
     DrawScale=0.300000
     CollisionRadius=4.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=204
     LightHue=12
     LightRadius=1
}
