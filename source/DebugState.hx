package ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class DebugState extends FlxState
{
	private var titleText:FlxText;
	private var levelSelectText:FlxText;
	private var levelSelectValueText:FlxText;
	private var godModeText:FlxText;
	private var godModeValueText:FlxText;
	private var rocketsText:FlxText;
	private var rocketsValueText:FlxText;
	private var palinText:FlxText;
	private var palinValueText:FlxText;
	private var maxApprovalText:FlxText;
	private var maxApprovalValueText:FlxText;	
	private var gameVersionText:FlxText;
	private var instructionText1:FlxText;
	private var instructionText2:FlxText;
	private var instructionText3:FlxText;
	private var selectedTextLine:Int = 1;
	private var levelNumber:Int = 1;
	private var playerGodMode:Bool = false;
	private var unlimitedRockets:Bool = false;
	private var palinActive:Bool = false;
	private var maxApproval:Bool = false;
	
	override public function create():Void
	{
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			FlxG.sound.music.stop();
			
		titleText = new FlxText(0, 0, FlxG.width, "SECRET DEBUG MENU");
		titleText.setFormat(Globals.TEXT_FONT, 72, 0xFFFFFFFF, "center");
		titleText.setPosition((FlxG.width / 2) - (titleText.width / 2), 60);
		titleText.antialiasing = false;
		add(titleText);
		
		levelSelectText = new FlxText(100, 200, 0, "LEVEL SELECT");
		levelSelectText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFFFF);
		levelSelectText.antialiasing = false;
		add(levelSelectText);
	
		levelSelectValueText = new FlxText(790, 200, 0, "");
		levelSelectValueText.setFormat(Globals.TEXT_FONT, 60, 0xFFFF0000);
		levelSelectValueText.antialiasing = false;
		add(levelSelectValueText);
		
		godModeText = new FlxText(100, 250, 0, "PLAYER INVINCIBLE");
		godModeText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFFFF);
		godModeText.antialiasing = false;
		add(godModeText);
		
		godModeValueText = new FlxText(790, 250, 0, "");
		godModeValueText.setFormat(Globals.TEXT_FONT, 60, 0xFFFF0000);
		godModeValueText.antialiasing = false;
		add(godModeValueText);
		
		rocketsText = new FlxText(100, 300, 0, "INFINITE ROCKETS");
		rocketsText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFFFF);
		rocketsText.antialiasing = false;
		add(rocketsText);
		
		rocketsValueText = new FlxText(790, 300, 0, "");
		rocketsValueText.setFormat(Globals.TEXT_FONT, 60, 0xFFFF0000);
		rocketsValueText.antialiasing = false;
		add(rocketsValueText);	
		
		palinText = new FlxText(100, 350, 0, "PALIN ALWAYS ACTIVE");
		palinText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFFFF);
		palinText.antialiasing = false;
		add(palinText);
		
		palinValueText = new FlxText(790, 350, 0, "");
		palinValueText.setFormat(Globals.TEXT_FONT, 60, 0xFFFF0000);
		palinValueText.antialiasing = false;
		add(palinValueText);	
		
		maxApprovalText = new FlxText(100, 400, 0, "MAX APPROVAL RATING");
		maxApprovalText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFFFF);
		maxApprovalText.antialiasing = false;
		add(maxApprovalText);
		
		maxApprovalValueText = new FlxText(790, 400, 0, "");
		maxApprovalValueText.setFormat(Globals.TEXT_FONT, 60, 0xFFFF0000);
		maxApprovalValueText.antialiasing = false;
		add(maxApprovalValueText);	
		
		instructionText1 = new FlxText(0, 0, FlxG.width, "[UP ARROW]/[DOWN ARROW] TO CHOOSE OPTION");
		instructionText1.setFormat(Globals.TEXT_FONT, 36, 0xFF00FF00, "center");
		instructionText1.setPosition((FlxG.width / 2) - (instructionText1.width / 2), 530);
		instructionText1.antialiasing = false;
		add(instructionText1);
		
		instructionText2 = new FlxText(0, 0, FlxG.width, "[LEFT ARROW]/[RIGHT ARROW] TO CHANGE VALUES");
		instructionText2.setFormat(Globals.TEXT_FONT, 36, 0xFF00FF00, "center");
		instructionText2.setPosition((FlxG.width / 2) - (instructionText2.width / 2), 560);
		instructionText2.antialiasing = false;
		add(instructionText2);
		
		instructionText3 = new FlxText(0, 0, FlxG.width, "[ENTER] TO ACCEPT AND START GAME");
		instructionText3.setFormat(Globals.TEXT_FONT, 36, 0xFF00FF00, "center");
		instructionText3.setPosition((FlxG.width / 2) - (instructionText3.width / 2), 590);
		instructionText3.antialiasing = false;
		add(instructionText3);
		
		gameVersionText = new FlxText(0, 0, FlxG.width, "VERSION: " + Globals.GAME_VERSION);
		gameVersionText.setFormat(Globals.TEXT_FONT, 36, 0xFFFFFFFF, "center");
		gameVersionText.setPosition((FlxG.width / 2) - (gameVersionText.width / 2), 675);
		gameVersionText.antialiasing = false;
		add(gameVersionText);
		
		super.create();
	}
	
	override public function update():Void
	{
		ColorCycler.Update();
		titleText.color = ColorCycler.WilliamsFlash1;
		
		if (selectedTextLine == 1)
		{
			levelSelectText.color = ColorCycler.WilliamsUltraFlash;
			levelSelectValueText.color = ColorCycler.WilliamsUltraFlash;
		}
		else
		{
			levelSelectText.color = 0xFFFFFFFF;
			levelSelectValueText.color = 0xFFFF0000;		
		}
		
		if (selectedTextLine == 2)
		{
			godModeText.color = ColorCycler.WilliamsUltraFlash;
			godModeValueText.color = ColorCycler.WilliamsUltraFlash;
		}
		else
		{
			godModeText.color = 0xFFFFFFFF;
			godModeValueText.color = 0xFFFF0000;	
		}
		
		if (selectedTextLine == 3)
		{
			rocketsText.color = ColorCycler.WilliamsUltraFlash;
			rocketsValueText.color = ColorCycler.WilliamsUltraFlash;
		}
		else
		{
			rocketsText.color = 0xFFFFFFFF;
			rocketsValueText.color = 0xFFFF0000;	
		}
		
		if (selectedTextLine == 4)
		{
			palinText.color = ColorCycler.WilliamsUltraFlash;
			palinValueText.color = ColorCycler.WilliamsUltraFlash;
		}
		else
		{
			palinText.color = 0xFFFFFFFF;
			palinValueText.color = 0xFFFF0000;	
		}
		
		if (selectedTextLine == 5)
		{
			maxApprovalText.color = ColorCycler.WilliamsUltraFlash;
			maxApprovalValueText.color = ColorCycler.WilliamsUltraFlash;
		}
		else
		{
			maxApprovalText.color = 0xFFFFFFFF;
			maxApprovalValueText.color = 0xFFFF0000;	
		}
		
		levelSelectValueText.text = Std.string(levelNumber);
		godModeValueText.text = playerGodMode ? "TRUE" : "FALSE";
		rocketsValueText.text = unlimitedRockets ? "TRUE" : "FALSE";
		palinValueText.text = palinActive ? "TRUE" : "FALSE";
		maxApprovalValueText.text = maxApproval ? "TRUE" : "FALSE";
		
		if (FlxG.keys.justPressed.ENTER)
		{
			Globals.playerGodMode = playerGodMode;
			Globals.unlimitedRockets = unlimitedRockets;
			Globals.palinAlwaysActive = palinActive;
			Globals.maxApproval = maxApproval;
			Globals.resetGameGlobals();
			Globals.currentWave = levelNumber;
			
			if (levelNumber != 25)
			{
				if (levelNumber >= 1 && levelNumber <= 4)
					Globals.currentZone = 1;
				else if (levelNumber >= 5 && levelNumber <= 8)
					Globals.currentZone = 2;
				else if (levelNumber >= 9 && levelNumber <= 12)
					Globals.currentZone = 3;
				else if (levelNumber >= 13 && levelNumber <= 16)
					Globals.currentZone = 4;
				else if (levelNumber >= 17 && levelNumber <= 20)
					Globals.currentZone = 5;
				else if (levelNumber >= 21 && levelNumber <= 24)
					Globals.currentZone = 6;
			}
			else 
				Globals.currentZone = 0;
				
			FlxG.switchState(new PlayState());
		}
		
		if (FlxG.keys.justPressed.UP)
		{
			FlxG.sound.play("Click");
			selectedTextLine--;
			if (selectedTextLine < 1)
				selectedTextLine = 5;
		}
		
		if (FlxG.keys.justPressed.DOWN)
		{
			FlxG.sound.play("Click");
			selectedTextLine++;
			if (selectedTextLine > 5)
				selectedTextLine = 1;
		}
		
		if (FlxG.keys.justPressed.LEFT)
		{
			FlxG.sound.play("Thud");
			if (selectedTextLine == 1)
			{
				levelNumber--;
				if (levelNumber < 1)
					levelNumber = 25;
			}
			else if (selectedTextLine == 2)
				playerGodMode = !playerGodMode;			
			else if (selectedTextLine == 3)
				unlimitedRockets = !unlimitedRockets;
			else if (selectedTextLine == 4)
				palinActive = !palinActive;	
			else if (selectedTextLine == 5)
				maxApproval = !maxApproval;	
		}
		
		if (FlxG.keys.justPressed.RIGHT)
		{
			FlxG.sound.play("Thud");
			if (selectedTextLine == 1)
			{
				levelNumber++;
				if (levelNumber > 25)
					levelNumber = 1;
			}
			else if (selectedTextLine == 2)
				playerGodMode = !playerGodMode;
			else if (selectedTextLine == 3)
				unlimitedRockets = !unlimitedRockets;
			else if (selectedTextLine == 4)
				palinActive = !palinActive;	
			else if (selectedTextLine == 5)
				maxApproval = !maxApproval;	
		}

		super.update();
	}
	
	override public function destroy():Void
	{
		titleText = null;
		levelSelectText = null;
		levelSelectValueText = null;
		godModeText = null;
		godModeValueText = null;
		rocketsText = null;
		rocketsValueText = null;
		palinText = null;
		palinValueText = null;
		maxApprovalText = null;
		maxApprovalValueText = null;
		gameVersionText = null;
		instructionText1 = null;
		instructionText2 = null;
		instructionText3 = null;
		
		super.destroy();
	}
}