//=============================================================================
// FocusSelectorOnGreatestLOS.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class FocusSelectorOnGreatestLOS expands FocusSelectorOnActor;



static function bool SelectFocus( GoalAbstracterInterf Focus,
		GoalAbstracterInterf SelectedWaypoint,
		Actor FocusingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	class'Debug'.static.DebugLog( FocusingActor, "SelectFocus", default.DebugCategoryName );
	SelectFocusOnGreatestLineOfSight( Focus, SelectedWaypoint, FocusingActor,
			Constrainer, Goal );
	return true;
}



//attempt to initialize the focus from the goal if not possible
//initialize the focus from the moving actor
static function SelectFocusOnGreatestLineOfSight( GoalAbstracterInterf Focus,
		GoalAbstracterInterf SelectedWaypoint,
		Actor FocusingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local Vector FocusLocation;
	local Rotator FocusRotation;

	class'Debug'.static.DebugLog( FocusingActor, "SelectFocusOnGreatestLineOfSight", default.DebugCategoryName );
	FocusLocation = GetFocusLocationWithGreatestLineOfSight( FocusingActor );
	Constrainer.ConstrainActorFocusAndRotation( FocusLocation, FocusRotation,
			FocusLocation, FocusingActor );
	Focus.AssignVector( FocusingActor, FocusLocation, false );
	Focus.SetAssociatedRotation( FocusingActor, FocusRotation );
}



static final function vector GetFocusLocationWithGreatestLineOfSight( Actor FocusingActor )
{
    local float BestDist, CurDist, CurAngleInRads;
    local int BestIdx, CurIdx;
    local float Distances[ 8 ];
    local vector Locations[ 8 ];
    local vector TraceHitNormal, TraceHitLocation;

    //Find trace end points in four cardinal directions plus diagonals
    CurAngleInRads = 0.0;
    for( CurIdx = 0; CurIdx < ArrayCount( Locations ); ++CurIdx )
    {
        Locations[ CurIdx ].X = ( sin( CurAngleInRads ) * 16000.0 );
        Locations[ CurIdx ].Y = ( cos( CurAngleInRads ) * 16000.0 );
        Locations[ CurIdx ].Z = 0.0;
        Locations[ CurIdx ] += FocusingActor.Location;
        CurAngleInRads += ( 2 * pi ) / 8;
        FocusingActor.Trace( TraceHitLocation, TraceHitNormal, Locations[ CurIdx ] );
        Distances[ CurIdx ] = VSize( FocusingActor.Location - TraceHitLocation );
    }
        
    // now select the ending trace point with the greatest unobstructed distance
    BestDist = 0.0;
    for( CurIdx = 0; CurIdx < ArrayCount( Locations ); ++CurIdx )
    {
        // Total distance in current direction, 45o left and 45o right.
        CurDist = Distances[ CurIdx ] + Distances[ ( CurIdx + 1 ) % ArrayCount( Distances ) ] +
        		Distances[ ( CurIdx + ArrayCount( Distances ) - 1 ) % ArrayCount( Distances ) ];
        if( CurDist > BestDist )
        {
            BestDist = CurDist;
            BestIdx = CurIdx;
        }
    }
}

defaultproperties
{
}
