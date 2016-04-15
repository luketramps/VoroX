package com.luketramps.vorox.utils 
{
	import com.genome2d.node.GNode;
	
	/**
	 * @author Lukas Damian Opacki
	 */
	public class ZoomOutOfGridBorders 
	{
		
		public function ZoomOutOfGridBorders(gNode:GNode) 
		{
			gNode.setScale (1, 1);
			gNode.setPosition (0, 0);
			
			if (gNode.userData)
			{
				gNode.userData.scaleX = 1;
				gNode.userData.scaleY = 1;
			}
		}
		
	}

}