//------------------------------------------------------------------------------
// IgnoreSpiritElementReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	If we receive an angreal effect that comes from an angreal
//				composed of SpiritElement, throw that effect away.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class IgnoreSpiritElementReflector expands IgnoreElementReflector;

#exec AUDIO IMPORT FILE=Sounds\SpiritShield\DeflectSS.wav		GROUP=SpiritShield

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Only pass this effect on to latter reflectors if it is its source angreal
// is NOT composed of ElementSpirit.
//------------------------------------------------------------------------------
function ProcessEffect( Invokable I )
{
	if( I.SourceAngreal != None && I.SourceAngreal.bElementSpirit )
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
	return Inv.bElementSpirit;
}

defaultproperties
{
     ImpactType=Class'Angreal.SpiritShieldVisual'
     DeflectSound=Sound'Angreal.SpiritShield.DeflectSS'
     TriggerEvent=ElementalSpiritTriggered
     IgnoredDamageType=Spirit
}
