package overlap2d;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class CompositeItem extends FlxSpriteGroup
{

	var ir:IResourceRetriever;
	var vo:Dynamic;

	var pixelsPerWU:Float;

	public function new(itemVO:Dynamic, ir:IResourceRetriever) 
	{
		super();

		this.ir = ir;
		this.vo = itemVO;

		pixelsPerWU = ir.getProjectVO().pixelToWorld;

		build(vo);
		invertY();
	}

	// TODO: this is not supposed to be like this
	private function invertY():Void {
		var tmpH = height;
		for (sprite in _sprites)
		{
			sprite.y = (tmpH-sprite.frameHeight)-sprite.y;
		}
	}

	private function build(itemVO:Dynamic):Void {
		if(itemVO.composite.sImages != null) buildImages(itemVO.composite.sImages);
		if(itemVO.composite.sComposites != null) buildComposites(itemVO.composite.sComposites);
	}

	private function processMain(sprite:FlxSprite, vo:Dynamic):Void {
		sprite.x = vo.x * pixelsPerWU;
		sprite.y = vo.y * pixelsPerWU;
		sprite.origin.x = sprite.frameWidth/2;
		sprite.origin.y = sprite.frameHeight/2;
		if(vo.rotation != null) sprite.angle = -vo.rotation;
		if(vo.scaleX != null) sprite.scale.x = vo.scaleX;
		if(vo.scaleY != null) sprite.scale.y = vo.scaleY;
		if(vo.tint != null) {
			sprite.color = FlxColor.fromRGB(Math.round(vo.tint[0]*255), Math.round(vo.tint[1]*255), Math.round(vo.tint[2]*255), Math.round(vo.tint[3]*255));
		}
	}

	private function buildImages(images:Array<Dynamic>):Void {
		for(imageVO in images) {
            var image:FlxSprite = ir.getRegion(imageVO.imageName);
            processMain(image, imageVO);
            add(image);
        }
	}

	private function buildComposites(composites:Array<Dynamic>):Void {
		for(compositeVo in composites) {
            var composite:CompositeItem = new CompositeItem(compositeVo, ir);
            processMain(composite, compositeVo);
            add(composite);
        }
	}
}
 