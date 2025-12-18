import openfl.Lib;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.addons.display.FlxBackdrop;
import openfl.net.URLRequest;
using StringTools;

var uh:Int = 1;
var curSelected:Int = 0;

var credits:Array<{name:String, work:String, icon:String, description:String, link:String}>=[
	{name: 'Fare', work: 'Artist', icon: 'fare', description: '', link: ''},
	{name: 'Tuffas', work: 'Artist', icon: 'tuffa', description: '', link: 'https://x.com/tuffaestuffa'},
	{name: 'Sebas1554', work: 'Artist', icon: 'Sebas', description: '', link: 'https://www.youtube.com/@Sebas1554-amonguss'},
	{name: 'Azure', work: 'Artist', icon: 'azure', description: '', link: ''},
	{name: 'Fckalex', work: 'Artist', icon: '', description: '', link: ''},
	{name: 'GB', work: 'Artist', icon: 'gb', description: '', link: 'https://x.com/WW_MT199?t=TBH8bSRNRrYCLjq02H9sOA&s=09'},
	{name: 'Ciri', work: 'Artist', icon: 'ciri', description: '', link: ''},
	{name: 'Bwhoved', work: 'BG Artist', icon: 'bwhoved', description: '', link: ''},
	{name: 'MrDankBoi', work: 'Animator', icon: '', description: '', link: ''},
	{name: 'Modnar', work: 'Pixel Artist', icon: '', description: '', link: ''},

	{name: 'Dmbomb', work: 'Musician', icon: 'dmbomb', description: '', link: 'https://www.youtube.com/@Mickydsmcnugget'},
	{name: 'Zoey', work: 'Musician', icon: 'zoey', description: '', link: 'https://youtube.com/@zoethesigmagrl-d3n'},
	{name: 'DeadLungs', work: 'Musician', icon: 'deadlungs', description: '', link: 'https://youtube.com/@unaliveoxygen'},
	{name: 'Rak', work: 'Musician', icon: 'rak', description: '', link: 'https://www.youtube.com/@rakeishon'},
	{name: 'Alexander', work: 'Musician', icon: '', description: '', link: ''},
	{name: 'MeDicenKay', work: 'Musician', icon: 'kay', description: '', link: ''},
	{name: 'Grimmothy', work: 'Musician', icon: '', description: '', link: ''},
	{name: 'TheSpookyGal', work: 'Musician', icon: '', description: '', link: ''},
	{name: 'J.Shadows', work: 'Voice Actor', icon: '', description: '', link: ''},

	{name: 'Begi', work: 'Charter', icon: 'begi', description: '', link: 'https://x.com/begi1236524'},
	{name: 'Baap', work: 'Charter', icon: '', description: '', link: ''},
	{name: 'JustX', work: 'Charter', icon: '', description: '', link: ''},
	{name: 'Cherri', work: 'Charter', icon: 'cherri', description: '', link: ''},
	{name: 'Pollo Rostizado', work: 'Charter', icon: 'pollo', description: '', link: ''},
	{name: 'n1ckolasn4me', work: 'Events', icon: '', description: '', link: ''},

	{name: 'Ina The Cat', work: 'Coder', icon: 'Ina', description: '', link: 'https://www.youtube.com/@InaTheCat'},
	{name: 'Remagets', work: 'Coder', icon: 'rema', description: 'Yeah im too lazy to create an oc', link: 'https://www.youtube.com/@printcodeRem'}
];

var shit:Array<FlxSprite>=[];
var chiyoIcons:Array<Int>=[];

var generalCam:FlxCamera = new FlxCamera();

var bg:FlxBackdrop;
var bg2:FlxBackdrop;

function create() {
	FlxG.cameras.add(generalCam, true);
	add(bg1 = new FlxBackdrop(Paths.image('menus/credits/sky'), 0x01)).scrollFactor.set(0.01);
	add(bg2 = new FlxBackdrop(Paths.image('menus/credits/trees'), 0x01)).scrollFactor.set(0.02); bg2.x -= 200;
	new FlxTimer().start(0.05,()->uh=0.1);
	for (i => creds in credits){
		var name = new FlxText(150 + (i * 800), 50, 1000, creds.name).setFormat(Paths.font(creds.name == "Remagets" ? 'pixel.otf' : 'ArialCEMTBlack.ttf'), 64, 0xFFFFFF00, 'center', FlxTextBorderStyle.OUTLINE, 0xFF000050);
		var work = new FlxText(150 + (i * 800), 150, 1000, creds.work).setFormat(Paths.font('ArialCEMTBlack.ttf'), 32, 0xFF555500, 'center', FlxTextBorderStyle.OUTLINE, 0xFF000020);
		var icon = new FlxSprite(450 + (i * 800), 250).loadGraphic(Paths.image('credits/'+(creds.icon != '' ? creds.icon : 'placeholder')));
		var description = new FlxText(-350 + (i * 800), 600, 2000, creds.description).setFormat(Paths.font('ArialCEMTBlack.ttf'), 24, 0xFF00AA00, 'center', FlxTextBorderStyle.OUTLINE, 0xFF000000);

		name.borderSize = 2;
		work.borderSize = 2;
		description.borderSize = 2;

		if (creds.icon == '') {
			chiyoIcons.push(i);
			icon.x -= 18;
			icon.y -= 70;
		}

		add(name);
		add(work);
		add(icon);
		add(description);

		shit.push(icon);

		if(creds.name == "Remagets") { icon.antialiasing = false; FlxTween.tween(icon, {y: icon.y + 30}, 3, {ease: FlxEase.quadInOut, type: 4});}
	}
	window.title = "Vs Sonic.exe: AIR - Credits";
}

function update(elapsed:Float) {
	if (curSelected < 0) curSelected = shit.length - 1; else if (curSelected >= shit.length) curSelected = 0;
	generalCam.scroll.x = CoolUtil.fpsLerp(generalCam.scroll.x, shit[curSelected].x - 440, uh);
	if (controls.LEFT_P || controls.RIGHT_P) curSelected += (controls.LEFT_P ? -1 : 1);
	if (controls.BACK) FlxG.switchState(new MainMenuState());
	if (controls.ACCEPT && credits[curSelected].link != '') Lib.getURL(new URLRequest((credits[curSelected].link)), "_blank");
	for (i in 0...shit.length){
		if(i == shit.length-1) { shit[i].scale.set(5.5,5.5); shit[i].updateHitbox(); break;}
	    var icon = shit[i];
	    var the = chiyoIcons.contains(i) ? 0.8 : 1.0;

	    icon.scale.set(CoolUtil.fpsLerp(icon.scale.x, the, 0.1), CoolUtil.fpsLerp(icon.scale.y, the, 0.1));

		icon.color = colorLerp(icon.color, i == curSelected ? 0xFFFFFFFF : 0xFF505050, 0.1);
	}
}

function beatHit(b:Int){
    for (i in 0...shit.length){
        var icon = shit[i];
        var base = chiyoIcons.contains(i) ? 0.8 : 1.0;
        var bump = base + 0.2;

        icon.scale.set(bump, bump);
    }
}

function colorLerp(from:FlxColor, to:FlxColor, ratio:Float):FlxColor
	return FlxColor.interpolate(from, to, FlxMath.bound(ratio * FlxG.elapsed * 60, 0, 1));