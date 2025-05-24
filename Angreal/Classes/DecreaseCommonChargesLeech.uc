//------------------------------------------------------------------------------
// DecreaseCommonChargesLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Decreases the victim's common angreal charges over time.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Since just one charge is used per iteration, make sure you set its
//   AffectResolution to how often you want that one charge taken away.
//------------------------------------------------------------------------------
class DecreaseCommonChargesLeech expands Leech;

// Piggy-backed sounds.
#exec AUDIO IMPORT FILE=Sounds\Decay\LeechDC.wav	GROUP=Decay

var AttachedSound Sounder;

var() Sound DecaySound;

//------------------------------------------------------------------------------
function AttachTo( Pawn NewHost )
{
	Super.AttachTo( NewHost );

	if( Owner == NewHost && DecaySound != None )
	{
		Sounder = Spawn( class'AttachedSound', Owner );
		Sounder.AmbientSound = DecaySound;
	}
}

//------------------------------------------------------------------------------
function UnAttach()
{
	if( Sounder != None )
	{
		Sounder.Destroy();
		Sounder = None;
	}

	Super.UnAttach();
}

//------------------------------------------------------------------------------
function Destroyed()
{
	if( Sounder != None )
	{
		Sounder.Destroy();
		Sounder = None;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
function AffectHost( optional int Iterations )
{
	local Inventory Inv;

	if( Owner != None && Pawn(Owner).Health > 0 )
	{
		// Iterate through all its inventory.
		for( Inv = Pawn(Owner).Inventory;
			 Inv != None;
			 Inv = Inv.Inventory )
		{
			// If you find a ter'angreal and it is common.
			if( AngrealInventory(Inv) != None && AngrealInventory(Inv).bCommon )
			{
				//AngrealInventory(Inv).UseCharge();
				AngrealInventory(Inv).CurCharges -= 1;
				if( AngrealInventory(Inv).CurCharges <= 0 )
				{
					AngrealInventory(Inv).UnCast();
					AngrealInventory(Inv).GoEmpty();
				}
			}
		}
	}
	else
	{
		Unattach();
	}
}

defaultproperties
{
    DecaySound=Sound'Decay.LeechDC'
    AffectResolution=1.00
    bDeleterious=True
}
