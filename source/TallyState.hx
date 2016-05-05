package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.util.FlxRandom;

class TallyState extends FlxState
{
	private var laborerTallySound:FlxSound;
	private var bankerTallySound:FlxSound;
	private var bimboTallySound:FlxSound;
	private var laborers:FlxGroup;
	private var bankers:FlxGroup;
	private var bimbos:FlxGroup;
	private var bimbo:FlxSprite;
	private var banker:FlxSprite;
	private var laborer:FlxSprite;	
	private var titleText:FlxText;
	private var innocentText:FlxText;
	private var noInnocentBonusText:FlxText;
	private var laborText:FlxText;
	private var noLaborerBonusText:FlxText;
	private var levelCompletedText:FlxText;
	private var totalBonusText:FlxText;
	private var laborerMultiplierText:FlxText;
	private var innocentMultiplierText:FlxText;
	private var elapsedTime:Float = 0;
	private var doneCountingLaborers:Bool = false;
	private var doneCountingBankers:Bool = false;
	private var doneCountingBimbos:Bool = false;
	private var doneCountingInnocents:Bool = false;
	private var laborTallyOK:Bool = false;
	private var innocentTallyOK:Bool = false;
	private var laborerDisplayCount:Int = 0;
	private var laborerCount:Int = 0;
	private var bankerCount:Int = 0;
	private var bankerDisplayCount:Int = 0;
	private var bimboCount:Int = 0;
	private var bimboDisplayCount:Int = 0;
	private var totalBonusPoints:Int = 0;
	private var delayTimer:Float = 0;
	private var scrollYOffset:Float = 0;
	private var textDelayTimer:FlxTimer;
	
	override public function create():Void
	{
		FlxG.camera.bgColor = 0xFF08105A;
		
		levelCompletedText = new FlxText(0, 0, FlxG.width, "CONGRATULATIONS");
		levelCompletedText.setFormat(Globals.TEXT_FONT, 96, 0xFFFFFFFF, "center", FlxText.BORDER_SHADOW, 0x404040);
		levelCompletedText.borderSize = 4;
		FlxTween.tween(levelCompletedText, { y:30 }, .2, { type: FlxTween.ONESHOT, ease: FlxEase.quadIn, complete: firstLineDone});
		levelCompletedText.setPosition((FlxG.width / 2) - (levelCompletedText.width / 2), -100);
		levelCompletedText.antialiasing = false;
		add(levelCompletedText);

		titleText = new FlxText(0, 0, FlxG.width, "EXCLUSION ZONE " + Std.string(Globals.currentZone) + " CLEARED");
		titleText.setFormat(Globals.TEXT_FONT, 72, 0xFFFFFFFF, "center", FlxText.BORDER_SHADOW, 0x404040);
		titleText.borderSize = 4;
		titleText.setPosition((FlxG.width / 2) - (titleText.width / 2), -100);
		titleText.antialiasing = false;
		add(titleText);
		
		laborText = new FlxText(0, 0, FlxG.width, "SLAVE LABOR BONUS:");
		laborText.setFormat(Globals.TEXT_FONT, 48, 0xFFFFFFFF, "center", FlxText.BORDER_SHADOW, 0x404040);
		laborText.borderSize = 4;
		laborText.setPosition((FlxG.width / 2) - (laborText.width / 2), 215);
		laborText.antialiasing = false;
		laborText.visible = false;
		add(laborText);
		
		laborerMultiplierText = new FlxText(0, 0, FlxG.width, "0 X 2500");
		laborerMultiplierText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFFFF);
		laborerMultiplierText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		laborerMultiplierText.setPosition(718, 295); 
		laborerMultiplierText.visible = false;
		laborerMultiplierText.antialiasing = false;
		add(laborerMultiplierText);
		
		noLaborerBonusText = new FlxText(0, 0, FlxG.width, "NO BONUS");
		noLaborerBonusText.setFormat(Globals.TEXT_FONT, 72, 0xFFFFFFFF, "center", FlxText.BORDER_SHADOW, 0x404040);
		noLaborerBonusText.borderSize = 4;
		noLaborerBonusText.setPosition((FlxG.width / 2) - (noLaborerBonusText.width / 2), 299);
		noLaborerBonusText.visible = false;
		noLaborerBonusText.antialiasing = false;
		add(noLaborerBonusText);
		
		innocentText = new FlxText(0, 0, FlxG.width, "SAVED INNOCENT BONUS:");
		innocentText.setFormat(Globals.TEXT_FONT, 48, 0xFFFFFFFF, "center", FlxText.BORDER_SHADOW, 0x404040);
		innocentText.borderSize = 4;
		innocentText.setPosition((FlxG.width / 2) - (innocentText.width / 2), 405);
		innocentText.antialiasing = false;
		innocentText.visible = false;
		add(innocentText);
		
		innocentMultiplierText = new FlxText(0, 0, FlxG.width, "0 X 5000");
		innocentMultiplierText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFFFF);
		innocentMultiplierText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		innocentMultiplierText.setPosition(718, 505);
		innocentMultiplierText.visible = false;
		innocentMultiplierText.antialiasing = false;
		add(innocentMultiplierText);
		
		noInnocentBonusText = new FlxText(0, 0, FlxG.width, "NO BONUS");
		noInnocentBonusText.setFormat(Globals.TEXT_FONT, 72, 0xFFFFFFFF, "center", FlxText.BORDER_SHADOW, 0x404040);
		noInnocentBonusText.borderSize = 4;
		noInnocentBonusText.setPosition((FlxG.width / 2) - (noInnocentBonusText.width / 2), 489);
		noInnocentBonusText.visible = false;
		noInnocentBonusText.antialiasing = false;
		add(noInnocentBonusText);
		
		totalBonusText = new FlxText(0, 0, FlxG.width, "TOTAL BONUS: " + Std.string(totalBonusPoints));
		totalBonusText.setFormat(Globals.TEXT_FONT, 72, 0xFFFFFFFF, "center", FlxText.BORDER_SHADOW, 0x404040);
		totalBonusText.borderSize = 4;
		totalBonusText.setPosition((FlxG.width / 2) - (totalBonusText.width / 2), 650);
		totalBonusText.antialiasing = false;
		totalBonusText.visible = false;
		add(totalBonusText);
		
		laborers = new FlxGroup();
		add(laborers);
		
		bankers = new FlxGroup();
		add(bankers);
		
		bimbos = new FlxGroup();
		add(bimbos);
		
		laborerTallySound = FlxG.sound.load("assets/sounds/Pickup.wav", 1);
		bankerTallySound = FlxG.sound.load("assets/sounds/CashIn.wav", 1);
		bimboTallySound = FlxG.sound.load("assets/sounds/Oooh.wav", 1);
		
		super.create();
	}
	
	private function firstLineDone(tween:FlxTween):Void 
	{
		FlxTween.tween(titleText, { y:120 }, .2, { type: FlxTween.ONESHOT, ease: FlxEase.quadIn, complete: secondLineDone } );
		FlxG.sound.play("Thud");
	}
	
	private function secondLineDone(tween:FlxTween):Void 
	{
		textDelayTimer = new FlxTimer(0.25, showThirdLine, 1);
		FlxG.sound.play("Thud");
	}
	
	private function showThirdLine(timer:FlxTimer):Void
	{
		textDelayTimer = new FlxTimer(0.5, showLaborTally, 1);
		laborText.visible = true;
		FlxG.sound.play("TallyText");
	}
	
	private function showLaborTally(timer:FlxTimer):Void
	{
		laborTallyOK = true;
	}
	
	private function showForthLine(timer:FlxTimer):Void
	{
		textDelayTimer = new FlxTimer(0.5, showInnocentTally, 1);
		innocentText.visible = true;
		FlxG.sound.play("TallyText");
	}
	
	private function showInnocentTally(timer:FlxTimer):Void
	{
		innocentTallyOK = true;
	}
	
	private function showNoBonusLine1(timer:FlxTimer):Void
	{
		noLaborerBonusText.visible = true;
		FlxG.sound.play("None");
		textDelayTimer = new FlxTimer(0.25, showForthLine, 1);
	}
	
	private function showNoBonusLine2(timer:FlxTimer):Void
	{
		noInnocentBonusText.visible = true;
		FlxG.sound.play("None");
		textDelayTimer = new FlxTimer(0.25, showTotalBonusLine, 1);
	}	
	
	private function showTotalBonusLine(timer:FlxTimer):Void
	{
		totalBonusText.visible = true;
		if (totalBonusPoints == 0)
		{
			FlxG.sound.play("Tilt");	
			FlxG.sound.play("Disappointed");	
		}
		else
		{
			FlxRandom.chanceRoll() ? (FlxG.sound.play("YeeHaa")) : (FlxG.sound.play("WoooHaaa"));
			FlxG.sound.play("TallyBonus");
		}
	}
	
	override public function update():Void
	{
		elapsedTime += FlxG.elapsed;
		
		ColorCycler.Update();
		
		titleText.color = ColorCycler.BlasterText;
		levelCompletedText.color = ColorCycler.WilliamsUltraFlash;
		
		if (laborerMultiplierText.visible)
		{
			laborerMultiplierText.color = ColorCycler.RedPulse;
			laborerMultiplierText.text = Std.string(laborerCount) + " X 500";
		}
		
		if (innocentMultiplierText.visible)
		{
			innocentMultiplierText.color = ColorCycler.RedPulse;
			innocentMultiplierText.text = Std.string(bankerCount + bimboCount) + " X 750";
		}
		
		if (totalBonusText.visible)
		{
			totalBonusText.color = ColorCycler.RGB;
			totalBonusText.text = "TOTAL BONUS: " + Std.string(totalBonusPoints);
			totalBonusText.setPosition((FlxG.width / 2) - (totalBonusText.width / 2), 650);
		}
		
		if (noLaborerBonusText.visible)
			noLaborerBonusText.color = ColorCycler.RedPulse;	
			
		if (noInnocentBonusText.visible)
			noInnocentBonusText.color = ColorCycler.RedPulse;	
		
		if (Globals.capturedLaborCount > 0)
		{
			if (laborTallyOK)
			{
				laborerMultiplierText.visible = true;
				
				if (laborerCount < Globals.capturedLaborCount && !doneCountingLaborers && elapsedTime > 0.07)
				{
					laborer = new FlxSprite(68 + (75 * laborerDisplayCount), 275);
					laborer.loadGraphic("assets/images/Laborer.png", true, 64, 106, false);
					laborer.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
					laborer.animation.play("walk", true, -1);
					laborers.add(laborer);
					laborerCount++;
					laborerDisplayCount++;
					totalBonusPoints += 500;
					updatePlayerScore(500);
					laborerTallySound.play(true);
					if (laborerCount % 8 == 0 && Globals.capturedLaborCount > 8 && laborerCount != Globals.capturedLaborCount)
					{
						laborerDisplayCount = 0;
						laborers.forEach(function(object:FlxBasic) { object.kill();	});
						laborers.clear();
					}
					elapsedTime = 0;
				}
				else if (laborerCount == Globals.capturedLaborCount && !doneCountingLaborers)
				{
					doneCountingLaborers = true;
					textDelayTimer = new FlxTimer(0.25, showForthLine, 1);
				}
			}
		}
		else
		{
			if (laborTallyOK && !doneCountingLaborers)
			{
				textDelayTimer = new FlxTimer(0.25, showNoBonusLine1, 1);
				doneCountingLaborers = true;
			}
		}
		
		if (Globals.savedBankerCount > 0 && doneCountingLaborers)
		{
			if (innocentTallyOK)
			{
				innocentMultiplierText.visible = true;
				
				if (bankerCount < Globals.savedBankerCount && !doneCountingBankers && elapsedTime > 0.07)
				{
					banker = new FlxSprite(58 + (125 * bankerDisplayCount), 450);
					banker.loadGraphic("assets/images/Banker.png", true, 112, 158, false);
					banker.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
					banker.animation.play("walk", true, -1);
					bankers.add(banker);
					bankerCount++;
					bankerDisplayCount++;
					totalBonusPoints += 750;
					updatePlayerScore(750);
					bankerTallySound.play(true);
					if (bankerCount % 5 == 0 && Globals.savedBankerCount > 5 && bankerCount != Globals.savedBankerCount)
					{
						bankerDisplayCount = 0;
						bankers.forEach(function(object:FlxBasic) { object.kill(); });
						bankers.clear();
					}
					elapsedTime = 0;
				}
				else if (bankerCount == Globals.savedBankerCount && !doneCountingBankers)
					doneCountingBankers = true;
			}
		}
		else if (doneCountingLaborers)
			doneCountingBankers = true;
		
		if (Globals.savedBimboCount > 0 && doneCountingBankers)
		{
			if (innocentTallyOK)
			{
				innocentMultiplierText.visible = true;
				
				if (bankers.length > 0)
					bankers.forEach(function(object:FlxBasic) { object.kill(); });
				
				if (bimboCount < Globals.savedBimboCount && !doneCountingBimbos && elapsedTime > 0.07)
				{
					bimbo = new FlxSprite(75 + (96 * bimboDisplayCount), 470);
					bimbo.loadGraphic("assets/images/Bimbo.png", true, 86, 150, false);
					bimbo.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
					bimbo.animation.play("walk", true, -1);
					bimbos.add(bimbo);
					bimboCount++;
					bimboDisplayCount++;
					totalBonusPoints += 750;
					updatePlayerScore(750);
					bimboTallySound.play(true);
					if (bimboCount % 6 == 0 && Globals.savedBimboCount > 6 && bimboCount != Globals.savedBimboCount)
					{
						bimboDisplayCount = 0;
						bimbos.forEach(function(object:FlxBasic) { object.kill(); });
						bimbos.clear();
					}
					elapsedTime = 0;
				}
				else if (bimboCount == Globals.savedBimboCount && !doneCountingBimbos)
					doneCountingBimbos = true;	
			}
		}
		else if (doneCountingBankers)
			doneCountingBimbos = true;	
		
		if (innocentTallyOK && Globals.savedBankerCount == 0 && Globals.savedBimboCount == 0 && !doneCountingInnocents)
		{
			textDelayTimer = new FlxTimer(0.25, showNoBonusLine2, 1);
			doneCountingInnocents = true;
		}
		else if (doneCountingBimbos && doneCountingBankers && !doneCountingInnocents)
		{
			doneCountingInnocents = true;
			textDelayTimer = new FlxTimer(0.25, showTotalBonusLine, 1);
		}
			
		if (doneCountingLaborers && doneCountingInnocents)
		{
			delayTimer += FlxG.elapsed;
			if (delayTimer > 4)
			{
				delayTimer = 0;
				FlxG.cameras.fade(0xFF000000, 1, false, onFinalFade);
			}
		}

		super.update();
	}
	
	private function onFinalFade():Void
	{
		Globals.currentWave++;	
		Globals.currentZone++;
		Globals.resetZoneCounts();
		FlxG.switchState(new NewsFlashState());
	}
	
	private function updatePlayerScore(value:Int):Void
	{
		Globals.playerScore += value;
		if (Globals.playerScore >= Globals.extraLifeThreshold)
		{
			FlxG.sound.play("ExtraLife");
			Globals.playerLives++;
			if (Globals.playerLives > 99)
				Globals.playerLives = 99;
			Globals.extraLifeThreshold += Globals.extraLifeInterval;
		}
	}
	
	override public function destroy():Void
	{
		laborers = null;
		bankers = null;
		bimbos = null;
		bimbo = null;
		banker = null;
		laborer = null;
		titleText = null;
		laborText = null;
		noLaborerBonusText = null;
		innocentText = null;
		noInnocentBonusText = null;
		levelCompletedText = null;
		totalBonusText = null;
		laborerMultiplierText = null;
		innocentMultiplierText = null;
		textDelayTimer.destroy();
		
		super.destroy();
	}
}