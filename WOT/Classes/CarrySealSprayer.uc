//------------------------------------------------------------------------------
// CarrySealSprayer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class CarrySealSprayer expands ParticleSprayer;

var ParticleSprayer Nimbus;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay(); 
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	// don't call Super.Tick( DeltaTime );
	if( Nimbus == None && !bDeleteMe )
	{
		Nimbus = Spawn( class'CarrySealNimbusSprayer', Self,, Location, Rotation );
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Nimbus != None )
	{
		Nimbus.bOn = false;
		Nimbus.LifeSpan = 1.0;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function SetColor( name Color )
{
	switch( Color )
	{
	case 'PC_Purple':
	case 'Purple': 
		Particles[0] = Texture( DynamicLoadObject( "WOT.CarryingSeal.CSsealPurple", class'Texture' ) );
		break;
	
	case 'PC_Red':
	case 'Red': 
		Particles[0] = Texture( DynamicLoadObject( "WOT.CarryingSeal.CSsealRed", class'Texture' ) );
		break;
	
	case 'PC_Blue':
	case 'Blue': 
		Particles[0] = Texture( DynamicLoadObject( "WOT.CarryingSeal.CSsealBlue", class'Texture' ) );
		break;
	
	case 'PC_Yellow':
	case 'Yellow': 
	case 'PC_Gold':
	case 'Gold': 
		Particles[0] = Texture( DynamicLoadObject( "WOT.CarryingSeal.CSsealYellow", class'Texture' ) );
		break;
	
	case 'PC_Green':
	case 'Green': 
	default:
		Particles[0] = Texture( DynamicLoadObject( "WOT.CarryingSeal.CSsealGreen", class'Texture' ) );
		break;
	}
}

defaultproperties
{
     Spread=15.000000
     Volume=11.000000
     NumTemplates=1
     Templates(0)=(LifeSpan=1.750000,MaxInitialVelocity=5.000000,MinInitialVelocity=-5.000000,MaxDrawScale=0.120000,MinDrawScale=0.050000,MaxScaleGlow=0.700000,MinScaleGlow=0.500000,GrowPhase=2,MaxGrowRate=0.250000,MinGrowRate=0.150000,FadePhase=1,MaxFadeRate=-0.600000,MinFadeRate=-0.500000)
     Templates(1)=(LifeSpan=0.550000,Weight=7.000000,MaxInitialVelocity=90.000000,MinInitialVelocity=-90.000000,MaxDrawScale=0.100000,MinDrawScale=0.050000,MaxScaleGlow=-1.250000,MinScaleGlow=0.750000,GrowPhase=2,MaxGrowRate=0.050000,MinGrowRate=0.500000,FadePhase=1,MaxFadeRate=-0.900000,MinFadeRate=-1.000000)
     Particles(0)=Texture'WOT.CarryingSeal.CSsealGreen'
     bOn=True
     MinVolume=0.250000
     bGrouped=True
     bDisableTick=False
     bStatic=False
     bTrailerSameRotation=True
     bTrailerPrePivot=True
     Physics=PHYS_Trailer
     RemoteRole=ROLE_SimulatedProxy
     PrePivot=(Z=75.000000)
     VisibilityRadius=0.000000
     VisibilityHeight=0.000000
}
