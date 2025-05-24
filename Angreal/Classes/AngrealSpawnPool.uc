//=============================================================================
// AngrealSpawnPool, spawns inventory objects from a weighted pool of object types
//=============================================================================
class AngrealSpawnPool expands Inventory /*NavigationPoint*/;

#exec AUDIO IMPORT FILE=Sounds\General\RespawnA.wav	GROUP=Effect
#exec AUDIO IMPORT FILE=Sounds\General\RespawnB.wav	GROUP=Effect
#exec AUDIO IMPORT FILE=Sounds\General\RespawnC.wav	GROUP=Effect

var() bool bRespawn;		// single-shot vs. repeated
var() float RespawnTime;	// Respawn after this time, 0 to use the spawned object's delay
var() class<inventory> Pool[16]; // the pool of inventory classes used to spawn at this point
var() byte Weight[16];		// weight to give each inventory class vs. the others

var Inventory PickupItem;	// respawned object waiting for the player in the pool

// Sound strings.
var() string CommmonSound;
var() string UnCommmonSound;
var() string RareSound;

var float WaitingDelay; // "local" variable

function int GetWeightedSelection()
{
	local int i, TotalWeight, RequiredWeight;

	// compute the total weight distribution
	for( i = 0; i < ArrayCount(Pool) && Pool[i] != None; i++ ) {
		TotalWeight += Weight[i];
	}

	// check for expiration of the spawn pool (all angreal depleted)
	if( TotalWeight == 0 ) {
		Warn( Self $ "  is empty.  Shuting down." );
		Destroy();
		return 0;
	}

	// select a target threshhold
	RequiredWeight = Rand( TotalWeight );

	// determine which entry (cumulatively) passes the threshhold
	TotalWeight = 0;
	for( i = 0; i < ArrayCount(Pool); i++ ) {
		TotalWeight += Weight[i];
		if( TotalWeight > RequiredWeight )
			return i;
	}

	return 0;
}

// Make sure no pawn already touching (while touch was disabled in sleep).
function CheckTouching()
{
	local int i;

	for( i=0; i < ArrayCount(Touching); i++ )
		if( Touching[i] != None && Touching[i].IsA( 'Pawn' ) )
			Touch( Touching[i] );
}

auto state Active
{
	function BeginState()
	{
		// pick a new object from the pool, then spawn it -- Inventory will default to becomming a pickup
		PickupItem = Spawn( Pool[ GetWeightedSelection() ] );

		//DEBUG log( Self $ " BeginState() set PickupItem to " $ PickupItem );
		if( PickupItem != None )
		{
			PickupItem.RespawnTime = 0.0; //don't respawn
			PickupItem.SetCollision( false, false, false ); // let the SpawnPool handle collision

			// Play sound according to rarity.
			if( AngrealInventory(PickupItem) != None )
			{
				if( AngrealInventory(PickupItem).bCommon ) 
				{
					PlaySound( Sound( DynamicLoadObject( CommmonSound, class'Sound') ) );
				}
				else if( AngrealInventory(PickupItem).bUnCommon ) 
				{
					PlaySound( Sound( DynamicLoadObject( UnCommmonSound, class'Sound') ) );
				}
				else if( AngrealInventory(PickupItem).bRare ) 
				{
					PlaySound( Sound( DynamicLoadObject( RareSound, class'Sound') ) );
				}
			}

			CheckTouching();
		} 
		else 
		{
			Warn( Self $ " PickupItem is invalid.  Shutting down." );
			Destroy();
		}
	}

	// Validate touch, and if valid trigger event.
	function bool ValidTouch( actor Other )
	{
		local Actor A;

		if( Other.bIsPawn && Pawn(Other).bIsPlayer && (Pawn(Other).Health > 0) && Level.Game.PickupQuery(Pawn(Other), self) )
		{
			if( Event != '' )
				foreach AllActors( class 'Actor', A, Event )
					A.Trigger( Other, Other.Instigator );
			return true;
		}
		return false;
	}
		
	function Touch( actor Other )
	{
		// If touched by a player pawn, let him pick this up.
		if( ValidTouch( Other ) )
		{
			if( PickupItem == None )
			{
				Warn( Self $ " Didn't contain a pickup." );
				return;
			}

			// if the SpawnPool is touched by a player, hand the touch off to the PickupItem
			if( Pawn(Other) != None && Pawn(Other).bIsPlayer )
			{
				PickupItem.Touch( Other );

				// setup for next go around
				PickupItem = None;
				if( bRespawn )
					GotoState( 'Waiting' );
				else
					Destroy();
			}
		}
	}
}

state Waiting
{
Begin:
	if( RespawnTime > 0.0 )
		WaitingDelay = RespawnTime;
	else
		WaitingDelay = PickupItem.RespawnTime;
	WaitingDelay /= Max( 1, Level.Game.NumPlayers / Max( Int( Level.IdealPlayerCount ), 1 ) );
	Sleep( WaitingDelay + 0.3 );
	GotoState( 'Active' );
}

//end of SpawnPool.

defaultproperties
{
     bRespawn=True
     Weight(0)=1
     Weight(1)=1
     Weight(2)=1
     Weight(3)=1
     Weight(4)=1
     Weight(5)=1
     Weight(6)=1
     Weight(7)=1
     Weight(8)=1
     Weight(9)=1
     Weight(10)=1
     Weight(11)=1
     Weight(12)=1
     Weight(13)=1
     Weight(14)=1
     Weight(15)=1
     CommmonSound="Angreal.RespawnA"
     UnCommmonSound="Angreal.RespawnB"
     RareSound="Angreal.RespawnC"
     bHidden=True
     DrawType=DT_Sprite
     Style=STY_Masked
}
