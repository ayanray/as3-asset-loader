/*
*	Copyright (c) 2007-2009 Ayan Ray | http://www.ayanray.com
*
*	Permission is hereby granted, free of charge, to any person obtaining a copy
*	of this software and associated documentation files (the "Software"), to deal
*	in the Software without restriction, including without limitation the rights
*	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*	copies of the Software, and to permit persons to whom the Software is
*	furnished to do so, subject to the following conditions:
*
*	The above copyright notice and this permission notice shall be included in
*	all copies or substantial portions of the Software.
*
*	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
*	THE SOFTWARE.
*/
package com.ayanray.loaders
{
	import com.ayanray.loaders.handlers.*;
	import com.ayanray.loaders.AssetLoaderTypes;
	import com.ayanray.loaders.AssetLoaderSettings;
	import com.ayanray.utils.getExtension;
	/**
	* The Asset Loader Class allows a Flash/Flex Developers to load multiple types of files<br />
	* with only one interface. This makes life much simpler ;).<br />
	* <br />
	* Currently, AssetLoader supports the following file types: <br />
	* <ul>
	* <li>HTML</li>
	* <li>XML</li>
	* <li>JPG</li>
	* <li>JPEG</li>
	* <li>PNG</li>
	* <li>GIF</li>
	* <li>SWF</li>
	* <li>RAW TEXT(TXT)</li>
	* </ul>
	* <br /><br />
	* Last Updated: July 27th, 2009
	* <br/><br/>
	* **********************************************<br />
	* Change Log<br />
	* ----------------------------------------------<br />
	* [+] 2009-07-27 -> Moved AssetLoader to Google Docs and create Flex Lib Project and auto ASDocs generation
	* [+] 2009-02-14 -> Made a MAJOR BUG FIX that caused the loading to halt when it reaches the end of loading at the same time as adding another item<br />
	* [+] 2009-01-20 -> Added MP3 Support with Sound Class + Fixed Bug while using AssetLoaderTypes.filetype for discrete use of images<br />
	* [+] 2008-22-08 -> Some memory leaks were discovered and soon thereafter fixed<br />
	* 
	*/
	public class AssetLoader
	{
		private static var __queue				:Array;
		private static var __loadingCount		:uint = 0;
		
		/**
		 * As mentioned above, the AssetLoader loads objects according to the URL and the settings object. <br />
		 * <br />
		 * The Settings Object can receive the following:<br />
		 * <ul>
		 * <li>onComplete - when loading is complete, this event is fired</li>
		 * <li>extra - an object that will be passed for each call back - useful for passing an id for example</li>
		 * <li>onInit - call back fired when the loading has commenced</li>
		 * <li>onUpdate - useful for preloaders, in the object that is received with the callback function, the event "e" contains bytesTotal and loadedBytes</li>
		 * <li>onError - for any type of error that prevents it from loading, this callback is called. </li>
		 * <li>... and many more... please consult each handler for specific call backs</li>
		 * <li> Remember that the extra is passed with each call back, so you can really use this to do anything</li>
		 * </ul>
		 * <br /><br />
		 * <b>How to setup your callback function:</b>
		 * <br/>
		 * function handleCallBack( obj:Object ) <br/>
		 * {<br/>
		 * 		trace(obj.asset);<br />
		 * 		trace(obj.extra);<br />
		 * 		trace(obj.e); // Only for onError, onUpdate... or other event dependent callbacks. Consult the individual handlers for more information.<br />
		 * }<br/>
		 * <br/><br/>
		 * <b>Example Usage:</b><br />
		 * new AssetLoader("images.xml", {onComplete: handleXMLFile});<br />
		 * new AssetLoader("imagesXMLGenerator.cgi", {onComplete: handleXMLFile, filetype: AssetLoaderTypes.XML});<br />
		 * // Notice that you can immediately tell AssetLoader what type a file is, so it does not need to figure it out on its own.<br />
		 * var loaderObj:Object = new Object();<br />
		 * loaderObj["image1.jpg"] = {onComplete: handleImageLoad};<br />
		 * loaderObj["image2.jpg"] = {onComplete: handleImageLoad};<br />
		 * loaderObj["image3.jpg"] = {onComplete: handleImageLoad};<br />
		 * new AssetLoader(loaderObj);<br />
		 * <br />
		 * <br />
		 * Tips:
		 * <ol>
		 * <li>If you are loading multiple assets at a time, create an object, and only call the AssetLoader once. This makes it better on performance</li>
		 * <li>Combine multiple AssetLoaders for best use, i.e. use AssetLoader to load an xml list full of images, then loop through the XML to create an object to pass to the AssetLoader again.</li>
		 * </ol>
		 * @param	...args	You can pass either an object containing URLS:String and the SETTINGS:Object in the form of {url1:SettingsObj1, url2:SettingsObj2...} OR you can pass two variables: 1 url and 1 settings object
		 */
		public function AssetLoader ( ...args ) :void  // TODO: CSS ASParser 
		{
			var length:uint = args.length; // faster than accessing array many times
			__queue = __queue || new Array();
			
			if(length == 1 && typeof(args[0]) == "object")
			{
				// Queue is required
				var id:uint = __queue.length;
				
				// Separate into rows and define custom onComplete
				for(var i:String in args[0])
				{
					addToQueue ( i, args[0][i], id );
					id++;
				}
				
				this.startQueue();
				
				return;
			}
			else if ( length == 2 && typeof(args[0]) == "string" && typeof(args[1]) == "object" )
			{
				addToQueue( args[0], args[1], __queue.length );
				this.startQueue();
				return;
			}
			
			var errString:String = "";
			errString += "Arguments Seen: " + length + "\n";
			errString += "Arguments Expected: 1 [object] or 2 [string] [object]" + "\n";
			for(var j:uint=0; j<length; j++)
			{
				errString += "Argument " + j + ": " + typeof(args[j]) + "\n"; 
			}
			if(AssetLoaderSettings.DEBUG > 0) throw new Error("ASSETLOADER: The AssetLoader Tool accepts either just an object, or a string and an object.\n" + errString );
		}
		/**
		* Internal method of actually initializing the loading. 
		*
		* @param url The URL the AssetLoader will begin to load
		* @param settings User defined functions and settings for each individual loader type
		*/
		private function load( url:String , settings:Object ) :void
		{
			// Get Extension of Current File trying to load
			var extension:String = ( settings.filetype != undefined ) ? "" : getExtension( url ).toUpperCase();
			var filetype:String = ( settings.filetype != undefined ) ? settings.filetype : AssetLoaderTypes[extension];
			
			__loadingCount++;
			
			// Check against existing AssetLoaderTypes
			if( filetype == 'IMG' ) 
			{
				new ImageLoader ( url , settings );
			}
			else if ( filetype == "XML" || filetype == "HTML" )
			{
				new XmlLoader ( url, settings );
			}
			else if ( filetype == "TEXT" )
			{
				new TextLoader ( url, settings );
			}
			else if ( filetype == "SOUND" )
			{
				new SoundLoader ( url, settings );
			}
			else if ( filetype == "VIDEO" )
			{
				new VideoLoader ( url, settings );
			}
			// If no type was found, look for the class in the handlers folder
			else 
			{
				var ClassReference:Class = (extension.toUpperCase() + "Loader" ) as Class;
				
				if(ClassReference is ILoader)
           			new ClassReference(url, settings);
				else
				{
					if(settings.updateQueue != null) settings.updateQueue( settings.extra );
					else __loadingCount--;
					var errString:String = "ASSETLOADER: I do not understand the extension '"+ extension +"' in the file '"+ url +"'.\n";
					if(AssetLoaderSettings.DEBUG > 0) throw new Error(errString);
				}
			}
		}
		/**
		* Internal function that adds a url and a settings object to the static queue (which is the same for all instances of the AssetLoader
		*
		* @param	url			The URL that will be loaded.
		* @param	settings	The Settings that will be used for the loaded item.
		* @param	position	The position in the queue that it will be added (over-write)
		*/
		private function addToQueue ( url:String, settings:Object, position:uint ) :void
		{
			// Assign AssetID
			if(settings.extra == undefined) settings.extra = new Object();
			settings.extra.assetid = position;
			
			// Setup CallBack
			settings.updateQueue = function( extra:Object ):void
			{
				__loadingCount--;
				nextInQueue( extra.assetid );
				extra.assetid = null;
				delete extra.assetid;
				delete this;
			};

			// Save Queue
			__queue[position] = {url: url, settings:settings, loading: false};
		}
		/**
		* If the user has passed multiple urls to load, startQueue is called to begin the loading process.
		*/
		private function startQueue() :void
		{
			if (__loadingCount >= AssetLoaderSettings.MAXLOAD && AssetLoaderSettings.MAXLOAD != 0) return;
			
			var length:uint = __queue.length;
			for(var i:uint = 0; i<length; i++) 
			{
				if (__loadingCount >= AssetLoaderSettings.MAXLOAD && AssetLoaderSettings.MAXLOAD != 0) return;
				
				var currentRow:Object = __queue[i]; // array access is slow, so var it.
				if (currentRow.loading == false && currentRow != null) 
				{
					this.load( currentRow.url, currentRow.settings );
					currentRow.loading = true;
				}
			}
		}
		/**
		* An internal callback that tells AssetLoader to begin the next download in the queue
		* 
		* @param 	obj 	A reference to the object that contains the __queue row id
		*/
		private function nextInQueue ( assetid:uint ) :void
		{			
			// Update Queue
			__queue.splice( assetid, 1 );
			__queue.forEach( function(item:*, index:int, arr:Array):void { item.settings.extra.assetid = index; } );
			
			// Check Queue and if there is one that isnt loading, start it.
			var length:uint = __queue.length;
			for(var i:uint = 0; i < length; i++)
			{
				if(__queue[i] == null || __queue[i].loading == true) continue;
				
				if (__loadingCount >= AssetLoaderSettings.MAXLOAD && AssetLoaderSettings.MAXLOAD != 0) return;
				
				// Load one more
				var currentRow:Object = __queue[i];
				this.load( currentRow.url, currentRow.settings );
				currentRow.loading = true;
				return;
			}
		}
		/**
		 * Removes all items awaiting loading
		 */
		public static function stopQueued():void
		{
			// Create Temporary Queue
			var tempQueue:Array = new Array();
			
			// Check Queue and if there is one that isnt loading, start it.
			var length:uint = __queue.length;
			for(var i:uint = 0; i < length; i++)
			{
				if (__queue[i] == null || __queue[i].loading == true) 
				{
					tempQueue[i] = __queue[i];
					continue;
				}
			}
			
			// Replace Queue with Queue of only currently loading items
			__queue = new Array();
			__queue = tempQueue;
			__loadingCount = __queue.length;
		}
	}
}