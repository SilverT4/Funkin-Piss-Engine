package;

import sys.FileSystem;
import multiplayer.Lobby;
import haxe.io.Path;
import lime.utils.Assets;
import yaml.Yaml;

class CoolUtil {
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function difficultyString():String {
		return difficultyArray[PlayState.storyDifficulty];
	}

	static inline var multiplier = 10000000;
	// The number of zeros in the following value
	// corresponds to the number of decimals rounding precision
	public static function roundFloat(value:Float):Float
		return Math.round(value * multiplier) / multiplier;

	public static function isStringInt(s:String) {
		var index = 0;
		if (s.startsWith("-")) {
			index = 1;
		}

		var splittedString = s.split("");
		switch (splittedString[index]) {
			case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0":
				return true;
		}
		return false;
	}

	public static function stringToOgType(s:String):Dynamic {
		//if is integer or float
		if (isStringInt(s)) {
			if (s.contains(".")) {
				return Std.parseFloat(s);
			} else {
				return Std.parseInt(s);
			}
		}
		//if is a bool
		if (s == "true")
			return true;
		if (s == "false")
			return false;

		//if it is null
		if (s == "null")
			return null;

		//else return the original string
		return s;
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
	
	public static function clearMPlayers() {
		Lobby.player1.clear();
		Lobby.player2.clear();
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

	public static function getSongs():Array<String> {
		var list = [];
		var assets_song_path = "assets/songs/";
		for (file in SysFile.readDirectory(assets_song_path)) {
			var path = haxe.io.Path.join([assets_song_path, file]);
			if (FileSystem.isDirectory(path)) {
				list.push(file);
			}
		}
		var pengine_song_path = "mods/songs/";
		for (file in SysFile.readDirectory(pengine_song_path)) {
			var path = haxe.io.Path.join([pengine_song_path, file]);
			if (FileSystem.isDirectory(path)) {
				list.push(file);
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
