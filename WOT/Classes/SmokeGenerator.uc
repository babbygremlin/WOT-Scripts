//=============================================================================
// SmokeGenerator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================
class SmokeGenerator expands Effects;

#exec TEXTURE IMPORT FILE=Icons\I_SmokeGen.pcx GROUP=Effects

var() float SmokeDelay;		// pause between puffs
var() float SizeVariance;	// how different each puff is 
var() float BasePuffSize;
var() int TotalNumPuffs;
var() float RisingVelocity;
var() class<effects> GenerationType;
var int SmokeCount;

auto state Active
{
	function Timer()
	{
		local Effects d;
		
		d = Spawn( GenerationType );
		d.DrawScale = BasePuffSize + FRand() * SizeVariance;
		if( AnimSpriteEffect(d) != None )
			AnimSpriteEffect(d).RisingRate = RisingVelocity;	
		SmokeCount++;
		if( SmokeCount > TotalNumPuffs && TotalNumPuffs != 0 )
			Destroy();
	}

	function Trigger( actor Other, pawn EventInstigator )
	{
		SetTimer( SmokeDelay + FRand() * SmokeDelay, True );
		SmokeCount = 0;
	}

	function UnTrigger( actor Other, pawn EventInstigator )
	{
		SmokeCount = 0;
		if( TotalNumPuffs == 0 )
			Destroy();
	}
}

defaultproperties
{
     SmokeDelay=0.150000
     SizeVariance=1.000000
     BasePuffSize=1.750000
     TotalNumPuffs=200
     RisingVelocity=75.000000
     GenerationType=Class'WOT.SpriteSmokePuff'
     bHidden=True
     DrawType=DT_Sprite
     Style=STY_Masked
     Texture=None
}
