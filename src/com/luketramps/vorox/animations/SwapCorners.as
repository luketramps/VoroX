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
	 * Moves the sites at the grid corners into the middle of the screen while relaxing the grid.
	 * @author Lukas Damian Opacki
	 */
	public class SwapCorners 
	{
		private var sitePoints:Vector.<PointVX>;
		private var bounds:Rectangle;
		private var duration:Number;
		
		private var relaxer:SitesRelaxation;
		public var relaxFactor:Number;
		
		private var cornerSites:Vector.<uint>;
		private var cornerTargets:Vector.<PointVX>;
		
		public function SwapCorners(chartName:String, duration:Number) 
		{
			var chart:Chart = Vorox.getInstance ().getChart (chartName);
			
			this.sitePoints = chart.sites;
			this.bounds = chart.bounds;
			this.duration = duration;
			this.relaxer = new SitesRelaxation (chartName);
		}
		
		/**
		 * Perform animation.
		 */
		public function animate():void 
		{
			relaxFactor = .4;
			
			cornerSites = new Vector.<uint> ();
			cornerSites.push (sitePoints.indexOf (sitePoints.getSiteAt (1, 1)));
			cornerSites.push (sitePoints.indexOf (sitePoints.getSiteAt (bounds.width-1, 1)));
			cornerSites.push (sitePoints.indexOf (sitePoints.getSiteAt (bounds.width-1, bounds.height-1)));
			cornerSites.push (sitePoints.indexOf (sitePoints.getSiteAt (1, bounds.height-1)));
			
			cornerTargets = new Vector.<PointVX> ();
			for (var j:int = 0; j < 4; j++) 
				cornerTargets.push (new PointVX ());
			
			PointVX.interpolate2 (sitePoints [cornerSites[0]], sitePoints [cornerSites[2]], .6, cornerTargets[0]);
			PointVX.interpolate2 (sitePoints [cornerSites[1]], sitePoints [cornerSites[3]], .6, cornerTargets[1]);
			PointVX.interpolate2 (sitePoints [cornerSites[2]], sitePoints [cornerSites[0]], .6, cornerTargets[2]);
			PointVX.interpolate2 (sitePoints [cornerSites[3]], sitePoints [cornerSites[1]], .6, cornerTargets[3]);
			
			for (var i:int = 0; i < 4; i++) 
			{
				Actuate.tween (sitePoints[cornerSites[i]], duration*.6, { x:cornerTargets[i].x, y:cornerTargets[i].y } )
				.ease (Linear.easeNone);
			}
			
			Actuate.timer (duration + .01)
			.onUpdate (relax);
		}
		
		private function relax():void
		{
			relaxer.relax (relaxFactor);
		}
		
		public function dispose():void
		{
			relaxer.dispose ();
			sitePoints = null;
			bounds = null;
		}
		
	}
	
}
