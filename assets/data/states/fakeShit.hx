import flixel.math.FlxPoint;
import Sys;

var generalCam:FlxCamera = new FlxCamera(0, 0, 1280, 720);

var winPos:FlxPoint = FlxPoint.get();
var jumpscared:Bool = false;
var jumpscare:FlxSprite;
var curSelected:Int = 0;
var hitboxes:Array<FlxSprite>=[];
var backBoxes:Array<FlxSprite>=[];
var icons:Array<FlxSprite>=[];
var moveTxts:Array<Alphabet>=[];
var texts:Array<String>=[
	'Chart Editor',
	'Character Editor',
	'Stage Editor',
	'Alphabet Editor',
	'Wiki'
];

function create() {
	FlxG.cameras.add(generalCam, false).bgColor = 0;
	cameras = [generalCam];

	winPos.set(window.x, window.y);

	add(back = new FlxSprite().makeGraphic(1280, 720, 0x80000000));

	for (i => uh in texts){
		var backB = new FlxSprite(-1280, 0 + (i * 144)).makeGraphic(1280, 144, 0x50FFFFFF);
		add(backB);
		backBoxes.push(backB);

		var mh = new Alphabet(25, 50 + (i * 140), uh, true, true);
		add(mh);
		moveTxts.push(mh);

		var box = new FlxSprite(0, 0 + (i * 148)).makeGraphic(1280, 140, 0x00FFFFFF);
		add(box);
		hitboxes.push(box);
	}

	for (i => uh in ['chart', 'character', 'stage', 'alphabet', 'wiki']){
		var icon = new FlxSprite(-130, 10 + (i * 144)).loadGraphic(Paths.image('editors/icons/'+uh));
		add(icon);
		icons.push(icon);
	}

	add(jumpscare = new FlxSprite()).frames = Paths.getSparrowAtlas('stages/sonic/jumpscare');
	jumpscare.animation.addByPrefix('jumpscare', 'jumpscare', 24, false);
	jumpscare.animation.play('jumpscare');
	jumpscare.screenCenter(0x01);
	jumpscare.alpha = 0.001;

    FlxG.sound.play(Paths.sound('fakeJumpscare'), 0);
}

function update(elapsed:Float) {
	if (controls.BACK) close();

	for (i in 0...backBoxes.length){
		if (FlxG.mouse.overlaps(hitboxes[i])) curSelected = i;

		backBoxes[i].x = FlxMath.lerp(backBoxes[i].x, i == curSelected ? 0 : -1280, 0.2);
		backBoxes[i].alpha = FlxMath.lerp(backBoxes[i].alpha, i == curSelected ? 1 : 0, 0.1);

		icons[i].x = FlxMath.lerp(icons[i].x, i == curSelected ? 15 : -130, 0.1);
		icons[i].alpha = FlxMath.lerp(icons[i].alpha, i == curSelected ? 1 : 0, 0.1);

		moveTxts[i].x = FlxMath.lerp(moveTxts[i].x, i == curSelected ? 140 : 25, 0.1);
	}

	if (FlxG.mouse.justPressed && !jumpscared){
		jumpscared = true;

		Options.save();
		FlxG.save.flush();

		if (FlxG.sound.music != null) FlxG.sound.music.stop();

		jumpscare.alpha = 1;
    	FlxG.sound.play(Paths.sound('fakeJumpscare'), 2);
		jumpscare.animation.play('jumpscare');
		new FlxTimer().start(1.25, () -> Sys.exit(0));
	}

	if (jumpscared){
		window.x = winPos.x + FlxG.random.int(-25, 25);
		window.y = winPos.y + FlxG.random.int(-30, 30);
	}
}