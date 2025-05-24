//=============================================================================
// RetreatInstigatorInventoryItem.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class RetreatInstigatorInventoryItem expands RetreatInstigator;

var () class<Inventory> CurrentOffendingInventoryItemType;

const ThreatInfluencePeerRadiusCount = 12;
const FullConfidencePeerCount = 3;



function bool GetRetreatInstigatorParams( Object InvokingObject,
		out Vector InstigatorLocation,
		out Vector InstigatorExtents )
{
	local bool bParamsDetermined;
	local Actor InstigatingActor;
	local Vector InventoryItemLocation, InventoryItemExtents;
	
	//Log( Self $ "::RetreatInstigatorInventoryItem::GetRetreatInstigatorParams" );
	if( Super.GetRetreatInstigatorParams( InvokingObject, InstigatorLocation, InstigatorExtents ) )
	{
		if( GetOffendingInventoryItemParams( InvokingObject,
				InventoryItemLocation, InventoryItemExtents,
				GetOffendingInventoryItemType() ) )
		{
			InstigatorExtents += InventoryItemExtents;
			bParamsDetermined = true;
		}		
	}
	
	return bParamsDetermined;
}



function bool GetOffendingInventoryItemParams( Object InvokingObject,
		out Vector InventoryItemLocation,
		out Vector InventoryItemExtents,
		class InventoryItemType )
{
	local bool bParamsDetermined;
	local Actor OffendingInventoryItem;

	if( GetOffendingInventoryItem( InvokingObject, OffendingInventoryItem, InventoryItemType ) )
	{
		InventoryItemLocation = OffendingInventoryItem.Location;
		InventoryItemExtents.x = OffendingInventoryItem.CollisionRadius;
		InventoryItemExtents.y = OffendingInventoryItem.CollisionRadius;
		InventoryItemExtents.z = OffendingInventoryItem.CollisionHeight;
		bParamsDetermined = true;
	}

	return bParamsDetermined;
}



function bool GetOffendingInventoryItem( Object InvokingObject, out Actor OffendingInventoryItem, class InventoryItemType )
{
	local Actor InstigatorUsed;
	local bool bReturn;
	local Pawn InventoryHolder;
	
	//Log( Self $ "::RetreatInstigatorInventoryItem::GetOffendingInventoryItem" );
	if( Super.GetRetreatInstigator( InvokingObject, InstigatorUsed ) )
	{
		InventoryHolder = Pawn( InstigatorUsed );
		if( InventoryHolder != none )
		{
			OffendingInventoryItem = InventoryHolder.FindInventoryType( InventoryItemType );
			
			if( OffendingInventoryItem != none )
			{
				//Log( Self $ "::RetreatInstigatorInventoryItem::GetOffendingInventoryItem" );
				//Log( "		OffendingInventoryItem: " $ OffendingInventoryItem );
				bReturn = true;
			}
			else
			{
				//Log( Self $ "::RetreatInstigatorInventoryItem::GetOffendingInventoryItem" );
				//Log( "		item of class -" $ InventoryItemType $ "- not found" );
			}
		}
	}
	
	return bReturn;
}



function class GetOffendingInventoryItemType()
{
	return CurrentOffendingInventoryItemType;
}



function BindOffendingInventoryItemType( class<Inventory> NewOffendingInventoryItemType )
{
	CurrentOffendingInventoryItemType = NewOffendingInventoryItemType;
}



function float GetThreatInfluence( Object InvokingObject )
{
	local float ThreatInfluence, CollectiveMass;
	local float RetreatRadius;
	local Vector RetreatOrigin, RetreatExtents;
	local Actor InvokingActor;
	
	//Log( Self $ "::RetreatInstigatorInventoryItem::GetThreatInfluence" );
	InvokingActor = Actor( InvokingObject );
	if( ( InvokingActor != None ) && GetRetreatInstigatorParams( InvokingObject, RetreatOrigin, RetreatExtents ) )
	{
		RetreatRadius = InvokingActor.Default.CollisionRadius * ThreatInfluencePeerRadiusCount;
		//get the collective mass of all like-actors that are threatened
		CollectiveMass = GetWeightedCollectivePeerMass( InvokingActor, RetreatOrigin, RetreatRadius );
		//add the mass for this actor
		CollectiveMass += InvokingActor.Mass;
				
		//Log( "::RetreatInstigatorInventoryItem::GetThreatInfluence" );
		//Log( "		final CollectiveMass " $ CollectiveMass );
		//Log( "		final divisor " $ ( FullConfidencePeerCount * RetreatingActor.Default.Mass ) );

		ThreatInfluence = 1 - FClamp( CollectiveMass / ( FullConfidencePeerCount *
				InvokingActor.Default.Mass ), 0.0, 1.0 );
	}
	else
	{
		//if there is no offending inventory item then the threat has no influence
		ThreatInfluence = 0;
	}
	
	//Log( Self $ "::RetreatInstigatorInventoryItem::GetThreatInfluence" );
	//Log( "		ThreatInfluence " $ ThreatInfluence );
	return ThreatInfluence;
}



static function float GetWeightedCollectivePeerMass( Actor GivenActor,
		Vector PeerRadiusLocation,
		float PeerRadius )
{
	local Actor CurrentActor;
	local float CollectiveMass, PenitrationRatio, CurrentSpiderDistance;
	local Vector Difference;
	
	//Log( "::RetreatInstigator::GetWeightedCollectivePeerMass" );
	foreach GivenActor.RadiusActors( GivenActor.Class, CurrentActor, PeerRadius, PeerRadiusLocation )
	{
		if( CurrentActor != GivenActor )
		{
			Difference = CurrentActor.Location - PeerRadiusLocation;
			Difference.z = 0;
			CurrentSpiderDistance = VSize( Difference ) - CurrentActor.CollisionRadius;
			PenitrationRatio = 1 - ( CurrentSpiderDistance / PeerRadius );
			if( PenitrationRatio > 0)
			{
				CollectiveMass += CurrentActor.Mass * PenitrationRatio;
				//Log( "		current CollectiveMass " $ CollectiveMass );
			}
		}
	}
	
	return CollectiveMass;
}

defaultproperties
{
}
