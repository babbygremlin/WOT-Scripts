//------------------------------------------------------------------------------
// ProjLeechRTSReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	ReturnToSenderReflector for ProjLeechArtifacts.  This filters
//				out the projectile leeches before the normal RTS reflector
//				gets its grubby hands on them.
//------------------------------------------------------------------------------
// How to use this class:
//
// + DEPRICATED by Author
//------------------------------------------------------------------------------
class ProjLeechRTSReflector expands Reflector;

var Leech MyLeech;							// The leech we installed in our destination.
var ProjLeechArtifact ControllingArtifact;	// The angreal whose charges we are using.

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
simulated function NotifyHitByAngrealProjectile( AngrealProjectile HitProjectile )
{
	local AttachLeechEffect Attacher;

	// Handle projectiles from ProjLeechArtifacts if we are not previously occupied.
	if( ProjLeechArtifact(HitProjectile.SourceAngreal) != None && MyLeech == None )
	{
		ControllingArtifact = ProjLeechArtifact(HitProjectile.SourceAngreal);

		///////////
		// Ripped from ProjLeechArtifact. 
		//
		//Attacher = Spawn( class'AttachLeechEffect' );
		Attacher = AttachLeechEffect( class'Invokable'.static.GetInstance( Self, class'AttachLeechEffect' ) );
		Attacher.SetSourceAngreal( HitProjectile.SourceAngreal );

		MyLeech = Spawn( ProjLeechArtifact(HitProjectile.SourceAngreal).LeechClass );
		//MyLeech.SetSourceAngreal( class'AngrealInventory'.static.CreateProxy( Owner, HitProjectile.SourceAngreal.Class ) );
		MyLeech.SetSourceAngreal( HitProjectile.SourceAngreal );
		MyLeech.Instigator = Pawn(Owner);

		Attacher.SetLeech( MyLeech );
		Attacher.SetVictim( Pawn(HitProjectile.SourceAngreal.Owner) );	// NOTE[aleiby]: Use Instigator or SourceAngreal.LastOwner instead of SourceAngreal.Owner?
		
		if( WOTPlayer(HitProjectile.SourceAngreal.Owner) != None )
		{
			WOTPlayer(HitProjectile.SourceAngreal.Owner).ProcessEffect( Attacher );
		}
		else if( WOTPawn(HitProjectile.SourceAngreal.Owner) != None )
		{
			WOTPawn(HitProjectile.SourceAngreal.Owner).ProcessEffect( Attacher );
		}
		//
		///////////

		InstallCopy();	// Let this new one handle the next RTSReflection.
	}
	else
	{
		// Pass control off to next reflector.
		Super.NotifyHitByAngrealProjectile( HitProjectile );
	}
}

//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	if( ControllingArtifact != None && !ControllingArtifact.bCasting )
	{
		Expired();
		Destroy();
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
function Expired()
{
	if( MyLeech != None )
	{
		MyLeech.UnAttach();
		MyLeech.Destroy();
	}

	Super.Expired();
}

defaultproperties
{
    Priority=200
}
