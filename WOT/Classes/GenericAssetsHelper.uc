//=============================================================================
// GenericAssetHelper.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class GenericAssetsHelper expands LegendActorComponent;

//=============================================================================
// GenericAssetHelper:
//
// Wrapper class for handling various asset-related issues (texture/damage 
// sounds, animations, effects) as an Actor moves, takes damage etc.
//=============================================================================

var private class<GenericTextureHelper>	TextureHelperClass;		// texture helper class associated with this class
var private class<GenericDamageHelper>	DamageHelperClass;		// damage helper class associated with this class
var private Texture						CurrentSavedTexture;	// current texture maintained by this class
var private float						SavedImpactVelocity;	// used for fall related stuff

//=============================================================================

function AssignTextureHelper( Class<GenericTextureHelper> C )
{
	TextureHelperClass = C;
}

//=============================================================================

function AssignDamageHelper( Class<GenericDamageHelper> C )
{
	DamageHelperClass = C;
}

//=============================================================================

function HandleLandedOnTexture( float ImpactVelocity )
{
	// pawn is in the air so texture is None, setting the impact veolcity
	// ensures that a landed sound will be played with next texture notification
	SavedImpactVelocity = ImpactVelocity;
}

//=============================================================================

function HandleMovingOnTexture()
{
	TextureHelperClass.Static.HandleMovingOnTexture( Owner, CurrentSavedTexture );
}

//=============================================================================

function HandleTextureCallback( Texture T )
{
	CurrentSavedTexture = T;

	if( !(SavedImpactVelocity ~= 0.0) )
	{
		// User previously landed (prior to WalkTexture event). Now that we 
		// have the texture we can use it to play the correct landed sound.
		// Note that the texture returned by the WalkTexture event can 
		// sometimes be None in which case a default landed sound will be used.
		TextureHelperClass.static.HandleLandingOnTexture( Owner, CurrentSavedTexture, SavedImpactVelocity );

		SavedImpactVelocity = 0.0;
	}
}

//=============================================================================

function HandleDamage( float Damage, vector HitLocation, name DamageType )
{
	DamageHelperClass.static.HandleDamage( Owner, Damage, HitLocation, DamageType );
}

//=============================================================================

function Texture GetCurrentTexture()
{
	return CurrentSavedTexture;
}

//=============================================================================

defaultproperties
{
     Texture=None
}
