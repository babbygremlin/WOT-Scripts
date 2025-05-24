//=============================================================================
// IconInfo.
//=============================================================================
class IconInfo expands Info;

// WOTPlayer uses this class tell the UI display code what angreal effects
// currently apply to that player.
//
// Use the `Tag' field to ID your IconInfos.  I had originally used the
// `Icon' field, which would be OK for the PEG demo, but would cause trouble
// farther down the road when angreal that affect existing angreal effects
// come along.  (e.g. Taint might change the textures of existing effects,
// or Disguise will have several different textures, depending on who
// you are disguised as.)
//
// It might make sense to move the effect timing functionality from
// WOTPlayer to here, but that isn't going to happen for the PEG demo.

var texture Icon;
var bool bGoodIcon;
var float InitialDuration;
var float RemainingDuration;
var Actor Inv; // Inventory. leech, or reflector displayed
var IconInfo Next;

replication
{
	// Things the server should send to the client.
	reliable if( Role==ROLE_Authority && bNetOwner )
		Icon,
		bGoodIcon,
		InitialDuration,
		RemainingDuration,
        Next;
}

function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( Leech( Inv ) != None )
	{
		RemainingDuration = Leech( Inv ).GetDuration();
	}
	else if( Reflector( Inv ) != None )
	{
		RemainingDuration = Reflector( Inv ).GetDuration();
	} 
	else if( AngrealInventory( Inv ) != None )
	{
		RemainingDuration = AngrealInventory( Inv ).GetDuration();
	}
	else 
	{
		//Warn( "Illegal Icon Inv:"$Inv );
		RemainingDuration = 0;
	}
}

// end of IconInfo

defaultproperties
{
}
