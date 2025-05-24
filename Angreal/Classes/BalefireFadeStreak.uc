//------------------------------------------------------------------------------
// BalefireFadeStreak.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BalefireFadeStreak expands Streak;

#exec TEXTURE IMPORT FILE=MODELS\BalefireFade.pcx GROUP=Skins FLAGS=2 // SKIN

defaultproperties
{
     SegmentLength=64.000000
     DrawType=DT_Mesh
     Skin=Texture'Angreal.Skins.BalefireFade'
     Mesh=Mesh'Angreal.LightningBolt'
     bUnlit=True
}
