import flixel.text.FlxText.FlxTextBorderStyle;
import hxvlc.flixel.FlxVideoSprite;
import flixel.math.FlxMath;
import funkin.options.OptionsMenu;
import funkin.editors.EditorPicker;

var maxRadius:Float = 30;

var buttons:Array<FlxSprite>=[];
var boxes:Array<FlxSprite>=[];

var back:FlxVideoSprite;
var noHijo:FlxVideoSprite;

var wall:FlxSprite;
var spikes:FlxSprite;
var sonic:FlxSprite;
var eyes:FlxSprite;
var guts:FlxSprite;

var honkHitbox:FlxSprite;
var yUWannaMakeMeCrossEyes:FlxSprite;
var iWontGonnaDoThat:FlxText;
var itWillAdvice:Bool = FlxG.random.bool(40);

var black:FlxSprite;

var clicked:Bool = false;
var curSelected:Int = 0;

var shadCam:FlxCamera = new FlxCamera();
var topCam:FlxCamera = new FlxCamera();
var vhs:CustomShader = new CustomShader('vhsPause');
var mh:Float = 0;

var ogRand:Int = FlxG.random.int(1, 10);
var ogCheck:Bool = FlxG.save.data.tooSlow;
var yaNoHijo:Int = FlxG.random.int(1, 10);

function create() {
	window.title = "Vs Sonic.exe: AIR";
	CoolUtil.playMenuSong();
	FlxG.sound.music.volume = yaNoHijo == 1 ? 0 : 1;

	if (Options.gameplayShaders){
		FlxG.cameras.add(shadCam).bgColor = 0x0;
		cameras = shadCam;
		shadCam.addShader(vhs);
	}

	FlxG.cameras.add(topCam).bgColor = 0;
	// topCam.flash(0xFF000000, 2);

	add(back = new FlxVideoSprite(-320, -180)).load(Paths.video('back'), ['input-repeat=65545']);
	back.play();
	back.scale.set(0.67, 0.67);
	back.updateHitbox();

	add(wall = new FlxSprite(FlxG.width-380)).frames = Paths.getSparrowAtlas('menus/mainmenu/wall');
	wall.animation.addByPrefix('wall', 'wall', 12);
	wall.animation.play('wall');

	for (i => shit in ['story', 'freeplay', 'options', 'credits']){
		var spr = new FlxSprite(950, 0);
		spr.frames = Paths.getFrames('menus/mainmenu/buttons');
		spr.animation.addByPrefix('i', shit+' i');
		spr.animation.addByPrefix('s', shit+' s');
		spr.animation.addByPrefix('d', shit+' d');
		spr.animation.play('i');
		switch(shit){
			case'story':spr.y=60;
			case'freeplay':spr.y=180;
			case'options':spr.y=440;
			case'credits':spr.y=580; spr.x-=30;
		}
		add(spr).updateHitbox();
		if (shit != 'freeplay') buttons.push(spr);
	}

	add(sonic = new FlxSprite(250, 120)).frames = Paths.getSparrowAtlas('menus/mainmenu/sonic');
	sonic.animation.addByPrefix('idle', 'idle');
	sonic.animation.addByPrefix('accept', 'accept', 24, false);
	sonic.animation.play('idle');
	sonic.scale.set(0.4, 0.4);
	sonic.updateHitbox();

	add(eyes = new FlxSprite(470, 350)).frames = Paths.getSparrowAtlas('menus/mainmenu/sonic');
	eyes.animation.addByPrefix('eyes', 'eyes');
	eyes.animation.play('eyes');
	eyes.scale.set(0.4, 0.4);
	eyes.updateHitbox();

	add(guts = new FlxSprite(840)).frames = Paths.getSparrowAtlas('menus/mainmenu/guts');
	guts.animation.addByPrefix('guts', 'guts', 12);
	guts.animation.play('guts');

	add(spikes = new FlxSprite()).frames = Paths.getSparrowAtlas('menus/mainmenu/spikes');
	spikes.animation.addByPrefix('spikes', 'spikes', 12);
	spikes.animation.play('spikes');

	add(honkHitbox = new FlxSprite(512, 444).makeGraphic(39, 36, 0x00FFFFFF));
	add(yUWannaMakeMeCrossEyes = new FlxSprite(525, 340).makeGraphic(30, 80, 0x00FFFFFF));

	if (itWillAdvice) add(iWontGonnaDoThat = new FlxText(295, 170, 500, 'No, I wont gonna cross my eyes...').setFormat(Paths.font('menuFont.ttf'), 32, 0xFFFF0000, 'center', FlxTextBorderStyle.OUTLINE, 0xFF000000)).alpha = 0;

	add(black = new FlxSprite().makeGraphic(1280, 720, 0xFF000000)).alpha = 0;
	black.camera = topCam;

	if (yaNoHijo == 1) {
		add(noHijo = new FlxVideoSprite(200, 200)).scale.set(0.6, 0.6);

		new FlxTimer().start(1, ()-> if (noHijo.load(Paths.video('ya no hijo'))) noHijo.play());

		noHijo.bitmap.onEndReached.add(()->{
			remove(noHijo);
			noHijo.destroy();
			FlxTween.num(0, 1, 1, {ease: FlxEase.quadInOut}, (v:Float) -> FlxG.sound.music.volume = v);
		});
	}	

	FlxG.mouse.visible = true;
}

function update(elapsed:Float) {
	mh += elapsed;
	
	if (Options.gameplayShaders) vhs.iTime = mh / 10;

	if (!clicked){
		if (FlxG.mouse.overlaps(honkHitbox) && FlxG.mouse.justPressed) FlxG.sound.play(Paths.sound('honk'), 0.35);
		if (itWillAdvice) {
			iWontGonnaDoThat.alpha = CoolUtil.fpsLerp(iWontGonnaDoThat.alpha, FlxG.mouse.overlaps(yUWannaMakeMeCrossEyes) ? 0.5 : 0, FlxG.mouse.overlaps(yUWannaMakeMeCrossEyes) ? 0.05 : 0.5);
			if (iWontGonnaDoThat.alpha != 0) iWontGonnaDoThat.setPosition(FlxG.random.float(292.5, 297.5), FlxG.random.float(167.5, 172.5));
		}

		eyesShit();
		curSelected = -1;
		
		for (i in 0...buttons.length) {
		    if (FlxG.mouse.overlaps(buttons[i])) {			
		        curSelected = i;
			
		        if (FlxG.mouse.justPressed) {
		            clicked = true;
				
		            switch (curSelected) {
		                case 0: storyClicked();
		                case 1, 2:
		                    FlxG.sound.play(Paths.sound('menu/confirm'));
		                    buttons[i].animation.play('d');
		                    FlxTween.tween(black, {alpha: 1}, 1.5, {ease: FlxEase.quartInOut,startDelay: 0.5});
						
		                    new FlxTimer().start(2, () -> {
		                        if (curSelected == 1) FlxG.switchState(new OptionsMenu());
		                        else if (curSelected == 2) FlxG.switchState(new ModState('creds'));
		                    });
		            }
		        }
		    }

		    if (!clicked) buttons[i].animation.play(i == curSelected ? 's' : 'i');
		}
	}

	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = false;
		persistentDraw = true;
		// openSubState(new ModSubState('fakeShit'));
		openSubState(new EditorPicker());
	}
}

function storyClicked() {
	FlxG.sound.play(Paths.sound('muajajajaj'), 0.6);
	buttons[0].animation.play('d');
	sonic.y -= 32;
	clicked = true;
	FlxTween.tween(black, {alpha: 1}, 2, {ease: FlxEase.quartInOut, startDelay: 1});
	FlxTween.tween(eyes, {alpha: 0}, 0.5, {ease: FlxEase.quartInOut});
	sonic.animation.play('accept');
	new FlxTimer().start(3.5, ()->{
		PlayState.loadSong(FlxG.save.data.tooSlow && ogRand != 1 ? 'too-slow' : 'og', 'hard');
		FlxG.switchState(new PlayState());
	});
}

function eyesShit() {
    var centerX = sonic.x + sonic.width/2;
    var centerY = sonic.y + sonic.height/2 - 70;

    var dx = FlxG.mouse.x - centerX;
    var dy = FlxG.mouse.y - centerY;
    var dist = Math.sqrt(dx*dx + dy*dy);

    if (dist > maxRadius) {
        var angle = Math.atan2(dy, dx);
        dx = Math.cos(angle) * maxRadius;
        dy = Math.sin(angle) * (maxRadius*1.5);
    }

    var targetX = centerX + dx - eyes.width/2;
    var targetY = centerY + dy - eyes.height/2;

    eyes.x = CoolUtil.fpsLerp(eyes.x, targetX, 0.05);
    eyes.y = CoolUtil.fpsLerp(eyes.y, targetY, 0.05);
}