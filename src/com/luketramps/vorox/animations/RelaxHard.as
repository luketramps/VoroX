/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.animations
{
	import ash.signals.Signal1;
	import com.eclecticdesignstudio.motion.Actuate;
	import com.luketramps.vorox.core.components.Chart;
	import com.luketramps.vorox.utils.SitesRelaxation;
	import com.luketramps.vorox.Vorox;
	import com.luketramps.vorox.data.PointVX;
	import flash.display.Stage;
	/**
	 * Sample animation.
	 * Quickly relaxes the grid.
	 * @author Lukas Damian Opacki
	 */
	public class RelaxHard
	{
		private var chart:Chart;
		private var intensity:Number;
		private var duration:Number;
		private var relaxer:SitesRelaxation;
		
		public function RelaxHard(chartName:String, duration:Number, intensityPeak:Number = .3) 
		{
			this.chart = Vorox.getInstance ().getChart (chartName);
			this.intensity = intensityPeak;
			this.duration = duration;
			this.relaxer = new SitesRelaxation (chartName);
		}
		
		/**
		 * Perform animation.
		 */
		public function animate():void 
		{
			Actuate.timer (duration).onUpdate (relaxer.relax, intensity);
		}
		
		public function dispose():void
		{
			stop ();
			
			relaxer.dispose ();
			
			chart = null;
			vx = null;
		}
	}
	
}
