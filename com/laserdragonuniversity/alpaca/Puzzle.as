package com.laserdragonuniversity.alpaca {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.ui.Mouse;
	import com.adobe.serialization.json.*;

	public class Puzzle extends MovieClip{
		
		private var stageRef:Stage;
		private var back:Background;
		private var inv:Inventory;
		private var player:Player;
		private var actionMC:MovieClip;
		private var speech:Speech;
		private var muzak:Muzak;
		private var toolbar:Toolbar;
		private var dialog:Dialog;
		private var darkness:MovieClip;
		private var allPuzzles:Object;
		
		private var newSpeech:Sound = new Sound();
		private var channel:SoundChannel = new SoundChannel();
		
		public function Puzzle(stageRef:Stage){
			
			this.stageRef = stageRef;
			
			back = Engine.back;
			inv = Engine.inv;
			player = Engine.player;
			toolbar = Engine.toolbar;
			
			allPuzzles = new Object;
			
			allPuzzles.room = new Object;
			allPuzzles.room.sphereUsed = false;
			allPuzzles.room.pianoUsed = false;
			allPuzzles.room.boxUsed = false;
			allPuzzles.room.gotBalloon = false;
			allPuzzles.room.switchOn = false;
			allPuzzles.room.usedSwitch = false;
			allPuzzles.room.bookOn = false;
			allPuzzles.room.usedBook = false;
			allPuzzles.room.wallUsed = false;
			allPuzzles.room.jackUsed = false;
			allPuzzles.room.mugwallUsed = false;

			
			allPuzzles.hangar = new Object;
			allPuzzles.hangar.doorBroken = false;
			allPuzzles.hangar.partyUsed = false;

			allPuzzles.tundra = new Object;
			allPuzzles.tundra.skyWeird = false;
			allPuzzles.tundra.skyWeirdCount = 0;
			allPuzzles.tundra.ledgeUsed = false;
			
			allPuzzles.room = allPuzzles.room;
			allPuzzles.hangar= allPuzzles.hangar;
			allPuzzles.tundra = allPuzzles.tundra;
			
		}
		
		public function returnPuzzles():Object{
			//trace ("Returning puzzles");
			return allPuzzles;
		}
		
		public function restorePuzzles(savedPuzzles:Object){
			//trace("Restoring puzzles...");
			allPuzzles = savedPuzzles;
		}
		
		public function firstAction():void{
			/* Creating this object is a clunky way to fit an unmoored line like this into the current
			dialog structure.  Changing the structure would probably be a good idea if the player is 
			going to talk a lot, and not necessarily while examining items */
			var lineObj:Object = new Object();
			var liquerizer;
			var masterpiece;
			var resume;
					for (var i in Engine.usableItems){// There's surely a better way to do this
						if (Engine.usableItems[i].displayName == "LIQUERIZER")
							liquerizer = Engine.usableItems[i];
						if (Engine.usableItems[i].displayName == "MASTERPIECE")
							masterpiece = Engine.usableItems[i];
					}
			liquerizer.visible = false;
			masterpiece.visible = false;
			resume = new resumeProper;
			resume.displayName = "RESUME";
			inv.addInvItem(resume.displayName);
			lineObj.displayName = "FIRSTLINE";
			speech = new Speech(stageRef, lineObj, "default"); 
						Engine.playerControl = false;
						Mouse.hide();
						var timer:Timer = new Timer(2500, 1);
						timer.addEventListener(TimerEvent.TIMER, firstAction, false, 0, true);
						timer.start();
						function firstAction(e:TimerEvent):void{
							timer.stop();
							Engine.playerControl = true;
							Mouse.hide();
							speech = new Speech(stageRef, lineObj, "this");
							timer.removeEventListener(TimerEvent.TIMER, firstAction);
						}
			
		}
		
		public function newBackground(thisBack:String):void{
			var room = back.currentBack;
			switch (thisBack){
				case "room":
					var glass;
					var box;
					var sphere;
					var lightswitch;
					var liquerizer;
					var wall;
					var masterpiece;
					for (var i in Engine.usableItems){// There's surely a better way to do this
						if (Engine.usableItems[i].displayName == "GLASS")
							glass = Engine.usableItems[i];
						if (Engine.usableItems[i].displayName == "GUITAR")
							box = Engine.usableItems[i];
						if (Engine.usableItems[i].displayName == "PIANO")
							sphere = Engine.usableItems[i];
						if (Engine.usableItems[i].displayName == "LIQUERIZER")
							liquerizer = Engine.usableItems[i];
						if (Engine.usableItems[i].displayName == "RECIPES")
							lightswitch = Engine.usableItems[i];
						if (Engine.usableItems[i].displayName == "WALL")
							wall = Engine.usableItems[i];
						if (Engine.usableItems[i].displayName == "MASTERPIECE")
							masterpiece = Engine.usableItems[i];
					}
					if (allPuzzles.room.boxUsed == true){
						box.gotoAndStop("open");
						box.lookTag = "2";
						box.usable = true;
						if (allPuzzles.room.gotBalloon == true){
							box.usable = false;
							box.lookTag = "3";
						}
					} else {
						box.gotoAndStop("default");
					}
					if (allPuzzles.room.sphereUsed == true){
						sphere.gotoAndStop("open");
						sphere.lookTag = "2";
					} else {
						liquerizer.visible = false;
					}
					if (allPuzzles.room.switchOn == true){
						lightswitch.gotoAndStop("on");
					} else {
						lightswitch.gotoAndStop("off");
					}
					if (allPuzzles.room.usedSwitch == true){
						lightswitch.lookTag = "2";
					}
					if (allPuzzles.room.jackUsed == true){
						wall.gotoAndStop("open");
						wall.lookTag = "2";
					} else {
						masterpiece.visible = false;
					}

				break;
				
				case "hangar":
					var door;
					var party;
					for (i in Engine.usableItems){ // Ditto
						if (Engine.usableItems[i].displayName == "RONDA")
							door = Engine.usableItems[i];
						if (Engine.usableItems[i].displayName == "PARTY")
							party = Engine.usableItems[i];
					}
					if (allPuzzles.hangar.partyUsed == true){
						party.lookTag = "2";
					} else {
						party.gotoAndStop("default");
					}
					
				break;
				
				case "tundra":
					var mountains;
					var ledge;
					var jackknife;
					var exitHangar;
					for (i in Engine.usableItems){ // Ditto
						if (Engine.usableItems[i].displayName == "GATE")
							ledge = Engine.usableItems[i];
						if (Engine.usableItems[i].displayName == "JACKKNIFE")
							jackknife = Engine.usableItems[i];
					}
					for (i in Engine.exits){// Ditto
						if (Engine.exits[i].name == "EXIT_hangar")
							exitHangar = Engine.exits[i];
					}
					if (allPuzzles.tundra.ledgeUsed == true){
						ledge.visible = false;
						exitHangar.visible = true;
					} else {
						exitHangar.visible = false;
					}
					for (i in Engine.usableItems){
						if (Engine.usableItems[i].displayName == "NEST")
							mountains = Engine.usableItems[i];
					}
					if (allPuzzles.room.switchOn == true){
						mountains.gotoAndStop("changed");
						jackknife.visible = true;
						allPuzzles.tundra.skyWeirdCount += 1;
						if (allPuzzles.tundra.skyWeirdCount < 2)
							speech = new Speech(stageRef, mountains, "lookweird");
						mountains.lookTag = "2";
					} else {
						mountains.gotoAndStop("default");
						jackknife.visible = false;
						allPuzzles.tundra.skyWeirdCount += 1;
						if (allPuzzles.tundra.skyWeirdCount < 2)
							speech = new Speech(stageRef, mountains, "lookweird");
						mountains.lookTag = null;
					}
				break;
			}
		}
		
		public function gotItem(thisItem:String):void{
			// This is empty now, but it gets called every time something is added to the inventory, in case anything special needs to happen
		}
		
		public function usedItem(thisItem:String):void{
			switch (thisItem){
				case "RECIPES":
					var lightswitch;
					for (var i in Engine.usableItems){
						if (Engine.usableItems[i].displayName == "RECIPES")
							lightswitch = Engine.usableItems[i];
					}
					if (lightswitch.currentLabel == "on"){
						lightswitch.gotoAndStop("turnOff");
						allPuzzles.room.switchOn = false;
					} else {
						lightswitch.gotoAndStop("turnOn");
						allPuzzles.room.switchOn = true;
					}
					if (allPuzzles.room.usedSwitch == false){
						allPuzzles.room.usedSwitch = true;
						Engine.playerControl = false;
						Mouse.hide();
						var timer:Timer = new Timer(1500, 1);
						timer.addEventListener(TimerEvent.TIMER, sayLine, false, 0, true);
						timer.start();
						function sayLine(e:TimerEvent):void{
							timer.stop();
							Engine.playerControl = true;
							Mouse.hide();
							speech = new Speech(stageRef, lightswitch, "use");
							timer.removeEventListener(TimerEvent.TIMER, sayLine);
							lightswitch.lookTag = "2";
						}
						
						
					}
				break;
			}
		}
			
						
		public function performedAction(actionMC:MovieClip):void{
			this.actionMC = actionMC;
			var clipString:String = String(actionMC); // I can't figure out how to identify the movieclip without converting it to a string (instance names are inconsistent), hence this goofy workaround
			switch (clipString){
				case "[object action_MUG2_GUITAR]":
					var box;
					for (var i in Engine.obstacles){ // This could be made much more elegant, couldn't it?
						if (Engine.obstacles[i].displayName == "GUITAR")
							box = Engine.obstacles[i];
					}
					box.gotoAndStop("open");
					speech = new Speech(stageRef, box, "usedmug");
					box.lookTag = "2";
					box.usable = true;
					inv.removeInvItem("MUG");
					allPuzzles.room.boxUsed = true;
				break;
				
				case "[object action_MUG_PIANO]":
					var currentItems:Array = inv.returnItems(null);
					var mug;
					var sphere;
					var liquerizer;
					for (i in currentItems){
						if (currentItems[i].displayName == "MUG")
							mug = currentItems[i];
					}
					for (i in Engine.usableItems){
						if (Engine.usableItems[i].displayName == "PIANO")
							sphere = Engine.usableItems[i];
						if (Engine.usableItems[i].displayName == "LIQUERIZER")
							liquerizer = Engine.usableItems[i];
					}
					mug.gotoAndStop("open");
					sphere.gotoAndStop("open");
					speech = new Speech(stageRef, sphere, "usedmug");
					sphere.visible = false;
					liquerizer.visible = true;
					mug.lookTag = "2";
					sphere.lookTag = "2";
					allPuzzles.room.sphereUsed = true;
				break;
				
				case "[object action_GUITAR_USE]":
					for (i in Engine.obstacles){
						if (Engine.obstacles[i].displayName == "GUITAR")
							box = Engine.obstacles[i];
					}
					var crowbar;
					crowbar = new crowbarProper;
					crowbar.displayName = "CROWBAR";
					inv.addInvItem(crowbar.displayName);
					allPuzzles.room.gotBalloon = true;
					box.lookTag = null;
					speech = new Speech(stageRef, box, "gotcrowbar");
					box.lookTag = "3";
					box.usable = false;
					
				break;
				
				case "[object action_GLASS_PIANO]":
					var glass;
					for (i in currentItems){
						if (currentItems[i].displayName == "GLASS")
							glass = currentItems[i];
					}
					for (i in Engine.usableItems){
						if (Engine.usableItems[i].displayName == "PIANO")
							sphere = Engine.usableItems[i];
					}
					speech = new Speech(stageRef, sphere, "usedglass");
					allPuzzles.room.pianoUsed = true;
				break;

				case "[object action_GLASS_PARTY]":
					var party;
					for (i in currentItems){
						if (currentItems[i].displayName == "GLASS")
							glass = currentItems[i];
					}
					for (i in Engine.usableItems){
						if (Engine.usableItems[i].displayName == "PARTY")
							party = Engine.usableItems[i];
					}
					speech = new Speech(stageRef, party, "usedparty");
					allPuzzles.hangar.partyUsed = true;
				break;
				
				case "[object action_JACKKNIFE_WALL]":
					var wall;
					var jackknife;
					var masterpiece;
					for (i in currentItems){
						if (currentItems[i].displayName == "JACKKNIFE")
							jackknife = currentItems[i];
					}
					for (i in Engine.usableItems){
						if (Engine.usableItems[i].displayName == "WALL")
							wall = Engine.usableItems[i];
						if (Engine.usableItems[i].displayName == "MASTERPIECE")
							masterpiece = Engine.usableItems[i];
					}
					wall.lookTag = "2";
					allPuzzles.room.jackUsed = true;
					speech = new Speech(stageRef, masterpiece, "usedjack");
					inv.removeInvItem("JACKKNIFE");
					masterpiece.visible = true;
				break;
				
				case "[object action_MUG_WALL]":
					for (i in currentItems){
						if (currentItems[i].displayName == "MUG")
							mug = currentItems[i];
					}
					for (i in Engine.usableItems){
						if (Engine.usableItems[i].displayName == "WALL")
							wall = Engine.usableItems[i];
					}
					speech = new Speech(stageRef, wall, "usedmug");
					allPuzzles.room.mugwallUsed = true;
				break;
				
				case "[object action_GLASS_WALL]":
					for (i in currentItems){
						if (currentItems[i].displayName == "GLASS")
							glass = currentItems[i];
					}
					for (i in Engine.usableItems){
						if (Engine.usableItems[i].displayName == "WALL")
							wall = Engine.usableItems[i];
					}
					speech = new Speech(stageRef, wall, "usedwall");
					allPuzzles.room.wallUsed = true;
				break;
				
				case "[object action_CROWBAR_GATE]":
					var ledge;
					var exitHangar;
					for (i in Engine.usableItems){ // Blurgh
						if (Engine.usableItems[i].displayName == "GATE")
							ledge = Engine.usableItems[i];
					}
					for (i in Engine.exits){
						if (Engine.exits[i].name == "EXIT_hangar")
							exitHangar = Engine.exits[i];
					}
					exitHangar.visible = true;
					ledge.visible = false;
					speech = new Speech(stageRef, ledge, "usedcrowbar");
					allPuzzles.tundra.ledgeUsed = true;
				break;
					
			}
		}
		
		public function spokeDialog(thisDialog:Object):void{
		switch(thisDialog.specialeffect){
		case "endGame":
		stageRef.dispatchEvent(new Event("endGame"));
		break;
		}
		}
			
	}//end class
}//end package