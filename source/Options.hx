package;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxSave;

class Options {
	// MAIN
	public static var masterVolume:Float = 1;
	public static var ghostTapping = true;
	public static var bgDimness:Float = 0.0;
	public static var framerate:Int = 145;

	// SKINS
	public static var customGf = false;
	public static var customGfPath = "";
	public static var customBf = false;
	public static var customBfPath = "";
	public static var customDad = false;
	public static var customDadPath = "";
	public static var controls = "ASWD";

	public static function startupSaveScript() {
		optionsSave = new FlxSave();
		optionsSave.bind("options");
		#if debug
		trace("Options Data: " + optionsSave.data);
		#end
		if (optionsSave.data == "{ }") {
			saveAll();
		}
		loadAll();
	}

	public static function saveAll() {
		optionsSave.data.masterVolume = masterVolume;
		optionsSave.data.ghostTapping = ghostTapping;
		optionsSave.data.bgDimness = bgDimness;
		optionsSave.data.framerate = framerate;

		optionsSave.data.customGf = customGf;
		optionsSave.data.customGfPath = customGfPath;
		optionsSave.data.customBf = customBf;
		optionsSave.data.customBfPath = customBfPath;
		optionsSave.data.customDad = customDad;
		optionsSave.data.customDadPath = customDadPath;
		optionsSave.data.controls = controls;

		optionsSave.flush();
	}

	public static function loadAll() {
		masterVolume = optionsSave.data.masterVolume;
		ghostTapping = optionsSave.data.ghostTapping;
		bgDimness = optionsSave.data.bgDimness;
		framerate = optionsSave.data.framerate;

		customGf = optionsSave.data.customGf;
		customGfPath = optionsSave.data.customGfPath;
		customBf = optionsSave.data.customBf;
		customBfPath = optionsSave.data.customBfPath;
		customDad = optionsSave.data.customDad;
		customDadPath = optionsSave.data.customDadPath;
		controls = optionsSave.data.controls;
	}

	public static function applyAll() {
		FlxG.updateFramerate = framerate;
		FlxG.drawFramerate = framerate;
		Options.framerate = framerate;
		Options.bgDimness = bgDimness;
		Options.ghostTapping = ghostTapping;
		PlayerSettings.player1.controls.bindFromSettings(true);
	}

	public static var optionsSave:FlxSave;
}
