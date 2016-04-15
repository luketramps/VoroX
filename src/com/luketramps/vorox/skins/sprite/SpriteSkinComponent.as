/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins.sprite 
{
	import com.genome2d.animation.GFrameAnimation;
	import com.luketramps.vorox.skins.SkinComponent;
	/**
	 * <p>Skin component for (sprite style) animated cells.</p>
	 * @inheritDoc
	 * @author Lukas Damian Opacki
	 */
	public class SpriteSkinComponent extends SkinComponent
	{
		/**
		 * References to the animation frames.
		 */
		public var frameAnimation:GFrameAnimation;
		
		/**
		 * @inheritDoc
		 */
		public function SpriteSkinComponent() 
		{
			super (SpriteSkinComponent);
		}
		
	}

}