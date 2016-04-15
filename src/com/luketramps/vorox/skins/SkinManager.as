/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins 
{
	import ash.core.Entity;
	import ash.core.System;
	import com.luketramps.vorox.skins.SkinComponent;
	/**
	 * A <code>SkinManager</code> handles specific operations related to <code>SkinComponent</code> and <code>SkinConfig</code> objects. 
	 * 
	 * A cells skin in Vorox is a (entity-) component, that inherites from SkinComponent and relates to a user specified SkinConfig object.
	 * 
	 * @author Lukas Damian Opacki
	 */
	public class SkinManager 
	{
		private var _SkinType:Class;
		
		public function SkinManager(SkinType:Class) 
		{
			this._SkinType = SkinType;
		}
		
		public final function get SkinType():Class
		{
			return _SkinType;
		}
		
		/*
		 * Called when a new <code>SkinConfig</code> object was added. 
		 */
		public function onConfigAdd(skinConfig:SkinConfig):void
		{
		}
		
		/*
		 * Called when a new <code>SkinConfig</code> object was removed. 
		 */
		public function onConfigRemove(skinConfig:SkinConfig):void
		{
		}
		
		/*
		 * Called when a new <code>SkinComponent</code> must be initialised. 
		 */
		public function createSkin(skinConfig:SkinConfig):SkinComponent
		{
			return null;
		}
		
		/*
		 * Called when a <code>SkinComponent</code> needs to be garbage collected.
		 */
		public function disposeSkin(skin:SkinComponent):void
		{
		}
		
		/*
		 * Called when a cells dependencies to its <code>SkinComponent</code> must be removed.
		 */
		public function removeSkin(cell:Entity):void
		{
		}
		
		/*
		 * Called when a cell needs to display a <code>SkinComponent</code>.
		 */
		public function applySkin(cell:Entity):void
		{
		}
		
	}

}