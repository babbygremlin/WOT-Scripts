class WOTBrowserFavoritesFact extends UBrowserFavoritesFact;

function Query(optional bool bBySuperset, optional bool bInitial)
{
	local int i;
	local UBrowserServerList L;

	Super.Query(bBySuperset, bInitial);

	for(i=0;i<FavoriteCount;i++)
	{
		L = FoundServer(ParseOption(Favorites[i], 1), Int(ParseOption(Favorites[i], 2)), "", "WOT", ParseOption(Favorites[i], 0));
		L.bKeepDescription = ParseOption(Favorites[i], 3) ~= (string(True));
	}

	QueryFinished(True);
}

defaultproperties
{
}
