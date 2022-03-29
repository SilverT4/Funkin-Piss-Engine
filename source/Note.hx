package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

using StringTools;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end


class Note extends FlxSprite {
	var daStage:String;

	//NOTE DATA
	public var noteData:Int = 0;
	public var action:String = "";
	public var actionValue:String = "";
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var isGoodNote:Bool = true;
	public var canBeMissed:Bool = false;

	//INPUT SHIT

	/** blocks action notes from doing anything */
	public var blockActions:Bool = false;

	/** the position of note in song */
	public var strumTime:Float = 0;

	/** `true` if the note is for boyfriend */
	public var mustPress:Bool = false;

	/** `true` when the note is on the song position that can be hit */
	public var canBeHit:Bool = false;

	/** `true` when it missed the strum line */
	public var tooLate:Bool = false;

	/** `true` if the note `strumTime` equals or is higher than current song position. works only for dad note */
	public var wasGoodHit:Bool = false;

	/** `true` if the note `strumTime` equals or is higher than current song position */
	public var wasGoodHitButt:Bool = false;

	//OTHER
	public var prevNote:Note;

	public var noteScore:Float = 1;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public static function getSwagWidth(?whichK:Int = 4):Float {
		switch (whichK) {
			case 4:
				return 160 * 0.7;
			case 6:
				return 160 * 0.55;
			default:
				return 160 * 0.7;
		}
	}

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?action:String, ?actionValue:String) {
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		if (action != null) {
			this.action = action;
			this.actionValue = actionValue;
		}
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;
		
		daStage = PlayState.stage.stage;

		switch (action.toLowerCase()) {
			case("ebola"):
				canBeMissed = true;
				isGoodNote = false;
				noteAsset(true, "eNotes");
			case("damage"):
				canBeMissed = true;
				isGoodNote = false;
				noteAsset(true, "damageNotes");
			default:
				noteAsset();
		}
		
		x += getSwagWidth(PlayState.SONG.whichK) * noteData;
		if (PlayState.SONG.whichK == 6) {
			switch (noteData) {
				case 0:
					animation.play('purpleScroll');
				case 1:
					animation.play('greenScroll');
				case 2:
					animation.play('redScroll');
				
				case 3:
					animation.play('purpleScroll');
				case 4:
					animation.play('blueScroll');
				case 5:
					animation.play('redScroll');
			}
		} else {
			switch (noteData) {
				case 0:
					animation.play('purpleScroll');
				case 1:
					animation.play('blueScroll');
				case 2:
					animation.play('greenScroll');
				case 3:
					animation.play('redScroll');
			}
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null) {
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;
			if (PlayState.SONG.whichK == 6) {
				switch (noteData) {
					case 0:
						animation.play('purpleholdend');
					case 1:
						animation.play('greenholdend');
					case 2:
						animation.play('redholdend');
					
					case 3:
						animation.play('purpleholdend');
					case 4:
						animation.play('blueholdend');
					case 5:
						animation.play('redholdend');
				}
			} else {
				switch (noteData) {
					case 0:
						animation.play('purpleholdend');
					case 1:
						animation.play('blueholdend');
					case 2:
						animation.play('greenholdend');
					case 3:
						animation.play('redholdend');
				}
			}

			updateHitbox();

			x -= width / 2;

			if (daStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote) {
				if (PlayState.SONG.whichK == 6) {
					switch (noteData) {
						case 0:
							prevNote.animation.play('purplehold');
						case 1:
							prevNote.animation.play('greenhold');
						case 2:
							prevNote.animation.play('redhold');
						
						case 3:
							prevNote.animation.play('purplehold');
						case 4:
							prevNote.animation.play('bluehold');
						case 5:
							prevNote.animation.play('redhold');
					}
				} else {
					switch (prevNote.noteData) {
						case 0:
							prevNote.animation.play('purplehold');
						case 1:
							prevNote.animation.play('bluehold');
						case 2:
							prevNote.animation.play('greenhold');
						case 3:
							prevNote.animation.play('redhold');
					}
				}

				if (PlayState.SONG.whichK == 6) {
					prevNote.scale.y *= (Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed * PlayState.SONG.whichK / 4.7);
				} else {
					prevNote.scale.y *= (Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed);
				}
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	function noteAsset(?custom:Bool = false, ?name:String) {
		if (custom == true && name != null) {
			frames = Paths.getSparrowAtlas(name);

			animation.addByPrefix('greenScroll', 'green0');
			animation.addByPrefix('redScroll', 'red0');
			animation.addByPrefix('blueScroll', 'blue0');
			animation.addByPrefix('purpleScroll', 'purple0');

			animation.addByPrefix('purpleholdend', 'pruple end hold');
			animation.addByPrefix('greenholdend', 'green hold end');
			animation.addByPrefix('redholdend', 'red hold end');
			animation.addByPrefix('blueholdend', 'blue hold end');

			animation.addByPrefix('purplehold', 'purple hold piece');
			animation.addByPrefix('greenhold', 'green hold piece');
			animation.addByPrefix('redhold', 'red hold piece');
			animation.addByPrefix('bluehold', 'blue hold piece');

			if (PlayState.SONG.whichK == 6) {
				setGraphicSize(Std.int(width * 0.55));
			} else {
				setGraphicSize(Std.int(width * 0.7));
			}
			updateHitbox();
			antialiasing = true;
		} else {
			switch (daStage) {
				case 'school' | 'schoolEvil':
					loadGraphic(Paths.image('pixelUI/arrows-pixels'), true, 17, 17);
	
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);
	
					if (isSustainNote) {
						loadGraphic(Paths.image('pixelUI/arrowEnds'), true, 7, 6);
	
						animation.add('purpleholdend', [4]);
						animation.add('greenholdend', [6]);
						animation.add('redholdend', [7]);
						animation.add('blueholdend', [5]);
	
						animation.add('purplehold', [0]);
						animation.add('greenhold', [2]);
						animation.add('redhold', [3]);
						animation.add('bluehold', [1]);
					}
	
					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
	
				default:
					frames = Paths.getSparrowAtlas('NOTE_assets');
	
					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');
	
					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');
	
					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');
					
					if (PlayState.SONG.whichK == 6) {
						setGraphicSize(Std.int(width * 0.55));
					} else {
						setGraphicSize(Std.int(width * 0.7));
					}
					updateHitbox();
					antialiasing = true;
			}
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (isSustainNote && PlayState.currentPlaystate.downscroll) {
			flipY = true;
		}

		// The * 0.5 is so that it's easier to hit them too late, instead of too early
		if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset && strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
			canBeHit = true;
		else
			canBeHit = false;

		if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
			tooLate = true;

		if (!mustPress) {
			if (PlayState.playAs == "bf") {
				canBeHit = false;
				if (strumTime <= Conductor.songPosition)
					wasGoodHit = true;
			}
		}

		if (strumTime <= Conductor.songPosition)
			wasGoodHitButt = true;

		if (tooLate) {
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
