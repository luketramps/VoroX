/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins.masked 
{
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderable.IGRenderable;
	import com.luketramps.vorox.skins.masked.MaskedSkinComponent;
	import com.luketramps.vorox.skins.SkinConfig;
	/**
	 * <p>A masked skin configuration. 
	 * A masked skin uses the cells polygonal area to mask a costum renderable.
	 * The renderable must be a subclass of GComponent without constructor parameters.
	 * To use masked skins, depth and stencil must be enabled.</p>
	 * @inheritDoc
	 * @author Lukas Damian Opacki
	 */
	public class MaskedSkin extends SkinConfig
	{
		/**
		 * Type of renderable that will be masked.
		 */
		public var Canvas:Class;
		
	   /**
		* Configurates a masked skin.
		* @param	skinName	 Name of the skin.
		* @param	CanvasClass  Type of renderable that will be masked.
		*/
		public function MaskedSkin(skinName:String, CanvasClass:Class) 
		{
			super (skinName, MaskedSkinComponent);
			this.Canvas = CanvasClass;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose(disposeSource:Boolean):void 
		{
			super.dispose (disposeSource);
			this.Canvas = null;
		}
	}

}