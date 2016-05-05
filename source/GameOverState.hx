package ;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GameOverState extends FlxSubState
{
	private var gameOverText:FlxText;
	private var resetTimer:Float = 0;
	private var firedPlayed:Bool = false;
	
	public function new(BGColor:Int=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		gameOverText = new FlxText(0, 0, FlxG.width, "GAME OVER"); 
		gameOverText.setFormat(Globals.TEXT_FONT, 72, 0xFFFFFF, "center", FlxText.BORDER_SHADOW, 0x000000);
		gameOverText.borderSize = 4;
		gameOverText.antialiasing = false;
		gameOverText.setPosition((FlxG.width / 2) - (gameOverText.width / 2), FlxG.height / 2  - 60);
		gameOverText.scrollFactor.x = 0;
		add(gameOverText);		
		
		FlxG.sound.play("Tilt");
	}
	
	override public function destroy():Void
	{
		gameOverText = null;
		super.destroy();
	}
	
	override public function update():Void
	{
		resetTimer += FlxG.elapsed;
		
		if (resetTimer > 1 && !firedPlayed)
		{
			FlxG.sound.play("Fired");
			firedPlayed = true;
		}
		
		if (resetTimer > 6)
			close();
			
		gameOverText.color = ColorCycler.WilliamsUltraFlash;
		super.update();
	}
	
	override public function close():Void 
	{
		super.close();
		Globals.resetCheatValues();
		FlxG.switchState(new HighScoresState());
	}
}