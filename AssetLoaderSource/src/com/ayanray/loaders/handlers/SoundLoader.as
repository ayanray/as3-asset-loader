﻿/**	Copyright (c) 2007-2008 Ayan Ray | http://www.ayanray.com**	Permission is hereby granted, free of charge, to any person obtaining a copy*	of this software and associated documentation files (the "Software"), to deal*	in the Software without restriction, including without limitation the rights*	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell*	copies of the Software, and to permit persons to whom the Software is*	furnished to do so, subject to the following conditions:**	The above copyright notice and this permission notice shall be included in*	all copies or substantial portions of the Software.**	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR*	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,*	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE*	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER*	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,*	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN*	THE SOFTWARE.**/package com.ayanray.loaders.handlers{	import flash.display.*;	import flash.events.*;	import flash.media.Sound;	import flash.media.SoundLoaderContext;	import flash.net.*;	import flash.system.*;	import flash.utils.*;		import com.ayanray.loaders.handlers.BaseLoader;	import com.ayanray.loaders.AssetLoaderSettings;	/**	* The Sound Loader loads MP3s and WAVS (untested).	*	* Custom Settings/Bound Function for the Sound Loader Class: 	* ------------------------------------	* checkPolicyFile : Allows the loader to check if there is a crossdomain.xml policy before loading the URL	* In order to access the bitmap.data from a URL different from where the SWF is hosted, you must set checkPolicyFile = true.	* 	* bufferTime : Sets the buffer time for loading the sound (allowing playback)	* 	* onID3({event, extra}): Sends the ID3 information for the sound once it is ready	* 	* onInit({event, sound, extra}) : If you are streaming the sound, or want to play it instantly, you can get the sound instantly	*/	public class SoundLoader extends BaseLoader	{			private var sound:Sound;			/**		* Requires URL and Settings with onComplete, everything else is optional		*		* @param url The URL of the image to load		* @param settings 		* 		*/		function SoundLoader( url:String, settings:Object ) :void		{			this.settings = settings;			this.extra = (this.settings.extra != undefined) ? this.settings.extra : new Object();						// Configuration			this.sound = new Sound();			//this.loaderObj = new Loader();			this.listenersObj = this.sound;			            this.startListeners( this.listenersObj );						// Set Timeout			if(AssetLoaderSettings.TIMEOUT != 0) timeout = setTimeout( onTimeout , AssetLoaderSettings.TIMEOUT);						var request:URLRequest = new URLRequest(url);						// Start Loader			try 			{				this.sound.load(request, new SoundLoaderContext(settings.bufferTime || 1000, settings.checkPolicyFile || false));			} 			catch ( e:SecurityError )			{				this.onError( e );			}		}		/**		* Overrides the base loader to allow sending the audio file		*/		public override function onComplete ( e:Event ) : void		{			if(settings.onComplete != undefined)				settings.onComplete( { asset: this.sound, extra: this.extra} );		}		/**		* Overrides the base loader's stop function to allow custom audio load haulting		*/		public override function stop()	:void		{			if(this.sound == null) return;						try 			{        		this.sound.close();				clear();				return;    		} 			catch (e:Error) 			{				// Loader hasn't started so must catch the error								// TODO: Handle the error			}						return;		}		/**		* Clears all variables and listeners		*/		public override function clear() :void		{						// Clear Everything Else            stopListeners(listenersObj);			this.settings = null;			this.extra = null;			this.sound = null;						// Clear Timeout			clearTimeout( this.timeout );		}		/**		* An Open Event occurs when "a load operation starts"        */		public function onOpen( e:Event ):void		{           if(settings.onInit != undefined)				settings.onInit({event:e, sound:this.sound, extra:this.extra});        }		/**		* An ID3 Event occurs when "ID3 data is available for an MP3 sound"		*		*/		public function onID3( e:Event ):void		{			if(settings.onID3 != undefined)				settings.onID3({event:e, extra:this.extra});		}		/**		* An unload event is dispatched when the loaderObj.unload() is called.		*		* For more information, please read:		* http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/LoaderInfo.html#event:unload        */		public function onUnload( e:Event ):void		{           if(settings.onUnload != undefined)				settings.onUnload({event:e, extra:this.extra});        }				public override function startListeners( dispatcher:IEventDispatcher ) :void 		{			super.startListeners( dispatcher );						// Custom			dispatcher.addEventListener(Event.OPEN, 						onOpen);			dispatcher.addEventListener(Event.ID3, 							onID3);			dispatcher.addEventListener(Event.UNLOAD, 						onUnload);		}		public override function stopListeners( dispatcher:IEventDispatcher ) :void 		{			super.stopListeners( dispatcher );						// Custom			dispatcher.removeEventListener(Event.OPEN, 						onOpen);			dispatcher.removeEventListener(Event.ID3, 						onID3);			dispatcher.removeEventListener(Event.UNLOAD, 					onUnload);		}	}}