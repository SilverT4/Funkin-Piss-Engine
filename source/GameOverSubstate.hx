package;

import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate {
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";
	var daStage = "";

	public function new(x:Float, y:Float) {
		daStage = PlayState.currentPlaystate.stage.name;
		var daBf:String = '';
		switch (PlayState.bf.curCharacter) {
			case 'bf-pixel':
				daBf = 'bf-pixel-dead';
			case 'bf-holding-gf':
				daBf = 'bf-holding-gf-dead';
			default:
				daBf = 'bf';
		}
		switch (daStage) {
			case 'school':
				stageSuffix = '-pixel';
			case 'schoolEvil':
				stageSuffix = '-pixel';
		}

		super();

		Conductor.songPosition = 0;

		if (Options.customBf) {
			daBf = 'bf-custom';
		}

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (Controls.check(ACCEPT, JUST_PRESSED)) {
			endBullshit();
		}

		if (Controls.check(BACK, JUST_PRESSED)) {
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(bf.curCharacter));
		#end

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12) {
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished) {
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
			if (PlayState.dad.curCharacter == "tankman") {
				//i love this lmao
				FlxG.sound.music.volume = 0.2;
				FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + new FlxRandom().int(1, 25)), 1, false, null, true,
					function() {
						FlxTween.num(FlxG.sound.music.volume, 1, 2, null, function tween(v:Float) {
							FlxG.sound.music.volume = v;
						});
					}
				);
			}
		}

		if (FlxG.sound.music.playing) {
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit() {
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void {
		if (!isEnding) {
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer) {
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function() {
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
