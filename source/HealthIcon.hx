package;

import openfl.display.BitmapData;
import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite {
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var curChar:String;

	public var actualChar:String;

	public function new(char:String = 'bf', isPlayer:Bool = false) {
		super();
		setChar(char, isPlayer);
	}

	public function setChar(char:String = 'bf', isPlayer:Bool = false) {
		var type = "normal";

		actualChar = char;
		switch (char) {
			case 'bf-custom': 
				curChar = char;
				type = "skin";
			case 'gf-custom': 
				curChar = char;
				type = "skin";
			case 'dad-custom': 
				curChar = char;
				type = "skin";
			case 'gf-christmas': curChar = "gf";
			case 'gf-car': curChar = "gf";
			case 'gf-pixel': curChar = "gf";
			case 'gf-tankmen': curChar = "gf";
			case 'mom-car': curChar = "mom";
			case 'monster': curChar = char;
			case 'monster-christmas': curChar = "monster";
			case 'bf-christmas': curChar = "bf";
			case 'bf-car': curChar = "bf";
			case 'bf-holding-gf': curChar = "bf";
			case 'bf-pixel': curChar = "bf-pixel";
			case 'senpai-angry': curChar = "senpai";
			case 'parents-christmas': curChar = "parents";
			case "pico-speaker": curChar = "pico";
			default:
				curChar = char;
				if (SysFile.exists("mods/characters/" + curChar + "/icon.png")) {
					type = "mods";
				}
		}
		if (type == "skin") {
			if (isPlayer == false) {
				if (char.startsWith("gf")) {
					if (Options.customGf && SysFile.exists(Paths.skinIcon("gf"))) {
						loadGraphic(BitmapData.fromBytes(SysFile.getBytes(Paths.skinIcon("gf"))), true, 150, 150);
					} else {
						loadGraphic(Paths.image('icons/icon-gf'), true, 150, 150);
					}
				}
				else if (char.startsWith("dad")) {
					if (Options.customDad && SysFile.exists(Paths.skinIcon("dad"))) {
						loadGraphic(BitmapData.fromBytes(SysFile.getBytes(Paths.skinIcon("dad"))), true, 150, 150);
					} else {
						loadGraphic(Paths.image('icons/icon-dad'), true, 150, 150);
					}
				}
			}
			else if (isPlayer && Options.customBf && SysFile.exists(Paths.skinIcon("bf"))) {
				loadGraphic(BitmapData.fromBytes(SysFile.getBytes(Paths.skinIcon("bf"))), true, 150, 150);
			} else {
				loadGraphic(Paths.image('icons/icon-bf'), true, 150, 150);
			}
		}
		if (type == "mods") {
			if (SysFile.exists(Paths.modsIcon(curChar))) {
				loadGraphic(BitmapData.fromBytes(SysFile.getBytes(Paths.modsIcon(curChar))), true, 150, 150);
			} else {
				loadGraphic(Paths.image('icons/icon-face'), true, 150, 150);
			}
		}
		if (type == "normal") {
			if (BitmapData.fromFile(Paths.image('icons/icon-$curChar')) != null) {
				loadGraphic(Paths.image('icons/icon-$curChar'), true, 150, 150);
			} else {
				loadGraphic(Paths.image('icons/icon-face'), true, 150, 150);
			}
		}
		
		antialiasing = true;
		animation.add(curChar, [0, 1], 0, false, isPlayer);
		animation.play(curChar);
		scrollFactor.set();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}