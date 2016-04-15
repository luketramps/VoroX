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
	 * Maps vertices to uvs like 1:1.
	 * @author Lukas Damian Opacki
	 */
	public class AlignNone extends TextureMapping 
	{
		/**
		 * @inheritDoc
		 */
		public override function mapUvToVertex(vert:PointVX, uvCoordinates:Array, cell:Cell):void 
		{
			uvCoordinates.push (vert.x);
			uvCoordinates.push (vert.y);
		}
		
	}

}