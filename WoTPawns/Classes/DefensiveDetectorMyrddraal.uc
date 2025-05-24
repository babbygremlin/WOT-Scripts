//=============================================================================
// DefensiveDetectorMyrddraal.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================
class DefensiveDetectorMyrddraal expands DefensiveDetector;

function EOffenderRejectionInfo RejectOffender( Actor Inquirer, Actor OffendingActor )
{
	local EOffenderRejectionInfo OffenderRejectionInfo;

	if( SeekingProjectile( OffendingActor ).Destination == Inquirer )
	{
//xxxrlo this looks suspicious
		OffenderRejectionInfo = ORI_NotRejected;
		RespondedToActor( OffendingActor, false );
	}
	else
	{
		OffenderRejectionInfo = ORI_OtherRejection;
	}
	return OffenderRejectionInfo;
}



function RespondedToActor( Actor RespondedTo, optional bool bRecollect )
{
	if( SeekingProjectile( RespondedTo ).Destination != none )
	{
		bRejectResponded = false;
	}
	else { bRejectResponded = true; }
	
}

defaultproperties
{
     CollectionRadius=2048.000000
     CollectClass=Class'Angreal.SeekingProjectile'
     bRestrictCollectionToFOV=True
     bActiveDetection=True
     bPassiveDetection=True
     DefensiveResponses(0)=(DR_MinResponseTime=1.000000,DR_MaxResponseTime=7.500000,DR_ResponsePreHint=MyrddraalTeleport)
}
