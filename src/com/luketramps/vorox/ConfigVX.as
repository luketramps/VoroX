/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox 
{
	import _List.ListIterator;
	import ash.signals.Signal0;
	import ash.tick.FrameTickProvider;
	import ash.tick.ITickProvider;
	import com.genome2d.context.GContextConfig;
	import com.genome2d.context.stats.GStats;
	import com.luketramps.vorox.ApplicationVX;
	import com.luketramps.vorox.data.DictionaryPool;
	import com.luketramps.vorox.data.EdgePool;
	import com.luketramps.vorox.data.HalfEdgePool;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.data.PointVXPool;
	import com.luketramps.vorox.data.PoolsConfig;
	import com.luketramps.vorox.data.VectorBoolPool;
	import com.luketramps.vorox.data.VectorEdgePool;
	import com.luketramps.vorox.data.VectorHalfEdgePool;
	import com.luketramps.vorox.data.VectorLrPool;
	import com.luketramps.vorox.data.VectorPointVXPool;
	import com.luketramps.vorox.data.VectorVertexPool;
	import com.luketramps.vorox.utils.GFrameTickProvider;
	import flash.display.Stage;
	import org.swiftsuspenders.Injector;
	/**
	 * ConfigVX is used to gather data for vorox initialisation. 
	 * Changing values must occure before initialising vorox.
	 * @author Lukas Damian Opacki
	 */
	public class ConfigVX 
	{
		/**
		 * Display stats in the upper left corner. 
		 * Default is false.
		 */
		public var showStats:Boolean = false;
		
		/**
		 * If true, the build in algorythms for <code>AlignCenter, AlignStrech</code> and <code>AlignNone</code> are beeing skipped.
		 * Set this to true if you want to use your own texture mapping algorythms in the first place.
		 * Default is false.
		 */
		public var preferCostumSkinAlign:Boolean = false;
		
		/**
		 * If true, initialises the genome 2d framework before starting vorox.
		 * Default is true.
		 */
		public var autoInitGenome2D:Boolean = true;
		
		private var _genome2DConfig:GContextConfig;
		
	   /**
		* Voronoi rendering system priority for the ash framework.
		* Voronoi rendering creates the polygonal data.
		* Default is 1.
		*/
		public var renderSitesPriority:uint = 1;
		
		/**
		* Grid rendering system priority for the ash framework.
		* Grid rendering renders the view from the polygonal data.
		* Default is 2.
		*/
		public var renderGridsPriority:uint = 2;
		
		/**
		 * Masked content update system priority for the ash framework.
		 * Masked content updates occur only if a masked skin is beeing used.
		 * Default is 3.
		 */
		public var updateMasksPriority:uint = 3;
		
		/**
		 * If true, all non quadratic textures provided to skins, will be made quadratic by cropping it.
		 * Default is true.
		 */
		public var fixNonQuadraticTextures:Boolean = true;
		
		/**
		 * If true, the grids will recalculate their position in world space with each update.
		 * Default is true.
		 */
		public var autoUpdateWorldCoordinates:Boolean = true;
		
		/**
		 * If true, newly created grids will automaticly be added to the root node of Genome2D.
		 */
		public var autoDisplayGrids:Boolean = true;
		
		/**
		 * If true, sites and cells that are out of bounds will be automaticly removed. 
		 * If this is set to false, sites that are out of bounds will cause an "Site ouf of bounds" error.
		 */
		public var autoKillSitesOutOfBounds:Boolean = true;
		
		/**
		 * Pools start size configiguration.
		 */
		public var poolsConfig:Object;
		
		internal var initialised:Boolean = false;
		internal var injectionTargetsAfterInit:Array;
		
		private var _injector:Injector;
		private var _tickProvider:ITickProvider;
		private var _stage:Stage;
		private var _onInit:Signal0;
		
		/**
		 * Creates a new <code>ConfigVX</code> object.
		 * 
		 * @param stage: the native stage object.
		 */
		public function ConfigVX(stage:Stage) 
		{
			var vxRunning:Boolean = true;
			try {
				Vorox.getInstance ();
			}
			catch (err:*)
			{
				vxRunning = false;
			}
			
			if (vxRunning)
				throw new Error ("Vorox can not be initialised twice.");
			
			_stage = stage;
			
			_genome2DConfig = new GContextConfig (stage);
			
			if (showStats)
			{
				genome2DConfig.statsClass = GStats;
				GStats.visible = true;
			}
			
			_tickProvider = new GFrameTickProvider ();
			_injector = new Injector ();
			_onInit = new Signal0 ();
			
			poolsConfig = new PoolsConfig ();
			
			injectionTargetsAfterInit = [];
		}
		
		/**
		 * Can be used before (!) vorox initialiation, to setup the pools sizes to a former sessions amounts and to optionaly make theese maximum amounts of objects fixed. 
		 * This way vorox creates objects for its pools only once instead of creating additional objects on demand.
		 * @param	json  A JSON encoded string, generated with <code>getPoolsInitData</code>.
		 * @param	poolSizeMultiplier  Multiply the amounts of objects, defined by <code>json</code> param.
		 * @param	fixPools  If true, the pools will have fixed sizes and a need for more objects will throw an error.
		 */
		public function initPools(json:String, poolSizeMultiplier:Number = 1, fixPools:Boolean = false):void
		{
			if (initialised)
				throw new Error ("Vorox already running. Can't init pools.");
				
			var obj:Object = JSON.parse (json);
			
			for each (var poolSize:uint in obj)
				poolSize *= poolSizeMultiplier;
				
			if (fixPools)
				obj.fixed = true;
			
			poolsConfig = obj;
		}
		
		/**
		 * Returns a JSON encoded string that can be used to with <code>initPools()</code> function to precisley create the nessecary amount of objects before running vorox. 
		 * Also, this way its possible to create fixed pool sizes. 
		 * Can only be used after (!) Vorox initialisation.
		 * @return
		 */
		public function getPoolsInitData():String
		{
			var obj:PoolsConfig = new PoolsConfig ();
			obj.dictPoolSize = DictionaryPool.max;
			obj.edgePoolSize = EdgePool.max;
			obj.halfeedgePoolSize = HalfEdgePool.max;
			obj.pointPoolSize = PointVXPool.max;
			obj.vecHalfedgePoolSize = VectorHalfEdgePool.max;
			obj.vecLrPoolSize = VectorLrPool.max;
			obj.vecBoolPoolSize = VectorBoolPool.max;
			obj.vecEdgePoolSize = VectorEdgePool.max;
			obj.vecPointPoolSize = VectorPointVXPool.max;
			obj.vecVertexPoolSize = VectorVertexPool.max;
			return JSON.stringify (obj);;
		}
		
		// Depraced
		/**
		 * Initialises all pools by the assumed max amount of cooexisting cells in the application. 
		 * Because pools can grow dynamicly, calling <code>initPools</code> is optional.
		 * However, if you know the maximum ammount of cells that will coexist (disposed cells/grids do not count) in your application, than you might improve performance with this function.
		 * Must be called before initialising vorox.
		 * @param	maxCells Highest possible amount of cells that your application contains at any point of time.
		 */
		 /*
		public function initPools(maxCells:uint):void
		{
			poolsConfig.pointPoolSize = 20 * maxCells;
			poolsConfig.vecEdgePoolSize = 5 * maxCells;
			poolsConfig.vecPointPoolSize = 1.3 * maxCells;
			poolsConfig.vecBoolPoolSize = 1.3 * maxCells;
			poolsConfig.edgePoolSize = 4 * maxCells;
			poolsConfig.dictPoolSize = 6.5 * maxCells;
			poolsConfig.vecLrPoolSize = 1.3 * maxCells;
			poolsConfig.halfeedgePoolSize = 10 * maxCells;
			poolsConfig.vecHalfedgePoolSize = 1.3 * maxCells;
			poolsConfig.vecVertexPoolSize = 1.3 * maxCells;
		}
		*/
		
		/**
		 * The native stage object.
		 */
		public function get stage():Stage
		{
			return _stage;
		}
		
		/**
		 * Genome2D configuration.
		 */
		public function get genome2DConfig():GContextConfig 
		{
			return _genome2DConfig;
		}
		
		/**
		 * A ticker used by ash to perform it's update loop.
		 * It can be replaced before initialising vorox.
		 */
		public function get tickProvider():ITickProvider 
		{
			return _tickProvider;
		}
		public function set tickProvider(value:ITickProvider):void 
		{
			if (initialised)
				throw new Error ("Can not change tick provider via ConfigVX after initialising vorox.");
			if (_tickProvider.playing)
				_tickProvider.stop ();
			_tickProvider = value;
		}
		
		/**
		 * The injector (from the swiftsuspenders framwork) that is beeing used for direct injection inside vorox.
		 */
		public function get injector():Injector 
		{
			return _injector;
		}
		
		/**
		 * The signal that gets fired once vorox was initialised with this config.
		 */
		public function get onInititialised():Signal0 
		{
			return _onInit;
		}
		
		/**
		 * Add a target for an injection after vorox was initialised.
		 * @param	target
		 */
		public function injectIntoAfterInit(target:*):void
		{
			injectionTargetsAfterInit.push (target);
		}
		
		internal function onVoroxRunning():void
		{
			for (var i:int = 0; i < injectionTargetsAfterInit.length; i++) 
			{
				injector.injectInto (injectionTargetsAfterInit[i]);
			}
			
			initialised = true;
			
			if (_tickProvider as GFrameTickProvider != null)
				_injector.injectInto (_tickProvider);
			
			_tickProvider.start ();
			_onInit.dispatch ();
		}
	}

}