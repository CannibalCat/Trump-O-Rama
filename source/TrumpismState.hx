package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxRandom;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.LogitechButtonID;

class TrumpismState extends FlxState
{
	private var trumpHead:FlxSprite;
	private var quoteText:FlxText;
	private var quoteSourceText:FlxText;
	private var trumpismNumber:Int;
	private var delayTimer:Float = 6;
	
	private var gamepad(get, never):FlxGamepad;
	private function get_gamepad():FlxGamepad 
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		
		if (gamepad == null)
			gamepad = FlxG.gamepads.getByID(0);

		return gamepad;
	}

	override public function create():Void
	{
		FlxG.camera.bgColor = 0xFF000000;
		FlxG.cameras.flash(0xFF000000, 2);
		
		trumpismNumber = FlxRandom.intRanged(1, 18, Globals.trumpismsUsed);
		
		trumpHead = new FlxSprite(0, 0, "assets/images/TrumpSmug.png");
		trumpHead.setPosition(80, FlxG.height / 2 - trumpHead.height / 2);
		add(trumpHead); 
		
		quoteText = new FlxText(355, 305, 0, getNextQuote());
		quoteText.setFormat(Globals.TEXT_FONT, 32, 0xFFFFFFFF);
		quoteText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		quoteText.antialiasing = false;
		add(quoteText);
		
		quoteSourceText = new FlxText(355, 465, 0, getNextQuoteSource());
		quoteSourceText.setFormat(Globals.TEXT_FONT, 18, 0xFFFFFFFF);
		quoteSourceText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 2);
		quoteSourceText.antialiasing = false;
		add(quoteSourceText);
	
		super.create();
	}
	
	private function getNextQuote():String
	{
		var nextQuote:String = "";
		
		switch trumpismNumber
		{
			case 1:
				nextQuote = "\"She does have a very nice figure\nI've said if Ivanka weren't my\ndaughter, perhaps I'd be dating her.\"";
				
			case 2:
				nextQuote = "\"I think the only difference between\nme and the other candidates is that\nI'm more honest and my women are\nmore beautiful.\"";
				
			case 3:
				nextQuote = "\"Look at those hands, are they\nsmall hands?\"";

			case 4:
				nextQuote = "\"You know, it doesn't matter what\nthe media writes as long as\nyou've got a young and beautiful\npiece of ass.\"";
				
			case 5:
				nextQuote = "\"I will be the greatest jobs\npresident that God ever created.\"";
				
			case 6:
				nextQuote = "\"Do you mind if I sit back a little?\nBecause your breath is very bad.\"";
				
			case 7:
				nextQuote = "\"All of the women on \"The Apprentice\"\nflirted with me - consciously or\nunconsciously. That's to be expected.\"";
				
			case 8:
				nextQuote = "\"My IQ is one of the highest - and\nyou all know it! Please don't feel so\nstupid or insecure; it's not your fault.\"";
				
			case 9:
				nextQuote = "\"I have seen women manipulate men\nwith just a twitch of their eye - or\nperhaps another body part.\"";
				
			case 10:
				nextQuote = "\"She's not giving me 100 percent.\nShe's giving me 84 percent, and 16\npercent is going towards taking\ncare of children.\"";
				
			case 11:
				nextQuote = "\"You know who's one of the great\nbeauties of the world, according to\neverybody? And I helped create her.\nIvanka. My Daughter, Ivanka. She's 6\nfeet tall, she's got the best body.\"";

			case 12:
				nextQuote = "\"Who the fuck knows? I mean, really,\nwho knows how much the Japs\nwill pay for Manhattan property\nthese days?\"";

			case 13:
				nextQuote = "\"I'm intelligent. Some people would say\nI'm very, very, very intelligent.\"";

			case 14:
				nextQuote = "\"Oftentimes when I was sleeping with\none of the top women in the world I\nwould say to myself, thinking about me\nas a boy from Queens, 'Can you believe\nwhat I'm getting?'\"";

			case 15:
				nextQuote = "\"Of course it is very hard for them\nto attack me on looks because\nI'm so good-looking.\"";

			case 16:
				nextQuote = "\"That must be a pretty picture, you\ndropping to your knees.\"";

			case 17:
				nextQuote = "\"Part of the beauty of me is that\nI'm very rich.\"";

			case 18:
				nextQuote = "\"I want a very good-looking guy\nto play me.\"";
		}
		
		return nextQuote;
	}
	
	private function getNextQuoteSource():String
	{
		var nextQuoteSource:String = "";
		
		switch trumpismNumber
		{
			case 1:
				nextQuoteSource = "The View, March 5, 2006";
				
			case 2:
				nextQuoteSource = "New Tork Times, November 17, 1999";
				
			case 3:
				nextQuoteSource = "Republican Debates, March 6, 2016";

			case 4:
				nextQuoteSource = "Esquire, 1991";
				
			case 5:
				nextQuoteSource = "Presidential Announcement Speech, June 6, 2015";
				
			case 6:
				nextQuoteSource = "The Larry King Show, April 15, 1989";
				
			case 7:
				nextQuoteSource = "How to Get Rich, 2004";
				
			case 8:
				nextQuoteSource = "Twitter, May 8, 2013";
				
			case 9:
				nextQuoteSource = "Trump: The Art of the Comeback, 1997";
				
			case 10:
				nextQuoteSource = "TIME, May 23, 2011";
				
			case 11:
				nextQuoteSource = "The Howard Stern Show, 2003";
				
			case 12:
				nextQuoteSource = "TIME, 1989";
				
			case 13:
				nextQuoteSource = "Fortune, April 3, 2000";
				
			case 14:
				nextQuoteSource = "Think Big: Make it Happen in Business and Life, 2008";
				
			case 15:
				nextQuoteSource = "NBC, Meet the Press, August 9, 2015";
				
			case 16:
				nextQuoteSource = "The Apprentice, March 3, 2013";
				
			case 17:
				nextQuoteSource = "Good Morning America, March 17, 2011";
				
			case 18:
				nextQuoteSource = "Master Apprentice, 2005";
		}
		
		return nextQuoteSource;
	}
	
	override public function update():Void
	{
		ColorCycler.Update();
		
		if (delayTimer > 0)
			delayTimer -= FlxG.elapsed;
			
		if (delayTimer <= 0 || FlxG.keys.justPressed.ENTER || gamepad.justPressed(7) || gamepad.justPressed(LogitechButtonID.TEN))
			FlxG.cameras.fade(0xFF000000, 2, false, onFinalFade);
			
		super.update();
	}
	
	private function onFinalFade():Void
	{
		Globals.currentWave++;
		Globals.trumpismsUsed.push(trumpismNumber);
		if (Globals.currentWave == 5 || Globals.currentWave == 9 || Globals.currentWave == 13 || 
			Globals.currentWave == 17 || Globals.currentWave == 21 || Globals.currentWave == 25)
			FlxG.switchState(new NewsFlashState());
		else
			FlxG.switchState(new PlayState());
	}
	
	override public function destroy():Void
	{
		trumpHead = null;
		quoteText = null;
		quoteSourceText = null;
		
		super.destroy();
	}
}