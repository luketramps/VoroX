/*
 *  	VoroX - Voronoi Animation Framework
 *  	http://www.luketramps.com/vorox
 *  	Copyright 2016 Lukas Damian Opacki. All rights reserved.
 *  	MIT License https://github.com/luketramps/VoroX/blob/master/LICENSE
 */
package com.luketramps.vorox 
{
	import ash.core.Engine;
	import ash.integration.swiftsuspenders.SwiftSuspendersEngine;
	import ash.signals.Signal0;
	import ash.signals.Signal1;
	import ash.tick.FrameTickProvider;
	import com.genome2d.Genome2D;
	import com.genome2d.node.GNode;
	import com.luketramps.vorox.data.PointVX;
	import com.luketramps.vorox.utils.MouseInput;
	import com.luketramps.vorox.Vorox;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import org.swiftsuspenders.dependencyproviders.InjectorUsingProvider;
	import org.swiftsuspenders.Injector;
	/**
	 * ApplicationVX is a shortcut to get VoroX configured and running. 
	 * Look at this class source code, to see how to initialise vorox .
	 * @author Lukas Damian Opacki
	 */
	public class ApplicationVX
	{
		[Inject] public var genome:Genome2D;	// Gpu accelerated 2d framework.
		[Inject] public var ash:Engine;			// Entity component framework.
		[Inject] public var vorox:Vorox;		// Vorox api.
		
		[Inject (name = "root")]
		public var rootNode:GNode; 				// Genome2D display root.
		public var stage:Stage					// Native stage.
		
		public var injector:Injector;			// Swift suspenders, injection framework.
		public var onTouch:Signal1;				// Signal fired by a (optional) input manager.
		public var onInitialised:Signal0;		// Signal fired when vorox.init() completed.
		
		public var config:ConfigVX;				// Vorox configuration.
		
		// Construct.
		public function ApplicationVX(stage:Stage) 
		{
			// Create a configuration.
			this.config = new ConfigVX (stage);
			this.stage = stage;
			
			// Setup configuration.
			// config.genome2DConfig.enableDepthAndStencil = true; // Requiered for MaskSkin.
			config.genome2DConfig.antiAliasing = 4;
			config.injectIntoAfterInit (this);
			config.onInititialised.addOnce (onVoroxReady);
			
			// Get the injector.
			injector = config.injector;
			
			// Provide "ready" signal.
			onInitialised = config.onInititialised;
		}
		
		// Start Vorox.
		public function start():void
		{
			setUp ();
			Vorox.init (config);
		}
		
		// Post vorox init.
		protected function onVoroxReady():void
		{
			startInputManagement ();
			startUp ();
		}
		
		// Add a simple/costum system to notify user input.
		protected function startInputManagement():void
		{
			onTouch = new Signal1 (PointVX);				// signal that gets dispatched when click event happens
			var input:MouseInput = new MouseInput ();		// system that fires the click signal
			
			// Add injection mappings.
			vorox.injector.map (Signal1, "touch").toValue (onTouch);	
			vorox.injector.map (MouseInput).toValue (input);
			
			// Wire up signal and system.
			vorox.injector.injectInto (input);
		}
		
		// Override for pre init setup.
		protected function setUp():void 
		{
		}
		
		// Override for post init setup.
		protected function startUp():void 
		{
		}
	}

}