package;

import openfl.media.Sound;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

class AnimationDebug extends FlxState {
	var bf:Boyfriend;
	var dad:Character;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;
	var reload:Bool = false;
	var reloadFlipX:Bool = false;

	public function new(daAnim:String = 'spooky', ?reload:Bool = false, ?flipX:Bool = false) {
		super();
		this.daAnim = daAnim;
		this.reload = reload;
		this.reloadFlipX = flipX;
	}

	override function create() {
		trace("selectin '" + daAnim + "'");
		if (!reload) {
			FlxG.sound.music.stop();
			if (Sound.fromFile(Paths.PEinst('test')) != null) {
				FlxG.sound.playMusic(Sound.fromFile(Paths.PEinst('test')));
			}
		}

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		gridBG.alpha = 0.7;
		add(gridBG);

		if (daAnim == 'bf')
			isDad = false;

		if (isDad) {
			dad = new Character(0, 0, daAnim);
			dad.screenCenter();
			dad.debugMode = true;
			add(dad);

			char = dad;

			dadO = new Character(0, 0, daAnim);
			dadO.screenCenter();
			dadO.debugMode = true;
			add(dadO);

			charO = dadO;
		}
		else {
			bf = new Boyfriend(0, 0, daAnim);
			bf.screenCenter();
			bf.debugMode = true;
			add(bf);

			char = bf;

			bfO = new Boyfriend(0, 0, daAnim);
			bfO.screenCenter();
			bfO.debugMode = true;
			add(bfO);

			charO = bfO;
		}
		
		char.flipX = reloadFlipX;
		charO.flipX = reloadFlipX;
		
		charO.alpha = 0.0;

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.color = FlxColor.LIME;
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		var text:FlxText = new FlxText(0, 15, 0, "Offsets:", 20);
		text.scrollFactor.set();
		add(text);
		genBoyOffsets();

		var info:FlxText = new FlxText(0, 0, 0, "", 15);
		info.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		info.text = 
		"WS - Change the animation\n" +
		"ARROWS - Move the current animation (shift to move it further)\n" +
		"V - Make a transparent clone of current animation\n" +
		"IJKL - Move the camera\n" +
		"QE - Decrease / Increase the camera zoom\n"
		;
		//flx text is bugged with \n
		info.scrollFactor.set();
		info.y = (FlxG.height - info.height) + (info.size * 2);
		info.x = 10;
		add(info);

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void {
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets) {
			var text:FlxText = new FlxText(10, 40 + (18 * daLoop), 0, anim + " : " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function updateTexts():Void {
		dumbTexts.forEach(function(text:FlxText) {
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float) {
		textAnim.text = char.animation.curAnim.name;
		for (text in dumbTexts) {
			if (text.text.split(" ")[0] == char.animation.curAnim.name) {
				text.color = FlxColor.YELLOW;
			} else {
				text.color = FlxColor.BLUE;
			}
		}

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L) {
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else {
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.R) {
			FlxG.switchState(new AnimationDebug(daAnim, true, char.flipX));
		}

		if (FlxG.keys.justPressed.W) {
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S) {
			curAnim += 1;
		}

		if (FlxG.keys.justPressed.F) {
			if (char.flipX == false) {
				char.flipX = true;
				charO.flipX = true;
			} else {
				char.flipX = false;
				charO.flipX = false;
			}
		}

		if (FlxG.keys.justPressed.V) {
			charO.animOffsets = char.animOffsets;
			charO.playAnim(animList[curAnim]);
			charO.alpha = 0.2;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE) {
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}

		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new MainMenuState());
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP) {
			updateTexts();
			if (upP)
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP)
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP)
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP)
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		super.update(elapsed);
	}

	var dadO:Character;
	var bfO:Boyfriend;
	var charO:Character;
}
