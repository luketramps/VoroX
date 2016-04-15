/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins.sprite 
{
	import ash.core.Entity;
	import ash.tools.ComponentPool;
	import com.genome2d.animation.GFrameAnimation;
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.skins.SkinComponent;
	import com.luketramps.vorox.skins.SkinConfig;
	import com.luketramps.vorox.skins.SkinManager;
	import com.luketramps.vorox.skins.sprite.SpriteSkin;
	import com.luketramps.vorox.skins.sprite.SpriteSkinComponent;
	/**
	 * @inheritDoc
	 * @author Lukas Damian Opacki
	 */
	public class SpriteSkinManager extends SkinManager
	{
		
		public function SpriteSkinManager() 
		{
			super (SpriteSkinComponent);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onConfigAdd(config:SkinConfig):void 
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onConfigRemove(config:SkinConfig):void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override public function createSkin(config:SkinConfig):SkinComponent
		{
			var skinCompo:SpriteSkinComponent = ComponentPool.get (SpriteSkinComponent);
			
			skinCompo.frameAnimation = new GFrameAnimation (SpriteSkin (config).frameTextures);
			skinCompo.frameAnimation.frameRate = SpriteSkin (config).frameRate;
			
			return skinCompo;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function disposeSkin(component:SkinComponent):void
		{
			var skinCompo:SpriteSkinComponent = component;
			
			skinCompo.frameAnimation = null;
			
			ComponentPool.dispose (skinCompo);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function applySkin(cell:Entity):void 
		{
			var skinCompo:SpriteSkinComponent = cell.get (SkinComponent);
			var core:Cell = cell.get (Cell);
			core.gShape.frameAnimation = skinCompo.frameAnimation;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeSkin(cell:Entity):void
		{
			var core:Cell = cell.get (Cell);
			core.gShape.texture = null;
			core.gShape.frameAnimation = null;
		}
		
	}

}