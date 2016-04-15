/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.animations
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.*;
	import com.luketramps.vorox.core.components.Chart;
	import com.luketramps.vorox.Vorox;
	import com.luketramps.vorox.data.PointVX;
	import flash.geom.Rectangle;
	
	/**
	 * Sample animation.
	 * Move sites to random positions.
	 * @author Lukas Damian Opacki
	 */
	public class Scatter
	{
		private var chart:Chart;
		private var bounds:Rectangle;
		private var duration:Number;
		private var intensity:Number;
		private var ease:IEasing;
		
		private var targetPoint:PointVX;
		
		public function Scatter(chartName:String, duration:Number) 
		{
			this.chart = Vorox.getInstance ().getChart (chartName);
			this.bounds = chart.bounds;
			this.duration = duration;
			this.targetPoint = new PointVX ();
		}
		
		/**
		 * Perform animation.
		 */
		public function animate():void 
		{
			for (var i:int = 0; i < chart.numSites; i++) 
			{
				targetPoint.x = Math.random() * bounds.width;
				targetPoint.y = Math.random() * bounds.height;
				
				Actuate.tween (chart.sites[i], duration, { x:targetPoint.x, y:targetPoint.y } )
				.ease (Linear.easeNone);
			}
		}
		
		public function stop():void
		{
			for (var i:int = 0; i < chart.numSites; i++) 
			{
				Actuate.stop (chart.sites[i]);
			}
		}
		
		public function dispose():void
		{
			this.bounds = null;
			this.chart = null;
		}
		
	}
	
}
