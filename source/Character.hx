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

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter) {
			case 'bf-custom':
				for (file in FileSystem.readDirectory(Options.customBfPath)) {
					if (file.endsWith(".xml")) {
						tex = Paths.PEgetSparrowAtlas(Options.customBfPath + file.substring(0, file.length - 4));
						frames = tex;
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
						tex = Paths.PEgetSparrowAtlas(Options.customGfPath + file.substring(0, file.length - 4));
						frames = tex;
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
						tex = Paths.PEgetSparrowAtlas(Options.customDadPath + file.substring(0, file.length - 4));
						frames = tex;
						break;
					}
				}
				animation.addByPrefix('idle', 'Dad idle dance', 24);
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
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
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

				playAnim('danceRight');
			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/gfChristmas');
				frames = tex;
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

				playAnim('danceRight');
			case 'gf-car':
				tex = Paths.getSparrowAtlas('characters/gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				setOffset('danceLeft', 0);
				setOffset('danceRight', 0);

				playAnim('danceRight');
			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				setOffset('danceLeft', 0);
				setOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;
			case 'gf-tankmen':
				tex = Paths.getSparrowAtlas('characters/gfTankmen');
				frames = tex;
				animation.addByPrefix('sad', 'GF Crying at Gunpoint ', 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				setOffset('danceLeft');
				setOffset('danceRight');
				setOffset('sad');

				playAnim('danceRight');
			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				setOffset('idle');
				setOffset("singUP", -6, 50);
				setOffset("singRIGHT", 0, 27);
				setOffset("singLEFT", -10, 10);
				setOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				setOffset('danceLeft');
				setOffset('danceRight');

				setOffset("singUP", -20, 26);
				setOffset("singRIGHT", -130, -14);
				setOffset("singLEFT", 130, -10);
				setOffset("singDOWN", -50, -130);

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				setOffset('idle');
				setOffset("singUP", 14, 71);
				setOffset("singRIGHT", 10, -60);
				setOffset("singLEFT", 250, -23);
				setOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				setOffset('idle');
				setOffset("singUP", 14, 71);
				setOffset("singRIGHT", 10, -60);
				setOffset("singLEFT", 250, -23);
				setOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				setOffset('idle');
				setOffset("singUP", -20, 50);
				setOffset("singRIGHT", -51);
				setOffset("singLEFT", -30);
				setOffset("singDOWN", -30, -40);
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				setOffset('idle');
				setOffset("singUP", -20, 50);
				setOffset("singRIGHT", -51);
				setOffset("singLEFT", -30);
				setOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer) {
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else {
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);

				setOffset('idle');
				setOffset("singUP", -29, 27);
				setOffset("singRIGHT", -68, -7);
				setOffset("singLEFT", 65, 9);
				setOffset("singDOWN", 200, -70);
				setOffset("singUPmiss", -19, 67);
				setOffset("singRIGHTmiss", -60, 41);
				setOffset("singLEFTmiss", 62, 64);
				setOffset("singDOWNmiss", 210, -28);

				playAnim('idle');

				flipX = true;
			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);

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

				playAnim('idle');

				flipX = true;
			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters/bfChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

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

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('characters/bfCar');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				setOffset('idle', -5);
				setOffset("singUP", -29, 27);
				setOffset("singRIGHT", -38, -7);
				setOffset("singLEFT", 12, -6);
				setOffset("singDOWN", -10, -50);
				setOffset("singUPmiss", -29, 27);
				setOffset("singRIGHTmiss", -30, 21);
				setOffset("singLEFTmiss", 12, 24);
				setOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				flipX = true;
			case 'bf-holding-gf':
				var tex = Paths.getSparrowAtlas('characters/bfAndGF');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance w gf0', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS0', 24, false);
				animation.addByPrefix('bfCatch', 'BF catches GF', 24, false);

				setOffset('idle', 0, 0);
				setOffset("singUP", -30, 11);
				setOffset("singRIGHT", -40, 20);
				setOffset("singLEFT", 16, 2);
				setOffset("singDOWN", -11, -13);
				setOffset("singUPmiss", -30, 8);
				setOffset("singRIGHTmiss", -40, 34);
				setOffset("singLEFTmiss", 6, 5);
				setOffset("singDOWNmiss", -10, -10);
				playAnim('idle');

				flipX = true;
			case 'bf-holding-gf-dead':
				var tex = Paths.getSparrowAtlas('characters/bfHoldingGF-DEAD');
				frames = tex;
				animation.addByPrefix('firstDeath', "BF Dies with GF", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead with GF Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY confirm holding gf", 24, false);

				setOffset('firstDeath', 37, 11);
				setOffset('deathLoop', 37, -6);
				setOffset('deathConfirm', 37, 25);
				
				playAnim('firstDeath');
				
				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				setOffset('idle');
				setOffset("singUP");
				setOffset("singRIGHT");
				setOffset("singLEFT");
				setOffset("singDOWN");
				setOffset("singUPmiss");
				setOffset("singRIGHTmiss");
				setOffset("singLEFTmiss");
				setOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				setOffset('firstDeath');
				setOffset('deathLoop', -37);
				setOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;
			case 'senpai':
				// frames = Paths.getSparrowAtlas('weeb/senpai');
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				setOffset('idle');
				setOffset("singUP", 5, 37);
				setOffset("singRIGHT");
				setOffset("singLEFT", 40);
				setOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				setOffset('idle');
				setOffset("singUP", 5, 37);
				setOffset("singRIGHT");
				setOffset("singLEFT", 40);
				setOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				setOffset('idle', -220, -280);
				setOffset('singUP', -220, -240);
				setOffset("singRIGHT", -220, -280);
				setOffset("singLEFT", -200, -280);
				setOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;
			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				setOffset('idle');
				setOffset("singUP", -47, 24);
				setOffset("singRIGHT", -1, -23);
				setOffset("singLEFT", -30, 16);
				setOffset("singDOWN", -31, -29);
				setOffset("singUP-alt", -47, 24);
				setOffset("singRIGHT-alt", -1, -24);
				setOffset("singLEFT-alt", -30, 15);
				setOffset("singDOWN-alt", -30, -27);

				playAnim('idle');
			case 'tankman':
				frames = Paths.getSparrowAtlas('characters/tankmanCaptain');
				animation.addByPrefix('idle', "Tankman Idle Dance instance 1", 24);
				animation.addByPrefix('singUP', "Tankman UP note instance 1", 24);
				animation.addByPrefix('singRIGHT', "Tankman Note Left instance 1", 24);
				animation.addByPrefix('singLEFT', "Tankman Right Note instance 1", 24);
				animation.addByPrefix('singDOWN', "Tankman DOWN note instance 1", 24);
				animation.addByPrefix('ugh', "TANKMAN UGH instance 1", 24);
				animation.addByPrefix('prettyGood', "PRETTY GOOD tankman instance 1", 24);
				
				flipX = true;

				setOffset('idle');
				setOffset("singLEFT", 70, -10);
				setOffset("singDOWN", 70, -100);
				setOffset("singRIGHT", 20, -30);
				setOffset('singUP', 50, 50);
				setOffset("ugh");
				setOffset("prettyGood");

				playAnim('idle');
			case "pico-speaker":
				frames = Paths.getSparrowAtlas('characters/picoSpeaker');
				animation.addByPrefix('picoShoot1', "Pico shoot 1", 24);
				animation.addByPrefix('picoShoot2', "Pico shoot 2", 24);
				animation.addByPrefix('picoShoot3', "Pico shoot 3", 24);
				animation.addByPrefix('picoShoot4', "Pico shoot 4", 24);

				/*
				setOffset('picoShoot1', 474, 19);
				setOffset("picoShoot2", 572, -109);
				setOffset("picoShoot3", 0, -45);
				setOffset("picoShoot4", 0, 0);
				*/
				
				setOffset('picoShoot1', 0, -1);
				setOffset("picoShoot2", 0, -129);
				setOffset("picoShoot3", 413, -65);
				setOffset("picoShoot4", 440, -20);

				playAnim('picoShoot1');
			default:
				frames = Paths.PEgetSparrowAtlas('mods/characters/$curCharacter/$curCharacter');

				var idleAnim = null;

				setConfig('mods/characters/$curCharacter/config.yml');

				if (config != null) {
					// take a shot everytime you see != null here
					var map:AnyObjectMap = config.get('animations');
					if (config.exists('animations')) {
						for (anim in map.keys()) {
							var values:AnyObjectMap = config.get('animations').get(anim);
							//trace(anim, values.get('x'), values.get('y'), values.get('frames'), values.get('looped'), values.get('name'), values.get('isIdle'));
							var _name = anim;
							var _frames = 24;
							var _looped = false;
							var _x = 0;
							var _y = 0;
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
									idleAnim = _name;
							}
							
							animation.addByPrefix(_name, anim, _frames, _looped);
							setOffset(_name, _x, _y);
						}
					}
					if (idleAnim != null) {
						playAnim(idleAnim);
					}
					flipX = true;
					if (Std.string(config.get('flipX')) == "true") {
						flipX = true;
					} else if (Std.string(config.get('flipX')) == "false") {
						flipX = false;
					}
					//note to self: without converting data values with Std.[type] it will always return null
				}
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
