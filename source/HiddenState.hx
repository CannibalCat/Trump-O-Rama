package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

class HiddenState extends FlxState
{
	private var hiddenText1:FlxText;
	private var hiddenText2:FlxText;
	private var hiddenText3:FlxText;

	override public function create():Void
	{
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			FlxG.sound.music.stop();
			
		hiddenText1 = new FlxText(0, 0, FlxG.width, "TRUMP-O-RAMA");
		hiddenText1.setFormat(Globals.TEXT_FONT, 96, 0xFFFFFFFF, "center", FlxText.BORDER_SHADOW, 0xFF404040);
		hiddenText1.borderSize = 4;
		hiddenText1.setPosition((FlxG.width / 2) - (hiddenText1.width / 2), 200);
		hiddenText1.antialiasing = false;
		add(hiddenText1);
			
		hiddenText2 = new FlxText(0, 0, FlxG.width, "PROGRAMMED AND DESIGNED BY\nJIMMY HUEY AND RICH WALTER");
		hiddenText2.setFormat(Globals.TEXT_FONT, 72, 0xFFFFFFFF, "center", FlxText.BORDER_SHADOW, 0xFF404040);
		hiddenText2.borderSize = 4;
		hiddenText2.setPosition((FlxG.width / 2) - (hiddenText2.width / 2), 300);
		hiddenText2.antialiasing = false;
		add(hiddenText2);
		
		hiddenText3 = new FlxText(0, 0, FlxG.width, "SPECIAL THANKS:\nANGEL LEON AND ZAID WALTER\nFOR TESTING AND FEEDBACK");
		hiddenText3.setFormat(Globals.TEXT_FONT, 72, 0xFFFFFFFF, "center", FlxText.BORDER_SHADOW, 0xFF404040);
		hiddenText3.borderSize = 4;
		hiddenText3.setPosition((FlxG.width / 2) - (hiddenText3.width / 2), 450);
		hiddenText3.antialiasing = false;
		add(hiddenText3);
		
		FlxG.sound.play("Busted"); 
		
		super.create();
	}
	
	override public function update():Void
	{
		ColorCycler.Update();
		
		hiddenText1.color = ColorCycler.WilliamsUltraFlash;
		hiddenText2.color = ColorCycler.WilliamsFlash1;
		hiddenText3.color = ColorCycler.RGB;
		
		if (FlxG.keys.justPressed.ANY)
			FlxG.switchState(new TitleState());
		
		super.update();
	}
	
	override public function destroy():Void
	{
		hiddenText1 = null;
		hiddenText2 = null;
		hiddenText3 = null;

		super.destroy();
	}
}