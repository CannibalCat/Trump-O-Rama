package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.LogitechButtonID;

enum ScaleState 
{
	ZOOMING_IN;
	ZOOMING_OUT;
	CANCELLED;
}

class NewsFlashState extends FlxState
{
	private var newspaper:FlxSprite;
	private var skipText:FlxText;
	private var elapsedTimer:Float = 0;
	private var scaleTimer:Float = 0;
	private var issueTimer:Float = 0;
	private var nextPaper:Int = 1;
	private var currentState:ScaleState;
	
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
		FlxG.camera.bgColor = 0x00000000;
		
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			FlxG.sound.music.stop();
			
		FlxG.sound.playMusic(Globals.NEWSFLASH_BGM, 1, true);
		
		skipText = new FlxText(225, 630, 0, "PRESS ENTER TO SKIP");
		skipText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFFFF);
		skipText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		skipText.antialiasing = false;
		add(skipText);
			
		loadPaper(nextPaper);
		
		currentState = ScaleState.ZOOMING_IN;
		
		super.create();
	}
	
	override public function update():Void
	{
		ColorCycler.Update();
		skipText.color = ColorCycler.WilliamsFlash8;
		
		elapsedTimer += FlxG.elapsed;
		scaleTimer += FlxG.elapsed;
		
		if (elapsedTimer > 0.5)
			skipText.visible = false;

		if (currentState == ScaleState.ZOOMING_IN)
		{
			if (newspaper.scale.x < 2)
			{
				if (scaleTimer > 0.05)
				{
					newspaper.scale.x += 0.1;
					newspaper.scale.y += 0.1;
					scaleTimer = 0;
				}
			}
			else
			{
				newspaper.angularVelocity = 0;
				newspaper.scale.x = 2;
				newspaper.scale.y = 2;
				newspaper.angle = 0;
				
				issueTimer += FlxG.elapsed;
				if (issueTimer > 3)
				{
					issueTimer = 0;
					currentState = ScaleState.ZOOMING_OUT;
					if (nextPaper == 3)
						FlxG.sound.music.fadeOut(1, 0);
				}
			}
		}
		else if (currentState == ScaleState.ZOOMING_OUT)
		{
			if (newspaper.scale.x > 0)
			{
				if (scaleTimer > 0.05)
				{
					newspaper.scale.x -= 0.1;
					newspaper.scale.y -= 0.1;
					scaleTimer = 0;
				}
			}
			else
			{
				newspaper.angularVelocity = 0;
				newspaper.visible = false;
				newspaper = null;
				nextPaper++;
				if (nextPaper > 3)
					FlxG.switchState(new PlayState());
				else
				{
					loadPaper(nextPaper);
					currentState = ScaleState.ZOOMING_IN;
				}
			}			
		}
		else if (currentState == ScaleState.CANCELLED)
		{
			FlxG.sound.music.fadeOut(1, 0);
			FlxG.cameras.fade(0xFF000000, 1, false, onFadeOut);
		}
		
		if (FlxG.keys.pressed.ENTER || gamepad.justPressed(7) || 
			gamepad.justPressed(LogitechButtonID.TEN))
			currentState = ScaleState.CANCELLED;
			
		super.update();
	}
	
	override public function destroy():Void
	{
		newspaper = null;
		skipText = null;
		
		super.destroy();
	}
	
	private function onFadeOut():Void
	{
		FlxG.switchState(new PlayState());
	}
	
	private function loadPaper(number:Int):Void
	{
		newspaper = new FlxSprite(0, 0, "assets/images/Newspaper" + Std.string(Globals.currentZone) + "_" + Std.string(number) + ".png");
		newspaper.setPosition(FlxG.width / 2 - newspaper.width / 2, FlxG.height / 2 - newspaper.height / 2);
		newspaper.scale.x = 0;
		newspaper.scale.y = 0;
		newspaper.angularVelocity = 720;
		newspaper.visible = true;
		add(newspaper); 
	}
}