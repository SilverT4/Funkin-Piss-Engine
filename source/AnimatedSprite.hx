import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;

/**
 * Sprite with offsets for animations
 */
class AnimatedSprite extends FlxSprite {
	public var animOffsets:Map<String, Array<Dynamic>>;

    public function new(X:Float = 0, Y:Float = 0) {
        super(X, Y);

        animOffsets = new Map<String, Array<Dynamic>>();
    }

	/**
	 * Plays anim on this sprite with also offsetting it
	 * @param name the animation name
	 * @param force force to play this animation?
	 * @param reversed should it start from last frame and end on first
	 * @param frame starting frame
	 */
	public function playAnim(name:String, force:Bool = false, reversed:Bool = false, frame:Int = 0) {
		animation.play(name, force, reversed, frame);

        if (animOffsets != null) {
            var daOffset = animOffsets.get(name);
            if (animOffsets.exists(name))
                offset.set(daOffset[0], daOffset[1]);
            else
                offset.set(0, 0);
        }
	}

	/**
	 * Sets the offset of specific animation
	 * @param name animation name
	 * @param x x that would be subtracted from animation x
	 * @param y y that would be subtracted from animation y
	 */
	public function setOffset(name:String, x:Float = 0, y:Float = 0) {
		animOffsets[name] = [x, y];
	}
}