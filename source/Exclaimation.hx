package ;

enum Phrase
{
	HELP_ME;
	SAVE_ME;
	HELP;
	OVER_HERE;
	OH_NO;
	THANK_YOU;
	GENERAL;
	SCREAM;
	MY_HERO;
	ALLAHU_AKBAR;
}

class Exclaimation extends Entity
{
	private var parentReference:Entity;
	private var y_offset:Float;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, phrase:Phrase, parentRef:Entity) 
	{
		super(X, Y, Z);
		
		parentReference = parentRef;
		
		var parentClassName = Type.getClassName(Type.getClass(parentReference));
		
		if (phrase == Phrase.ALLAHU_AKBAR)
			loadGraphic("assets/images/ClericExclaimation.png", true, 60, 34, false);
		else
			loadGraphic("assets/images/Exclaimations.png", true, 52, 34, false);
		
		switch phrase
		{
			case HELP:
				animation.add("default", [6, 6], 4, false);
				this.y_offset = 36;
				
			case HELP_ME:
				animation.add("default", [0, 1], 4, false);
				this.y_offset = 36;
				
			case SAVE_ME:
				animation.add("default", [4, 5], 3, false);
				this.y_offset = 36;
				
			case OVER_HERE:
				animation.add("default", [2, 3], 3, false);
				this.y_offset = 15;
				
			case OH_NO:
				animation.add("default", [8, 9], 3, false);
				this.y_offset = 36;
				
			case THANK_YOU:
				animation.add("default", [10, 11], 4, false);
				if (parentClassName == "Banker")
					this.y_offset = 15;	
				else 
					this.y_offset = 36;	
					
			case GENERAL:
				animation.add("default", [7, 7, 7, 7], 4, false);
				if (parentClassName == "Laborer")
					this.y_offset = 30;
				else if (parentClassName == "Bandito")
					this.y_offset = 15;
				else 
					this.y_offset = 36;
					
			case ALLAHU_AKBAR:
				animation.add("default", [0, 1], 2, false);
				this.y_offset = 36;			
					
			case SCREAM:
				animation.add("default", [14, 14, 14], 3, false);
				this.y_offset = 36;
				
			case MY_HERO:
				animation.add("default", [12, 13], 3, false);
				this.y_offset = 36;
		}
		
		animation.play("default", true);	
	}
	
	override public function update():Void
	{
		color = ColorCycler.RedPulse;
		
		x = (parentReference.x + (parentReference.frameWidth / 2)) - (frameWidth / 2);
		y = parentReference.y - y_offset;
		
		if (animation.finished)
			kill();
			
		super.update();
	}
}