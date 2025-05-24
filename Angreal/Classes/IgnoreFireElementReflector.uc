//------------------------------------------------------------------------------
// IgnoreFireElementReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	If we receive an angreal effect that comes from an angreal
//				composed of FireElement, throw that effect away.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class IgnoreFireElementReflector expands IgnoreElementReflector;

#exec AUDIO IMPORT FILE=Sounds\FireShield\DeflectFS.wav		GROUP=FireShield

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Only pass this effect on to latter reflectors if it is its source angreal
// is NOT composed of ElementFire.
//------------------------------------------------------------------------------
function ProcessEffect( Invokable I )
{
	if( I.SourceAngreal != None && I.SourceAngreal.bElementFire )
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
	return Inv.bElementFire;
}

defaultproperties
{
     ImpactType=Class'Angreal.FireShieldVisual'
     DeflectSound=Sound'Angreal.FireShield.DeflectFS'
     TriggerEvent=ElementalFireTriggered
     IgnoredDamageType=Fire
}
