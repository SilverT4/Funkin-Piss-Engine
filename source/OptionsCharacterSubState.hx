package;

import flixel.FlxSprite;
import flixel.FlxG;
import lime.net.oauth.OAuthToken.AccessToken;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSubState;

using StringTools;

class OptionsCharacterSubState extends FlxSubState {

    var character:String;
    var character_path:String;
    var character_list:Array<String>;

    var grpTexts:FlxTypedGroup<FlxText>;
    var inGame = false;

    override public function new(character, ?inGame) {
        super();

        this.inGame = inGame;
        this.character = character;
        character_path = "mods/skins/" + character + "/";
        character_list = new Array<String>();

        character_list.push("Vanilla");
		for (file in SysFile.readDirectory(character_path)) {
			var path = haxe.io.Path.join([character_path, file]);
            if (SysFile.isDirectory(path)) {
                character_list.push(file);
            }
		}

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.5;
		bg.scrollFactor.set();

        grpTexts = new FlxTypedGroup<FlxText>();

        add(bg);
		add(grpTexts);

        updateMenu();

        cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    }

    override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.UP) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected -= 1;
		}

		if (FlxG.keys.justPressed.DOWN) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected += 1;
		}

        if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			closeSubState();
			FlxG.state.openSubState(new OptionsSubState(inGame));
		}

        if (curSelected < 0)
			curSelected = character_list.length - 1;

		if (curSelected >= character_list.length)
			curSelected = 0;

		grpTexts.forEach(function(txt:FlxText) {
			if (txt.ID == curSelected)
				txt.color = FlxColor.YELLOW;
            else
                txt.color = FlxColor.WHITE;
		});

        if (FlxG.keys.justPressed.ENTER) {
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
            if (character_list[curSelected] == "Vanilla") {
                switch (character) {
                    case "bf":
                        Options.customBf = false;
                        if (inGame) PlayState.bf = new Boyfriend(PlayState.bf.x, PlayState.bf.y, PlayState.SONG.player1);
                    case "gf":
                        Options.customGf = false;
                        if (inGame) PlayState.gf = new Character(PlayState.gf.x, PlayState.gf.y, PlayState.gfVersion);
                    case "dad":
                        Options.customDad = false;
                        if (inGame) PlayState.dad = new Character(PlayState.dad.x, PlayState.dad.y, PlayState.SONG.player2);
                }
            } else {
                switch (character) {
                    case "bf":
                        Options.customBf = true;
                        Options.customBfPath = character_path + character_list[curSelected] + "/";
                        if (inGame) PlayState.bf = new Boyfriend(PlayState.bf.x, PlayState.bf.y, "bf-custom");
                    case "gf":
                        Options.customGf = true;
                        Options.customGfPath = character_path + character_list[curSelected] + "/";
                        if (inGame) PlayState.gf = new Character(PlayState.gf.x, PlayState.gf.y, "gf-custom");
                    case "dad":
                        Options.customDad = true;
                        Options.customDadPath = character_path + character_list[curSelected] + "/";
                        if (inGame) PlayState.dad = new Character(PlayState.dad.x, PlayState.dad.y, "dad-custom");
                }
            }
            Options.saveAll();
            if (inGame) {
                PlayState.updateChar(character);
            }
        }
    }

    function updateMenu() {
		grpTexts.clear();
        var i = 0;
		for (character in character_list) {
			var optionText:FlxText = new FlxText(20, 20 + (i * 50), 0, character, 32);
			optionText.scrollFactor.set();
			optionText.ID = i;
			optionText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
			grpTexts.add(optionText);
            i++;
		}
	}

	var curSelected:Int;
}