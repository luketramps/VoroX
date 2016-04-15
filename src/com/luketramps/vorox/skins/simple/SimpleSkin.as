/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins.simple 
{
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureManager;
	import com.luketramps.vorox.skins.SkinConfig;
	import flash.display.BitmapData;
	/**
	 * SimpleSkin texturises a cell with a single texture.
	 * @author Lukas Damian Opacki
	 */
	public class SimpleSkin extends SkinConfig 
	{
		/**
		 * Create a new SimpleSkin from a native texture, an (embeded) bitmap or bitmapData object.
		 * @param	skinName  Name of the skin.
		 * @param	source	  Pixel data for the skin.
		 * @return  New SimpleSkin
		 */
		public static function createFrom (skinName:String, source:*):SimpleSkin
		{
			var texture:GTexture = GTextureManager.createTexture (SkinConfig.createGTextureId (skinName), source);
			return new SimpleSkin (skinName, texture);
		}
		
		/**
		 * Reference to the cell texture.
		 */
		public var gTexture:GTexture;
		
		/**
		 * Configurate a new SimpleSkin.
		 * @param	skinName  Name of the skin.
		 * @param	gTexture  Texture of the skin.
		 */
		public function SimpleSkin(skinName:String, gTexture:GTexture) 
		{
			super (skinName, SimpleSkinComponent);
			this.gTexture = (SkinConfig.fixRatioEnabled) ? super.fixTextureRatio (gTexture) : gTexture;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose(disposeSource:Boolean):void 
		{
			super.dispose (disposeSource);
			
			gTexture.dispose (disposeSource);
			
			gTexture = null;
		}
	}

}