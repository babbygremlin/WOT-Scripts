//=============================================================================
// LegacyTextures.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================
class LegacyTextures expands Effects;

#exec OBJ LOAD FILE=Textures\LegacyT.utx PACKAGE=WOT.WaterEffects

simulated function BeginPlay()
{
	Super.BeginPlay();
	DontUseThisClass();
}

simulated function DontUseThisClass()
{
	warn( "This class should not be placed in any levels.  It is used as a legacy asset holder only." );
	assert(false);
}

defaultproperties
{
}
