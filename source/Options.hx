package;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxSave;

class Options {
	//when adding new option place it here so it will load and save
	private static var saveList = [
		"masterVolume",
		"ghostTapping",
		"bgDimness",
		"framerate",
		"controls",
		"discordRPC",
		"customGf",
		"customGfPath",
		"customBf",
		"customBfPath",
		"customDad",
		"customDadPath"
	];

	// MAIN
	public static var masterVolume:Float = 1;
	public static var ghostTapping = true;
	public static var bgDimness:Float = 0.0;
	public static var framerate:Int = 145;
	public static var controls = "ASWD";
	public static var discordRPC:Bool = true;

	// SKINS
	public static var customGf = false;
	public static var customGfPath = "";
	public static var customBf = false;
	public static var customBfPath = "";
	public static var customDad = false;
	public static var customDadPath = "";

	public static function startupSaveScript() {
		optionsSave = new FlxSave();
		optionsSave.bind("options");
		saveAndLoadAll();
		#if debug
		trace("Options Data: " + optionsSave.data);
		#end
	}

	public static function exists(variable):Dynamic {
		if (get(variable) != null) {
			return true;
		}
		return false;
	}

	public static function get(variable):Dynamic {
		return Reflect.field(optionsSave.data, variable);
	}

	public static function set(variable, value) {
		Reflect.setField(optionsSave.data, variable, value);
	}

	public static function setAndSave(variable, value) {
		Reflect.setField(optionsSave.data, variable, value);
		saveFile();
	}

	/** Saves the save file */
	public static function saveFile() {
		optionsSave.flush();
	}

	public static function saveAndLoadAll() {
		for (i in 0...saveList.length) {
			if (!exists(saveList[i])) {
				set(saveList[i], Reflect.field(Options, saveList[i]));
			}
		}
		saveFile();
		loadAll();
	}

	/** Saves settings and saves them to the save file */
	public static function saveAll() {
		for (i in 0...saveList.length) {
			set(saveList[i], Reflect.field(Options, saveList[i]));
		}
		saveFile();
	}

	/** Loads settings from save file */
	public static function loadAll() {
		for (i in 0...saveList.length) {
			Reflect.setField(Options, saveList[i], get(saveList[i]));
		}
	}

	/** Applies shit from settings to the game like: controls, fps */
	public static function applyAll() {
		FlxG.updateFramerate = framerate;
		FlxG.drawFramerate = framerate;
		PlayerSettings.player1.controls.bindFromSettings(true);
	}

	public static var optionsSave:FlxSave;
}
