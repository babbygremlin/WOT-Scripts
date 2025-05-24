//=============================================================================
// SitterRed.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

// The champion for the Aes Sedai.

class SitterRed expands Sitter;

#exec TEXTURE IMPORT NAME=JSitterRed1 FILE=MODELS\SitterRed1.PCX GROUP=Skins FLAGS=2 // Ajah1

defaultproperties
{
     MultiSkins(1)=Texture'WOTPawns.Skins.JSitterRed1'
     MultiSkins(2)=Texture'WOTPawns.Skins.JSitterRed1'
}
