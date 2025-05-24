//=============================================================================
// SisterYellow.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

// the captain for the Aes Sedai

class SisterYellow expands Sister;

#exec TEXTURE IMPORT NAME=JSisterYellow1 FILE=MODELS\SisterYellow1.PCX GROUP=Skins FLAGS=2 // Ajah1

defaultproperties
{
     MultiSkins(1)=Texture'WOTPawns.Skins.JSisterYellow1'
     MultiSkins(2)=Texture'WOTPawns.Skins.JSisterYellow1'
}
