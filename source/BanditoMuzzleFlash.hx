package ;

import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;

class BanditoMuzzleFlash extends Entity
{
	private var parentReference:Bandito;
	private var firingPistol:Int;
	private var muzzleOffsets:Array<Array<Int>> = [[ 49, 55, 53, 49, 45, 49, 55, 53, 48, 44 ],	// Top Pistol
												   [ 66, 72, 70, 66, 62, 66, 72, 70, 65, 61 ]]; // Bottom Pistol	
												   
	private var muzzleOffset(get, never):Int;
	private function get_muzzleOffset():Int
	{
		var frameOffset:Int;
		
		if (parentReference.animation.curAnim != null && parentReference.animation.curAnim.name != "idle")
			frameOffset = muzzleOffsets[firingPistol][parentReference.animation.curAnim.curFrame];
		else
			frameOffset = muzzleOffsets[firingPistol][5];

		return frameOffset;
	}
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, parentRef:Bandito, firingPistol:Int) 
	{
		super(X, Y, Z);
		
		loadGraphic("assets/images/EnemyMuzzleFlash.png", true, 18, 10, false);
		animation.add("default", [0, 1, 2, 3], 32, false);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 

		parentReference = parentRef;
		this.firingPistol = firingPistol;
		
		facing = parentReference.facing;
		animation.play("default");	
		
		FlxSpriteUtil.fadeOut(this, 0.12);
	}

	override public function update():Void
    {
		if (facing == FlxObject.RIGHT)
		{
			if (firingPistol == 0)
			{
				x = parentReference.x + parentReference.frameWidth + 2;
				y = parentReference.y + muzzleOffset;
			}
			else
			{
				x = (parentReference.x + parentReference.frameWidth) - 2;
				y = parentReference.y + muzzleOffset;
			}
		}
		else 
		{
			if (firingPistol == 0)
			{
				x = parentReference.x - frameWidth - 4;
				y = parentReference.y + muzzleOffset;
			}
			else
			{
				x = parentReference.x - frameWidth - 2;
				y = parentReference.y + muzzleOffset;
			}
		}
		
		if (animation.finished)
			this.kill();

		super.update();
	}
}
