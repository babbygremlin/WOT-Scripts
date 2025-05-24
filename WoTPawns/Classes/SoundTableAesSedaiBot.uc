//=============================================================================
// SoundTableAesSedaiBot.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class SoundTableAesSedaiBot expands SoundTableAesSedai;

defaultproperties
{
     SoundList(1)=(SoundSlot=Acquired,SoundOdds=0.330000,ESoundInfo=(SoundString="AesSedaiA.Aes_Taunt1",Radius=2048.000000))
     SoundList(2)=(SoundSlot=Acquired,SoundOdds=0.330000,ESoundInfo=(SoundString="AesSedaiA.Aes_Taunt3",Radius=2048.000000))
     SoundList(3)=(SoundSlot=Acquired,SoundOdds=0.330000,ESoundInfo=(SoundString="AesSedaiA.Aes_Taunt5",Radius=2048.000000))
     SoundList(48)=(SoundSlot=Breath,SoundOdds=1.000000,ESoundInfo=(SoundString="AesSedaiBotA.AesB_Breath1",Slot=SLOT_Talk,Volume=1.000000,Radius=256.000000,Pitch=1.000000))
     SoundList(49)=(SoundSlot=Look,SoundOdds=1.000000,ESoundInfo=(SoundString="AesSedaiA.Aes_Taunt6",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
}
