/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.systems 
{
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderable.GSprite;
	import com.genome2d.components.renderable.IGRenderable;
	import com.genome2d.textures.GTexture;
	import com.luketramps.vorox.skins.masked.MaskedSkin;
	import com.luketramps.vorox.skins.masked.MaskedSkinComponent;
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.core.nodes.UpdateSpriteSkinsNode;
	import com.luketramps.vorox.core.nodes.MaskCellNode;
	
	/**
	 * Internaly added and removed system that updates the masked canvas of mask skins.
	 * @author Lukas Damian Opacki
	 */
	public class CellMaskingSys extends System
	{
		public static var systemPriority:uint;
		
		public var ash:Engine;
		
		private var spriteSkins:NodeList;
		private var maskedCells:NodeList;
		private var currentCenter:PointVX;
		private var scaleX:Number;
		private var scaleY:Number;
		
		public override function addToEngine(ash:Engine):void 
		{
			if (maskedCells == null)
				maskedCells = ash.getNodeList (MaskCellNode);
		}
		
		public override function update(t:Number):void
		{
			var cell:Cell;
			for (var node:MaskCellNode = maskedCells.head; node; node = node.next)
				updateCanvasPosition (node.core, MaskedSkinComponent (node.skin).canvas);
		}
		
		// Map canvas position to cell center.
		[Inline]
		final private function updateCanvasPosition(cell:Cell, canvas:GComponent):void //node:UpdateAnimatedTextureNode):void 
		{
			canvas.node.setPosition (cell.boundsCenterX, cell.boundsCenterY);
		}
		
	}

}