package ;

import flixel.FlxG;
import flixel.util.FlxPoint;

class Shrapnel extends Entity
{
	public function new() 
	{
		super();
		
		loadGraphic("assets/images/Shrapnel.png", true, 20, 20, false);
		animation.add("explode", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);	
		animation.play("explode");
	}
	
	override public function update():Void
	{
		if (x > FlxG.camera.scroll.x + FlxG.width || x + frameWidth < FlxG.camera.scroll.x ||
			y > FlxG.height || y < FlxG.camera.scroll.y)
			kill();
			
		super.update();
	}
}