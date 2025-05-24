//=============================================================================
// FireWallSprayer1.
// $Author: Jcrable $
// $Date: 10/20/99 4:28p $
// $Revision: 9 $
//=============================================================================
class FireWallSprayer1 expands ParticleSprayer;

var()	float	DamageInterval;		// How often (seconds) should damage occur for actors inside fire.
var		int		TouchingCount;		// Number of actors currently touching us.

//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
/*DEBUG
	log( Self$" Touching[ 0 ] : "$Touching[ 0 ]$" at "$Level.TimeSeconds );
	log( Self$" Touching[ 1 ] : "$Touching[ 1 ]$" at "$Level.TimeSeconds );
	log( Self$" Touching[ 2 ] : "$Touching[ 2 ]$" at "$Level.TimeSeconds );
	log( Self$" Touching[ 3 ] : "$Touching[ 3 ]$" at "$Level.TimeSeconds );
*/
	// Damage timer.
	DamageInterval -= DeltaTime;
	while( DamageInterval <= 0.0 )
	{
		DamageInterval += default.DamageInterval;
		DamageTouching();
	}

	// Don't call -- Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
function DamageTouching()
{
	local int i;

	if( TouchingCount > 0 )
	{
		for( i = 0; i < ArrayCount(Touching); i++ ) 
		{
			if( Pawn(Touching[i]) != None )
			{
				FireWallSlab(Owner).DamageActor( Touching[i] );
			}
		}
	}
}

//------------------------------------------------------------------------------
function Touch( Actor Other )
{
	TouchingCount++;
	assert(TouchingCount>0);	//ARL

	if( Other != None )
	{
		if( FireWallSlab(Owner) != None )
		{
			FireWallSlab(Owner).DamageActor( Other );
		}
	}
}

//------------------------------------------------------------------------------
function UnTouch( Actor Other )
{
	assert(TouchingCount>0);	//ARL
	TouchingCount--;
}

//------------------------------------------------------------------------------
function Hide()
{
	Super.Hide();
	SetCollision( false, false, false );
}

//------------------------------------------------------------------------------
function Show()
{
	Super.Show();
	SetCollision( default.bCollideActors, default.bBlockActors, default.bBlockPlayers );
}

//------------------------------------------------------------------------------
function Actor GetBaseResource() //TBI "Owner" not replicating properly -- due to RemoteRole=ROLE_None?
{
	if( Owner != None )
	{
		return Owner.GetBaseResource();
	}
	else
	{
		return None;
	}
}

defaultproperties
{
     DamageInterval=0.500000
     Spread=60.000000
     Volume=7.000000
     Gravity=(Z=20.000000)
     NumTemplates=2
     Templates(0)=(LifeSpan=0.850000,Weight=2.000000,MaxInitialVelocity=120.000000,MinInitialVelocity=60.000000,MaxDrawScale=2.000000,MinDrawScale=1.500000,MinScaleGlow=0.850000,GrowPhase=2,MaxGrowRate=-1.000000,MinGrowRate=-0.500000,FadePhase=1,MaxFadeRate=-1.000000,MinFadeRate=-1.000000)
     Templates(1)=(LifeSpan=1.050000,Weight=5.000000,MaxInitialVelocity=105.000000,MinInitialVelocity=65.000000,MaxDrawScale=1.500000,MinDrawScale=1.500000,MinScaleGlow=0.800000,GrowPhase=2,MaxGrowRate=0.250000,MinGrowRate=-0.050000,FadePhase=1,MaxFadeRate=-1.500000,MinFadeRate=-1.000000)
     Templates(2)=(LifeSpan=0.000000,Weight=0.000000,MaxInitialVelocity=80.000000,MinInitialVelocity=70.000000,MaxDrawScale=0.150000,MinDrawScale=0.500000,MaxScaleGlow=0.800000,MinScaleGlow=0.700000,GrowPhase=2,MaxGrowRate=0.500000,FadePhase=1,MaxFadeRate=-1.000000,MinFadeRate=-1.000000)
     Particles(0)=WetTexture'WOTTraps.FireWall.FireWallFlameWet2'
     Particles(1)=WetTexture'WOTTraps.FireWall.FireWallFlameWet'
     Particles(2)=Texture'ParticleSystems.Fire.Flame02'
     bOn=True
     VolumeScalePct=0.750000
     MinVolume=3.000000
     bDisableTick=False
     bStatic=False
     SpriteProjForward=16.000000
     VisibilityRadius=1000.000000
     VisibilityHeight=1000.000000
     bCollideActors=True
}
