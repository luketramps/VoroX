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
	import com.genome2d.components.renderable.GShape;
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.core.components.Grid;
	import com.luketramps.vorox.core.components.GridRenderResult;
	import com.luketramps.vorox.core.components.Chart;
	import com.luketramps.vorox.core.nodes.RenderGridsNode;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.data.PointVXPool;
	import com.luketramps.vorox.skins.align.AlignCenter;
	import com.luketramps.vorox.skins.align.AlignNone;
	import com.luketramps.vorox.skins.align.AlignStrech;
	import com.luketramps.vorox.Vorox;
	import flash.utils.Dictionary;
	
	/**
	 * Renders voronoi polygons to screen.
	 * @author Lukas Damian Opacki
	 */
	public class GridRenderSys extends System
	{
		public static var useBuiltInAlignment:Boolean;
		public static var updateWorldCoordinates:Boolean;
		public static var systemPriority:uint;
		public static var alignments:Dictionary = new Dictionary (false);
		
		[Inject]
		public var vx:Vorox;
		
		private var chartList:NodeList;
		private var grid:Grid;
		private var chart:Chart;
		private var pointPoolID:int = -1;
		
		public override function addToEngine(ash:Engine):void 
		{
			if (chartList == null)
				chartList = ash.getNodeList (RenderGridsNode);
		}
		
		// Render all grids.
		public override function update(t:Number):void
		{
			vx.onGridsUpdate.dispatch ();
			
			var numGrids:uint;
			var renderData:GridRenderResult;
			
			// Dispose last frame objects.
			if (pointPoolID > -1)
				PointVXPool.disposeSubpool (pointPoolID);
			
			// Collect this frame objects into pool.
			pointPoolID = PointVXPool.enterNextSubPool ();
			
			for (var node:RenderGridsNode = chartList.head; node; node = node.next)
			{
				chart = node.siteCore;
				numGrids = chart.myGrids.length;
				
				// Invalidate last frame render results.
				for each (var data:GridRenderResult in chart.renderResults)
					data.isValid = false;
				
				// Render grids.
				for (var i:int = 0; i < numGrids; i++) 
				{
					grid = chart.myGrids[i];
					cells = grid.cells;
					renderData = chart.renderResults[grid.outlinePixels];
					
					// Dont render grids, if they dont want to.
					if (!grid.locked)
					{
						// Update regions count.
						numRegions = grid.chart.numSites;
						
						// Get collections which store render results.
						gridVertices = renderData.vertices;
						gridUvCoords = renderData.uvcoords;
						
						// Dont render twice, if same chart parent and outlinePixels.
						if (renderData.isValid == false)
						{
							// Get voronoi regions for triangulation.
							regions = renderData.outlinedPolygons;
							
							// Shrink regions for outlines.
							if (grid.outlinePixels > 0)
								shrinkRegions (chart, grid.outlinePixels / 2);
							
							// Triangulate region points and map textures for gshapes.
							triangulateRegions ();
							
							// Store cells to copy data
							renderData.cells = cells;
							
							// Prevent re-rendering.
							renderData.isValid = true;
						}
						else 
						{
							// Copy data from rendered cells
							copyCellData (grid, renderData);
						}
						
						// Store latest verts and uvs inside grid.
						grid.renderData = renderData;
						
						// Update world coords.
						if (updateWorldCoordinates)
							grid.translateSpace ();
						
						// Upload vertices and uvs to gpu.
						setupShapes (); 
					}
				}
			}
			
			vx.onGridsUpdateComplete.dispatch ();
		}
		
		[Inline]
		private final function copyCellData(grid:Grid, renderData:GridRenderResult):void 
		{
			var numCells:uint = cells.length;
			for (var m:int = 0; m < numCells; m++) 
			{
				grid.cells[m].boundingMinX = renderData.cells[m].boundingMinX;
				grid.cells[m].boundingMinY = renderData.cells[m].boundingMinY;
				grid.cells[m].boundingMaxX = renderData.cells[m].boundingMaxX;
				grid.cells[m].boundingMaxY = renderData.cells[m].boundingMaxY;
				grid.cells[m].width = renderData.cells[m].width;
				grid.cells[m].height = renderData.cells[m].height;
				grid.cells[m].boundsCenterX = renderData.cells[m].boundsCenterX;
				grid.cells[m].boundsCenterY = renderData.cells[m].boundsCenterY;
			}
		}
		
		private var cells:Vector.<Cell>;
		private var cell:Cell;
		private var gShapes:Vector.<GShape>;
		private var gridVertices:Vector.<Array>;
		private var gridUvCoords:Vector.<Array>;
		
		
		// Set vertices and texture coordinates.
		[Inline]
		final public function setupShapes():void
		{
			gShapes = grid.cellShapes;
			
			for (i = 0; i < numRegions; i++ )
			{
				gShapes[i].setup (gridVertices[i], gridUvCoords[i]);
			}
		}
		
		// TRIANGULATE REGIONS
		// **************************************************************************************
		
		private var texcoords:Array;
		private var verts:Array;
		private var numRegions:int;
		private var numRegionPoints:uint;
		private var maxX:Number;
		private var maxY:Number;
		private var minX:Number;
		private var minY:Number;
		private var k:uint, l:uint, i:uint, ii:uint, jj:uint, j:uint;
		
		[Inline]
		final private function triangulateRegions():void
		{
			var regions:Vector.<Vector.<PointVX>> = chart.polygons;
			
			numRegions = regions.length;
			
			for (i = 0; i < numRegions; i++) 
			{
				verts = gridVertices[i];
				texcoords = gridUvCoords[i];
				cell = cells[i];
				
				verts.length = 0;
				texcoords.length = 0;
				
				numRegionPoints = regions[i].length;
				
				// Get bounds for "scaleTex" uv-coord evaluation
				var currentX:Number;
				var currentY:Number;
				
				maxX = 0;
				maxY = 0;
				minX = 1000000;
				minY = 1000000;
				for (j = 0; j < numRegionPoints; j++)
				{
					currentX = regions[i][j].x;
					currentY = regions[i][j].y;
					if (currentX > maxX) maxX = currentX;
					if (currentY > maxY) maxY = currentY;
					if (currentX < minX) minX = currentX;
					if (currentY < minY) minY = currentY;
				}
				
				cell.boundingMinX = minX;
				cell.boundingMinY = minY;
				cell.boundingMaxX = maxX;
				cell.boundingMaxY = maxY;
				cell.width = maxX - minX;
				cell.height = maxY - minY;
				cell.boundsCenterX = minX + (maxX - minX)/2;
				cell.boundsCenterY = minY + (maxY - minY) / 2;
				
				// triangulate
				for (k = 0, l = numRegionPoints -1; k < l; k++, l--)
				{
					// a, b, z
					if (k + 1 != l)
					{
						verts.push (regions[i][k].x);
						verts.push (regions[i][k].y);
						verts.push (regions[i][k + 1].x);
						verts.push (regions[i][k + 1].y);
						verts.push (regions[i][l].x);
						verts.push (regions[i][l].y);
						
						// Store scaled uv coords.
						addUVs (regions[i][k]);
						addUVs (regions[i][k + 1]);
						addUVs (regions[i][l]);
					}
					
					// z, y, b
					if (k + 2 < l)
					{
						verts.push (regions[i][l].x);
						verts.push (regions[i][l].y);
						verts.push (regions[i][l - 1].x);
						verts.push (regions[i][l - 1].y);
						verts.push (regions[i][k + 1].x);
						verts.push (regions[i][k + 1].y);
						
						addUVs (regions[i][l]);
						addUVs (regions[i][l - 1]);
						addUVs (regions[i][k + 1]);
					}
				}
			}
		}
		
		// SKIN ALIGN (UV MAPPING)
		// **************************************************************************************
		
		[Inline]
		final private function addUVs(p:PointVX):void
		{
			var align:Class;
			
			if (!cell.skin)
				align = AlignNone;
			else 
				align = cell.skin.AlignType;
			
			// Inlined skin align.
			if (useBuiltInAlignment)
			{
				if (align == AlignCenter)
				{
					if (cell.width > cell.height)
					{
						texcoords.push ((p.x - cell.boundingMinX) / cell.width);
						texcoords.push ((p.y - cell.boundingMinY + (cell.width - cell.height) /2 ) / cell.width);
					}
					else
					{
						texcoords.push ((p.x - cell.boundingMinX + (cell.height - cell.width) /2 ) / cell.height);
						texcoords.push ((p.y - cell.boundingMinY) / cell.height);
					}
				}
				else if (align == AlignStrech)
				{
					texcoords.push (((p.x - cell.boundingMinX) / cell.width));
					texcoords.push (((p.y - cell.boundingMinY) / cell.height));
				}
				else if (align = AlignNone)
				{
					texcoords.push (p.x);
					texcoords.push (p.y);
				}
				else
					chooseAlign (p, align);
			}
			else chooseAlign (p, align);
		}
		
		[Inline]
		private final function chooseAlign(p:PointVX, AlignType:Class):void 
		{
			alignments[AlignType].mapUvToVertex (p, texcoords, cell);
		}
		
		// CREATE OUTLINES (SCALE CELL REGIONS DOWN)
		// **************************************************************************************
		
		private var p1:PointVX;
		private var p2:PointVX;
		private var p3:PointVX;
		private var p2_shrinked:PointVX;
		private var shrinkPixels:Number;
		private var regionsResized:Vector.<Vector.<PointVX>> = new Vector.<Vector.<PointVX>> ();
		
		[Inline]
		final private function shrinkRegions(chart:Chart, outlineThickness:Number):Vector.<Vector.<PointVX>>
		{
			this.shrinkPixels = outlineThickness;
			
			var regions:Vector.<Vector.<PointVX>> = chart.polygons;
			
			// ensure there are enough arrays
			var delta:int = regions.length - regionsResized.length;
			if (delta > 0)
			{
				for (i = 0; i < delta; i++)
				{
					regionsResized.push (new Vector.<PointVX> ());
				}
			}
			
			// resize regions inbetween first and last
			for (jj = 0; jj < numRegions; jj++)
			{
				numRegionPoints = regions[jj].length;
				regionsResized[jj].length = numRegionPoints;
				
				for (ii = 0; ii < numRegionPoints-2; ii++)
				{
					p1 = regions[jj][ii];
					p2 = regions[jj][ii+1];
					p3 = regions[jj][ii + 2];
					findShrinkPoint ();
					regionsResized[jj][ii+1] = p2_shrinked;
				}
				
				// resize last region
				p1 = regions[jj][numRegionPoints-2];
				p2 = regions[jj][numRegionPoints-1];
				p3 = regions[jj][0];
				findShrinkPoint ();
				regionsResized[jj][numRegionPoints - 1] = p2_shrinked;
				
				// resize first resgion
				p1 = regions[jj][numRegionPoints-1];
				p2 = regions[jj][0];
				p3 = regions[jj][1];
				findShrinkPoint ();
				regionsResized[jj][0] = p2_shrinked;
			}
			
			chart.polygons = regionsResized;
			
			return regionsResized;
		}
		
		private var v1:PointVX = new PointVX (0, 0);
		private var v2:PointVX = new PointVX (0, 0);
		private var v3:PointVX = new PointVX (0, 0);
		
		[Inline]
		final private function findShrinkPoint():void
		{
			var v1_length:Number;
			var v2_length:Number;
			
			v1.x = p2.x - p1.x;
			v1.y = p2.y - p1.y;
			v2.x = p2.x - p3.x;
			v2.y = p2.y - p3.y;
			
			// vectors
			v1_length = Math.sqrt (Math.pow(v1.x, 2) + Math.pow (v1.y, 2));
			v2_length = Math.sqrt (Math.pow(v2.x, 2) + Math.pow (v2.y, 2));
			
			// unify vectors
			v1.x = v1.x / v1_length;
			v1.y = v1.y / v1_length;
			v2.x = v2.x / v2_length;
			v2.y = v2.y / v2_length;
			
			v3 = PointVXPool.getPointFromSubpool ((v1.x + v2.x)/2, (v1.y + v2.y)/2);
			
			// set distance
			v3.x = v3.x * shrinkPixels;
			v3.y = v3.y * shrinkPixels;
			
			v3.x = (p2.x + v3.x * -1);
			v3.y = (p2.y + v3.y * -1);
			p2_shrinked = v3;
		}
		
	}

}