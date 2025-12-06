class DropShadow {
/**
    Shader taken from the shaders folder
  **/
  public var shader:CustomShader = new CustomShader('dropShadow');
  
  /*
    The color of the drop shadow.
   */
  public var color:FlxColor;

  /*
    The angle of the drop shadow.

    for reference, depending on the angle, the affected side will be:
    0 = RIGHT
    90 = UP
    180 = LEFT
    270 = DOWN
   */
  public var angle:Float;

  /*
    The distance or size of the drop shadow, in pixels,
    relative to the texture itself... NOT the camera.
   */
  public var distance:Float;

  /*
    The strength of the drop shadow.
    Effectively just an alpha multiplier.
   */
  public var strength:Float;

  /*
    The brightness threshold for the drop shadow.
    Anything below this number will NOT be affected by the drop shadow shader.
    A value of 0 effectively means theres no threshold, and vice versa.
   */
  public var threshold:Float;

  /*
    The amount of antialias samples per-pixel,
    used to smooth out any hard edges the brightness thresholding creates.
    Defaults to 2, and 0 will remove any smoothing.
   */
  public var antialiasAmt:Float;

  /*
    Whether the shader should try and use the alternate mask.
    False by default.
   */
  public var useAltMask:Bool;

  /*
    The image for the alternate mask.
    At the moment, it uses the blue channel to specify what is or isnt going to use the alternate threshold.
    (its kinda sloppy rn i need to make it work a little nicer)
    TODO: maybe have a sort of "threshold intensity texture" as well? where higher/lower values indicate threshold strength..
   */
  public var altMaskImage:BitmapData;

  /*
    An alternate brightness threshold for the drop shadow.
    Anything below this number will NOT be affected by the drop shadow shader,
    but ONLY when the pixel is within the mask.
   */
  public var maskThreshold:Float;

  /*
    The FlxSprite that the shader should get the frame data from.
    Needed to keep the drop shadow shader in the correct bounds and rotation.
   */
  public var attachedSprite:FlxSprite;

  /*
    The hue component of the Adjust Color part of the shader.
   */
  public var baseHue:Float;

  /*
    The saturation component of the Adjust Color part of the shader.
   */
  public var baseSaturation:Float;

  /*
    The brightness component of the Adjust Color part of the shader.
   */
  public var baseBrightness:Float;

  /*
    The contrast component of the Adjust Color part of the shader.
   */
  public var baseContrast:Float;

  /*
    The zoom component of the shader.
   */
  public var baseZoom:Float;

  /*
    Whether the shader should use pixel perfect mode.
   */
  public var pixelPerfect:Bool;

  /*
    Whether the shader should flip the sprite horizontally.
   */
  public var flipX:Bool;

  /*
    Whether the shader should flip the sprite vertically.
   */
  public var flipY:Bool;

    function new(
    sprite:FlxSprite, color:Array<Float>, ang:Float, dist:Float, str:Float, thr:Float, 
    hue:Float, saturation:Float, brightness:Float, contrast:Float, 
    AA:Float, zoom:Float, pixelPerfect:Bool, flipX:Bool, flipY:Bool) {
        
        this.color = color != null ? color : [0, 0, 0];

        this.angle = ang != null ? ang : 0;
        this.distance = dist != null ? dist : 10;
        this.strength = str != null ? str : 1;
        this.threshold = thr != null ? thr : 0.1;

        this.antialiasAmt = AA != null ? AA : 2;
        this.attachedSprite = sprite != null ? sprite : null;

        this.baseHue = hue != null ? hue : 0;
        this.baseSaturation = saturation != null ? saturation : 0;
        this.baseBrightness = brightness != null ? brightness : 1;
        this.baseContrast = contrast != null ? contrast : 1;

        this.baseZoom = zoom != null ? zoom : 1;
        this.pixelPerfect = pixelPerfect != null ? pixelPerfect : false;
        this.flipX = flipX != null ? flipX : false;
        this.flipY = flipY != null ? flipY : false;

        attachedSprite.shader = shader;

        setAdjustColor(baseBrightness, baseHue, baseContrast, baseSaturation);
        setDropShadowColor(color[0], color[1], color[2]);   
        updateFrameInfo(attachedSprite.frame);
        setAngle(angle);
        setDistance(distance);
        setStrength(strength);
        setThreshold(threshold);
        setAntialias(antialiasAmt);
        setZoom(baseZoom);
        setPixelPerfect(this.pixelPerfect);
        setFlipX(this.flipX);
        setFlipY(this.flipY);
    }

    public function updateFrameInfo(frame:FlxFrame) {
        frame ??= attachedSprite.frame;
        var uv = frame.uv;
        
        attachedSprite.shader.uFrameBounds = [uv.x, uv.y, uv.width, uv.height];
        attachedSprite.shader.angOffset = frame.angle;
    }

    public function postUpdate(elapsed:Float) {
        updateFrameInfo(attachedSprite.frame);
    }

    public function setAdjustColor(b:Float, h:Float, c:Float, s:Float) {
      attachedSprite.shader.brightness = baseBrightness = b;
      attachedSprite.shader.hue = baseHue = h;
      attachedSprite.shader.contrast = baseContrast = c;
      attachedSprite.shader.saturation = baseSaturation = s;
    }

    public function setDropShadowColor(r:Float, g:Float, b:Float) {
        attachedSprite.shader.dropColor = [r / 255, g / 255, b / 255];
    }

    public function setAngle(ang:Float) {
        attachedSprite.shader.ang = angle = ang;
    }

    public function setDistance(dist:Float) {
        attachedSprite.shader.dist = distance = dist;
    }

    public function setStrength(str:Float) {
        attachedSprite.shader.str = strength = str;
    }

    public function setThreshold(thr:Float) {
        attachedSprite.shader.thr = threshold = thr;
    }

    public function setAntialias(AA:Float) {
        attachedSprite.shader.AA_STAGES = antialiasAmt = AA;
    }

    public function setUseAltMask(useAltMask:Bool) {
        attachedSprite.shader.altMask = useAltMask = useAltMask;
    }

    public function setMaskThreshold(maskThreshold:Float) {
        attachedSprite.shader.thr2 = maskThreshold = maskThreshold;
    }

    public function setSprite(spr:FlxSprite) {
        attachedSprite = spr;
        updateFrameInfo(attachedSprite.frame);
    }

    public function setZoom(zoom:Float) {
        attachedSprite.shader.zoom = baseZoom = zoom;
    }

    public function setPixelPerfect(pixelPerfect:Bool) {
        attachedSprite.shader.pixelPerfect = this.pixelPerfect = pixelPerfect;
    }

    public function setFlipX(flipX:Bool) {
        attachedSprite.shader.flipX = this.flipX = flipX;
    }

    public function setFlipY(flipY:Bool) {
        attachedSprite.shader.flipY = this.flipY = flipY;
    }
}