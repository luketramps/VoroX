/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.control 
{
	import ash.core.Engine;
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.data.NamedItems;
	import com.luketramps.vorox.skins.SkinComponent;
	import com.luketramps.vorox.skins.SkinConfig;
	import com.luketramps.vorox.skins.SkinManager;
	import com.luketramps.vorox.Vorox;
	import flash.utils.Dictionary;
	/**
	 * @author Lukas Damian Opacki
	 */
	public class Skinner 
	{
		
		[Inject(name = "skinConfigs")]	
		public var allSkins:NamedItems;
		
		[Inject(name = "grids")]		
		public var allGrids:NamedItems;
		
		[Inject]
		public var ash:Engine;
		
		[Inject]
		public var vorox:Vorox;
		
		public var managers:Dictionary;
		
		// Construct.
		public function Skinner() 
		{
			managers = new Dictionary (false);
		}
		
		// Adds a type and manager for a new kind of skin.
		public function setupSkinType(manager:SkinManager):void
		{
			vorox.injector.injectInto (manager);
			
			// Add the manager for the skin.
			if (managers [manager.SkinType] != null)
				throw new Error ("Can not register two SkinManagers for the same SkinType " + mgr.SkinType + ".");
			else managers [manager.SkinType] = manager;
		}
		
		// Create a skin defined by a SkinConfig object.
		public function createSkin(skinConfig:SkinConfig):void
		{
			var mgr = managers[skinConfig.SkinType];
			
			if (!mgr) 
				throw new Error ("SkinManager is undefined for " + skinConfig.SkinType + ".");
			
			mgr.onConfigAdd (skinConfig);
			
			allSkins.add (skinConfig.skinName, skinConfig, true);
		}
		
		// Dispose a skin for good.
		public function disposeSkin(skinName:String, disposeSource:Boolean):void
		{
			var config:SkinConfig = allSkins.remove (skinName);
			
			if (config)
			{
				managers[config.SkinType].onConfigRemove (config);
				config.dispose (disposeSource);
			}
		}
		
		// Applies a Skin to a cell. If a skin already exists on the cell entity, then it will be removed first.
		public function applySkin(skinName:String, cell:Cell, align:Class):void
		{
			var config:SkinConfig = allSkins.getItemByName (skinName, true);
			var mgr:SkinManager = managers[config.SkinType];
			var skin:SkinComponent = mgr.createSkin (config);
			
			skin.AlignType = align;
			skin.name = config.skinName;
			
			if (cell.entity.get (SkinComponent))
				removeCurrentSkin (cell);
			
			mgr.applySkin (cell.entity.add (skin, SkinComponent));
			
			cell.entity.get (Cell).skin = skin;
		}
		
		// Remove a cells currently applied skin, if there is one. Happens automaticly when applying a new skin.
		public function removeCurrentSkin(cell:Cell):void
		{
			var currentSkin:SkinComponent = cell.entity.get (SkinComponent);
			var mgr:SkinManager = managers[currentSkin.SkinType];
			
			mgr.removeSkin (cell.entity);
			mgr.disposeSkin (cell.entity.remove (SkinComponent));
		}
		
		// Checks if a skin exists.
		public function hasSkin(skinName:String):Boolean
		{
			return allSkins.containsName (skinName);
		}
		
		// Applies one skin to all cells of a grid. Former skins will be removed.
		public function applySkinToGrid(skinName:String, gridName:String, Align:Class):void
		{
			vorox.forEachCellOf (gridName, 
				function(cell:Cell):void
				{
					applySkin (skinName, cell, Align);
				});
		}
	}

}