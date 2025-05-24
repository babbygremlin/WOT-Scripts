//------------------------------------------------------------------------------
// ForkRTSReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 9 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class ForkRTSReflector expands ReturnToSenderReflector;

#exec AUDIO IMPORT FILE=Sounds\Fork\ForkFK.wav		GROUP=Fork

var GenericProjectile IgnoredProj;

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
simulated function OnReflectedTouch( GenericProjectile HitProjectile )
{
	local GenericProjectile ForkedCopy;

	if( HitProjectile == IgnoredProj )
	{
		return;
	}

	if( IsAffectable( HitProjectile ) )
	{
		// NOTE[aleiby]: Use Ryan's SpawnTemplated code.
		ForkedCopy = Spawn( HitProjectile.Class, HitProjectile.Owner, HitProjectile.Tag, HitProjectile.Location, HitProjectile.Rotation );
		ForkedCopy.SetSourceAngreal( HitProjectile.SourceAngreal );
		ForkedCopy.Instigator = HitProjectile.Instigator;
		
		Super.OnReflectedTouch( HitProjectile );

		IgnoredProj = ForkedCopy;
		ForkedCopy.Touch( Owner );
		IgnoredProj = None;
	}
}

//------------------------------------------------------------------------------
function SpawnImpactEffect( vector AimLoc )
{
	local ReflectSkinEffect Effect;

	Effect = Spawn( class'ReflectSkinEffect', Owner,, Owner.Location, Owner.Rotation); 
	Effect.Mesh = Owner.Mesh;
	Effect.DrawScale = Owner.DrawScale;
	if( WOTPlayer(Owner) != None )
	{
		Effect.SetColor( WOTPlayer(Owner).PlayerColor, true );
	}
	else
	{
		Effect.SetColor( 'Green', true );
	}
}

defaultproperties
{
     SoundReflectName="Angreal.Fork.ForkFK"
     Priority=150
}
