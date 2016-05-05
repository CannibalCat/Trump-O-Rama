package;
 
import flixel.FlxG;
import flixel.FlxObject;

class PlayerBullet extends Entity
{
	private static var SPEED:Float = 500;
 
	public function new() 
	{
		super();
		loadGraphic("assets/images/GunBullet.png", false, 38, 4, false);
    }
 
    override public function update():Void
    {
		color = ColorCycler.WilliamsUltraFlash;
			
        if (facing == FlxObject.LEFT)
            velocity.x = -SPEED;    

		if (facing == FlxObject.RIGHT)
            velocity.x = SPEED;    
		
		if (x > FlxG.camera.scroll.x + FlxG.width || x + frameWidth < FlxG.camera.scroll.x)
			kill();
		
		super.update();
    }
}