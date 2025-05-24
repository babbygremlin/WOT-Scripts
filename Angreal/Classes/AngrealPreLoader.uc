//------------------------------------------------------------------------------
// AngrealPreLoader.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	Use this class to preload lazyloaded artifacts.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Place in level.
// + List angreal to load in ArtifactList.
//------------------------------------------------------------------------------
class AngrealPreLoader expands KeyPoint;

var() class<AngrealInventory> ArtifactList[50];

//------------------------------------------------------------------------------
simulated function PostBeginPlay()
{
	local int i;

	for( i = 0; i < ArrayCount(ArtifactList); i++ )
	{
		if( ArtifactList[i] != None )
		{
			if( ArtifactList[i].default.ActivateSoundName != "" )
			{
				DynamicLoadObject( ArtifactList[i].default.ActivateSoundName, class'Sound' );
			}

			if( ArtifactList[i].default.DeActivateSoundName != "" )
			{
				DynamicLoadObject( ArtifactList[i].default.DeActivateSoundName, class'Sound' );
			}

			if( class<ProjectileLauncher>( ArtifactList[i] ) != None && class<ProjectileLauncher>( ArtifactList[i] ).default.ProjectileClassName != "" )
			{
				DynamicLoadObject( class<ProjectileLauncher>( ArtifactList[i] ).default.ProjectileClassName, class'Class' );
			}
/* - ProjLeechArtifact is obsolete.
			if( class<ProjLeechArtifact>( ArtifactList[i] ) != None )
			{
				DynamicLoadObject( class<ProjLeechArtifact>( ArtifactList[i] ).default.ProjectileClassName, class'Class' );
				DynamicLoadObject( class<ProjLeechArtifact>( ArtifactList[i] ).default.LeechClassName, class'Class' );
			}
*/
		}
	}

	Destroy();
}

defaultproperties
{
     bNoDelete=True
     RemoteRole=ROLE_None
     bAlwaysRelevant=True
}
