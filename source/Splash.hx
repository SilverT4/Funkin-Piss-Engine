package;

import flixel.addons.display.FlxGridOverlay;
import clipboard.Clipboard;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class SplashColorState extends FlxState {
    var splash:Splash;
    var strumNote:FlxSprite;

    var color:FlxColor;
    var text:FlxText;

    public function new() {
        super();

        var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		gridBG.alpha = 0.7;
		add(gridBG);

        strumNote = new FlxSprite();
        strumNote.frames = Paths.getSparrowAtlas('NOTE_assets');
        strumNote.antialiasing = true;
        strumNote.setGraphicSize(Std.int(strumNote.width * 0.7));
        strumNote.animation.addByPrefix('confirm', 'up confirm', 24, false);
        strumNote.updateHitbox();
        strumNote.screenCenter();
        add(strumNote);

        splash = new Splash(null, true);
        splash.updateHitbox();
        splash.screenCenter();
        add(splash);

        color = FlxColor.WHITE;

        text = new FlxText(100, 100);
        text.size = 24;
        text.text = color.toHexString();
        add(text);

        textRed = new FlxText(0, FlxG.height - 20);
        textRed.size = 16;
        textRed.screenCenter(X);
        textRed.x -= 70;
        add(textRed);

        textGreen = new FlxText(textRed.x + textRed.width + 50, FlxG.height - 20);
        textGreen.size = 16;
        add(textGreen);

        textBlue = new FlxText(textGreen.x + textGreen.width + 50, FlxG.height - 20);
        textBlue.size = 16;
        add(textBlue);

        //splash.color.red = 150;
        //splash.color.green = 78;
        //splash.color.blue = 162;

        splash.animation.play("splash");
        splash.animation.finishCallback = function(name:String) {splash.animation.play("splash"); strumNote.animation.play("confirm");};

        splash.offset.set(
            strumNote.width - (strumNote.width / 2), 
            strumNote.width - (strumNote.width / 4)
        );
    }

    override function update(elapsed) {
        super.update(elapsed);

        splash.y = strumNote.y;
        splash.x = strumNote.x;

        if (FlxG.keys.justPressed.Q) {
            color.red += 5;
        }
        if (FlxG.keys.justPressed.A) {
            color.red -= 5;
        }

        if (FlxG.keys.justPressed.W) {
            color.green += 5;
        }
        if (FlxG.keys.justPressed.S) {
            color.green -= 5;
        }

        if (FlxG.keys.justPressed.E) {
            color.blue += 5;
        }
        if (FlxG.keys.justPressed.D) {
            color.blue -= 5;
        }

        if (FlxG.keys.justPressed.UP) {
            color.saturation += 0.1;
        }
        if (FlxG.keys.justPressed.DOWN) {
            color.saturation -= 0.1;
        }

        if (FlxG.keys.justPressed.LEFT) {
            framerate -= 1;
        }
        if (FlxG.keys.justPressed.RIGHT) {
            framerate += 1;
        }

        if (FlxG.keys.justPressed.C) {
            Clipboard.set(splash.color.toWebString());
        }

        if (FlxG.keys.justPressed.V) {
            color = FlxColor.fromString(Clipboard.get());
        }


        splash.animation.curAnim.frameRate = framerate;
        splash.color = color;

        text.text = splash.color.toWebString() + "                   " + splash.animation.curAnim.frameRate;
        textRed.text = Std.string(splash.color.red);
        textGreen.text = Std.string(splash.color.green);
        textBlue.text = Std.string(splash.color.blue);
    }

	var framerate:Float = 24;

	var textRed:FlxText;

	var textGreen:FlxText;

	var textBlue:FlxText;
}

abstract SplashColor(FlxColor) from FlxColor to FlxColor {
    public static var LEFT = FlxColor.fromString("#FF9AFF");
    public static var DOWN = FlxColor.fromString("#67FFFF");
    public static var UP = FlxColor.fromString("#96FFA0");
    public static var RIGHT = FlxColor.fromString("#FF6C63");
    public static var THING = FlxColor.fromString("#FFE137");
}

class Splash extends FlxSprite {
    public var whaNote:Note;

    public function new(?note:Note, ?debug = false) {
        super();

        whaNote = note;

        frames = Paths.getSparrowAtlas('noteSplashes');
        switch (new FlxRandom().int(1, 4)) {
            case 1:
                animation.addByPrefix('splash', 'note impact 1 green', 24, false);
            case 2:
                animation.addByPrefix('splash', 'note impact 1 red', 24, false);
            case 3:
                animation.addByPrefix('splash', 'note impact 1 blue', 24, false);
            case 4:
                animation.addByPrefix('splash', 'note impact 1 purple', 24, false);
        }

        if (!debug)
            animation.finishCallback = function(name:String) {kill();};
    }

    public function play(colour:SplashColor) {
        //sorry for br`ish i felt to do that lmao
        color = colour;
        animation.play('splash');
    }

    public function updatePos() {
        if (whaNote != null) {
            if (whaNote.mustPress) {
                PlayState.currentPlaystate.bfStrumLineNotes.forEach(function(spr:FlxSprite) {
                    if (Math.abs(whaNote.noteData) == spr.ID) {
                        y = spr.y;
                        x = spr.x;
                        return;
                    }
                });
            }
            else {
                PlayState.currentPlaystate.dadStrumLineNotes.forEach(function(spr:FlxSprite) {
                    if (Math.abs(whaNote.noteData) == spr.ID) {
                        y = spr.y;
                        x = spr.x;
                        return;
                    }
                });
            }
        }
    }

    override function update(elapsed) {
        super.update(elapsed);

        updatePos();
    }
}