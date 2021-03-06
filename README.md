#VoroX (alpha)

##Voronoi Animation Framework

Vorox is an extensible implementation of continuously generated (animatable) voronoi diagramms in Actionscript 3 using Stage3D for display rendering. Vorox enables to move and 'skin' cells inside voronoi grids at runtime. Vorox also provides further functionality for the creation of generic art, games and UI. 

##Official Manual

If you want a more detailed manual on how to use VoroX, you'll find it here

[VoroX Manual](http://www.luketramps.com/lt/index.php/vorox/vorox-manual).

##Quick Start

To get a quick start with VoroX download the zip to use the following example. Link all the swc libraries to your project and call <code>new GitExample(stage).start ()</code> in your document class.

```actionscript3
package examples.official
{
    import com.luketramps.vorox.animations.Swap;
    import com.luketramps.vorox.ApplicationVX;
    import com.luketramps.vorox.data.PointVX;
    import com.luketramps.vorox.skins.simple.SimpleSkin;
    import com.luketramps.vorox.Vorox;
    import flash.display.Stage;

    /* Extending ApplicationVX is a quick way to start Vorox */
    public class GitExample extends ApplicationVX
    {
        /* Assets for skinning */
        [Embed(source="../../my/skin.png")]
        public var MyBitmap:Class;

        /* Sample animation */
        private var swap:Swap;

        public function GitExample(stage:Stage) 
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
            /* Create a chart */
            vorox.createRandomChart ("myChart", 30, stage.stageWidth, stage.stageHeight);

            /* Create a grid from the chart */
            vorox.createGrid ("myGrid", "myChart", 8);

            /* Create a skin */
            vorox.addSkin (SimpleSkin.createFrom ("mySimpleSkin", MyBitmap));

            /* Apply the skin to all cells of the grid */
            vorox.applySkinOnGrid ("mySimpleSkin", "myGrid");   

            /* Animate sites on click */
            super.onTouch.add (
            function(p:PointVX):void
            {
                if (swap == null)
                    swap = new Swap ("myChart", 3);
	
                /* Animate sites */
                swap.animate ();
            });
        }   
    }
}
```


##Basic info.

A Chart object is mostly a collection of points (sites), that define a Voronoi diagramm. Grids come as a collection of cells, representing the voronoi diagramm. A cell displays a region in the voronoi chart, that is constantly beeing updated (rendered to display) via Genome2D framework. Rendering can be turned on and off for grids or charts individualy. However, charts, grids and cells are entities in an entity component system. It would be best to know the basics of entity component systems, to get started with Vorox. Add and dispose charts and grids, use the Vorox api.


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
