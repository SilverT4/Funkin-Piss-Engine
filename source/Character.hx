package;

import sys.FileSystem;
import yaml.util.ObjectMap.AnyObjectMap;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Character extends AnimatedSprite {
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var stunned:Bool = false;

	public var holdTimer:Float = 0;

	var animationsFromAlt:List<String>;

	public var config:AnyObjectMap = new AnyObjectMap();
	public var configPath:String = "";

	public function addPrefixAlternative(name, prefix, frames, looped) {
		animationsFromAlt.add(name);
		animation.addByPrefix(name, prefix, frames, looped);
	}

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false, isDebug = false) {
		super(x, y);

		animationsFromAlt = new List<String>();
		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		this.debugMode = isDebug;

		antialiasing = true;

		if (!curCharacter.endsWith("-custom")) {
			if (CoolUtil.isCustomPath(CoolUtil.getCharacterPath(curCharacter))) {
				if (FileSystem.exists(CoolUtil.getCharacterPath(curCharacter) + curCharacter + ".txt")) {
					frames = Paths.PEgetPackerAtlas(CoolUtil.getCharacterPath(curCharacter) + curCharacter);
				}
				else {
					frames = Paths.PEgetSparrowAtlas(CoolUtil.getCharacterPath(curCharacter) + curCharacter);
				}
			}
			else {
				if (FileSystem.exists(CoolUtil.getCharacterPath(curCharacter) + curCharacter + ".txt")) {
					frames = Paths.getPackerAtlas('characters/' + curCharacter + '/' + curCharacter);
				}
				else {
					frames = Paths.getSparrowAtlas('characters/' + curCharacter + '/' + curCharacter);
				}
			}
		}

		switch (curCharacter) {
			case 'bf-custom':
				for (file in FileSystem.readDirectory(Options.customBfPath)) {
					if (file.endsWith(".xml")) {
						frames = Paths.PEgetSparrowAtlas(Options.customBfPath + file.substring(0, file.length - 4));
						break;
					}
				}
				addPrefixAlternative('idle', 'BF idle dance', 24, false);
				addPrefixAlternative('singUP', 'BF NOTE UP0', 24, false);
				addPrefixAlternative('singLEFT', 'BF NOTE LEFT0', 24, false);
				addPrefixAlternative('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				addPrefixAlternative('singDOWN', 'BF NOTE DOWN0', 24, false);
				addPrefixAlternative('singUPmiss', 'BF NOTE UP MISS', 24, false);
				addPrefixAlternative('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				addPrefixAlternative('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				addPrefixAlternative('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				addPrefixAlternative('hey', 'BF HEY', 24, false);
				addPrefixAlternative('firstDeath', "BF dies", 24, false);
				addPrefixAlternative('deathLoop', "BF Dead Loop", 24, true);
				addPrefixAlternative('deathConfirm', "BF Dead confirm", 24, false);
				addPrefixAlternative('scared', 'BF idle shaking', 24, true);

				setOffset('idle', -5);
				setOffset("singUP", -29, 27);
				setOffset("singRIGHT", -38, -7);
				setOffset("singLEFT", 12, -6);
				setOffset("singDOWN", -10, -50);
				setOffset("singUPmiss", -29, 27);
				setOffset("singRIGHTmiss", -30, 21);
				setOffset("singLEFTmiss", 12, 24);
				setOffset("singDOWNmiss", -11, -19);
				setOffset("hey", 7, 4);
				setOffset('firstDeath', 37, 11);
				setOffset('deathLoop', 37, 5);
				setOffset('deathConfirm', 37, 69);
				setOffset('scared', -4);

				setConfig(Options.customBfPath + "config.yml");

				flipX = true;

				if (config != null) {
					if (config.get('animations') != null) {
						for (name in animationsFromAlt) {
							if (config.get('animations').get(name) != null) {
								var x = 0;
								var y = 0;
								if (Std.string(config.get('animations').get(name).get('X')) != "null") {
									x = config.get('animations').get(name).get('X');
								}
								if (Std.string(config.get('animations').get(name).get('Y')) != "null") {
									y = config.get('animations').get(name).get('Y');
								}
								setOffset(name, x, y);
							}
						}
					}

					if (Std.string(config.get("flipX")) != "null") {
						flipX = CoolUtil.strToBool(Std.string(config.get("flipX")));
					}
				}

				playAnim('idle');
			case 'gf-custom':
				for (file in FileSystem.readDirectory(Options.customGfPath)) {
					if (file.endsWith(".xml")) {
						frames = Paths.PEgetSparrowAtlas(Options.customGfPath + file.substring(0, file.length - 4));
						break;
					}
				}
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				setOffset('cheer');
				setOffset('sad', -2, -2);
				setOffset('danceLeft', 0, -9);
				setOffset('danceRight', 0, -9);

				setOffset("singUP", 0, 4);
				setOffset("singRIGHT", 0, -20);
				setOffset("singLEFT", 0, -19);
				setOffset("singDOWN", 0, -20);
				setOffset('hairBlow', 45, -8);
				setOffset('hairFall', 0, -9);

				setOffset('scared', -2, -17);

				setConfig(Options.customGfPath + "config.yml");

				if (config != null) {
					if (config.get('animations') != null) {
						for (name in animationsFromAlt) {
							if (config.get('animations').get(name) != null) {
								var x = 0;
								var y = 0;
								if (Std.string(config.get('animations').get(name).get('X')) != "null") {
									x = config.get('animations').get(name).get('X');
								}
								if (Std.string(config.get('animations').get(name).get('Y')) != "null") {
									y = config.get('animations').get(name).get('Y');
								}
								setOffset(name, x, y);
							}
						}
					}

					if (Std.string(config.get("flipX")) != "null") {
						flipX = CoolUtil.strToBool(Std.string(config.get("flipX")));
					}
				}

				playAnim('danceRight');
			case 'dad-custom':
				// DAD ANIMATION LOADING CODE
				for (file in FileSystem.readDirectory(Options.customDadPath)) {
					if (file.endsWith(".xml")) {
						frames = Paths.PEgetSparrowAtlas(Options.customDadPath + file.substring(0, file.length - 4));
						break;
					}
				}
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				animation.addByPrefix('singUP-alt', 'alt Dad Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN-alt', 'alt Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT-alt', 'alt Dad Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'alt Dad Sing Note RIGHT', 24, false);

				setOffset('idle');
				setOffset("singUP", -6, 50);
				setOffset("singRIGHT", 0, 27);
				setOffset("singLEFT", -10, 10);
				setOffset("singDOWN", 0, -30);
				setOffset("singUP-alt");
				setOffset("singDOWN-alt");
				setOffset("singLEFT-alt");
				setOffset("singRIGHT-alt");

				setConfig(Options.customDadPath + "config.yml");

				if (config != null) {
					if (config.get('animations') != null) {
						for (name in animationsFromAlt) {
							if (config.get('animations').get(name) != null) {
								var x = 0;
								var y = 0;
								if (Std.string(config.get('animations').get(name).get('X')) != "null") {
									x = config.get('animations').get(name).get('X');
								}
								if (Std.string(config.get('animations').get(name).get('Y')) != "null") {
									y = config.get('animations').get(name).get('Y');
								}
								setOffset(name, x, y);
							}
						}
					}

					if (Std.string(config.get("flipX")) != "null") {
						flipX = CoolUtil.strToBool(Std.string(config.get("flipX")));
					}
				}

				playAnim('idle');
		}

		var idleAnim = null;

		setConfig(CoolUtil.getCharacterPath(curCharacter) + 'config.yml');

		if (FileSystem.exists(configPath)) {
			if (config != null) {
				// take a shot everytime you see != null here
				var map:AnyObjectMap = config.get('animations');
				if (config.exists('animations')) {
					for (anim in map.keys()) {
						var values:AnyObjectMap = config.get('animations').get(anim);
						//trace(anim, values.get('x'), values.get('y'), values.get('frames'), values.get('looped'), values.get('name'), values.get('isIdle'));
						var _name = "";
						var _frames = 24;
						var _looped = false;
						var _x = 0;
						var _y = 0;
						var _indices = null;
						if (values != null) {
							if (values.get('x') != null)
								_x = values.get('x');
							if (values.get('y') != null)
								_y = values.get('y');
							if (values.get('frames') != null)
								_frames = values.get('frames');
							if (values.get('looped') != null)
								_looped = values.get('looped');
							if (values.get('name') != null)
								_name = values.get('name');
							if (values.get('isIdle') == true)
								idleAnim = anim;
							if (values.get('indices') != null)
								_indices = values.get('indices');
						}
						
						if (values.exists("indices")) {
							if (values.get('indices') != null) {
								animation.addByIndices(anim, _name, _indices, "", _frames, _looped);
							}
						}
						else {
							animation.addByPrefix(anim, _name, _frames, _looped);
						}
						setOffset(anim, _x, _y);
					}
				}
				if (idleAnim != null) {
					playAnim(idleAnim);
				}
				if (Std.string(config.get('flipX')) == "true") {
					flipX = true;
				} else if (Std.string(config.get('flipX')) == "false") {
					flipX = false;
				}
			}
		}

		switch (curCharacter) {
			case 'gf':
				playAnim('danceRight');
			case 'gf-christmas':
				playAnim('danceRight');
			case 'gf-car':
				playAnim('danceRight');
			case 'gf-pixel':
				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;
			case 'dad':
				playAnim('idle');
			case 'spooky':
				playAnim('danceRight');
			case 'mom':
				playAnim('idle');
			case 'mom-car':
				playAnim('idle');
			case 'monster':
				playAnim('idle');
			case 'monster-christmas':
				playAnim('idle');
			case 'pico':
				playAnim('idle');
			case 'bf':
				playAnim('idle');
			case 'bf-christmas':
				playAnim('idle');
			case 'bf-car':
				playAnim('idle');
			case 'bf-pixel':
				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;
			case 'bf-pixel-dead':
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
			case 'senpai':
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'spirit':
				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;
			case 'parents-christmas':
				playAnim('idle');
			default:
				//ass
		}

		dance();

		if (isPlayer) {
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf')) {
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null) {
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public function resetColorTransform() {
		missColorTransform = false;
		colorTransform.redOffset = 0;
		colorTransform.greenOffset = 0;
		colorTransform.blueOffset = 0;
	}

	override function update(elapsed:Float) {
		if (!animation.curAnim.name.startsWith("sing") && missColorTransform) {
			resetColorTransform();
		}
		if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished) {
			playAnim('deathLoop');
		}
		if (PlayState.playAs == "bf") {
			if (!curCharacter.startsWith('bf')) {
				if (animation.curAnim.name.startsWith('sing')) {
					holdTimer += elapsed;
				}

				var dadVar:Float = 4;
				if (curCharacter == 'dad')
					dadVar = 6.1;
				
				if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001) {
					dance();
					holdTimer = 0;
				}
			}
		}

		switch (curCharacter) {
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance() {
		var missAnim = false;
		if (animation.curAnim.name.endsWith('miss')) {
			if (animation.curAnim.finished) {
				missAnim = false;
			}
			else {
				missAnim = true;
			}
		}
		if (!debugMode && !stunned && !missAnim) {
			switch (curCharacter) {
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair')) {
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-custom':
					if (!animation.curAnim.name.startsWith('hair')) {
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair')) {
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair')) {
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair')) {
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-tankmen':
					if (!animation.curAnim.name.startsWith('hair')) {
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				case 'pico-speaker':
					playAnim("picoShoot1");
				default:
					playAnim('idle');
			}
		}
	}

	override public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void {
		if (animation.exists(AnimName)) {
			resetColorTransform();
			
			super.playAnim(AnimName, Force, Reversed, Frame);
	
			if (curCharacter == 'gf') {
				if (AnimName == 'singLEFT') {
					danced = true;
				}
				else if (AnimName == 'singRIGHT') {
					danced = false;
				}
	
				if (AnimName == 'singUP' || AnimName == 'singDOWN') {
					danced = !danced;
				}
			}
		} else {
			if (AnimName.endsWith("miss")) {
				super.playAnim(AnimName.substring(0, AnimName.length - 4), Force, Reversed, Frame);
				colorTransform.redOffset = -45;
				colorTransform.greenOffset = -80;
				colorTransform.blueOffset = -50;
				missColorTransform = true;
			}
			#if debug
			//trace("animation " + AnimName + " doesn't exist");
			#end
		}
	}

	public function setConfig(path:String) {
		configPath = path;
		if (FileSystem.exists(configPath)) {
			config = CoolUtil.readYAML(configPath);
		}
	}

	var missColorTransform:Bool = false;
}
