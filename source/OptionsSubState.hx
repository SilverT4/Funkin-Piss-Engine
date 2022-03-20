package;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.FlxGame;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

class OptionsSubState extends FlxSubState {

	var options = [
		'Gameplay',
		'Preferences'
	];
	var optionsItems = new FlxTypedGroup<Alphabet>();
	var curSelected:Int = 0;
	var inGame:Bool;

	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public function new(?inGame = false) {
		super();

		this.inGame = inGame;

		if (inGame) {
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bg.alpha = 0.6;
			bg.scrollFactor.set();
			add(bg);
		}
		else {
			var bg = new Background(FlxColor.ORANGE);
			add(bg);
		}

		/*
		var testBg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.MAGENTA);
		testBg.scrollFactor.set();
		add(testBg);
		*/

		var curY = 0.0;
		var curIndex = -1;
		for (s in options) {
			curIndex++;
			var option = new Alphabet(0, 0, s, true);
			option.ID = curIndex;
			option.scrollFactor.set();
			option.screenCenter(XY);
			option.y += curY;
			curY += option.height;

			optionsItems.add(option);
		}
		for (item in optionsItems) {
			item.y -= curY / 2;
		}
		add(optionsItems);

		// sets this state camera to camStatic
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UP_P) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected -= 1;
		}

		if (controls.DOWN_P) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected += 1;
		}

		if (curSelected < 0)
			curSelected = optionsItems.length - 1;

		if (curSelected >= optionsItems.length)
			curSelected = 0;

		optionsItems.forEach(function(alphab:Alphabet) {
			alphab.alpha = 0.6;

			if (alphab.ID == curSelected) {
				alphab.alpha = 1;
			}
		});

		if (FlxG.keys.justPressed.ENTER) {
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			switch (options[curSelected]) {
				case '${options[0]}', "Gameplay":
					closeSubState();
					FlxG.state.openSubState(new OptionsGameplaySubState(inGame));
				case '${options[1]}', "Preferences":
					closeSubState();
					FlxG.state.openSubState(new OptionsPrefencesSubState(inGame));
			}
		}

		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MainMenuState.selectedSomethin = false;
			PlayState.openSettings = false;
			if (inGame) close();
			else FlxG.switchState(new MainMenuState());
		}
	}
}

class OptionsPrefencesSubState extends OptionSubState {
	public function new(inGame) {
		var items = [
			new OptionItem('FPS Limit: ' + Options.framerate),
			new OptionItem('Background Dimness: ' + Options.bgDimness),
			new OptionItem('Discord Rich Presence', true, Options.discordRPC, value -> Options.discordRPC = value),
			new OptionItem('BF Skin'),
			new OptionItem('GF Skin'),
			new OptionItem('Dad Skin')
		];
		super(items, inGame);
	}
	
	override public function update(elapsed) {
		super.update(elapsed);

		if (controls.RIGHT_P || controls.LEFT_P) {
			if (controls.LEFT_P) {
				if (itemList[curSelected].text.startsWith("FPS Limit")) {
					if (Options.framerate > 5)
						Options.framerate -= 5;
					setOptionText(curSelected, "FPS Limit: " + Options.framerate);
				}
				else if (itemList[curSelected].text.startsWith("Background Dimness")) {
					if (Options.bgDimness > 0.0)
						Options.bgDimness -= 0.05;
					setOptionText(curSelected, "Background Dimness: " + Options.bgDimness);
				}
			}
			if (controls.RIGHT_P) {
				if (itemList[curSelected].text.startsWith("FPS Limit")) {
					if (Options.framerate < 240)
						Options.framerate += 5;
					setOptionText(curSelected, "FPS Limit: " + Options.framerate);
				}
				else if (itemList[curSelected].text.startsWith("Background Dimness")) {
					if (Options.bgDimness < 1.0) Options.bgDimness += 0.05;
					setOptionText(curSelected, "Background Dimness: " + Options.bgDimness);
				}
			}
		}

		if (controls.ACCEPT) {
			switch (itemList[curSelected].text) {
				case "BF Skin":
					closeSubState();
					FlxG.state.openSubState(new OptionsCharacterSubState("bf", inGame));
				case "GF Skin":
					closeSubState();
					FlxG.state.openSubState(new OptionsCharacterSubState("gf", inGame));
				case "Dad Skin":
					closeSubState();
					FlxG.state.openSubState(new OptionsCharacterSubState("dad", inGame));	
			}
		}
	}
}

class OptionsGameplaySubState extends OptionSubState {
	public function new(inGame) {
		var items = [
			new OptionItem("Controls: " + Options.controls),
			new OptionItem("Ghost Tapping", true, Options.ghostTapping, value -> Options.ghostTapping = value)
		];
		super(items, inGame);
	}
	
	override public function update(elapsed) {
		super.update(elapsed);

		if (controls.RIGHT_P || controls.LEFT_P) {
			if (itemList[curSelected].text.startsWith("Controls: ")) {
				if (Options.controls == "ASWD") {
					Options.controls = "DFJK";
				}
				else {
					Options.controls = "ASWD";
				}
				setOptionText(curSelected, "Controls: " + Options.controls);
			}
		}
	}
}





class OptionSubState extends FlxSubState {
	private var itemList:Array<OptionItem>;

	public var items = new FlxTypedGroup<OptionItem>();
	public var checkboxes = new FlxTypedGroup<Checkbox>();

	public var curSelected:Int = 0;
	var inGame:Bool;

	private var controls(get, never):Controls;

	private inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public function new(itemList, inGame) {
		super();
		
		this.inGame = inGame;
		this.itemList = itemList;

		var bg = new Background(FlxColor.MAGENTA);
		if (inGame) bg.alpha = 0.8;
		add(bg);

		var curY = 0.0;
		var curIndex = -1;
		for (option in itemList) {
			curIndex++;
			option.ID = curIndex;
			option.y += curY;
			curY += option.height + 25;
			items.add(option);

			if (option.hasCheckBox) {
				option.checkbox.x = option.x + option.width + 10;
				option.checkbox.y = option.y;
				option.checkbox.ID = curIndex;
				checkboxes.add(option.checkbox);
			}
		}
		add(items);
		add(checkboxes);

		// sets this state camera to camStatic
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UP_P) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected -= 1;
		}

		if (controls.DOWN_P) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected += 1;
		}

		if (curSelected < 0)
			curSelected = items.length - 1;

		if (curSelected >= items.length)
			curSelected = 0;

		items.forEach(function(alphab:Alphabet) {
			alphab.alpha = 0.6;

			if (alphab.ID == curSelected) {
				alphab.alpha = 1;
			}
		});

		if (controls.ACCEPT) {
			for (checkbox in checkboxes) {
				if (checkbox.ID == curSelected) {
					checkOption(curSelected);
					break;
				}
			}
		}

		if (FlxG.keys.justPressed.ESCAPE) {
			Options.saveAll();
			Options.applyAll();
			closeSubState();
			FlxG.state.openSubState(new OptionsSubState(inGame));
		}
	}

	public function setOptionText(i:Int, s:String) {
		for (alphab in items) {
			if (alphab.ID == i) {
				alphab.setText(s);
				alphab.screenCenter(X);
				break;
			}
		}
	}

	public function checkOption(i:Int) {
		for (checkbox in checkboxes) {
			if (checkbox.ID == i) {
				checkbox.triggerChecked();
				break;
			}
		}
	}
}

class OptionItem extends Alphabet {
	public var checkbox:Checkbox;
	public var hasCheckBox:Bool;

	public function new(text, ?hasCheckBox = false, ?checkBoxValue = false, ?checkBoxCallback:(value:Bool) -> Void) {
		super(0, 0, text);

		this.hasCheckBox = hasCheckBox;
		scrollFactor.set();
		screenCenter(X);
		
		if (hasCheckBox) {
			checkbox = new Checkbox(x + width + 10, y, checkBoxValue);
			checkbox.hitCallback = checkBoxCallback;
			checkbox.scrollFactor.set();
		}
	}
}

class Checkbox extends AnimatedSprite {
	private var checked = false;

	public var hitCallback:(value:Bool) -> Void;

	public function new(X, Y, ?checked:Bool = false) {
		super(X, Y);

		this.checked = checked;

		frames = Paths.getSparrowAtlas('checkboxThingie');
		antialiasing = true;
		setGraphicSize(Std.int(frameWidth * 0.75));
        updateHitbox();

		animation.addByPrefix("unselected", "Check Box unselected", 24);
		animation.addByPrefix("selecting", "Check Box selecting animation", 24, false);
		animation.addByPrefix("selected", "Check Box Selected Static", 24);

		setOffset("unselected", 0, -25);
		setOffset("selecting", 19, 50);
		setOffset("selected", 10, 28);

		if (checked) playAnim("selected");
		else playAnim("unselected");

		animation.finishCallback = function(name:String) {
			if (name == "selecting")
				playAnim("selected");
		};
	}

	public function triggerChecked() {
		checked = !checked;
		hitCallback(checked);
		if (checked)
			playAnim("selecting");
		else
			playAnim("unselected");
	}
}

class Background extends FlxSprite {
	public function new(Color:FlxColor) {
		super(-80, 0);

		loadGraphic(Paths.image('menuDesat'));
		scrollFactor.x = 0;
		scrollFactor.y = 0.15;
		setGraphicSize(Std.int(width * 1.1));
		updateHitbox();
		screenCenter();
		antialiasing = true;
		color = Color;
	}
}