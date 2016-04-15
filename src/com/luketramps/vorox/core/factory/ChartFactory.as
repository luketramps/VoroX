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
	import ash.tools.ComponentPool;
	import com.luketramps.vorox.core.components.Grid;
	import com.luketramps.vorox.core.components.GridRenderResult;
	import com.luketramps.vorox.core.components.Chart;
	import com.luketramps.vorox.data.NamedItems;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.data.VectorPointVXPool;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * Internal factory.
	 * @author Lukas Damian Opacki
	 */
	public class ChartFactory 
	{
		[Inject] public var ash:Engine;
		
		[Inject (name = "charts")]	public var allCharts:NamedItems;
		
		// Create a chart component.
		public function createChart (name:String, sites:Vector.<PointVX>, bounds:Rectangle):Chart
		{
			var entity:Entity = new Entity (name);
			var chart:Chart = new Chart ();
			
			chart.name = name;
			chart.sites = sites;
			chart.numSites = sites.length;
			chart.bounds = bounds;
			
			chart.polygonCenters = new Vector.<PointVX> ();
			chart.myGrids = new Vector.<Grid> ();
			chart.renderResults = new Dictionary (true);
			chart.locked = false;
			
			for (var i:int = 0; i < chart.numSites; i++) 
			{
				addSiteTo (chart, sites[i]);
			}
			
			updateSiteIndicies (chart);
			
			allCharts.add (name, chart, true);
			entity.add (chart);
			ash.addEntity (entity);
			return chart;
		}
		
		// Add site to existing chart component.
		public function addSiteTo(chart:Chart, site:PointVX):void
		{
			var center:PointVX;
			center = new PointVX (0, 0, site.index);
			chart.polygonCenters.push (center);
			
			if (site.index >= chart.sites.length)
			{
				chart.sites.push (site);
				chart.numSites ++;
			}
		}
		
		// Remove specific site from sites.
		public function removeSiteFrom(chart:Chart, siteIndex:uint):void
		{
			chart.numSites --;
			
			// remove site
			chart.sites.splice (siteIndex, 1);
			chart.polygons.splice (siteIndex, 1);
			chart.polygonCenters.splice (siteIndex, 1);
			
			// remove verts and uvs
			for each (var renderResult:GridRenderResult in chart.renderResults)
			{
				renderResult.vertices.splice (siteIndex, 1);
				renderResult.uvcoords.splice (siteIndex, 1);
			}
			
			// keep site indexies
			updateSiteIndicies (chart);
		}
		
		public function updateSiteIndicies(chart:Chart):void
		{
			for (var i:int = 0; i < chart.numSites; i++) 
			{
				chart.sites[i].index = i;
			}
		}
		
		// Create a chart component with random site points.
		public function createRandomChart(name:String, numSites:uint, bounds:Rectangle):Chart
		{
			return createChart (name, getRandomPoints (numSites, bounds), bounds);
		}
		
		// Create some random points.
		private function getRandomPoints(numPoints:uint, bounds:Rectangle):Vector.<PointVX>
		{
			var randSites:Vector.<PointVX> = new Vector.<PointVX>();
			for (var i:int = 0; i < numPoints; i++) 
			{
				randSites.push ( new PointVX (Math.random() * bounds.width, Math.random() * bounds.height, i ) );
			}
			return randSites;
		}
		
	}

}