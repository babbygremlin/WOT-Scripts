//=============================================================================
// NPCLegionTextureHelper.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class NPCLegionTextureHelper expands GenericTextureHelper;

#exec AUDIO IMPORT FILE=Sounds\Pawn\NPCs\Legion\TextureMove\Leg_RunTex1.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\NPCs\Legion\TextureMove\Leg_RunTex2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\NPCs\Legion\TextureMove\Leg_RunTex3.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\NPCs\Legion\TextureMove\Leg_RunTex4.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\NPCs\Legion\TextureMove\Leg_LandTex1.wav	GROUP=Landed

//=============================================================================
// Legion only walks so volume shouldn't be lowered when walking.

static function HandleMovingOnTexture( Actor A, Texture CurrentTexture )
{
	DetermineTextureEffect( A, SG_RunWalk, CurrentTexture, 1.0 );
}

//=============================================================================

defaultproperties
{
     MovementEffects(0)=(Texture=ST_All,SoundStr="WOTPawns.Leg_RunTex1")
     MovementEffects(1)=(Texture=ST_All,SoundStr="WOTPawns.Leg_RunTex2")
     MovementEffects(2)=(Texture=ST_All,SoundStr="WOTPawns.Leg_RunTex3")
     MovementEffects(3)=(Texture=ST_All,SoundStr="WOTPawns.Leg_RunTex4")
     MovementEffects(4)=(Group=SG_Landed,Texture=ST_All,SoundStr="WOTPawns.Leg_LandTex1")
     MovementEffects(5)=(Group=SG_End)
}
