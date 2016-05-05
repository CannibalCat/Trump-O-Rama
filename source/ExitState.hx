package ;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class ExitState extends FlxSubState
{
	private var elapsedTime:Float = 0;
	
	public function new(BGColor:Int=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		FlxG.sound.play("PilotReadyToRollOut");
	}
	
	private function fadeOut():Void 
	{
		FlxG.cameras.fade(0xFF000000, 2, false, close);
	}
	
	override public function update():Void
	{
		if (Globals.pauseGame)
			return;
			
		elapsedTime += FlxG.elapsed;
			
		Globals.globalGameState.chopper.velocity.y -= 4 *  (1 + elapsedTime);
		if (Globals.globalGameState.chopper.y + Globals.globalGameState.chopper.frameHeight <= 0)
			fadeOut();
			
		Globals.globalGameState.player.setPosition(Globals.globalGameState.chopper.x + 305, Globals.globalGameState.chopper.y + 56); 
		super.update();
	}
	
	override public function close():Void 
	{
		super.close();
		Globals.palinActive = false;
		if (Globals.currentWave % 4 == 0)
			FlxG.switchState(new BombingRunState());
		else
			FlxG.switchState(new TrumpismState());
	}
}