package;

import haxe.Json;
import sys.Http;
import OptionsSubState.Background;
import clipboard.Clipboard;
import flixel.text.FlxText;
import haxe.Exception;
import flixel.util.FlxColor;
import openfl.display.StageDisplayState;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite {
	public static inline var ENGINE_NAME:String = "PEngine"; //engine name in case i will change it lmao
	public static inline var ENGINE_VER = "v0.2b";

	public static var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	public static var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).

	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.

	//public static var framerate:Int = 69; // How many frames per second the game should run at. | use Options.framerate instead

	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void {
		Lib.current.addChild(new Main());
	}

	public function new() {
		super();

		if (stage != null) {
			init();
		}
		else {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void {
		if (hasEventListener(Event.ADDED_TO_STAGE)) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	public function setupGame():Void {
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		Options.startupSaveScript();

		if (zoom == -1) {
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end

		if (Options.updateChecker) {
			var request = new Http('https://api.github.com/repos/Paidyy/Funkin-PEngine/releases');
			request.setHeader('User-Agent', 'haxe');
			request.setHeader("Accept", "application/vnd.github.v3+json");
			request.request();
			if (!CoolUtil.isEmpty(request.responseData)) {
				//trace(request.responseData);
				gitJson = Json.parse(request.responseData);
				if (gitJson[0].tag_name != null)
					if (gitJson[0].tag_name != Main.ENGINE_VER)
						Main.outdatedVersion = true;
			}
		}

		if (Main.outdatedVersion)
			trace('Running Version: $ENGINE_VER while there\'s a newer Version: ${gitJson[0].tag_name}');

		addChild(new Game(gameWidth, gameHeight, initialState, zoom, Options.framerate, Options.framerate, skipSplash, startFullscreen));

		#if !mobile
		addChild(new EFPS());
		#end

	}

	public static var gitJson:Dynamic = null;

	public static var outdatedVersion:Bool = false;
}

class Game extends FlxGame {
	override public function update() {
		if (Options.disableCrashHandler) {
			super.update();
		}
		else {
			try {
				super.update();
			}
			catch (exc) {
				FlxG.switchState(new CrashHandler(exc));
			}
		}
	}
}

class CrashHandler extends FlxState {
	// inspired from ddlc mod and old minecraft crash handler
	var exception:Exception;
	var gf:Character;

	public function new(exc:Exception) {
		super();

		exception = exc;
	}

	override function create() {
		super.create();

		var bg = new Background(FlxColor.fromString("#696969"));
		bg.scrollFactor.set(0, 0);
		add(bg);

		var bottomText = new FlxText(0, 0, 0, "C to copy exception | ESC to send to menu");
		bottomText.scrollFactor.set(0, 0);
		bottomText.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.WHITE);
		bottomText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1);
		bottomText.screenCenter(X);
		bottomText.y = FlxG.height - bottomText.height - 10;
		add(bottomText);

		var exceptionText = new FlxText();
		exceptionText.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE);
		exceptionText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1);
		exceptionText.text = "Game has encountered a Exception!";
		exceptionText.color = FlxColor.RED;
		exceptionText.screenCenter(X);
		exceptionText.y += 20;
		add(exceptionText);

		var crashShit = new FlxText();
		crashShit.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.WHITE);
		crashShit.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1);
		crashShit.text = exception.details();
		crashShit.screenCenter(X);
		crashShit.y += exceptionText.y + exceptionText.height + 20;
		add(crashShit);

		gf = new Character(0, 0, "gf", false, true);
		gf.scrollFactor.set(0, 0);
		gf.animation.play("sad");
		add(gf);

		gf.setGraphicSize(Std.int(gf.frameWidth * 0.3));
		gf.updateHitbox();
		gf.x = FlxG.width - gf.width;
		gf.y = FlxG.height - gf.height;
	}

	override function update(elapsed) {
		if (FlxG.keys.justPressed.C) {
			Clipboard.set(exception.details());
		}

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new MainMenuState());

		if (FlxG.mouse.wheel == -1) {
			if (FlxG.keys.pressed.CONTROL)
				FlxG.camera.zoom += 0.02;
			if (FlxG.keys.pressed.SHIFT)
				FlxG.camera.scroll.x += 20;
			if (!FlxG.keys.pressed.SHIFT && !FlxG.keys.pressed.CONTROL)
				FlxG.camera.scroll.y += 20;
		}
		if (FlxG.mouse.wheel == 1) {
			if (FlxG.keys.pressed.CONTROL)
				FlxG.camera.zoom -= 0.02;
			if (FlxG.keys.pressed.SHIFT) {
				if (FlxG.camera.scroll.x > 0)
					FlxG.camera.scroll.x -= 20;
			}
			if (!FlxG.keys.pressed.SHIFT && !FlxG.keys.pressed.CONTROL) {
				if (FlxG.camera.scroll.y > 0)
					FlxG.camera.scroll.y -= 20;
			}
		}
	}
}

class EFPS extends FPS {
	override public function new() {
		super(10, 3, FlxColor.WHITE);
	}

	override public function __enterFrame(deltaTime) {
		super.__enterFrame(deltaTime);

		textColor = FlxColor.LIME;

		if (currentFPS <= Std.int(Options.framerate / 1.5)) {
			textColor = FlxColor.YELLOW;
		}
		if (currentFPS <= Std.int(Options.framerate / 3.5)) {
			textColor = FlxColor.RED;
		}
	}
}
