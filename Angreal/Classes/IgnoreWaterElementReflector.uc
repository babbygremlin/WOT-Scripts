//------------------------------------------------------------------------------
// IgnoreWaterElementReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	If we receive an angreal effect that comes from an angreal
//				composed of WaterElement, throw that effect away.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class IgnoreWaterElementReflector expands IgnoreElementReflector;

#exec AUDIO IMPORT FILE=Sounds\WaterShield\DeflectWS.wav		GROUP=WaterShield

//#if 1 //HACK

// Hack to make Warren happy.
// This will not work in multiplayer.
// This will probably screw up continuous and stepped zonevelocity transitions.
// This takes up more memory than needed.
// It globally effects all zone (water or not).
// It will allow any other creatures to walk about freely in water.
// This technique is not sanctioned by the author.
// All consequences of this code may be reported to Warren (wmarshall@legendent.com).

var vector InitialZoneVelocity[64];
var ZoneInfo Zones[64];

//------------------------------------------------------------------------------
function Install( Pawn NewHost )
{
	local ZoneInfo Zone;
	local int i;

	Super.Install( NewHost );

	foreach AllActors( class'ZoneInfo', Zone )
	{
		if( i < ArrayCount(Zones) )
		{
			Zones[i] = Zone;
			InitialZoneVelocity[i] = Zone.ZoneVelocity;
			Zone.ZoneVelocity = vect(0,0,0);
			i++;
		}
		else
		{
			warn( "Zone array exceeded." );
			break;
		}
	}
}

//------------------------------------------------------------------------------
function UnInstall()
{
	local int i;

	Super.UnInstall();

	for( i = 0; i < ArrayCount(Zones); i++ )
	{
		if( Zones[i] != None )
		{
			Zones[i].ZoneVelocity = InitialZoneVelocity[i];
		}
	}
}

//#endif

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Only pass this effect on to latter reflectors if it is its source angreal
// is NOT composed of ElementWater.
//------------------------------------------------------------------------------
function ProcessEffect( Invokable I )
{
	if( I.SourceAngreal != None && I.SourceAngreal.bElementWater )
	{
		IgnoreEffect( I );
	}
	else
	{
		Super.ProcessEffect( I );
	}
}

//------------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn InstigatedBy, vector Hitlocation, vector Momentum, name DamageType )
{
	if( class'AngrealInventory'.static.DamageTypeContains( DamageType, IgnoredDamageType ) || DamageType == 'drowned' )
	{
		SpawnImpactEffect( Hitlocation );
	}
	else
	{
		// Pass on to next reflector.
		Super(Reflector).TakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, DamageType );
	}
}

//------------------------------------------------------------------------------
function bool InvIsIgnored( AngrealInventory Inv )
{
	return Inv.bElementWater;
}

defaultproperties
{
     ImpactType=Class'Angreal.WaterShieldVisual'
     DeflectSound=Sound'Angreal.WaterShield.DeflectWS'
     TriggerEvent=ElementalWaterTriggered
     IgnoredDamageType=Water
}
