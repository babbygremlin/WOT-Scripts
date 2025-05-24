//=============================================================================
// InfoSpammer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class InfoSpammer expands LegendActorComponent;

var() float TimeBetweenUpdates;
var() bool bSpamEnabled;

var private float TimeToNextUpdate;

static function InfoSpammer GetTypeInstance( Actor Owner, Class<InfoSpammer> C )
{
	local Actor A;
	local InfoSpammer Spammer;

	ForEach Owner.AllActors( C, A )
	{
		// has to be an *exact* match -- not a subclass matching a superclass
		if( C == A.class )
		{
			Spammer = InfoSpammer( A );
			break;
		}
	}

	if( Spammer == None )
	{
		Spammer = Owner.Spawn( C );
	}

	Spammer.SetOwner( Owner );

	return Spammer;
}



static function InfoSpammer GetInstance( Actor Owner )
{
	return GetTypeInstance( Owner, default.class );
}



function ShowString( coerce string HitString )
{
	PlayerPawn(Owner).ClientMessage( HitString );
	PlayerPawn(Owner).Log( HitString );
}



function ShowSpam();



function Tick( float DeltaTime )
{
	if( bSpamEnabled && PlayerPawn(Owner) != None )
	{
		if( TimeToNextUpdate <= 0.0 )
		{
			ShowSpam();
		
			TimeToNextUpdate = TimeBetweenUpdates;
		}
		else
		{
			TimeToNextUpdate -= DeltaTime;
		}
	}
}



function EnableSpammer( bool bVal )
{
	bSpamEnabled = bVal;
}

defaultproperties
{
     TimeBetweenUpdates=0.050000
}
