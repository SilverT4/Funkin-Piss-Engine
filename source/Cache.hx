package;

/**
 * Class that caches game assets
 */
class Cache {
    public static var characters:Map<String, Character> = new Map<String, Character>();
	public static var bfs:Map<String, Boyfriend> = new Map<String, Boyfriend>();

    public static var stages:Map<String, Stage> = new Map<String, Stage>();

    public static function cacheCharacter(char, daChar) {
		if (char == "bf") {
            if (!Cache.bfs.exists(daChar)) {
                trace("caching character (boyfriend): " + daChar + "...");
                Cache.bfs.set(daChar, new Boyfriend(0, 0, daChar));
            }
		} else {
            if (!Cache.characters.exists(daChar)) {
                trace("caching character: " + daChar + "...");
                Cache.characters.set(daChar, new Character(0, 0, daChar));
            }
		}
	}

    public static function cacheStage(name) {
        if (!Cache.stages.exists(name)) {
            Cache.stages.set(name, new Stage(name));
        }
    }
}