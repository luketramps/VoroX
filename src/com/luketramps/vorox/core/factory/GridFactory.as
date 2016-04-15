/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.factory 
{
	import ash.core.Engine;
	import ash.core.Entity;
	import com.genome2d.components.renderable.GShape;
	import com.genome2d.node.GNode;
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.core.components.Grid;
	import com.luketramps.vorox.core.components.GridRenderResult;
	import com.luketramps.vorox.core.components.Chart;
	import com.luketramps.vorox.components.Skin;
	import com.luketramps.vorox.core.control.Skinner;
	import com.luketramps.vorox.Vorox;
	import com.luketramps.vorox.data.NamedItems;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.core.renderable.GSpriteShape;
	/**
	 * Internal factory.
	 * @author Lukas Damian Opacki
	 */
	public class GridFactory 
	{
		static public var autoDisplayGrids:Boolean;
		
		[Inject] public var ash:Engine;
		[Inject] public var vx:Vorox;
		
		[Inject (name = "root")]
		public var rootNode:GNode;
		
		[Inject (name="grids")]
		public var allGrids:NamedItems;
		
		private var cellNameGenerator:CellEntityNameGenerator;
		
		[PostConstruct]
		public function init():void
		{
			cellNameGenerator = new CellEntityNameGenerator ();
		}
		
		// Creates a grid with cells.
		public function create(gridName:String, chart:Chart, outlineWidth:uint):Grid
		{
			var numCells:uint = chart.numSites;
			
			// Grid data component.
			var _grid:Grid = new Grid ();
			_grid.name = gridName;
			_grid.cellShapes = new Vector.<GShape> ();
			_grid.chart = chart;
			_grid.gNode = GNode.create ();
			_grid.cells = new Vector.<Cell> ();
			_grid.locked = false;
			_grid.outlinePixels = outlineWidth;
			_grid.gRoot = rootNode;
			
			// Render result.
			if (chart.renderResults[outlineWidth] == null)
			{
				var renderData:GridRenderResult = new GridRenderResult ();
				renderData.isValid = false;
				renderData.outlinePx = outlineWidth;
				renderData.vertices = new Vector.<Array>(numCells);
				renderData.uvcoords = new Vector.<Array>(numCells);
				renderData.outlinedPolygons = new Vector.<Vector.<PointVX>> ();
				for (var j:int = 0; j < numCells; j++) 
				{
					renderData.vertices[j] = [];
					renderData.uvcoords[j] = [];
					renderData.outlinedPolygons[i] = new Vector.<PointVX>();
				}
				chart.renderResults[outlineWidth] = renderData;
			}
			
			// Cells.
			for (var i:int = 0; i < numCells; i++) 
			{
				addCellTo (_grid, i);
			}
			
			// Grid entity.
			var entity:Entity =  (new Entity (gridName));
			entity.add (_grid);
			ash.addEntity (entity);
			
			// Store grid.
			chart.myGrids.push (_grid);
			allGrids.add (gridName, _grid, true);
			
			// Display grid.
			if (autoDisplayGrids)
				rootNode.addChild (_grid.gNode);
			
			return _grid;
		}
		
		public function addCellTo(grid:Grid, cellIndex:uint):Entity
		{
			// Cell data component.
			var cellEntityID:String = cellNameGenerator.getNameFor (grid); //core.name + "_" + String (cellIndex+1);
			var entity:Entity = new Entity (cellEntityID)
			var cell:Cell = new Cell ();
			cell.entity = entity;
			cell.chart = grid.chart;
			cell.gShape = GNode.createWithComponent (GSpriteShape) as GSpriteShape;
			cell.gNode = cell.gShape.node;
			cell.grid = grid;
			cell.site = grid.chart.sites[cellIndex];
			
			// Add entity.
			entity.add (cell);
			ash.addEntity (entity);
			
			// Store cell.
			grid.cells[cellIndex] = cell;
			grid.cellShapes[cellIndex] = cell.gShape;
			
			// Display cell.
			grid.gNode.addChild (cell.gNode);
		}
		
		public function removeCell(grid:Grid, siteIndex:uint):void 
		{
			var cell:Cell = grid.cells.splice (siteIndex, 1)[0];
			
			ash.removeEntity (cell.entity);
			
			vx.disposer.disposeCell (cell);
			
			grid.cellShapes.splice (siteIndex, 1);
		}
		
	}

}
import com.luketramps.vorox.core.components.Grid;
import flash.utils.Dictionary;

class CellEntityNameGenerator
{
	private var names:Dictionary;
	
	public function CellEntityNameGenerator()
	{
		this.names = new Dictionary (true);
	}
	
	public function getNameFor(grid:Grid)
	{
		if (names[grid] == null)
			names[grid] = 0;
		else
			names[grid] ++;
			
		return grid.name + "_" + String (names[grid]);
	}
}