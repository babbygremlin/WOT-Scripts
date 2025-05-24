//=============================================================================
// Credits.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 16 $
//=============================================================================
class Credits expands uiHUD;

const NORMAL_FONT_Y = 14;
const SPACING_FACTOR = 1.5;
const LEFT_COLUMN = 0.2;
const RIGHT_COLUMN = 0.5;

var float LinesPerSecond;
var float AdjustedLinesPerSecond;
var float YOffset;
var string CreditsText[204];

simulated function PostRender( Canvas C )
{
	local int i, n, Y;
	local float XL, YL;
	local Actor A;

	C.SetFont( font'WOT.F_WOTReg14' );
	C.StrLen( " ", XL, YL );

	AdjustedLinesPerSecond = LinesPerSecond * ( YL / NORMAL_FONT_Y );

	Y = YOffset + SizeY;
	for( i = 0; i < ArrayCount(CreditsText); i++ )
	{
		C.StrLen( CreditsText[i], XL, YL );
		if( Y > -YL )
		{
			C.DrawColor.R = 180;
			C.DrawColor.G = 180;
			C.DrawColor.B = 180;

			n = InStr( CreditsText[i], " - " );
			if( InStr( CreditsText[i], ":" ) != -1 || InStr( CreditsText[i], "   " ) != -1 )
			{
				if( InStr( CreditsText[i], ":" ) != -1 )
				{
					C.DrawColor.R = 255;
					C.DrawColor.G = 255;
					C.DrawColor.B = 255;
				}
				// left aligned
				C.SetPos( SizeX * LEFT_COLUMN, Y );
				C.DrawText( CreditsText[i], false );
			}
			else if( n == -1 )
			{
				C.DrawColor.R = 255;
				C.DrawColor.G = 255;
				C.DrawColor.B = 255;
				// centered
				C.SetPos( ( SizeX - XL ) / 2, Y );
				C.DrawText( CreditsText[i], false );
			}
			else
			{
				// left aligned and indended from center
				C.SetPos( SizeX * LEFT_COLUMN, Y );
				C.DrawText( Left( CreditsText[i], n ), false );
				C.SetPos( SizeX * RIGHT_COLUMN, Y );
				C.DrawText( Right( CreditsText[i], Len( CreditsText[i] ) - ( n + 3 ) ), false );
			}
		}

		Y += YL * SPACING_FACTOR;
		if( Y > SizeY )
		{
			break;
		}
	}

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	if( -YOffset > YL * SPACING_FACTOR * ArrayCount(CreditsText) + SizeY )
	{
		WOTPlayer(Owner).EndCredits();
		foreach AllActors( class'Actor', A, 'CreditsComplete' )
		{
			A.Trigger( Self, Pawn(Owner) );
		}
	}
}

simulated function Tick( float DeltaTime )
{
	YOffset -= DeltaTime * AdjustedLinesPerSecond;
}

simulated function bool KeyEvent( int Key, int Action, FLOAT Delta )
{
	local Actor A;

	if( Action == EInputAction.IST_Press )
	{
		WOTPlayer(Owner).EndCredits();
		foreach AllActors( class'Actor', A, 'CreditsAborted' )
		{
			A.Trigger( Self, Pawn(Owner) );
		}
		return true;
	}

	return false;
}

defaultproperties
{
     LinesPerSecond=40.000000
     CreditsText(0)="THE WHEEL OF TIME"
     CreditsText(1)=" "
     CreditsText(2)="Based on @The Wheel of Time@"
     CreditsText(3)="novels by Robert Jordan "
     CreditsText(4)=" "
     CreditsText(5)=" "
     CreditsText(6)="LEGEND ENTERTAINMENT COMPANY"
     CreditsText(7)=" "
     CreditsText(8)="Game Designer/Writer - Glen Dahlgren"
     CreditsText(9)=" "
     CreditsText(10)="Producers - Mike Verdu, Mark Poesch, Glen Dahlgren"
     CreditsText(11)=" "
     CreditsText(12)="Art Director - Glen Dahlgren"
     CreditsText(13)=" "
     CreditsText(14)="Executive Producer - Mike Verdu"
     CreditsText(15)=" "
     CreditsText(16)="Technical Lead - Mark Poesch"
     CreditsText(17)=" "
     CreditsText(18)="AI Lead - Ryan Ovrevik"
     CreditsText(19)=" "
     CreditsText(20)="Technical Team - Mark Poesch"
     CreditsText(21)=" - Ryan Ovrevik"
     CreditsText(22)=" - Aaron Leiby"
     CreditsText(23)=" - Mike Fox"
     CreditsText(24)=" - Jess Crable"
     CreditsText(25)=" - Sam Brown"
     CreditsText(26)=" - Jim Montanus"
     CreditsText(27)=" "
     CreditsText(28)="Additional Programming - Duane Beck"
     CreditsText(29)=" - Warren Marshall"
     CreditsText(30)=" "
     CreditsText(31)="Level Design Team:"
     CreditsText(32)="Lead Level Designer - Scott Dalton"
     CreditsText(33)="Level Designers - James Parkman"
     CreditsText(34)=" - Warren Marshall"
     CreditsText(35)=" - Matthias Worch"
     CreditsText(36)=" "
     CreditsText(37)="Additional Level Design by:"
     CreditsText(38)="Level Designers - Dave Kelvin"
     CreditsText(39)=" - Aaron Logue"
     CreditsText(40)=" - Steve Fukuda"
     CreditsText(41)=" - Tim Jervis"
     CreditsText(42)=" "
     CreditsText(43)="UI Development:"
     CreditsText(44)=" - Paul Mock"
     CreditsText(45)=" - Julie Airoldi"
     CreditsText(46)=" - Mike Fox"
     CreditsText(47)=" - Mark Poesch"
     CreditsText(48)=" - Jim Montanus"
     CreditsText(49)=" - Glen Dahlgren"
     CreditsText(50)=" "
     CreditsText(51)="Art Team:"
     CreditsText(52)="Art Lead/Director - Paul Mock"
     CreditsText(53)="Effects Artist - Robert Wisnewski"
     CreditsText(54)="Texture Artists - Julie Airoldi"
     CreditsText(55)=" - Marc Tetreault"
     CreditsText(56)=" - Cindy Wentzell"
     CreditsText(57)="Character Skin Artist - Joel Walden"
     CreditsText(58)="Character Modeler - Sherer Design Associates"
     CreditsText(59)=" - Joel Walden"
     CreditsText(60)="Character Animator - Evolution Graphics"
     CreditsText(61)="Architect - Paul Mock"
     CreditsText(62)=" "
     CreditsText(63)="Additional Character Animation by:"
     CreditsText(64)="Character Animators - Joel Walden"
     CreditsText(65)=" - Robert Wisnewski"
     CreditsText(66)=" "
     CreditsText(67)="Sound and Music Team:"
     CreditsText(68)="Music Composers - Robert Berry"
     CreditsText(69)=" - Leif Sorbye"
     CreditsText(70)="Sound Effects Engineers - Andy Frazier"
     CreditsText(71)=" - Eric Heberling"
     CreditsText(72)=" - Tommy Tallarico Studios"
     CreditsText(73)=" "
     CreditsText(74)="Additional Music by:"
     CreditsText(75)="Composer - Andy Frazier"
     CreditsText(76)=" "
     CreditsText(77)="Cut Scene Animation Team:"
     CreditsText(78)="Writer/Director - Glen Dahlgren"
     CreditsText(79)="Storyboards - Dub Media"
     CreditsText(80)=" - Kathleen Bober"
     CreditsText(81)="Environment Importer - Dub Media"
     CreditsText(82)="Animators - Blur Studios"
     CreditsText(83)=" - Spank Hole Studios"
     CreditsText(84)="Video Engineer - Jim Montanus"
     CreditsText(85)=" "
     CreditsText(86)="Additional Animation by:"
     CreditsText(87)="Animators - Dub Media"
     CreditsText(88)=" "
     CreditsText(89)="Voice Talent:"
     CreditsText(90)="Casting/Voice Directors - Glen Dahlgren"
     CreditsText(91)=" - Kathleen Bober"
     CreditsText(92)="Narrator - Henry Strozier"
     CreditsText(93)="Elayna Sedai - Colleen Delany"
     CreditsText(94)="The Hound - Conrad Feininger"
     CreditsText(95)="Ishamael, the Forsaken - Jeff Baker"
     CreditsText(96)="Whitecloak Leader - Bob Supan"
     CreditsText(97)="Amyrlin Seat - Lucy Newman Williams"
     CreditsText(98)="Sephraem - Jacqueline Underwood"
     CreditsText(99)="Cerist - Jacqueline Underwood"
     CreditsText(100)="Trollocs - Bob Supan"
     CreditsText(101)="Trolloc Clan Leader - George Wilson"
     CreditsText(102)="Myrddraal - Bob Supan"
     CreditsText(103)="Warders - Bob Supan"
     CreditsText(104)="Mashadar - Bob Supan"
     CreditsText(105)="Generic Whitecloaks - Bob Supan"
     CreditsText(106)=" - Jeff Baker"
     CreditsText(107)="Poleine - Carolyn Stewart"
     CreditsText(108)="Blue Sister - Lynn Filusch"
     CreditsText(109)="Brown Sister - Shannon Parks"
     CreditsText(110)="Angry Sitter - Lynn Filusch"
     CreditsText(111)="Machin Shin - Lucy Newman Williams"
     CreditsText(112)=" - Conrad Feininger"
     CreditsText(113)=" - Carolyn Stewart"
     CreditsText(114)=" - Lynn Filusch"
     CreditsText(115)=" - Jeff Baker"
     CreditsText(116)="Legion - Andy Frazier"
     CreditsText(117)=" - Deanne Guardino"
     CreditsText(118)="Kyrin - Kathleen Bober"
     CreditsText(119)="Whitecloak Guard - Glen Dahlgren"
     CreditsText(120)=" "
     CreditsText(121)="Proof-of-Concept Team:"
     CreditsText(122)=" - Glen Dahlgren, Mark Poesch"
     CreditsText(123)=" - Dave Townsend, Dave Chladon"
     CreditsText(124)=" - Aaron Logue"
     CreditsText(125)=" - Paul Mock, Cindy Wentzell, Robert Wisnewski"
     CreditsText(126)=" "
     CreditsText(127)="Quality Assurance Team (Legend):"
     CreditsText(128)="QA Lead - Craig Lafferty"
     CreditsText(129)="Testers - Grant Roberts"
     CreditsText(130)=" - Ben Leiby"
     CreditsText(131)=" "
     CreditsText(132)="Additional Testing - Justice Hearn"
     CreditsText(133)=" - Peter Logan"
     CreditsText(134)=" - Charlie Cash"
     CreditsText(135)=" "
     CreditsText(136)="Production Team:"
     CreditsText(137)="Office Manager - Rosie Freeman"
     CreditsText(138)="Production Assistance - Sam Brown"
     CreditsText(139)="Assistant Producer - Craig Lafferty"
     CreditsText(140)=" "
     CreditsText(141)="Ter'angreal flavor text researchers:"
     CreditsText(142)=" - autio"
     CreditsText(143)=" - James Bradwell"
     CreditsText(144)=" - Kyle Davis"
     CreditsText(145)=" - Glen Dahlgren"
     CreditsText(146)=" - Joy Debnath"
     CreditsText(147)=" - Travis King"
     CreditsText(148)=" - Nathan Leung"
     CreditsText(149)=" - Philip Moschovas"
     CreditsText(150)=" - Andrew Penick"
     CreditsText(151)=" - Ronny Hanset Ringen"
     CreditsText(152)=" - Matt Ryall"
     CreditsText(153)=" - Jakob Strasser"
     CreditsText(154)=" "
     CreditsText(155)="GT Interactive"
     CreditsText(156)=" "
     CreditsText(157)="Producer - Jason Schreiber"
     CreditsText(158)="Product Manager - Barbara Gleason"
     CreditsText(159)="QA Manager - Steve Knopf"
     CreditsText(160)="Test Lead - Jim Dunn"
     CreditsText(161)="Senior Tester - Jeff Oviatt"
     CreditsText(162)="Testers - Chris Dunn"
     CreditsText(163)=" - Aaron Harris"
     CreditsText(164)=" - Scott 'Cubbie' Donaldson"
     CreditsText(165)=" - Brandon Montrone"
     CreditsText(166)=" - Jon Marquette"
     CreditsText(167)=" - Doug Price"
     CreditsText(168)=" - Yume Gregersen"
     CreditsText(169)=" - Josh Galloway"
     CreditsText(170)="Documentation Manager - Peter Witcher"
     CreditsText(171)="Network/MIS - Mike Fassbinder"
     CreditsText(172)="CD Replication - Patick Struhs"
     CreditsText(173)="Director of Marketing - Tony Kee"
     CreditsText(174)="Director of Creative Services - Leslie Mills"
     CreditsText(175)="Art/Trafficking Manager - Liz Fierro"
     CreditsText(176)="Creative Director - Vic Merritt"
     CreditsText(177)="Senior Graphic Designers - Michael Marrs"
     CreditsText(178)=" - Lesley Zinn"
     CreditsText(179)=" "
     CreditsText(180)="Localization - Mark Cárter"
     CreditsText(181)=" - Neil McKenna"
     CreditsText(182)=" - Olivier Goulon"
     CreditsText(183)=" - Alex Nannicini"
     CreditsText(184)=" - Sam Brown"
     CreditsText(185)=" - Mike Fox"
     CreditsText(186)=" "
     CreditsText(187)="@The Wheel of Time@, @The Eye of the World@, @The Dragon Reborn@,"
     CreditsText(188)="and the snake wheel symbol are trademarks of Robert Jordan"
     CreditsText(189)=" "
     CreditsText(190)=" "
     CreditsText(191)="Special Thanks to:"
     CreditsText(192)="   Tim Sweeney, the father of Unreal"
     CreditsText(193)="   Robert Jordan, for giving us such a wonderful and detailed world"
     CreditsText(194)=" "
     CreditsText(195)="Additional Thanks to:"
     CreditsText(196)="   The entire Epic team"
     CreditsText(197)="   Bob Berry for design concepts in the Advanced Windowing Toolkit"
     CreditsText(198)="   The Coca Cola Company"
     CreditsText(199)="   Mtn. Dew"
     CreditsText(200)=" "
     CreditsText(201)="Extra-Special Thanks to:"
     CreditsText(202)="   Our families and friends, for their tolerance of our long hours,"
     CreditsText(203)="   their understanding, love and support"
}
