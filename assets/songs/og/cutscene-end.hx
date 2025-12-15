import hxvlc.flixel.FlxVideoSprite;

var uh:FlxVideoSprite;

function create() {
    persistentUpdate = false;
    camera = uhCam = new FlxCamera();
    FlxG.cameras.add(uhCam, false);

    add(uh = new FlxVideoSprite()).load(Paths.video('og2'));
    uh.bitmap.onEndReached.add(()->{
        uh.visible = false;
        uh.stop();
        uh.destroy();
        uh = null;
        FlxG.cameras.remove(uhCam);
        close();
    });

    uh.play();
}

function update() {
    if (controls.ACCEPT) {
        uh.stop();
        uh.destroy();
        FlxG.cameras.remove(uhCam);
        close();
    }
}