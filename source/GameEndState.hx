package ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class GameEndState extends FlxState
{
	private var theEndLogo:FlxSprite;
	private var waitTimer:FlxTimer;
	
	override public function create():Void
	{
		theEndLogo = new FlxSprite();
		theEndLogo.loadGraphic("assets/images/TheEndLogo.png", false, 528, 96, false);
		theEndLogo.setPosition((FlxG.width / 2) - (theEndLogo.width / 2), (FlxG.height / 2) - (theEndLogo.height / 2));
		add(theEndLogo);		
		
		FlxG.camera.bgColor = 0xFF000000;
		FlxG.cameras.fade(0xFF000000, 2, true);
		
		waitTimer = new FlxTimer(4, onTimerComplete, 1);
	}
	
	private function onTimerComplete(timer:FlxTimer):Void
	{
		FlxG.cameras.fade(0xFF000000, 2, false, onFadeOutComplete);
	}
	
	private function onFadeOutComplete():Void
	{
		Globals.validatePlayerScore = true; 
		FlxG.sound.volume = 1;
		FlxG.switchState(new HighScoresState());
	}
	
	override public function destroy():Void
	{
		theEndLogo = null;
		if (waitTimer != null)
			waitTimer.destroy();
		
		super.destroy();
	}
}