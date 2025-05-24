//=============================================================================
// Scout used for path generation.
//=============================================================================
class Scout extends Pawn
	native;

function PreBeginPlay()
{
	Destroy(); //scouts shouldn't exist during play
}

defaultproperties
{
    AccelRate=1.00
    SightRadius=4100.00
    CombatStyle=4.36346778309305678E24
    CollisionRadius=30.00
    CollisionHeight=61.00
    bCollideActors=False
    bCollideWorld=False
    bBlockActors=False
    bBlockPlayers=False
    bProjTarget=False
}
