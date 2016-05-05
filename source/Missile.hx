package;
 
import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Missile extends Entity
{
	private static var SPEED:Float = 750;
	private var smokeEmitter:FlxEmitter;
	private var flyByPlayed:Bool = false;
 
	public function new() 
	{
		super();
		loadGraphic("assets/images/Missile.png", true, 112, 22, false);
		animation.add("default", [0, 1], 8, true);
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
		
		for (i in 0...200)
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
		flyByPlayed = false;
		super.revive();
	}
	
	override public function kill():Void
	{
		super.kill();
		smokeEmitter.kill();
	}

    override public function update():Void
    {
		if (((facing == FlxObject.RIGHT && x > FlxG.camera.scroll.x) || 
			(facing == FlxObject.LEFT && x < FlxG.camera.scroll.x + FlxG.width)) && !flyByPlayed)
		{
			flyByPlayed = true;
			FlxG.sound.play("MissileFlyBy");
		}
		
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
			
		smokeEmitter.y = y + 10;
		
		if ((facing == FlxObject.RIGHT && x > FlxG.camera.scroll.x + (FlxG.width * 1.5)) || 
			(facing == FlxObject.LEFT && x + frameWidth + (FlxG.width * 1.5) < FlxG.camera.scroll.x))
			kill();
		
		super.update();
    }
}