#VoroX (alpha)

##Vornoi Animation Framework

Vorox is an extensible implementation of proceduraly generated (animated) voronoi diagramms in Actionscript 3 using Stage3D rendering. Vorox enables to animate and 'skin' cells inside voronoi grids at runtime. Vorox also provides further functionality for games and applications, like hittesting cells and stuff. 


##(Super) Quick guide

To get a quick start with VoroX download the zip to use the following example. Simply call <code>new SimpleApp(stage).start ()</code> in your document class.

```actionscript3
package examples 
{
	import com.luketramps.vorox.animations.Swap;
	import com.luketramps.vorox.ApplicationVX;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.skins.simple.SimpleSkin;
	import com.luketramps.vorox.Vorox;
	import flash.display.Stage;
	
	/* ApplicationVX is a shortcut to get vorox running */
	public class SimpleApp extends ApplicationVX
	{
		/* Assets for skinning */
		[Embed(source="../../my/skin.png")]
		public var MyBitmap:Class;
		
		/* Sample animation */
		private var swap:Swap;
		
		public function SimpleApp(stage:Stage) 
		{
			stage.frameRate = 60;
			
			/* Init vorox */
			super (stage);
		}
		
		/* Pre init code */
		override protected function setUp():void 
		{
		}
		
		/* Post init code */
		protected override function startUp():void
		{
			var vorox:Vorox = super.vx;
			
			/* Create some sites */
			vorox.createRandomSites ("mySites", 30, stage.stageWidth, stage.stageHeight);
			
			/* Create a grid from the sites */
			vorox.createGrid ("myGrid", "mySites", 8);
			
			/* Create a skin */
			vorox.addSkin (SimpleSkin.createFrom ("mySimpleSkin", MyBitmap));
			
			/* Apply the skin to all cells of the grid */
			vorox.applySkinOnGrid ("mySimpleSkin", "myGrid");	

			/* Animate sites on click */
			super.onTouch.add (
			function(p:PointVX):void
			{
				if (swap == null)
					swap = new Swap ("mySites", 3);
					
				/* Animate sites */
				swap.animate ();
			});
		}	
	}
}
```


##Basic info.

Differently skinned grids with the same set of sites and/or different sets of sites, each with multiple grids, are possible. Rendering can be turned on and off for grids or sites individualy. 


##Skinning cells.

Each cell of a grid can have a skin attached. Different skin types offer different behavior: A SimpleSkin applies a single texture on the cell, while SpriteSkin is for sprite animations and MaskedSkin is a renderable, that uses the cell polygon as mask. To add or remove skins, use the vorox api.


##How it works.

Vorox's render loop is realised via Ash (entity component framework) while graphics are rendered by Genome2D. At core of Vorox, nodename's Delauney code creates voronoi diagrams, which are translated to renderable Genome2D components by vorox on a per frame/tick basis. Dependenciy injection is handled by swiftsuspenders.


If you have any questions, drop a mail or visit luketramps.com. Don't forget to let me know about bugs, if you find any.


##Third party dependencies. 

- Genome2D, by (c) Peter Stefcek (MIT License)
- Delauney, by (c) Alan Shaw 
- Ash - by (c) Richard lord
- Swiftsuspenders, by (c) Till Schneidereit
- Actuate, by  (c)Joshua Granick


Zip download comes with all dependencies and examples.
