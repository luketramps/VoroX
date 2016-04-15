/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.animations
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import com.luketramps.vorox.core.components.Chart;
	import com.luketramps.vorox.utils.SitesRelaxation;
	import com.luketramps.vorox.Vorox;
	import com.luketramps.vorox.data.PointVX;
	import flash.geom.Rectangle;
	/**
	 * Sample animation.
	 * Moves sites to random positions while relaxing the chart.
	 * @author Lukas Damian Opacki
	 */
	public class Swap 
	{
		private var chart:Chart;
		private var bounds:Rectangle;
		private var duration:Number;
		
		private var relaxer:SitesRelaxation;
		private var relaxFactor:Number;
		
		private var sourcePoint:PointVX;
		private var targetPoint:PointVX;
		
		public function Swap(chartName:String, duration:Number, relaxation:Number = .8) 
		{
			this.chart = Vorox.getInstance ().getChart (chartName);
			this.bounds = chart.bounds;
			this.duration = duration;
			this.relaxFactor = relaxation;
			this.relaxer = new SitesRelaxation (chartName);
			this.targetPoint = new PointVX ();
		}
		
		/**
		 * Perform animation.
		 */
		public function animate():void 
		{
			for (var i:int = 0; i < chart.numSites; i++) 
			{
				sourcePoint = chart.sites[i];
				targetPoint.x = Math.random() * bounds.width;
				targetPoint.y = Math.random() * bounds.height;
				
				Actuate.tween (sourcePoint, duration, { x:targetPoint.x, y:targetPoint.y } )
				.onUpdate (relax)
				.ease (Linear.easeNone);
			}
		}
		
		private function relax():void
		{
			relaxer.relax (relaxFactor);
		}
		
		public function dispose():void
		{
			relaxer.dispose ();
			
			this.chart = null;
			this.sitePoints = null;
		}
		
	}
	
}
