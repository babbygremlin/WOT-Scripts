//=============================================================================
// PortcullisMover.
//=============================================================================
class PortcullisMover expands Mover;

#exec AUDIO IMPORT FILE=Sounds\Portcullis\ClosedPT.WAV			 GROUP=Portcullis
#exec AUDIO IMPORT FILE=Sounds\Portcullis\ClosePT.WAV			 GROUP=Portcullis
#exec AUDIO IMPORT FILE=Sounds\Portcullis\DestroyedPT.wav		 GROUP=Portcullis
#exec AUDIO IMPORT FILE=Sounds\Portcullis\OpenPT.wav			 GROUP=Portcullis

var (Portcullis) int		WithstandDamage; // amount of damage the portcullis can withstand
var (Portcullis) string		DestroyedSoundName;

replication
{
	// Data the server should send to all clients
	unreliable if( Role==ROLE_Authority )
		WithstandDamage;
}

function PreBeginPlay()
{
	Super.PreBeginPlay();
	HideMover();
}

// Actually goes to open state quietly
function HideMover()
{
	InterpolateTo( 1, 0 ); // Frame 0 is closed, 1 is open
}

function Activate()
{
	WithstandDamage = default.WithstandDamage;
	HideMover();

	GotoState( 'TriggerToggle' );
}

function Deactivate()
{
	GotoState( 'Inactive' );
}

auto state Inactive
{
}

state TriggerToggle
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if( Portcullis(Owner).IsInactive( None ) ) // for events, ignore the instigator
			return;

		Super.Trigger( Other, EventInstigator );
		Disable( 'Trigger' );
	}

	function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name damageType )
	{
		if( Portcullis(Owner).IsInactive( None ) ) // for damage, ignore the instigator
			return;

		if( Damage < 0 )
		{
			Warn( "Damage="$ Damage );
		}

		spawn( class'TrapBurst', , , HitLocation );
		PlaySound( Sound( DynamicLoadObject( Trap(Owner).DamageSoundName, class'Sound' ) ) );

//log( Self$".TakeDamage() Damage="$ Damage $" WithstandDamage="$ WithstandDamage );
		WithstandDamage -= Damage;
		if( WithstandDamage <= 0 ) 
		{
			Trap(Owner).DestroyedTrigger( Self, EventInstigator );
			HideMover();
			PlaySound( Sound( DynamicLoadObject( DestroyedSoundName, class'Sound' ) ) );
			GotoState( 'Inactive' );
		}
	}
}

defaultproperties
{
     WithstandDamage=120
     DestroyedSoundName="WOTTraps.Portcullis.DestroyedPT"
     MoverEncroachType=ME_IgnoreWhenEncroach
     EncroachDamage=1
     bDamageTriggered=True
     OpeningSound=Sound'WOTTraps.Portcullis.OpenPT'
     OpenedSound=Sound'WOTTraps.Portcullis.OpenPT'
     ClosingSound=Sound'WOTTraps.Portcullis.ClosePT'
     ClosedSound=Sound'WOTTraps.Portcullis.ClosedPT'
}
