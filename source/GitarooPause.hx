package;

import Discord.DiscordClient;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import sys.io.File;
import openfl.display.BitmapData;
import openfl.media.Sound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class GitarooPause extends MusicBeatState
{
	var video:MP4Sprite;
	//YOU EXPECTED GITAROOPAUSE BUT IT WA...
	//dead meme
	public function new():Void {
		super();
	}

	override public function create() {
		super.create();

		DiscordClient.changePresence("A Skeleton has appeared", "");
		
		play();
		add(video);

		FlxG.sound.playMusic(Sound.fromFile("assets\\shared\\images\\pauseAlt\\skullgang.ogg"));

		var skeleton = new FlxSprite(200, 100);
		skeleton.loadGraphic(BitmapData.fromBytes(File.getBytes("assets\\shared\\images\\pauseAlt\\skull.png")));
		skeleton.alpha = 0.0;
		add(skeleton);

		var text = new FlxText(skeleton.x + skeleton.width + 50, 0);
		text.size = 48;
		text.text = "a skeleton appears";
		text.screenCenter(Y);
		text.alpha = 0.0;
		add(text);

		new FlxTimer().start(4.5, function(tmr:FlxTimer) {
			FlxTween.tween(skeleton, {alpha: 1.0}, 1);
			FlxTween.tween(text, {alpha: 1.0}, 1);
		});
	}

	public function play() {
		video = new MP4Sprite(0, 0, FlxG.width, FlxG.height, true);
		video.video.repeat = -1;
		video.video.blockInput = true;
		video.playVideo("assets\\shared\\images\\pauseAlt\\fire.mp4");
	}
}
