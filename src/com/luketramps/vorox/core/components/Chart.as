/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.components 
{
	import ash.core.Entity;
	import com.luketramps.vorox.data.PointVX;
	import com.nodename.Delaunay.Voronoi;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * An instance of Chart is the representation of a voronoi charts data.
	 * Warning: Some values should not be changed here.
	 * @author Lukas Damian Opacki
	 */
	public class Chart 
	{
		/**
		 * Name of the chart.
		 */
		public var name:String;
		
		/**
		 * Actual sites (points that define the voronoi chart).
		 * Changing x/y properties can be used to animate the voronoi grid.
		 */
		public var sites:Vector.<PointVX>; // Fix: rename 2 sites!
		
		/**
		 * Current amount of sites. Do not change.
		 */
		public var numSites:uint;
		
		/**
		 * Grids that belont to this chart.
		 */
		public var myGrids:Vector.<Grid>;
		
		/**
		 * The actual voronoi diagram, rendered by as3delauney.
		 * WARNING. Pooled objects, disposed at the beginning of each render loop.
		 */
		public var voronoi:Voronoi;
		
		/**
		 * Polygonal regions of the voronoi diagram.
		 * WARNING. Pooled objects, disposed at the beginning of each render loop.
		 */
		public var polygons:Vector.<Vector.<PointVX>>;
		
		/**
		 * Centers of the voronoi region polygons - not 100% accurate.
		 * X/Y coordinates are intended for read only.
		 */
		public var polygonCenters:Vector.<PointVX>;
		
		/**
		 * Bounds and therefore, the global coordinate system of the voronoi diagramm (grid space).
		 */
		public var bounds:Rectangle;
		
		/**
		 * If true, updates of the voronoi object and grids, that depend on this chart is suspended (render lock).
		 */
		public var locked:Boolean;
		
		/**
		 * Stores triangulated vertices and uv coordinates of related grids.
		 * This data is beeing used to render cells.
		 */
		public var renderResults:Dictionary;
		
		/**
		 * Internal.
		 */
		public var pointPoolID:uint;
		/**
		 * Internal.
		 */
		public var edgePoolID:uint;
		/**
		 * Internal.
		 */
		public var dictPoolID:uint;
		/**
		 * Internal.
		 */
		public var vecEdgePoolID:uint;
		/**
		 * Internal.
		 */
		public var vecPvxPoolID:uint;
		/**
		 * Internal.
		 */
		public var vecLrPoolID:uint;
		/**
		 * Internal.
		 */
		public var vecBoolPoolID:uint;
		/**
		 * Internal.
		 */
		public var halfEdgePoolID:uint;
		/**
		 * Internal.
		 */
		public var poolsCleared:Boolean;
		/**
		 * Internal.
		 */
		public var vecHalfedgePoolID:uint;
		/**
		 * Internal.
		 */
		public var vecVertexPoolID:uint;
		
		
		/**
		 * Return the site with the given index.
		 * @param	siteIndex Index of the site.
		 * @return  The site with the given index.
		 */
		public function getSite(siteIndex:uint):PointVX
		{
			return sites[siteIndex];
		}
		
		/**
		 * Find the nearest site to a location in local grid space.
		 * @param x  X coordinate of the location.
		 * @param y  Y coordinate of the location.
		 * @return  The site next the the given location.
		 */
		[Inline]
		final public function getSiteAt(x:Number, y:Number):PointVX
		{
			var location:PointVX = new PointVX ();
			var numPoints:uint = sites.length;
			var distance:Number = 1000000;
			var nextDistance:Number = 0;
			var index:int = -1;
			
			for (var i:int = 0; i < numPoints; i++) 
			{
				location.x = x;
				location.y = y;
				nextDistance = PointVX.distance (location, sites[i]);
				if (distance > nextDistance) {
					distance = nextDistance;
					index = i;
				}
			}
			
			return sites[index];
		}
		
		public function get lastSite():PointVX
		{
			return sites[numSites - 1];
		}
		
		/**
		 * Get the (cell-) polygon, that contains a specific point.
		 * @param	target  A point within bounds of sites.
		 * @return  A vector containing vertices of the polygon.
		 */
		public function getPolygonAt(target:PointVX):Vector.<PointVX>
		{
			return voronoi.region (target);
		}
		
		/**
		 * Get a (cell-) polygon.
		 * @param	siteIndex Index of the cells site.
		 * @return  A vector containing vertices of the polygon.
		 */
		public function getPolygonOf(siteIndex:uint):Vector.<PointVX>
		{
			var tempIndex:uint = 999999;
			for (var i:int = 0; i < numSites; i++) 
			{
				if (sites[i].index == siteIndex)
				{
					tempIndex = i;
					break;
				}
			}
			return polygons[tempIndex];
		}
		
		/**
		 * Get the (not 100% accurate) center of the (cell-) polygon.
		 * @param	siteIndex  Index of the site
		 * @return  Center of the (cell-) polygon.
		 */
		public function getCenterOf(siteIndex:int):PointVX 
		{
			return polygonCenters[siteIndex];
		}
		
		/**
		 * Creates an deep clone of this charts sites.
		 * @return  A clone of sites.
		 */
		public function cloneState():Vector.<PointVX> 
		{
			var clone:Vector.<PointVX> = new Vector.<PointVX>(numSites);
			for (var i:int = 0; i < numSites; i++) 
				clone[i] = sites[i].clone ();
			return clone;
		}
		
	}

}