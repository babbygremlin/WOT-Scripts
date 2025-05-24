//=============================================================================
// AnimationTableWOT.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 6 $
//=============================================================================

class AnimationTableWOT expands AnimationTableImpl abstract;

const MarkEntryAsInvalidValue = 999;

var() float AnimCanBeUsedRadiusMultiplier;

//=============================================================================
// Returns true if the given animation will not intersect with the level or any
// actors. Quick 'n dirty approach for now -- just try to move the SourceActor's
// CC along the AnimEndVector vector. If Actor is on terrain with much of a 
// slope to it -- CanActorMoveTo might fail. If we decide this is annoying
// because animations are limited because of this, we could do a more rigorous
// check to see if the animation can "fit".

static function bool AnimCanBeUsed( Actor SourceActor, AnimInfoT AnimInfo )
{
	local vector AnimVector;

	if( AnimInfo.AnimEndVector != vect(0,0,0) )
	{
		// don't normalize -- size of vector in properties ==> shift amount in units of collision radius
		AnimVector = ( AnimInfo.AnimEndVector >> SourceActor.Rotation );
	}
	else
	{
    	return true;
	}

	// any geometry in that direction?
	return class'util'.static.CanActorMoveTo( SourceActor, Normal(AnimVector), default.AnimCanBeUsedRadiusMultiplier*VSize(AnimVector)*SourceActor.CollisionRadius, false );
}

//=============================================================================
// Strip out animations which will intersect with geometry. For now this only
// applies to death animations.

static function FilterMatchingAnims( Actor SourceActor, 
									 out int MatchingEntries[10], 
									 out int NumMatchingAnims, 
								     out float TotalOdds, 
									 name LookupName )
{
	local int i, j;
	local int NumStrippedAnims;
	local int NumRemainingAnims;

	NumStrippedAnims = 0;
	if( LookupName == 'Death' )
	{
		// make sure any potential death animations won't intersect with geometry
		for( i=0; i<NumMatchingAnims; i++ )
		{
			if( !AnimCanBeUsed( SourceActor, default.AnimList[MatchingEntries[i]] ) )
			{
				// strip it out (flag by adding huge value for now)
				MatchingEntries[i] += MarkEntryAsInvalidValue;
			
				NumStrippedAnims++;
			}
		}
	}

	if( NumStrippedAnims == NumMatchingAnims )
	{
		// *all* anims would be stripped out, so keep them all
		for( i=0; i<NumMatchingAnims; i++ )
		{
			MatchingEntries[i] -= MarkEntryAsInvalidValue;
		}
	}
	else if( NumStrippedAnims != 0 )
	{
		NumRemainingAnims = NumMatchingAnims - NumStrippedAnims;

		// move all unfiltered entries to top of list
		i = 0;
		for( j=0; j<NumMatchingAnims; j++ )
		{
			if( MatchingEntries[j] < MarkEntryAsInvalidValue )
			{
				// keep this entry -- move it into the ith position
				MatchingEntries[i] = MatchingEntries[j];
				i++;
			}
			else
			{
				// this entry is zapped -- reduce Odds accordingly
				TotalOdds -= default.AnimList[ MatchingEntries[j]-MarkEntryAsInvalidValue ].AnimOdds;
			}
		}

		NumMatchingAnims = NumRemainingAnims;
	}
}

//=============================================================================

static function vector GetAnimEndVector( name LookupName )
{
	local int AnimIndex;

	for( AnimIndex=0; AnimIndex<ArrayCount(default.AnimList); AnimIndex++ )
	{
		// given name is a specific animation so look for this
		if( LookupName == default.AnimList[AnimIndex].EAnimInfo.AnimName )
		{
			// done -- should only be 1 match
			return default.AnimList[AnimIndex].AnimEndVector;
		}
	}

	warn( "ERROR (GetAnimAnimEndVector) -- animation not found: " $ LookupName );

	return vect(0,0,0);
}

//=============================================================================

defaultproperties
{
     AnimCanBeUsedRadiusMultiplier=1.000000
}
