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

# Skins and Characters
To add a skin:
1. Download skin from gamebanana or just make one yourself
2. Copy the .xml and .png file and paste in ex. "mods/skins/< bf/gf/dad >/< your skin name >/" folder

To add a icon make a image file with name "icon.png" also it should be 300x150
To add a config create a file with name "config.yml" (example config is in "mods/skins/")

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
Skin config file: (config.yml) <br>
<code>
#Default boyfriend offset values<br>
offset:<br>
  scared:<br>
    x: -4<br>
    y: 0<br>
  deathLoop:<br>
    x: 37<br>
    y: 5<br>
  singRIGHTmiss:<br>
    x: -30<br>
    y: 21<br>
  singDOWN:<br>
    x: -10<br>
    y: -50<br>
  singLEFTmiss:<br>
    x: 12<br>
    y: 24<br>
  singUP:<br>
    x: -29<br>
    y: 27<br>
  deathConfirm:<br>
    x: 37<br>
    y: 69<br>
  firstDeath:<br>
    x: 37<br>
    y: 11<br>
  hey:<br>
    x: 7<br>
    y: 4<br>
  idle:<br>
    x: -5<br>
    y: 0<br>
  singDOWNmiss:<br>
    x: -11<br>
    y: -19<br>
  singRIGHT:<br>
    x: -38<br>
    y: -7<br>
  singLEFT:<br>
    x: 12<br>
    y: -6<br>
  singUPmiss:<br>
    x: -29<br>
    y: 27<br>
</code>