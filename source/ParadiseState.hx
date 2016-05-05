package ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;

enum Step
{
	MOVE_TO_FIRST_BIMBO;
	MOVE_TO_SECOND_BIMBO;
	MOVE_TO_THIRD_BIMBO;
	MOVE_TO_CENTER;
	TRANSFORMATION;
	LAUNCH;
	NONE;
}

class ParadiseState extends FlxState
{
	private var virgin:Virgin;
	private var virgins:FlxTypedGroup<Virgin>;
	private var trumpReflection:FlxSprite;
	private var background:FlxSprite;
	private var floorChunks:FlxSprite;
	private var cloudLayer1:FlxBackdrop;
	private var cloudLayer2:FlxBackdrop;
	private var eventTimer:FlxTimer;
	private var chunkEmitter:FlxEmitter;
	private var currentStep:Step;
	private var dialog1Played:Bool = false;
	private var dialog2Played:Bool = false;
	private var dialog3Played:Bool = false;
	private var dialog4Played:Bool = false;

	public var trump:NakedTrump;
	public var hellHoleUpper:FlxSprite;
	public var hellHoleLower:Entity;
	public var trumpLaunch:Bool = false;
	public var displayList:FlxTypedGroup<Entity>;
	
	override public function create():Void
	{
		cloudLayer1 = new FlxBackdrop("assets/images/CloudLayer2.png", 0.3, 0, true, false); 
		cloudLayer1.setPosition(0, 0);
		add(cloudLayer1);
		
		cloudLayer2 = new FlxBackdrop("assets/images/CloudLayer4.png", 0.1, 0, true, false);
		cloudLayer2.setPosition(0, 256);
		add(cloudLayer2);
		
		background = new FlxSprite();
		background.loadGraphic("assets/images/Paradise.png", false, 1024, 768, false);
		background.setPosition(0, 0);
		background.scrollFactor.set(0, 0);
		add(background);
		
		displayList = new FlxTypedGroup<Entity>();
		
		hellHoleUpper = new FlxSprite();
		hellHoleUpper.loadGraphic("assets/images/HellHoleUpper.png", false, 554, 264, false);
		hellHoleUpper.setPosition(280, 504);
		hellHoleUpper.scrollFactor.set(0, 0);
		hellHoleUpper.visible = false;
		add(hellHoleUpper);
		
		hellHoleLower = new Entity(402, 665, 1000);
		hellHoleLower.loadGraphic("assets/images/HellHoleLower.png", false, 191, 103, false);
		hellHoleLower.scrollFactor.set(0, 0);
		hellHoleLower.visible = false;
		displayList.add(hellHoleLower);
		
		trump = new NakedTrump((FlxG.width / 2) - 51, 550, 550 + 136);
		trump.scrollFactor.set(0, 0);
		trump.changeState(Entity.State.IDLE);
		displayList.add(trump);
		
		virgins = new FlxTypedGroup<Virgin>();
		
		for (i in 0...6)
		{
			var x_pos:Int = 0;
			var y_pos:Int = 0;
			var direction:Int = 0;
			
			switch i
			{
				case 0:
					x_pos = 100;
					y_pos = 600;
					direction = FlxObject.RIGHT;
					
				case 1:
					x_pos = 200;
					y_pos = 530;
					direction = FlxObject.RIGHT;
					
				case 2:
					x_pos = 300;
					y_pos = 460;
					direction = FlxObject.RIGHT;
					
				case 3:
					x_pos = 900 - 86;
					y_pos = 600;
					direction = FlxObject.LEFT;
					
				case 4:
					x_pos = 800 - 86;
					y_pos = 530;
					direction = FlxObject.LEFT;
					
				case 5:
					x_pos = 700 - 86;
					y_pos = 460;
					direction = FlxObject.LEFT;
			}
			
			virgin = new Virgin(x_pos, y_pos, y_pos + 150, direction, this);
			virgin.changeState(Entity.State.IDLE);
			virgin.scrollFactor.set(0, 0);
			virgins.add(virgin);
			displayList.add(virgin);
		}
	
		FlxG.sound.volume = 1;
		FlxG.camera.bgColor = 0xFF6DC1D9;
		FlxG.cameras.fade(0xFFFFFFFF, 4, true, onFadeIn);
		FlxG.sound.playMusic(Globals.PARADISE_BGM, 0.75, false); 
		
		currentStep = Step.NONE;
		
		add(displayList);
	}
	
	override public function update():Void
	{
		ColorCycler.Update();
		FlxG.camera.scroll.add(-5, 0);
		displayList.sort(sortByZ);
	
		switch currentStep
		{
			case MOVE_TO_FIRST_BIMBO:
				if (trump.x < 600)
					trump.velocity.x = 125;
				else 
					trump.velocity.x = 0;
					
				if (trump.y > 595)
					trump.velocity.y = -125;
				else	
					trump.velocity.y = 0;			
					
				if (trump.velocity.x == 0 && trump.velocity.y == 0)
				{
					if (!dialog1Played)
					{
						dialog1Played = true;
						FlxG.sound.play("TrumpShallWe");
						trump.changeState(Entity.State.IDLE);
						eventTimer = new FlxTimer(2, function(Step) { changeStep(MOVE_TO_SECOND_BIMBO); }, 1);		
					}
				}
					
			case MOVE_TO_SECOND_BIMBO:
				if (trump.x > 300)
					trump.velocity.x = -125;
				else 
					trump.velocity.x = 0;
					
				if (trump.y > 595)
					trump.velocity.y = -125;
				else	
					trump.velocity.y = 0;			
					
				if (trump.velocity.x == 0 && trump.velocity.y == 0)
				{
					if (!dialog2Played)
					{
						dialog2Played = true;
						FlxG.sound.play("TrumpReady");
						trump.changeState(Entity.State.IDLE);
						eventTimer = new FlxTimer(2, function(Step) { changeStep(MOVE_TO_THIRD_BIMBO); }, 1);	
					}
				}
				
			case MOVE_TO_THIRD_BIMBO:
				if (trump.x < 510)
					trump.velocity.x = 125;
				else 
					trump.velocity.x = 0;
					
				if (trump.y > 465)
					trump.velocity.y = -125;
				else	
					trump.velocity.y = 0;			
					
				if (trump.velocity.x == 0 && trump.velocity.y == 0)
				{
					if (!dialog3Played)
					{
						dialog3Played = true;
						FlxG.sound.play("TrumpLike");
						trump.changeState(Entity.State.IDLE);
						eventTimer = new FlxTimer(2, function(Step) { changeStep(MOVE_TO_CENTER); }, 1);	
					}
				}
				
			case MOVE_TO_CENTER: 
				if (trump.x > (FlxG.width / 2) - 51)
					trump.velocity.x = -125;
				else 
					trump.velocity.x = 0;
					
				if (trump.y < 550)
					trump.velocity.y = 125;
				else	
					trump.velocity.y = 0;			
					
				if (trump.velocity.x == 0 && trump.velocity.y == 0)
				{
					if (!dialog4Played)
					{
						dialog4Played = true;
						FlxG.sound.play("TrumpDontLikeMe");
						trump.changeState(Entity.State.IDLE);
						eventTimer = new FlxTimer(2, triggerTransformation, 1);		
					}
				}
				
			case TRANSFORMATION:
				if (trumpLaunch)
					changeStep(LAUNCH);
				
			case LAUNCH:
				trump.animation.play("fall");
				FlxTween.tween(trump, { y:100 }, 2, { type: FlxTween.ONESHOT, ease: FlxEase.sineOut, complete: onLaunchComplete } );
				changeStep(NONE);
					
			case NONE:
		}
		
		super.update();
	}
	
	private function onLaunchComplete(tween:FlxTween):Void
	{
		FlxTween.tween(trump, { y:1000 }, 2, { type: FlxTween.ONESHOT, ease: FlxEase.sineIn, complete: onDescentComplete } );
	}
	
	private function onDescentComplete(tween:FlxTween):Void
	{
		FlxTween.tween(FlxG.sound, { volume:0 }, 2);
		FlxG.cameras.fade(0xFF000000, 2, false, onFadeOut);
	}
	
	private function triggerTransformation(timer:FlxTimer):Void
	{
		FlxG.sound.play("Transform");
		for (v in virgins)
		{
			v.changeState(Entity.State.TRANSFORMING);
			var spinner = new SpinnerEffect(v.x + 5, v.y + 15, v.z + 1);
			spinner.scrollFactor.set(0, 0);
			displayList.add(spinner);
		}		
		changeStep(TRANSFORMATION);
	}
	
	private function changeStep(newStep:Step):Void
	{
		if (newStep == Step.MOVE_TO_FIRST_BIMBO || 
			newStep == Step.MOVE_TO_SECOND_BIMBO ||
			newStep == Step.MOVE_TO_THIRD_BIMBO || 
			newStep == Step.MOVE_TO_CENTER)
			trump.changeState(Entity.State.FOLLOWING);

		currentStep = newStep;
	}
	
	private function onFadeIn():Void
	{
		FlxG.sound.play("TrumpStrange");
		eventTimer = new FlxTimer(2, function(Step) { changeStep(MOVE_TO_FIRST_BIMBO); }, 1);		
	}
	
	private inline function sortByZ(order:Int, o1:Entity, o2:Entity):Int
    {
        return FlxSort.byValues(order, o1.z, o2.z);
    }

	override public function destroy():Void
	{
		FlxG.sound.music.stop();
		trump = null;
		trumpReflection = null;
		virgin = null;
		virgins = null;
		hellHoleUpper = null;
		hellHoleLower = null;
		floorChunks = null;
		background = null;
		cloudLayer1 = null;
		cloudLayer2 = null;	
		displayList = null;
		chunkEmitter = null;
		if (eventTimer != null)
			eventTimer.destroy();
		
		super.destroy();
	}
	
	private function onFadeOut():Void 
	{
		FlxG.switchState(new HellDescentState());
	}
	
	public function blowChunks()
	{
		chunkEmitter = new FlxEmitter(0, 0, 12);
		chunkEmitter.x = 500;
		chunkEmitter.y = 550;
		
		for (i in 0...2)
		{
			for (j in 0...6) 
			{
				var particle:FlxParticle = new FlxParticle();
				particle.loadGraphic("assets/images/FloorChunks.png", true, 48, 48, false);
				particle.animation.add("none", [j], 1, false);
				particle.animation.play("none");
				particle.elasticity = 0.3;
				particle.angularVelocity = 1080;
				particle.visible = false;
				particle.scrollFactor.set(0, 0);
				chunkEmitter.add(particle);
			}
		}
		
		chunkEmitter.setXSpeed(-150, 150);
		chunkEmitter.setYSpeed(-400, -200);
		chunkEmitter.bounce = 0.4;
		chunkEmitter.gravity = 300;
		
		add(chunkEmitter);
		chunkEmitter.start(true, 3, 0, 0, 0);
	}
}