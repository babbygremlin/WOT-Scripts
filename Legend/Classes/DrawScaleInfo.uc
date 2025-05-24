//=============================================================================
// DrawScaleInfo.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class DrawScaleInfo expands AiComponent;

var float DrawScaleRatio;
var float DrawScaleFactor;



function Init( Actor ScaledActor )
{
	InitDrawScaleRatio( ScaledActor );
	InitDrawScaleFactor( ScaledActor );
}


function InitDrawScaleRatio( Actor ScaledActor )
{
	DrawScaleRatio = ScaledActor.DrawScale / ScaledActor.Default.DrawScale;
}


function InitDrawScaleFactor( Actor ScaledActor )
{
	DrawScaleFactor = Sqrt( GetDrawScaleRatio() );
}



function float GetDrawScaleRatio()
{
	return DrawScaleRatio;
}



function float GetDrawScaleFactor()
{
	return DrawScaleFactor;
}

defaultproperties
{
}
