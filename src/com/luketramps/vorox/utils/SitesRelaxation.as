/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox.utils 
{
	import com.luketramps.vorox.core.components.Chart;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.Vorox;
	/**
	 * Relaxes sites (maniupulation/animation of a chart). 
	 * Sites relaxation is accomplished by moving each site into direction of its cells center. 
	 * This creates an effect of relaxing or melting a grid, by making it's cells more homogeneous.
	 * @author Lukas Damian Opacki
	 */
	public class SitesRelaxation 
	{
		private var chart:Chart;
		private var numSites:uint;
		private var tempPoint:PointVX;
		
		/**
		 * Creates a new SitesRelaxation, which can be used to animate grids.
		 * @param	siteName  Name of the chart.
		 */
		public function SitesRelaxation(chartName:String) 
		{
			chart = Vorox.getInstance ().getChart (chartName, true);
			tempPoint = new PointVX ();
		}
		
		/**
		 * Relax the grid with an intensity between 1 and 0.
		 * @param	intensity of the applied relaxation.
		 */
		public function relax(relaxStrength:Number = .1):void
		{
			numSites = chart.numSites;
			for (var i:int = 0; i < numSites; i++) 
			{
				tempPoint = chart.getCenterOf (i);
				
				PointVX.interpolate2 (tempPoint, chart.sites[i], relaxStrength, tempPoint);
				
				chart.sites[i].x = tempPoint.x;
				chart.sites[i].y = tempPoint.y;
			}
		}
		
		/**
		 * Dispose this object.
		 */
		public function dispose():void
		{
			numSites = 0;
			chart = null;
			tempPoint = null;
		}
	}

}