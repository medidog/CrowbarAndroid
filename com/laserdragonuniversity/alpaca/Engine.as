package com.laserdragonuniversity.alpaca {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import com.adobe.serialization.json.*;

	
	public class Engine extends MovieClip{
		
		public static var player:Player;
		public static var back:Background;
		public static var newBack:String;
		public static var toolbar:Toolbar;
		public static var inv:Inventory;
		public static var options:Options;
		public static var saver:SaveRestore;
		public static var useBox:UseBox;
		public static var puzzle:Puzzle;
		
		private var opening:MovieClip;
		private var ending:MovieClip;
		
		public static var obstacles:Array = new Array();
		public static var usableItems:Array = new Array();
		public static var foreground:Array = new Array();
		public static var exits:Array = new Array();
		
		private var musicURL:String;
		private var endMusicURL:String;
		private var saveURL:String;
		private var saveID:String;
		
		public static var useAudio:Boolean;
		private var playerScale:Number;
		private var walkRate:Number;
		public static var targetBuffer;
		public static var playerName:String;
		public static var playerControl:Boolean = true;
		public static var restoring:Boolean = false;
		
		private var firstLocation:String;
		public static var lastLocation:String;
		
		public static var configData:Object = new Object;
		public static var linesData:Object = new Object;
		private var speechLoader:URLLoader;
		private var configLoader:URLLoader;
		
		public function Engine(){
			/* This roundabout code is necessary to allow the exported alpaca.swf to be dynamically loaded
			into container.swf (that way we can make a load progress bar).  We get errors without it.
			This can cause movie clips to behave strangely sometimes - you may need to put code in certain
			clips in order to ensure that they stay stopped on the first frame like they're supposed to */
			addEventListener(Event.ADDED_TO_STAGE, startGame);
		}
		
		private function startGame(e:Event):void{
			
			removeEventListener(Event.ADDED_TO_STAGE, startGame);
			
			configLoaded(new Event("filler"));
			linesLoaded(new Event("filler"));
			
			stage.addEventListener("changeBackground", changeBackground, false, 0, true);
		} 
		
		private function linesLoaded(e:Event):void{
			var jsonLines:String = '{"observations":{"FIRSTLINE":{"default":" ","this":"Finally! I am in the Double Fine office for the Backers’ Party. Let’s check if my resume survived the fall. Yes, it’s right here, in my fanny pack! Now it is time to join the party."},"NEST":{"look":"Cute. 2HB has a nest apparently.","look2":"2HB is in the other room, admiring the recipe book.","use":"I don’t think 2HB would like me touching his belongings.","lookweird":"Wow! Is that actual lava?! I better be careful around this room!"},"GUITAR":{"look":"It looks like my old electro.","look2":"Yeah that’s how my old guitar ended up too. Maybe I can make use of some of the pieces.","look3":"It is in a much better place now.","use":"I guess I could play it but I should concentrate on getting to the party.","use3":"And do what with them exactly?","usedmug":"That’s not the reaction I was expecting. But..why?","gotcrowbar":"Thankfully, the pieces magically formed a crowbar in my inventory. Otherwise, it would have been really hard to program it."},"MASTERPIECE":{"look":"’HAM’.","usedjack":"All I wanted to do was write ’Hamdi Was Here’, but the knife got stuck! Now it just says ’HAM’."},"WALL":{"look":"It’s a pink wall.","look2":"I call this masterpiece, ’The Fiasco’.","usedwall":"I don’t hear anything.","usedmug":"I don’t hear anything.","usedjack":"All I wanted to do was write ’Hamdi Was Here’, but the knife got stuck! Now it just says ’HAM’.","use":"Yeah this wall is what is missing in my apartment! I can pick it up after the party. I don’t want to carry it around with me.","use2":"Wait for me, my masterpiece! Right after the party."},"GATE":{"look":"I see the main office behind this door. I better find a way to open it!","usedcrowbar":"That’s one way of opening it!","use":"That thing will dice me if I just walk through it. Besides I think there is also a glass panel behind the lasers."},"RESUME":{"look":"It is my resume! I’m glad I thought about bringing my resume with me!","useGUITAR":"I already wrote in my resume that I can play guitar.","useGUITAR2":"Do you want me to put in my resume that I can also break guitars?","useGUITAR3":"Do you want me to put in my resume that I can also break guitars?","useGATE":"Sure, I’ll just throw it at them.","useMIRROR":"That won’t change anything.","usePUDDLE":"I don’t wanna mess up my resume.","useFORK":"I can’t reach it.","useWALL":"I already have it on my wall at home.","usenot":"I’ll hold on to my resume."},"JACKKNIFE":{"look":"I was just thinking about how those scratches were made on this column. This explains a lot.","get":"Got it!","useSCRATCHES":"I don’t wanna mess up his count.","useRECIPES":"I don’t wanna scratch that.","usePUDDLE":"Yuck! I don’t wanna do that.","useFORK":"Don’t worry, fork! I will save you from the clench of that evil ceiling.","useNEST":"I don’t wanna hurt him with his own knife.","usenot":"It is so tiny that I can only scratch my name on a wall with it."},"LID":{"look":"It’s the ventilation lid.","use":"There is no way I can fix it."},"PARTY":{"look":"The party has already started. Is that Tim on the ceiling fan?","look2":"Looks like I can’t join the party. At least I will give them my resume.","use":"I think I’m supposed to check in with the front desk first.","useRESUME":"I need to get in the party first.","usedparty":"Pempelemm, pempeleem... Hehe, I love this song!","use2":"Looks like I can’t join the party. At least I will give them my resume."},"RONDA":{"look":"Office..er.. girl?","usedresume":"Here’s my resume! Thank you for accepting it."},"MUG":{"look":"This could come in handy.","look2":"I pressed all buttons and got this super mixed drink. It’s called Absinthmindedness!","get":"Hehe I have a cool mug! Yippie!","useRESUME":"Genius combination! Combining these two items created...Nothing.","useGATE":"That’s not helpful.","useWALL":"I don’t hear anything.","useFORK2":"I can’t reach it.","useGATE2":"I am afraid it might anger the Lava God, if the alcohol gets into the lava.","usePUDDLE":"Yuck!","useGLASS":"Nah.","useGLASS2":"Nah.","useFILES2":"I don’t wanna melt them.","useLID2":"Melting that would not accomplish anything.","useGRILL2":"You should never mix alcohol and fire.","useRECIPES":"Hey! It is the mug on the recipe book!","useRECIPES2":"Hey! It is the mug on the recipe book!","useNEST2":"I don’t know if he is old enough to drink.","useSCRATCHES2":"I don’t want to spill my drink on that.","useJACKKNIFE2":"I don’t want to spill my drink on that.","useNEST22":"I don’t want to spill my drink on that.","useWALL2":"I don’t want to spill my drink on that.","useWALL22":"I don’t want to spill my drink on that.","useGUITAR":"Would I like a glass of guitar? Hmmm no.","useLIQUERIZER2":"I already have some.","usenot":"I don’t think I need to mug that."},"GLASS":{"look":"This could come in handy.","get":"Hehe I have a cool glass! Yippie!","useWALL2":"I don’t wanna do that here anymore. I will keep this glass for the party.","useLIQUERIZER":"It’s not working. Besides, this is not the right glass for the machine.","useGATE":"That’s not helpful.","useFORK":"I can’t reach it.","useMUG":"Nah.","usePUDDLE":"Yuck! I don’t wanna do that.","useGUITAR":"Would I like a glass of guitar? Hmmm no.","usenot":"I don’t wanna do that."},"MIRROR":{"look":"I am having a bad hair day. I don’t want to look into a mirror right now.","use":"Nah."},"PUDDLE":{"look":"It’s the puddle I landed on. Sticky.","use":"I don’t want to touch it."},"PIANO":{"look":"Hmm, what an interesting piano! I wonder how it works.","look2":"I guess there is a problem with the game, just restart it.","use":"I don’t know how to play.","use2":"I guess there is a problem with the game, just restart it.","usedglass":"Nothing happens!","usedbeforemug":"Let’s see what this mug can do!","usedmug":"Oh, it smells too strong. I bet I can melt things with this."},"LIQUERIZER":{"look":"Cool contraption! I wish I had something like this in my house.","use":"It’s out of ice. I don’t think it works when something is missing."},"RECIPES":{"look":"Double Fine Recipes... I wonder if there are any useful recipes in it.","look2":"Maybe the recipe book holds some hints.","use":"2HB must really like this book, he comes flying in as soon as I start using it."},"SIGN":{"look":"It says that nobody should remove the plaques on the wall and keep belongings safe. Hmm, interesting.","use":"I should probably leave it on the wall."},"VENTILATION":{"look":"I do not want to go back now. No!","use":"I do not want to go back now. No!"},"FILES":{"look":"Oh these folders should be the backers archive. I can see my name from here.","use":"I am the 91,876th backer, yay!"},"GRILL":{"look":"Grill at the office? These guys know how to party.","use":"Should I just forget about the party and grill stuff here? I forgot my patties at home."},"FORK":{"look":"That fork looks useful.","use":"I can’t reach it."},"SCRATCHES":{"look":"Looks like the 2HB has been counting days! How bored could he be?","use":"Nah, I don’t wanna mess up his count."},"PLANS":{"look":"Are those escape plans? Geez!","use":"Yeah I can just use these plans to get out of this room instead of figuring my own way out. Okay. Determination: check. Wings: Nope! *Sigh*"},"CROWBAR":{"look":"This is the coolest thing! I made my own crowbar!","useGUITAR3":"I don’t think I should break it any further.","useLIQUERIZER":"What is this? A rampage against musical instruments??","useNEST":"I don’t want to hurt him.","useWALL":"I can use this crowbar to take this wall with me after the party.","useSIGN":"I should save some of the mischief until after I get hired.","useNEST2":"I don’t want to destroy 2HB’s nest. I’d rather stay on his good side.","useFORK":"I can’t reach it.","useSCRATCHES":"I don’t wanna mess up his count.","usenot":"I have more important stuff to break."},"DEFAULT":"Nah, I don’t think I’m gonna do that."},"dialog":{"RONDA":{"talk":[{"option":"Hi! I am here to join the Backers’ Party.","skipfirst":true,"response":[["door","Congratulations on completing the challenge!"],["player","What challenge?"],["door","The Special Backers’ Trap Challenge sweety. You know, the challenge that needs to be completed in order to attend the party?"],["player","Oh, that challenge. Yeah, thanks. Did you see my smooth moves with the laser door?"],["door","No, I didn’t see it. Come to think of it, I didn’t hear you play the guitar either."],["player","Yeah, I thought about playing it but then I decided to concentrate on getting out of there. But seriously, great setup."],["door","Wait a minute... How did you even open the door without playing the guitar?"],["player","I broke the control panel of the door with my crowbar of course."],["door","..."],["player","Well, the challenge was to get out of the room. And it was obvious from the setup that I needed a crowbar to do that. So I found the Absinthmindedness Mug on the shelves, got the drink from the EZ Piano Liquerizer and poured it over the guitar. And then..."],["door","That is quite enough. From the way the story is going, I don’t want to know the rest of it."],["player","Good, ’cause I don’t want to waste any more time here instead of being in the party now."],["door","As long as you show me the Trap Challenge Item, you can go in."],["player","Now, you are speaking in riddles, Ronda. What item would that be?"],["door","The coin."],["player","Coin? I didn’t see any coins besides a picture of it on the recipe book cover. Are you talking about that coin?"],["door","Yes, that is the one. Judging from your adventurer skills, it’s odd that you didn’t come across it."],["player","It is not my fault if you hid it that well."],["door","It was supposed to be lying on the floor. Next to the piano."],["player","Geez."]],"submenu":[{"option":"So I can’t join the party without the coin?","response":[["door","It is so unfortunate that you could not find the coin, but I really can’t allow you into the party without it."],["player","What is the significance of this coin anyway?"],["door","Um, let’s see... You were supposed to find the coin, insert it into the guitar, then you’d hear the instructions on how to open the laser door."],["player","But, that is too logical for an adventure challenge."]]},{"option":"Isn’t this crowbar still acceptable as a Trap Challenge item?","response":[["door","I am afraid not."],["player","But come on! It is THE adventure item of all time."],["door","Sorry, it is also necessary to open the door to the party. We were assuming if you made it this far, you would have the coin with you."],["player","I could still break into the party with my crowbar."],["door","Believe me, 2HB tried that so many times."]]},{"option":"By the way, what’s up with 2HB?","response":[["door","Shh shh sh, don’t talk about him in such a high volume. Whisper instead. What about him?"],["player","Okay, okay. I think he’s counting the days he spent in his nest."],["door","Wow, you really cannot whisper, can you?"],["player","I am whispering?!"],["door","Anyway, those are not days. He’s counting the number of adventurers who could not make it into the party."],["player","So I am just another notch.."],["door","Another what, dear?"],["player","Scratch, another scratch."]]},{"option":"Can I stay a little longer and watch the party?","response":[["door","Yeah sure. Oh.. You are serious."]]},{"option":"I give up! Since I cannot join the party, can I at least leave my resume with you?","response":[["door","Sure, you can leave it on my desk."],["player","Thanks. I’ll put it as soon as the conversation is over."]],"specialeffect":"endGame","action":"end"}]},{"option":"Hey baby, I am here for the party. Now, be a doll and open the door for me.","skipfirst":true,"response":[["door","Congratulations on completing the challenge!"],["player","What challenge?"],["door","The Special Backers’ Trap Challenge sweety. You know, the challenge that needs to be completed in order to attend the party?"],["player","Oh, that challenge. Yeah, thanks. Did you see my smooth moves with the laser door?"],["door","No, I didn’t see it. Come to think of it, I didn’t hear you play the guitar either."],["player","Yeah, I thought about playing it but then I decided to concentrate on getting out of there. But seriously, great setup."],["door","Wait a minute... How did you even open the door without playing the guitar?"],["player","I broke the control panel of the door with my crowbar of course."],["door","..."],["player","Well, the challenge was to get out of the room. And it was obvious from the setup that I needed a crowbar to do that. So I found the Absinthmindedness Mug on the shelves, got the drink from the EZ Piano Liquerizer and poured it over the guitar. And then..."],["door","That is quite enough. From the way the story is going, I don’t want to know the rest of it."],["player","Good, ’cause I don’t want to waste any more time here instead of being in the party now."],["door","As long as you show me the Trap Challenge Item, you can go in."],["player","Now, you are speaking in riddles, Ronda. What item would that be?"],["door","The coin."],["player","Coin? I didn’t see any coins besides a picture of it on the recipe book cover. Are you talking about that coin?"],["door","Yes, that is the one. Judging from your adventurer skills, it’s odd that you didn’t come across it."],["player","It is not my fault if you hid it that well."],["door","It was supposed to be lying on the floor. Next to the piano."],["player","Geez."]],"submenu":[{"option":"So I can’t join the party without the coin?","response":[["door","It is so unfortunate that you could not find the coin, but I really can’t allow you into the party without it."],["player","What is the significance of this coin anyway?"],["door","Um, let’s see... You were supposed to find the coin, insert it into the guitar, then you’d hear the instructions on how to open the laser door."],["player","But, that is too logical for an adventure challenge."]]},{"option":"Isn’t this crowbar still acceptable as a Trap Challenge item?","response":[["door","I am afraid not."],["player","But come on! It is THE adventure item of all time."],["door","Sorry, it is also necessary to open the door to the party. We were assuming if you made it this far, you would have the coin with you."],["player","I could still break into the party with my crowbar."],["door","Believe me, 2HB tried that so many times."]]},{"option":"By the way, what’s up with 2HB?","response":[["door","Shh shh sh, don’t talk about him in such a high volume. Whisper instead. What about him?"],["player","Okay, okay. I think he’s counting the days he spent in his nest."],["door","Wow, you really cannot whisper, can you?"],["player","I am whispering?!"],["door","Anyway, those are not days. He’s counting the number of adventurers who could not make it into the party."],["player","So I am just another notch.."],["door","Another what, dear?"],["player","Scratch, another scratch."]]},{"option":"Can I stay a little longer and watch the party?","response":[["door","Yeah sure. Oh.. You are serious."]]},{"option":"I give up! Since I cannot join the party, can I at least leave my resume with you?","response":[["door","Sure, you can leave it on my desk."],["player","Thanks. I’ll put it as soon as the conversation is over."]],"specialeffect":"endGame","action":"end"}]},{"option":"Hello, the life of the party is here! Now where is the bar?","skipfirst":true,"response":[["door","Congratulations on completing the challenge!"],["player","What challenge?"],["door","The Special Backers’ Trap Challenge sweety. You know, the challenge that needs to be completed in order to attend the party?"],["player","Oh, that challenge. Yeah, thanks. Did you see my smooth moves with the laser door?"],["door","No, I didn’t see it. Come to think of it, I didn’t hear you play the guitar either."],["player","Yeah, I thought about playing it but then I decided to concentrate on getting out of there. But seriously, great setup."],["door","Wait a minute... How did you even open the door without playing the guitar?"],["player","I broke the control panel of the door with my crowbar of course."],["door","..."],["player","Well, the challenge was to get out of the room. And it was obvious from the setup that I needed a crowbar to do that. So I found the Absinthmindedness Mug on the shelves, got the drink from the EZ Piano Liquerizer and poured it over the guitar. And then..."],["door","That is quite enough. From the way the story is going, I don’t want to know the rest of it."],["player","Good, ’cause I don’t want to waste any more time here instead of being in the party now."],["door","As long as you show me the Trap Challenge Item, you can go in."],["player","Now, you are speaking in riddles, Ronda. What item would that be?"],["door","The coin."],["player","Coin? I didn’t see any coins besides a picture of it on the recipe book cover. Are you talking about that coin?"],["door","Yes, that is the one. Judging from your adventurer skills, it’s odd that you didn’t come across it."],["player","It is not my fault if you hid it that well."],["door","It was supposed to be lying on the floor. Next to the piano."],["player","Geez."]],"submenu":[{"option":"So I can’t join the party without the coin?","response":[["door","It is so unfortunate that you could not find the coin, but I really can’t allow you into the party without it."],["player","What is the significance of this coin anyway?"],["door","Um, let’s see... You were supposed to find the coin, insert it into the guitar, then you’d hear the instructions on how to open the laser door."],["player","But, that is too logical for an adventure challenge."]]},{"option":"Isn’t this crowbar still acceptable as a Trap Challenge item?","response":[["door","I am afraid not."],["player","But come on! It is THE adventure item of all time."],["door","Sorry, it is also necessary to open the door to the party. We were assuming if you made it this far, you would have the coin with you."],["player","I could still break into the party with my crowbar."],["door","Believe me, 2HB tried that so many times."]]},{"option":"By the way, what’s up with 2HB?","response":[["door","Shh shh sh, don’t talk about him in such a high volume. Whisper instead. What about him?"],["player","Okay, okay. I think he’s counting the days he spent in his nest."],["door","Wow, you really cannot whisper, can you?"],["player","I am whispering?!"],["door","Anyway, those are not days. He’s counting the number of adventurers who could not make it into the party."],["player","So I am just another notch.."],["door","Another what, dear?"],["player","Scratch, another scratch."]]},{"option":"Can I stay a little longer and watch the party?","response":[["door","Yeah sure. Oh.. You are serious."]]},{"option":"I give up! Since I cannot join the party, can I at least leave my resume with you?","response":[["door","Sure, you can leave it on my desk."],["player","Thanks. I’ll put it as soon as the conversation is over."]],"specialeffect":"endGame","action":"end"}]},{"option":"Oh my god! I love your hair!","skipfirst":true,"response":[["door","Congratulations on completing the challenge!"],["player","What challenge?"],["door","The Special Backers’ Trap Challenge sweety. You know, the challenge that needs to be completed in order to attend the party?"],["player","Oh, that challenge. Yeah, thanks. Did you see my smooth moves with the laser door?"],["door","No, I didn’t see it. Come to think of it, I didn’t hear you play the guitar either."],["player","Yeah, I thought about playing it but then I decided to concentrate on getting out of there. But seriously, great setup."],["door","Wait a minute... How did you even open the door without playing the guitar?"],["player","I broke the control panel of the door with my crowbar of course."],["door","..."],["player","Well, the challenge was to get out of the room. And it was obvious from the setup that I needed a crowbar to do that. So I found the Absinthmindedness Mug on the shelves, got the drink from the EZ Piano Liquerizer and poured it over the guitar. And then..."],["door","That is quite enough. From the way the story is going, I don’t want to know the rest of it."],["player","Good, ’cause I don’t want to waste any more time here instead of being in the party now."],["door","As long as you show me the Trap Challenge Item, you can go in."],["player","Now, you are speaking in riddles, Ronda. What item would that be?"],["door","The coin."],["player","Coin? I didn’t see any coins besides a picture of it on the recipe book cover. Are you talking about that coin?"],["door","Yes, that is the one. Judging from your adventurer skills, it’s odd that you didn’t come across it."],["player","It is not my fault if you hid it that well."],["door","It was supposed to be lying on the floor. Next to the piano."],["player","Geez."]],"submenu":[{"option":"So I can’t join the party without the coin?","response":[["door","It is so unfortunate that you could not find the coin, but I really can’t allow you into the party without it."],["player","What is the significance of this coin anyway?"],["door","Um, let’s see... You were supposed to find the coin, insert it into the guitar, then you’d hear the instructions on how to open the laser door."],["player","But, that is too logical for an adventure challenge."]]},{"option":"Isn’t this crowbar still acceptable as a Trap Challenge item?","response":[["door","I am afraid not."],["player","But come on! It is THE adventure item of all time."],["door","Sorry, it is also necessary to open the door to the party. We were assuming if you made it this far, you would have the coin with you."],["player","I could still break into the party with my crowbar."],["door","Believe me, 2HB tried that so many times."]]},{"option":"By the way, what’s up with 2HB?","response":[["door","Shh shh sh, don’t talk about him in such a high volume. Whisper instead. What about him?"],["player","Okay, okay. I think he’s counting the days he spent in his nest."],["door","Wow, you really cannot whisper, can you?"],["player","I am whispering?!"],["door","Anyway, those are not days. He’s counting the number of adventurers who could not make it into the party."],["player","So I am just another notch.."],["door","Another what, dear?"],["player","Scratch, another scratch."]]},{"option":"Can I stay a little longer and watch the party?","response":[["door","Yeah sure. Oh.. You are serious."]]},{"option":"I give up! Since I cannot join the party, can I at least leave my resume with you?","response":[["door","Sure, you can leave it on my desk."],["player","Thanks. I’ll put it as soon as the conversation is over."]],"specialeffect":"endGame","action":"end"}]},{"option":"Never mind.","action":"end"}],"useObject":{"GLASS":[["player","I wanted to have a drink, but the machine is out of ice."],["door","I am sorry, I don’t think we have any more left."],["player","Never mind then."]],"RESUME":[["player","Here is my resume."],["door","Sorry dear, I am busy right now."],["player","Oh, ok."]]}}}}';
			linesData = JSON.parse(jsonLines);
		}
		
		private function configLoaded(e:Event):void{
			useAudio = false;
			playerScale=1;
			walkRate=10;
			targetBuffer = 20;
			playerName = "Player";
			firstLocation="room";
			saveID = "alpacasample";
			
			createBackground(firstLocation);
			createUI();

			// This needs to be here or Flash gets annoyed
			useBox = new UseBox(stage, usableItems[0]);
			
			// Add the intro screen over everything else
			// This can be a fully animated intro if we want - anything that fits in a movie clip
			opening = new introScreen;
			addChild(opening);
			opening.addEventListener(Event.ENTER_FRAME, checkFrame);
			
			function autoClick():void
				{
				//And finally dispatching our event to this button. It will think that a person has clicked it
				opening.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, true, stage.stageWidth / 2, stage.stageHeight / 2));

				}

			function checkFrame():void{
    			if(opening.currentFrame==opening.totalFrames){
        			//do something
					opening.addEventListener(MouseEvent.CLICK, removeIntro, false, 0, true);
					autoClick();
    			}
			}
		}
		
		private function createBackground(thisBack:String):void{
			trace("Creating new background: "+thisBack);
			var playerLoc:MovieClip;

			
			back = new Background(stage, thisBack);
			addChild(back);
			obstacles = back.returnObstacles();
			for (var i in obstacles){
				addChild(obstacles[i]);
			}
			
			if (restoring){
				playerLoc = new MovieClip();
				playerLoc.x = 0;
				playerLoc.y = 0;
			} else if (lastLocation){
				var lastLocName = "startPoint_"+lastLocation; 
				playerLoc = back.currentBack[lastLocName];
			} else {
				playerLoc = back.currentBack.startPoint;
			}
			
			player = new Player(stage, walkRate, targetBuffer);
			if (playerLoc.x > stage.stageWidth / 2){
				player.scaleX = -playerScale;
			}else {
				player.scaleX = playerScale;
			}
			player.scaleY = playerScale;
			player.x = playerLoc.x;
			player.y = playerLoc.y;
			
			if (restoring){
				saver.dispatchEvent(new Event("repose"));
				restoring = false;
			}
			
			addChild(player);
			player.addEventListener("playerWalking", startDepth, false, 0, true);
			player.name = playerName;
			
			foreground = back.returnForeground();
			for (i in foreground){
				addChild(foreground[i]);
			}
			
			usableItems = back.returnItems();
			exits = back.returnExits();
			for (i in exits){
				addChild(exits[i]);
			}
			
			// Add event listeners for all the usable items
			for (i in usableItems){
				var thisClip = usableItems[i];
				thisClip.buttonMode = true;
				thisClip.addEventListener(MouseEvent.CLICK, examine, false, 0, true);
				thisClip.gotoAndStop(1);
			}
			
			back.currentBack.ground.addEventListener(MouseEvent.CLICK, movePlayer, false, 0, true);
			
			// Keep the toolbar at the highest depth
			if (toolbar){
				puzzle.newBackground(thisBack);
				changeUIDepth();
				toolbar.addListeners();
				
				// Remove any items the player has already picked up
				var allInv:Array = inv.returnItems("all");
				for (i in usableItems){
					for (var j in allInv){
						if (usableItems[i].displayName == allInv[j].displayName){
							usableItems[i].visible = false;
						}
					}
				}
			}
			
		}
		
		private function changeBackground(e:Event){
			back.clearStage();
			removeChild(back);
			for (var i in obstacles){
				removeChild(obstacles[i]);
				obstacles[i].visible = false;
			}
			for (i in foreground){
				removeChild(foreground[i]);
				foreground[i].visible = false;
			}
			for (i in usableItems){
				usableItems[i].visible = false;
			}
			for (i in exits){
				removeChild(exits[i]);
				exits[i].visible = false;
			}
			removeChild(player);
			createBackground(newBack);
		}
			
		
		private function createUI():void{
			
			toolbar = new Toolbar(stage);
			addChild(toolbar);
			toolbar.x = 0;
			toolbar.y = 0;

			inv = new Inventory(stage);
			addChild(inv);
			inv.x = 5;
			inv.y = 0;
			inv.visible = false;
			
			options = new Options(stage, musicURL);
			addChild(options);
			options.x = 100;
			options.y = 50;
			options.visible = false;
			
			saver = new SaveRestore(stage, saveURL, saveID);
			addChild(saver);
			saver.x = 100;
			saver.y = 50;
			saver.visible = false;
			
			puzzle = new Puzzle(stage);
			
			stage.addEventListener("endGame", endGame, false, 0, true);
		}
		
		private function removeIntro(e:MouseEvent):void{
			removeChild(opening);
			opening.removeEventListener(MouseEvent.CLICK, removeIntro);
			puzzle.firstAction();
		}
		
		private function movePlayer(e:MouseEvent):void{
			if (playerControl){
				stage.dispatchEvent(new Event("playerMoving"));
				player.startWalking(mouseX, mouseY);
				if (stage.contains(useBox)){
					stage.removeChild(useBox);
				}
			}
		}
		
		private function examine(e:MouseEvent):void{
			if (player.hasEventListener(Event.ENTER_FRAME)==false){
				stage.dispatchEvent(new Event("itemClicked"));
				if (inv.draggingItem == false  && playerControl){
					useBox = new UseBox(stage, e.currentTarget);
					useBox.x = mouseX;
					useBox.y = mouseY;
					stage.addChild(useBox);
				}
			}
		}
		
		private function startDepth(e:Event):void{
			addEventListener(Event.ENTER_FRAME, checkPlayerDepth, false, 0, true);
		}
		
		private function checkPlayerDepth(e:Event):void{
			if (player.currentLabel == "walk"){
				var playerDepth = getChildIndex(player);
				for (var i in obstacles){
					var blockDepth = getChildIndex(obstacles[i]);
					if (player.y > obstacles[i].depthSplit.y + obstacles[i].y && playerDepth < blockDepth){
						changePlayerDepth("front", obstacles[i]);
					} 
					if (player.y < obstacles[i].depthSplit.y + obstacles[i].y && playerDepth > blockDepth){
						changePlayerDepth("behind", obstacles[i]);
					}
				}
			}else {
				removeEventListener(Event.ENTER_FRAME, checkPlayerDepth);
			}
			
		}
		
		private function changePlayerDepth(where:String, what:MovieClip):void{
			
			var playerindex = getChildIndex(player);
			var otherindex = getChildIndex(what);
			
			if (where == "behind"){
				setChildIndex(player, otherindex);
			} else {
				setChildIndex(what, playerindex);
				setChildIndex(player, otherindex);
			}
		}
			
		private function changeUIDepth():void{
			
			setChildIndex(toolbar, 0);
			setChildIndex(inv, 0);
			for (var i in exits){
				setChildIndex(exits[i], 0);
			}
			for (i in foreground){
				setChildIndex(foreground[i], 0);
			}
			setChildIndex(player, 0);
			for (i in obstacles){
				setChildIndex(obstacles[i], 0);
			}
			
			back.gotoBack();
			
		}
			
		private function endGame(e:Event):void{
			ending = new endScreen;
			addChild(ending);
		}
	} //end Engine class
} // end package