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
	 * Maps the texture so it's center sticks with the cells bounding box center.
	 * @author Lukas Damian Opacki
	 */
	public class AlignCenter extends TextureMapping 
	{
		/**
		 * @inheritDoc
		 */
		public override function mapUvToVertex(vert:PointVX, uvCoordinates:Array, cell:Cell):void 
		{
			if (cell.width > cell.height)
			{
				uvCoordinates.push ((vert.x - cell.boundingMinX) / cell.width);
				uvCoordinates.push ((vert.y - cell.boundingMinY + (cell.width - cell.height) /2 ) / cell.width);
			}
			else
			{
				uvCoordinates.push ((vert.x - cell.boundingMinX + (cell.height - cell.width) /2 ) / cell.height);
				uvCoordinates.push ((vert.y - cell.boundingMinY) / cell.height);
			}
		}
	}

}