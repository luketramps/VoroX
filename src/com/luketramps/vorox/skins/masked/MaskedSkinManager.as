/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins.masked 
{
	import ash.core.Engine;
	import ash.core.Entity;
	import ash.core.NodeList;
	import ash.tools.ComponentPool;
	import com.genome2d.components.GComponent;
	import com.genome2d.node.GNode;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureManager;
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.core.components.Grid;
	import com.luketramps.vorox.core.components.MaskFlag;
	import com.luketramps.vorox.core.nodes.MaskCellNode;
	import com.luketramps.vorox.core.systems.CellMaskingSys;
	import com.luketramps.vorox.skins.masked.MaskedSkinComponent;
	import com.luketramps.vorox.skins.SkinComponent;
	import com.luketramps.vorox.skins.SkinConfig;
	import com.luketramps.vorox.skins.SkinManager;
	import flash.display.BitmapData;
	/**
	 * Manager for creating, applying and disposing <code>MaskedSkinComponent</code>.
	 * 
	 * @inheritDoc 
	 * 
	 * @author Lukas Damian Opacki
	 */
	public class MaskedSkinManager extends SkinManager
	{
		private static var maskingSystem:CellMaskingSys;
		private static var maskingTexture:GTexture;
		private static var maskingNodes:NodeList;
		
		[Inject]
		public var ash:Engine;
		
		/**
		 * Creates a new MaskedSkinManager.
		 */
		public function MaskedSkinManager() 
		{
			super (MaskedSkinComponent);
		}
		
		/**
		 * @inheritDoc
		 */
		[PostConstruct]
		public function setup():void
		{
			if (!maskingTexture)
			{
				maskingTexture = GTextureManager.createTexture ("voroxMask", new BitmapData (32, 32, false, 0x00ff00));
				maskingSystem = new CellMaskingSys ();
				maskingNodes = ash.getNodeList (MaskCellNode);
				
				maskingNodes.nodeAdded.add (onMaskAdded);
				maskingNodes.nodeAdded.add (onMaskRemoved);
			}
		}
		
		// Remove masking systems, when last masking node removed.
		private function onMaskRemoved(node:MaskCellNode):void 
		{
			if (maskingNodes.empty)
				ash.removeSystem (maskingSystem);
		}
		
		// Add masking system, when first masking node added.
		private function onMaskAdded(node:MaskCellNode):void 
		{
			if (maskingNodes.head == node)
				ash.addSystem (maskingSystem, CellMaskingSys.systemPriority);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onConfigAdd(config:SkinConfig):void 
		{
			var T:Class = MaskedSkin (config).Canvas;
			var gCompo:* = new T();
			
			if (gCompo as GComponent == null)
				throw new Error ("'" + MaskedSkin (config).Canvas + "' used by 'MaskedSkin.Canvas' needs to be a subclass of '"+GComponent+"'.");
				
			gCompo.dispose ();
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
			var skinCompo:MaskedSkinComponent = ComponentPool.get (MaskedSkinComponent);
			
			skinCompo.canvas = GNode.createWithComponent (MaskedSkin(config).Canvas);
			//skinCompo.align = SkinAlignment.NONE;
			
			return skinCompo;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function disposeSkin(component:SkinComponent):void
		{
			super.disposeSkin (component);
			
			var skinCompo:MaskedSkinComponent = component;
			
			skinCompo.canvas = null;
			
			ComponentPool.dispose (skinCompo);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function applySkin(cellEntity:Entity):void 
		{
			var skinCompo:MaskedSkinComponent = cell.get (SkinComponent);
			var cell:Cell = cellEntity.get (Cell);
			var grid:Grid = cell.grid;
			
			// Apply dummy texture.
			cell.gShape.texture = maskingTexture;
			
			// Use shape as mask.
			skinCompo.canvas.node.mask = cell.gShape.node;
			
			// Display canvas.
			grid.gNode.removeChild (cell.gShape.node);
			grid.gNode.addChild (skinCompo.canvas.node);
			grid.gNode.addChild (cell.gShape.node);
			
			// Add mask flag.
			cell.add (ComponentPool.get (MaskFlag));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeSkin(cellEntity:Entity):void
		{
			var skinCompo:MaskedSkinComponent = cell.get (SkinComponent);
			var cell:Cell = cellEntity.get (Cell);
			var grid:Grid = cell.grid;
			
			// Remove dummy textures.
			cell.gShape.texture = null;
			
			// Fix masking bug.
			cell.gShape.node.g2d_usedAsMask = 0;
			
			// Remove canvas from display list.
			grid.gNode.removeChild (skinCompo.canvas.node);
			
			// Dispose canvas.
			skinCompo.canvas.node.dispose ();
			skinCompo.canvas.dispose ();
			
			// Remove mask flag.
			ComponentPool.dispose (cell.remove (MaskFlag));
		}
	}

}