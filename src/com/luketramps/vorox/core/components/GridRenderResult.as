/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.components 
{
	import com.luketramps.vorox.data.PointVX;
	/**
	 * Holds data rendered by <code>GridRenderSystem</code> which is used to setup genome2d renderables.
	 * Grids with the same sites and outlines (that's the space between cells) are beeing batched.
	 * @author Lukas Damian Opacki
	 */
	public class GridRenderResult 
	{
		/**
		 * Space between cells. 
		 */
		public var outlinePx:uint;
		
		/**
		 * Resized cell polygons (shrinked by outlinePx).
		 */
		public var outlinedPolygons:Vector.<Vector.<PointVX>>;
		
		/**
		 * Vertices for AnimatableGShape instances, sorted by site index.
		 */
		public var vertices:Vector.<Array>;
		
		/**
		 * UV Texture coordinates comming from skin alingments, sorted by site index.
		 */
		public var uvcoords:Vector.<Array>;
		
		/**
		 * Cell cores of the related grid.
		 */
		public var cells:Vector.<Cell>;
		
		/**
		 * True, if the data was rendered after last tick.
		 */
		public var isValid:Boolean;
		
	}

}

