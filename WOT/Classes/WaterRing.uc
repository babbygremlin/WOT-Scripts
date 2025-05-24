//=============================================================================
// WaterRing.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================
class WaterRing expands Effects;

#exec OBJ LOAD FILE=Textures\fireeffect56.utx  PACKAGE=WOT.Effect56

simulated function Tick( float DeltaTime )
{
	if( Level.NetMode != NM_DedicatedServer )
	{
		ScaleGlow = Lifespan / Default.Lifespan;
		AmbientGlow = ScaleGlow * 255;
	}
}

simulated function PostBeginPlay()
{
	if( Instigator != None )
		MakeNoise( 0.5 );
}

defaultproperties
{
     bNetOptional=True
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.800000
     DrawType=DT_Mesh
     Style=STY_None
     DrawScale=0.700000
     ScaleGlow=1.100000
}
