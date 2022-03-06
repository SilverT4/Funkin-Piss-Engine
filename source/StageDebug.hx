package;

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

    public function new(stageName:String = 'stage') {
		super();
		this.stageName = stageName;
	}

    function gendumbTexts(pushList:Bool = true):Void {
		var daLoop:Int = 0;

        for (penis in stage) {
            var text:FlxText = new FlxText(10, 40 + (18 * daLoop), 0, penis.name + " : " + "[ " + penis.x + ", " + penis.y + ", " + penis.sizeMultiplier + "]", 15);
            text.scrollFactor.set();
            text.color = FlxColor.GRAY;
            dumbTexts.add(text);

            if (pushList)
                imageList.push(penis.name);

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

    override function create() {
        
        FlxG.sound.music.stop();
        if (Sound.fromFile(Paths.PEinst('test')) != null) {
            FlxG.sound.playMusic(Sound.fromFile(Paths.PEinst('test')));
        }

        //FlxG.worldBounds.set(2147483647, 2147483647);

        stage = new Stage(stageName);
        add(stage);

        var text:FlxText = new FlxText(0, 15, 0, "Images:", 20);
        text.scrollFactor.set();
        add(text);

        dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);
        gendumbTexts();

        var info:FlxText = new FlxText(0, 0, 0, "", 15);
		info.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		info.text =
        "DRAG MOUSE CLICK - Move current Sprite\n" +
        "WS - Change the Sprite\n" +
		"IJKL - Move the camera\n"
		;
		info.scrollFactor.set();
		info.y = (FlxG.height - info.height) + (info.size * 2);
		info.x = 10;
		add(info);
        
        //copying from animation debug because yes
        camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.screenCenter();
		add(camFollow);

        FlxG.camera.follow(camFollow);

        super.create();
    }

    override function update(elapsed) {

        for (text in dumbTexts) {
			if (text.text.split(" ")[0] == imageList[currentSprite]) {
				text.color = FlxColor.YELLOW;
			} else {
				text.color = FlxColor.BLUE;
			}
		}

        if (FlxG.keys.justPressed.W)
            currentSprite++;
        if (FlxG.keys.justPressed.S)
            currentSprite--;

        if (currentSprite < 0)
            currentSprite = imageList.length - 1;

        if (currentSprite >= imageList.length)
            currentSprite = 0;

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

        if (FlxG.mouse.pressed) {
            if (FlxG.mouse.justMoved) {
                for (penis in stage) {
                    if (penis.name == imageList[currentSprite]) {
                        penis.x = FlxG.mouse.x;
                        penis.y = FlxG.mouse.y;
                    }
                }
            }

            if (FlxG.mouse.wheel == 1) {
                for (penis in stage) {
                    if (penis.name == imageList[currentSprite]) {
                        penis.setAssetSize(penis.sizeMultiplier + 0.01);
                    }
                }
            }
            if (FlxG.mouse.wheel == -1) {
                for (penis in stage) {
                    if (penis.name == imageList[currentSprite]) {
                        penis.setAssetSize(penis.sizeMultiplier - 0.01);
                    }
                }
            }

            /*
            if (draggedSprite == null) {
                for (penis in stage) {
                    if (FlxCollision.pixelPerfectPointCheck(FlxG.mouse.y, FlxG.mouse.x, penis, 255)) {
                        draggedSprite = penis;
                    }
                }
            }
            */
        }
        if (FlxG.mouse.justReleased) {
            // do it 2 times to not glitch the text
            removeTexts();
            removeTexts();
            gendumbTexts(false);
        }
        /*
        if (!FlxG.mouse.pressed) {
            draggedSprite = null;
        }
        if (draggedSprite != null) {
            draggedSprite.x = FlxG.mouse.x;
            draggedSprite.y = FlxG.mouse.y;
        }
        */

        if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new MainMenuState());
		}

        super.update(elapsed);
    }

    var draggedSprite:StageAsset;

	var currentSprite:Int = 0;
}