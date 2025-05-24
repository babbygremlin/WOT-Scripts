//=============================================================================
// ActorFactory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================
class ActorFactory expands Keypoint;

const ThisClassName = 'ActorFactory';

var() class<actor> prototype; 	// the template class
var() Name SpawnTemplateTag;	// the tag name of the actor to use as the template for the prototype
var() int maxitems;				// max number of items from this factory at any time
var() int capacity;				// max number of items ever buildable (-1 = no limit)
var() float interval;			// average time interval between spawnings
var() name itemtag;				// tag given to items produced at this factory
var() bool bFalling;			// non-pawn items spawned should be set to falling
var() bool bNonPrototypeTriggerShutdown; // trigger from anything but spawned type shuts down the factory

var() enum EDistribution
{
	DIST_Constant,
	DIST_Uniform,
	DIST_Gaussian
} timeDistribution;

var() bool bOnlyPlayerTouched; 	// only player can trigger it
var() bool bCovert;				// only do hidden spawns
var() bool bStoppable;			// stops producing when untouched

var private int NumSpawnPoints;			// number of spawnspots
var private int NumSpawnedItems;		// current number of items from this factory
var private SpawnPoint spawnspot[16]; 	// possible start locations

function PostBeginPlay()
{
	local SpawnPoint newspot;
	local Actor A;
	
	Super.PostBeginPlay();
	
	// count and store spawn points
	NumSpawnPoints = 0;
	foreach AllActors( class'SpawnPoint', newspot, tag )
	{
		if( NumSpawnPoints < 16 )
		{
			spawnspot[NumSpawnPoints] = newspot;
			newspot.factory = self;
			NumSpawnPoints += 1;
		}
	}

	if( NumSpawnPoints == 0 )
	{
		warn( Self $ " has no spawn points!" );
	}
	
	// count pre-existing matching items (item event = factory tag)
	NumSpawnedItems = 0;
	class'Debug'.static.DebugLog( Self, "looking for: " $ prototype $ ", " $ tag, ThisClassName );
	foreach AllActors( prototype, A, tag )
	{
		NumSpawnedItems++;
	}
	
	if( itemtag == '' )
	{
		itemtag = 'BallPiensRock';
	}
}	


function StartBuilding()
{
}

Auto State Waiting
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		local Actor A;

		if( Event != '' )
		{
			ForEach AllActors( class 'Actor', A, Event)
			{
				A.Trigger(self, EventInstigator);
			}
		}
		GotoState('Spawning');
	}
		
	function Touch(Actor Other)
	{
		local pawn OtherPawn;
	
		OtherPawn = Pawn(Other);
		if( (otherpawn != None) && (!bOnlyPlayerTouched || otherpawn.bIsPlayer) )
		{
			Trigger( other, otherPawn );
		}
	}
}

State Spawning
{
	function UnTouch(Actor Other)
	{
		local int i;
		if( bStoppable )
		{
			//check if some other pawn still touching
			for(i=0;i<4;i++)
			{
				if( (pawn(Touching[i]) != None) && (!bOnlyPlayerTouched || pawn(Touching[i]).bIsPlayer) )
				{
					return;
				}
			}
			GotoState('Waiting');
		}
	}

	function Trigger(actor Other, pawn EventInstigator)
	{
		class'Debug'.static.DebugLog( Self, "Trigger: " $ Other $ ", " $ EventInstigator, ThisClassName );
		
		if( Other != None && Other.class != prototype )
		{
			if( bNonPrototypeTriggerShutdown )
			{
				class'Debug'.static.DebugLog( Self, " Shutting down due to non-prototype trigger", ThisClassName );
				// trigger from anything but creatures belonging to 
				// this factory shuts down the factory
				GotoState('Finished');
			}
			return;
		}
			
		NumSpawnedItems--;
		if( NumSpawnedItems < maxitems )
		{
			StartBuilding();
		}
	}

	function bool trySpawn(int start, int end)
	{
		local int i;
		local bool done;

		done = false;
		i = start;
		while(i < end)
		{
			if( spawnspot[i].Create() )
			{
				done = true;
				i = end;
				if( capacity > 0 )
				{
					capacity--;
				}
					
				NumSpawnedItems++;
				
				if( capacity == 0 )
				{
					GotoState('Finished');
				}
			}
			i++;
		}
		
		return done;
	}
		
	function Timer()
	{
		local int start;
		
		if( NumSpawnedItems < maxitems )
		{
			//pick a spawn point
			start = Rand( NumSpawnPoints );
			
			if( !trySpawn( start, NumSpawnPoints ) )
			{
				trySpawn( 0, start );
			}
		}
			
		if( NumSpawnedItems < maxitems )
		{
			StartBuilding();
		}
	}

	Function StartBuilding()
	{
		local float nextTime;
		
		if( capacity == -1 || capacity > 0 )
		{
			if( timeDistribution == DIST_Constant )
			{
				nextTime = interval;
			}
			else if( timeDistribution == DIST_Uniform )
			{
				nextTime = 2 * FRand() * interval;
			}
			else //timeDistribution is gaussian
			{
				nextTime = 0.5 * (FRand() + FRand() + FRand() + FRand()) * interval;
			}
			
			SetTimer( nextTime, false );
		}
	}

	function BeginState()
	{
		class'Debug'.static.DebugLog( Self, " " $ NumSpawnPoints $ " SpawnPoints, " $ NumSpawnedItems $ " initial items", ThisClassName );
		
		if( !bStoppable )
		{
			Disable('UnTouch');
		}
	}

	function EndState()
	{
		Super.EndState();
		
		class'Debug'.static.DebugLog( Self, " factory shutting down", ThisClassName );
	}

Begin:
	Timer();
}

state Finished
{
}	

function DumpInfo( PlayerPawn P )
{
	local SpawnPoint SP;
	local Actor A;
	local int Count;

	P.log( "   " );

	P.log( "ActorFactory: " $ Name );
	P.log( "  state: "      $ GetStateName() );
	P.log( "  prototype: "  $ prototype );
	P.log( "  capacity: "   $ capacity );
	P.log( "  maxitems: "   $ maxitems );
	P.log( "  spawn spots: " $ NumSpawnPoints );
	P.log( "  spawned items: " $ NumSpawnedItems );
	P.log( "  event: "      $ event );
	P.log( "  tag: "        $ tag );
	P.log( "  itemtag: "    $ itemtag );

	// dump SpawnPoint info
	Count=0;
	P.log( "   " );
	P.log( "  SpawnPoints:" );
	foreach AllActors( class'SpawnPoint', SP, tag )
	{
		SP.DumpInfo( P );
		Count++;
		P.log( "   " );
	}
	P.log( "    " $ Count $ " SpawnPoints found." );

	// dump Trigger info
	Count=0;
	P.log( "   " );
	P.log( "  Existing Triggers:" );
	foreach AllActors( class'Actor', A )
	{
		if( A.Event == tag )
		{
			P.log( "    " $ A.Name );
			Count++;
		}
	}
	P.log( "    " $ Count $ " Triggers found." );
}

defaultproperties
{
     MaxItems=1
     capacity=1000000
     Interval=1.000000
     bFalling=True
     bNonPrototypeTriggerShutdown=True
     bStatic=False
     bCollideActors=True
}
