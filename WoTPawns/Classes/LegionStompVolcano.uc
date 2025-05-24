//=============================================================================
// LegionStompVolcano.
//=============================================================================
class LegionStompVolcano expands Effects;

#exec MESH IMPORT MESH=LegionStompVolcano ANIVFILE=MODELS\LegionStompVolcano_a.3d DATAFILE=MODELS\LegionStompVolcano_d.3d X=0 Y=0 Z=0 MLOD=0
#forceexec MESH ORIGIN MESH=LegionStompVolcano X=0 Y=0 Z=16

#exec MESH SEQUENCE MESH=LegionStompVolcano SEQ=All                STARTFRAME=0 NUMFRAMES=21
#exec MESH SEQUENCE MESH=LegionStompVolcano SEQ=LegionStompVolcano STARTFRAME=0 NUMFRAMES=21
#exec MESH SEQUENCE MESH=LegionStompVolcano SEQ=VolcanoStageOne     STARTFRAME=0 NUMFRAMES=10;
#exec MESH SEQUENCE MESH=LegionStompVolcano SEQ=VolcanoStageTwo    STARTFRAME=11 NUMFRAMES=1;
#exec MESH SEQUENCE MESH=LegionStompVolcano SEQ=VolcanoStageThree     STARTFRAME=12 NUMFRAMES=10;
#exec TEXTURE IMPORT FILE=MODELS\LegionStompVolcano.PCX GROUP=Skins FLAGS=2
#exec MESHMAP NEW   MESHMAP=LegionStompVolcano MESH=LegionStompVolcano
#exec MESHMAP SCALE MESHMAP=LegionStompVolcano X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=LegionStompVolcano NUM=1 TEXTURE=LegionStompVolcano


auto simulated state Erupt
{
	simulated function PreBeginPlay()
	{
		Super.BeginPlay();
	}
	
	simulated function BeginState()
	{
		SetCollisionSize( 48, 16 );
		Spawn( class'LegionStompSprayerA',,, Location + vect( 0, 0, 32 ), rotator(vect(0,0,1)) );
		Spawn( class'LegionStompSprayerB',,, Location + vect( 0, 0, 32 ), rotator(vect(0,0,1)) );
		Spawn( class'LegionStompSprayerC',,, Location + vect( 0, 0, 32 ), rotator(vect(0,0,1)) );
		Spawn( class'LegionStompSprayerD',,, Location + vect( 0, 0, 32 ), rotator(vect(0,0,1)) );
	}
		
	simulated function Touch( Actor Other )
	{
		if( Other.IsA( 'Pawn' ) )
		{
			if( Pawn( Other ).Physics == PHYS_Walking )
			{
				Pawn( Other ).SetPhysics( PHYS_Falling );
				Pawn( Other ).Velocity.Z += 256;
			}
			Pawn( Other ).TakeDamage( 10, Pawn( Owner ), Pawn( Other ).Location, vect( 0, 0, 0 ), 'xxFxx' );
			if( PlayerPawn( Other ) != None )
			{
				PlayerPawn( Other ).ShakeView( 0.6, 3500, -50 );
			}
		}
	}
	
Begin:
	PlayAnim( 'VolcanoStageOne', 0.5 );
	FinishAnim();
	PlayAnim( 'VolcanoStageThree', 0.5 );
	FinishAnim();
	Destroy();
}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Mesh
     bMustFace=False
     Mesh=Mesh'WOTPawns.LegionStompVolcano'
     DrawScale=1.750000
     bCollideActors=True
     bCollideWorld=True
}
