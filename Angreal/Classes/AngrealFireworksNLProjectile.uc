//------------------------------------------------------------------------------
// AngrealFireworksNLProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	No lights.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealFireworksNLProjectile expands AngrealFireworksProjectile;

defaultproperties
{
    Fireworks(0)=(ProjType=Class'ParticleSystems.Firework01NL',ExpType=Class'ParticleSystems.Firework05NL',LaunchSound=Sound'Fireworks.Launch1FW',ExplodeSound=Sound'Fireworks.Explode1FW'),
    Fireworks(1)=(ProjType=Class'ParticleSystems.Firework06NL',ExpType=Class'ParticleSystems.Firework05NL',LaunchSound=Sound'Fireworks.Launch1FW',ExplodeSound=Sound'Fireworks.Explode1FW'),
    Fireworks(2)=(ProjType=Class'ParticleSystems.Firework03NL',ExpType=Class'ParticleSystems.Firework09NL',LaunchSound=Sound'Fireworks.Launch1FW',ExplodeSound=Sound'Fireworks.Explode3FW'),
    Fireworks(3)=(ProjType=Class'ParticleSystems.Firework04NL',ExpType=Class'ParticleSystems.Firework08NL',LaunchSound=Sound'Fireworks.Launch1FW',ExplodeSound=Sound'Fireworks.Explode2FW'),
    Fireworks(4)=(ProjType=Class'ParticleSystems.Firework02NL',ExpType=Class'ParticleSystems.Firework07NL',LaunchSound=Sound'Fireworks.Launch1FW',ExplodeSound=Sound'Fireworks.Explode2FW'),
}
