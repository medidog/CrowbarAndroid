package com.asgamer.cursor
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;

	public class Cursor extends MovieClip
	{
		
		private var stageRef:Stage;
		private var p:Point = new Point(); //keeps up with last known mouse position
		
		public function Cursor(stageRef:Stage)
		{
			Mouse.hide(); //make the mouse disappear
			mouseEnabled = false;
			mouseChildren = false;
			
			this.stageRef = stageRef;
			x = stageRef.mouseX;
			y = stageRef.mouseY;
			
			stageRef.addEventListener(MouseEvent.MOUSE_MOVE, updateMouse, false, 0, true);
			stageRef.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
			stageRef.addEventListener(Event.ADDED, updateStack, false, 0, true);
		}
		
		private function updateStack(e:Event) : void
		{
			stageRef.addChild(this);
		}
		
		private function mouseLeaveHandler(e:Event) : void
		{
			visible = false;
			Mouse.show(); //in case of right click
			stageRef.addEventListener(MouseEvent.MOUSE_MOVE, mouseReturnHandler, false, 0, true);
		}
		
		private function mouseReturnHandler(e:Event) : void
		{
			visible = true;
			Mouse.hide(); //in case of right click
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseReturnHandler);
		}
		
		private function updateMouse(e:MouseEvent) : void
		{
			x = stageRef.mouseX;
			y = stageRef.mouseY;
			
			var newRotation:Number = Math.atan2(y - p.y, x - p.x) * 180 / Math.PI;
			if (newRotation - rotation > 180) 
					newRotation -= 360;
			else if (rotation - newRotation > 180)
					newRotation += 360;
			
			rotation -= (rotation - newRotation) / 10;
			
			p.x = x;
			p.y = y;
			
			e.updateAfterEvent();
		}
		
	}
	
}