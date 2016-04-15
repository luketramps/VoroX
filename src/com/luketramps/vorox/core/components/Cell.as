/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.components 
{
	import ash.core.Entity;
	import com.genome2d.node.GNode;
	import com.luketramps.vorox.skins.SkinComponent;
	import com.luketramps.vorox.core.renderable.GSpriteShape;
	import com.luketramps.vorox.data.PointVX;
	/**
	 * A cell is a visual representation of a region surrounding a site point in the voronoi chart, that can be skinned.
	 * Warning: Some values should not be changed here.
	 * @author Lukas Damian Opacki
	 */
	public class Cell 
	{
		/**
		 * The site related to this cell.
		 */
		public var site:PointVX;
		
		/**
		 * The entity, that holds this component.
		 */
		public var entity:Entity;
		
		/**
		 * Parental chart of this cell.
		 */
		public var chart:Chart;
		
		/**
		 * Parental grid that holds this cell.
		 */
		public var grid:Grid;
		
		/**
		 * The genome2d renderable that will be texturised to represent the cell on screen.
		 */
		public var gShape:GSpriteShape;
		
		/**
		 * The GNode instance that represents the cells position in genome2d display list.
		 */
		public var gNode:GNode;
		
		/**
		 * Width of the cell in local grid space.
		 */
		public var width:Number;
		
		/**
		 * Height of the cell in local grid space.
		 */
		public var height:Number;
		
		/**
		 * Center of the cells bounding rectangle on x achsis.
		 */
		public var boundsCenterX:Number;
		
		/**
		 * Center of the cells bounding rectangle on y achsis.
		 */
		public var boundsCenterY:Number;
		
		/**
		 * Upper left corner of the cells bounding rectangle on x achsis.
		 */
		public var boundingMinX:Number;
		
		/**
		 * Upper left corner of the cells bounding rectangle on y achsis.
		 */
		public var boundingMinY:Number;
		
		/**
		 * Lower right corner of the cells bounding rectangle on x achsis.
		 */
		public var boundingMaxX:Number;
		
		/**
		 * Lower right corner of the cells bounding rectangle on y achsis.
		 */
		public var boundingMaxY:Number;
		
		/**
		 * The currently attached skin of the cell.
		 */
		public var skin:SkinComponent;
		
		/**
		 * The cells identity, which is also it's sites index.
		 */
		public function get index():int 
		{
			return site.index;
		}
		
		/**
		 * The (cell-) polygon.
		 */
		public function get polygon():Vector.<PointVX>
		{
			return chart.getPolygonOf (site.index);
		}
		
		/**
		 * Center of the (cell-) polygon (not 100% accurate).
		 */
		public function get polygonCenter():PointVX
		{
			return chart.getCenterOf (site.index);
		}
		
		
	}

}