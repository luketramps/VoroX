package com.luketramps.vorox.utils 
{
	import ash.core.Engine;
	import ash.core.System;
	import ash.signals.Signal1;
	import com.luketramps.vorox.data.PointVX;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	/**
	 * @author Lukas Damian Opacki
	 */
	public class MouseInput extends System
	{
		[Inject] 
		public var stage:Stage;
		
		[Inject (name = "touch")] 
		public var onTouch:Signal1;
		
		public var lastTouch:PointVX;
		
		[PostConstruct]
		public function onInjectionComplete():void
		{
			lastTouch = new PointVX ();
			enable (true);
		}
		
		public function enable (bool:Boolean):void
		{
			if (bool)
				this.stage.addEventListener (MouseEvent.CLICK, doTouch);
			else 
				this.stage.removeEventListener (MouseEvent.CLICK, doTouch);
		}
		
		protected function doTouch(e:MouseEvent):void 
		{
			lastTouch.x = stage.mouseX;
			lastTouch.y = stage.mouseY;
			onTouch.dispatch (new PointVX (lastTouch.x, lastTouch.y));
		}
		
		public function removedFromSystem(ash:Engine):void 
		{
			if (onTouch)
				onTouch.removeAll ();
			onTouch = null;
			lastTouch = null;
			stage = null;
		}
		
		public function kill():void
		{
			removeFromEngine ();
		}
	}

}