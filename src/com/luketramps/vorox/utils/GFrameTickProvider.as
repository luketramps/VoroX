package com.luketramps.vorox.utils 
{
	import air.update.descriptors.ConfigurationDescriptor;
	import ash.tick.ITickProvider;
	import com.genome2d.Genome2D;
	import com.luketramps.vorox.data.DictionaryPool;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Lukas Damian Opacki
	 */
	public class GFrameTickProvider implements ITickProvider 
	{
		private var genome:Genome2D;
		private var listeners:Dictionary = new Dictionary (true);;
		private var _playing:Boolean;
		
		[PostConstruct]
		public function postConstruct():void
		{
			genome = Genome2D.getInstance ();
		}
		
		public function get playing():Boolean 
		{
			return _playing;
		}
		
		public function add(listener:Function):void 
		{
			storeListener (listener);
			
			if (_playing) 
				activateListener (listener);
		}
		
		private function storeListener(listener:Function):void 
		{
			listeners[listener] = listener;
		}
		
		private function activateListener(listener:Function):void
		{
			genome.getContext ().onFrame.add (listener);
		}
		
		private function deactivateListener(listener:Function):void
		{
			genome.getContext ().onFrame.remove (listener);
		}
		
		public function remove(listener:Function):void 
		{
			deactivateListener (listener);
			delete listeners[listener];
		}
		
		public function start():void 
		{
			if (_playing == false)
			{
				for each (var listener:Function in listeners) 
				{
					activateListener (listener);
				}
				_playing = true;
			}
		}
		
		public function stop():void 
		{
			if (_playing == true)
			{
				for each (var listener:Function in listeners) 
				{
					deactivateListener (listener);
				}
				_playing = false;
			}
		}
		
	}

}