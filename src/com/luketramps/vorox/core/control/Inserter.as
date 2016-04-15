/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.control 
{
	import ash.core.Entity;
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.core.components.Grid;
	import com.luketramps.vorox.core.components.GridRenderResult;
	import com.luketramps.vorox.core.components.Chart;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.data.PointVXPool;
	import com.luketramps.vorox.Vorox;
	/**
	 * Internal controls.
	 * @author Lukas Damian Opacki
	 */
	public class Inserter 
	{
		[Inject] public var vx:Vorox;
		
		[PostConstruct]
		public function onInjected() 
		{
		}
		
		// Remove site from chart and dispose all related grid cells.
		public function removeSiteNo (chartName:String, siteIndex:uint):void
		{
			var chart:Chart = vx.getChart(chartName);
			var outlines:Vector.<uint> = new Vector.<uint> ();
			
			// Remove site from chart.
			vx.chartFactory.removeSiteFrom (chart, siteIndex);
			
			// Remove cells from grids.
			var grid:Grid;
			for (var i:int = 0; i < chart.myGrids.length; i++) 
			{
				grid = chart.myGrids[i];
				
				// Remove the related cell.
				vx.gridFactory.removeCell (grid, siteIndex);
			}
		}
		
		// Insert new cell into existing grid.
		public function insertSite(chartName:String, x:Number, y:Number):PointVX
		{
			var chart:Chart = vx.getChart(chartName);
			var siteIndex:uint = chart.numSites;
			var outlines:Vector.<uint> = new Vector.<uint> ();
			var site:PointVX = new PointVX (x, y, siteIndex);
			
			if (x > chart.bounds.width || x < chart.bounds.x || y > chart.bounds.height || y < chart.bounds.y)
				throw new Error ("Site coordinates must be within chart bounds.");
			
			// Add a site.
			var cell:Entity = vx.chartFactory.addSiteTo (chart, site);
			
			// Add cell to all grids.
			var grid:Grid;
			for (var i:int = 0; i < chart.myGrids.length; i++) 
			{
				grid = chart.myGrids[i];
				
				// Add a new cell at the end of grids collections.
				vx.gridFactory.addCellTo (grid, siteIndex);
				
				// Store outlines to lookup renderdata.
				if (outlines.indexOf (grid.outlinePixels) == -1)
					outlines.push (grid.outlinePixels);
			}
			
			// Update amount of render result collections.
			for (var j:int = 0; j < outlines.length; j++) 
			{
				renderData = chart.renderResults[outlines[j]];
				renderData.vertices.push ([]);
				renderData.uvcoords.push ([]);
			}
			
			return site;
		}
		
		// Remove a cell from a grid and dispose it.
		public function removeSiteAt (chartName:String, x:Number, y:Number):void
		{
			var site:PointVX = vx.getChart (chartName).getSiteAt (x, y);
			removeSiteNo (chartName, site.index);
		}
		
	}

}