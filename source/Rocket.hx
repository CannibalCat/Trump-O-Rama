package;
 
import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Rocket extends Entity
{
	private static var SPEED:Float = 750;
	private var smokeEmitter:FlxEmitter;
 
	public function new() 
	{
		super();
		loadGraphic("assets/images/Rocket.png", true, 46, 12, false);
		animation.add("default", [0, 1, 2], 12, true);
		animation.play("default");
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		smokeEmitter = new FlxEmitter();
		
		if (facing == FlxObject.RIGHT)
			smokeEmitter.setXSpeed(-150, -100);
		else
			smokeEmitter.setXSpeed(100, 150);
			
		smokeEmitter.setYSpeed(-30, 30);
		smokeEmitter.setAlpha(1, 1, 0, 0);
		smokeEmitter.setColor(0xFFFFFFFF, 0xFF000000);
		smokeEmitter.setScale(0.5, 1, 2, 2.5);
		smokeEmitter.gravity = 0;
		smokeEmitter.setRotation(0, 0);
		
		for (i in 0...125)
		{
			var smokeParticle:FlxParticle = new FlxParticle();
			smokeParticle.loadGraphic("assets/images/SmokeParticle.png", false, 15, 15, false);
			smokeParticle.visible = false; 
			smokeEmitter.add(smokeParticle);
			smokeParticle.kill();
		}
    }
	
	override public function revive():Void
	{
		smokeEmitter.revive();
		Globals.globalGameState.add(smokeEmitter);
		smokeEmitter.start(false, 1, 0.01);
		super.revive();
	}
	
	override public function kill():Void
	{
		super.kill();
		smokeEmitter.kill();
	}

    override public function update():Void
    {
        if (facing == FlxObject.LEFT)
		{
			smokeEmitter.x = x + frameWidth;
            velocity.x = -SPEED;    
		}

		if (facing == FlxObject.RIGHT)
		{
			smokeEmitter.x = x;
            velocity.x = SPEED;    
		}
			
		smokeEmitter.y = y + 5;
		
		if (x > FlxG.camera.scroll.x + (FlxG.width * 1.5) || x + frameWidth + (FlxG.width * 1.5) < FlxG.camera.scroll.x)
			kill();
		
		super.update();
    }
}