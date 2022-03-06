*If this is outdated please tell me*
# Songs
You can add custom songs to the game!
(For now they are only available on Freeplay)

To add a song: 
1. Create a folder in a songs folder with a name of your song.
2. Add Inst.ogg and Voices.ogg (optionally) to this folder.
3. When you finish go to freeplay menu and select your song,

To create a data for the song:
1. Go to your song select the difficulty and it will send you to the chart editor
2. When you finish change the title of the song in Song section to you song name (for example "Test") after that save the song difficulty in "mods/songs/yoursong/" folder

Or steal the data from some mod or idk and paste it in "mods/songs/yoursong/" folder

## Action Notes
To add a Action Note that is not visible in the game press ALT + LEFT CLICK

# Stages
To add a stage create a folder in "mods/stages/" folder with the name of your stage
After that create a "/images/" folder in it and place there your assets
Then create a config.yml in "mods/stages/{stagename}/" with:
```
images:
  image_name_from_images_folder:
    
  another_image:

```
To edit the stage go into any fucking song and press 6 then select your stage

# Weeks
To add a week create a folder in "mods/weeks/" with the name of your stage
Then create a config.yml file in "mods/weeks/{weekname}/" with:
```
songs:
 songname:
  
 anothersongname:

```

To add a week image (that in storymode) place a image with the name of your stage (in .png format)

# Skins and Characters
To add a skin:
1. Download skin from gamebanana or just make one yourself
2. Copy the .xml and .png file and paste in ex. "mods/skins/< bf/gf/dad >/< your skin name >/" folder

To add a icon make a image file with name "icon.png" also it should be 300x150
To add a config create a file with name "config.yml" (example config is in Examples section)

## Offsets
If the skin animation go a bit off use these
1. Create a new file with the following name "yourskinnamehere_config.yml" (example config file is in skins/< character >/ folder)
2. A: Copy the exmple config file content to your skin config file and change the values (if you dont want to change the offset of specific animation just remove the entire animation name key)

### Offset In-Game Tool
If you wanna to make it easier to set the x and y values:
1. Go to any song and press 8
2. Enter the character name in the white box
3. When you end setting up the offsets get the current offset values from the "Offsets" list so for example [69, -420] is x: 69 and y: -420

#### Controls:
 - W and S - change the animation
 - V - show helper sprite of current animation, basically if you'll go to another animation helper sprite will appear in less visible version
 - JKIL - move the camera
 - ARROWS - change the offset of current animation hold SHIFT to move it faster
 - R - reload the sprite
 - Q - zoom out camera
 - E - zoom in camera

# Examples:
#### Skin config file: (config.yml) <br>
```
#Default boyfriend offset values
offset:
  scared:
    x: -4
    y: 0
  deathLoop:
    x: 37
    y: 5
  singRIGHTmiss:
    x: -30
    y: 21
  singDOWN:
    x: -10
    y: -50
  singLEFTmiss:
    x: 12
    y: 24
  singUP:
    x: -29
    y: 27
  deathConfirm:
    x: 37
    y: 69
  firstDeath:
    x: 37
    y: 11
  hey:
    x: 7
    y: 4
  idle:
    x: -5
    y: 0
  singDOWNmiss:
    x: -11
    y: -19
  singRIGHT:
    x: -38
    y: -7
  singLEFT:
    x: 12
    y: -6
  singUPmiss:
    x: -29
    y: 27
```

#### Song script.lua file example:
```
-- Example Config so you don't have to think 30 minut how to do something

print("Hello World!")
print("Current Song Name: " .. swagSong.song)
--Caches the character so it doesnt freeze the game when loading it
cacheCharacter("dad", "obama")

function beatHit()
	print(curBeat)
end

function stepHit()
	print(curStep)
  if curStep == 69 then
		changeCharacter("dad", "obama")
	end
end

function onCameraMove(char)
	if char == "dad" then
		setCamZoom("game", stageZoom + 0.2)
	elseif char == "bf" then
		setCamZoom("game", stageZoom)
	end
end

function onNotePress(char)
	if char == "dad" then
		shakeCamera("hud", 0.005, 0.1)
		shakeCamera("game", 0.01, 0.1)
	end
end
```

#### Character config.yml file:
```
# Default boyfriend anim values
# IMPORTANT: If animation is for idle pose add isIdle: true
# Note: Restarting the song will also reload this config!

flipX: true
X: 0
Y: 450

animations:
  BF idle dance:
    x: -5
    y: 0
    name: idle
    isIdle: true
  BF idle shaking:
    x: -4
    y: 0
    name: scared
  BF Dead Loop:
    x: 37
    y: 5
    name: deathLoop
  BF NOTE RIGHT MISS:
    x: -30
    y: 21
    name: singRIGHTmiss
  BF NOTE DOWN0:
    x: -10
    y: -50
    name: singDOWN
  BF NOTE LEFT MISS:
    x: 12
    y: 24
    name: singLEFTmiss
  BF NOTE UP0:
    x: -29
    y: 27
    name: singUP
  BF Dead confirm:
    x: 37
    y: 69
    name: deathConfirm
  BF dies:
    x: 37
    y: 11
    name: firstDeath
  BF HEY:
    x: 7
    y: 4
    name: hey
  BF NOTE DOWN MISS:
    x: -11
    y: -19
    name: singDOWNmiss
  BF NOTE RIGHT0:
    x: -38
    y: -7
    name: singRIGHT
  BF NOTE LEFT0:
    x: 12
    y: -6
    name: singLEFT
  BF NOTE UP MISS:
    x: -29
    y: 27
    name: singUPmiss
```

#### Week config.yml file:
```
# if you wanna to hide the week from story menu change the number value to -1
# Sorry for no week unlock option i will probably add it sometime later

color: "#2a3d42"
storyModeName: "teh epic week"
onlyInFreeplay: false

songs:
 songname:
  character: pico
 fsjfodsjofsp:
  character: forgor
```
Stages config.yml file:
```
zoom: 0.9

images:
  bg:
    x: -300
    y: 0
    size: 0.50
  ground:
    x: -200
    y: 0
    size: 0.70
```