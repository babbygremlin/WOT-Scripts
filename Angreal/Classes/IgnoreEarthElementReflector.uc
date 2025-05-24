//------------------------------------------------------------------------------
// IgnoreEarthElementReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	If we receive an angreal effect that comes from an angreal
//				composed of EarthElement, throw that effect away.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class IgnoreEarthElementReflector expands IgnoreElementReflector;

#exec AUDIO IMPORT FILE=Sounds\EarthShield\DeflectES.wav		GROUP=EarthShield

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Only pass this effect on to latter reflectors if it is its source angreal
// is NOT composed of ElementEarth.
//------------------------------------------------------------------------------
function ProcessEffect( Invokable I )
{
	if( I.SourceAngreal != None && I.SourceAngreal.bElementEarth )
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
	return Inv.bElementEarth;
}

defaultproperties
{
    ImpactType=Class'EarthShieldVisual'
    DeflectSound=Sound'EarthShield.DeflectES'
    TriggerEvent=ElementalEarthTriggered
    IgnoredDamageType=Earth
}
