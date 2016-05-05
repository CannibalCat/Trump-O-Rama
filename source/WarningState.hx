package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.LogitechButtonID;

class WarningState extends FlxState
{
	private var warningScreen:FlxSprite;
	private var attractTimer:Float = 4;
	private var exitDialogActive:Bool = false;
	
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
		warningScreen = new FlxSprite(0, 0, "assets/images/WarningScreen.png");
		add(warningScreen); 
		
		FlxG.cameras.fade(0xFF000000, 1, true);
		
		super.create();
	}
	
	private function onCloseDialog():Void
	{
		exitDialogActive = false;
	}
	
	override public function update():Void
	{
		ColorCycler.Update();
		
		if (exitDialogActive)
			return;		

		attractTimer -= FlxG.elapsed;
		
		if (attractTimer <= 0)
			FlxG.cameras.fade(0xFF000000, 1, false, onFinalFade);
			
		super.update();
	}
	
	private function onFinalFade():Void
	{
		FlxG.switchState(new TitleState());
	}
	
	override public function destroy():Void
	{
		warningScreen = null;
		super.destroy();
	}
}