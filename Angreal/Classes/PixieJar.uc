//------------------------------------------------------------------------------
// PixieJar.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn
// + Call SetColor
// + Then call SetLightRadius (optional)
// (must be done in that order)
//------------------------------------------------------------------------------
class PixieJar expands Effects;

#exec TEXTURE IMPORT FILE=MODELS\Glass.pcx GROUP=Effects

var Pixie Tinker;			// Our pixie in a jar.

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	Tinker = Spawn( class'Pixie' );
}

//------------------------------------------------------------------------------
simulated function SetColor( name Color )
{
	switch( Color )
	{
	case 'Blue':	Tinker.SetMyActor( Spawn( class'PixieSprayerBlue'	,,,, rotator(vect(0,0,1)) ) );	break;
	case 'Green':	Tinker.SetMyActor( Spawn( class'PixieSprayerGreen'	,,,, rotator(vect(0,0,1)) ) );	break;
	case 'Purple':	Tinker.SetMyActor( Spawn( class'PixieSprayerPurple'	,,,, rotator(vect(0,0,1)) ) );	break;
	case 'Red':		Tinker.SetMyActor( Spawn( class'PixieSprayerRed'	,,,, rotator(vect(0,0,1)) ) );	break;
	case 'Yellow':	Tinker.SetMyActor( Spawn( class'PixieSprayerYellow'	,,,, rotator(vect(0,0,1)) ) );	break;
	}
}

//------------------------------------------------------------------------------
simulated function SetLightRadius( byte Radius )
{
	Tinker.SetLightRadius( Radius );
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	if( Tinker != None )
	{
		Tinker.SetLocation( Location );
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Tinker != None )
	{
		Tinker.Destroy();
	}

	Super.Destroyed();
}
		

defaultproperties
{
    RemoteRole=0
    DrawType=2
    Style=3
    Texture=None
    Skin=Texture'Effects.Glass'
    Mesh=Mesh'AMAPearl'
    DrawScale=0.20
    ScaleGlow=2.00
    CollisionRadius=9.00
    CollisionHeight=9.00
    bCollideWorld=True
}
