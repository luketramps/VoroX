package com.luketramps.vorox.utils 
{
	import com.genome2d.node.GNode;
	import flash.geom.Rectangle;
	/**
	 * @author Lukas Damian Opacki
	 */
	public class ZoomOverGridBorders
	{
		private var gridNode:GNode;
		private var shrink:Number;
		private var bounds:Rectangle;
		
		public function ZoomOverGridBorders(gridNode:GNode, shrinkOutline:Number, bounds:Rectangle) 
		{
			this.gridNode = gridNode;
			this.shrink = shrinkOutline;
			this.bounds = bounds;
			
			execute ();
			kill ();
		}
		
		protected function execute():void 
		{
			var scaleX:Number = (bounds.width + shrink) / bounds.width;
			var scaleY:Number = (bounds.height + shrink) / bounds.height;
			
			// Fix not precise bounds.
			scaleX *= 1.01;
			scaleY *= 1.01;
			
			gridNode.userData = { };
			gridNode.userData[scaleX] = scaleX;
			gridNode.userData[scaleY] = scaleY;
			
			gridNode.scaleX = scaleX;
			gridNode.scaleY = scaleY;
			
			gridNode.x -= bounds.width *(scaleX-1) /2;
			gridNode.y -= bounds.height *(scaleY-1) /2;
		}
		
		protected function kill():void 
		{
			this.gridNode = null;
			this.bounds = null;
		}
		
	}

}