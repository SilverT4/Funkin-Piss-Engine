package;

import flixel.input.FlxInput.FlxInputState;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;

enum KeyType {
	UP;
	LEFT;
	RIGHT;
	DOWN;
	UI_UP;
	UI_LEFT;
	UI_RIGHT;
	UI_DOWN;

	ACCEPT;
	BACK;
	PAUSE;
}

class Key {
	public static var UP = [W, FlxKey.UP];
	public static var LEFT = [A, FlxKey.LEFT];
	public static var RIGHT = [D, FlxKey.RIGHT];
	public static var DOWN = [S, FlxKey.DOWN];
	public static var UI_UP = [W, FlxKey.UP];
	public static var UI_LEFT = [A, FlxKey.LEFT];
	public static var UI_RIGHT = [D, FlxKey.RIGHT];
	public static var UI_DOWN = [S, FlxKey.DOWN];

	public static var ACCEPT = [ENTER];
	public static var BACK = [ESCAPE];
	public static var PAUSE = [ENTER, ESCAPE];

	public static function fromType(keyType:KeyType):Array<FlxKey> {
		return Reflect.field(Key, Std.string(keyType));
	}
}

class Controls {
	public static function bind(keyType:KeyType, newKey:FlxKey, ?arrayIndex:Int = 0) {
		var shit = Key.fromType(keyType);
		shit[arrayIndex] = newKey;
		Reflect.setField(Key, Std.string(keyType), shit);
    }

    public static function check(keyType:KeyType, ?action:FlxInputState = JUST_PRESSED) {
		var finalValue = false;
		for (key in Key.fromType(keyType)) {
			finalValue = FlxG.keys.checkStatus(key, action);
			if (finalValue)
				return true;
		}
		return finalValue;
    }
}