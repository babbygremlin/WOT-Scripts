//------------------------------------------------------------------------------
// ResourceSpawner.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 8 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class ResourceSpawner expands AngrealInventory
	abstract;

// The Minion, Guardian or Champion that is currently helping you.
var WOTPawn CurrentArenaHelper;

// Message displayed telling you that you can only have one helper at a time.
var() localized string LimitWarning;

// Seperation between the castor and the resource.
var() float SpawnSeparation;

var() Texture TopSparkle, BottomSparkle;

//------------------------------------------------------------------------------
function class<WOTPawn> GetResourceClass()
{
	// Subclass, override and return the correct ResourceClass.
	return None;
}

//------------------------------------------------------------------------------
function Cast()
{	
	local class<WOTPawn> ResourceClass;
	local vector Offset;
	local AppearEffect AE;

	if( HaveHelper() )
	{
		if( WOTPlayer(Owner) != None )
		{
			WOTPlayer(Owner).ClientMessage( LimitWarning );
		}			
	}
	else
	{
		ResourceClass = GetResourceClass();

		if( ResourceClass != None )
		{
			Offset = Normal(vector(Owner.Rotation)) * (Owner.CollisionRadius + ResourceClass.default.CollisionRadius + SpawnSeparation);
			CurrentArenaHelper = Spawn( ResourceClass, Owner, 'AngrealSpawned', Owner.Location + Offset, Owner.Rotation );
		
			if( CurrentArenaHelper != None )
			{
				AE = Spawn( class'AppearEffect' );
				AE.TopSprite = TopSparkle;
				AE.BottomSprite = BottomSparkle;
				AE.SetAppearActor( CurrentArenaHelper );
				CurrentArenaHelper.PlayerReplicationInfo.Team = Pawn(Owner).PlayerReplicationInfo.Team;	// Makes him our team's friend.
				CurrentArenaHelper.PlayerReplicationInfo.PlayerName = Pawn(Owner).PlayerReplicationInfo.PlayerName $ "'s " $ string(ResourceClass.Name);
				Super.Cast();
				UseCharge();
			}
			else
			{
				Failed();
			}
		}
	}
}

//------------------------------------------------------------------------------
function bool HaveHelper()
{
	local Pawn IterP;
	local name HelperType;
	local class<WOTPawn> ResourceClass;

	ResourceClass = GetResourceClass();

	if( ResourceClass == None )
		return false;

	HelperType = ResourceClass.Name;

	for( IterP = Level.PawnList; IterP != None; IterP = IterP.NextPawn )
	{
		if
		(	IterP.Tag == 'AngrealSpawned'												// We're only worried about the ones we spawned.
		&&	IterP.IsA( HelperType )														// If this is one of the types of things we make.
		&&	IterP.Health > 0															// And it is still breathing.
		&&	IterP.Owner == Owner														// If our owner spawned it.
		&&	IterP.PlayerReplicationInfo.Team == Pawn(Owner).PlayerReplicationInfo.Team	// And it is on our team.  (This allows the player to change teams, and spawn another helper since the first will no longer accumulate points for him.)
		)
		{
			return true;
		}
	}

	return false;
}

////////////////
// AI Support //
////////////////

//------------------------------------------------------------------------------
function float GetPriority()
{
	if( HaveHelper() )	return 0.0;
	else				return Priority;
}

defaultproperties
{
     SpawnSeparation=50.000000
     Priority=50.000000
}
