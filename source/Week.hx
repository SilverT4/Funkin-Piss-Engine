package;

import yaml.util.ObjectMap.AnyObjectMap;

class Week {
    public var songs:Array<String>;
    public var characters:Array<String>;
    public var storyModeName:String;
    public var id:String;
    public var config:AnyObjectMap;
    public var unlockAfter:String;

    public function new(id:String, songs:Array<String>, characters:Array<String>, storyModeName:String, ?config = null) {
        this.id = id;
        this.songs = songs;
        this.characters = characters;
        this.storyModeName = storyModeName;
        this.config = config;

        if (config != null) {
            unlockAfter = config.get("unlockedAfter");
        }
        else {
            switch (id) {
                case "week1", "week2", "week3", "week4", "week5", "week6", "week7":
                    unlockAfter = "week" + (Std.parseInt(id.substring(4)) - 1);
            }
        }
    }
}