//=============================================================================
// SpawnPoint.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================
class SpawnPoint expands NavigationPoint;

#exec Texture Import File=Icons\I_SpawnPoint.pcx Mips=Off Flags=2

const ThisClassName = 'SpawnPoint';

var() Name ItemEvent;					// if set spawned Actors' events set to this, otherwise factory's Tag used
var() Name ItemTag;						// if set spawned Actors' tags set to this, otherwise factory's ItemTag used
var() Name SpawnTemplateTag;			// the tag name of the actor to use as the template for the prototype

var() Sound		 CreateSound;			// if set, sound played "from" spawned actor when spawned
var() ESoundSlot CreateSoundSlot;		// parameter for CreateSound
var() float		 CreateSoundVolume;		// parameter for CreateSound
var() bool		 CreateSoundbNoOverride;// parameter for CreateSound
var() float		 CreateSoundRadius;		// parameter for CreateSound
var() float		 CreateSoundPitch;		// parameter for CreateSound

// set by associated ActorFactory
var ActorFactory factory;

function bool Create()
{
	local pawn NewCreature;
	local PawnFactory pawnFactory;
	local pawn creature;
	local actor NewActor, ActorIter, SpawnTemplate;
	local rotator newRot;
	local Name TemplateTag;
	
	// make sure no player can see this SpawnPoint
	if( factory.bCovert && PlayerCanSeeMe() ) 
	{
		return false;
	}
	
	//attempt to find the spawn template for the prototype
	TemplateTag = '';
	if( SpawnTemplateTag != '' )
	{
		TemplateTag = SpawnTemplateTag;
	}
	else if( Factory.SpawnTemplateTag != '' )
	{
		TemplateTag = Factory.SpawnTemplateTag;
	}
	if( TemplateTag != '' )
	{
		foreach AllActors( Factory.Prototype, ActorIter, TemplateTag )
		{
			//store it so that the spawned actor can get to it if it wants
			SpawnTemplate = ActorIter;
			break;
		}
	}
		
	// create the creature
	NewActor = Spawn( factory.prototype, , , , , SpawnTemplate );

	if( NewActor == None )
	{
		return false;
	}
	
	class'Debug'.static.DebugLog( Self, "Spawned a " $ factory.prototype , ThisClassName );
	
	newRot = rot(0,0,0);
	newRot.yaw = rotation.yaw;
	NewActor.SetRotation(newRot);

	if( ItemEvent != '' )
	{
		NewActor.event = ItemEvent;
	}
	else
	{
		NewActor.event = factory.tag;
	}

	if( ItemTag != '' )
	{
		NewActor.tag = ItemTag;
	}
	else
	{
		NewActor.tag = factory.ItemTag;
	}

	if( Event != '' )
	{
		foreach AllActors( class 'Actor', ActorIter, Event )
		{
			ActorIter.Trigger( Self, Instigator );
		}
	}
	
	if( factory.bFalling )
	{
		NewActor.SetPhysics( PHYS_Falling );
	}
	
	if( NewActor.IsA( 'Pawn' ) )
	{
		NewCreature = Pawn(NewActor);
/*
		//xxxrlo
		if( WOTPawn(NewCreature) != None )
		{
			WOTPawn(NewCreature).Orders = pawnFactory.Orders;
			WOTPawn(NewCreature).OrderTag = pawnFactory.OrderTag;
			WOTPawn(NewCreature).SetEnemy( pawnFactory.enemy );
			WOTPawn(NewCreature).Alarmtag = pawnFactory.AlarmTag;
		}
		else 
		{
			NewCreature.enemy = pawnFactory.enemy;
		}
*/

		pawnFactory = PawnFactory( factory );
		if( pawnFactory == None )
		{
			log( "Error - use PawnFactory to spawn pawns" );
			BroadcastMessage( "Error - use PawnFactory to spawn pawns" );
			return true;
		}
	
		if( NewCreature.enemy != None )
		{
			NewCreature.lastseenpos = NewCreature.enemy.location;
		}
	
		NewCreature.SetMovementPhysics();
	
		if( NewCreature.Physics == PHYS_Walking )
		{
			NewCreature.SetPhysics( PHYS_Falling );
		}

		if( NewCreature.IsA( 'WOTPawn' ) )
		{
			WOTPawn(NewCreature).AssignedTeam = PawnFactory.team;
			WOTPawn(NewCreature).InitPlayerReplicationInfo();
		}

	}
	
	if( CreateSound != None )
	{
		NewActor.PlaySound( CreateSound, 
							CreateSoundSlot, 
							CreateSoundVolume, 
							CreateSoundbNoOverride, 
							CreateSoundRadius, 
							CreateSoundPitch );
	}

	class'Debug'.static.DebugLog( Self, "Spawned a " $ factory.prototype $ " tag: " $ NewActor.tag $ ", event: " $ NewActor.event, ThisClassName );

	return true;
}

function DumpInfo( PlayerPawn P )
{
	P.log( "    name: "       $ name );
	P.log( "    event: "      $ event );
	P.log( "    tag: "        $ tag );
	P.log( "    eventtag: "   $ itemevent );
	P.log( "    itemtag: "    $ itemtag );
}

defaultproperties
{
     bDirectional=True
     Texture=Texture'WOT.I_SpawnPoint'
     SoundVolume=128
}
