package;
 
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxRandom;

class BackgroundDrone extends FlxSprite
{
	private var speed:Float;
 
	public function new() 
	{
		super();
		loadGraphic("assets/images/SmallDrone.png", true, 92, 24, false);
		animation.add("default", [0, 1], 4, true);
		animation.play("default");
		
		speed = FlxRandom.floatRanged(75, 100);
		
		setFacingFlip(FlxObject.LEFT, false, false); 
		setFacingFlip(FlxObject.RIGHT, true, false); 
    }
	
    override public function update():Void
    {
        if (facing == FlxObject.LEFT)
            velocity.x = -speed;    

		if (facing == FlxObject.RIGHT)
            velocity.x = speed;   
			
		if (x > FlxG.camera.bounds.width)
			x = 0 - frameWidth;
		
		if (x + frameWidth < 0)
			x = FlxG.camera.bounds.width;
		
		super.update();
    }
}