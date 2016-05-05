package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.util.FlxRandom;

class Chopper extends Entity
{
	private var chopperBlades:FlxSound;
	private var timeElapsed:Float = 0;
	private var y_offset:Float = 0;
	private var x_offset:Float = 0;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0) 
	{
		super(X, Y, Z);
		
		loadGraphic("assets/images/Chopper.png", true, 958, 270, false);
		animation.add("default", [0, 1], 16, true);
		animation.play("default");
		
		chopperBlades = FlxG.sound.load("assets/sounds/Chopper.wav", 1, true, true); 
		chopperBlades.proximity(x, y, FlxG.camera.target, 2048);
		
		currentState = Entity.State.HOVERING;
	}
	
	private function hover():Void
	{
		if (timeElapsed > 4 && !chopperBlades.playing)
			chopperBlades.play();
		
		x_offset = (2 * Math.sin(timeElapsed)) * 15;  
		y_offset = (2 * (Math.sin(timeElapsed) * Math.cos(timeElapsed)) * 15); 
		setPosition(7200 + x_offset, 400 + y_offset);
	}
	
	override public function destroy():Void
	{
		chopperBlades = null;
		super.destroy();
	}
	
	override public function update():Void
	{
		if (currentState == Entity.State.HOVERING)
		{
			timeElapsed += FlxG.elapsed;
			hover();
		}
		
		z = 720;
		
		super.update();
	}
}