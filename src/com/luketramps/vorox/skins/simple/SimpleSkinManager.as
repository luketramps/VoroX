/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins.simple 
{
	import ash.core.Entity;
	import ash.tools.ComponentPool;
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.skins.simple.SimpleSkin;
	import com.luketramps.vorox.skins.simple.SimpleSkinComponent;
	import com.luketramps.vorox.skins.SkinComponent;
	import com.luketramps.vorox.skins.SkinConfig;
	import com.luketramps.vorox.skins.SkinManager;
	/**
	 * @inheritDoc
	 * @author Lukas Damian Opacki
	 */
	public class SimpleSkinManager extends SkinManager
	{
		public function SimpleSkinManager() 
		{
			super (SimpleSkinComponent);
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
			var skinCompo:SimpleSkinComponent = ComponentPool.get (SimpleSkinComponent);
			
			skinCompo.gTexture = SimpleSkin (config).gTexture;
			
			return skinCompo;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function disposeSkin(component:SkinComponent):void
		{
			super.disposeSkin (component);
			
			var skinCompo:SimpleSkinComponent = component;
			
			skinCompo.gTexture = null;
			
			ComponentPool.dispose (skinCompo);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function applySkin(cell:Entity):void 
		{
			var skinCompo:SimpleSkinComponent = cell.get (SkinComponent);
			var core:Cell = cell.get (Cell);
			core.gShape.texture = skinCompo.gTexture;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeSkin(cell:Entity):void
		{
			var core:Cell = cell.get (Cell);
			core.gShape.texture = null;
		}
		
	}

}