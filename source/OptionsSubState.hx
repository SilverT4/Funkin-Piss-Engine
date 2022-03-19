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
		'Discord Rich Presence: ' + Options.discordRPC,
		'BF Skin',
		'GF Skin',
		'Dad Skin',
	];

	var selector:FlxSprite;
	var curSelected:Int = 0;
	var gameZoom = FlxG.camera.zoom;

	var inGame = false;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;
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

		// sets this state camera to camStatic
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	function updateMenu() {
		grpOptionsTexts.clear();
		for (i in 0...textMenuItems.length) {
			//not in Alphabet font for now because i dont want to fuck with it for 3 hours
			var optionText:FlxText = new FlxText(20, 20 + (i * 50), 0, textMenuItems[i], 32);
			optionText.scrollFactor.set();
			optionText.ID = i;
			optionText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
			grpOptionsTexts.add(optionText);
		}
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

		if (controls.RIGHT_P || controls.LEFT_P) {
			if (controls.LEFT_P) {
				if (textMenuItems[curSelected].startsWith("FPS Limit")) {
					if (Options.framerate > 5) {
						Options.framerate -= 5;
					}
					textMenuItems[curSelected] = "FPS Limit: " + Options.framerate;
				}
				else if (textMenuItems[curSelected].startsWith("Background Dimness")) {
					if (Options.bgDimness > 0.0)
						Options.bgDimness -= 0.05;
					textMenuItems[curSelected] = "Background Dimness: " + Std.string(Options.bgDimness);
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
			}
	
			if (controls.RIGHT_P) {
				if (textMenuItems[curSelected].startsWith("FPS Limit")) {
					if (Options.framerate < 240)
						Options.framerate += 5;
					textMenuItems[curSelected] = "FPS Limit: " + Options.framerate;
				}
				else if (textMenuItems[curSelected].startsWith("Background Dimness")) {
					if (Options.bgDimness < 1.0) Options.bgDimness += 0.05;
					textMenuItems[curSelected] = "Background Dimness: " + Std.string(Options.bgDimness);
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
			}

			if (textMenuItems[curSelected].startsWith("Ghost Tapping")) {
				Options.ghostTapping = !Options.ghostTapping;
				textMenuItems[curSelected] = "Ghost Tapping: " + Options.ghostTapping;
			}
			else if (textMenuItems[curSelected].startsWith("Discord Rich Presence: ")) {
				Options.discordRPC = !Options.discordRPC;
				textMenuItems[curSelected] = "Discord Rich Presence: " + Options.discordRPC;
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
