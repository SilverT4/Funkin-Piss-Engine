package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBoxOg extends FlxSpriteGroup {
	public var box:FlxSprite;

	var curCharacter:String = '';

	public var dialogue:Alphabet;
	var dialogueList:Array<String> = [];
	var dropText:FlxText;

	public var finishThing:Void->Void;

	private var talkingRight:Bool = false;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var hasDialog:Bool;

	public function new(?dialogueList:Array<String>, ?hasDialog = true) {
		super();

		this.hasDialog = hasDialog;

		box = new FlxSprite(0, 45);
		
		box.frames = Paths.getSparrowAtlas('dialogue/speech_bubble_talking');
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByIndices('normal', 'speech bubble normal', [0, 5, 10, 15], "", 6);
		box.setGraphicSize(Std.int(box.width * 0.9));

		/*
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;

			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
			*/

			box.animation.play('normalOpen');
			// box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
			box.updateHitbox();
			box.y = FlxG.height - box.frameHeight;
			box.scrollFactor.set();
			add(box);
	
			box.screenCenter(X);
			box.x += 40;
			// portraitLeft.screenCenter(X);

		if (dialogueList != null) {
			if (!hasDialog)
				return;

			this.dialogueList = dialogueList;

			if (dialogueList[0].contains(":dad:")) {
				box.flipX = true;
			}
	
			dialogue = new Alphabet(0, 80, "", false, true);
			// dialogue.x = 90;
			// add(dialogue);
	
			// set this state camera to camStatic
			cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		}
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float) {
		if (!hasDialog) {
			dialogueOpened = false;
			dialogueStarted = false;
		}
		if (box.animation.curAnim != null) {
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished) {
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted) {
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueStarted) {
			remove(dialogue);

			FlxG.sound.play(Paths.sound('dialogueClose'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null) {
				if (!isEnding) {
					isEnding = true;

					new FlxTimer().start(0.2, function(tmr:FlxTimer) {
						box.alpha -= 1 / 5;
						// bgFade.alpha -= 1 / 5 * 0.7;
						// portraitLeft.visible = false;
						// portraitRight.visible = false;
						theDialog.alpha -= 1 / 5;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer) {
						finishThing();
						kill();
					});
				}
			}
			else {
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void {
		cleanDialog();

		if (theDialog != null)
			remove(theDialog);

		/*
		// this adds breaks to text so you dont have to lazy bitch
		// also needs to be rewritten
		var textLength = 0;
		var num = -1;
		var dialogueWords = dialogueList[0].split(" ");
		for (s in dialogueList[0].split(" ")) {
			num += 1;
			textLength = s.split("").length + textLength;
			// trace(s + " |  text length = " + textLength);
			if (textLength >= 34) {
				dialogueWords[num - 1] += "\n";
				textLength = 0;
			}
		}
		dialogueList[0] = "";
		for (s in dialogueWords) {
			if (s.endsWith("\n")) {
				dialogueList[0] += s;
			} else {
				dialogueList[0] += s + " ";
			}
		}
		*/

		theDialog = new Alphabet(box.x + 40, 420, dialogueList[0], false, true, 0.7);
		add(theDialog);

		switch (curCharacter) {
			case 'dad':
			/*
				portraitRight.visible = false; 
				if (!portraitLeft.visible) {
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			 */
			case 'bf':
				/*
					portraitLeft.visible = false;
					if (!portraitRight.visible) {
						portraitRight.visible = true;
						portraitRight.animation.play('enter');
					}
				 */
		}
		if (!talkingRight) {
			box.flipX = true;
		}
		else {
			box.flipX = false;
		}
	}

	function cleanDialog():Void {
		var splitName:Array<String> = dialogueList[0].split(":");
		var splitNameSplit:Array<String> = splitName[1].split(",");
		curCharacter = splitNameSplit[0];
		talkingRight = CoolUtil.strToBool(splitNameSplit[1]);
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}

	public var theDialog:Alphabet;
}
