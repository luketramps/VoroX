/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.core.nodes 
{
	import ash.core.Node;
	import com.luketramps.vorox.core.components.Cell;
	import com.luketramps.vorox.skins.sprite.SpriteSkin;
	/**
	 * Used to lookup sprite skins via ash engine.
	 * @author Lukas Damian Opacki
	 */
	public class UpdateSpriteSkinsNode extends Node
	{
		public var skin:SpriteSkin;
		public var core:Cell;
	}

}