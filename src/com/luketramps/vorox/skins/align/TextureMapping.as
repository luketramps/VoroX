/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins.align 
{
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.data.PointVX;
	/**
	 * Abstract class. 
	 * Subclass to create costum skin alingment.
	 * @author Lukas Damian Opacki
	 */
	public class TextureMapping 
	{
		
		public function TextureMapping() 
		{
		}
		
		/**
		 * Function that ads uv coordinates for a single vertex to an array.
		 * For example <code>uvCoordinates.push (myUv.x, myUv.y)</code>.
		 * @param	vert			The vertex.
		 * @param	uvCoordinates	Collection of uv coordinates, where the result must be added.
		 * @param	cell			An instance of Cell.
		 */
		public function mapUvToVertex(vert:PointVX, uvCoordinates:Array, cell:Cell):void
		{
		}
		
	}

}