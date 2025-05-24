//=============================================================================
// RotatingMover.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================
class RotatingMover expands Mover;

var() rotator RotateRate;

function BeginPlay()
{
	Disable( 'Tick' );
}

function Tick( float DeltaTime )
{
	SetRotation( Rotation + (RotateRate*DeltaTime) );
}

function Trigger( Actor other, Pawn EventInstigator )
{
	Enable('Tick');
}

function UnTrigger( Actor other, Pawn EventInstigator )
{
	Disable('Tick');
}

defaultproperties
{
}
