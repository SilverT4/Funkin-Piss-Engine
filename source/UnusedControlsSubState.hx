package;

import Controls.Control;
import openfl.display.Preloader.DefaultPreloader;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ControlsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['Left', 'Down', 'Up', 'Right'];

	var selector:FlxSprite;
	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	public function new()
	{
		super();

		grpOptionsTexts = new FlxTypedGroup<FlxText>();
		add(grpOptionsTexts);

		selector = new FlxSprite().makeGraphic(5, 5, FlxColor.RED);
		add(selector);

		for (i in 0...textMenuItems.length)
		{
			var optionText:FlxText = new FlxText(20, 20 + (i * 50), 0, textMenuItems[i], 32);
			optionText.ID = i;
			var settings:PlayerSettings = PlayerSettings.player1;
			switch (optionText.text) {
				case "Left":
					grpOptionsTexts.add(new FlxText(20, 20 + (i * 50), 0, textMenuItems[i] + "    " + PlayerSettings.player1.controls.LEFT, 32));
				case "Down":
					//grpOptionsTexts.add(new FlxText(20, 20 + (i * 50), 0, textMenuItems[i] + "    " + controls, 32));
				case "Up":
					//grpOptionsTexts.add(new FlxText(20, 20 + (i * 50), 0, textMenuItems[i] + "    " + controls, 32));
				case "Right":
					//grpOptionsTexts.add(new FlxText(20, 20 + (i * 50), 0, textMenuItems[i] + "    " + controls, 32));
				default:
					grpOptionsTexts.add(new FlxText(20, 20 + (i * 50), 0, textMenuItems[i], 32));
			}
			
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UP_P)
			curSelected -= 1;

		if (controls.DOWN_P)
			curSelected += 1;

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;

		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		grpOptionsTexts.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
				txt.color = FlxColor.YELLOW;
		});

		if (controls.ACCEPT)
		{
			switch (textMenuItems[curSelected])
			{
				case "Left":
				case "Down":
				case "Up":
				case "Right":
			}
		}
	}
}