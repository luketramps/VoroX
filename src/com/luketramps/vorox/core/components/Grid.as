/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.components 
{
	import ash.core.Entity;
	import com.genome2d.components.renderable.GShape;
	import com.genome2d.node.GNode;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.skins.align.AlignCenter;
	import com.luketramps.vorox.Vorox;
	import flash.utils.Dictionary;
	/**
	 * A grid is a visual representation of a voronoi chart.
	 * Warning: Some values should not be changed here.
	 * @author Lukas Damian Opacki
	 */
	public class Grid 
	{
		/**
		 * Name of the grid.
		 */
		public var name:String;
		
		/**
		 * If true, this grid will not be updated at screen.
		 */
		public var locked:Boolean;
		
		/**
		 * The node of this grid in genome2d display list.
		 */
		public var gNode:GNode;
		
		/**
		 * The root node of genome2d display list.
		 */
		public var gRoot:GNode;
		
		/**
		 * Cores of cells, sorted by site index.
		 */
		public var cells:Vector.<Cell>;
		
		/**
		 * Renderables of cells, sorted by site index.
		 */
		public var cellShapes:Vector.<GShape>;
		
		/**
		 * Empty space inbetween cells.
		 */
		public var outlinePixels:uint;
		
		/**
		 * Parental chart of the grid.
		 */
		public var chart:Chart;
		
		/**
		 * Rendering results from grid render system (triangulated vertices and uvs).
		 */
		public var renderData:GridRenderResult;
		
		
		private var vx:Vorox;
		
		// Current world space.
		private var scaleX:Number;
		private var scaleY:Number;
		private var x:Number;
		private var y:Number;
		
		/**
		 * Private constructor.
		 */
		public function Grid()
		{
			vx = Vorox.getInstance ();
		}
		
		/**
		 * Must be called once per frame, before using <code>getWorldCoordinate(...)</code> and <code>getWorldPolygon(...)</code>.
		 * This is done automaticly by defaults in <code>ConfigVX</code>.
		 */
		public function translateSpace():void
		{
			x = y = 0;
			scaleY = scaleX = 1;
			
			var parentNodes:Vector.<GNode> = new Vector.<GNode>();
			for (var node:GNode = gNode; node; node = node.parent)
			{
				if (node == gRoot)
					break;
				//parentNodes.push (node);
				parentNodes[parentNodes.length] = node;
			}
			
			parentNodes.reverse ();
			
			var numParents:uint = parentNodes.length;
			for (var i:int = 0; i < numParents; i++) 
			{
				node = parentNodes[i];
				
				x += node.x * scaleX;
				y += node.y * scaleY;
				
				scaleX *= node.scaleX;
				scaleY *= node.scaleY;
			}
		}
		
		/**
		 * Translates a polygon from grid space to world space.
		 * @param	polygon		  Polygon in local space.
		 * @param	resultVector  (Resulting) Polygon in world space.
		 */
		public function getWorldPolygon(polygon:Vector.<PointVX>, resultVector:Vector.<PointVX>):void
		{
			var numVerts:uint = polygon.length;
			for (var i:int = 0; i < numVerts; i++) 
			{
				if (resultVector[i] == null)
					resultVector[i] = new PointVX ();
					
				getWorldCoordinate (polygon[i], resultVector[i]);
			}
		}
		
		/**
		 * Translate a point from grid space to global space.
		 * @param	Point in local space.
		 * @param	(Resulting) Point in global space.
		 */
		public function getWorldCoordinate(p:PointVX, result:PointVX):void
		{
			result.x = x + (scaleX * p.x);
			result.y = y + (scaleY * p.y);
		}
		
		/**
		 * Return the site with the given index.
		 * @param	siteIndex Index of the site.
		 * @return  The site with the given index.
		 */
		public function getSite(siteIndex:uint):void
		{
			return chart.getSite (siteIndex);
		}
		
		/**
		 * Returns the cell, that represents the region of the site with the given index.
		 * @param	index  Index of the cell(s site).
		 * @return  The cell of this gird with the given index.
		 */
		public function getCell(index:uint):Cell 
		{
			return cells[index];
		}
		
		/**
		 * Find a cell in the grid that contains a specific point.
		 * @param	target    A point within bounds of an chart.
		 * @return  The cell of this grid, that contains the given point.
		 */
		public function getCellAt(x, y):Cell
		{
			return cells [ chart.getSiteAt (x, y).index ];
		}
		
		/**
		 * Apply a Skin to a cell.
		 * Skins must be created first with <code>addSkin()</code> before they can be applied to cells.
		 * @param	skinName   Name of the skin.
		 * @param	cellIndex  Index of the cells site.
		 * @param	Align	   Skin alignment. If <code>null</code> then <code>AlignCenter</code> will be used.
		 */
		public function applySkin(skinName:String, cellIndex:uint, Align:Class = null):void
		{
			vx.skinner.applySkin (skinName, cell, (!Align) ? AlignCenter : Align);
		}
		
	}

}