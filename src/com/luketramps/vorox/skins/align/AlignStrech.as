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
	 * Maps texture so it gets streched.
	 * @author Lukas Damian Opacki
	 */
	public class AlignStrech extends TextureMapping 
	{
		/**
		 * @inheritDoc
		 */
		public override function mapUvToVertex(vert:PointVX, uvCoordinates:Array, cell:Cell):void 
		{
			uvCoordinates.push (((vert.x - cell.boundingMinX) / cell.width));
			uvCoordinates.push (((vert.y - cell.boundingMinY) / cell.height));
		}
		
	}
}