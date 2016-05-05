package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.system.FlxSound;

class NiqabiDemon extends Entity
{
	private static var RUN_SPEED:Float = 175;
	private static var blastRange:Int = 50;	
	private var parentState:ParadiseState;
	private var fuseCounter:Float = 0;
	private var warCry:FlxSound;
	private var reflection:FlxSprite;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, Direction:Int=FlxObject.RIGHT, parentState:ParadiseState) 
	{
		super(X, Y, Z);
		
		this.parentState = parentState;
		
        loadGraphic("assets/images/Convert.png", true, 86, 146, false);
		animation.add("idle", [15], 1, true);
		animation.add("attack", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 20, true);
		animation.add("exploding", [20, 21], 15, true);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		warCry = FlxG.sound.load("assets/sounds/NiqabiWarCry.wav", 1);
		
		velocity.x = 0;
		velocity.y = 0;
		
		reflection = new FlxSprite();
		reflection.loadGraphic("assets/images/ConvertReflection.png", true, 86, 146, false);
		reflection.animation.add("idle", [15], 1, true);
		reflection.animation.add("attack", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 20, true);
		reflection.animation.add("exploding", [0, 1], 15, true);
		reflection.setFacingFlip(FlxObject.LEFT, true, false); 
		reflection.setFacingFlip(FlxObject.RIGHT, false, false); 
		reflection.alpha = 0.3;
		reflection.scrollFactor.set(0, 0);
		reflection.animation.play("idle");
		
		currentState = Entity.State.IDLE;
		
		target = null;
		facing = Direction;
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.EXPLODING)
			FlxG.sound.play("EvilLaugh");
		else if (newState == Entity.State.CHASING)
		{
			warCry.play();
			animation.play("attack", true, -1);
			reflection.animation.play("attack", true, -1);
		}
	
		super.changeState(newState);
	}
	
	override public function draw():Void
	{
		reflection.draw();
		super.draw();
	}
	
    override public function update():Void
	{
		reflection.x = x;
		reflection.y = z;
		reflection.facing = facing;
		reflection.update();
		
		if (currentState == Entity.State.CHASING)
		{
			if (x < parentState.trump.x)
				velocity.x = RUN_SPEED;
			else if (x > parentState.trump.x)
				velocity.x = -RUN_SPEED;	
			else
				velocity.x = 0;
				
			if (z < parentState.trump.z)
				velocity.y = RUN_SPEED;
			else if (z > parentState.trump.z)
				velocity.y = -RUN_SPEED;
			else 
				velocity.y = 0;
				
			if (velocity.x > 0)
				facing = FlxObject.RIGHT;
			else if (velocity.x < 0)
				facing = FlxObject.LEFT;
			
			if (FlxMath.distanceBetween(this, parentState.trump) < blastRange) 
				changeState(Entity.State.EXPLODING);
		}
		else if (currentState == Entity.State.EXPLODING)
		{
			velocity.x = 0;
			velocity.y = 0;
			
			fuseCounter += FlxG.elapsed;
			if (fuseCounter > 2)
			{
				explode();
				parentState.trumpLaunch = true;
				parentState.hellHoleUpper.visible = true;
				parentState.hellHoleLower.visible = true;
				parentState.blowChunks();
				FlxG.sound.play("Explosion" + FlxRandom.intRanged(1, 4));
				FlxG.sound.play("FemaleDie");
				kill();
			}
			
			animation.play("exploding");
		}
		else if (currentState == Entity.State.IDLE)
		{
			velocity.x = 0;
			velocity.y = 0;
			animation.play("idle");
			reflection.animation.play("idle");
		}
		
		z = y + frameHeight;
		
		super.update();
	}
	
	private function explode():Void
	{
		var center:FlxPoint = getGraphicMidpoint();
		var explosionFlash = new ExplosionFlash(center.x - 151, z - 220, z - 1);
		explosionFlash.scrollFactor.set(0, 0);
		parentState.displayList.add(explosionFlash);
		var explosion = new Explosion(center.x - 64, center.y - 64, z + 1, Explosion.ExplosionType.FIRE);
		explosion.scrollFactor.set(0, 0);
		parentState.displayList.add(explosion);
		FlxG.camera.flash(0xFFFFFFFF, 1);
		FlxG.camera.shake(0.01, 0.5);
		
		FlxG.sound.play("Explosion" + FlxRandom.intRanged(1, 4));
	}
	
	override public function kill():Void
	{
		if (warCry.playing)
			warCry.stop();
		FlxG.sound.play("FemaleDie");
		super.kill();
	}
}