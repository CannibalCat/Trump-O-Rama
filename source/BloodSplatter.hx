package ;

import flixel.FlxSprite;
import flixel.FlxObject;

enum SplatterType
{
	SPLASH;
	HORIZONTAL;
}

class BloodSplatter extends Entity
{
	private var parentReference:Entity;
	private var splatterType:SplatterType;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, parentRef:Entity, pattern:SplatterType) 
	{
		super(X, Y, Z);
		
		parentReference = parentRef;
		splatterType = pattern;
		
		loadGraphic("assets/images/BloodSplatter.png", true, 64, 48, false);
		
		switch splatterType
		{
			case SPLASH:
				animation.add("splatter", [7, 8, 9], 9, false);
				
			case HORIZONTAL:
				animation.add("splatter", [0, 1, 2, 3, 4, 5, 6], 14, false);
		}

		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		facing = parentReference.facing;
		
		setSplatterPosition();			
				
		animation.play("splatter");
	}
	
	override public function update():Void
    {
		setSplatterPosition();
		
		if (animation.finished)
			this.kill();
			
		super.update();
	}
	
	private function setSplatterPosition():Void
	{
		if (splatterType == SPLASH)
		{
			if (Type.getClassName(Type.getClass(parentReference)) == "Player")
				setPosition(parentReference.x + parentReference.offset.x - (frameWidth / 2), parentReference.y + parentReference.origin.y - (frameHeight / 2));
			else if (Type.getClassName(Type.getClass(parentReference)) == "Cleric" && parentReference.health <= 4)
				setPosition(parentReference.x + parentReference.origin.x - (frameWidth / 2), parentReference.y + (parentReference.height / 2) - (frameHeight / 2));
			else
				setPosition(parentReference.x + parentReference.origin.x - (frameWidth / 2), parentReference.y + parentReference.origin.y - (frameHeight / 2));
		}
		else if (splatterType == HORIZONTAL)
		{
			if (Type.getClassName(Type.getClass(parentReference)) == "Player")
			{
				if (parentReference.facing == FlxObject.RIGHT)
					setPosition(parentReference.x + 80, parentReference.y + parentReference.origin.y - (frameHeight / 2));
				else
					setPosition(parentReference.x - 30, parentReference.y + parentReference.origin.y - (frameHeight / 2));
			}
		}
		
		z = parentReference.z + 1;		
	}
}