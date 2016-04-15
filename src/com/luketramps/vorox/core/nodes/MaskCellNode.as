/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.nodes 
{
	import ash.core.Node;
	import com.luketramps.vorox.skins.masked.MaskedSkin;
	import com.luketramps.vorox.skins.masked.MaskedSkinComponent;
	import com.luketramps.vorox.skins.SkinComponent;
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.core.components.MaskFlag;
	import com.luketramps.vorox.components.StickySkin;
	/**
	 * Used to lookup masked cells via ash engine.
	 * @author Lukas Damian Opacki
	 */
	public class MaskCellNode extends Node
	{
		public var maskFlag:MaskFlag;
		public var skin:SkinComponent;
		public var core:Cell;
	}

}