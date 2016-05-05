package;
 
import flixel.FlxG;
import flixel.FlxObject;

class MegaDrone extends Entity
{
	private static var SPEED:Float = 2000;
	private var flyByPlayed:Bool = false;
 
	public function new() 
	{
		super();
		loadGraphic("assets/images/MegaDrone.png", true, 370, 96, false);
		animation.add("default", [0, 1], 8, true);
		animation.play("default");
		
		setFacingFlip(FlxObject.LEFT, false, false); 
		setFacingFlip(FlxObject.RIGHT, true, false); 
    }
	
	override public function revive():Void
	{
		flyByPlayed = false;
		super.revive();
	}
	
    override public function update():Void
    {
		if (((facing == FlxObject.RIGHT && x > FlxG.camera.scroll.x) || 
			(facing == FlxObject.LEFT && x < FlxG.camera.scroll.x + FlxG.width)) && !flyByPlayed)
		{
			flyByPlayed = true;
			FlxG.sound.play("QuickWhoosh");
		}
		
        if (facing == FlxObject.LEFT)
            velocity.x = -SPEED;    

		if (facing == FlxObject.RIGHT)
            velocity.x = SPEED;    
			
		if ((facing == FlxObject.RIGHT && x > FlxG.camera.scroll.x + FlxG.width) || 
			(facing == FlxObject.LEFT && x + frameWidth < FlxG.camera.scroll.x))
			kill();
		
		super.update();
    }
}