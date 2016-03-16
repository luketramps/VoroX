#VoroX (alpha)

##Voronoi Animation Framework

Vorox is an extensible implementation of continuously generated (animatable) voronoi diagramms in Actionscript 3 using Stage3D for display rendering. Vorox enables to move and 'skin' cells inside voronoi grids at runtime. Vorox also provides further functionality for games and applications, like hittesting cells and stuff. 

##Official Manual

If you want a more detailed manual on how to use VoroX, you'll find it [here](http://www.luketramps.com/lt/index.php/vorox/vorox-manual).

To see VoroX in action, follow this [link](http://www.luketramps.com/lt/index.php/vorox) (requires Flash Player).

##Quick Start

To get a quick start with VoroX download the zip to use the following example. Link all the swc libraries to your project and call <code>new SimpleApp(stage).start ()</code> in your document class.

```actionscript3
package  
{
	import com.luketramps.vorox.animations.Swap;
	import com.luketramps.vorox.ApplicationVX;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.skins.simple.SimpleSkin;
	import com.luketramps.vorox.Vorox;
	import flash.display.Stage;
	
	/* Extending ApplicationVX is a quick way to start Vorox */
	public class SimpleApp extends ApplicationVX
	{
		/* Assets for skinning */
		[Embed(source="../my/skin.png")]
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

Sites are collections of points, while grids are voronoi diagramms rendered from sites. Grids come as a collection of cells, representing the voronoi diagramm. Each cell is represented in the display list. Differently skinned grids with the same set of sites and/or different sets of sites, each with multiple grids, are possible. Rendering can be turned on and off for grids or sites individualy. However, grids, sites and cells are entities in an entity component system. It would be best to know the basics of entity component systems, to get started with Vorox. Add and dispose sites and grids, use the Vorox api.


##Skinning cells.

Each cell of a grid can have a skin attached. Different skin types offer different behavior: A SimpleSkin applies a single texture on the cell, while SpriteSkin is for sprite animations and MaskedSkin is a renderable, that is masked by the cell polygon. To add, apply, remove and dispose skins, use the Vorox api. 


##How it works.

Vorox's render loop is realised via Ash (entity component framework) while graphics are rendered by Genome2D. At core of Vorox, nodename's Delauney code creates voronoi diagrams, which are translated to renderable Genome2D components by Vorox on a per frame/tick basis. Dependency injection is handled by swiftsuspenders.


If you have any questions, drop a mail or visit luketramps.com. Don't forget to let me know about bugs, if you find any.


##Third party dependencies. 

- Genome2D, by (c) Peter Stefcek (MIT License)
- Delauney, by (c) Alan Shaw (MIT License)
- Ash - by (c) Richard lord (MIT License)
- Swiftsuspenders, by (c) Till Schneidereit (MIT License)
- Actuate, by (c) Joshua Granick (MIT License)


Zip download comes with all dependencies and examples.
