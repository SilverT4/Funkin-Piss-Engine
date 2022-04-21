package;

import openfl.media.Sound;
import Discord.DiscordClient;
import flixel.util.FlxColor;
import OptionsSubState.Background;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;

class EditorSelector extends FlxState {

	var options = [
		'Chart Editor',
		'Character Editor',
        'Stage Editor',
        'Dialogue Editor'
	];
	var optionsItems = new FlxTypedGroup<Alphabet>();
	var curSelected:Int = 0;
	var inGame:Bool;

	public function new() {
		super();

        FlxG.sound.music.stop();
        if (Sound.fromFile(Paths.PEinst('test')) != null) {
            FlxG.sound.playMusic(Sound.fromFile(Paths.PEinst('test')));
        }

		var bg = new Background(FlxColor.WHITE);
		add(bg);

		var curY = 0.0;
		var curIndex = -1;
		for (s in options) {
			curIndex++;
			var option = new Alphabet(0, 0, s, true);
			option.ID = curIndex;
			option.scrollFactor.set();
			option.screenCenter(XY);
			option.y += curY;
			curY += option.height + 10;

			optionsItems.add(option);
		}
		for (item in optionsItems) {
			item.y -= curY / 2;
		}
		add(optionsItems);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (Controls.check(UI_UP)) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected -= 1;
		}

		if (Controls.check(UI_DOWN)) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected += 1;
		}

		if (curSelected < 0)
			curSelected = optionsItems.length - 1;

		if (curSelected >= optionsItems.length)
			curSelected = 0;

		optionsItems.forEach(function(alphab:Alphabet) {
			alphab.alpha = 0.6;

			if (alphab.ID == curSelected) {
				alphab.alpha = 1;
			}
		});

		if (Controls.check(ACCEPT)) {
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			switch (options[curSelected]) {
                case 'Chart Editor':
                    FlxG.switchState(new ChartingState());

                    #if desktop
                    DiscordClient.changePresence("Chart Editor", null, null, true);
                    #end
				case "Character Editor":
                    FlxG.switchState(new AnimationDebugCharacterSelector());

                    #if desktop
                    DiscordClient.changePresence("Character Editor", null, null, true);
                    #end
				case "Stage Editor":
                    FlxG.switchState(new DebugStageSelector());

                    #if desktop
                    DiscordClient.changePresence("Stage Editor", null, null, true);
                    #end
                case "Dialogue Editor":
                    FlxG.switchState(new DialogueBoxEditor());

                    #if desktop
                    DiscordClient.changePresence("Dialogue Editor", null, null, true);
                    #end
			}
		}

		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new PlayState());
		}
	}
}