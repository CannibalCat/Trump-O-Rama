package;
 
import flixel.FlxG;
import flixel.FlxObject;

class EnemyBullet extends Entity
{
    private static var speed:Float = 500;
 
    public function new()
	{
		super();
		if (Globals.currentWave == 25)
			loadGraphic("assets/images/TripleBurst.png", false, 38, 2, false);
		else 
			loadGraphic("assets/images/EnemyBullet.png", false, 38, 2, false);
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
    }

    override public function update():Void
    {
        if (facing == FlxObject.LEFT)
            velocity.x = -speed;    

		if (facing == FlxObject.RIGHT)
            velocity.x = speed;    
		
		if ((facing == FlxObject.RIGHT && x > FlxG.camera.scroll.x + FlxG.width) || 
			(facing == FlxObject.LEFT && x + frameWidth < FlxG.camera.scroll.x))
			kill();		
			
		super.update();
    }
}