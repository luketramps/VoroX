/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.animations
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import com.luketramps.vorox.core.components.Chart;
	import com.luketramps.vorox.utils.SitesRelaxation;
	import com.luketramps.vorox.Vorox;
	import com.luketramps.vorox.data.PointVX;
	/**
	 * Sample animation.
	 * Relaxes the grid (more smoothly).
	 * @author Lukas Damian Opacki
	 */
	public class RelaxSoftly
	{
		private var duration:Number;
		private var chart:Chart;
		private var intensityPeak:Number;
		private var relaxer:SitesRelaxation;
		
		public var currentIntensity:Number;
		
		public function RelaxSoftly(chartName:String, duration:Number, intensity:Number = .3) 
		{
			this.chart = Vorox.getInstance ().getChart (chartName);
			this.intensityPeak = intensity;
			this.duration = duration;
			this.relaxer = new SitesRelaxation (chartName);
		}
		
		/**
		 * Perform animation.
		 */
		public function animate():void 
		{
			currentIntensity = 0;
			
			Actuate.tween (this, duration/2, { currentIntensity:intensityPeak } )
			.onUpdate (relax)
			.ease (Linear.easeNone)
			.onComplete (onOverPeak);
		}
		
		private function onOverPeak():void
		{
			Actuate.tween (this, duration/2, { currentIntensity:0 } )
			.onUpdate (relax)
			.ease (Linear.easeNone)
		}
		
		private function relax():void
		{
			relaxer.relax (currentIntensity);
		}
		
		public function stop():void
		{
			Actuate.stop (this);
		}
		
		public function dispose():void
		{
			stop ();
			
			relaxer.dispose ();
			
			chart = null;
			
		}
		
	}
	
}
