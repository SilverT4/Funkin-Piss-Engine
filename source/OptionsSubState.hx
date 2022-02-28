package;

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
	var textMenuItems:Array<String> = [
		'Controls: ' + Options.controls,
		'Ghost Tapping: ' + Options.ghostTapping,
		'FPS Limit: ' + Options.framerate,
		'Background Dimness: ' + Options.bgDimness,
		'BF Skin',
		'GF Skin',
		'Dad Skin'
	];

	var selector:FlxSprite;
	var curSelected:Int = 0;
	var gameZoom = FlxG.camera.zoom;

	var inGame = false;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	public function new(inGame) {
		super();

		this.inGame = inGame;
		// FlxG.cameras.add(optionsCamera);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.5;
		bg.scrollFactor.set();

		grpOptionsTexts = new FlxTypedGroup<FlxText>();

		selector = new FlxSprite().makeGraphic(5, 5, FlxColor.TRANSPARENT);
		selector.scrollFactor.set();

		var applyInfo:FlxText = new FlxText(0, FlxG.height - 45, "PRESS ENTER TO APPLY", 32);
		applyInfo.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		applyInfo.scrollFactor.set();
		applyInfo.screenCenter(X);

		add(bg);
		add(grpOptionsTexts);
		add(selector);
		add(applyInfo);

		updateMenu();

		// set this state camera to camStatic
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	function updateMenu() {
		grpOptionsTexts.clear();
		for (i in 0...textMenuItems.length) {
			var optionText:FlxText = new FlxText(20, 20 + (i * 50), 0, textMenuItems[i], 32);
			optionText.scrollFactor.set();
			optionText.ID = i;
			optionText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
			grpOptionsTexts.add(optionText);
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.UP) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected -= 1;
		}

		if (FlxG.keys.justPressed.DOWN) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected += 1;
		}

		if (FlxG.keys.justPressed.LEFT) {
			if (textMenuItems[curSelected].startsWith("FPS Limit")) {
				if (Options.framerate > 5) {
					Options.framerate -= 5;
				}
				textMenuItems[curSelected] = "FPS Limit: " + Options.framerate;
			}
			else if (textMenuItems[curSelected].startsWith("Background Dimness")) {
				switch (Options.bgDimness) {
					case 0.1:
						Options.bgDimness = 0.0;
					case 0.2:
						Options.bgDimness = 0.1;
					case 0.3:
						Options.bgDimness = 0.2;
					case 0.4:
						Options.bgDimness = 0.3;
					case 0.5:
						Options.bgDimness = 0.4;
					case 0.6:
						Options.bgDimness = 0.5;
					case 0.7:
						Options.bgDimness = 0.6;
					case 0.8:
						Options.bgDimness = 0.7;
					case 0.9:
						Options.bgDimness = 0.8;
					case 1.0:
						Options.bgDimness = 0.9;
				}
				textMenuItems[curSelected] = "Background Dimness: " + Options.bgDimness;
			}
			else if (textMenuItems[curSelected].startsWith("Ghost Tapping")) {
				if (Options.ghostTapping == true) {
					Options.ghostTapping = false;
				}
				else {
					Options.ghostTapping = true;
				}
				textMenuItems[curSelected] = "Ghost Tapping: " + Options.ghostTapping;
			}

			else if (textMenuItems[curSelected].startsWith("Controls: ")) {
				if (Options.controls == "ASWD") {
					Options.controls = "DFJK";
				}
				else {
					Options.controls = "ASWD";
				}
				textMenuItems[curSelected] = "Controls: " + Options.controls;
			}
			Options.saveAll();
			updateMenu();
		}

		if (FlxG.keys.justPressed.RIGHT) {
			if (textMenuItems[curSelected].startsWith("FPS Limit")) {
				Options.framerate += 5;
				textMenuItems[curSelected] = "FPS Limit: " + Options.framerate;
			}
			else if (textMenuItems[curSelected].startsWith("Background Dimness")) {
				switch (Options.bgDimness) {
					case 0.0:
						Options.bgDimness = 0.1;
					case 0.1:
						Options.bgDimness = 0.2;
					case 0.2:
						Options.bgDimness = 0.3;
					case 0.3:
						Options.bgDimness = 0.4;
					case 0.4:
						Options.bgDimness = 0.5;
					case 0.5:
						Options.bgDimness = 0.6;
					case 0.6:
						Options.bgDimness = 0.7;
					case 0.7:
						Options.bgDimness = 0.8;
					case 0.8:
						Options.bgDimness = 0.9;
					case 0.9:
						Options.bgDimness = 1.0;
				}
				textMenuItems[curSelected] = "Background Dimness: " + Options.bgDimness;
			}
			else if (textMenuItems[curSelected].startsWith("Ghost Tapping")) {
				if (Options.ghostTapping == true) {
					Options.ghostTapping = false;
				}
				else {
					Options.ghostTapping = true;
				}
				textMenuItems[curSelected] = "Ghost Tapping: " + Options.ghostTapping;
			}
			
			else if (textMenuItems[curSelected].startsWith("Controls: ")) {
				if (Options.controls == "ASWD") {
					Options.controls = "DFJK";
				}
				else {
					Options.controls = "ASWD";
				}
				textMenuItems[curSelected] = "Controls: " + Options.controls;
			}
			Options.saveAll();
			updateMenu();
		}
		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MainMenuState.selectedSomethin = false;
			FlxG.camera.zoom = gameZoom;
			PlayState.openSettings = false;
			close();
		}

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;

		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		grpOptionsTexts.forEach(function(txt:FlxText) {
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected) {
				txt.color = FlxColor.YELLOW;
			}
		});

		if (FlxG.keys.justPressed.ENTER) {
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			Options.applyAll();
			switch (textMenuItems[curSelected]) {
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
