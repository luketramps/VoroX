/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins.simple 
{
	import com.genome2d.textures.GTexture;
	import com.luketramps.vorox.skins.SkinComponent;
	/**
	 * <p>A simple skin component</p>
	 * @inheritDoc
	 * @author Lukas Damian Opacki
	 */
	public class SimpleSkinComponent extends SkinComponent
	{
		/**
		 * Reference to the cells texture.
		 */
		public var gTexture:GTexture;
		
		/**
		 * @inheritDoc
		 */
		public function SimpleSkinComponent() 
		{
			super (SimpleSkinComponent);
		}
		
	}

}