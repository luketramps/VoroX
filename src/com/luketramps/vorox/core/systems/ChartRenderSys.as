/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.systems 
{
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	import com.luketramps.vorox.core.components.Chart;
	import com.luketramps.vorox.core.nodes.RenderVoroNode;
	import com.luketramps.vorox.data.DictionaryPool;
	import com.luketramps.vorox.data.EdgePool;
	import com.luketramps.vorox.data.HalfEdgePool;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.data.PointVXPool;
	import com.luketramps.vorox.data.VectorBoolPool;
	import com.luketramps.vorox.data.VectorEdgePool;
	import com.luketramps.vorox.data.VectorHalfEdgePool;
	import com.luketramps.vorox.data.VectorLrPool;
	import com.luketramps.vorox.data.VectorPointVXPool;
	import com.luketramps.vorox.data.VectorVertexPool;
	import com.luketramps.vorox.Vorox;
	import com.nodename.Delaunay.Voronoi;
	/**
	 * Updates the voronoi diagram(s).
	 * @author Lukas Damian Opacki
	 */
	public class ChartRenderSys extends System
	{
		static public var systemPriority:uint;
		static public var autoKillCells:Boolean;
		
		private var vorox:Vorox;
		private var chartNodes:NodeList;
		
		public override function addToEngine(ash:Engine):void 
		{
			vorox = Vorox.getInstance ();
			chartNodes = ash.getNodeList (RenderVoroNode);
		}
		
		private var chart:Chart;
		
		// Render regions from chart to update polygon data.
		public override function update(t:Number):void
		{
			vorox.onChartUpdate.dispatch ();
			
			for (var node:RenderVoroNode = chartNodes.head; node; node = node.next) 
			{
				chart = node.siteCore;
				
				// Skip locked chart.
				if (!chart.locked)
				{
					if (chart.voronoi != null) 
					{
						// Dispose last frame data.
						disposeReferencesOf (chart);
					}
					
					// Setup object pools for current frame.
					storeReferencesFor (chart);
					
					// Try to collect garbage.
					GarbageCollector.gc ();
					
					// Update voronoi.
					chart.voronoi = new Voronoi (chart.sites, null, chart.bounds);
					chart.polygons = chart.voronoi.regions();
					
					// Update cell centers.
					var numRegions:uint = chart.numSites;
					for (var i:int = 0; i < numRegions; i++) 
					{
						setCenter (chart.getPolygonOf (i), chart.getCenterOf (i));
					}
					
					// Check if sites are within bounds.
					var m:int;
					if (autoKillCells)
						for (m = 0; m < chart.numSites; m++) 
						{
							if (chart.polygons[m].length == 0)
							{
								vorox.removeSite (chart.name, m--);
							}
						}
					else 
						for (m = 0; m < chart.numSites; m++) 
						{
							if (chart.polygons[m].length == 0)
							{ 
								throw new Error ("The site with the index " + String (m) + " is out of bounds.");
							}
						}
				}
			}
			
			vorox.onChartUpdateComplete.dispatch ();
		}
		
		// Collect current frame references.
		[Inline]
		public final function storeReferencesFor(chart:Chart):void
		{
			chart.pointPoolID = PointVXPool.enterNextSubPool ();
			chart.edgePoolID = EdgePool.enterNextSubPool ();
			chart.dictPoolID = DictionaryPool.enterNextSubPool ();
			chart.vecEdgePoolID = VectorEdgePool.enterNextSubPool ();
			chart.vecBoolPoolID = VectorBoolPool.enterNextSubPool ();
			chart.vecPvxPoolID = VectorPointVXPool.enterNextSubPool ();
			chart.vecLrPoolID = VectorLrPool.enterNextSubPool ();
			chart.halfEdgePoolID = HalfEdgePool.enterNextSubPool ();
			chart.vecHalfedgePoolID = VectorHalfEdgePool.enterNextSubPool ();
			chart.vecVertexPoolID = VectorVertexPool.enterNextSubPool ();
			chart.poolsCleared = false;
		}
		
		// Dispose last frame objects into pools.
		[Inline]
		public final function disposeReferencesOf(chart:Chart):void
		{
			PointVXPool.disposeSubpool (chart.pointPoolID);
			EdgePool.disposeSubpool (chart.edgePoolID);
			DictionaryPool.disposeSubpool (chart.dictPoolID);
			VectorEdgePool.disposeSubpool (chart.vecEdgePoolID);
			VectorBoolPool.disposeSubpool (chart.vecBoolPoolID);
			VectorPointVXPool.disposeSubpool (chart.vecPvxPoolID);
			VectorLrPool.disposeSubpool (chart.vecLrPoolID);
			HalfEdgePool.disposeSubpool (chart.halfEdgePoolID);
			VectorHalfEdgePool.disposeSubpool (chart.vecHalfedgePoolID);
			VectorVertexPool.disposeSubpool (chart.vecVertexPoolID);
			chart.poolsCleared = true;
			chart.voronoi.dispose();
		}
		
		private var x:Number = 0;
		private var y:Number = 0;
		private var j:uint, i:uint;
		private var p1:PointVX;
		private var p2:PointVX;
		private var area:Number;
		
		// Get a polygon center.
		[Inline] 
		final private function setCenter(region:Vector.<PointVX>, center:PointVX):void
		{
			x = y = 0;
			
			j = region.length -1;
			for (i = 0; i < region.length; i++) 
			{
				p1 = region[j];
				p2 = region[i];
				x += (p1.x + p2.x)*(p1.x * p2.y - p2.x * p1.y);
				y += (p1.y + p2.y) * (p1.x * p2.y - p2.x * p1.y);
				j = i;
			}
			area = getPolygonalArea (region);
			x = 1 / (6 * area) * x;
			y = 1 / (6 * area) * y;
			
			center.x = x;
			center.y = y;
		}
		
		// Get polygon area.
		[Inline] 
		final private function getPolygonalArea(region:Vector.<PointVX>):Number
		{
			area = 0;
			j = region.length -1;
			for (i = 0; i < region.length; i++) 
			{
				area = area + (region[j].x + region[i].x) * (region[j].y - region[i].y);
				j = i;
			}
			return area / 2 * (-1);
		}
		
	}

}

import flash.net.LocalConnection;
import flash.system.System;

internal class GarbageCollector
{
	static function gc():void
	{
		System.pauseForGCIfCollectionImminent (.1);
		//System.gc ();
		//System.gc ();
	}
	
	static function force():void
	{
		try
		{
			new LocalConnection().connect('foo');
			new LocalConnection().connect('foo');
		}
		catch (e:*) { }
	}
}