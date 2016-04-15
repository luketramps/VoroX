/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.control 
{
	import ash.core.Engine;
	import ash.core.Entity;
	import com.luketramps.vorox.core.systems.ChartRenderSys;
	import com.luketramps.vorox.skins.SkinComponent;
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.core.components.Grid;
	import com.luketramps.vorox.core.components.GridRenderResult;
	import com.luketramps.vorox.core.components.Chart;
	import com.luketramps.vorox.data.DictionaryPool;
	import com.luketramps.vorox.data.EdgePool;
	import com.luketramps.vorox.data.VectorBoolPool;
	import com.luketramps.vorox.data.VectorEdgePool;
	import com.luketramps.vorox.data.VectorLrPool;
	import com.luketramps.vorox.Vorox;
	import com.luketramps.vorox.data.NamedItems;
	import com.luketramps.vorox.data.PointVXPool;
	/**
	 * @author Lukas Damian Opacki
	 */
	public class Disposer 
	{
		[Inline]
		internal static function disposeObject (obj:Object):void
		{
			for (var key:String in obj)
				delete obj[key];
		}
		
		
		[Inject(name = "grids")]
		public var allGrids:NamedItems;
		
		[Inject(name = "charts")]
		public var allCharts:NamedItems;
		
		[Inject]
		public var vx:Vorox;
		
		[Inject]
		public var ash:Engine;
		
		public function Disposer() 
		{
		}
		
		private var chartRenderer:ChartRenderSys;
		
		[PostConstruct]
		public function init():void
		{
			chartRenderer = ChartRenderSys (ash.getSystem (ChartRenderSys));
		}
		
		/**
		 * Disposes a charts entity and all of its comonents, such as the Chart component and all the grids that are attached to this chart component, such as their cells.
		 * 
		 * @param	chart  The Chart entity that holds the comonents to be disposed.
		 *
		 */
		public function disposeChart(chartEntity:Entity):void
		{
			var chart:Chart = chartEntity.get (Chart);
			
			if (chart == null)
				throw new Error ("Entity does not represent a chart.");
			
			if (chart.polygons)
			{
				// Emtpy polygons.
				for (var i:int = 0; i < chart.numSites; i++) 
				{
					chart.polygons[i].length = null;
					chart.polygons[i] = null;
				}
				
				chart.polygons.length = 0;
				chart.polygons = null;
				
				chart.polygonCenters.length = 0;
				chart.polygonCenters = null;
				
				// Retruns chart objects to pools.
				if (!chart.poolsCleared)
				{
					chartRenderer.disposeReferencesOf (chart);
				}
				
			}
			
			for (var j:int = 0; j < chart.myGrids; j++) 
				disposeGrid (chart.myGrids[j]);
			
			for each(var renderData:GridRenderResult in chart.renderResults) 
				disposeRenderData (renderData);
			
			// Kill refs
			chart.myGrids.length = 0;
			chart.myGrids = null;
			
			chart.sites.length = 0;
			chart.sites = null;
			
			chart.renderResults = null;
			chart.myGrids = null;
			
			allCharts.remove (chart.name);
			
			// Kill entity
			chartEntity.remove (Chart);
			ash.removeEntity (chartEntity);
		}
		
		// Dispose a grid and its components.
		[Inline]
		final public function disposeGrid(gridEntity:Entity):void
		{
			var grid:Grid = gridEntity.get (Grid);
			
			if (chart == null)
				throw new Error ("Entity does not represent a grid.");
			
			var numCells:uint = grid.cells.length;
			
			grid.chart.myGrids.splice (grid.chart.myGrids.indexOf (gridEntity), 1);
			delete grid.chart.gridsByName [gridEntity.name];
			
			grid.gNode.dispose ();
			grid.chart = null;
			grid.gRoot = null;
			
			for (var i:int = 0; i < numCells; i++) 
			{
				disposeCell (grid.cells[i]);
				
				grid.cells[i] = null;
				grid.cellShapes[i] = null;
			}
			
			disposeRenderData (grid.renderData);
			
			allGrids.remove (grid.name);
			gridEntity.remove (Grid);
			ash.removeEntity (gridEntity);
		}
		
		// Dispose grid render data.
		[Inline]
		final public function disposeRenderData(renderResult:GridRenderResult):void 
		{
			if (renderResult.outlinedPolygons != null)
			{
				var numRegions:uint = renderResult.outlinedPolygons.length;
				for (var i:int = 0; i < numRegions; i++) 
				{
					renderResult.outlinedPolygons[i] = null;
					renderResult.vertices[i] = null;
					renderResult.uvcoords[i] = null;
				}
				renderResult.outlinedPolygons = null;
				renderResult.vertices = null;
				renderResult.uvcoords = null;
			}
		}
		
		// Dispose a cell and its components.
		[Inline]
		final public function disposeCell(cell:Cell):void
		{
			// Unskin cell.
			if (cell.entity.get (SkinComponent))
				vx.skinner.removeCurrentSkin (cell);
			
			// Dispose entity.
			cell.entity.remove (Cell);
			ash.removeEntity (cell.entity);
			
			// Dispose display.
			cell.gShape.dispose ();
			cell.gNode.dispose ();
			
			// Remove references.
			cell.entity = null;
			cell.gNode = null;
			cell.grid = null;
			cell.chart = null;
		}
		
	}

}