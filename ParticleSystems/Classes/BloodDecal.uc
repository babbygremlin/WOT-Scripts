//------------------------------------------------------------------------------
// BloodDecal.uc
// $Author: Aleiby $
// $Date: 9/13/99 11:42p $
// $Revision: 2 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
// How this class works:
//------------------------------------------------------------------------------
class BloodDecal expands Decal;

var() Texture BloodTextures[15];

//------------------------------------------------------------------------------
simulated function BeginPlay()
{
	local int i;

	Super.BeginPlay();

	Skin = None;
	while( Skin == None && i < 100 )
	{
		Skin = BloodTextures[ Rand( ArrayCount(BloodTextures) ) ];
		i++;	// to prevent an infinite loop if there are no BloodTextures.
	}

	if( Skin == None )
	{
		warn( "Couldn't find a valid BloodTexture to use as a Skin." );
		Destroy();
	}
}

defaultproperties
{
     BloodTextures(0)=Texture'ParticleSystems.ModulatedBlood.Blood05'
     BloodTextures(1)=Texture'ParticleSystems.ModulatedBlood.Blood06'
     BloodTextures(2)=Texture'ParticleSystems.ModulatedBlood.Blood07'
     BloodTextures(3)=Texture'ParticleSystems.ModulatedBlood.Blood08'
     BloodTextures(4)=Texture'ParticleSystems.ModulatedBlood.Blood09'
     BloodTextures(5)=Texture'ParticleSystems.ModulatedBlood.Blood10'
     BloodTextures(6)=Texture'ParticleSystems.ModulatedBlood.Blood11'
     BloodTextures(7)=Texture'ParticleSystems.ModulatedBlood.Blood12'
     BloodTextures(8)=Texture'ParticleSystems.ModulatedBlood.Blood13'
     BloodTextures(9)=Texture'ParticleSystems.ModulatedBlood.Blood15'
     BloodTextures(10)=Texture'ParticleSystems.ModulatedBlood.Blood16'
     BloodTextures(11)=Texture'ParticleSystems.ModulatedBlood.Blood17'
     BloodTextures(12)=Texture'ParticleSystems.ModulatedBlood.Blood18'
     BloodTextures(13)=Texture'ParticleSystems.ModulatedBlood.Blood19'
     BloodTextures(14)=Texture'ParticleSystems.ModulatedBlood.Blood04'
     DetailLevel=2
     GoreLevel=2
     DrawScale=0.700000
}
