package;

import flixel.FlxSprite;
import openfl.display.BitmapData;
import flixel.system.FlxAssets.FlxGraphicAsset;
import yaml.util.ObjectMap.TObjectMap;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class Stage extends FlxTypedGroup<Dynamic> {

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


    //Character position for current stage
    public var gfX:Float = 400;
    public var gfY:Float = 130;

    public var dadX:Float = 100;
    public var dadY:Float = 100;

    public var bfX:Float = 770;
    public var bfY:Float = 450;

    //ASSETS
    public var halloweenBG:StageAsset;

	public var phillyCityLights:FlxTypedGroup<StageAsset>;
	public var phillyTrain:StageAsset;
	public var trainSound:FlxSound;

	public var limo:StageAsset;
	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	public var fastCar:StageAsset;

	public var upperBoppers:StageAsset;
	public var bottomBoppers:StageAsset;
	public var santa:StageAsset;

	public var bgGirls:BackgroundGirls;

	public var bgSkittles:StageAsset;

    public var tankRolling:StageAsset;

	public var bgTank0:StageAsset;
	public var bgTank1:StageAsset;
	public var bgTank2:StageAsset;
	public var bgTank3:StageAsset;
	public var bgTank4:StageAsset;
	public var bgTank5:StageAsset;

	public function new(stage:String = "stage") {
		super();

        this.stage = stage;

		switch (stage) {
            case 'stage':
                camZoom = 0.9;

                var bg:StageAsset = new StageAsset(-600, -200, 'stageback').loadGraphic(Paths.stageImage('stageback', stage));
                bg.antialiasing = true;
                bg.scrollFactor.set(0.9, 0.9);
                bg.active = false;
                add(bg);

                var stageFront:StageAsset = new StageAsset(-650, 600, 'stagefront').loadGraphic(Paths.stageImage('stagefront', stage));
                stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
                stageFront.updateHitbox();
                stageFront.antialiasing = true;
                stageFront.scrollFactor.set(0.9, 0.9);
                stageFront.active = false;
                add(stageFront);

                var stageCurtains:StageAsset = new StageAsset(-500, -300, 'stagecurtains').loadGraphic(Paths.stageImage('stagecurtains', stage));
                stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
                stageCurtains.updateHitbox();
                stageCurtains.antialiasing = true;
                stageCurtains.scrollFactor.set(1.3, 1.3);
                stageCurtains.active = false;

                add(stageCurtains);
			case 'spooky':
                camZoom = 1;
                var hallowTex = Paths.stageSparrow('halloween_bg', stage);

                halloweenBG = new StageAsset(-200, -100, 'halloween_bg');
                halloweenBG.frames = hallowTex;
                halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
                halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
                halloweenBG.animation.play('idle');
                halloweenBG.antialiasing = true;
                add(halloweenBG);
			case 'philly':
                camZoom = 1.05;

                var bg:StageAsset = new StageAsset(-100, 0, 'sky').loadGraphic(Paths.stageImage('sky', stage));
                bg.scrollFactor.set(0.1, 0.1);
                add(bg);

                var city:StageAsset = new StageAsset(-10, 0, 'city').loadGraphic(Paths.stageImage('city', stage));
                city.scrollFactor.set(0.3, 0.3);
                city.setGraphicSize(Std.int(city.width * 0.85));
                city.updateHitbox();
                add(city);

                phillyCityLights = new FlxTypedGroup<StageAsset>();
                add(phillyCityLights);

                for (i in 0...5) {
                    var light:StageAsset = new StageAsset(city.x, 0, 'win').loadGraphic(Paths.stageImage('win' + i, stage));
                    light.scrollFactor.set(0.3, 0.3);
                    light.visible = false;
                    light.setGraphicSize(Std.int(light.width * 0.85));
                    light.updateHitbox();
                    light.antialiasing = true;
                    phillyCityLights.add(light);
                }

                var streetBehind:StageAsset = new StageAsset(-40, 50, 'behindTrain').loadGraphic(Paths.stageImage('behindTrain', stage));
                add(streetBehind);

                phillyTrain = new StageAsset(2000, 360, 'train').loadGraphic(Paths.stageImage('train', stage));
                add(phillyTrain);

                trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
                FlxG.sound.list.add(trainSound);

                // var cityLights:StageAsset = new StageAsset().loadGraphic(AssetPaths.win0.png);

                var street:StageAsset = new StageAsset(-40, streetBehind.y, 'street').loadGraphic(Paths.stageImage('street', stage));
                add(street);
			case 'limo':
                camZoom = 0.9;

                bfX += 260;
                bfY -= 220;

                var skyBG:StageAsset = new StageAsset(-120, -50, 'limoSunset').loadGraphic(Paths.stageImage('limoSunset', stage));
                skyBG.scrollFactor.set(0.1, 0.1);
                add(skyBG);

                var bgLimo:StageAsset = new StageAsset(-200, 480, 'bgLimo');
                bgLimo.frames = Paths.stageSparrow('bgLimo', stage);
                bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
                bgLimo.animation.play('drive');
                bgLimo.scrollFactor.set(0.4, 0.4);
                add(bgLimo);

                grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
                add(grpLimoDancers);

                for (i in 0...5) {
                    var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400, i);
                    dancer.scrollFactor.set(0.4, 0.4);
                    grpLimoDancers.add(dancer);
                }

                var overlayShit:StageAsset = new StageAsset(-500, -600, 'limoOverlay').loadGraphic(Paths.stageImage('limoOverlay', stage));
                overlayShit.alpha = 0.5;
                // add(overlayShit);

                // var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

                // FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

                // overlayShit.shader = shaderBullshit;

                var limoTex = Paths.stageSparrow('limoDrive', stage);

                limo = new StageAsset(-120, 550, 'limoDrive');
                limo.frames = limoTex;
                limo.animation.addByPrefix('drive', "Limo stage", 24);
                limo.animation.play('drive');
                limo.antialiasing = true;

                fastCar = new StageAsset(-300, 160, 'fastCarLol').loadGraphic(Paths.stageImage('fastCarLol', stage));
                // add(limo);
			case 'mall':
                camZoom = 0.8;

                bfX += 200;

                var bg:StageAsset = new StageAsset(-1000, -500, 'bgWalls').loadGraphic(Paths.stageImage('bgWalls', stage));
                bg.antialiasing = true;
                bg.scrollFactor.set(0.2, 0.2);
                bg.active = false;
                bg.setGraphicSize(Std.int(bg.width * 0.8));
                bg.updateHitbox();
                add(bg);

                upperBoppers = new StageAsset(-240, -90, 'upperBop');
                upperBoppers.frames = Paths.stageSparrow('upperBop', stage);
                upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
                upperBoppers.antialiasing = true;
                upperBoppers.scrollFactor.set(0.33, 0.33);
                upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
                upperBoppers.updateHitbox();
                add(upperBoppers);

                var bgEscalator:StageAsset = new StageAsset(-1100, -600, 'bgEscalator').loadGraphic(Paths.stageImage('bgEscalator', stage));
                bgEscalator.antialiasing = true;
                bgEscalator.scrollFactor.set(0.3, 0.3);
                bgEscalator.active = false;
                bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
                bgEscalator.updateHitbox();
                add(bgEscalator);

                var tree:StageAsset = new StageAsset(370, -250, 'christmasTree').loadGraphic(Paths.stageImage('christmasTree', stage));
                tree.antialiasing = true;
                tree.scrollFactor.set(0.40, 0.40);
                add(tree);

                bottomBoppers = new StageAsset(-300, 140, 'bottomBop');
                bottomBoppers.frames = Paths.stageSparrow('bottomBop', stage);
                bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
                bottomBoppers.antialiasing = true;
                bottomBoppers.scrollFactor.set(0.9, 0.9);
                bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
                bottomBoppers.updateHitbox();
                add(bottomBoppers);

                var fgSnow:StageAsset = new StageAsset(-600, 700, 'fgSnow').loadGraphic(Paths.stageImage('fgSnow', stage));
                fgSnow.active = false;
                fgSnow.antialiasing = true;
                add(fgSnow);

                santa = new StageAsset(-840, 150, 'santa');
                santa.frames = Paths.stageSparrow('santa', stage);
                santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
                santa.antialiasing = true;
                add(santa);
			case 'mallEvil':
                camZoom = 1.1;

                bfX += 320;
				dadY -= 80;

                var bg:StageAsset = new StageAsset(-400, -500, 'evilBG').loadGraphic(Paths.stageImage('evilBG', stage));
                bg.antialiasing = true;
                bg.scrollFactor.set(0.2, 0.2);
                bg.active = false;
                bg.setGraphicSize(Std.int(bg.width * 0.8));
                bg.updateHitbox();
                add(bg);

                var evilTree:StageAsset = new StageAsset(300, -300, 'evilTree').loadGraphic(Paths.stageImage('evilTree', stage));
                evilTree.antialiasing = true;
                evilTree.scrollFactor.set(0.2, 0.2);
                add(evilTree);

                var evilSnow:StageAsset = new StageAsset(-200, 700, "evilSnow").loadGraphic(Paths.stageImage("evilSnow", stage));
                evilSnow.antialiasing = true;
                add(evilSnow);
			case 'school':
                if (!Options.customBf) {
					bfX += 200;
					bfY += 220;
				}
				if (!Options.customGf) {
					gfX += 180;
					gfY += 300;
				}

                // defaultCamZoom = 0.9;

                var bgSky = new StageAsset().loadGraphic(Paths.stageImage('weebSky', stage));
                bgSky.name = 'weebSky';
                bgSky.scrollFactor.set(0.1, 0.1);
                add(bgSky);

                var repositionShit = -200;

                var bgSchool:StageAsset = new StageAsset(repositionShit, 0, 'weebSchool').loadGraphic(Paths.stageImage('weebSchool', stage));
                bgSchool.scrollFactor.set(0.6, 0.90);
                add(bgSchool);

                var bgStreet:StageAsset = new StageAsset(repositionShit, 0, 'weebStreet').loadGraphic(Paths.stageImage('weebStreet', stage));
                bgStreet.scrollFactor.set(0.95, 0.95);
                add(bgStreet);

                var fgTrees:StageAsset = new StageAsset(repositionShit + 170, 130, 'weebTreesBack').loadGraphic(Paths.stageImage('weebTreesBack', stage));
                fgTrees.scrollFactor.set(0.9, 0.9);
                add(fgTrees);

                var bgTrees:StageAsset = new StageAsset(repositionShit - 380, -800, 'weebTrees');
                var treetex = Paths.stagePacker('weebTrees', stage);
                bgTrees.frames = treetex;
                bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
                bgTrees.animation.play('treeLoop');
                bgTrees.scrollFactor.set(0.85, 0.85);
                add(bgTrees);

                var treeLeaves:StageAsset = new StageAsset(repositionShit, -40, 'petals');
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
                if (!Options.customBf) {
					bfX += 200;
					bfY += 220;
				}
				if (!Options.customGf) {
					gfX += 180;
					gfY += 300;
				}
                
                //var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
                //var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

                var posX = 400;
                var posY = 200;

                var bg:StageAsset = new StageAsset(posX, posY, 'animatedEvilSchool');
                bg.frames = Paths.stageSparrow('animatedEvilSchool', stage);
                bg.animation.addByPrefix('idle', 'background 2', 24);
                bg.animation.play('idle');
                bg.scrollFactor.set(0.8, 0.9);
                bg.scale.set(6, 6);
                add(bg);

                /* 
                    var bg:StageAsset = new StageAsset(posX, posY).loadGraphic(Paths.image('evilSchoolBG'));
                    bg.scale.set(6, 6);
                    // bg.setGraphicSize(Std.int(bg.width * 6));
                    // bg.updateHitbox();
                    add(bg);

                    var fg:StageAsset = new StageAsset(posX, posY).loadGraphic(Paths.image('evilSchoolFG'));
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

                bfX += 50;
				bfY -= 50;
				gfX = 190;
				gfY = 50;

				var tankSky:StageAsset = new StageAsset(-60, -400, 'tankSky').loadGraphic(Paths.stageImage('tankSky', stage));
				tankSky.setGraphicSize(Std.int(tankSky.width * 1.3));
				tankSky.antialiasing = true;
				tankSky.active = false;
				add(tankSky);

				var tankMountains:StageAsset = new StageAsset(-20, 180, 'tankMountains').loadGraphic(Paths.stageImage('tankMountains', stage));
				tankMountains.setGraphicSize(Std.int(tankMountains.width * 1.3));
				tankMountains.antialiasing = true;
				tankMountains.scrollFactor.set(0.4, 0.9);
				tankMountains.active = false;
				add(tankMountains);

				var tankBuildings:StageAsset = new StageAsset(-190, 130, 'tankBuildings').loadGraphic(Paths.stageImage('tankBuildings', stage));
				tankBuildings.setGraphicSize(Std.int(tankBuildings.width * 1.15));
				tankBuildings.antialiasing = true;
				tankBuildings.scrollFactor.set(0.4, 0.9);
				tankBuildings.active = false;
				add(tankBuildings);

				var tankRuins:StageAsset = new StageAsset(-210, 140, 'tankRuins').loadGraphic(Paths.stageImage('tankRuins', stage));
				tankRuins.setGraphicSize(Std.int(tankRuins.width * 1.15));
				tankRuins.antialiasing = true;
				tankRuins.scrollFactor.set(0.4, 0.9);
				tankRuins.active = false;
				add(tankRuins);

				bgSkittles = new StageAsset(0, 0, 'tankWatchtower');
				bgSkittles.frames = Paths.stageSparrow('tankWatchtower', stage);
				bgSkittles.animation.addByPrefix('bop', "watchtower gradient color instance 1", 24, false);
				bgSkittles.antialiasing = true;
				bgSkittles.scrollFactor.set(0.3, 0.6);
				add(bgSkittles);

				var smokeLeft:StageAsset = new StageAsset(-200, -130, 'smokeLeft');
				smokeLeft.frames = Paths.stageSparrow('smokeLeft', stage);
				smokeLeft.animation.addByPrefix('smoke', 'SmokeBlurLeft instance 1', 24);
				smokeLeft.animation.play('smoke');
				smokeLeft.scrollFactor.set(0.4, 0.4);
				add(smokeLeft);

				var smokeRight:StageAsset = new StageAsset(1200, 0, 'smokeRight');
				smokeRight.frames = Paths.stageSparrow('smokeRight', stage);
				smokeRight.animation.addByPrefix('smoke', 'SmokeRight instance 1', 24);
				smokeRight.animation.play('smoke');
				smokeRight.scrollFactor.set(0.4, 0.4);
				add(smokeRight);

				tankRolling = new StageAsset();
                tankRolling.name = 'tankRolling';
				tankRolling.frames = Paths.stageSparrow('tankRolling', stage);
				tankRolling.animation.addByPrefix('rollin', 'BG tank w lighting instance 1', 24);
				tankRolling.animation.play('rollin');
				tankRolling.scrollFactor.set(0.8, 0.8);
				add(tankRolling);
				tankRolling.kill();

				var tankGround = new StageAsset(-240, -110, 'tankGround').loadGraphic(Paths.stageImage('tankGround', stage));
				tankGround.setGraphicSize(Std.int(tankGround.width * 1.1));
				tankGround.scrollFactor.set(0.9, 0.9);
				add(tankGround);

				bgTank0 = new StageAsset(-300, 470, 'tank0');
				bgTank0.frames = Paths.stageSparrow('tank0', stage);
				bgTank0.animation.addByPrefix('bop', "fg tankhead far right instance 1", 24, false);
				bgTank0.antialiasing = true;

				bgTank1 = new StageAsset(-30, 840, 'tank1');
				bgTank1.frames = Paths.stageSparrow('tank1', stage);
				bgTank1.animation.addByPrefix('bop', "fg tankhead 5 instance 1", 24, false);
				bgTank1.antialiasing = true;

				bgTank2 = new StageAsset(440, 780, 'tank2');
				bgTank2.frames = Paths.stageSparrow('tank2', stage);
				bgTank2.animation.addByPrefix('bop', "foreground man 3 instance 1", 24, false);
				bgTank2.antialiasing = true;

				bgTank3 = new StageAsset(890, 830, 'tank3');
				bgTank3.frames = Paths.stageSparrow('tank3', stage);
				bgTank3.animation.addByPrefix('bop', "fg tankhead 4 instance 1", 24, false);
				bgTank3.antialiasing = true;

				bgTank4 = new StageAsset(1250, 760, 'tank4');
				bgTank4.frames = Paths.stageSparrow('tank4', stage);
				bgTank4.animation.addByPrefix('bop', "fg tankman bobbin 3 instance 1", 24, false);
				bgTank4.antialiasing = true;

				bgTank5 = new StageAsset(1450, 460, 'tank5');
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
                    
                    if (config != null) {

                        if (config.get("zoom") != null) camZoom = Std.parseFloat(Std.string(config.get("zoom")));

                        if (config.get("gfX") != null) gfX = Std.parseFloat(Std.string(config.get("gfX")));
                        if (config.get("gfY") != null) gfY = Std.parseFloat(Std.string(config.get("gfY")));
                        if (config.get("dadX") != null) dadX = Std.parseFloat(Std.string(config.get("dadX")));
                        if (config.get("dadY") != null) dadY = Std.parseFloat(Std.string(config.get("dadY")));
                        if (config.get("bfX") != null) bfX = Std.parseFloat(Std.string(config.get("bfX")));
                        if (config.get("bfY") != null) bfY = Std.parseFloat(Std.string(config.get("bfY")));

                        var map:TObjectMap<Dynamic, Dynamic> = config.get('images');

                        for (image in map.keys()) {
                            var keys = config.get('images').get(image);
                            var stageSprite = new StageAsset(0, 0, image).loadGraphic(BitmapData.fromBytes(SysFile.getBytes('mods/stages/$stage/images/$image.png')));
                            if (keys != null) {
                                if (keys.get("x") != null) stageSprite.x = keys.get("x");
                                if (keys.get("y") != null) stageSprite.y = keys.get("y");
                                if (keys.get("size") != null) {
                                    stageSprite.setAssetSize(keys.get("size"));
                                }
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

class StageAsset extends FlxSprite {

    public var name:String;

    public var sizeMultiplier:Float = 1.0;

    public function new(?X:Float = 0, ?Y:Float = 0, ?name:String) {
        this.name = name;

        super(X, Y);
    }

    public function setAssetSize(sizeMultiplier:Float = 1.0) {
        this.sizeMultiplier = sizeMultiplier;
        setGraphicSize(Std.int(frameWidth * sizeMultiplier));
        updateHitbox();
    }

    /**
	 * Load an image from an embedded graphic file.
	 *
	 * HaxeFlixel's graphic caching system keeps track of loaded image data.
	 * When you load an identical copy of a previously used image, by default
	 * HaxeFlixel copies the previous reference onto the `pixels` field instead
	 * of creating another copy of the image data, to save memory.
	 *
	 * @param   Graphic    The image you want to use.
	 * @param   Animated   Whether the `Graphic` parameter is a single sprite or a row / grid of sprites.
	 * @param   Width      Specify the width of your sprite
	 *                     (helps figure out what to do with non-square sprites or sprite sheets).
	 * @param   Height     Specify the height of your sprite
	 *                     (helps figure out what to do with non-square sprites or sprite sheets).
	 * @param   Unique     Whether the graphic should be a unique instance in the graphics cache.
	 *                     Set this to `true` if you want to modify the `pixels` field without changing
	 *                     the `pixels` of other sprites with the same `BitmapData`.
	 * @param   Key        Set this parameter if you're loading `BitmapData`.
	 * @return  This `FlxSprite` instance (nice for chaining stuff together, if you're into that).
	 */
	override public function loadGraphic(Graphic:FlxGraphicAsset, Animated:Bool = false, Width:Int = 0, Height:Int = 0, Unique:Bool = false, ?Key:String):StageAsset {
        super.loadGraphic(Graphic, Animated, Width, Height, Unique);
        return this;
    }
}