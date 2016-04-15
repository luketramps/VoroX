/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins 
{
	import ash.core.System;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureManager;
	import com.luketramps.vorox.Vorox;
	import flash.geom.Rectangle;
	/**
	 * A skin config is used to create a skin.
	 * Skin config is a model for skin components.
	 * @author Lukas Damian Opacki
	 */
	public class SkinConfig 
	{
		public static var fixRatioEnabled:Boolean;
		
		/**
		 * Name of the skin.
		 */
		public var skinName:String;
		
		/**
		 * Type of the skin.
		 */
		public var SkinType:Class;
		
		public function SkinConfig(skinName:String, skinType:Class) 
		{
			this.skinName = skinName;
			this.SkinType = skinType;
		}
		
		/**
		 * Dispose this skin configuration.
		 * @param	disposeSource  If true, gpu memory for textures gets freed as well.
		 */
		public function dispose(disposeSource:Boolean):void
		{
			this.SkinType = null;
			this.skinName = null;
		}
		
		/**
		 * GTexture ID generator.
		 * @param	skinName
		 * @param	suffix
		 * @return
		 */
		public static function createGTextureId(skinName:String, suffix:String = ""):String
		{
			var id:String = "GTex_" + skinName;
			
			if (suffix != "")
				id +=  "_" + suffix;
			
			return  id;
		}
		
		/**
		 * Returnes a new texture if <code>configVX.fixNonQuadraticTextures</code> is <code>true</code>. The new texture is quadratic.
		 * @param	tex  Texture that will be cropped.
		 * @return  New texture.
		 */
		protected function fixTextureRatio(tex:GTexture):GTexture
		{
			if (fixRatioEnabled && tex.width != tex.height)
			{
				var rect:Rectangle;
				
				if (tex.width > tex.height)
				{
					rect = new Rectangle (tex.region.x + (tex.width - tex.height) / 2, tex.region.y, tex.height, tex.height);
				}
				else 
				{
					rect = new Rectangle (tex.region.x, tex.region.y + (tex.height - tex.width) / 2, tex.width, tex.width);
				}
				
				return GTextureManager.createSubTexture (tex.id + "_RatioVX", tex, rect, tex.g2d_region, false);
			}
			
			return tex;
		}
	}

}