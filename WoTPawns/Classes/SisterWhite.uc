//=============================================================================
// SisterWhite.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

// the captain for the Aes Sedai

class SisterWhite expands Sister;

#exec TEXTURE IMPORT NAME=JSisterWhite1 FILE=MODELS\SisterWhite1.PCX GROUP=Skins FLAGS=2 // Ajah1

defaultproperties
{
     MultiSkins(1)=Texture'WOTPawns.Skins.JSisterWhite1'
     MultiSkins(2)=Texture'WOTPawns.Skins.JSisterWhite1'
}
