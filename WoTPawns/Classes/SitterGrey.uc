//=============================================================================
// SitterGrey.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

// The champion for the Aes Sedai.

class SitterGrey expands Sitter;

#exec TEXTURE IMPORT NAME=JSitterGrey1 FILE=MODELS\SitterGray1.PCX GROUP=Skins FLAGS=2 // Ajah1

defaultproperties
{
     MultiSkins(1)=Texture'WOTPawns.Skins.JSitterGrey1'
     MultiSkins(2)=Texture'WOTPawns.Skins.JSitterGrey1'
}
