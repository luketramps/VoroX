/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.skins 
{
	import avmplus.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	/**
	 * SkinComponents represent a skin that is attached to a cell. 
	 * Creation and disposal of SkinComponents are handled via vorox.
	 * To remove a skin from a cell, call <code>vorox.removeSkin(...)</code>.
	 * @author Lukas Damian Opacki
	 */
	public class SkinComponent 
	{
		
		/**
		 * Name of skin.
		 */
		public var name:String;
		
		/**
		 * Skin alingment. Can be changed at runtime.
		 */
		public var AlignType:Class;
		
		
		private var _SkinType:Class;
		
		/**
		 * Private constructor, used by SkinManagers.
		 * @param	name	  Name of skin.
		 * @param	SkinType  Type if skin for mapping a <code>SkinManager</code>.
		 */
		public function SkinComponent(name:String, SkinType:Class = null) 
		{
			if (!SkinType)
				SkinType = getDefinitionByName (getQualifiedClassName (this))
			
			this._SkinType = SkinType;
			this.name = name;
		}
		
		/**
		 * Type of skin.
		 */
		public function get SkinType():Class 
		{
			return _SkinType;
		}
		
	}

}