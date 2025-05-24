//------------------------------------------------------------------------------
// IgnoreAirElementReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	If we receive an angreal effect that comes from an angreal
//				composed of AirElement, throw that effect away.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class IgnoreAirElementReflector expands IgnoreElementReflector;

#exec AUDIO IMPORT FILE=Sounds\AirShield\DeflectAS.wav		GROUP=AirShield

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Only pass this effect on to latter reflectors if it is its source angreal
// is NOT composed of ElementAir.
//------------------------------------------------------------------------------
function ProcessEffect( Invokable I )
{
	if( I.SourceAngreal != None && I.SourceAngreal.bElementAir )
	{
		IgnoreEffect( I );
	}
	else
	{
		Super.ProcessEffect( I );
	}
}

//------------------------------------------------------------------------------
function bool InvIsIgnored( AngrealInventory Inv )
{
	return Inv.bElementAir;
}

defaultproperties
{
    ImpactType=Class'AirShieldVisual'
    DeflectSound=Sound'AirShield.DeflectAS'
    TriggerEvent=ElementalAirTriggered
    IgnoredDamageType=Air
}
