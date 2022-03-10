package;

import yaml.util.ObjectMap.AnyObjectMap;
import haxe.io.Path;
import lime.utils.Assets;
import yaml.Yaml;

using StringTools;

class CoolUtil {
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function difficultyString():String {
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function strToBool(s:String):Dynamic {
		switch (s.toLowerCase()) {
			case "true":
				return true;
			case "false":
				return false;
			default:
				return null;
		}
	}

	public static function toBool(d):Dynamic {
		var s = Std.string(d);
		switch (s.toLowerCase()) {
			case "true":
				return true;
			case "false":
				return false;
			default:
				return null;
		}
	}

	public static function coolTextFile(path:String, ?modsFolder = false):Array<String> {
		var daList;
		if (modsFolder) {
			daList = SysFile.getContent(path).trim().split('\n');
		}
		else {
			daList = Assets.getText(path).trim().split('\n');
		}

		for (i in 0...daList.length) {
			daList[i] = daList[i].trim();
			daList[i] = daList[i].replace('\\n', '\n');
		}

		return daList;
	}

	public static function readYAML(path:String) {
		#if sys
		return Yaml.read(path);
		#else
		return null;
		#end
	}

	public static function getStages():Array<String> {
		var stages = Stage.stagesList;
		var mods_characters_path = "mods/stages/";
		for (stage in SysFile.readDirectory(mods_characters_path)) {
			var path = Path.join([mods_characters_path, stage]);
			if (SysFile.isDirectory(path)) {
				stages.push(stage);
			}
		}
		return stages;
	}

	public static function getCharacters():Array<String> {
		var list = CoolUtil.coolTextFile(Paths.txt('characterList'));
		var mods_characters_path = "mods/characters/";
		for (char in SysFile.readDirectory(mods_characters_path)) {
			var path = Path.join([mods_characters_path, char]);
			if (SysFile.isDirectory(path)) {
				list.push(char);
			}
		}
		return list;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int> {
		var dumbArray:Array<Int> = [];
		for (i in min...max) {
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function isEmpty(d:Dynamic):Bool {
		if (d == "" || d == 0 || d == null || d == "0" || d == "null" || d == "empty" || d == "none") {
			return true;
		}
		return false;
	}
}
