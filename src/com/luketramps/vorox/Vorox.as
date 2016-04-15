/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox 
{
	import ash.core.Engine;
	import ash.core.Entity;
	import ash.signals.Signal0;
	import com.genome2d.Genome2D;
	import com.luketramps.vorox.ConfigVX;
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.core.components.Grid;
	import com.luketramps.vorox.core.components.Chart;
	import com.luketramps.vorox.core.control.Disposer;
	import com.luketramps.vorox.core.control.HitTester;
	import com.luketramps.vorox.core.control.Inserter;
	import com.luketramps.vorox.core.control.Skinner;
	import com.luketramps.vorox.core.factory.GridFactory;
	import com.luketramps.vorox.core.factory.ChartFactory;
	import com.luketramps.vorox.core.systems.GridRenderSys;
	import com.luketramps.vorox.data.NamedItems;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.skins.align.AlignCenter;
	import com.luketramps.vorox.skins.align.TextureMapping;
	import com.luketramps.vorox.skins.SkinConfig;
	import com.luketramps.vorox.skins.SkinManager;
	import com.luketramps.vorox.StartupVX;
	import com.luketramps.vorox.utils.ZoomOutOfGridBorders;
	import com.luketramps.vorox.utils.ZoomOverGridBorders;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import org.swiftsuspenders.Injector;
	/**
	 * VoroX API.
	 * @author Lukas Damian Opacki
	 */
	public class Vorox 
	{
		// Singleton
		private static var _instance:Vorox;
		
		/**
		 * Returns vorox singleton.
		 * Vorox must be initialised.
		 * @return the singleton vorox instance.
		 */
		public static function getInstance():Vorox
		{
			if (!_instance) throw new Error ("Vorox was not initialised. Call 'VoroX.init()' first.");
			return _instance;
		}
		
		/**
		 * Initialise vorox. 
		 * Initialisation is asynchronous. 
		 * After initialisiation the provided instance of <code>ConfigVX</code> dispatches it's <code>config.onInitialised</code> signal.
		 */
		public static function init(config:ConfigVX):Vorox
		{
			if (_instance) throw new Error ("VoroX is running. Can not init twice.");
			
			_config = config;
			_instance = new Vorox (new SingletonEnforcer ());
			
			new StartupVX (config, _instance);
			
			return _instance;
		}
		
		/**
		 * The native stage object.
		 */
		[Inject] public var stage:Stage;
		
		/**
		 * The facade to the core of Genome2D.
		 */
		[Inject] public var genome:Genome2D;
		
		/**
		 * Ash entity component framework engine.
		 */
		[Inject] public var ash:Engine;
		
		/**
		 * Internal model.
		 */
		[Inject(name = "charts")]	public var allCharts:NamedItems;
		
		/**
		 * Internal model.
		 */
		[Inject(name = "grids")]	public var allGrids:NamedItems;
		
		// Injector.
		public var injector:Injector;
		
		/**
		 * Internal factory.
		 */
		[Inject] public var gridFactory:GridFactory;
		/**
		 * Internal factory.
		 */
		[Inject] public var chartFactory:ChartFactory;
		
		/**
		 * Internal controler.
		 */
		[Inject] public var skinner:Skinner;
		/**
		 * Internal controler.
		 */
		[Inject] public var disposer:Disposer;
		/**
		 * Internal controler.
		 */
		[Inject] public var hitTester:HitTester;
		/**
		 * Internal controler.
		 */
		[Inject] public var inserter:Inserter;
		
		/**
		 * Dispatched when ChartRenderSys is about to update charts.
		 */
		public var onChartUpdate:Signal0;
		
		/**
		 * Dispatched when ChartRenderSys has updated charts.
		 */
		public var onChartUpdateComplete:Signal0;
		
		/**
		 * Dispatched when GridRenderSystem is about to update grids and cells.
		 */
		public var onGridsUpdate:Signal0;
		
		/**
		 * Dispatched when GridRenderSystem has updated grids and cells.
		 */
		public var onGridsUpdateComplete:Signal0;
		
		/**
		 * Private constructor.
		 * @param	singleton
		 */
		public function Vorox(singleton:SingletonEnforcer) 
		{
			onChartUpdate = new Signal0 ();
			onChartUpdateComplete = new Signal0 ();
			onGridsUpdate = new Signal0 ();
			onGridsUpdateComplete = new Signal0 ();
		}
		
		/**
		 * Create a chart with random sites.
		 * @param	chartName 	A name for the chart.
		 * @param	numSites 	Initial amount of cells / sites.
		 * @param	width		Space for sites on x achsis.
		 * @param	height		Space for sites on y achsis.
		 * @return  The new Chart instance.
		 */
		public function createRandomChart(chartName:String, numSites:uint, width:uint, height:uint):Chart // Chart.createRandom ()
		{
			return chartFactory.createRandomChart (chartName, numSites, new Rectangle (0, 0, width, height));
		}
		
		/**
		 * Create a chart from a set of sites (points).
		 * @param	chartName 	A name for the chart.
		 * @param	sites 		A vector filled with PointVX instances.
		 * @param	width		Space for sites on x achsis.
		 * @param	height		Space for sites on y achsis.
		 * @return  			The new Chart instance.
		 */
		public function createChart (chartName:String, sites:Vector.<PointVX>, width:uint, height:uint):Chart // Chart.create()
		{
			return chartFactory.createChart (chartName, sites, width, height);
		}
		
		/**
		 * Create a grid and attach it to an existing chart. 
		 * @param	gridName 	   Name of the grid.
		 * @param	chartName	   Name of the chart.
		 * @param	outlinePixels  Space inbetween cells.
		 * @return 
		 */
		public function createGrid(gridName:String, chartName:String, outlinePixels:uint = 0):Grid // chartObj.createGrid ();
		{
			return gridFactory.create (gridName, allCharts.getItemByName (chartName, true), outlinePixels);
		}
		
		/**
		 * Resets a grids scale to 1. 
		 * See <code>showGridBorders()</code> for more info.
		 * @param	gridName The name of the grid.
		 */
		public function hideGridBorders(gridName:String):void  // gridObj.hideBorder ();
		{
			var grid:Grid = getGrid (gridName);
			new ZoomOverGridBorders (grid.gNode, grid.outlinePixels, grid.chart.bounds);
		}
		
		/**
		 * This is a dirty solution for removing grid borders on grids with outlines greater than 0. This solution works only on stationary fullscreen grids.
		 * Currently there is no other possibility to remove the thin border from outlined grids.
		 * @param	gridName The name of the grid.
		 */
		public function showGridBorders(gridName:String):void  // gridObj.showBorder ();
		{
			var grid:Grid = getGrid (gridName);
			new ZoomOutOfGridBorders (grid.gNode);
		}
		
		/**
		 * Add a new skin type. 
		 * To create a costum skin type, extend SkinManager, SkinConfig and SkinComponent and pass your skin manager here.
		 * @param	manager An instance of a costum skin manager.
		 */
		public function addSkinType(manager:SkinManager):void // SkinManager.newSkinType ();
		{
			skinner.setupSkinType (manager);
		}
		
		/**
		 * Add a new skin.
		 * Use <code>SimpleSkin, MaskSkin</code> or <code>SpriteSkin</code>. Or create your own type of skin.
		 * @param	skin  The skin configuration that describes the skin.
		 */
		public function addSkin(skin:SkinConfig):void  // SkinManager.createSkin ();
		{
			skinner.createSkin (skin);
		}
		
		/**
		 * Remove a skin and optionaly remove its texture from gpu memory.
		 * @param	skinName  		 Name of the skin.
		 * @param	disposeGTexture  If true, the related gpu textures will be disposed.
		 */
		public function disposeSkin(skinName:String, disposeGTexture:Boolean = false):void  // SkinManager.disposeSkin ();
		{
			skinner.disposeSkin (skinName, disposeGTexture);
		}
		
		/**
		 * Apply a Skin to a cell.
		 * Skins must be created first with <code>addSkin()</code> before they can be applied to cells.
		 * @param	skinName  Name of the skin.
		 * @param	cell	  Instance of Cell that the skin will be applied to.
		 * @param	Align	  Skin alignment. If <code>null</code> then <code>AlignCenter</code> will be used.
		 */
		public function applySkin(skinName:String, cell:Cell, Align:Class = null):void  // cellObj.applySkin ();
		{
			skinner.applySkin (skinName, cell, (!Align) ? AlignCenter : Align);
		}
		
		/**
		 * Applies a skin at all cells of a grid.
		 * @param	skinName  Name of the skin.
		 * @param	gridName  Name of the grid.
		 * @param	Align	  Skin alignment. If <code>null</code> then <code>AlignCenter</code> will be used.
		 */
		public function applySkinOnGrid(skinName:String, gridName:String, Align:Class = null):void // gridObj.applySkin ();
		{
			skinner.applySkinToGrid (skinName, gridName, (!Align) ? AlignCenter : Align);
		}
		
		/**
		 * Check if a skin exists.
		 * @param	skinName  Name of the skin.
		 * @return 	True, if the skin exists.
		 */
		public function hasSkin(skinName:String):Boolean   // SkinManager.hasSkin ();
		{
			return skinner.hasSkin (skinName);
		}
		
		/**
		 * Check if a skin exists.
		 * @param	gridName  Name of the Grid.
		 * @return 	True, if the grid exists.
		 */
		public function hasGrid(gridName:String):Boolean // Grid.lookup ();
		{
			return allGrids.containsName (gridName);
		}
		
		/**
		 * Check if a skin exists.
		 * @param	chartName  Name of the Chart.
		 * @return 	True, if the chart exists.
		 */
		public function hasChart(chartName:String):Boolean // Grid.lookup ();
		{
			return allCharts.containsName (chartName);
		}
		
		/**
		 * Call a function with each cell in a grid as parameter. 
		 * @param	gridName  Name of the grid.
		 * @param	func	  Function object must take an parameter of the type 'Cell'
		 */
		public function forEachCellOf(gridName:String, func:Function):void  // gridObj.forEachCell
		{
			var grid:Grid = getGrid (gridName);
			var cells:Vector.<Cell> = grid.cells;
			var numCells:uint = grid.chart.numSites;
			
			for (var i:int = 0; i < numCells; i++) 
				func (cells[i]);
		}
		
		/**
		 * Look up a instance of <code>Grid</code> by its name property.
		 * @param	gridName   Name of the grid.
		 * @param	mustExist  If true, throws an error when grid is non existant.
		 * @return  The grids core.
		 */
		public function getGrid(gridName:String, mustExist:Boolean = true):Grid  // Grid.getGrid ();
		{
			return allGrids.getItemByName (gridName, mustExist);
		}
		
		/**
		 * Look up a instance of <code>Chart</code> by its name property.
		 * @param	chartName   Name of the chart.
		 * @param	mustExist  If true, throws an error when grid is non existant.
		 * @return  The grids core.
		 */
		public function getChart(chartName:String, mustExist:Boolean = true):Chart  // Chart.getChart ();
		{
			return allCharts.getItemByName (chartName, mustExist);
		}
		
		/**
		 * Test if a point is in an cells polygonal area. 
		 * Works also when the grid is scaled or moved.
		 * @param	cell  Core of the cell that will be hit-tested.
		 * @param	hitPoint  A point in global coordinate space.
		 * @return  True, if the point is inside the cells polygon (as it apears on screen).
		 */
		public function hitTest(cell:Cell, hitPoint:PointVX):Boolean   // ???
		{
			return hitTester.hitTest (cell, hitPoint);
		}
		
		/**
		 * Dispose Chart entity and its components, such as attached grids and cells. 
		 * Skins are not affected.
		 * @param	chartName  Name of the chart.
		 */
		public function disposeChart(chartName:String):void  // chartObj.dispose ();
		{
			disposer.disposeChart (ash.getEntityByName (chartName));
		}
		
		/**
		 * Dispose grid entity and grid components and cells.
		 * @param	gridName  Name of the grid.
		 */
		public function disposeGrid(gridName:String):void   // gridObj.dispose ();
		{
			disposer.disposeGrid (ash.getEntityByName (gridName));
		}
		
		/**
		 * Add a skin alignment type.
		 * To create a costum skin alinment, create a subclass of <code>TextureMapping</code>.
		 * @param	AlignType   Mapping class of the costum SkinAlign type.
		 * @param	alignObj	Instance of the costum SkinAlign type. If <code>null</code> a new instance is created.
		 */
		public function addSkinAlignType(AlignType:Class, alignObj:TextureMapping = null):void   // SkinManager.newAlignType ();
		{
			GridRenderSys.alignments[AlignType] = (alignObj) ? alignObj : new AlignType ();
		}
		
		/**
		 * Insert a new site into an existing chart at the given location (in local grid space).
		 * Appends a site to the end of the <code>sites</code> property of an instance of <code>Chart</code>.
		 * @param	chartName  Name of the chart.
		 * @param	x		   X of the new site in grids local coordinates.
		 * @param	y		   Y of the new site in grids local coordinates.
		 * @return  The new site point.
		 */
		public function insertSiteAt(chartName:String, x:Number, y:Number):PointVX  // chartObj.insertSite (pointVX); chartObj.insertSiteAt (x,y);
		{
			return inserter.insertSite (chartName, x, y);
		}
		
		/**
		 * Remove a site from a chart. 
		 * Site indicies may change.
		 * All cells that represent the site within related grids get disposed as well.
		 * @param	chartName  Name of the chart.
		 * @param	siteIndex  Index of site to delete.
		 */
		public function removeSite (chartName:String, siteIndex:uint):void  // chartObj.removeSite (pointVX);
		{
			inserter.removeSiteNo (chartName, siteIndex);
		}
		
		/**
		 * Removes a the site, next to the given location (in local grid space).
		 * @param	chartName   Name of the chart.
		 * @param	x			X coordinate.
		 * @param	y			Y coordinate.
		 */
		public function removeSiteAt (chartName:String, x:Number, y:Number):void  // chartObj.removeSiteAt
		{
			inserter.removeSiteAt (chartName, x, y);
		}
		
	}

}
class SingletonEnforcer
{
}