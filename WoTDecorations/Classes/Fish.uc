//=============================================================================
// Fish.
//=============================================================================
class Fish expands WOTDecoration;

#exec MESH IMPORT MESH=Fish ANIVFILE=MODELS\Fish_a.3d DATAFILE=MODELS\Fish_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Fish X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Fish SEQ=Frame01 STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Fish SEQ=Frame02 STARTFRAME=1 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Fish SEQ=Frame03 STARTFRAME=2 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JFish0 FILE=MODELS\Fish0.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=Fish MESH=Fish
#exec MESHMAP SCALE MESHMAP=Fish X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Fish NUM=0 TEXTURE=JFish0

var float AnimRate;
var() bool bRateControlsTweening;

auto simulated state() AnimatedFish
{
Begin:
	AnimRate = RandRange( MinAnimRate, MaxAnimRate );
	
	if( bRateControlsTweening )
	{
		while( true )
		{
			PlayAnim( 'Frame01', 1.0, AnimRate );
			FinishAnim();
			PlayAnim( 'Frame02', 1.0, AnimRate );
			FinishAnim();
			PlayAnim( 'Frame01', 1.0, AnimRate );
			FinishAnim();
			PlayAnim( 'Frame03', 1.0, AnimRate );
			FinishAnim();
		}
	}
	else
	{		
		while( true )
		{
			PlayAnim( 'Frame01', AnimRate );
			FinishAnim();
			PlayAnim( 'Frame02', AnimRate );
			FinishAnim();
			PlayAnim( 'Frame01', AnimRate );
			FinishAnim();
			PlayAnim( 'Frame03', AnimRate );
			FinishAnim();
		}
	}
}

defaultproperties
{
     MaxAnimRate=2.000000
     MinAnimRate=0.500000
     bStatic=False
     bStasis=False
     bCanFallOutOfWorld=True
     RemoteRole=ROLE_None
     Mesh=Mesh'WOTDecorations.Fish'
}
