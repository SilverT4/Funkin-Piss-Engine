package;

import openfl.display.BitmapData;
import flixel.system.FlxAssets.FlxGraphicAsset;
import yaml.util.ObjectMap.TObjectMap;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class Stage extends FlxGroup {

    public static var stagesList = [
        "stage",
        "spooky",
        "philly",
        "limo",
        "mall",
        "mallEvil",
        "school",
        "schoolEvil",
        "tank"
    ];

    public var stage:String;
    public var camZoom:Float = 0.9;

    //ASSETS
    public var halloweenBG:FlxSprite;

	public var phillyCityLights:FlxTypedGroup<FlxSprite>;
	public var phillyTrain:FlxSprite;
	public var trainSound:FlxSound;

	public var limo:FlxSprite;
	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	public var fastCar:FlxSprite;

	public var upperBoppers:FlxSprite;
	public var bottomBoppers:FlxSprite;
	public var santa:FlxSprite;

	public var bgGirls:BackgroundGirls;

	public var bgSkittles:FlxSprite;

    public var tankRolling:FlxSprite;

	public var bgTank0:FlxSprite;
	public var bgTank1:FlxSprite;
	public var bgTank2:FlxSprite;
	public var bgTank3:FlxSprite;
	public var bgTank4:FlxSprite;
	public var bgTank5:FlxSprite;

	public function new(stage:String = "stage") {
		super();

        this.stage = stage;

		switch (stage) {
            case 'stage':
                camZoom = 0.9;

                var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.stageImage('stageback', stage));
                bg.antialiasing = true;
                bg.scrollFactor.set(0.9, 0.9);
                bg.active = false;
                add(bg);

                var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.stageImage('stagefront', stage));
                stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
                stageFront.updateHitbox();
                stageFront.antialiasing = true;
                stageFront.scrollFactor.set(0.9, 0.9);
                stageFront.active = false;
                add(stageFront);

                var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.stageImage('stagecurtains', stage));
                stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
                stageCurtains.updateHitbox();
                stageCurtains.antialiasing = true;
                stageCurtains.scrollFactor.set(1.3, 1.3);
                stageCurtains.active = false;

                add(stageCurtains);
			case 'spooky':
                camZoom = 1;
                var hallowTex = Paths.stageSparrow('halloween_bg', stage);

                halloweenBG = new FlxSprite(-200, -100);
                halloweenBG.frames = hallowTex;
                halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
                halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
                halloweenBG.animation.play('idle');
                halloweenBG.antialiasing = true;
                add(halloweenBG);
			case 'philly':
                camZoom = 1.05;

                var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.stageImage('sky', stage));
                bg.scrollFactor.set(0.1, 0.1);
                add(bg);

                var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.stageImage('city', stage));
                city.scrollFactor.set(0.3, 0.3);
                city.setGraphicSize(Std.int(city.width * 0.85));
                city.updateHitbox();
                add(city);

                phillyCityLights = new FlxTypedGroup<FlxSprite>();
                add(phillyCityLights);

                for (i in 0...5) {
                    var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.stageImage('win' + i, stage));
                    light.scrollFactor.set(0.3, 0.3);
                    light.visible = false;
                    light.setGraphicSize(Std.int(light.width * 0.85));
                    light.updateHitbox();
                    light.antialiasing = true;
                    phillyCityLights.add(light);
                }

                var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.stageImage('behindTrain', stage));
                add(streetBehind);

                phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.stageImage('train', stage));
                add(phillyTrain);

                trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
                FlxG.sound.list.add(trainSound);

                // var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

                var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.stageImage('street', stage));
                add(street);
			case 'limo':
                camZoom = 0.9;

                var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.stageImage('limoSunset', stage));
                skyBG.scrollFactor.set(0.1, 0.1);
                add(skyBG);

                var bgLimo:FlxSprite = new FlxSprite(-200, 480);
                bgLimo.frames = Paths.stageSparrow('bgLimo', stage);
                bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
                bgLimo.animation.play('drive');
                bgLimo.scrollFactor.set(0.4, 0.4);
                add(bgLimo);

                grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
                add(grpLimoDancers);

                for (i in 0...5) {
                    var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
                    dancer.scrollFactor.set(0.4, 0.4);
                    grpLimoDancers.add(dancer);
                }

                var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.stageImage('limoOverlay', stage));
                overlayShit.alpha = 0.5;
                // add(overlayShit);

                // var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

                // FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

                // overlayShit.shader = shaderBullshit;

                var limoTex = Paths.stageSparrow('limoDrive', stage);

                limo = new FlxSprite(-120, 550);
                limo.frames = limoTex;
                limo.animation.addByPrefix('drive', "Limo stage", 24);
                limo.animation.play('drive');
                limo.antialiasing = true;

                fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.stageImage('fastCarLol', stage));
                // add(limo);
			case 'mall':
                camZoom = 0.8;

                var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.stageImage('bgWalls', stage));
                bg.antialiasing = true;
                bg.scrollFactor.set(0.2, 0.2);
                bg.active = false;
                bg.setGraphicSize(Std.int(bg.width * 0.8));
                bg.updateHitbox();
                add(bg);

                upperBoppers = new FlxSprite(-240, -90);
                upperBoppers.frames = Paths.stageSparrow('upperBop', stage);
                upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
                upperBoppers.antialiasing = true;
                upperBoppers.scrollFactor.set(0.33, 0.33);
                upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
                upperBoppers.updateHitbox();
                add(upperBoppers);

                var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.stageImage('bgEscalator', stage));
                bgEscalator.antialiasing = true;
                bgEscalator.scrollFactor.set(0.3, 0.3);
                bgEscalator.active = false;
                bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
                bgEscalator.updateHitbox();
                add(bgEscalator);

                var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.stageImage('christmasTree', stage));
                tree.antialiasing = true;
                tree.scrollFactor.set(0.40, 0.40);
                add(tree);

                bottomBoppers = new FlxSprite(-300, 140);
                bottomBoppers.frames = Paths.stageSparrow('bottomBop', stage);
                bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
                bottomBoppers.antialiasing = true;
                bottomBoppers.scrollFactor.set(0.9, 0.9);
                bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
                bottomBoppers.updateHitbox();
                add(bottomBoppers);

                var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.stageImage('fgSnow', stage));
                fgSnow.active = false;
                fgSnow.antialiasing = true;
                add(fgSnow);

                santa = new FlxSprite(-840, 150);
                santa.frames = Paths.stageSparrow('santa', stage);
                santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
                santa.antialiasing = true;
                add(santa);
			case 'mallEvil':
                camZoom = 1.1;
                var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.stageImage('evilBG', stage));
                bg.antialiasing = true;
                bg.scrollFactor.set(0.2, 0.2);
                bg.active = false;
                bg.setGraphicSize(Std.int(bg.width * 0.8));
                bg.updateHitbox();
                add(bg);

                var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.stageImage('evilTree', stage));
                evilTree.antialiasing = true;
                evilTree.scrollFactor.set(0.2, 0.2);
                add(evilTree);

                var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.stageImage("evilSnow", stage));
                evilSnow.antialiasing = true;
                add(evilSnow);
			case 'school':
                // defaultCamZoom = 0.9;

                var bgSky = new FlxSprite().loadGraphic(Paths.stageImage('weebSky', stage));
                bgSky.scrollFactor.set(0.1, 0.1);
                add(bgSky);

                var repositionShit = -200;

                var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.stageImage('weebSchool', stage));
                bgSchool.scrollFactor.set(0.6, 0.90);
                add(bgSchool);

                var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.stageImage('weebStreet', stage));
                bgStreet.scrollFactor.set(0.95, 0.95);
                add(bgStreet);

                var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.stageImage('weebTreesBack', stage));
                fgTrees.scrollFactor.set(0.9, 0.9);
                add(fgTrees);

                var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
                var treetex = Paths.stagePacker('weebTrees', stage);
                bgTrees.frames = treetex;
                bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
                bgTrees.animation.play('treeLoop');
                bgTrees.scrollFactor.set(0.85, 0.85);
                add(bgTrees);

                var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
                treeLeaves.frames = Paths.stageSparrow('petals', stage);
                treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
                treeLeaves.animation.play('leaves');
                treeLeaves.scrollFactor.set(0.85, 0.85);
                add(treeLeaves);

                var widShit = Std.int(bgSky.width * 6);

                bgSky.setGraphicSize(widShit);
                bgSchool.setGraphicSize(widShit);
                bgStreet.setGraphicSize(widShit);
                bgTrees.setGraphicSize(Std.int(widShit * 1.4));
                fgTrees.setGraphicSize(Std.int(widShit * 0.8));
                treeLeaves.setGraphicSize(widShit);

                fgTrees.updateHitbox();
                bgSky.updateHitbox();
                bgSchool.updateHitbox();
                bgStreet.updateHitbox();
                bgTrees.updateHitbox();
                treeLeaves.updateHitbox();

                bgGirls = new BackgroundGirls(-100, 190);
                bgGirls.scrollFactor.set(0.9, 0.9);

                if (PlayState.SONG.song.toLowerCase() == 'roses') {
                    bgGirls.getScared();
                }

                bgGirls.setGraphicSize(Std.int(bgGirls.width * PlayState.daPixelZoom));
                bgGirls.updateHitbox();
                add(bgGirls);
			case 'schoolEvil':
                //var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
                //var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

                var posX = 400;
                var posY = 200;

                var bg:FlxSprite = new FlxSprite(posX, posY);
                bg.frames = Paths.stageSparrow('animatedEvilSchool', stage);
                bg.animation.addByPrefix('idle', 'background 2', 24);
                bg.animation.play('idle');
                bg.scrollFactor.set(0.8, 0.9);
                bg.scale.set(6, 6);
                add(bg);

                /* 
                    var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('evilSchoolBG'));
                    bg.scale.set(6, 6);
                    // bg.setGraphicSize(Std.int(bg.width * 6));
                    // bg.updateHitbox();
                    add(bg);

                    var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('evilSchoolFG'));
                    fg.scale.set(6, 6);
                    // fg.setGraphicSize(Std.int(fg.width * 6));
                    // fg.updateHitbox();
                    add(fg);

                    wiggleShit.effectType = WiggleEffectType.DREAMY;
                    wiggleShit.waveAmplitude = 0.01;
                    wiggleShit.waveFrequency = 60;
                    wiggleShit.waveSpeed = 0.8;
                    */

                // bg.shader = wiggleShit.shader;
                // fg.shader = wiggleShit.shader;

                /* 
                    var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
                    var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

                    // Using scale since setGraphicSize() doesnt work???
                    waveSprite.scale.set(6, 6);
                    waveSpriteFG.scale.set(6, 6);
                    waveSprite.setPosition(posX, posY);
                    waveSpriteFG.setPosition(posX, posY);

                    waveSprite.scrollFactor.set(0.7, 0.8);
                    waveSpriteFG.scrollFactor.set(0.9, 0.8);

                    // waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
                    // waveSprite.updateHitbox();
                    // waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
                    // waveSpriteFG.updateHitbox();

                    add(waveSprite);
                    add(waveSpriteFG);
                    */
			case 'tank':
				camZoom = 0.95;

				var tankSky:FlxSprite = new FlxSprite(-60, -400).loadGraphic(Paths.stageImage('tankSky', stage));
				tankSky.setGraphicSize(Std.int(tankSky.width * 1.3));
				tankSky.antialiasing = true;
				tankSky.active = false;
				add(tankSky);

				var tankMountains:FlxSprite = new FlxSprite(-20, 180).loadGraphic(Paths.stageImage('tankMountains', stage));
				tankMountains.setGraphicSize(Std.int(tankMountains.width * 1.3));
				tankMountains.antialiasing = true;
				tankMountains.scrollFactor.set(0.4, 0.9);
				tankMountains.active = false;
				add(tankMountains);

				var tankBuildings:FlxSprite = new FlxSprite(-190, 130).loadGraphic(Paths.stageImage('tankBuildings', stage));
				tankBuildings.setGraphicSize(Std.int(tankBuildings.width * 1.15));
				tankBuildings.antialiasing = true;
				tankBuildings.scrollFactor.set(0.4, 0.9);
				tankBuildings.active = false;
				add(tankBuildings);

				var tankRuins:FlxSprite = new FlxSprite(-210, 140).loadGraphic(Paths.stageImage('tankRuins', stage));
				tankRuins.setGraphicSize(Std.int(tankRuins.width * 1.15));
				tankRuins.antialiasing = true;
				tankRuins.scrollFactor.set(0.4, 0.9);
				tankRuins.active = false;
				add(tankRuins);

				bgSkittles = new FlxSprite(0, 0);
				bgSkittles.frames = Paths.stageSparrow('tankWatchtower', stage);
				bgSkittles.animation.addByPrefix('bop', "watchtower gradient color instance 1", 24, false);
				bgSkittles.antialiasing = true;
				bgSkittles.scrollFactor.set(0.3, 0.6);
				add(bgSkittles);

				var smokeLeft:FlxSprite = new FlxSprite(-200, -130);
				smokeLeft.frames = Paths.stageSparrow('smokeLeft', stage);
				smokeLeft.animation.addByPrefix('smoke', 'SmokeBlurLeft instance 1', 24);
				smokeLeft.animation.play('smoke');
				smokeLeft.scrollFactor.set(0.4, 0.4);
				add(smokeLeft);

				var smokeRight:FlxSprite = new FlxSprite(1200, 0);
				smokeRight.frames = Paths.stageSparrow('smokeRight', stage);
				smokeRight.animation.addByPrefix('smoke', 'SmokeRight instance 1', 24);
				smokeRight.animation.play('smoke');
				smokeRight.scrollFactor.set(0.4, 0.4);
				add(smokeRight);

				tankRolling = new FlxSprite();
				tankRolling.frames = Paths.stageSparrow('tankRolling', stage);
				tankRolling.animation.addByPrefix('rollin', 'BG tank w lighting instance 1', 24);
				tankRolling.animation.play('rollin');
				tankRolling.scrollFactor.set(0.8, 0.8);
				add(tankRolling);
				tankRolling.kill();

				var tankGround = new FlxSprite(-240, -110).loadGraphic(Paths.stageImage('tankGround', stage));
				tankGround.setGraphicSize(Std.int(tankGround.width * 1.1));
				tankGround.scrollFactor.set(0.9, 0.9);
				add(tankGround);

				bgTank0 = new FlxSprite(-300, 470);
				bgTank0.frames = Paths.stageSparrow('tank0', stage);
				bgTank0.animation.addByPrefix('bop', "fg tankhead far right instance 1", 24, false);
				bgTank0.antialiasing = true;

				bgTank1 = new FlxSprite(-30, 840);
				bgTank1.frames = Paths.stageSparrow('tank1', stage);
				bgTank1.animation.addByPrefix('bop', "fg tankhead 5 instance 1", 24, false);
				bgTank1.antialiasing = true;

				bgTank2 = new FlxSprite(440, 780);
				bgTank2.frames = Paths.stageSparrow('tank2', stage);
				bgTank2.animation.addByPrefix('bop', "foreground man 3 instance 1", 24, false);
				bgTank2.antialiasing = true;

				bgTank3 = new FlxSprite(890, 830);
				bgTank3.frames = Paths.stageSparrow('tank3', stage);
				bgTank3.animation.addByPrefix('bop', "fg tankhead 4 instance 1", 24, false);
				bgTank3.antialiasing = true;

				bgTank4 = new FlxSprite(1250, 760);
				bgTank4.frames = Paths.stageSparrow('tank4', stage);
				bgTank4.animation.addByPrefix('bop', "fg tankman bobbin 3 instance 1", 24, false);
				bgTank4.antialiasing = true;

				bgTank5 = new FlxSprite(1450, 460);
				bgTank5.frames = Paths.stageSparrow('tank5', stage);
				bgTank5.animation.addByPrefix('bop', "fg tankhead far right instance 1", 24, false);
				bgTank5.antialiasing = true;

				bgTank0.scrollFactor.set(1.1, 1);
				bgTank1.scrollFactor.set(1.6, 1);
				bgTank2.scrollFactor.set(2.0, 1);
				bgTank3.scrollFactor.set(2.6, 1);
				bgTank4.scrollFactor.set(1.6, 1);
				bgTank5.scrollFactor.set(1.1, 1);
            default:
                if (SysFile.exists('mods/stages/$stage/')) {
                    var config = CoolUtil.readYAML('mods/stages/$stage/config.yml');

                    if (config.get("zoom") != null) camZoom = Std.parseFloat(Std.string(config.get("zoom")));
                    
                    if (config != null) {
                        var map:TObjectMap<Dynamic, Dynamic> = config.get('images');
                        for (image in map.keys()) {
                            var keys = config.get('images').get(image);
                            var stageSprite = new FlxSprite(0, 0).loadGraphic(BitmapData.fromBytes(SysFile.getBytes('mods/stages/$stage/images/$image.png')));
                            if (keys != null) {
                                if (keys.get("x") != null) stageSprite.x = keys.get("x");
                                if (keys.get("y") != null) stageSprite.y = keys.get("y");
                                if (keys.get("size") != null) stageSprite.setGraphicSize(Std.int(stageSprite.width * keys.get("size")));
                                if (keys.get("scrollFactorX") != null) stageSprite.scrollFactor.x = keys.get("scrollFactorX");
                                if (keys.get("scrollFactorY") != null) stageSprite.scrollFactor.y = keys.get("scrollFactorY");
                            }
                            add(stageSprite);
                        }
                    }
                }
		}
	}
}
