/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins.masked 
{
	import com.genome2d.components.GComponent;
	import com.luketramps.vorox.skins.SkinComponent;
	/**
	 * <p>A masked cells skin component.</p>
	 * @inheritDoc
	 * @author Lukas Damian Opacki
	 */
	public class MaskedSkinComponent extends SkinComponent
	{
		/**
		 * An instance of the renderable GComponent that will be masked by the cell polygon.
		 */
		public var canvas:GComponent;
		
		/**
		 * @inheritDoc
		 */
		public function MaskedSkinComponent() 
		{
			super (MaskedSkinComponent);
		}
		
	}

}