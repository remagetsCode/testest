import openfl.Lib;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.addons.display.FlxBackdrop;
import openfl.net.URLRequest;

var uh:Int = 1;
var curSelected:Int = 0;

var credits:Array<{name:String, work:String, icon:String, description:String, link:String}>=[
	{name: 'Fare', work: 'Artist', icon: 'fare', description: '', link: ''},
	{name: 'Tuffas', work: 'Artist', icon: 'tuffa', description: '', link: 'https://x.com/tuffaestuffa'},
	{name: 'Sebas1554', work: 'Artist', icon: 'Sebas', description: '', link: 'https://www.youtube.com/@Sebas1554-amonguss'},
	{name: 'Azure', work: 'Artist', icon: '', description: '', link: ''},
	{name: 'Fckalex', work: 'Artist', icon: '', description: '', link: ''},
	{name: 'GB', work: 'Artist', icon: 'gb', description: '', link: 'https://x.com/WW_MT199?t=TBH8bSRNRrYCLjq02H9sOA&s=09'},

	{name: 'Dmbomb', work: 'Musician', icon: 'dmbomb', description: '', link: 'https://www.youtube.com/@Mickydsmcnugget'},
	{name: 'Zoey', work: 'Musician', icon: 'zoey', description: '', link: 'https://youtube.com/@zoethesigmagrl-d3n'},
	{name: 'DeadLungs', work: 'Musician', icon: 'deadlungs', description: '', link: 'https://youtube.com/@unaliveoxygen'},
	{name: 'Rak', work: 'Musician', icon: 'rak', description: '', link: 'https://www.youtube.com/@rakeishon'},

	{name: 'Begi', work: 'Charter', icon: 'begi', description: '', link: 'https://x.com/begi1236524'},
	{name: 'Baap', work: 'Charter', icon: '', description: '', link: ''},
	{name: 'JustX', work: 'Charter', icon: '', description: '', link: ''},
	{name: 'Eli', work: 'Charter', icon: 'eli', description: '', link: ''},

	{name: 'Ina The Cat', work: 'Coder', icon: 'Ina', description: '', link: 'https://www.youtube.com/@InaTheCat'}
];

var shit:Array<FlxSprite>=[];

var generalCam:FlxCamera = new FlxCamera(0, 0, 1280, 720);

var bg:FlxBackdrop;
var bg2:FlxBackdrop;

function create() {
	FlxG.cameras.add(generalCam);
	add(bg1 = new FlxBackdrop(Paths.image('menus/credits/sky'), 0x01)).scrollFactor.set(0.01);
	add(bg2 = new FlxBackdrop(Paths.image('menus/credits/trees'), 0x01)).scrollFactor.set(0.02); bg2.x -= 200;
	// bg.velocity.set(0, 50);
	new FlxTimer().start(0.05,()->uh=0.06);
	for (i => creds in credits){
		var name = new FlxText(150 + (i * 800), 50, 1000, creds.name).setFormat(Paths.font('ArialCEMTBlack.ttf'), 64, 0xFFFFFF00, 'center', FlxTextBorderStyle.OUTLINE, 0xFF000050);
		var work = new FlxText(150 + (i * 800), 150, 1000, creds.work).setFormat(Paths.font('ArialCEMTBlack.ttf'), 32, 0xFF555500, 'center', FlxTextBorderStyle.OUTLINE, 0xFF000020);
		var icon = new FlxSprite(450 + (i * 800), 250).loadGraphic(Paths.image('credits/'+(creds.icon != '' ? creds.icon : 'placeholder')));
		var description = new FlxText(-350 + (i * 800), 600, 2000, creds.description).setFormat(Paths.font('ArialCEMTBlack.ttf'), 24, 0xFF00AA00, 'center', FlxTextBorderStyle.OUTLINE, 0xFF000000);

		name.borderSize = 2;
		work.borderSize = 2;
		description.borderSize = 2;

		add(name);
		add(work);
		add(icon);
		add(description);

		shit.push(icon);
	}
	window.title = "Vs Sonic.exe: AIR - Credits";
}

function update(elapsed:Float) {
	if (curSelected < 0) curSelected = shit.length - 1; else if (curSelected >= shit.length) curSelected = 0;
	generalCam.scroll.x = FlxMath.lerp(generalCam.scroll.x, shit[curSelected].x - 440, uh);
	if (controls.LEFT_P || controls.RIGHT_P) curSelected += (controls.LEFT_P ? -1 : 1);
	if (controls.BACK) FlxG.switchState(new MainMenuState());
	if (controls.ACCEPT && credits[curSelected].link != '') Lib.getURL(new URLRequest((credits[curSelected].link)), "_blank");
	for (eh in shit) eh.scale.set(FlxMath.lerp(eh.scale.x, 1, 0.05), FlxMath.lerp(eh.scale.y, 1, 0.05));
}

function beatHit(b:Int) if (b % 1 == 0 && FlxG.sound.music != null) for (eh in shit) eh.scale.set(1.2, 1.2);