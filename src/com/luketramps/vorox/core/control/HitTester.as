/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.control 
{
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.core.components.Grid;
	import com.luketramps.vorox.components.SpriteSkin;
	import com.luketramps.vorox.core.components.GridRenderResult;
	import com.luketramps.vorox.core.systems.GridRenderSys;
	import com.luketramps.vorox.data.PointVX;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * Internal controls.
	 * @author Lukas Damian Opacki
	 */
	public class HitTester 
	{
		[Inject] public var stage:Stage;
		
		private var debugMode:Boolean = false;
		private var debugCanvas:Sprite;
		
		private var worldHitPoint:PointVX = new PointVX ();
		private var boundsMax:PointVX = new PointVX ();
		private var boundsMin:PointVX = new PointVX ();
		private var worldVertices:Vector.<PointVX> = new Vector.<PointVX> (12);
		
		public function HitTester() 
		{
		}
		
		[PostConstruct]
		public function onStartup():void
		{
			if (debugMode) 
			{
				debugCanvas = new Sprite ();
				stage.addChild (debugCanvas);
				//stage.addEventListener (Event.ENTER_FRAME, function(e:*):void { debugCanvas.graphics.clear () } );
			}
		}
		
		// Tests if a point overlays the polygonal area of a cell.
		[Inline]
		public final function hitTest(cell:Cell, hitPoint:PointVX):Boolean 
		{
			var grid:Grid = cell.grid;
			
			boundsMax.x = cell.boundingMaxX;
			boundsMax.y = cell.boundingMaxY;
			boundsMin.x = cell.boundingMinX;
			boundsMin.y = cell.boundingMinY;
			
			// Convert local bounds to world bounds.
			if (GridRenderSys.updateWorldCoordinates == false)
				grid.translateSpace ();
			
			worldHitPoint = hitPoint;
			grid.getWorldCoordinate (boundsMax, boundsMax);
			grid.getWorldCoordinate (boundsMin, boundsMin);
			
			// Check if point is inside cells bounding box.
			if ((worldHitPoint.x > boundsMin.x) && (worldHitPoint.x < boundsMax.x) &&
				(worldHitPoint.y > boundsMin.y) && (worldHitPoint.y < boundsMax.y))
				{
					var originVertices:Vector.<PointVX> = cell.chart.getPolygonOf (cell.index)
					var numRegionVerts:uint = originVertices.length;
					var numIntersections:int = 0;
					
					// Convert local vertices to world vertices.
					grid.getWorldPolygon (originVertices, worldVertices);
					
					// Cast a ray horizontaly, begining at the hitpoint and going through the polygon, to find intersections with the cells outlines (Jordan curve theorem).
					for (var i:int = 0, j = numRegionVerts-1; i < numRegionVerts; j = i++) 
					{
						if (((worldVertices[i].y > worldHitPoint.y) != (worldVertices[j].y > worldHitPoint.y)) &&
							(worldHitPoint.x < (worldVertices[j].x - worldVertices[i].x) * (worldHitPoint.y - worldVertices[i].y) /
							(worldVertices[j].y - worldVertices[i].y) + worldVertices[i].x))
							{
								numIntersections ++;
							}
					}
					
					if (debugMode)
					{
						debugCanvas.graphics.clear ();
						drawCell (worldVertices, numRegionVerts, 0xff00ff);
						drawBounds (boundsMin, boundsMax, 0x00ff00);
					}
					
					// Hittest was successfull if..
					if (numIntersections % 2 == 1)
						return true;
					else return false;
				}
				
		}
		
		private function drawBounds(boundsMin:PointVX, boundsMax:PointVX, color:uint):void 
		{
			debugCanvas.graphics.lineStyle (1, color, .8);
			debugCanvas.graphics.moveTo (boundsMin.x, boundsMin.y);
			debugCanvas.graphics.lineTo (boundsMax.x, boundsMin.y);
			debugCanvas.graphics.lineTo (boundsMax.x, boundsMax.y);
			debugCanvas.graphics.lineTo (boundsMin.x, boundsMax.y);
			debugCanvas.graphics.lineTo (boundsMin.x, boundsMin.y);
		}
		
		private function drawCell(verts:Vector.<PointVX>, numVerts:uint, color:uint):void 
		{
			debugCanvas.graphics.lineStyle (1, color, .8);
			for (var i:int = 0, j = numVerts -1; i < numVerts; j = i++) 
			{
				debugCanvas.graphics.moveTo (verts[j].x, verts[j].y);
				debugCanvas.graphics.lineTo (verts[i].x, verts[i].y);
			}
		}
		
	}

}