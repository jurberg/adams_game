package game {

import flash.events.MouseEvent;
import flash.geom.*;
import mx.core.*;

public class Player extends AnimatedGameObject {

	protected static const speed:Number = 100;
	
	protected var destination:Point = new Point();

	public function Player() {
		super();
	}
	
	public function startup():void {
		moving = false;
		super.startupAnimatedGameObject(ResourceManager.StickManGraphics, new Point(), 100, false);
	}
	
	public override function shutdown():void {
		super.shutdown();
	}
	
	public override function mouseUp(event:MouseEvent):void {
		this.destination = new Point(event.stageX, event.stageY);
		this.moving = true;
	}
	
	public override function enterFrame(dt:Number):void {
		super.enterFrame(dt);
		
		if (!moving) return;
		
		var pos:Point = new Point(destination.x - position.x, destination.y - position.y);

		//Stop moving when we get to the destination
		if (pos.x < 1 && pos.x > -1 && pos.y < 1 && pos.y > -1) {
			moving = false;
			return;
		}
				
		//Switch direction of graphics when destination is backwards
		if (pos.x < 0) {
			this.graphics = ResourceManager.StickManBackGraphics;
		} else {
			this.graphics = ResourceManager.StickManGraphics;
		}
		
		// move to the next position
		pos.normalize(speed * dt);
		position.x += pos.x;
		position.y += pos.y;
		
	}
	
}
	
}