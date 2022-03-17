package;

import flixel.util.FlxColor;
import clipboard.Clipboard;
import openfl.events.KeyboardEvent;
import flixel.FlxG;
import openfl.ui.Keyboard;
import flixel.addons.ui.FlxUIInputText;

class UIInputText extends FlxUIInputText {

	// FlxUIInputText but with cool shit

	var selectedEverything = false;
	var previousText = "";
	var previousIndex = 0;

    override function update(elapsed) {
        super.update(elapsed);

        if (FlxG.mouse.pressed || FlxG.mouse.pressedRight || FlxG.mouse.pressedMiddle)
            selectedEverything = false;

        if (selectedEverything) {
            set_backgroundColor(FlxColor.fromString("#1470cc"));
            set_color(FlxColor.WHITE);
        } else {
            set_backgroundColor(FlxColor.WHITE);
            set_color(FlxColor.BLACK);
        }
    }

	override function onKeyDown(e:KeyboardEvent) {
		var key:Int = e.keyCode;

		if (hasFocus) {
            if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.A)
                selectedEverything = true;

			if (key == Keyboard.BACKSPACE) {
				if (selectedEverything) {
					saveUndoShit();

					text = "";
					caretIndex = 0;
					selectedEverything = false;
                    onChange(INPUT_ACTION);
				}
			}

			if (FlxG.keys.pressed.CONTROL) {
				switch (key) {
					case Keyboard.C:
						if (selectedEverything)
							Clipboard.set(text);
					case Keyboard.V:
						selectedEverything = false;

						var clipboard = Clipboard.get();
						if (clipboard.length > 0 && (maxLength == 0 || (text.length + clipboard.length) < maxLength)) {
							saveUndoShit();

							text = insertSubstring(text, clipboard, caretIndex);
							caretIndex += clipboard.length;
							onChange(INPUT_ACTION);
						}
					case Keyboard.Z:
						text = previousText;
						caretIndex = previousIndex;
                        onChange(INPUT_ACTION);
				}
			}
			else {
				selectedEverything = false;
				ogOnKeyDown(e);
			}
		}
	}

	function saveUndoShit() {
		previousText = text;
		previousIndex = caretIndex;
	}

    public static inline var BACKSPACE_ACTION:String = "backspace"; // press backspace
	public static inline var DELETE_ACTION:String = "delete"; // press delete
	public static inline var ENTER_ACTION:String = "enter"; // press enter
	public static inline var INPUT_ACTION:String = "input"; // manually edit

	private function ogOnKeyDown(e:KeyboardEvent):Void {
		var key:Int = e.keyCode;

		if (hasFocus) {
			// Do nothing for Shift, Ctrl, Esc, and flixel console hotkey
			if (key == 16 || key == 17 || key == 220 || key == 27) {
				return;
			}
			// Left arrow
			else if (key == 37) {
				if (caretIndex > 0) {
					caretIndex--;
					text = text; // forces scroll update
				}
			}
			// Right arrow
			else if (key == 39) {
				if (caretIndex < text.length) {
					caretIndex++;
					text = text; // forces scroll update
				}
			}
			// End key
			else if (key == 35) {
				caretIndex = text.length;
				text = text; // forces scroll update
			}
			// Home key
			else if (key == 36) {
				caretIndex = 0;
				text = text;
			}
			// Backspace
			else if (key == 8) {
				if (caretIndex > 0) {
                    saveUndoShit();
					caretIndex--;
					text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
					onChange(BACKSPACE_ACTION);
				}
			}
			// Delete
			else if (key == 46) {
				if (text.length > 0 && caretIndex < text.length) {
                    saveUndoShit();
					text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
					onChange(DELETE_ACTION);
				}
			}
			// Enter
			else if (key == 13) {
				onChange(ENTER_ACTION);
			}
			// Actually add some text
			else {
				if (e.charCode == 0) // non-printable characters crash String.fromCharCode
				{
					return;
				}
				var newText:String = filter(String.fromCharCode(e.charCode));

				if (newText.length > 0 && (maxLength == 0 || (text.length + newText.length) < maxLength)) {
                    saveUndoShit();
					text = insertSubstring(text, newText, caretIndex);
					caretIndex++;
					onChange(INPUT_ACTION);
				}
			}
		}
	}
}
