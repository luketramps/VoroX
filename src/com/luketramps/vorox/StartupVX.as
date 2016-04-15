/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox 
{
	import ash.core.Engine;
	import ash.integration.swiftsuspenders.SwiftSuspendersEngine;
	import ash.tick.ITickProvider;
	import com.genome2d.Genome2D;
	import com.genome2d.node.GNode;
	import com.luketramps.vorox.ConfigVX;
	import com.luketramps.vorox.core.control.Disposer;
	import com.luketramps.vorox.core.control.HitTester;
	import com.luketramps.vorox.core.control.Inserter;
	import com.luketramps.vorox.core.control.Skinner;
	import com.luketramps.vorox.core.factory.GridFactory;
	import com.luketramps.vorox.core.factory.ChartFactory;
	import com.luketramps.vorox.core.systems.CellMaskingSys;
	import com.luketramps.vorox.core.systems.GridRenderSys;
	import com.luketramps.vorox.core.systems.ChartRenderSys;
	import com.luketramps.vorox.data.DictionaryPool;
	import com.luketramps.vorox.data.EdgePool;
	import com.luketramps.vorox.data.HalfEdgePool;
	import com.luketramps.vorox.data.NamedItems;
	import com.luketramps.vorox.data.PointVXPool;
	import com.luketramps.vorox.data.PoolsConfig;
	import com.luketramps.vorox.data.VectorBoolPool;
	import com.luketramps.vorox.data.VectorEdgePool;
	import com.luketramps.vorox.data.VectorHalfEdgePool;
	import com.luketramps.vorox.data.VectorLrPool;
	import com.luketramps.vorox.data.VectorPointVXPool;
	import com.luketramps.vorox.data.VectorVertexPool;
	import com.luketramps.vorox.skins.align.AlignCenter;
	import com.luketramps.vorox.skins.align.AlignNone;
	import com.luketramps.vorox.skins.align.AlignStrech;
	import com.luketramps.vorox.skins.masked.MaskedSkinManager;
	import com.luketramps.vorox.skins.simple.SimpleSkinManager;
	import com.luketramps.vorox.skins.SkinConfig;
	import com.luketramps.vorox.skins.sprite.SpriteSkinManager;
	import com.nodename.Delaunay.Edge;
	import com.nodename.Delaunay.Vertex;
	import flash.display.Stage;
	import org.swiftsuspenders.Injector;
	/**
	 * @author Lukas Damian Opacki
	 */
	internal class StartupVX 
	{
		private var vx:Vorox;
		private var config:ConfigVX;
		private var injector:Injector;
		private var stage:Stage;
		
		// Constructor 
		public function StartupVX(config:ConfigVX, vx:Vorox) 
		{
			this.vx = vx;
			this.config = config;
			this.stage = config.stage;
			this.injector = config.injector;
			
			initVX ();
		}
		
		private function initVX():void 
		{
			// Start Genome2D.
			if (config.autoInitGenome2D)				new GStarter (config.genome2DConfig, onGenome2dReady);
			else if (Genome2D.g2d_instance == null)		throw new Error ("Genome2D must be initialised.");
			else										onGenome2dReady ();
			
			// Proceed when genome is ready.
			function onGenome2dReady():void
			{
				setFlags ();
				fillPools ();
				setupInjector ();
				setupVoroX ();
				addTick ();
				cleanUp ();
			}
		}
		
		// Set config flags.
		private function setFlags():void 
		{
			SkinConfig.fixRatioEnabled = config.fixNonQuadraticTextures;
			GridFactory.autoDisplayGrids = config.autoDisplayGrids;
			GridRenderSys.updateWorldCoordinates = config.autoUpdateWorldCoordinates;
			GridRenderSys.useBuiltInAlignment = !config.preferCostumSkinAlign;
			GridRenderSys.systemPriority = config.renderGridsPriority;
			CellMaskingSys.systemPriority = config.updateMasksPriority;
			ChartRenderSys.systemPriority = config.renderSitesPriority;
			ChartRenderSys.autoKillCells = config.autoKillSitesOutOfBounds;
		}
		
		// Fill up object pools.
		private function fillPools():void 
		{
			var poolsConfig:Object = config.poolsConfig;
			
			PointVXPool.init (poolsConfig.pointPoolSize, (!poolsConfig.fixed) ? poolsConfig.pointPoolSize/5 : 0);
			VectorEdgePool.init (poolsConfig.vecEdgePoolSize, (!poolsConfig.fixed) ? poolsConfig.vecEdgePoolSize/5 : 0);
			VectorBoolPool.init (poolsConfig.vecBoolPoolSize, (!poolsConfig.fixed) ? poolsConfig.vecBoolPoolSize/5 : 0);
			VectorPointVXPool.init (poolsConfig.vecPointPoolSize, (!poolsConfig.fixed) ? poolsConfig.vecPointPoolSize/5 : 0);
			DictionaryPool.init (poolsConfig.dictPoolSize, (!poolsConfig.fixed) ? poolsConfig.dictPoolSize/5 : 0);
			EdgePool.init (poolsConfig.edgePoolSize, (!poolsConfig.fixed) ? poolsConfig.edgePoolSize/5 : 0);
			VectorLrPool.init (poolsConfig.vecLrPoolSize, (!poolsConfig.fixed) ? poolsConfig.vecLrPoolSize / 5 : 0);
			HalfEdgePool.init (poolsConfig.halfeedgePoolSize, (!poolsConfig.fixed) ? poolsConfig.halfeedgePoolSize / 5 : 0);
			VectorHalfEdgePool.init (poolsConfig.vecHalfedgePoolSize, (!poolsConfig.fixed) ? poolsConfig.vecHalfedgePoolSize / 5 : 0);
			VectorVertexPool.init (poolsConfig.vecVertexPoolSize, (!poolsConfig.fixed) ? poolsConfig.vecVertexPoolSize / 5 : 0);
			
			// Hotfix: static member needs obj from subpool.
			Edge.createFirstEdge ();
			//Vertex.createFirstVertex ();
		}
		
		// Map injectees.
		private function setupInjector():void 
		{
			var factory:StartupFactory = new StartupFactory ();
			injector.map (Engine).toValue (new SwiftSuspendersEngine (injector));
			injector.map (Genome2D).toValue (Genome2D.getInstance ());
			injector.map (GNode, "root").toValue (Genome2D.getInstance ().root);
			injector.map (Stage).toValue (stage);
			injector.map (Vorox).toValue (vx);
			injector.map (NamedItems, "skinConfigs").toValue (factory.createAllSkinsCollection ());
			injector.map (NamedItems, "charts").toValue (factory.createAllSitesCollection ());
			injector.map (NamedItems, "grids").toValue (factory.createAllGridsCollection ());
			injector.map (Skinner).toValue (injector.getOrCreateNewInstance (Skinner));
			injector.map (Disposer).toValue (injector.getOrCreateNewInstance (Disposer));
			injector.map (HitTester).toValue (injector.getOrCreateNewInstance (HitTester));
			injector.map (Inserter).toValue (injector.getOrCreateNewInstance (Inserter));
			injector.map (GridFactory).toValue (injector.getOrCreateNewInstance (GridFactory));
			injector.map (ChartFactory).toValue (injector.getOrCreateNewInstance (ChartFactory));
		}
		
		// Wire up vorox engine.
		private function setupVoroX():void 
		{
			injector.injectInto (vx);
			vx.injector = injector;
			
			// Add vorox Skin types.
			vx.addSkinType (new SimpleSkinManager ());
			vx.addSkinType (new SpriteSkinManager ());
			vx.addSkinType (new MaskedSkinManager ());
			
			// Add vorox Skin alingments.
			vx.addSkinAlignType (AlignCenter);
			vx.addSkinAlignType (AlignStrech);
			vx.addSkinAlignType (AlignNone);
			
			// Add vorox systems.
			var ash:Engine = injector.getInstance (Engine);
			ash.addSystem (new ChartRenderSys (), ChartRenderSys.systemPriority);
			ash.addSystem (new GridRenderSys (), GridRenderSys.systemPriority);
		}
		
		// Start update loop.
		private function addTick():void 
		{
			if (config.tickProvider)
			{
				var ash:Engine = injector.getInstance (Engine);
				var tick:ITickProvider = config.tickProvider;
				tick.add (ash.update);
				//tick.start ();
			}
		}
		
		// End startup.
		private function cleanUp():void 
		{
			config.onVoroxRunning ();
			
			vx = null;
			injector = null;
			stage = null;
			config = null;
		}
	}

}
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.luketramps.vorox.data.NamedItems;
import flash.display.MovieClip;
class GStarter
{
	public function GStarter(config:GContextConfig, onComplete:Function):void
	{
		haxe.initSwc (new MovieClip ());
		Genome2D.getInstance ().onInitialized.addOnce (onComplete);
		Genome2D.getInstance ().init (config);
	}
}
class StartupFactory
{
	// Prepare Grid collection.
	public function createAllGridsCollection():NamedItems 
	{
		var allGrids:NamedItems = new NamedItems ();
		allGrids.returnNullErrorMethod = function (name:String):void
		{
			throw new Error ("A instance of Grid named '" + name + "' does not exist.");
		};
		allGrids.overrideExistingItemErrorMethod = function (name:String):void
		{
			throw new Error ("A instance of Grid named '" + name + "does already exist. Choose a different name or dispose the existing instance of Sites first.");
		}
		return allGrids;
	}
	
	// Prepares SkinConfig collection.
	public function createAllSkinsCollection():NamedItems 
	{
		var allSkins:NamedItems = new NamedItems ();
		allSkins.returnNullErrorMethod = function (name:String):void
		{
			throw new Error ("A skin named '" + name + "' does not exist.")
		};
		allSkins.overrideExistingItemErrorMethod = function (name:String):void
		{
			throw new Error ("A skin named '" + name + "does already exist. Choose a different name or dispose the existing skin first.");
		}
		return allSkins;
	}
	
	// Prepare Sites collection.
	public function createAllSitesCollection():NamedItems 
	{
		var allSites:NamedItems = new NamedItems ();
		allSites.returnNullErrorMethod = function (name:String):void
		{
			throw new Error ("A instance of Sites named '" + name + "' does not exist.");
		};
		allSites.overrideExistingItemErrorMethod = function (name:String):void
		{
			throw new Error ("A isntance of Sites named '" + name + "' does already exist. Choose a different name or dispose the existing instance of Sites first.");
		};
		return allSites;
	}
}

