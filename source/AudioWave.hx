package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxStrip;
import flixel.util.FlxColor;
import haxe.io.Bytes;
import lime.media.AudioBuffer;
import lime.media.vorbis.VorbisFile;
import openfl.geom.Rectangle;
import openfl.media.Sound;

class AudioWave extends FlxSprite {
	//mostly copied from github.com/gedehari/HaxeFlixel-Waveform-Rendering/
	//currently unused
	var audioBuffer:AudioBuffer;
	var bytes:Bytes;

	override public function new(?X:Float = 0, ?Y:Float = 0, song:String, angle:Int = 90) {
		super(X, Y);
		this.angle = angle;

		makeGraphic(1280, 720, FlxColor.TRANSPARENT);

		audioBuffer = AudioBuffer.fromFile('assets/songs/${song.toLowerCase()}/Voices.' + Paths.SOUND_EXT);
		trace("Channels        : " + audioBuffer.channels + "\nBits per sample : " + audioBuffer.bitsPerSample);

		bytes = audioBuffer.data.toBytes();

		trace(bytes.length);

		var index:Int = 0;
		var drawIndex:Int = 0;
		var samplesPerCollumn:Int = 600;

		var min:Float = 0;
		var max:Float = 0;

		while ((index * 4) < (bytes.length - 1)) {
			var byte:Int = bytes.getUInt16(index * 4);

			if (byte > 65535 / 2)
				byte -= 65535;

			var sample:Float = (byte / 65535);

			if (sample > 0) {
				if (sample > max)
					max = sample;
			}
			else if (sample < 0) {
				if (sample < min)
					min = sample;
			}

			if ((index % samplesPerCollumn) == 0) {
				// trace("min: " + min + ", max: " + max);

				if (drawIndex > 1280) {
					drawIndex = 0;
				}

				var pixelsMin:Float = Math.abs(min * 300);
				var pixelsMax:Float = max * 300;

				pixels.fillRect(new Rectangle(drawIndex, 0, 1, 720), FlxColor.TRANSPARENT);
				pixels.fillRect(new Rectangle(drawIndex, (FlxG.height / 2) - pixelsMin, 1, pixelsMin + pixelsMax), FlxColor.LIME);
				drawIndex += 1;

				min = 0;
				max = 0;
			}

			index += 1;
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}