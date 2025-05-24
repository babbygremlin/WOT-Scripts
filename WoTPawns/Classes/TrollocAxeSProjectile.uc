//=============================================================================
// TrollocAxeSProjectile.
//=============================================================================

class TrollocAxeSProjectile expands TrollocAxeProjectileBase;

#exec MESH IMPORT MESH=MTrollocAxeSProjectile ANIVFILE=MODELS\TrollocAxeS_a.3d DATAFILE=MODELS\TrollocAxeS_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MTrollocAxeSProjectile X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=MTrollocAxeSProjectile SEQ=All         STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=MTrollocAxeSProjectile SEQ=TROLLOC_AXE STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MTrollocAxeSProjectile MESH=MTrollocAxeSProjectile
#exec MESHMAP SCALE MESHMAP=MTrollocAxeSProjectile X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     YawSpinRate=300000
     speed=800.000000
     MaxSpeed=800.000000
     Mesh=Mesh'WOTPawns.MTrollocAxeSProjectile'
     MultiSkins(1)=Texture'WOTPawns.Skins.TBird'
}
