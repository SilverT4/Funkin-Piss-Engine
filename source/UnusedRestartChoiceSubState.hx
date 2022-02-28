package;

import flixel.FlxSubState;
import flixel.FlxGame;
import lime.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/*


	THIS IS UNUSED
	used this because i was dumb 💀


 */
class RestartChoiceSubState extends FlxSubState {
	var selector:FlxSprite;
	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	public function new() {
		super();

		grpOptionsTexts = new FlxTypedGroup<FlxText>();
		add(grpOptionsTexts);

		selector = new FlxSprite().makeGraphic(5, 5, FlxColor.TRANSPARENT);
		add(selector);

		var yes:FlxText = new FlxText(0, 0, 0, "Yes", 32);
		yes.screenCenter(X);
		yes.y += 440;
		yes.x -= 150;
		yes.ID = 0;
		grpOptionsTexts.add(yes);

		var no:FlxText = new FlxText(0, 0, 0, "No", 32);
		no.screenCenter(X);
		no.y = yes.y;
		no.x += 150;
		no.ID = 1;
		grpOptionsTexts.add(no);

		var tit:FlxText = new FlxText(0, 0, 0, "This setting requires restart to take effect!", 32);
		tit.screenCenter(X);
		tit.y += 230;
		grpOptionsTexts.add(tit);

		var tit2:FlxText = new FlxText(0, 0, 0, "Exit the game?", 32);
		tit2.screenCenter(X);
		tit2.y = tit.y + 40;
		grpOptionsTexts.add(tit2);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.LEFT) {
			if (curSelected != 0) {
				curSelected = 0;
			}
			else {
				curSelected = 1;
			}
		}
		if (FlxG.keys.justPressed.RIGHT) {
			if (curSelected != 1) {
				curSelected = 1;
			}
			else {
				curSelected = 0;
			}
		}

		grpOptionsTexts.forEach(function(txt:FlxText) {
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
				txt.color = FlxColor.YELLOW;
		});

		if (FlxG.keys.justPressed.ENTER) {
			switch (curSelected) {
				case 0: // Yes
					System.exit(0);
				case 1: // No
					close();
			}
		}
	}
}
