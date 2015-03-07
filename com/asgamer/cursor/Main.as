package com.asgamer.cursor 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Main extends Sprite
	{
		
		private var cursor:Cursor;
		private var timer:Timer;
		
		public function Main() : void
		{
			cursor = new Cursor(stage);
			stage.addChild(cursor);
			
			timer = new Timer(1000);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, createNewMc);
		}
		
		private function createNewMc(e:TimerEvent) : void
		{
			var mc:MovieClip = new MovieClip();
			
			mc.graphics.beginFill(0xFFAA00);
			mc.graphics.drawCircle(0,0, Math.random() * 50);
			mc.graphics.endFill();
			
			mc.x = Math.random() * 550;
			mc.y = Math.random() * 400;
			stage.addChild(mc);
		}
		
	}
		
}