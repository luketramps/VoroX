/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins.sprite 
{
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureManager;
	import com.luketramps.vorox.skins.SkinConfig;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * <p>Skin component for (sprite style) animated cells.</p>
	 * @inheritDoc
	 * @author Lukas Damian Opacki
	 */
	public class SpriteSkin extends SkinConfig 
	{
		/**
		 * Create the skin configuration from an embeded texture atlas image.
		 * @param	skinName   Name of the skin.
		 * @param	atlas	   Texture atlas as embeded class.
		 * @param	regions	   Regions of textures (the animations frames).
		 * @param	frameRate  Sprite animation frame rate.
		 * @return  New SpriteSkin.
		 */
		public static function createFromEmbeded(skinName:String, atlas:Class, regions:Class, frameRate:uint):SpriteSkin
		{
			var gAtlas:GTexture = GTextureManager.createTexture (SkinConfig.createGTextureId (skinName), atlas);
			var gFrames:Array = GTextureManager.createSubTextures (gAtlas, Xml.parse (new XML (new regions)));
			return new SpriteSkin (skinName, gFrames, frameRate);
		}
		
		/**
		 * Create the skin configuration from an texutre atlas bitmap data.
		 * @param	skinName   Name of the skin.
		 * @param	atlas	   Texture atlas as bitmapdata.
		 * @param	regions	   Regions of textures (the animations frames).
		 * @param	frameRate  Sprite animation frame rate.
		 * @return  New SpriteSkin.
		 */
		public static function createFromBitmapAtlas(skinName:String, atlas:BitmapData, regions:XML, frameRate:uint):SpriteSkin
		{
			var gAtlas:GTexture = GTextureManager.createTexture (SkinConfig.createGTextureId (skinName));
			var gFrames:Array = GTextureManager.createSubTextures (gAtlas, Xml.parse (regions));
			return new SpriteSkin (skinName, gFrames, frameRate);
		}
		
		/**
		 * Create the skin confuguration from a bunch of bitmapdata frames.
		 * @param	skinName   Name of the skin.
		 * @param	frames	   Animation frames as bitmapdata.
		 * @param	frameRate  Sprite animation frame rate.
		 * @return
		 */
		public static function createFromBitmapFrames(skinName:String, frames:Vector.<BitmapData>, frameRate:uint):SpriteSkin
		{
			var gFrames:Array = [];
			for (var i:int = 0; i < frames.length; i++) 
			{
				gFrames.push (GTextureManager.createTexture (SkinConfig.createGTextureId (skinName, "_" + String (i)), frames[i]));
			}
			return new SpriteSkin (skinName, gFrames, frameRate);
		}
		
		/**
		 * Frames of the animation.
		 */
		public var frameTextures:Array;
		
		/**
		 * Frame rate of the animation.
		 */
		public var frameRate:uint;
		
		/**
		 * Create a new Sprite skin configuration.
		 * @param	skinName	  Name of the skin
		 * @param	frameTextures Frames of the animation in the right order as Gtextures.
		 * @param	frameRate	  Frame rate of the animation.
		 */
		public function SpriteSkin(skinName:String, frameTextures:Array, frameRate:uint) 
		{
			super (skinName, SpriteSkinComponent);
			this.frameTextures = fixEachFrameRatio (frameTextures);
			this.frameRate = frameRate;
		}
		
		private function fixEachFrameRatio(frames:Array):Array
		{
			if (SkinConfig.fixRatioEnabled)
				for (var i:int = 0; i < frames.length; i++) 
					frames[i] = super.fixTextureRatio (frames[i]);
			return frames;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose(disposeSource:Boolean):void 
		{
			for (var i:int = 0; i < frameTextures.length; i++) 
				frameTextures[i].dispose (disposeSource);
			
			frameTextures = null;
				
			super.dispose(disposeSource);
		}
		
	}

}