//------------------------------------------------------------------------------
// ReflectSkinEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class ReflectSkinEffect expands Effects;

#exec TEXTURE IMPORT FILE=MODELS\RefPurple.pcx	GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\RefBlue.pcx	GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\RefRed.pcx		GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\RefYellow.pcx	GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\RefGreen.pcx	GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\RefWhite.pcx	GROUP=Effects

#exec TEXTURE IMPORT FILE=MODELS\RefMPurple.pcx	GROUP=MottledEffects
#exec TEXTURE IMPORT FILE=MODELS\RefMBlue.pcx	GROUP=MottledEffects
#exec TEXTURE IMPORT FILE=MODELS\RefMRed.pcx	GROUP=MottledEffects
#exec TEXTURE IMPORT FILE=MODELS\RefMYellow.pcx	GROUP=MottledEffects
#exec TEXTURE IMPORT FILE=MODELS\RefMGreen.pcx	GROUP=MottledEffects
#exec TEXTURE IMPORT FILE=MODELS\RefMWhite.pcx	GROUP=MottledEffects

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local float Scalar;

	Super.Tick( DeltaTime );

	// Hide from First person perspective.
	if( PlayerPawn(Owner) != None )
	{
		bOwnerNoSee = PlayerPawn(Owner).ViewTarget == None;
	}

	// Scale values over lifespan.
	Scalar = LifeSpan / default.LifeSpan;
	ScaleGlow = default.ScaleGlow * Scalar;
	AmbientGlow = default.AmbientGlow * Scalar;
	LightBrightness = default.LightBrightness * Scalar;
}

//------------------------------------------------------------------------------
simulated function SetColor( name Color, optional bool bMottled )
{
	switch( Color )
	{
	case 'PC_Green':
	case 'Green': 
		LightBrightness = 255; LightHue =  64; LightSaturation =   0;
		if( !bMottled )
			SetTexture( Texture'Angreal.Effects.RefGreen' );
		else
			SetTexture( Texture'Angreal.MottledEffects.RefMGreen' );
		break;
	
	case 'PC_Purple':
	case 'Purple': 
		LightBrightness = 255; LightHue = 212; LightSaturation =   0;
		if( !bMottled )
			SetTexture( Texture'Angreal.Effects.RefPurple' );
		else
			SetTexture( Texture'Angreal.MottledEffects.RefMPurple' );
		break;
	
	case 'PC_Red':
	case 'Red': 
		LightBrightness = 255; LightHue =   0; LightSaturation =   0;
		if( !bMottled )
			SetTexture( Texture'Angreal.Effects.RefRed' );
		else
			SetTexture( Texture'Angreal.MottledEffects.RefMRed' );
		break;
	
	case 'PC_Blue':
	case 'Blue': 
		LightBrightness = 255; LightHue = 160; LightSaturation =   0;
		if( !bMottled )
			SetTexture( Texture'Angreal.Effects.RefBlue' );
		else
			SetTexture( Texture'Angreal.MottledEffects.RefMBlue' );
		break;
	
	case 'PC_Yellow':
	case 'Yellow': 
	case 'PC_Gold':
	case 'Gold': 
		LightBrightness = 255; LightHue =  32; LightSaturation =   0;
		if( !bMottled )
			SetTexture( Texture'Angreal.Effects.RefYellow' );
		else
			SetTexture( Texture'Angreal.MottledEffects.RefMYellow' );
		break;
	
	case 'PC_White':
	case 'White':
	default:
		LightBrightness = 255; LightHue =   0; LightSaturation = 255;
		if( !bMottled )
			SetTexture( Texture'Angreal.Effects.RefWhite' );
		else
			SetTexture( Texture'Angreal.MottledEffects.RefMWhite' );
		break;
	}
}

//------------------------------------------------------------------------------
simulated function SetTexture( Texture T )
{
	local int i;

	Texture = T;
	Skin = T;

	for( i = 0; i < ArrayCount(MultiSkins); i++ )
	{
		MultiSkins[i] = T;
	}
}

defaultproperties
{
     bAnimByOwner=True
     bNetTemporary=False
     bTrailerSameRotation=True
     Physics=PHYS_Trailer
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'Angreal.Effects.RefWhite'
     Skin=Texture'Angreal.Effects.RefWhite'
     ScaleGlow=0.500000
     AmbientGlow=64
     Fatness=157
     bUnlit=True
     MultiSkins(0)=Texture'Angreal.Effects.RefWhite'
     MultiSkins(1)=Texture'Angreal.Effects.RefWhite'
     MultiSkins(2)=Texture'Angreal.Effects.RefWhite'
     MultiSkins(3)=Texture'Angreal.Effects.RefWhite'
     MultiSkins(4)=Texture'Angreal.Effects.RefWhite'
     MultiSkins(5)=Texture'Angreal.Effects.RefWhite'
     MultiSkins(6)=Texture'Angreal.Effects.RefWhite'
     MultiSkins(7)=Texture'Angreal.Effects.RefWhite'
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=204
     LightSaturation=204
     LightRadius=12
}
