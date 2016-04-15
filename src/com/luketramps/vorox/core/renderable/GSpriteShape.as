/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.renderable 
{
	import com.genome2d.animation.GFrameAnimation;
	import com.genome2d.components.renderable.GShape;
	import com.genome2d.context.GCamera;
	
	/**
	 * A GShape with GFrameAnimation.
	 * @author Lukas Damian Opacki
	 */
	public class GSpriteShape extends GShape 
	{
		public var frameAnimation:GFrameAnimation;
		
		public function GSpriteShape() 
		{
			super();
		}
		
		override public function render(p_camera:GCamera, p_useMatrix:Boolean):void 
		{
			if (frameAnimation)
			{
				frameAnimation.update (node.core.getCurrentFrameDeltaTime());
				texture = frameAnimation.currentFrameTexture;
			}
			
			super.render(p_camera, p_useMatrix);
		}
		
	}

}