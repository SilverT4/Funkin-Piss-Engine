package;

import sys.io.File;
import sys.FileSystem;
import yaml.Yaml;
import yaml.util.ObjectMap.AnyObjectMap;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxCamera;
import openfl.media.Sound;
import Stage.StageAsset;
import flixel.util.FlxCollision;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxState;

class StageDebug extends FlxState {

    var stageName = "";
    var stage:Stage;

    var dumbTexts:FlxTypedGroup<FlxText>;

    var imageList:Array<String> = [];

    var camFollow:FlxObject;

    var hudCamera:FlxCamera;

    var dumbTextsWidthWX:Float = 0.0;

    var draggedSprite:StageAsset;

	var currentSprite:Int = 0;

	var cum:FlxCamera;

	var midget:Character;

	var gf:Character;

	var dad:Character;

	var characters:FlxTypedGroup<Character>;

	var dumbTexts2:FlxTypedGroup<FlxText>;

    var textImg:FlxText;
    var textChar:FlxText;

    public function new(stageName:String = 'stage') {
		super();
		this.stageName = stageName;
	}

    function gendumbTexts(pushList:Bool = true):Void {
		var daLoop:Int = 0;

        for (penis in stage) {
            var text:FlxText = new FlxText(10, 42 + (23 * daLoop), 0, penis.name + " : " + "[ " + penis.x + ", " + penis.y + ", " + penis.sizeMultiplier + "]", 15);
            text.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            text.scrollFactor.set();
            text.color = FlxColor.GRAY;
            if (text.width + text.x > dumbTextsWidthWX) {
                dumbTextsWidthWX = text.width + text.x;
            }
            dumbTexts.add(text);

            if (pushList)
                imageList.push(penis.name);

            daLoop++;
        }
	}

    function gendumbTexts2(pushList:Bool = true):Void {
		var daLoop:Int = 0;

        for (char in characters) {
            var text:FlxText = new FlxText(dumbTextsWidthWX + 30, 42 + (23 * daLoop), 0, char.curCharacter + " : " + "[ " + char.x + ", " + char.y + "]", 15);
            text.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            text.scrollFactor.set();
            text.color = FlxColor.GRAY;
            dumbTexts2.add(text);

            if (pushList)
                characterList.push(char.curCharacter);

            daLoop++;
        }
	}

    function removeTexts():Void {
        dumbTexts.forEach(function(text:FlxText) {
            text.text = " ";
            text.kill();
            dumbTexts.remove(text, true);
        });
	}

    function removeTexts2():Void {
        dumbTexts2.forEach(function(text:FlxText) {
            text.text = " ";
            text.kill();
            dumbTexts2.remove(text, true);
        });
	}

    override function create() {
        hudCamera = new FlxCamera();
        hudCamera.bgColor.alpha = 0;

        FlxG.cameras.add(hudCamera, false);
        
        FlxG.sound.music.stop();
        if (Sound.fromFile(Paths.PEinst('test')) != null) {
            FlxG.sound.playMusic(Sound.fromFile(Paths.PEinst('test')));
        }

        //collission stuff unused | FlxG.worldBounds.set(2147483647, 2147483647);

        stage = new Stage(stageName);
        FlxG.camera.zoom = stage.camZoom;
        add(stage);

        midget = new Boyfriend(stage.bfX, stage.bfY, "bf");
        gf = new Character(stage.gfX, stage.gfY, "gf");
        dad = new Character(stage.dadX, stage.dadY, "dad");

        characters = new FlxTypedGroup<Character>();

        characters.add(gf);
        characters.add(dad);
        characters.add(midget);

        add(characters);

        textImg = new FlxText(15, 15, 0, "Images:", 20);
        textImg.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
        textImg.scrollFactor.set();
        add(textImg);

        dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);
        gendumbTexts();

        var info:FlxText = new FlxText(0, 0, 0, "", 15);
		info.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		info.text =
        "CTRL + DRAG MOUSE CLICK - Move current Sprite\n" +
        "CTRL + DRAG MOUSE WHEEL - Change the size of current Sprite\n" +
        "WS - Change the Sprite\n" +
        "AD - Change the tab (Images / Characters)\n" +
		"IJKL - Move the camera (Shift to 2x faster)\n" +
        "CTRL + S - Save the Config\n"
		;
		info.scrollFactor.set();
		info.y = (FlxG.height - info.height) + (info.size * 2);
		info.x = 10;
		add(info);

        textChar = new FlxText(0, 15, 0, "Characters:", 20);
        textChar.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
        textChar.scrollFactor.set();
        textChar.x = dumbTextsWidthWX + 20;
        add(textChar);

        dumbTexts2 = new FlxTypedGroup<FlxText>();
		add(dumbTexts2);
        gendumbTexts2();
        
        //copying from animation debug because yes
        camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.screenCenter();
		add(camFollow);

        FlxG.camera.follow(camFollow);

        info.cameras = [hudCamera];
        dumbTexts.cameras = [hudCamera];
        textImg.cameras = [hudCamera];
        textChar.cameras = [hudCamera];
        dumbTexts2.cameras = [hudCamera];

        super.create();
    }

    override function update(elapsed) {
        if (FlxG.keys.justPressed.A) {
            curTab = 0;
        }
        else if (FlxG.keys.justPressed.D) {
            curTab = 1;
        }

        if (curTab == 0) {
            textImg.color = FlxColor.YELLOW;
            textChar.color = FlxColor.WHITE;
            for (text in dumbTexts) {
                if (text.text.split(" ")[0] == imageList[currentSprite]) {
                    text.color = FlxColor.YELLOW;
                } else {
                    text.color = FlxColor.GRAY;
                }
            }
        }
        
        if (curTab == 1) {
            textImg.color = FlxColor.WHITE;
            textChar.color = FlxColor.YELLOW;
            for (text in dumbTexts2) {
                if (text.text.split(" ")[0] == characterList[currentCharacter]) {
                    text.color = FlxColor.YELLOW;
                } else {
                    text.color = FlxColor.GRAY;
                }
            }
        }

        if (FlxG.keys.justPressed.W)
            if (curTab == 0)
                currentSprite--;
            else if (curTab == 1)
                currentCharacter--;
        if (FlxG.keys.justPressed.S)
            if (curTab == 0)
                currentSprite++;
            else if (curTab == 1)
                currentCharacter++;

        if (currentSprite < 0)
            currentSprite = imageList.length - 1;

        if (currentSprite >= imageList.length)
            currentSprite = 0;

        if (currentCharacter < 0)
            currentCharacter = characterList.length - 1;

        if (currentCharacter >= characterList.length)
            currentCharacter = 0;

        if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L) {
            var multiplier = 1;
            if (FlxG.keys.pressed.SHIFT)
                multiplier = 2;

            if (FlxG.keys.pressed.I)
                camFollow.velocity.y = -90 * multiplier;
            else if (FlxG.keys.pressed.K)
                camFollow.velocity.y = 90 * multiplier;
            else
                camFollow.velocity.y = 0;
    
            if (FlxG.keys.pressed.J)
                camFollow.velocity.x = -90 * multiplier;
            else if (FlxG.keys.pressed.L)
                camFollow.velocity.x = 90 * multiplier;
            else
                camFollow.velocity.x = 0;
        }
        else {
            camFollow.velocity.set();
        }

        if (FlxG.keys.pressed.CONTROL && FlxG.mouse.pressed) {
            if (FlxG.mouse.justMoved) {
                if (curTab == 0)
                    for (penis in stage) {
                        if (penis.name == imageList[currentSprite]) {
                            penis.x = FlxG.mouse.x;
                            penis.y = FlxG.mouse.y;
                        }
                    }
                if (curTab == 1)
                    for (char in characters) {
                        if (char.curCharacter == characterList[currentCharacter]) {
                            char.x = FlxG.mouse.x;
                            char.y = FlxG.mouse.y;
                        }
                    }
            }

            if (FlxG.mouse.wheel == 1) {
                if (curTab == 0)
                    for (penis in stage) {
                        if (penis.name == imageList[currentSprite]) {
                            penis.setAssetSize(penis.sizeMultiplier + 0.01);
                        }
                    }
            }
            if (FlxG.mouse.wheel == -1) {
                if (curTab == 0)
                    for (penis in stage) {
                        if (penis.name == imageList[currentSprite]) {
                            penis.setAssetSize(penis.sizeMultiplier - 0.01);
                        }
                    }
            }
        }
        if (FlxG.mouse.justReleased) {
            // do it 2 times to not glitch the text
            if (curTab == 0) {
                removeTexts();
                removeTexts();
                gendumbTexts(false);
            }
            if (curTab == 1) {
                removeTexts2();
                removeTexts2();
                gendumbTexts2(false);
            }
        }

        if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.S) {
			saveConfig();
		}
 
        if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new MainMenuState());
		}

        super.update(elapsed);
    }

    function saveConfig() {
		if (stage.config != null) {
			if (!stage.config.exists('images')) {
				stage.config.set('images', new AnyObjectMap());
			}
            stage.config.set('zoom', stage.camZoom);

            for (char in characters) {
                stage.config.set('${char.curCharacter}X', char.x);
                stage.config.set('${char.curCharacter}Y', char.y);
            }

			var map:AnyObjectMap = stage.config.get('images');
            for (image in stage) {
                if (!map.exists(image.name)) {
                    stage.config.get('images').set(image.name);
                }
                stage.config.get('images').get(image.name).set('x', image.x);
				stage.config.get('images').get(image.name).set('y', image.y);
                stage.config.get('images').get(image.name).set('size', image.sizeMultiplier);
            }
			var renderedYaml = Yaml.render(stage.config);
			CoolUtil.writeToFile(stage.configPath, renderedYaml);
		}
	}

	var curTab:Int = 0;

	var currentCharacter:Int = 0;

	var characterList:Array<String> = [];
}