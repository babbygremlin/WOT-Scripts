//=============================================================================
// FireWall.uc
// $Author: Jcrable $
// $Date: 10/20/99 4:24p $
// $Revision: 3 $
//=============================================================================
class FireWall expands Wall;

function rotator GetSlabRotation( int i, vector StartNormal )
{
	return rotator( StartNormal );
}

function actor AnyActorsInArea( vector SearchLocation, int SearchDistance )
{
	local Actor A;
	
	foreach RadiusActors( class'Actor', A, SearchDistance, SearchLocation ) 
	{
		if( !SameLogicalActor( A ) &&  !A.bHidden && A.bCollideActors ) //NEW 9/7/1999 fixed Tutorial trap placement by adding bCollideActors
		{
			return A;
		}
	}

	foreach RadiusActors( class'Actor', A, SearchDistance * 2, SearchLocation )
	{
		if( A.IsA( 'Teleporter' ) )
		{
			if( VSize( A.Location - SearchLocation ) < 1000 )
			{
				return A;
			}
		}
	}
	
	return None;
}

defaultproperties
{
     SlabClass=Class'WOTTraps.FireWallSlab'
     MaxSlabs=18
}
