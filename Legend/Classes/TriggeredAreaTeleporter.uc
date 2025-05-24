//------------------------------------------------------------------------------
// TriggeredAreaTeleporter.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class TriggeredAreaTeleporter expands Teleporter;

var vector  OrigOffset;
var rotator OrigViewRotation;
var rotator OrigRotation;

//------------------------------------------------------------------------------
simulated function Touch( Actor Other );

//------------------------------------------------------------------------------
simulated function Trigger( Actor Other, Pawn EventInstigator )
{
	local Actor IterA;
	
	foreach RadiusActors( class'Actor', IterA, CollisionRadius, Location )
	{
		if( IterA != Self && IterA.bCollideActors )
		{
			OrigOffset = IterA.Location - Location;
			OrigRotation = IterA.Rotation;
			if( Pawn(IterA) != None )
			{
				OrigViewRotation = Pawn(IterA).ViewRotation;
				//Pawn(IterA).ClientMessage( "Storing ViewRotation: "$OrigViewRotation );
			}
			Super.Touch( IterA );
		}
	}
}

//------------------------------------------------------------------------------
simulated function bool Accept( Actor Incoming )
{
	local TriggeredAreaTeleporter Source;
	local PathNode IterPN;
	local PathNode ClosestPN;
	local float TempDistance;
	local float BestDistance;
	
	if( Super.Accept( Incoming ) )
	{
		// Find the source teleporter.
		foreach AllActors( class'TriggeredAreaTeleporter', Source )
			if( Source.URL ~= string(Tag) ) break;
		if( Source == None && PlayerPawn(Incoming) != None )
		{
			PlayerPawn(Incoming).ClientMessage( Self$" cannot find source teleporter!" );
			return false;
		}
			
		if( !Incoming.SetLocation( Location + Source.OrigOffset ) )
		{
			// If we don't fit here, go to the nearest path node.
			foreach RadiusActors( class'PathNode', IterPN, CollisionRadius, Location )
			{
				TempDistance = VSize(Incoming.Location - IterPN.Location);
				if( ClosestPN == None || TempDistance < BestDistance )
				{
					ClosestPN = IterPN;
					BestDistance = TempDistance;
				}
			}
			
			if( IterPN == None )
			{
				//PlayerPawn(Incoming).ClientMessage( "No valid path nodes found, using teleporter's location." );
				Incoming.SetLocation( Location );
			}
			else
			{
				Incoming.SetLocation( IterPN.Location );
			}
		}
		
		Incoming.SetRotation( Source.OrigRotation );
		if( Pawn(Incoming) != None )
		{
			Pawn(Incoming).ViewRotation = Source.OrigViewRotation;
			//PlayerPawn(Incoming).ClientMessage( "Setting ViewRotation: "$Pawn(Incoming).ViewRotation );
		}
		
		return true;
	}
	else return false;
}

defaultproperties
{
}
